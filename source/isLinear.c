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
/************************************/

/******* head files *******/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
/**************************/

/****** function definitions ******/
bool isLinear(int boundary[BOUNDARY_NUM_MAX][2], const int boundaryNum, double alpha, double beta, double radius);
/**********************************/

/********************* function complement ************************/

//The returned bool value determines the type of the boundary.
//For a line, alpha is the slope, beta is the interception, radius = 0.
//For a circle, alpha and beta are the abscissa and the ordinate of the center, radius is the radius of the circle.
bool isLinear(int boundary[BOUNDARY_NUM_MAX][2], const int boundaryNum, double alpha, double beta, double radius)
{
	/* Loop variable.*/
	int i = 0; 
	/* The total number of coordinates selected.*/
	int coordinateNum = 0;
	/* x^2 */
	int x2 = 0;
	/* y^2 */
	int y2 = 0; 
	/* sum(x) */
	int sx = 0;
	/* sum(x^2) */
	int sx2 = 0;
	/* sum(y) */
	int sy = 0;
	/* sum(y^2) */
	int sy2 = 0;
	/* sum(x * y) */
	int sxy = 0;
	/* sum(x^3 + x * y^2) */
	int b1 = 0;
	/* sum(y^3 + y * x^2) */
	int b2 = 0;
	/* sum(x ^ 2 + y ^ 2) */
	int b3 = 0; 
	/* Determinant of matrix A.*/
	int det = 0;
	/* Common denominator for slope and interception.*/
	int denom = 0;
	/* Square error for linear fitting.*/
	double squareError = 0;
	/* (1, 1) of inverse of matrix A.*/
	int ia1 = 0;
	/* (1, 2) of inverse of matrix A.*/
	int ia2 = 0;
	/* (1, 3) of inverse of matrix A.*/
	int ia3 = 0;
	/* (2, 1) of inverse of matrix A.*/
	int ia4 = 0;
	/* (2, 2) of inverse of matrix A.*/
	int ia5 = 0;
	/* (2, 3) of inverse of matrix A.*/
	int ia6 = 0;
	/* (3, 1) of inverse of matrix A.*/
	int ia7 = 0;
	/* (3, 2) of inverse of matrix A.*/
	int ia8 = 0;
	/* (3, 3) of inverse of matrix A.*/
	int ia9 = 0;
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
	alpha = (coordinateNum * sxy - sx * sy) / denom;
	beta = (sx2 * sy - sx * sxy) / denom;
	squareError = sy2 + sx2 * alpha * alpha + coordinateNum * beta * beta + (sx * alpha * beta - sxy * alpha - sy * beta) * 2;
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
		alpha = (ia1 * b1 + ia2 * b2 + ia3 * b3) / 2 / det;
		beta = (ia4 * b1 + ia5 * b2 + ia6 * b3) / 2 / det;
		radius = (ia7 * b1 + ia8 * b2 + ia9 * b3) / det + alpha * alpha + beta * beta;
		radius = sqrt(radius);
		return FALSE;
	}
}
/******************************************************************/

int main(int argc, char* argv[])
{
	FILE* fid;
	int i=0;
	int boundaryNum = 0;
	int boundary[BOUNDARY_NUM_MAX][2];
	double alpha = 0, beta = 0, radius = 0;
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
	if (isLinear(boundary, boundaryNum, alpha, beta, radius))
	{
		printf("%g\t%g\n",alpha, beta);
	}
	else
	{
		printf("%g\t%g\t%g\n", alpha, beta, radius);
	}
	/*for (i = 0; i < boundaryNum; i++)
	{
		printf("%d\t%d\n", boundary[i][0], boundary[i][1]);
	}*/
	fclose(fid);
	system("pause");
}