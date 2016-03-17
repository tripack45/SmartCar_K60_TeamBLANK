function [graph,dir,spd,special_case] = alg(img_buffer)
%% Setup
imgrow=size(img_buffer,1);
imgcol=size(img_buffer,2);
%img_buffer=CArray(img_buffer);
IMG_ROWS=imgrow;
IMG_COLS=imgcol;
try
 %% Boundary Detection
 
    %constants
    lBoundary=zeros(1,2);
    ABANDON=2;
    MATLABZERO=1;
    LBeginScan =ABANDON+MATLABZERO+1;
    LEndScan = IMG_COLS / 2+MATLABZERO;
    BLACK_THRESHOLD=50;
    WHITE_THRESHOLD=60;
    %0 is left; 1 is up; 2 is right; 3 is down;
    %input: rawframe
    %rawframe=f;
    %output: rBoundary
    %        lBoundary
    
    col = 0;
    LCap = 0;
    row =MATLABZERO+ IMG_ROWS-8;
    for col = LBeginScan:LEndScan
        if( img_buffer(row,col) > WHITE_THRESHOLD...
                && img_buffer(row,col-1)<BLACK_THRESHOLD)
            lBoundary(MATLABZERO,:)= [row col];
            LCap=1;
            break;
        end
    end
    if (LCap)
        LNum=MATLABZERO+1;
    else
        col= LBeginScan;
        LNum=MATLABZERO;
    end
    lastDirection=1;
    moveable=1;
    movestep=0;
    while (moveable && row<MATLABZERO+IMG_ROWS-3 && movestep<300 )
        %judge
        if ((img_buffer(row,col+1)<BLACK_THRESHOLD...
                || img_buffer(row,col-1)<BLACK_THRESHOLD...
                || img_buffer(row+1,col)<BLACK_THRESHOLD...
                || img_buffer(row-1,col)<BLACK_THRESHOLD)...
                &&(img_buffer(row,col+1)> WHITE_THRESHOLD...
                || img_buffer(row,col-1)> WHITE_THRESHOLD...
                || img_buffer(row+1,col)> WHITE_THRESHOLD...
                || img_buffer(row-1,col)> WHITE_THRESHOLD)...
                )%need improvement
            lBoundary(LNum,:)=[row col];
            LNum=LNum+1;
        end
        %move
        moveable=0;
        for step=1:4
            switch mod(lastDirection+step+2,4);
                case 0
                    if (col>MATLABZERO+ABANDON+1 && img_buffer(row,col-1)> WHITE_THRESHOLD)
                        moveable=1;
                        col=col-1;
                        lastDirection=0;
                    end
                case 1
                    if (row>MATLABZERO+1 &&img_buffer(row-1,col)> WHITE_THRESHOLD)
                        moveable=1;
                        row=row-1;
                        lastDirection=1;
                    end
                case 2
                    if (col<MATLABZERO+IMG_COLS-ABANDON-2 &&img_buffer(row,col+1)> WHITE_THRESHOLD)
                        moveable=1;
                        col=col+1;
                        lastDirection=2;
                    end
                case 3
                    if (row<MATLABZERO+IMG_ROWS-1 &&img_buffer(row+1,col)> WHITE_THRESHOLD)
                        moveable=1;
                        row=row+1;
                        lastDirection=3;
                    end
            end
            if (moveable)
                break;
            end
        end
        movestep=movestep+1;
    end
    
    %% Inverse Transerfering
    scale=70/50; % 70pts=50cm
    zrow=35; zcol=39; % zero on graph: (35,39);
    input=lBoundary;
    c1=-0.0104; c2=0.817;
    t=@(y)y/(c1*y+c2);
    it=@(y)c2*y/(1-c1*y);
    inv_trans=@(y) it(y-zrow)*scale+zrow;
    
    s50=@(x) 38+(70-38)/51*(x-3);
    
    result=[];
    if(LNum>5)
        for row=1:length(input)
            %result(row,1)=ceil(input(row,1));
            result(row,1)=ceil(inv_trans(input(row,1)));
            %result(row,2)=ceil(input(row,2));
            result(row,2)=ceil( (input(row,2)-zcol)/s50(input(row,1))*70+zcol);
        end
    end
    
    %% Output to graph
    out=zeros(150,150)+57;
    %lBoundary=lBoundary+1;
    %rBoundary=rBoundary+1;
    %guideLine=guideLine+1;
    for row=1:length(result);
        out(result(row,1)+50,result(row,2)+30)=50;%50/55/65
    end
    graph=out;
    spd=0;
    dir=0;
    special_case.CaseNumer=0;
    
catch exception
    disp(exception);
    rethrow(exception);
    graph=zeros(imgrow,imgcol);
    spd=0;
    dir=0;
end

end

