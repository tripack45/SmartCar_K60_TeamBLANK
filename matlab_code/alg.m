function [graph,dir,spd] = alg(rawframe)
%% Setup
imgrow=size(rawframe,1);
imgcol=size(rawframe,2);
IMG_ROWS=imgrow;
IMG_COLS=imgcol;
%% Boundary Detector

%constants
CONTRAST_THRESHOLD = 8;
BLACK_THRESHOLD=50;
WHITE_THRESHOLD=60;
IMG_BLACK_MID_WIDTH=2;
ABANDON=2;
%input: rawframe
%rawframe=f;
%output: rBoundaryFlag,rBoundary
%        lBoundaryFlag,lBoundary
rBoundaryFlag=false(imgrow,1);
lBoundaryFlag=false(imgrow,1);
rBoundary=zeros(imgrow,1);
lBoundary=zeros(imgrow,1);

LBeginScan = IMG_BLACK_MID_WIDTH+ABANDON;
LEndScan = IMG_COLS / 2 - IMG_BLACK_MID_WIDTH;
RBeginScan = IMG_COLS - IMG_BLACK_MID_WIDTH-ABANDON;
REndScan = IMG_COLS / 2 + IMG_BLACK_MID_WIDTH;
row = 0;
col = 0;
LPredict = LBeginScan;
RPredict = RBeginScan;
BoundaryShift = 2;
LUnCap = 0;
RUnCap = 0;
for row = IMG_ROWS-5:-1:1
    lBoundaryFlag(row) = false;
    rBoundaryFlag(row) = false;
    for col = LBeginScan:LEndScan
      if( rawframe(row,col+IMG_BLACK_MID_WIDTH) > WHITE_THRESHOLD...
              && rawframe(row,col)<BLACK_THRESHOLD)
              LPredict = col;
              lBoundary(row)= col;
              lBoundaryFlag(row) = true;
              LUnCap = 0;
              break;
      end
    end
    LUnCap=LUnCap+1;
    if (LUnCap > 8)
        LUnCap=8;
    end
    LBeginScan = LPredict-BoundaryShift*LUnCap;
    if (LBeginScan < IMG_BLACK_MID_WIDTH + ABANDON) 
        LBeginScan = IMG_BLACK_MID_WIDTH + ABANDON;
    end
    LEndScan = LPredict+BoundaryShift*LUnCap;
    if (LEndScan > IMG_COLS - IMG_BLACK_MID_WIDTH - ABANDON) 
        LEndScan = IMG_COLS - IMG_BLACK_MID_WIDTH - ABANDON;
    end
    for col = RBeginScan:-1:REndScan
      if (rawframe(row,col - IMG_BLACK_MID_WIDTH) > WHITE_THRESHOLD ...
              && rawframe(row,col)<BLACK_THRESHOLD)
              RPredict = col;
              rBoundary(row) = col;
              rBoundaryFlag(row) = true;
              RUnCap = 0;
              break;
      end
    end
    RUnCap=RUnCap+1;
    if (RUnCap > 8) 
        RUnCap=8;
    end
    RBeginScan = RPredict+BoundaryShift*RUnCap;
    if (RBeginScan > IMG_COLS - IMG_BLACK_MID_WIDTH - ABANDON) 
        RBeginScan = IMG_COLS - IMG_BLACK_MID_WIDTH - ABANDON;
    end
    REndScan = RPredict-BoundaryShift*RUnCap;
    if (REndScan < IMG_BLACK_MID_WIDTH + ABANDON) 
        REndScan = IMG_BLACK_MID_WIDTH + ABANDON;
    end
end

%% Guideline Generator
global TrackWidth;
%Output: guideline
guideLine=zeros(imgrow,1);
for row=imgrow:-1:1
    if lBoundaryFlag(row) && rBoundary(row)
        t= lBoundary(row)+rBoundary(row);
        pos=t;
        guideLine(row)=floor(t/2);
        %break;
    elseif lBoundaryFlag(row)
        t = 2 * lBoundary(row) + TrackWidth(row);
        pos=t;
        guideLine(row)=floor(t/2);
        %break;
    elseif rBoundaryFlag(row)
        t = 2 * rBoundary(row) - TrackWidth(row);
        pos=t;
        guideLine(row)=floor(t/2);
        %break;
    end 
end
pos=pos-imgcol;

%% Servo PID
DIR_P=20;
DIR_D=100;
PID_SENSITIVITY=1;
global LastDirection;
s16Tmp=DIR_P*pos+DIR_D*(pos-LastDirection)/10;
LastDirection=pos;
dir=s16Tmp/(PID_SENSITIVITY);
  

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
graph=out;
spd=0;

end

