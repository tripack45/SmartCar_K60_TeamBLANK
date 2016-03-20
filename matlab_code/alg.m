function [graph,dir,spd] = alg(img_buffer)
%% Setup
imgrow=size(img_buffer,1);
imgcol=size(img_buffer,2);
%img_buffer=CArray(img_buffer);
IMG_ROWS=imgrow;
IMG_COLS=imgcol;
try
 %% Boundary Detection
    %constants
    Boundary=[];
    LBoundary=[];
    RBoundary=[];
    ABANDON=3;
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
    col = 0;
    Cap = 0;
    row =MATLABZERO+ IMG_ROWS-6;
    for col = LBeginScan:LEndScan
        if( img_buffer(row,col) > WHITE_THRESHOLD...
                && img_buffer(row,col-1)<BLACK_THRESHOLD)
            Boundary(MATLABZERO,:)= [row col];
            Cap=1;
            break;
        end
    end
    if (Cap)
        Num=MATLABZERO+1;
    else
        col= LBeginScan;
        Num=MATLABZERO;
    end
    lastDirection=1;
    moveable=1;
    movestep=0;
    counter=0;
    BFlag=zeros(4,1);
    BFFlag=1;
    oldNum=1;
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
            Boundary(Num,:)=[row col];
            Num=Num+1;
            counter=0;
        else
            counter=counter+1;
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
        if (Num~=oldNum&&(counter>10||row==MATLABZERO+IMG_ROWS-3))
            BFlag(BFFlag)=Num;
            oldNum=Num;
            BFFlag=BFFlag+1;
        end
    end
    if (~isempty(Boundary))
        if(BFlag(4))
            LBoundary=Boundary(1:BFlag(2)-1,:);
            RBoundary=Boundary(BFlag(2):end,:);
        elseif(BFlag(3))
            x=1;
        elseif (BFlag(2))
            LBoundary=Boundary(1:BFlag(1)-1,:);
            RBoundary=Boundary(BFlag(1):end,:);
        elseif (BFlag(1))
            if (Boundary(1,2)>IMG_COLS-10||img_buffer(Boundary(1,1),Boundary(1,2)+10)<WHITE_THRESHOLD)
                RBoundary=Boundary(:,:);
            else
                LBoundary=Boundary(:,:);
            end
        end
    end
    
    %% Inverse Transerfering
    scale=70/50; % 70pts=50cm
    zrow=35; zcol=39; % zero on graph: (35,39);
    lInput=LBoundary;
    rInput=RBoundary;
    c1=-0.0104; c2=0.817;
    t=@(y)y/(c1*y+c2);
    it=@(y)c2*y/(1-c1*y);
    inv_trans=@(y) it(y-zrow)*scale+zrow;
    
    s50=@(x) 38+(70-38)/51*(x-3);
    
    lResult=[];
    if(size(lInput,1)>5)
        for row=1:length(lInput)
            %result(row,1)=ceil(input(row,1));
            lResult(row,1)=ceil(inv_trans(lInput(row,1)));
            %result(row,2)=ceil(input(row,2));
            lResult(row,2)=ceil( (lInput(row,2)-zcol)/s50(lInput(row,1))*70+zcol);
        end
    end
    
    rResult=[];
    if(size(rInput,1)>5)
        for row=1:length(rInput)
            %result(row,1)=ceil(input(row,1));
            rResult(row,1)=ceil(inv_trans(rInput(row,1)));
            %result(row,2)=ceil(input(row,2));
            rResult(row,2)=ceil( (rInput(row,2)-zcol)/s50(rInput(row,1))*70+zcol);
        end
    end
    
    carPosY=65;
    carPosX=30;
    tCarPosY=ceil(inv_trans(carPosY));
    tCarPosX=ceil( (carPosX-zcol)/ s50(carPosY) *70+zcol);
    
    %% Output to graph
    out=zeros(150,150)+57;
    %lBoundary=lBoundary+1;
    %rBoundary=rBoundary+1;
    %guideLine=guideLine+1;
    for row=1:length(lResult);
        out(lResult(row,1)+50,lResult(row,2)+30)=50;%9/44/50/55/65
    end
    for row=1:length(rResult);
        out(rResult(row,1)+50,rResult(row,2)+30)=55;%50/55/65
    end
    
    for ii=-1:1
        for jj=-1:1
            out(tCarPosY+jj+50,tCarPosX+ii+30)=9;
        end
    end

    
    %% Calculating the corresponding circle
    if(length(lResult)>length(rResult))
        input=lResult;
        dr=35;
    else
        input=rResult;
        dr=-35;
    end
    
    if (length(input)>10)
        x=input(1:5:length(input),1);
        y=input(1:5:length(input),2);
        A=[sum(x.*x) sum(y.*x) sum(x);
            sum(x.*y) sum(y.*y) sum(y);
            sum(x) sum(y) sum(x./x)];
        B=[-sum(x.^3+y.^2.*x); -sum(y.^3+x.^2.*y); -sum(y.^2+x.^2)];
        C=A\B;
        x0=-C(1)/2;
        y0=-C(2)/2;
        r=sqrt(-C(3)+x0^2+y0^2);
        p=[0:2*pi/100:2*pi];
        r=r+dr;
        xx=r*cos(p)+x0;
        yy=r.*sin(p)+y0;
        for ii=1:length(x)
            out(x(ii)+50,y(ii)+30)=44;
        end
        for row=1:length(xx)
            if (0-50+1<xx(row)+1 && xx(row)<150-50+1 ...
                && 0-30+1<yy(row) && yy(row)<150-30+1)
                out(ceil(xx(row))+50 ,ceil(yy(row))+30)=65;
            end
        end
    end
    graph=out;
    spd=0;
    dir=0;
    
catch exception
    disp(exception);
    rethrow(exception);
    graph=zeros(imgrow,imgcol);
    spd=0;
    dir=0;
end

end

