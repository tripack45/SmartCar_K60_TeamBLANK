function [currentState] = analyzer(currentState)
   %% Calculating the corresponding circle   
   
   SRThres=10;
   if(currentState.LBoundarySize>currentState.RBoundarySize)
       currentState.fittedBoundary=1;
       x=currentState.LBoundaryY(1:5:end);
       y=currentState.LBoundaryX(1:5:end);
       n=length(x);
   else
       currentState.fittedBoundary=2;
       x=currentState.RBoundaryY(1:5:end);
       y=currentState.RBoundaryX(1:5:end);
       n=length(x);
   end
   if(n<5)
       currentState.isUnknown=0;
       return;
   end
   
   x2=0;   y2=0;
   sx2=0;  sy2=0;  sxy=0;
   sx=0;   sy=0;
   sb1=0;  sb2=0;  sb3=0;
   det=0;
   for i=1:n
       sx=sx+x(i);     sy=sy+y(i);
       x2=x(i)*x(i);   sx2=sx2+x2;
       y2=y(i)*y(i);   sy2=sy2+y2;
       sxy=sxy+x(i)*y(i);
       sb1=sb1+(x2+y2)*x(i);
       sb2=sb2+(x2+y2)*y(i);
   end
   denom=n*sx2-sx^2;
   alpha=(n*sxy-sx*sy)/denom;  currentState.lineAlpha = alpha;
   beta=(sx2*sy-sx*sxy)/denom; currentState.lineBeta  = beta;
   SquareResidue=floor(sy2+alpha^2*sx2+n*beta^2-2*alpha*sxy-2*beta*sy+2*alpha*beta*sx);
   currentState.lineMSE=SquareResidue/n;
   
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
   C(2)=sa4*sb1+sa5*sb2+sa6*sb3;
   C(3)=sa7*sb1+sa8*sb2+sa9*sb3;
   %          disp(det);
   C(1)=-C(1)/det;
   C(2)=-C(2)/det;
   C(3)=-C(3)/det;
   
   x0=-C(1)/2; currentState.circleY=x0;
   y0=-C(2)/2; currentState.circleX=y0;
   r=-C(3)+x0^2+y0^2;
   r=sqrt(r);  currentState.circleRadius=r;
   
end

