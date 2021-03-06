function [xOut,yOut]=InversePerspectiveTransform(xIn,yIn)
PERSPECTIVE_SCALE=70;
REAL_WORLD_SCALE=50; %70pts==50cm
%  * Transform: y'= y / (c1*y + c2 )
%  * InverseTr: y = c2*y'/(1 - c1*y )
%  * The frame of reference is at the center of the 
%  * image, i.e. at (39,35)
%  *   O ---------> x
%  *    |
%  *    |
%  *    V y
% */ 
C1=-159;
C2=10129; %// Scaled by 10000
ORIGIN_X=38;
ORIGIN_Y=31;
TRAPZOID_HEIGHT=33;
TRAPZOID_UPPER=32;
TRAPZOID_LOWER=53;
% /* Formula
%    Standard_50(y')= Upeer + (Lower- Upper)* (y'-3) / Height
%    x= PERSPECTIVE_SCALE * x' / Standard_50(y') 
% */

numerator = PERSPECTIVE_SCALE * (xIn - ORIGIN_X) * TRAPZOID_HEIGHT;
denominator = TRAPZOID_UPPER * TRAPZOID_HEIGHT  ...
                + (TRAPZOID_LOWER - TRAPZOID_UPPER) * (yIn - 3);
xOut=fix(numerator./denominator) + ORIGIN_X+75;

numerator = PERSPECTIVE_SCALE * C2 * (yIn - ORIGIN_Y);
denominator = REAL_WORLD_SCALE * (10000 - C1 * (yIn - ORIGIN_Y));
yOut=fix(numerator./denominator) + ORIGIN_Y+100;

end