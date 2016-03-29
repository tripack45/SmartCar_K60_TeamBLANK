#ifndef DEBUG_H
#define DEBUG_H


#define CMDACK 0xA0
#define CMDKILL 0xFF
#define CMDSET_SPD 0xB0
#define CMDSET_DIR 0xC0
#define CMDFASTER 0xD1
#define CMDSLOWER 0xD2
#define CMDLEFT 0xD3
#define CMDRIGHT 0xD4
#define CMDVARPLUS 0xC1
#define CMDVARMINUS 0xC2
#define CMDSAVEPARA 0xCF

extern u8 isDebugging;
extern int16 debugWatch[4];

void Debug_Init();

void ExecuteDebugCommand(u8 CmdNumber, u8* para);

void DebugDeadlock();

void LoadVariable();
void SaveVariable();

void UI_Debug();

void DebugKeyPress1();
void DebugKeyPress2();
void DebugKeyPress3();

#endif