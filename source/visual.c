#include "includes.h"



#define SAMPLE_RATE 5
#define PERSPECTIVE_SCALE 70
#define REAL_WORLD_SCALE 50 // 70pts==50cm
/* Formula
 * Transform: y'= y / (c1*y + c2 )
 * InverseTr: y = c2*y'/(1 - c1*y )
 * The frame of reference is at the center of the 
 * image, i.e. at (39,35)
 *   O ---------> x
 *    |
 *    |
 *    V y
*/ 
#define C1 -104
#define C2 8170 // Scaled by 10000
#define ORIGIN_X 39
#define ORIGIN_Y 35
#define TRAPZOID_HEIGHT 51
#define TRAPZOID_UPPER 38
#define TRAPZOID_LOWER 70
/* Formula
   Standard_50(y')= Upeer + (Lower- Upper)* y' / Height
   x= PERSPECTIVE_SCALE * x' / Standard_50(y') 
*/

u8 InversePerspectiveTransform(u8* xIn,u8* yIn, u8 size){
    u8* xOut=xIn;
    for(u8 i=0;i<size;i+=SAMPLE_RATE){
        int32 numerator = PERSPECTIVE_SCALE * (xIn - ORIGIN_X) * TRAPZOID_HEIGHT;
        int32 denominator = TRAPZOID_UPPER * TRAPZOID_HEIGHT  
                + (TRAPZOID_LOWER - TRAPZOID_UPPER) * (yIn - 3);
        (*xOut)=numerator/denominator + ORIGIN_X;
        xOut ++; 
        numerator = PERSPECTIVE_SCALE* C2 * (yIn[i] - ORIGIN_Y);
        denominator = REAL_WORLD_SCALE * (10000 - C1 * (yIn[i] - ORIGIN_Y));
        (*yOut)=numerator/denominator + ORIGIN_Y;
        yOut ++;
   }   
   return (xOut - xIn); //Returns number of points processed    
}