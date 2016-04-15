function [currentState] = analyzer(currentState)
   %% Calculating the corresponding circle   
   
   SRThres=10;
   if(currentState.LBoundarySize>currentState.RBoundarySize)
       currentState.fittedBoundary=1;
       x=currentState.LBoundaryX(1:5:end);
       y=currentState.LBoundaryY(1:5:end);
       n=length(x);
   else
       currentState.fittedBoundary=2;
       x=currentState.RBoundaryX(1:5:end);
       y=currentState.RBoundaryY(1:5:end);
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
   denom=n*sy2-sy^2;
   alpha=floor(100*(n*sxy-sx*sy)/denom);  currentState.lineAlpha = alpha;
   beta=floor(100*(sy2*sx-sy*sxy)/denom); currentState.lineBeta  = beta;
   
   t1=sx2*10000+alpha^2*sy2+n*beta^2;
   t2=-2*alpha*sxy*100-2*beta*sx*100+2*alpha*beta*sy;
   SquareResidue=(t1+t2)/n;
   SquareResidue=SquareResidue/10000;
   
   currentState.lineMSE=SquareResidue;
   
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
   
   x0=floor(C(1)/2/det); currentState.circleX=x0;
   x0_old=C(1)/2/det;
   y0=floor(C(2)/2/det); currentState.circleY=y0;
   y0_old=C(2)/2/det;
   r=floor(C(3)/det+x0^2+y0^2);
   r_old=C(3)/det+x0^2+y0^2;
   r=floor(sqrt(r));  currentState.circleRadius=r;
   r_old=sqrt(r_old);
   distanceSum=0;
   distanceSum_old=0;
   for i=1:n
        diffX = x(i)-x0;
        diffX_old = x(i)-x0_old;
        diffY = y(i)-y0;
        diffY_old = y(i)-y0_old;
        distance = (( diffX * diffX + diffY * diffY) * 10000);
        distance_old = (( diffX_old ^2 + diffY_old ^2) * 10000);
        distanceSum = distanceSum + floor(sqrt(distance));
        distanceSum_old = distanceSum_old + sqrt(distance_old);
   end
   MSEX=sx2 - 2 * x0 * sx + n * x0^2;
   MSEX_old=sx2 - 2 * x0_old * sx + n * x0_old^2;
   MSEY=sy2 - 2 * y0 * sy + n * y0^2;
   MSEY_old=sy2 - 2 * y0_old * sy + n * y0_old^2;
   MSEnr2=n * r^2;  
   MSEnr2_old=n * r_old^2;
   currentState.circleMSE = MSEX + MSEY + MSEnr2 - 2 * r * distanceSum / 100;
   circleMSE_old = MSEX_old+MSEY_old+MSEnr2_old-2*r_old*distanceSum_old/100;
   currentState.circleMSE = floor(currentState.circleMSE/n);
   circleMSE_old = circleMSE_old/n;
   fprintf('circleMSE_old=%10g\t',circleMSE_old);
end

