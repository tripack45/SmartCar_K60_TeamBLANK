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

#define SPD_FLASH_INDEX 1
#define DIR_FLASH_INDEX 3
#define END_FLASH_INDEX 13

void Debug_Init();

void ExecuteDebugCommand(u8 CmdNumber, u8* para);

void DebugDeadlock();

void LoadVariable();
void SaveVariable();

void UI_Debug();
#endif