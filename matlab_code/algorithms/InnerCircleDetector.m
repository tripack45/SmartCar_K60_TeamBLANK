function currentState = InnerCircleDetector( currentState )
% WARNING: THIS FUNCTION IS NOT CALLED!!
% WARNING: THIS FUNCTION IS NOT CALLED!!
% WARNING: THIS FUNCTION IS NOT CALLED!!
MZ=1;
if currentState.fittedBoundary==1 
    boundaryX=currentState.LBoundaryX;
    boundaryY=currentState.LBoundaryY;
    size=currentState.LBoundarySize;
else
    boundaryX=currentState.RBoundaryX;
    boundaryY=currentState.RBoundaryY;
    size=currentState.RBoundarySize;
end
   counter=0;
   for i=0:2
       sgn1=sign( boundaryX( MZ + i ) - boundaryX( MZ + size - 1 -i));
       sgn2=sign( boundaryY( MZ + i ) - boundaryY( MZ + size - 1 -i));
       counter=counter-sgn1*sgn2;
   end
   currentState.innerCircleFlag=sign(counter);
end

