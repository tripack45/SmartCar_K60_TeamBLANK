function [graph,dir,spd,special_case] = alg(img_buffer,TrackWidth)
%% Setup
imgrow=size(img_buffer,1);
imgcol=size(img_buffer,2);
IMG_ROWS=imgrow;
IMG_COLS=imgcol;
try
    
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
            if( img_buffer(row,col+IMG_BLACK_MID_WIDTH) > WHITE_THRESHOLD...
                    && img_buffer(row,col)<BLACK_THRESHOLD)
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
            if (img_buffer(row,col - IMG_BLACK_MID_WIDTH) > WHITE_THRESHOLD ...
                    && img_buffer(row,col)<BLACK_THRESHOLD)
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
    
    %% Special Case Handler
    RT_TURN_THRESHOLD=8;
    RT_TURN_LINETHRESHOLD=8;
    special_case=struct('CaseFound',false,...
                        'CaseNumber',0);
    lcounter=0;
    for(row=1:floor(imgrow/2))
       counter=0;
       for(col=1:imgcol)
           if(img_buffer(row,col)>WHITE_THRESHOLD)
                counter=counter+1;
           end
       end
       if(counter<RT_TURN_THRESHOLD);
               lcounter=lcounter+1;
       end
       if(lcounter>RT_TURN_LINETHRESHOLD)
            special_case.CaseFound=true;
            special_case.CaseNumber=1;
            disp('RT_FOUND');
            break;
       end
    end
    
    %% Guideline Generator
    %Output: guideline
    guideLine=zeros(imgrow,1);
    for row=imgrow-5:-1:1
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
        else
            pos=0;
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
    lBoundary=lBoundary+1;
    rBoundary=rBoundary+1;
    guideLine=guideLine+1;
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
    
catch exception
    disp(exception);
    %rethrow(exception);
    graph=zeros(imgrow,imgcol);
    spd=0;
    dir=0;
end

end

