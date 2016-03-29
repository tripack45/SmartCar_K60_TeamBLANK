/**********************************
*      Created by Jerry Yang      *
*      March. 27, 2016            *
***********************************/

/******* constant definitions *******/
#ifndef _CRT_SECURE_NO_WARNINGS
#define _CRT_SECURE_NO_WARNINGS
#endif
#define FILE_NAME "F:\\document\\freescale\\SmartCar_K60_TeamBLANK\\matlab_code\\input.txt"
#define HALF_TRACK 35
#define SELECT_STEP 5
#define BOUNDARY_NUM_MAX 128
#define COORDINATE_NUM_MAX 50
#define SQUARE_ERROR_THRES 10
#define bool int
#define TRUE 1
#define FALSE 0
typedef unsigned char u8;
typedef char s8;
typedef unsigned short u16;
typedef short s16;
typedef unsigned long int u32;
typedef long int s32;
typedef unsigned long long int u64;
typedef long long int s64;
/************************************/

/******* head files *******/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
/**************************/

/****** function definitions ******/
bool isLinear(u8 boundary[BOUNDARY_NUM_MAX][2], const u8 boundaryNum, float *alpha, float *beta, float *radius);
/**********************************/

/********************* function complement ************************/

//The returned bool value determines the type of the boundary.
//For a line, alpha is the slope, beta is the interception, radius = 0.
//For a circle, alpha and beta are the abscissa and the ordinate of the center, radius is the radius of the circle.
bool isLinear(u8 boundary[BOUNDARY_NUM_MAX][2], const u8 boundaryNum, float *alpha, float *beta, float *radius)
{
	/* Loop variable.*/
	u8 i = 0; 
	/* The total number of coordinates selected.*/
	u8 coordinateNum = 0;
	/* x^2 */
	u16 x2 = 0;
	/* y^2 */
	u16 y2 = 0; 
	/* sum(x) */
	u16 sx = 0;
	/* sum(x^2) */
	u32 sx2 = 0;
	/* sum(y) */
	u16 sy = 0;
	/* sum(y^2) */
	u32 sy2 = 0;
	/* sum(x * y) */
	u32 sxy = 0;
	/* sum(x^3 + x * y^2) */
	u32 b1 = 0;
	/* sum(y^3 + y * x^2) */
	u32 b2 = 0;
	/* sum(x ^ 2 + y ^ 2) */
	u32 b3 = 0; 
	/* Determinant of matrix A.*/
	s32 det = 0;
	/* Common denominator for slope and interception.*/
	s32 denom = 0;
	/* Square error for linear fitting.*/
	u32 squareError = 0;
	/* (1, 1) of inverse of matrix A.*/
	s32 ia1 = 0;
	/* (1, 2) of inverse of matrix A.*/
	s32 ia2 = 0;
	/* (1, 3) of inverse of matrix A.*/
	s32 ia3 = 0;
	/* (2, 1) of inverse of matrix A.*/
	s32 ia4 = 0;
	/* (2, 2) of inverse of matrix A.*/
	s32 ia5 = 0;
	/* (2, 3) of inverse of matrix A.*/
	s32 ia6 = 0;
	/* (3, 1) of inverse of matrix A.*/
	s32 ia7 = 0;
	/* (3, 2) of inverse of matrix A.*/
	s32 ia8 = 0;
	/* (3, 3) of inverse of matrix A.*/
	s32 ia9 = 0;
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

	int abscissa[COORDINATE_NUM_MAX], ordinate[COORDINATE_NUM_MAX];
	int x, y; /* x and y are the current abscissa and ordinate.*/
	for (i = 0; i < boundaryNum; i += SELECT_STEP)
	{
		abscissa[coordinateNum] = x = boundary[i][0];
		ordinate[coordinateNum] = y = boundary[i][1];
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
	denom = coordinateNum * sx2 - sx * sx;
	*alpha = (float)(coordinateNum * sxy - sx * sy) / denom;
	*beta = (float)(sx2 * sy - sx * sxy) / denom;
	squareError = (u32)(sy2 + sx2 * (*alpha) * (*alpha) + coordinateNum * (*beta) * (*beta) + (sx * (*alpha) * (*beta) - sxy * (*alpha) - sy * (*beta)) * 2);
	if (squareError < SQUARE_ERROR_THRES)
	{
		radius = 0;
		return TRUE;
	}
	else
	{
		b3 = sx2 + sy2;
		det = coordinateNum * sx2 * sy2 + 2 * sx * sy * sxy - coordinateNum * sxy * sxy - sx * sx * sy2 - sy * sy * sx2;
		ia1 = coordinateNum * sy2 - sy * sy;
		ia2 = sx * sy - coordinateNum * sxy;
		ia3 = sxy * sy - sx * sy2;
		ia4 = ia2;
		ia5 = coordinateNum * sx2 - sx * sx;
		ia6 = sxy * sx - sy * sx2;
		ia7 = ia3;
		ia8 = ia6;
		ia9 = sx2 * sy2 - sxy * sxy;
		*alpha = (float)((s64)ia1 * b1 + (s64)ia2 * b2 + (s64)ia3 * b3) / 2 / det;
		*beta = (float)((s64)ia4 * b1 + (s64)ia5 * b2 + (s64)ia6 * b3) / 2 / det;
		*radius = (float)((s64)ia7 * b1 + (s64)ia8 * b2 + (s64)ia9 * b3) / det + (*alpha) * (*alpha) + (*beta) * (*beta);
		*radius = (float)sqrt(*radius);
		return FALSE;
	}
}
/******************************************************************/

int main(int argc, char* argv[])
{
	FILE* fid;
	int i=0;
	u8 boundaryNum = 0;
	u8 boundary[BOUNDARY_NUM_MAX][2];
	float alpha = 0, beta = 0, radius = 0;
	fid = fopen(FILE_NAME, "r");
	if (fid == NULL)
	{
		printf("Cannot open file!\n");
		system("pause");
		return -1;
	}
	while (!feof(fid))
	{
		fscanf(fid, "%d\t%d\n", &boundary[boundaryNum][0], &boundary[boundaryNum][1]);
		boundaryNum++;
	}
	if (isLinear(boundary, boundaryNum, &alpha, &beta, &radius))
	{
		printf("The line can be represented as:\n y = %f x + %f\n",alpha, beta);
	}
	else
	{
		printf("The circle can be represented as:\n (x - %f)^2 + (y - %f)^2 = %f^2\n", alpha, beta, radius);
	}
	fclose(fid);
	system("pause");
}