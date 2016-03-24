function [graph,dir,spd] = alg(img_buffer)
%% Setup
global endPoint;
imgrow=size(img_buffer,1);
imgcol=size(img_buffer,2);
%img_buffer=CArray(img_buffer);
IMG_ROWS=imgrow;
IMG_COLS=imgcol;
img_buffer=uint8(img_buffer);
 
 %% Boundary Detection
    %constant
    TRUE              = int32(1);
    FALSE             = int32(0);
    DIS_ROW           = uint8(4);
    DIS_COL           = uint8(3);
    MZ                = uint8(1);
    LBEGIN_SCAN       = uint8(DIS_COL);
    LEND_SCAN         = uint8(IMG_COLS / 2);
    WHITE_THRES       = int32(60);
    START_LINE_HEIGHT = uint8(10);
    BOUNDARY_LENGTH   = int32(300);
    
    DIR_LEFT          = int32(0);
    DIR_UP            = int32(1);
    DIR_RIGHT         = int32(2);
    DIR_DOWN          = int32(3);
    %input: rawframe
    %rawframe=f;
    %output: rBoundary
    %        lBoundary
    Boundary=uint8(zeros(BOUNDARY_LENGTH,2)); 
    LBoundary=uint8(zeros(BOUNDARY_LENGTH,2)); 
    RBoundary=uint8(zeros(BOUNDARY_LENGTH,2)); 
    endPoint=uint8(zeros(8,1));
    row  = uint8(0);
    col  = uint8(0);
    step = uint8(0);
    currBoundaryPtr = uint8(0);
    isCaptured = uint8(FALSE);
    for (row = IMG_ROWS - 1 - DIS_ROW - 1: -1 :...
            IMG_ROWS - 1 - DIS_ROW - 1 - START_LINE_HEIGHT) 
        for (col = LBEGIN_SCAN : LEND_SCAN)
            if (img_buffer(MZ + row, MZ + col) > WHITE_THRES...
                    && img_buffer(MZ + row, MZ + col - 1) < WHITE_THRES...
                    && img_buffer(MZ + row, MZ + col + 1) > WHITE_THRES)
                Boundary(MZ + 0, MZ + 0) = row;
                Boundary(MZ + 0, MZ + 1) = col;
                isCaptured = TRUE;
                break;
            end
        end
        if (isCaptured)
            break;
        end
    end
    if (isCaptured)
        row = Boundary(MZ + 0, MZ + 0);
        col = Boundary(MZ + 0, MZ + 1);
        currBoundaryPtr = currBoundaryPtr + 1;
    else
        row = IMG_ROWS - 1 - DIS_ROW - 1 ;
        col = LBEGIN_SCAN;
    end
    
    lastDirection         = uint8(DIR_UP);   
    isMoveable            = uint8(TRUE);
    stepCounter           = uint8(0);
    uncapturedStepCounter = uint8(0);
    sectionTail           = uint8(zeros(5,1));
    sectionHead           = uint8(zeros(5,1));
    sectionCounter        = uint8(1);
    while (isMoveable && row < IMG_ROWS - DIS_ROW -1 && stepCounter < 255)
        
        %move
        isMoveable = FALSE;
        for (step = 0 : 3)
            switch mod(lastDirection + step + 3 , 4);
                case 0
                    if (col > DIS_COL && ...
                        img_buffer(MZ + row, MZ + col - 1) > WHITE_THRES)
                        isMoveable = 1;
                        col = col - 1;
                        lastDirection = 0;
                    end
                case 1
                    if (row > 1 && ...
                        img_buffer(MZ + row - 1, MZ + col) > WHITE_THRES)
                        isMoveable = 1;
                        row = row - 1;
                        lastDirection = 1;
                    end
                case 2
                    if (col < IMG_COLS - DIS_COL - 1 && ...
                        img_buffer(MZ + row, MZ + col + 1)> WHITE_THRES)
                        isMoveable = 1;
                        col = col + 1;
                        lastDirection = 2;
                    end
                case 3
                    if (row < IMG_ROWS - DIS_ROW && ...
                        img_buffer(MZ + row + 1, MZ + col)> WHITE_THRES)
                        isMoveable = 1;
                        row = row + 1;
                        lastDirection = 3;
                    end
            end
            if (isMoveable)
                break;
            end
        end
        
        %{
        % yaotui's walking alg
        moveDirX=[-1,0,1,0];
        moveDirY=[0,-1,0,1];
        
        isMoveable = FALSE;
        for( step = 0 : 3 )
           nextDir=mod(lastDirection + step + 3 , 4);
           if(img_buffer(MZ+ row+ moveDirY(MZ + nextDir), ...
                   MZ+col+moveDirX(MZ + nextDir))> WHITE_THRES ...
               && col > DIS_COL && col < IMG_COLS - DIS_COL - 1 ...
               && row > 1       && row < IMG_ROWS - DIS_ROW ...
               )
               isMoveable       = TRUE;
               col              = col + moveDirX(MZ + nextDir);
               row              = row + moveDirY(MZ + nextDir);
               lastDirection    = nextDir;
               break;
           end
        end
        %}
        
        stepCounter = stepCounter + 1;  
        
        %find out boundary
        if (      (img_buffer(MZ + row    , MZ + col + 1) < WHITE_THRES...
                || img_buffer(MZ + row    , MZ + col - 1) < WHITE_THRES...
                || img_buffer(MZ + row + 1, MZ + col    ) < WHITE_THRES...
                || img_buffer(MZ + row - 1, MZ + col    ) < WHITE_THRES)...
                &&(img_buffer(MZ + row    , MZ + col + 1) > WHITE_THRES...
                || img_buffer(MZ + row    , MZ + col - 1) > WHITE_THRES...
                || img_buffer(MZ + row + 1, MZ + col    ) > WHITE_THRES...
                || img_buffer(MZ + row - 1, MZ + col    ) > WHITE_THRES)...
                )%need improvement
            Boundary(MZ + currBoundaryPtr, MZ + 0) = row;
            Boundary(MZ + currBoundaryPtr, MZ + 1) = col;
            currBoundaryPtr = currBoundaryPtr + 1;
            uncapturedStepCounter = 0;
        else
            uncapturedStepCounter = uncapturedStepCounter + 1;
        end
        
        %divide the boundary
        if ( sectionHead(MZ + sectionCounter - 1) ~= currBoundaryPtr ...
                &&(((col ==  IMG_COLS - DIS_COL - 1  || row == 1 ...
                || col == DIS_COL ) ...
                && uncapturedStepCounter > 3) ...
                || ~(isMoveable && row < IMG_ROWS - DIS_ROW -1 ...
                && stepCounter < 255)) )
            if (currBoundaryPtr -1 ...
                    - sectionHead(MZ + sectionCounter - 1) > 0 ...
                    && currBoundaryPtr -1 ...
                    - sectionHead(MZ + sectionCounter - 1) < 20)
                sectionHead(MZ + sectionCounter - 1) = currBoundaryPtr;
            else
                sectionTail(MZ + sectionCounter - 1) =...
                    currBoundaryPtr - 1;
                endPoint(MZ + 2 * (sectionCounter - 1)) =...
                    guideLoc(Boundary(MZ + sectionTail(MZ + sectionCounter - 1),:));
                endPoint(MZ + 2 * (sectionCounter - 1)+1) =...
                    guideLoc(Boundary(MZ + sectionHead(MZ + sectionCounter - 1),:));
                sectionCounter = sectionCounter +1;
                sectionHead(MZ + sectionCounter - 1) = currBoundaryPtr;
            end
        end
        
    end

  % code for drawing convinience not for c  
    
    if (~isempty(Boundary))
        switch sectionCounter
            case 5
            LBoundary = Boundary(MZ + sectionHead(1) :...
                MZ + sectionTail(2),:);
            RBoundary = Boundary(MZ + sectionHead(2) : ...
                MZ + sectionTail(4), : );
            case 4
            endPoint(5:6)=0;
            LBoundary=Boundary(MZ + sectionHead(1) : MZ + sectionTail(1),:);
            RBoundary=Boundary(MZ + sectionHead(2) : MZ + sectionTail(2),:);
            case 3
            LBoundary=Boundary(MZ + sectionHead(1) : MZ + sectionTail(1),:);
            RBoundary=Boundary(MZ + sectionHead(2) : MZ + sectionTail(2),:);
            case 2
            if (Boundary(MZ + sectionHead(1), MZ + 0)<Boundary(MZ + sectionTail(1),MZ + 0))
                RBoundary=Boundary(MZ + sectionHead(1):sectionTail(1),:);
            else
                LBoundary=Boundary(MZ + sectionHead(1):sectionTail(1),:);
            end
        end
    end
    
    if sum(LBoundary)>0
        LBoundary=LBoundary+1;
    else
        LBoundary=[];
    end
    if sum(RBoundary)>0
        RBoundary=RBoundary+1;
    else
        RBoundary=[];
    end
    

    %%
    if(length(LBoundary)>length(RBoundary))
        newinput=LBoundary;
    else
        newinput=RBoundary;
    end
    
    %% Inverse Transerfering
    scale=70/50; % 70pts=50cm
    zrow=35; zcol=39; % zero on graph: (35,39);
    lInput=double(LBoundary);
    rInput=double(RBoundary);
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
        n=size(x,1);
        SRThres=10;
        lineflag=0;
        x2=0;
        y2=0;
        sx2=0;
        sxy=0;
        sy2=0;
        sx=0;
        sy=0;
        sb1=0;
        sb2=0;
        sb3=0;
        det=0;
        for i=1:n
            sx=sx+x(i);
            sy=sy+y(i);
            x2=x(i)*x(i);
            sx2=sx2+x2;
            y2=y(i)*y(i);
            sy2=sy2+y2;
            sxy=sxy+x(i)*y(i); 
            sb1=sb1+(x2+y2)*x(i);
            sb2=sb2+(x2+y2)*y(i);
        end
        denom=n*sx2-sx^2;
        alpha=(n*sxy-sx*sy)/denom;
        beta=(sx2*sy-sx*sxy)/denom;
        SquareResidue=sy2+alpha^2*sx2+n*beta^2-2*alpha*sxy-2*beta*sy+2*alpha*beta*sx;
        if (SquareResidue < SRThres)
           for jj=0-50+1:150-50+1
              temp=ceil(alpha*jj+beta)+dr;
              if (temp>=0-30+1 && temp<=150-30)
                  out(jj+50,temp+30)=65;
              end
           end
        else
            sb3=sx2+sy2;
            det=n*sx2*sy2+2*sx*sy*sxy-n*sxy*sxy-sx*sx*sy2-sy*sy*sx2;
            sa1=n*sy2-sy*sy;
            sa2=sx*sy-n*sxy;
            sa3=sxy*sy-sx*sy2;
            sa4=sa2;
            sa5=n*sx2-sx*sx;
            sa6=sxy*sx-sy*sx2;
            sa7=sa3;
            sa8=sa6;
            sa9=sx2*sy2-sxy*sxy;
            C(1)=sa1*sb1+sa2*sb2+sa3*sb3;
            C(1)=-C(1)/det;
            C(2)=sa4*sb1+sa5*sb2+sa6*sb3;
            C(2)=-C(2)/det;
            C(3)=sa7*sb1+sa8*sb2+sa9*sb3;
            C(3)=-C(3)/det;
%          A=[sum(x.*x) sum(y.*x) sum(x); 
%          sum(x.*y) sum(y.*y) sum(y);
%          sum(x) sum(y) sum(x./x)];
%          B=[-sum(x.^3+y.^2.*x); -sum(y.^3+x.^2.*y); -sum(y.^2+x.^2)];
%          C=A\B;
            x0=-C(1)/2;
            y0=-C(2)/2;  
            r=sqrt(-C(3)+x0^2+y0^2);
            p=[0:2*pi/100:2*pi];
            if(y0>tCarPosX)
               dr=-dr;
            end
            r=r+dr;
            xx=r*cos(p)+x0;
            yy=r.*sin(p)+y0;
            for ii=1:length(x)
               out(x(ii)+50,y(ii)+30)=44;
            end
            for row=1:length(xx)
                if (0-50+1<xx(row)+1 && xx(row)<150-50 ...
                    && 0-30+1<yy(row) && yy(row)<150-30+1)
                    out(ceil(xx(row))+50 ,ceil(yy(row))+30)=65;
                end
            end
        end
    end
    
    %%
    if(~isempty(newinput))
        newx=newinput(1:5:length(newinput),1);
        newy=newinput(1:5:length(newinput),2);
        InnerThres=35;
        inner=(newx(3)-newx(2))*(newx(2)-newx(1))+(newy(3)-newy(2))*(newy(2)-newy(1));
        for ii=2:length(newx)-2
            lastinner=inner;
            inner=(newx(ii+2)-newx(ii+1))*(newx(ii+1)-newx(ii))+(newy(ii+2)-newy(ii+1))*(newy(ii+1)-newy(ii));
            if (abs(inner-lastinner)>InnerThres)
                out(1:3,1:3)=9;
            end
        end
    end
    
    %%
        
    for ii=-1:1
        for jj=-1:1
            if(exist('x0')&&exist('y0'))
               
            if(x0+jj+50>0   && y0+ii+30>0 ...
            && x0+jj+50<150 && y0+ii+30<150)
                out(ceil(x0)+jj+50,ceil(y0)+ii+30)=9;
            end
            
            end
        end
    end
    
    graph=out;
    spd=0;
    dir=0;
    
    


end

function endPoint=guideLoc(point)
MZ=1;
DIS_COL=3;
IMG_COLS=77;
IMG_ROWS=67;
endPoint=0;
if (point(1)<IMG_ROWS/2)
    endPoint=endPoint+4;
end
if (point(2)>IMG_COLS/2)
    endPoint=endPoint+2;
end
if (point(2)>=MZ+IMG_COLS-DIS_COL-3 || point(2)<=MZ+DIS_COL+2)
    endPoint=endPoint+2;
else
    endPoint=endPoint+1;
end
end


