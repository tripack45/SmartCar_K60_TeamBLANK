function [graph,dir,spd] = alg(img_buffer)
%% Setup
imgrow=size(img_buffer,1);
imgcol=size(img_buffer,2);
IMG_ROWS=imgrow;
IMG_COLS=imgcol;
img_buffer=uint8(img_buffer);
 
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
                    ,'unknownFlag',0 ...
                    ,'lineAlpha'  ,0 ...
                    ,'lineBeta'   ,0 ...
                    ,'circleX'    ,0 ...
                    ,'circleY'    ,0 ...
                   ,'circleRadius',0);

if(length(LBoundary)>length(RBoundary))
    input=LBoundary(1:5:end,:);
else
    input=RBoundary(1:5:end,:);
end


if(size(input,1)>5)
    [isLinear,alpha,beta,x0,y0,radius]=analyzer(double(input));
    
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

%% Control
spd=0;
dir=0;

    
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
    p=0 : 2*pi/100 : 2*pi;
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
            if(exist('x0')&&exist('y0'))
                if(x0+jj>0   && y0+ii>0 ...
                        && x0+jj<150 && y0+ii<150)
                    out(ceil(x0)+jj,ceil(y0)+ii)=9;
                end
            end
        end
    end
end
graph=out;

end





