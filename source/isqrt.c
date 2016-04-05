#ifndef _CRT_SECURE_NO_WARNINGS
	#define _CRT_SECURE_NO_WARNINGS
#endif 
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdio.h>
#include <time.h>
#include <math.h>
int isqrt(int);
int isqrt(int x){
	int begin = 0;
	int end = x;
	int med = 0;
	int med2 = 0;
	while (end - begin > 1){
		med = (begin + end) / 2;
		med2 = x / med;
		if (med == med2){
			return med;
		}
		else if (med2 < med){
			end = med;
		}
		else{
			begin = med;
		}
	}
	return begin;
}

main()
{
	int c = 28000;
	c = isqrt(c);
	printf("%d\n", c);
	system( "pause");
}


