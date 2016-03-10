%% Setups
imgrow=67;
imgcol=77;
h=figure();
im=image(ones(imgrow,imgcol));
colormap(h,colorcube);
axis equal;
caxis manual;
caxis([0,255]);

text(0,-1,'DIR:','Color','Black');
text(20,-1,'SPD:','Color','Black');
t1=text( 7,-1,'000','Color','Black');
t2=text( 27,-1,'000','Color','Black');

TrackWidth=z;

f=frame(:,:,820);

%% Boundary Detector

%constants
CONTRAST_THRESHOLD = 8;
BLACK_THRESHOLD=60;
%input: rawframe
rawframe=f;
%output: rBoundaryFlag,rBoundary
%        lBoundaryFlag,lBoundary
rBoundaryFlag=false(imgrow,1);
lBoundaryFlag=false(imgrow,1);
rBoundary=zeros(imgrow,1);
lBoundary=zeros(imgrow,1);

for row=1:imgrow
    for col=1+2:imgcol-2
        if( rawframe(row,col+2) - rawframe(row,col-1)> CONTRAST_THRESHOLD ...
            ...    %&& rawframe(row,col-2)< BLACK_THRESHOLD ...
          )
            lBoundaryFlag(row)=true;
            lBoundary(row)= col;
            break;
        end
    end
    for col=imgcol-2:-1:1+2
        if( rawframe(row,col-2) - rawframe(row,col+1)> CONTRAST_THRESHOLD ...
             ...    %&& rawframe(row,col+2)< BLACK_THRESHOLD ...
            )
            rBoundaryFlag(row)=true;
            rBoundary(row)= col;
            break;
        end
    end
end

%% Guideline Generator
%Output: guideline
guideLine=zeros(imgrow,1);
for row=imgrow:-1:1
    if lBoundaryFlag(row) && rBoundary(row)
        t= lBoundary(row)+rBoundary(row);
        pos=t;
        guideLine(row)=floor(t/2);
        break;
    elseif lBoundaryFlag(row)
        t = 2 * lBoundary(row) - TrackWidth(row);
        pos=t;
        guideLine(row)=floor(t/2);
        break;
    elseif rBoundaryFlag(row)
        t = 2 * rBoundary(row) + TrackWidth(row);
        pos=t;
        guideLine(row)=floor(t/2);
        break;
    end 
end
pos=pos-imgcol;

%% Output to graph
out=zeros(imgrow,imgcol)+57;
for row=1:imgrow
    if lBoundaryFlag(row)
        out(row,lBoundary(row))=50;
    end
    if rBoundaryFlag(row)
        out(row,rBoundary(row))=55;
    end
    if ~guideLine(row)==0
        out(row,guideLine(row))=65; 
    end
end
set(im,'CData',out);
spd=10;
dir=20;
set(t1,'String',num2str(dir));
set(t2,'String',num2str(spd));
drawnow nocallbacks;