function [graph,dir,spd] = alg(img_buffer)
%% Setup
imgrow=size(img_buffer,1);
imgcol=size(img_buffer,2);
IMG_ROWS=imgrow;
IMG_COLS=imgcol;
img_buffer=uint8(img_buffer);
beep=@(x)sound(sin(150*(1:floor(8192*x/1000))));

%% Visual Algorithms
[LBoundary,RBoundary]=BoundaryDetector(img_buffer);

if(length(LBoundary)>5)
    [LBoundary(:,2),LBoundary(:,1)] = ...
        InversePerspectiveTransform(double(LBoundary(:,2)),...
                                    double(LBoundary(:,1)));
end
if(length(RBoundary)>5)
    [RBoundary(:,2),RBoundary(:,1)] = ...
        InversePerspectiveTransform(double(RBoundary(:,2)),...
                                    double(RBoundary(:,1)));
end
[tCarPosX,tCarPosY]=InversePerspectiveTransform(30,65);

%% Analyzing Algorithms
currentState=struct( 'state',      0 ...
                    ,'isUnknown'  ,0 ...
                    ,'lineAlpha'  ,0 ...
                    ,'lineBeta'   ,0 ...
                    ,'circleX'    ,0 ...
                    ,'circleY'    ,0 ...
                   ,'circleRadius',0 ...
                    ,'carPosX'    ,tCarPosX ...
                    ,'carPosY'    ,tCarPosY);

if(length(LBoundary)>length(RBoundary))
    input=LBoundary(1:5:end,:);
else
    input=RBoundary(1:5:end,:);
end
input=double(input);


if(size(input,1)>5)
    [isLinear,alpha,beta,x0,y0,radius]=analyzer(input);
    
    if(isLinear)
        currentState.state=1;
    else
        currentState.state=2;
    end
    currentState.lineAlpha      = alpha;
    currentState.lineBeta       = beta;
    currentState.circleX        = x0;
    currentState.circleY        = y0;
    currentState.circleRadius   = radius;
end

isCrossroad=0;
if(size(input,1)>5)
    isCrossroad = IsCrossroad(input(:,2),input(:,1),size(input,1));
end

if(isCrossroad)
   currentState.state=3;
end

%% Control


persistent internalState;
if(isempty(internalState))
    clear('internalState')
end
if(~exist('internalState','var'))
    internalState=struct('state',0 ...
                         ,'lastFrameState',0 ...
                         ,'stateCounter',0);
end
internalState=ControllerUpdate(internalState,currentState);
[spd,dir]=ControllerControl(internalState,currentState);
    
%% Output to graph

%Draw Boundary
out=zeros(150,150)+57;
for row=1:size(LBoundary,1);
    out(LBoundary(row,1),LBoundary(row,2))=50;%9/44/50/55/65
end
for row=1:size(RBoundary,1);
    out(RBoundary(row,1),RBoundary(row,2))=55;%50/55/65
end

for ii=-1:1
    for jj=-1:1
        out(tCarPosY+jj,tCarPosX+ii)=9;
    end
end

for i=1:size(input,1)
    out(input(i,1),input(i,2))=44;
end

% Draw A line
if(currentState.state==1)
    for jj=0+1:150+1
        temp=ceil(currentState.lineAlpha * jj+currentState.lineBeta);
        if (temp>=0+1 && temp<=150)
            out(jj,temp)=65;
        end
    end
end

if(currentState.state==2)
    % Draw the correponding circle
    p=0 : 2*pi/300 : 2*pi;
    px=currentState.circleRadius.*cos(p)+x0;
    py=currentState.circleRadius.*sin(p)+y0;
    
    % for ii=1:length(px)
    %     out(px(ii),py(ii))=44;
    % end
    
    for row=1:length(p)
        if (0+1<px(row)+1 && px(row)<150 ...
                && 0+1<py(row) && py(row)<150+1)
            out(ceil(px(row)) ,ceil(py(row)))=65;
        end
    end
    
    % Draw the center of the circle
    for ii=-1:1
        for jj=-1:1
            if(x0+jj>0   && y0+ii>0 ...
                    && x0+jj<150 && y0+ii<150)
                out(ceil(x0)+jj,ceil(y0)+ii)=9;
            end
        end
    end
end


if(isCrossroad)
    for ii=-1:1
        for jj=-1:1
            out(2+jj,2+ii)=9;
        end
    end
end

%draw currdir currspd
out=SpdDirDrawer(dir,spd, out);
graph=out;



end



function out=SpdDirDrawer(currdir ,currspd, out)
try
    if 80+currdir/10<=0
        currdir=-790;
    end
    if currdir>0
        for (i=80:80+currdir/10)
            for(j=105:115)
                out(j,i)=45;
            end
        end
    else
        for (i=80:-1:80+currdir/10)
            for(j=105:115)
                out(j,i)=45;
            end
        end
    end
    
    if currspd>0
        for (i=80:80+currspd*2)
            for(j=115:125)
                out(j,i)=50;
            end
        end
    else
        for (i=80:-1:80+currspd*2)
            for(j=115:125)
                out(j,i)=50;
            end
        end
    end
catch
end
end

function internalState=ControllerUpdate(internalState,currentState)
if(~currentState.isUnknown)
    if(internalState.state==0)
        %First time running
        internalState.state=currentState.state;
        internalState.stateCounter=internalState.stateCounter+1;
        internalState.lastFrameState=internalState.stateCounter;
        return;
    end
    %instantSwithing
    internalState.state=currentState.state;
    internalState.stateCounter=internalState.stateCounter+1;
    internalState.lastFrameState=internalState.stateCounter;
end
end

function [spd,dir]=ControllerControl(internalState,currentState)
CONTROL_STATE_STRAIGHT =1;
CONTROL_STATE_TURN     =2;
CONTROL_STATE_CROSS    =3;
CONTROL_STATE_STR2TRN  =4;
switch internalState.state
    case CONTROL_STATE_STRAIGHT 
        [spd,dir]=LinearStateHandler(currentState);
    case CONTROL_STATE_TURN
        spd=10;dir=0;
    case CONTROL_STATE_CROSS    
        spd=10;dir=0;
    case CONTROL_STATE_STR2TRN
        spd=10;dir=0;
    otherwise
        spd=10; dir=0;
        disp('UNKNOW STATE');
end
end


