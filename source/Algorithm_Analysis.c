#include "includes.h"
LinearDectect linearDectect;

//The returned bool value determines the type of the boundary.
//For a line, alpha is the slope, beta is the interception, radius = 0.
//For a circle, alpha and beta are the abscissa and the ordinate of the center, radius is the radius of the circle.
void CurveFitting(CurrentControlState *CState)
{
  /* Loop variable.*/
  u8 i = 0; 
  u8 *boundaryX,*boundaryY;
  s16 boundaryNum;
  s16 coordinateNum=0;
  /* The total number of coordinates selected.*/
  if((CState->LBoundarySize) > (CState->RBoundarySize)){
    boundaryX = CState->LBoundaryX;  
    boundaryY = CState->LBoundaryY;
    boundaryNum = CState->LBoundarySize;
    CState->fittedBoundary=1;
  }else{
    boundaryX = CState->RBoundaryX;  
    boundaryY = CState->RBoundaryY;
    boundaryNum = CState->RBoundarySize;  
    CState->fittedBoundary=2;
  }
  if(boundaryNum<(1+SELECT_STEP*(5-1))){
    CState->isUnknown=1;
    return;
  }
  /* x^2 */
  s16 x2 = 0;
  /* y^2 */
  s16 y2 = 0; 
  /* sum(x) */
  s16 sx = 0;
  /* sum(x^2) */
  s32 sx2 = 0;
  /* sum(y) */
  s16 sy = 0;
  /* sum(y^2) */
  s32 sy2 = 0;
  /* sum(x * y) */
  s32 sxy = 0;
  /* sum(x^3 + x * y^2) */
  s32 b1 = 0;
  /* sum(y^3 + y * x^2) */
  s32 b2 = 0;
  /* sum(x ^ 2 + y ^ 2) */
  s32 b3 = 0; 
  /* Determinant of matrix A.*/
  s64 det = 0;
  /* Common denominator for slope and interception.*/
  s32 denom = 0;
  /* (1, 1) of inverse of matrix A.*/
  s64 ia1 = 0;
  /* (1, 2) of inverse of matrix A.*/
  s64 ia2 = 0;
  /* (1, 3) of inverse of matrix A.*/
  s64 ia3 = 0;
  /* (2, 1) of inverse of matrix A.*/
  s64 ia4 = 0;
  /* (2, 2) of inverse of matrix A.*/
  s64 ia5 = 0;
  /* (2, 3) of inverse of matrix A.*/
  s64 ia6 = 0;
  /* (3, 1) of inverse of matrix A.*/
  s64 ia7 = 0;
  /* (3, 2) of inverse of matrix A.*/
  s64 ia8 = 0;
  /* (3, 3) of inverse of matrix A.*/
  s64 ia9 = 0;
  /* The geometric Square Error of circle fitting. */
  s32 distanceSum = 0;
  /****** Here is the way for circle fitting.******/
  /* A = [sum(x.*x) sum(x.*y) sum(x);  
  sum(x.*y) sum(y.*y) sum(y);
  sum(x)    sum(y)    sum(1)];*/
  /* B = [-sum(x.^3 + x * y.^2); 
  -sum(y.^3 + y * x.^2); 
  -sum(x.^2 + y.^2)    ];*/
  /* C = A \ B; alpha = -C(1) / 2; beta = -C(2) / 2; radius = sqrt(-C(3) + alpha^2 + beta^2); */
  /************************************************/
  
  /****** Here is the way for linear fitting.******/
  /* alpha = (coordinateNum * sum(x * y) - sum(x) * sum(y)) / (coordinateNum * sum(x^2) - sum(x)^2); */
  /* beta  = (sum(x^2) * sum(y) - sum(x) * sum(x * y))      / (coordinateNum * sum(x^2) - sum(x)^2); */
  /************************************************/
  
  /* squareError = sum(y^2) + alpha^2 * sum(x^2) + coordinateNum * beta^2 - 2 * alpha * sum(x * y) - 2 * beta * sy + 2 * alpha * beta * sum(x).*/
  /* When the square error for linear fitting is less than SQUARE_ERROR_THRES, return TRUE, use linear fitting.*/
  /* When the square error for linear fitting is not less than SQUARE_ERROR_THRES, return FALSE, use circle fitting.*/
  
  /* x and y are the current abscissa and ordinate.*/
  u8 x, y;

  for (i = 0; i < boundaryNum; i += SELECT_STEP)
  {
    x = boundaryX[i];
    y = boundaryY[i];
    sx += x;
    sy += y;
    x2 = x * x;
    sx2 += x2;
    y2 = y * y;
    sy2 += y2;
    sxy += x * y;
    b1 += (x2 + y2) * x;
    b2 += (x2 + y2) * y;
    coordinateNum++;
  }
  denom = coordinateNum * sy2 - sy * sy;
  CState->lineAlpha  = 100 * ((s32)(coordinateNum * sxy) - (s32)(sx * sy)) / denom;
  CState->lineBeta   = 100 * ((s32)(sy2 * sx) - (s32)(sy * sxy)) / denom;
  
  s64 t1=  (s64)sx2 * 100 * 100;
      t1+= (s64)sy2 * (s64)(CState->lineAlpha) * (s64)(CState->lineAlpha); 
      t1+= coordinateNum * (s64)(CState->lineBeta) * (s64)(CState->lineBeta);
  s64 t2=sy * (s64)(CState->lineAlpha) * (s64)(CState->lineBeta)
              - (s64)sxy * (s64)(CState->lineAlpha) * 100
              - (s64)sx * (s64)(CState->lineBeta) * 100;
  t2*=2;
  s64 t3 = (t1+t2)/coordinateNum;
  CState->lineMSE = t3 / (100 * 100);
  
  b3 = sx2 + sy2;
  det = coordinateNum * (s64)sx2 * (s64)sy2 
        + 2 * sx * sy * (s64)sxy 
        - coordinateNum * (s64)sxy * (s64)sxy 
        - sx * sx * (s64)sy2 
          - sy * sy * (s64)sx2;
  ia1 = coordinateNum * sy2 - sy * sy;
  ia2 = sx * sy - coordinateNum * sxy;
  ia3 = sxy * sy - sx * sy2;
  ia4 = ia2;
  ia5 = coordinateNum * sx2 - sx * sx;
  ia6 = sxy * sx - sy * sx2;
  ia7 = ia3;
  ia8 = ia6;
  ia9 = (s64)sx2 * (s64)sy2 - (s64)sxy * (s64)sxy;
  CState->circleX = (float)((s64)ia1 * b1 + (s64)ia2 * b2 + (s64)ia3 * b3) / 2 / det;
  CState->circleY = (float)((s64)ia4 * b1 + (s64)ia5 * b2 + (s64)ia6 * b3) / 2 / det;
  s64 t = ((s64)ia7 * b1 + (s64)ia8 * b2 + (s64)ia9 * b3) / det
                               + (CState->circleX) * (CState->circleX)
                               + (CState->circleY) * (CState->circleY);
  CState->circleRadius = Isqrt(t);
  
  for (i = 0; i < boundaryNum; i += SELECT_STEP){
    s32 diffX = (s16)(boundaryX[i]) - (CState->circleX);
    s32 diffY = (s16)(boundaryY[i]) - (CState->circleY);
    u32 distance = (( diffX * diffX + diffY * diffY) * 10000);
    distanceSum += Isqrt(distance);
  }
  s32 MSEX=(s32)sx2 - 2 * (CState->circleX) * (s32)sx + coordinateNum * (CState->circleX) * (CState->circleX);
  s32 MSEY=(s32)sy2 - 2 * (CState->circleY) * (s32)sy + coordinateNum * (CState->circleY) * (CState->circleY);
  s32 MSEnr2=coordinateNum * (CState->circleRadius) * (CState->circleRadius);     
  CState->circleMSE = MSEX + MSEY + MSEnr2 - 2 * (CState->circleRadius) * distanceSum / 100;
  CState->circleMSE /= coordinateNum;
}

u8 IsCrossroad(u8* boundaryX,u8* boundaryY, u8 size){
#define CROSSROAD_STEP_LENGTH 5
#define C(x) (x * CROSSROAD_STEP_LENGTH)
  if (size<C(6)) return 0;
  s32 ipSqr=0;
  s32 dSqr=1;
  for (int i=0;i<size-C(5);i+=CROSSROAD_STEP_LENGTH){
    s16 v0x=boundaryX[MZ+ i + C(1)] - boundaryX[MZ + i + C(0)];
    s16 v0y=boundaryY[MZ+ i + C(1)] - boundaryY[MZ + i + C(0)];
    s16 v1x=boundaryX[MZ+ i + C(2)] - boundaryX[MZ + i + C(1)];
    s16 v1y=boundaryY[MZ+ i + C(2)] - boundaryY[MZ + i + C(1)];
    s16 v3x=boundaryX[MZ+ i + C(4)] - boundaryX[MZ + i + C(3)];
    s16 v3y=boundaryY[MZ+ i + C(4)] - boundaryY[MZ + i + C(3)];
    s16 v4x=boundaryX[MZ+ i + C(5)] - boundaryX[MZ + i + C(4)];
    s16 v4y=boundaryY[MZ+ i + C(5)] - boundaryY[MZ + i + C(4)];
#undef C    
    ipSqr=v0x*v1x+v0y*v1y;
    ipSqr*=ipSqr;
    dSqr =(v0x*v0x+v0y*v0y)*(v1x*v1x+v1y*v1y);
    s16 angle01=100*ipSqr/dSqr;
    
    ipSqr=v1x*v3x+v1y*v3y;
    ipSqr*=ipSqr;
    dSqr =(v1x*v1x+v1y*v1y)*(v3x*v3x+v3y*v3y);    
    s16 angle13=100*ipSqr/dSqr;
     
    ipSqr=v3x*v4x+v3y*v4y;
    ipSqr*=ipSqr;
    dSqr =(v3x*v3x+v3y*v3y)*(v4x*v4x+v4y*v4y);   
    s16 angle34=100*ipSqr/dSqr;
    
    if(angle01 > CROSSROAD_STRAIGHT_THRES
    && angle13 < CROSSROAD_SHARPTURN_THRES 
    && angle34 > CROSSROAD_STRAIGHT_THRES)
      return 1;

  }
  return 0;
}


u8 IsStartLine(u8 img_buffer[][IMG_COLS]){
  u8 count=0;
  u8 x1=0; u8 y1=0;
  for(int row=20;row<60;row+=3)
    for(int col=10;col<70;col+=3)
      if(   img_buffer[row][col]<WHITE_THRES
         && img_buffer[row][col-12]>WHITE_THRES
         && img_buffer[row][col+12]>WHITE_THRES
         && img_buffer[row-4][col]>WHITE_THRES
         && img_buffer[row+4][col]>WHITE_THRES){
            if(count==0){
               count++;
               x1=col;y1=row;
            }else{
                int d=ABS(x1-col);
                if(d>15) return 1;
            }
      }
  return 0;
}