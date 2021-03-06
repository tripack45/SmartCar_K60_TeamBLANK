function [graph,dir,spd] = alg(img_buffer)
%% Setup
displaySize=200;
imgrow=size(img_buffer,1);
imgcol=size(img_buffer,2);
IMG_ROWS=imgrow;
IMG_COLS=imgcol;
img_buffer=uint8(img_buffer);
beep=@(x)sound(sin(150*(1:floor(8192*x/1000))));
currentState=struct( ...
    'state'       ,0 ...
    ,'img_buffer' ,img_buffer ...
    ,'binarizedImg',[] ...
    ,'LBoundaryX'  ,[] ...
    ,'LBoundaryY'  ,[] ...
    ,'LBoundarySize',0 ...
    ,'RBoundaryX'  ,[] ...
    ,'RBoundaryY'  ,[] ...
    ,'RBoundarySize',0 ...
    ,'fittedBoundary',0 ...
    ,'isUnknown'  ,0 ...
    ,'lineAlpha'  ,0 ...
    ,'lineBeta'   ,0 ...
    ,'lineMSE'    ,0 ...
    ,'circleX'    ,0 ...
    ,'circleY'    ,0 ...
    ,'circleRadius',0 ...
    ,'circleMSE'   ,0 ...
    ,'innerCircleFlag',0 ...
    ,'carPosX'    ,0 ...
    ,'carPosY'    ,0);
try
    %% Visual Algorithms
    
    [LBoundary,RBoundary]=BoundaryDetector(currentState);
    if(isempty(LBoundary))
        currentState.LBoundaryX=[];
        currentState.LBoundaryY=[];
        currentState.LBoundarySize=0;
    else
        currentState.LBoundaryX=LBoundary(:,2);
        currentState.LBoundaryY=LBoundary(:,1);
        currentState.LBoundarySize=size(LBoundary,1);
    end
    if(isempty(RBoundary))
        currentState.RBoundaryX=[];
        currentState.RBoundaryY=[];
        currentState.RBoundarySize=0;
    else
        currentState.RBoundaryX=RBoundary(:,2);
        currentState.RBoundaryY=RBoundary(:,1);
        currentState.RBoundarySize=size(RBoundary,1);
    end
    
    [tCarPosX,tCarPosY]=InversePerspectiveTransform(37,66);
    currentState.carPosX=tCarPosX;
    currentState.carPosY=tCarPosY;

    if(currentState.LBoundarySize<=5 && currentState.RBoundarySize<=5)
        %Not enough points for analyzing
        throw(MException('ANALYZER:UnknownState','No available points'));
    end
    
    if(currentState.LBoundarySize>0)
    [currentState.LBoundaryX,currentState.LBoundaryY] = ...
       InversePerspectiveTransform(double(currentState.LBoundaryX),...
                                   double(currentState.LBoundaryY));
    end
    if(currentState.RBoundarySize>0)
        [currentState.RBoundaryX,currentState.RBoundaryY] = ...
            InversePerspectiveTransform(double(currentState.RBoundaryX),...
                                        double(currentState.RBoundaryY));
    end
    
    %% Analyzing Algorithms
    
    isCrossroad  = IsCrossroad(currentState);
    
    currentState = analyzer(currentState);
    
    %currentState = InnerCircleDetector(currentState);
    currentState.innerCircleFlag = sign(currentState.carPosX-currentState.circleX);
    if (currentState.lineMSE>currentState.circleMSE)
        fprintf('Circle\t');
    else
        fprintf('Line  \t');
    end
     fprintf('lineMSE=%10g\t circleMSE=%10g\n',...
         currentState.lineMSE,currentState.circleMSE);
     fprintf('alpha=%10g\t beta=%g\n',currentState.lineAlpha/100,currentState.lineBeta/100);
    if(isCrossroad)
        currentState.state=3;
    elseif(currentState.lineMSE<=1)
        currentState.state=1;
        if(currentState.fittedBoundary==1)
            currentState.lineBeta=currentState.lineBeta+35;
        elseif(currentState.state==2)
            currentState.lineBeta=currentState.lineBeta-35;
        end
    else
        currentState.state=2;
        d=sqrt((currentState.carPosX-currentState.circleX)^2 ...
               +(currentState.carPosY-currentState.circleY)^2);
        if(d>currentState.circleRadius)
            currentState.circleRadius=currentState.circleRadius+35;
        else
            currentState.circleRadius=currentState.circleRadius-35;
        end
        if(d<25||currentState.circleRadius<25)
            throw(MException('ANALYZER:UnknownState','False fit result'));
        end
    end
    currentState.isUnknown=0;
  %  disp(currentState.state);
catch ME
    switch ME.identifier
        case 'ANALYZER:UnknownState'
            currentState.isUnknown=1;
            disp('unknown');
%             disp(ME.message);
        otherwise
            rethrow(ME);
    end
end

%% Control
persistent internalState;

if(isempty(internalState))
    internalState=struct( ...
        'state',0 ...
        ,'candidateState',0 ...
        ,'candidateStateCounter',0   ...
        ,'crossCounter',0   ...
        );
end


internalState=ControllerUpdate(internalState,currentState);
[spd,dir]=ControllerControl(internalState,currentState);
[dir ,spd]=CircleStateHandler(currentState);

    
%% Output to graph
try
%Draw Boundary
out=zeros(displaySize,displaySize)+57;
for row=1:size(currentState.LBoundaryY);
    out(currentState.LBoundaryY(row),currentState.LBoundaryX(row))=50;%9/44/50/55/65
end
for row=1:size(currentState.RBoundaryY);
    out(currentState.RBoundaryY(row),currentState.RBoundaryX(row))=55;%50/55/65
end

for ii=-1:1
    for jj=-1:1
        out(tCarPosY+jj,tCarPosX+ii)=9;
    end
end

% Draw A line
if(currentState.state==1)
    for jj=0+1:displaySize+1
        temp=ceil(currentState.lineAlpha * jj+currentState.lineBeta);
        if (temp>=0+1 && temp<=displaySize)
            out(jj,temp)=65;
        end
    end
end

% if(currentState.state==2)
    % Draw the correponding circle
    p=0 : 2*pi/300 : 2*pi;
    px=currentState.circleRadius.*cos(p)+currentState.circleY;
    py=currentState.circleRadius.*sin(p)+currentState.circleX;
    
    % for ii=1:length(px)
    %     out(px(ii),py(ii))=44;
    % end
    
    for row=1:length(p)
        if (0+1<px(row)+1 && px(row)<displaySize ...
                && 0+1<py(row) && py(row)<displaySize+1)
            out(ceil(px(row)) ,ceil(py(row)))=65;
        end
    end
    
    % Draw the center of the circle
    for ii=-1:1
        for jj=-1:1
            if(currentState.circleY+jj>0   && currentState.circleX+ii>0 ...
                    && currentState.circleY+jj<displaySize && currentState.circleX+ii<displaySize)
                out(ceil(currentState.circleY)+jj,ceil(currentState.circleX)+ii)=9;
            end
        end
    end
% end


if(currentState.state==3)
    for ii=-1:1
        for jj=-1:1
            out(2+jj,2+ii)=9;
        end
    end
end

if(currentState.innerCircleFlag==-1)
    out([70:73],[1:15])=9;
else
    out([70:73],[135:displaySize])=9;
end
catch
    dir=0;
    spd=0;
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

CONSISTENCY_AWARD=10;
INCONSISTENCY_PUNISHMENT=30;
PROMOTION_REQUIREMENT=30;
MAXIMUM_SCORE=50;
CROSSROAD_INERTIA=10;

if(~currentState.isUnknown)
    
    if(internalState.state==0)
        %First time running
        internalState.state=currentState.state;
        internalState.candidateState=currentState.state;
        internalState.candidateStateCounter=CONSISTENCY_AWARD;
        return;
    end
    
    if(internalState.state==3)
        % if the established situation is crossroad;
        % maintain the state for a period of time
        if(internalState.crossCounter>0)
            internalState.crossCounter=internalState.crossCounter-1;
            %waiting is not over yet
            return;
        end
    end
    
    if(internalState.state == 4)
         persistent str2trnCounter;
         if(isempty(str2trnCounter))
             str2trnCounter=0;
         end
         if(currentState.lineMSE>13)
             str2trnCounter=str2trnCounter+1;
         else
             str2trnCounter=str2trnCounter-1;
         end
         if(str2trnCounter>3)
             internalState.state=2;
             str2trnCounter=0;
         end
         return;
    end
    
    counter=internalState.candidateStateCounter;
    if(currentState.state==internalState.candidateState)
        % The new state agress with candidate state
        % Grant 10 points if it agrees
        counter=counter + CONSISTENCY_AWARD;
        counter=min(counter,MAXIMUM_SCORE); %Cannot Exceeds 80pts
        internalState.candidateStateCounter=counter;
        if(counter>30)
            % 40pts to make the candidate official
            if(internalState.state~=internalState.candidateState)
                if(internalState.state == 1)
                    if(internalState.candidateState == 2)
                        internalState.state = 4;
                        return;
                    end
                end
                internalState.state=internalState.candidateState;
                if(internalState.state==3)
                    internalState.crossCounter=CROSSROAD_INERTIA;
                end
            end
        end
    else
        % 30 pts punishment if it disagress
        internalState.crossCounter=internalState.crossCounter - INCONSISTENCY_PUNISHMENT;
        if(internalState.crossCounter<0)
            % Change Candidate if the points reaches negative
            internalState.candidateState=currentState.state;
            internalState.crossCounter=CONSISTENCY_AWARD;
        end
    end
end
end

function [spd,dir]=ControllerControl(internalState,currentState)
CONTROL_STATE_STRAIGHT =1;
CONTROL_STATE_TURN     =2;
CONTROL_STATE_CROSS    =3;
CONTROL_STATE_STR2TRN  =4;
switch internalState.state
    case CONTROL_STATE_STRAIGHT 
        [dir,spd]=LinearStateHandler(currentState);
        disp('Straight');
    case CONTROL_STATE_TURN
        disp('Turn');
        spd=10;dir=0;
    case CONTROL_STATE_CROSS
         disp('Cross');
        [dir,spd]=CrossroadStateHandler(currentState.img_buffer);
        spd=10;dir=0;
    case CONTROL_STATE_STR2TRN
        disp('STR2TURN');
        spd=10;dir=0;
    otherwise
        spd=10; dir=0;
%         disp('UNKNOW STATE');
end
end


