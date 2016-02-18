#ifndef BLUE_TOOTH_H
#define BLUE_TOOTH_H

void Bluetooth_Configure();
void Bluetooth_SendStr(char*);
void Bluetooth_SendDataChunkSync(uint8* chunk_ptr, uint16 size);
void Bluetooth_SendDataChunkAsync(uint8* chunk_ptr, uint16 size);
void Bluetooth_SendDataChunkObselete(u8* chunk_ptr, uint16 size);
int Bluetooth_IsSendDataChunkComplete();
#endif