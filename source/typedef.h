#ifndef _TYPE_DEF_
#define _TYPE_DEF_

#include "common.h"

typedef volatile unsigned char U8;
typedef volatile char S8;
typedef volatile unsigned short U16;
typedef volatile short S16;
typedef volatile unsigned long int U32;
typedef volatile long int S32;
typedef volatile unsigned long long int U64;
typedef volatile long long int S64;

typedef unsigned char u8;
typedef char s8;
typedef unsigned short u16;
typedef short s16;
typedef unsigned long int u32;
typedef long int s32;
typedef unsigned long long int u64;
typedef long long int s64;

typedef volatile unsigned char B2;
typedef unsigned char b2;

#define abs(x) (x>0?x:(-x))
#define Nop asm("nop")
#define insert(a,b,c) if ((a)<(b)) a=b;else if ((a)>(c)) a=c;
#define judge_in(a,b,c) (((b)<=(a)&&(a)<=(c))?1:0)
#define insert_in(a,b,c) ((a)<(b)?(b):(a)>(c)?c:a)
#define maxab(a,b) ((a)<(b)?b:a)
#define minab(a,b) ((a)>(b)?b:a)
#define abs0(a) ((a)>0?a:0)


#endif