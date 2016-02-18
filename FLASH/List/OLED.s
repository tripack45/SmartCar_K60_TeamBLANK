///////////////////////////////////////////////////////////////////////////////
//
// IAR ANSI C/C++ Compiler V7.20.2.7424/W32 for ARM       18/Feb/2016  01:29:46
// Copyright 1999-2014 IAR Systems AB.
//
//    Cpu mode     =  thumb
//    Endian       =  little
//    Source file  =  E:\freescale_racing\framework2016\source\OLED.c
//    Command line =  
//        E:\freescale_racing\framework2016\source\OLED.c -lCN
//        E:\freescale_racing\framework2016\FLASH\List\ -lB
//        E:\freescale_racing\framework2016\FLASH\List\ -o
//        E:\freescale_racing\framework2016\FLASH\Obj\ --no_cse --no_unroll
//        --no_inline --no_code_motion --no_tbaa --no_clustering
//        --no_scheduling --debug --endian=little --cpu=Cortex-M4 -e
//        --char_is_signed --fpu=None --dlib_config "C:\Program Files (x86)\IAR
//        Systems\Embedded Workbench 7.0\arm\INC\c\DLib_Config_Normal.h" -I
//        E:\freescale_racing\framework2016\source\ -I
//        E:\freescale_racing\framework2016\common\ -I
//        E:\freescale_racing\framework2016\LPLD\ -I
//        E:\freescale_racing\framework2016\LPLD\HW\ -I
//        E:\freescale_racing\framework2016\LPLD\DEV\ -Ol -I "C:\Program Files
//        (x86)\IAR Systems\Embedded Workbench 7.0\arm\CMSIS\Include\" -D
//        ARM_MATH_CM4
//    List file    =  E:\freescale_racing\framework2016\FLASH\List\OLED.s
//
///////////////////////////////////////////////////////////////////////////////

        #define SHT_PROGBITS 0x1

        PUBLIC F6x8
        PUBLIC Oled_Clear
        PUBLIC Oled_DC
        PUBLIC Oled_DLY_ms
        PUBLIC Oled_Init
        PUBLIC Oled_Putnum
        PUBLIC Oled_Putstr
        PUBLIC Oled_RST
        PUBLIC Oled_SCL
        PUBLIC Oled_SDA
        PUBLIC Oled_Set_Pos
        PUBLIC Oled_WrCmd
        PUBLIC Oled_WrDat

// E:\freescale_racing\framework2016\source\OLED.c
//    1 /*
//    2     Basic of Oled
//    3 Arthor : Qian Qiyang (KisaragiAyanoo@twitter)
//    4 Date : 2015/12/01
//    5 
//    6 */
//    7 
//    8 
//    9 #include "includes.h"
//   10 
//   11 
//   12 
//   13 // ===== Variables =====
//   14 
//   15 // --- Local ---
//   16 const uint8 F6x8[][6];
//   17 #define XLevelL		0x00
//   18 #define XLevelH		0x10
//   19 #define XLevel		((XLevelH&0x0F)*16+XLevelL)
//   20 #define OLED_COL	128
//   21 #define Max_Row		  64
//   22 #define	Brightness	0xCF 
//   23 
//   24 #define X_WIDTH 128
//   25 #define Y_WIDTH 64
//   26 
//   27 
//   28 
//   29 // ===== Functions Declare =====
//   30 
//   31 // --- Local --- ( No need for user to use ! )
//   32 
//   33   // Basic Driver 
//   34 void Oled_WrDat(uint8 data);
//   35 void Oled_WrCmd(uint8 cmd);
//   36 void Oled_DLY_ms(uint16 ms);
//   37 void Oled_Set_Pos(uint8 x, uint8 y);
//   38 
//   39   // Hardware Interface
//   40 void Oled_SCL(u8 x);
//   41 void Oled_SDA(u8 x);
//   42 void Oled_RST(u8 x);
//   43 void Oled_DC(u8 x);
//   44 
//   45 
//   46 
//   47 
//   48 
//   49 // ===== APIs Realization =====
//   50 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   51 void Oled_Putstr(u8 y,u8 x,u8 ch[])
//   52 {
Oled_Putstr:
        PUSH     {R4-R8,LR}
        MOVS     R3,R1
        MOVS     R4,R2
//   53   uint8 c=0,i=0,j=0,t=0; 
        MOVS     R7,#+0
        MOVS     R8,#+0
        MOVS     R6,#+0
        MOVS     R5,#+0
        B.N      ??Oled_Putstr_0
//   54   while (ch[t]!='\0')
//   55     t++;
??Oled_Putstr_1:
        ADDS     R5,R5,#+1
??Oled_Putstr_0:
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        LDRB     R1,[R5, R4]
        CMP      R1,#+0
        BNE.N    ??Oled_Putstr_1
//   56   Oled_Set_Pos(21-x-t,7-y);
        RSBS     R1,R0,#+7
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        RSBS     R0,R3,#+21
        SUBS     R0,R0,R5
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       Oled_Set_Pos
//   57   for(j=0;j<t;j++){   
        MOVS     R6,#+0
        B.N      ??Oled_Putstr_2
//   58     c = ch[t-1-j]-32;
//   59     for(i=0;i<6;i++)     
//   60       Oled_WrDat(F6x8[c][5-i]);  
??Oled_Putstr_3:
        LDR.W    R0,??DataTable5
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        MOVS     R1,#+6
        MLA      R0,R1,R7,R0
        UXTB     R8,R8            ;; ZeroExt  R8,R8,#+24,#+24
        SUBS     R0,R0,R8
        LDRB     R0,[R0, #+5]
        BL       Oled_WrDat
        ADDS     R8,R8,#+1
??Oled_Putstr_4:
        UXTB     R8,R8            ;; ZeroExt  R8,R8,#+24,#+24
        CMP      R8,#+6
        BLT.N    ??Oled_Putstr_3
        ADDS     R6,R6,#+1
??Oled_Putstr_2:
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        CMP      R6,R5
        BCS.N    ??Oled_Putstr_5
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        SUBS     R0,R5,#+1
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        SUBS     R0,R0,R6
        LDRB     R0,[R0, R4]
        SUBS     R7,R0,#+32
        MOVS     R8,#+0
        B.N      ??Oled_Putstr_4
//   61   }
//   62 }
??Oled_Putstr_5:
        POP      {R4-R8,PC}       ;; return
//   63 /*
//   64 void print_curse(u8 col,u8 sel){   
//   65   uint8 i;
//   66   for(i=0;i<8;++i){
//   67     if (col == i) {
//   68       if (sel == 0) Oled_Putstr(col,0,">");
//   69       else Oled_Putstr(col,0,"*");
//   70     }
//   71     else Oled_Putstr(i,0," "); 
//   72   }
//   73 }
//   74 */

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   75 void Oled_Putnum(u8 x,u8 y,s16 c){      
Oled_Putnum:
        PUSH     {R4,R5,LR}
        SUB      SP,SP,#+12
//   76   uint8 cha[7],temp,sig=0;
        MOVS     R3,#+0
//   77   
//   78   if (c<0){
        SXTH     R2,R2            ;; SignExt  R2,R2,#+16,#+16
        CMP      R2,#+0
        BPL.N    ??Oled_Putnum_0
//   79     sig=1;
        MOVS     R3,#+1
//   80     c = -c;
        SXTH     R2,R2            ;; SignExt  R2,R2,#+16,#+16
        RSBS     R2,R2,#+0
//   81   }
//   82   
//   83   cha[0]=' ';
??Oled_Putnum_0:
        MOVS     R4,#+32
        STRB     R4,[SP, #+0]
//   84   
//   85   temp=c/10000;
        SXTH     R2,R2            ;; SignExt  R2,R2,#+16,#+16
        MOVW     R4,#+10000
        SDIV     R4,R2,R4
//   86   if(temp==0) cha[1]=' ';
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        CMP      R4,#+0
        BNE.N    ??Oled_Putnum_1
        MOVS     R4,#+32
        STRB     R4,[SP, #+1]
        B.N      ??Oled_Putnum_2
//   87   else cha[1]=temp+48;
??Oled_Putnum_1:
        ADDS     R4,R4,#+48
        STRB     R4,[SP, #+1]
//   88   
//   89   temp=c%10000/1000;
??Oled_Putnum_2:
        SXTH     R2,R2            ;; SignExt  R2,R2,#+16,#+16
        MOVW     R4,#+10000
        SDIV     R5,R2,R4
        MLS      R4,R4,R5,R2
        MOV      R5,#+1000
        SDIV     R4,R4,R5
//   90   if(temp==0 && cha[1]==' ') cha[2]=' ';
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        CMP      R4,#+0
        BNE.N    ??Oled_Putnum_3
        LDRB     R5,[SP, #+1]
        CMP      R5,#+32
        BNE.N    ??Oled_Putnum_3
        MOVS     R4,#+32
        STRB     R4,[SP, #+2]
        B.N      ??Oled_Putnum_4
//   91   else cha[2]=temp+48;
??Oled_Putnum_3:
        ADDS     R4,R4,#+48
        STRB     R4,[SP, #+2]
//   92   
//   93   temp=c%1000/100;
??Oled_Putnum_4:
        SXTH     R2,R2            ;; SignExt  R2,R2,#+16,#+16
        MOV      R4,#+1000
        SDIV     R5,R2,R4
        MLS      R4,R4,R5,R2
        MOVS     R5,#+100
        SDIV     R4,R4,R5
//   94   if(temp==0 && cha[2]==' ') cha[3]=' ';
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        CMP      R4,#+0
        BNE.N    ??Oled_Putnum_5
        LDRB     R5,[SP, #+2]
        CMP      R5,#+32
        BNE.N    ??Oled_Putnum_5
        MOVS     R4,#+32
        STRB     R4,[SP, #+3]
        B.N      ??Oled_Putnum_6
//   95   else cha[3]=temp+48;
??Oled_Putnum_5:
        ADDS     R4,R4,#+48
        STRB     R4,[SP, #+3]
//   96   
//   97   temp=c%100/10;
??Oled_Putnum_6:
        SXTH     R2,R2            ;; SignExt  R2,R2,#+16,#+16
        MOVS     R4,#+100
        SDIV     R5,R2,R4
        MLS      R4,R4,R5,R2
        MOVS     R5,#+10
        SDIV     R4,R4,R5
//   98   if(temp==0 && cha[3]==' ') cha[4]=' ';
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        CMP      R4,#+0
        BNE.N    ??Oled_Putnum_7
        LDRB     R5,[SP, #+3]
        CMP      R5,#+32
        BNE.N    ??Oled_Putnum_7
        MOVS     R4,#+32
        STRB     R4,[SP, #+4]
        B.N      ??Oled_Putnum_8
//   99   else cha[4]=temp+48; 
??Oled_Putnum_7:
        ADDS     R4,R4,#+48
        STRB     R4,[SP, #+4]
//  100   
//  101   temp=c%10;
??Oled_Putnum_8:
        SXTH     R2,R2            ;; SignExt  R2,R2,#+16,#+16
        MOVS     R4,#+10
        SDIV     R5,R2,R4
        MLS      R4,R4,R5,R2
//  102   cha[5]=temp+48;  
        ADDS     R2,R4,#+48
        STRB     R2,[SP, #+5]
//  103   cha[6]='\0';
        MOVS     R2,#+0
        STRB     R2,[SP, #+6]
//  104   if(sig){
        UXTB     R3,R3            ;; ZeroExt  R3,R3,#+24,#+24
        CMP      R3,#+0
        BEQ.N    ??Oled_Putnum_9
//  105     temp=6;
        MOVS     R4,#+6
        B.N      ??Oled_Putnum_10
//  106     while(cha[temp]!=' ')
//  107       temp--;
??Oled_Putnum_11:
        SUBS     R4,R4,#+1
??Oled_Putnum_10:
        ADD      R2,SP,#+0
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        LDRB     R2,[R4, R2]
        CMP      R2,#+32
        BNE.N    ??Oled_Putnum_11
//  108     cha[temp]='-';
        MOVS     R2,#+45
        ADD      R3,SP,#+0
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        STRB     R2,[R4, R3]
//  109   }
//  110   Oled_Putstr(x,y+1,cha);
??Oled_Putnum_9:
        ADD      R2,SP,#+0
        ADDS     R1,R1,#+1
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       Oled_Putstr
//  111 }
        POP      {R0-R2,R4,R5,PC}  ;; return
//  112 
//  113 
//  114 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  115 void Oled_Clear(void)
//  116 {
Oled_Clear:
        PUSH     {R3-R5,LR}
//  117 	uint8 y,x;	
//  118 	for(y=0;y<8;y++)
        MOVS     R4,#+0
        B.N      ??Oled_Clear_0
//  119 	{
//  120 		Oled_WrCmd(0xb0+y);
//  121 		Oled_WrCmd(0x01);
//  122 		Oled_WrCmd(0x10); 
//  123 		for(x=0;x<X_WIDTH;x++)
//  124 			Oled_WrDat(0);
??Oled_Clear_1:
        MOVS     R0,#+0
        BL       Oled_WrDat
        ADDS     R5,R5,#+1
??Oled_Clear_2:
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        CMP      R5,#+128
        BLT.N    ??Oled_Clear_1
        ADDS     R4,R4,#+1
??Oled_Clear_0:
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        CMP      R4,#+8
        BGE.N    ??Oled_Clear_3
        SUBS     R0,R4,#+80
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       Oled_WrCmd
        MOVS     R0,#+1
        BL       Oled_WrCmd
        MOVS     R0,#+16
        BL       Oled_WrCmd
        MOVS     R5,#+0
        B.N      ??Oled_Clear_2
//  125 	}
//  126 }
??Oled_Clear_3:
        POP      {R0,R4,R5,PC}    ;; return
//  127 
//  128 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  129 void Oled_Init(void)        
//  130 {  
Oled_Init:
        PUSH     {R7,LR}
//  131   PORTC->PCR[12] |= PORT_PCR_MUX(1);
        LDR.N    R0,??DataTable5_1  ;; 0x4004b030
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.N    R1,??DataTable5_1  ;; 0x4004b030
        STR      R0,[R1, #+0]
//  132   PORTC->PCR[13] |= PORT_PCR_MUX(1);
        LDR.N    R0,??DataTable5_2  ;; 0x4004b034
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.N    R1,??DataTable5_2  ;; 0x4004b034
        STR      R0,[R1, #+0]
//  133   PORTC->PCR[14] |= PORT_PCR_MUX(1);
        LDR.N    R0,??DataTable5_3  ;; 0x4004b038
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.N    R1,??DataTable5_3  ;; 0x4004b038
        STR      R0,[R1, #+0]
//  134   PORTC->PCR[15] |= PORT_PCR_MUX(1);
        LDR.N    R0,??DataTable5_4  ;; 0x4004b03c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100
        LDR.N    R1,??DataTable5_4  ;; 0x4004b03c
        STR      R0,[R1, #+0]
//  135   PTC->PDDR |= (1<<12);
        LDR.N    R0,??DataTable5_5  ;; 0x400ff094
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1000
        LDR.N    R1,??DataTable5_5  ;; 0x400ff094
        STR      R0,[R1, #+0]
//  136   PTC->PDDR |= (1<<13);
        LDR.N    R0,??DataTable5_5  ;; 0x400ff094
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x2000
        LDR.N    R1,??DataTable5_5  ;; 0x400ff094
        STR      R0,[R1, #+0]
//  137   PTC->PDDR |= (1<<14);
        LDR.N    R0,??DataTable5_5  ;; 0x400ff094
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x4000
        LDR.N    R1,??DataTable5_5  ;; 0x400ff094
        STR      R0,[R1, #+0]
//  138   PTC->PDDR |= (1<<15);
        LDR.N    R0,??DataTable5_5  ;; 0x400ff094
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8000
        LDR.N    R1,??DataTable5_5  ;; 0x400ff094
        STR      R0,[R1, #+0]
//  139   
//  140   Oled_SCL(1);
        MOVS     R0,#+1
        BL       Oled_SCL
//  141   //Oled_CS(1);	 	
//  142 	
//  143   Oled_RST(0);
        MOVS     R0,#+0
        BL       Oled_RST
//  144   Oled_DLY_ms(50);
        MOVS     R0,#+50
        BL       Oled_DLY_ms
//  145   Oled_RST(1);
        MOVS     R0,#+1
        BL       Oled_RST
//  146 
//  147   Oled_WrCmd(0xae);//--turn off oled panel
        MOVS     R0,#+174
        BL       Oled_WrCmd
//  148   Oled_WrCmd(0x00);//---set low column address
        MOVS     R0,#+0
        BL       Oled_WrCmd
//  149   Oled_WrCmd(0x10);//---set high column address
        MOVS     R0,#+16
        BL       Oled_WrCmd
//  150   Oled_WrCmd(0x40);//--set start line address  Set Mapping RAM Display Start Line (0x00~0x3F)
        MOVS     R0,#+64
        BL       Oled_WrCmd
//  151   Oled_WrCmd(0x81);//--set contrast control register
        MOVS     R0,#+129
        BL       Oled_WrCmd
//  152   Oled_WrCmd(0xcf); // Set SEG Output Current Brightness
        MOVS     R0,#+207
        BL       Oled_WrCmd
//  153   Oled_WrCmd(0xa1);//--Set SEG/Column Mapping     0xa0¶‰E”½’u 0xa1³í
        MOVS     R0,#+161
        BL       Oled_WrCmd
//  154   Oled_WrCmd(0xc8);//Set COM/Row Scan Direction   0xc0ã‰º”½’u 0xc8³í
        MOVS     R0,#+200
        BL       Oled_WrCmd
//  155   Oled_WrCmd(0xa6);//--set normal display
        MOVS     R0,#+166
        BL       Oled_WrCmd
//  156   Oled_WrCmd(0xa8);//--set multiplex ratio(1 to 64)
        MOVS     R0,#+168
        BL       Oled_WrCmd
//  157   Oled_WrCmd(0x3f);//--1/64 duty
        MOVS     R0,#+63
        BL       Oled_WrCmd
//  158   Oled_WrCmd(0xd3);//-set display offset	Shift Mapping RAM Counter (0x00~0x3F)
        MOVS     R0,#+211
        BL       Oled_WrCmd
//  159   Oled_WrCmd(0x00);//-not offset
        MOVS     R0,#+0
        BL       Oled_WrCmd
//  160   Oled_WrCmd(0xd5);//--set display clock divide ratio/oscillator frequency
        MOVS     R0,#+213
        BL       Oled_WrCmd
//  161   Oled_WrCmd(0xf0);//--set divide ratio, Set Clock as 100 Frames/Sec
        MOVS     R0,#+240
        BL       Oled_WrCmd
//  162   Oled_WrCmd(0xd9);//--set pre-charge period
        MOVS     R0,#+217
        BL       Oled_WrCmd
//  163   Oled_WrCmd(0xf1);//Set Pre-Charge as 15 Clocks & Discharge as 1 Clock
        MOVS     R0,#+241
        BL       Oled_WrCmd
//  164   Oled_WrCmd(0xda);//--set com pins hardware configuration
        MOVS     R0,#+218
        BL       Oled_WrCmd
//  165   Oled_WrCmd(0x12);
        MOVS     R0,#+18
        BL       Oled_WrCmd
//  166   Oled_WrCmd(0xdb);//--set vcomh
        MOVS     R0,#+219
        BL       Oled_WrCmd
//  167   Oled_WrCmd(0x40);//Set VCOM Deselect Level
        MOVS     R0,#+64
        BL       Oled_WrCmd
//  168   Oled_WrCmd(0x20);//-Set Page Addressing Mode (0x00/0x01/0x02)
        MOVS     R0,#+32
        BL       Oled_WrCmd
//  169   Oled_WrCmd(0x02);//
        MOVS     R0,#+2
        BL       Oled_WrCmd
//  170   Oled_WrCmd(0x8d);//--set Charge Pump enable/disable
        MOVS     R0,#+141
        BL       Oled_WrCmd
//  171   Oled_WrCmd(0x14);//--set(0x10) disable
        MOVS     R0,#+20
        BL       Oled_WrCmd
//  172   Oled_WrCmd(0xa4);// Disable Entire Display On (0xa4/0xa5)
        MOVS     R0,#+164
        BL       Oled_WrCmd
//  173   Oled_WrCmd(0xa6);// Disable Inverse Display On (0xa6/a7) 
        MOVS     R0,#+166
        BL       Oled_WrCmd
//  174   Oled_WrCmd(0xaf);//--turn on oled panel
        MOVS     R0,#+175
        BL       Oled_WrCmd
//  175   Oled_Clear(); 
        BL       Oled_Clear
//  176   Oled_Set_Pos(0,0);  
        MOVS     R1,#+0
        MOVS     R0,#+0
        BL       Oled_Set_Pos
//  177 	
//  178 
//  179 } 
        POP      {R0,PC}          ;; return
//  180 
//  181 
//  182 
//  183 // --- Basic Driver ---
//  184 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  185 void Oled_DLY_ms(uint16 ms)
//  186 {                         
Oled_DLY_ms:
        B.N      ??Oled_DLY_ms_0
//  187   uint16 a;
//  188   while(ms)
//  189   {
//  190     a=1335;
??Oled_DLY_ms_1:
        MOVW     R1,#+1335
//  191     while(a--);
??Oled_DLY_ms_2:
        MOVS     R2,R1
        SUBS     R1,R2,#+1
        UXTH     R2,R2            ;; ZeroExt  R2,R2,#+16,#+16
        CMP      R2,#+0
        BNE.N    ??Oled_DLY_ms_2
//  192     ms--;
        SUBS     R0,R0,#+1
//  193   }
??Oled_DLY_ms_0:
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        CMP      R0,#+0
        BNE.N    ??Oled_DLY_ms_1
//  194   return;
        BX       LR               ;; return
//  195 }
//  196 

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
//  197 void Oled_WrDat(uint8 data)
//  198 {
Oled_WrDat:
        PUSH     {R3-R5,LR}
        MOVS     R4,R0
//  199   uint8 i=8;
        MOVS     R5,#+8
//  200   //Oled_CS(0);;
//  201   Oled_DC(1);;
        MOVS     R0,#+1
        BL       Oled_DC
//  202   Oled_SCL(0);;   ;
        MOVS     R0,#+0
        BL       Oled_SCL
        B.N      ??Oled_WrDat_0
//  203   while(i--)
//  204   {
//  205     if(data&1){
//  206       Oled_SDA(1);asm("nop");asm("nop");
//  207     }
//  208     else{
//  209       Oled_SDA(0);asm("nop");asm("nop");
??Oled_WrDat_1:
        MOVS     R0,#+0
        BL       Oled_SDA
        nop
        nop
//  210     }
//  211     Oled_SCL(1); 
??Oled_WrDat_2:
        MOVS     R0,#+1
        BL       Oled_SCL
//  212     asm("nop");asm("nop");asm("nop");asm("nop");        
        nop
        nop
        nop
        nop
//  213     Oled_SCL(0);; 
        MOVS     R0,#+0
        BL       Oled_SCL
//  214     asm("nop");asm("nop");
        nop
        nop
//  215     data>>=1;;    
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        LSRS     R4,R4,#+1
??Oled_WrDat_0:
        MOVS     R0,R5
        SUBS     R5,R0,#+1
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BEQ.N    ??Oled_WrDat_3
        LSLS     R0,R4,#+31
        BPL.N    ??Oled_WrDat_1
        MOVS     R0,#+1
        BL       Oled_SDA
        nop
        nop
        B.N      ??Oled_WrDat_2
//  216   }
//  217   //Oled_CS=1;
//  218 }
??Oled_WrDat_3:
        POP      {R0,R4,R5,PC}    ;; return
//  219 

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
//  220 void Oled_WrCmd(uint8 cmd)
//  221 {
Oled_WrCmd:
        PUSH     {R3-R5,LR}
        MOVS     R4,R0
//  222   uint8 i=8;
        MOVS     R5,#+8
//  223   
//  224   //Oled_CS(0);;
//  225   Oled_DC(0);;
        MOVS     R0,#+0
        BL       Oled_DC
//  226   Oled_SCL(0);;
        MOVS     R0,#+0
        BL       Oled_SCL
        B.N      ??Oled_WrCmd_0
//  227   //asm("nop");   
//  228   while(i--)
//  229   {
//  230     if(cmd&0x80){Oled_SDA(1);;}
//  231     else{Oled_SDA(0);;}
??Oled_WrCmd_1:
        MOVS     R0,#+0
        BL       Oled_SDA
//  232     Oled_SCL(1);;
??Oled_WrCmd_2:
        MOVS     R0,#+1
        BL       Oled_SCL
//  233     asm("nop");asm("nop");     
        nop
        nop
//  234     Oled_SCL(0);;    
        MOVS     R0,#+0
        BL       Oled_SCL
//  235     cmd<<=1;;   
        LSLS     R4,R4,#+1
??Oled_WrCmd_0:
        MOVS     R0,R5
        SUBS     R5,R0,#+1
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BEQ.N    ??Oled_WrCmd_3
        LSLS     R0,R4,#+24
        BPL.N    ??Oled_WrCmd_1
        MOVS     R0,#+1
        BL       Oled_SDA
        B.N      ??Oled_WrCmd_2
//  236   }
//  237   //Oled_CS=1;
//  238 }
??Oled_WrCmd_3:
        POP      {R0,R4,R5,PC}    ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  239 void Oled_Set_Pos(uint8 x, uint8 y)
//  240 { 
Oled_Set_Pos:
        PUSH     {R3-R5,LR}
//  241   uint8 xt,msb,lsb;
//  242   //Oled_WrCmd(0xb0+y);
//  243   //Oled_WrCmd(((x&0xf0)>>4)|0x10);
//  244   //Oled_WrCmd((x&0x0f)|0x01); 
//  245   xt = 1 + x * 6;
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        MOVS     R2,#+6
        MULS     R0,R2,R0
        ADDS     R0,R0,#+1
//  246   lsb = xt % 16;
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        MOVS     R2,#+16
        SDIV     R5,R0,R2
        MLS      R5,R5,R2,R0
//  247   msb = xt / 16 + 0x10;
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        MOVS     R2,#+16
        SDIV     R0,R0,R2
        ADDS     R4,R0,#+16
//  248   Oled_WrCmd(0xb0 + y);
        SUBS     R0,R1,#+80
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       Oled_WrCmd
//  249   Oled_WrCmd(lsb);
        MOVS     R0,R5
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       Oled_WrCmd
//  250   Oled_WrCmd(msb); 
        MOVS     R0,R4
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       Oled_WrCmd
//  251 } 
        POP      {R0,R4,R5,PC}    ;; return
//  252 
//  253 // --- Hardware Interface ---
//  254 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  255 void Oled_SCL(u8 x){                     //d0
//  256   if(x)
Oled_SCL:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BEQ.N    ??Oled_SCL_0
//  257     PTC->PSOR |= 1<<15;
        LDR.N    R0,??DataTable5_6  ;; 0x400ff084
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8000
        LDR.N    R1,??DataTable5_6  ;; 0x400ff084
        STR      R0,[R1, #+0]
        B.N      ??Oled_SCL_1
//  258   else
//  259     PTC->PCOR |= 1<<15;
??Oled_SCL_0:
        LDR.N    R0,??DataTable5_7  ;; 0x400ff088
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8000
        LDR.N    R1,??DataTable5_7  ;; 0x400ff088
        STR      R0,[R1, #+0]
//  260 }
??Oled_SCL_1:
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  261 void Oled_SDA(u8 x){                             //d1
//  262   if(x)
Oled_SDA:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BEQ.N    ??Oled_SDA_0
//  263     PTC->PSOR |= 1<<14;
        LDR.N    R0,??DataTable5_6  ;; 0x400ff084
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x4000
        LDR.N    R1,??DataTable5_6  ;; 0x400ff084
        STR      R0,[R1, #+0]
        B.N      ??Oled_SDA_1
//  264   else
//  265     PTC->PCOR |= 1<<14;
??Oled_SDA_0:
        LDR.N    R0,??DataTable5_7  ;; 0x400ff088
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x4000
        LDR.N    R1,??DataTable5_7  ;; 0x400ff088
        STR      R0,[R1, #+0]
//  266 }
??Oled_SDA_1:
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  267 void Oled_RST(u8 x){                     //res
//  268   if(x)
Oled_RST:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BEQ.N    ??Oled_RST_0
//  269     PTC->PSOR |= 1<<13;
        LDR.N    R0,??DataTable5_6  ;; 0x400ff084
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x2000
        LDR.N    R1,??DataTable5_6  ;; 0x400ff084
        STR      R0,[R1, #+0]
        B.N      ??Oled_RST_1
//  270   else
//  271     PTC->PCOR |= 1<<13;
??Oled_RST_0:
        LDR.N    R0,??DataTable5_7  ;; 0x400ff088
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x2000
        LDR.N    R1,??DataTable5_7  ;; 0x400ff088
        STR      R0,[R1, #+0]
//  272 }
??Oled_RST_1:
        BX       LR               ;; return
//  273 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  274 void Oled_DC(u8 x){                      //dc
//  275   if(x)
Oled_DC:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BEQ.N    ??Oled_DC_0
//  276     PTC->PSOR |= 1<<12;
        LDR.N    R0,??DataTable5_6  ;; 0x400ff084
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1000
        LDR.N    R1,??DataTable5_6  ;; 0x400ff084
        STR      R0,[R1, #+0]
        B.N      ??Oled_DC_1
//  277   else
//  278     PTC->PCOR |= 1<<12;
??Oled_DC_0:
        LDR.N    R0,??DataTable5_7  ;; 0x400ff088
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1000
        LDR.N    R1,??DataTable5_7  ;; 0x400ff088
        STR      R0,[R1, #+0]
//  279 }
??Oled_DC_1:
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable5:
        DC32     F6x8

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable5_1:
        DC32     0x4004b030

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable5_2:
        DC32     0x4004b034

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable5_3:
        DC32     0x4004b038

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable5_4:
        DC32     0x4004b03c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable5_5:
        DC32     0x400ff094

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable5_6:
        DC32     0x400ff084

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable5_7:
        DC32     0x400ff088
//  280 
//  281 

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
//  282 const uint8 F6x8[][6] =
F6x8:
        DATA
        DC8 0, 0, 0, 0, 0, 0, 0, 0, 0, 47, 0, 0, 0, 0, 7, 0, 7, 0, 0, 20, 127
        DC8 20, 127, 20, 0, 36, 42, 127, 42, 18, 0, 98, 100, 8, 19, 35, 0, 54
        DC8 73, 85, 34, 80, 0, 0, 5, 3, 0, 0, 0, 0, 28, 34, 65, 0, 0, 0, 65, 34
        DC8 28, 0, 0, 20, 8, 62, 8, 20, 0, 8, 8, 62, 8, 8, 0, 0, 0, 160, 96, 0
        DC8 0, 8, 8, 8, 8, 8, 0, 0, 96, 96, 0, 0, 0, 32, 16, 8, 4, 2, 0, 62, 81
        DC8 73, 69, 62, 0, 0, 66, 127, 64, 0, 0, 66, 97, 81, 73, 70, 0, 33, 65
        DC8 69, 75, 49, 0, 24, 20, 18, 127, 16, 0, 39, 69, 69, 69, 57, 0, 60
        DC8 74, 73, 73, 48, 0, 1, 113, 9, 5, 3, 0, 54, 73, 73, 73, 54, 0, 6, 73
        DC8 73, 41, 30, 0, 0, 54, 54, 0, 0, 0, 0, 86, 54, 0, 0, 0, 8, 20, 34
        DC8 65, 0, 0, 20, 20, 20, 20, 20, 0, 0, 65, 34, 20, 8, 0, 2, 1, 81, 9
        DC8 6, 0, 50, 73, 89, 81, 62, 0, 124, 18, 17, 18, 124, 0, 127, 73, 73
        DC8 73, 54, 0, 62, 65, 65, 65, 34, 0, 127, 65, 65, 34, 28, 0, 127, 73
        DC8 73, 73, 65, 0, 127, 9, 9, 9, 1, 0, 62, 65, 73, 73, 122, 0, 127, 8
        DC8 8, 8, 127, 0, 0, 65, 127, 65, 0, 0, 32, 64, 65, 63, 1, 0, 127, 8
        DC8 20, 34, 65, 0, 127, 64, 64, 64, 64, 0, 127, 2, 12, 2, 127, 0, 127
        DC8 4, 8, 16, 127, 0, 62, 65, 65, 65, 62, 0, 127, 9, 9, 9, 6, 0, 62, 65
        DC8 81, 33, 94, 0, 127, 9, 25, 41, 70, 0, 70, 73, 73, 73, 49, 0, 1, 1
        DC8 127, 1, 1, 0, 63, 64, 64, 64, 63, 0, 31, 32, 64, 32, 31, 0, 63, 64
        DC8 56, 64, 63, 0, 99, 20, 8, 20, 99, 0, 7, 8, 112, 8, 7, 0, 97, 81, 73
        DC8 69, 67, 0, 0, 127, 65, 65, 0, 0, 85, 42, 85, 42, 85, 0, 0, 65, 65
        DC8 127, 0, 0, 4, 2, 1, 2, 4, 0, 64, 64, 64, 64, 64, 0, 0, 1, 2, 4, 0
        DC8 0, 32, 84, 84, 84, 120, 0, 127, 72, 68, 68, 56, 0, 56, 68, 68, 68
        DC8 32, 0, 56, 68, 68, 72, 127, 0, 56, 84, 84, 84, 24, 0, 8, 126, 9, 1
        DC8 2, 0, 24, 164, 164, 164, 124, 0, 127, 8, 4, 4, 120, 0, 0, 68, 125
        DC8 64, 0, 0, 64, 128, 132, 125, 0, 0, 127, 16, 40, 68, 0, 0, 0, 65
        DC8 127, 64, 0, 0, 124, 4, 24, 4, 120, 0, 124, 8, 4, 4, 120, 0, 56, 68
        DC8 68, 68, 56, 0, 252, 36, 36, 36, 24, 0, 24, 36, 36, 24, 252, 0, 124
        DC8 8, 4, 4, 8, 0, 72, 84, 84, 84, 32, 0, 4, 63, 68, 64, 32, 0, 60, 64
        DC8 64, 32, 124, 0, 28, 32, 64, 32, 28, 0, 60, 64, 48, 64, 60, 0, 68
        DC8 40, 16, 40, 68, 0, 28, 160, 160, 160, 124, 0, 68, 100, 84, 76, 68
        DC8 20, 20, 20, 20, 20, 20

        SECTION `.iar_vfe_header`:DATA:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        END
//  283 {
//  284     { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },   // sp
//  285     { 0x00, 0x00, 0x00, 0x2f, 0x00, 0x00 },   // !
//  286     { 0x00, 0x00, 0x07, 0x00, 0x07, 0x00 },   // "
//  287     { 0x00, 0x14, 0x7f, 0x14, 0x7f, 0x14 },   // #
//  288     { 0x00, 0x24, 0x2a, 0x7f, 0x2a, 0x12 },   // $
//  289     { 0x00, 0x62, 0x64, 0x08, 0x13, 0x23 },   // %
//  290     { 0x00, 0x36, 0x49, 0x55, 0x22, 0x50 },   // &
//  291     { 0x00, 0x00, 0x05, 0x03, 0x00, 0x00 },   // '
//  292     { 0x00, 0x00, 0x1c, 0x22, 0x41, 0x00 },   // (
//  293     { 0x00, 0x00, 0x41, 0x22, 0x1c, 0x00 },   // )
//  294     { 0x00, 0x14, 0x08, 0x3E, 0x08, 0x14 },   // *
//  295     { 0x00, 0x08, 0x08, 0x3E, 0x08, 0x08 },   // +
//  296     { 0x00, 0x00, 0x00, 0xA0, 0x60, 0x00 },   // ,
//  297     { 0x00, 0x08, 0x08, 0x08, 0x08, 0x08 },   // -
//  298     { 0x00, 0x00, 0x60, 0x60, 0x00, 0x00 },   // .
//  299     { 0x00, 0x20, 0x10, 0x08, 0x04, 0x02 },   // /
//  300     { 0x00, 0x3E, 0x51, 0x49, 0x45, 0x3E },   // 0 16
//  301     { 0x00, 0x00, 0x42, 0x7F, 0x40, 0x00 },   // 1
//  302     { 0x00, 0x42, 0x61, 0x51, 0x49, 0x46 },   // 2
//  303     { 0x00, 0x21, 0x41, 0x45, 0x4B, 0x31 },   // 3
//  304     { 0x00, 0x18, 0x14, 0x12, 0x7F, 0x10 },   // 4
//  305     { 0x00, 0x27, 0x45, 0x45, 0x45, 0x39 },   // 5
//  306     { 0x00, 0x3C, 0x4A, 0x49, 0x49, 0x30 },   // 6
//  307     { 0x00, 0x01, 0x71, 0x09, 0x05, 0x03 },   // 7
//  308     { 0x00, 0x36, 0x49, 0x49, 0x49, 0x36 },   // 8
//  309     { 0x00, 0x06, 0x49, 0x49, 0x29, 0x1E },   // 9
//  310     { 0x00, 0x00, 0x36, 0x36, 0x00, 0x00 },   // :
//  311     { 0x00, 0x00, 0x56, 0x36, 0x00, 0x00 },   // ;
//  312     { 0x00, 0x08, 0x14, 0x22, 0x41, 0x00 },   // <
//  313     { 0x00, 0x14, 0x14, 0x14, 0x14, 0x14 },   // =
//  314     { 0x00, 0x00, 0x41, 0x22, 0x14, 0x08 },   // >
//  315     { 0x00, 0x02, 0x01, 0x51, 0x09, 0x06 },   // ?
//  316     { 0x00, 0x32, 0x49, 0x59, 0x51, 0x3E },   // @
//  317     { 0x00, 0x7C, 0x12, 0x11, 0x12, 0x7C },   // A
//  318     { 0x00, 0x7F, 0x49, 0x49, 0x49, 0x36 },   // B
//  319     { 0x00, 0x3E, 0x41, 0x41, 0x41, 0x22 },   // C
//  320     { 0x00, 0x7F, 0x41, 0x41, 0x22, 0x1C },   // D
//  321     { 0x00, 0x7F, 0x49, 0x49, 0x49, 0x41 },   // E
//  322     { 0x00, 0x7F, 0x09, 0x09, 0x09, 0x01 },   // F
//  323     { 0x00, 0x3E, 0x41, 0x49, 0x49, 0x7A },   // G
//  324     { 0x00, 0x7F, 0x08, 0x08, 0x08, 0x7F },   // H
//  325     { 0x00, 0x00, 0x41, 0x7F, 0x41, 0x00 },   // I
//  326     { 0x00, 0x20, 0x40, 0x41, 0x3F, 0x01 },   // J
//  327     { 0x00, 0x7F, 0x08, 0x14, 0x22, 0x41 },   // K
//  328     { 0x00, 0x7F, 0x40, 0x40, 0x40, 0x40 },   // L
//  329     { 0x00, 0x7F, 0x02, 0x0C, 0x02, 0x7F },   // M
//  330     { 0x00, 0x7F, 0x04, 0x08, 0x10, 0x7F },   // N
//  331     { 0x00, 0x3E, 0x41, 0x41, 0x41, 0x3E },   // O
//  332     { 0x00, 0x7F, 0x09, 0x09, 0x09, 0x06 },   // P
//  333     { 0x00, 0x3E, 0x41, 0x51, 0x21, 0x5E },   // Q
//  334     { 0x00, 0x7F, 0x09, 0x19, 0x29, 0x46 },   // R
//  335     { 0x00, 0x46, 0x49, 0x49, 0x49, 0x31 },   // S
//  336     { 0x00, 0x01, 0x01, 0x7F, 0x01, 0x01 },   // T
//  337     { 0x00, 0x3F, 0x40, 0x40, 0x40, 0x3F },   // U
//  338     { 0x00, 0x1F, 0x20, 0x40, 0x20, 0x1F },   // V
//  339     { 0x00, 0x3F, 0x40, 0x38, 0x40, 0x3F },   // W
//  340     { 0x00, 0x63, 0x14, 0x08, 0x14, 0x63 },   // X
//  341     { 0x00, 0x07, 0x08, 0x70, 0x08, 0x07 },   // Y
//  342     { 0x00, 0x61, 0x51, 0x49, 0x45, 0x43 },   // Z
//  343     { 0x00, 0x00, 0x7F, 0x41, 0x41, 0x00 },   // [
//  344     { 0x00, 0x55, 0x2A, 0x55, 0x2A, 0x55 },   // 55
//  345     { 0x00, 0x00, 0x41, 0x41, 0x7F, 0x00 },   // ]
//  346     { 0x00, 0x04, 0x02, 0x01, 0x02, 0x04 },   // ^
//  347     { 0x00, 0x40, 0x40, 0x40, 0x40, 0x40 },   // _
//  348     { 0x00, 0x00, 0x01, 0x02, 0x04, 0x00 },   // '
//  349     { 0x00, 0x20, 0x54, 0x54, 0x54, 0x78 },   // a
//  350     { 0x00, 0x7F, 0x48, 0x44, 0x44, 0x38 },   // b
//  351     { 0x00, 0x38, 0x44, 0x44, 0x44, 0x20 },   // c
//  352     { 0x00, 0x38, 0x44, 0x44, 0x48, 0x7F },   // d
//  353     { 0x00, 0x38, 0x54, 0x54, 0x54, 0x18 },   // e
//  354     { 0x00, 0x08, 0x7E, 0x09, 0x01, 0x02 },   // f
//  355     { 0x00, 0x18, 0xA4, 0xA4, 0xA4, 0x7C },   // g
//  356     { 0x00, 0x7F, 0x08, 0x04, 0x04, 0x78 },   // h
//  357     { 0x00, 0x00, 0x44, 0x7D, 0x40, 0x00 },   // i
//  358     { 0x00, 0x40, 0x80, 0x84, 0x7D, 0x00 },   // j
//  359     { 0x00, 0x7F, 0x10, 0x28, 0x44, 0x00 },   // k
//  360     { 0x00, 0x00, 0x41, 0x7F, 0x40, 0x00 },   // l
//  361     { 0x00, 0x7C, 0x04, 0x18, 0x04, 0x78 },   // m
//  362     { 0x00, 0x7C, 0x08, 0x04, 0x04, 0x78 },   // n
//  363     { 0x00, 0x38, 0x44, 0x44, 0x44, 0x38 },   // o
//  364     { 0x00, 0xFC, 0x24, 0x24, 0x24, 0x18 },   // p
//  365     { 0x00, 0x18, 0x24, 0x24, 0x18, 0xFC },   // q
//  366     { 0x00, 0x7C, 0x08, 0x04, 0x04, 0x08 },   // r
//  367     { 0x00, 0x48, 0x54, 0x54, 0x54, 0x20 },   // s
//  368     { 0x00, 0x04, 0x3F, 0x44, 0x40, 0x20 },   // t
//  369     { 0x00, 0x3C, 0x40, 0x40, 0x20, 0x7C },   // u
//  370     { 0x00, 0x1C, 0x20, 0x40, 0x20, 0x1C },   // v
//  371     { 0x00, 0x3C, 0x40, 0x30, 0x40, 0x3C },   // w
//  372     { 0x00, 0x44, 0x28, 0x10, 0x28, 0x44 },   // x
//  373     { 0x00, 0x1C, 0xA0, 0xA0, 0xA0, 0x7C },   // y
//  374     { 0x00, 0x44, 0x64, 0x54, 0x4C, 0x44 },   // z
//  375     { 0x14, 0x14, 0x14, 0x14, 0x14, 0x14 }    // horiz lines
//  376 };
// 
//   552 bytes in section .rodata
// 1 164 bytes in section .text
// 
// 1 164 bytes of CODE  memory
//   552 bytes of CONST memory
//
//Errors: none
//Warnings: none
