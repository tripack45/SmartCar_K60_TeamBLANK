function [graph] = alg(img_buffer)
%% Setup
imgrow=size(img_buffer,1);
imgcol=size(img_buffer,2);
%img_buffer=CArray(img_buffer);
IMG_ROWS=imgrow;
IMG_COLS=imgcol;
try
 %% Boundary Detection
 
    %constants
    lBoundary=[];
    RBoundary=[];
    ABANDON=2;
    MATLABZERO=1;
    LBeginScan =ABANDON+MATLABZERO+1;
    LEndScan = IMG_COLS / 2+MATLABZERO;
    RBeginScan =IMG_COLS-ABANDON-1+MATLABZERO-1;
    REndScan = IMG_COLS / 2+MATLABZERO;
    BLACK_THRESHOLD=50;
    WHITE_THRESHOLD=60;
    %0 is left; 1 is up; 2 is right; 3 is down;
    %input: rawframe
    %rawframe=f;
    %output: rBoundary
    %        lBoundary

    LCap = 0;
    RCap = 0;
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
    while (moveable && row>MATLABZERO+2 && col<MATLABZERO+IMG_COLS-ABANDON-3 && movestep<300 )
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
            end
            if (moveable)
                break;
            end
        end
        movestep=movestep+1;
    end

    %right
    %0 is left; 1 is up; 2 is right; 3 is down;
    row =MATLABZERO+ IMG_ROWS-8;
    for col = RBeginScan:-1:REndScan
        if( img_buffer(row,col) > WHITE_THRESHOLD...
                && img_buffer(row,col+1)<BLACK_THRESHOLD)
            RBoundary(MATLABZERO,:)= [row col];
            RCap=1;
            break;
        end
    end
    if (RCap)
        row=RBoundary(MATLABZERO,1);
        RNum=MATLABZERO+1;
    else
        row=MATLABZERO+IMG_ROWS-8;
        col= RBeginScan;
        RNum=MATLABZERO;
    end
    lastDirection=1;
    moveable=1;
    movestep=0;
    while (moveable &&row>MATLABZERO+2 && col>MATLABZERO+ABANDON+2  && movestep<300 )
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
            RBoundary(RNum,:)=[row col];
            RNum=RNum+1;
        end
        %move
        moveable=0;
        for step=1:4
            switch mod(lastDirection-step+6,4);
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
    
    Lresult=[];
    if(LNum>10)
        for row=1:length(input)
            %result(row,1)=ceil(input(row,1));
            Lresult(row,1)=ceil(inv_trans(input(row,1)));
            %result(row,2)=ceil(input(row,2));
            Lresult(row,2)=ceil( (input(row,2)-zcol)/s50(input(row,1))*70+zcol);
        end
    end
    Rresult=[];
    input=RBoundary;
    if(RNum>5)
        for row=1:length(input)
            %result(row,1)=ceil(input(row,1));
            Rresult(row,1)=ceil(inv_trans(input(row,1)));
            %result(row,2)=ceil(input(row,2));
            Rresult(row,2)=ceil( (input(row,2)-zcol)/s50(input(row,1))*70+zcol);
        end
    end
    
    %% Output to graph
    out=zeros(150,150)+57;
    %lBoundary=lBoundary+1;
    %rBoundary=rBoundary+1;
    %guideLine=guideLine+1;
    for row=1:length(Lresult);
        out(Lresult(row,1)+50,Lresult(row,2)+30)=50;%50/55/65
    end
    for row=1:length(Rresult);
        out(Rresult(row,1)+50,Rresult(row,2)+30)=55;%50/55/65
    end
    if (length(Lresult)>10)
        x=Lresult(1:5:length(Lresult),1);y=Lresult(1:5:length(Lresult),2);
        A=[sum(x.*x) sum(y.*x) sum(x);
            sum(x.*y) sum(y.*y) sum(y);
            sum(x) sum(y) sum(x./x)];
        B=[-sum(x.^3+y.^2.*x); -sum(y.^3+x.^2.*y); -sum(y.^2+x.^2)];
        C=A\B;
        x0=-C(1)/2;
        y0=-C(2)/2;
        r=sqrt(-C(3)+x0^2+y0^2);
        p=[0:2*pi/100:2*pi];
        xx=r*cos(p)+x0;
        yy=r.*sin(p)+y0;
        for row=1:length(xx)
            if (0<xx(row)&& xx(row)<150&&0<yy(row)&&yy(row)<150)
                out(floor(xx(row))+1 ,floor(yy(row))+1)=65;
            end
        end
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

