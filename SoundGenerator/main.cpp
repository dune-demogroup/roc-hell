/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   main.cpp
 * Author: fanch le fraka
 *
 * Created on 27 juillet 2019, 14:57
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
typedef unsigned long long int  uint64;
typedef unsigned int            uint32;
typedef unsigned short          uint16;
typedef unsigned char           uint8;
typedef long long int           int64;
typedef int                     int32;
typedef short                   int16;
typedef char                    int8;

//file format:
//header:
//	sound_count*sizeof(uint16) -> offsets to a sound
//per sound:
//	uint16 sound size ("samples" count)
//	per sample
//		uint8 note/noise :	~0 = mute
//							~1 = note
//							~8 = noise
//							~9 = note+noise
//		uint8 volume : 4bits (0->15)
//		uint8 fine tune
//		uint8 course tune (4bits)

int main(int argc, char** argv)
{
    static uint8 datas[65536];
    uint32 nb_sounds = 16;
    uint16 data_idx = nb_sounds * sizeof(uint16);
    uint8* header = datas;
    
    uint16 sound_size;
	float base_freq;
//son prise de diamant/objet
	sound_size = 32;
    header[0] = data_idx >> 8;
    header[1] = data_idx & 0xFF;
    header += 2;
    datas[data_idx] = ((sound_size * 4)) >> 8;
    data_idx++;
    datas[data_idx] = ((sound_size * 4)) & 0xFF;
    data_idx++;
    base_freq = 32;
    for (uint32 i = 0;i < sound_size;i++)
    {
        datas[data_idx] = ~0x1;
        data_idx++;
        datas[data_idx] = 15 - (i & 7);
        data_idx++;
        uint16 df = (uint16)(base_freq + fabsf(cosf(i * 3.14159 * 16 / (float)sound_size)) * 16);
        datas[data_idx] = df & 0xFF;
        data_idx++;
        datas[data_idx] = df >> 8;
        data_idx++;
    }
//son pierre qui tombe
    sound_size = 8;
    header[0] = data_idx >> 8;
    header[1] = data_idx & 0xFF;
    header += 2;
    datas[data_idx] = ((sound_size * 4)) >> 8;
    data_idx++;
    datas[data_idx] = ((sound_size * 4)) & 0xFF;
    data_idx++;
    base_freq = 1800;
    for (uint32 i = 0;i < sound_size;i++)
    {
        datas[data_idx] = i > 4 ? ~0x9 : ~0x1;
        data_idx++;
        datas[data_idx] = i & 1 ? 15 : 7;
        data_idx++;
        uint16 df = (uint16)(base_freq + fabsf(cosf(i * 3.14159 * 8 / (float)sound_size)) * 16);
        datas[data_idx] = df & 0xFF;
        data_idx++;
        datas[data_idx] = df >> 8;
        data_idx++;
    }
//son marche 
	sound_size = 60;
    header[0] = data_idx >> 8;
    header[1] = data_idx & 0xFF;
    header += 2;
    datas[data_idx] = ((sound_size * 4)) >> 8;
    data_idx++;
    datas[data_idx] = ((sound_size * 4)) & 0xFF;
    data_idx++;
    base_freq = 2000;
    for (uint32 i = 0;i < sound_size;i++)
    {
        uint32 n = i % 10;
        datas[data_idx] = n < 1 ? ~0x9 : ~0x1;
        data_idx++;
        datas[data_idx] = n < 2 ? 8 + (rand() & 7) : 0;
        data_idx++;
        uint16 df = (uint16)(base_freq + fabsf(cosf(i * 3.14159 * 8 / (float)sound_size)) * 256);
        datas[data_idx] = df & 0xFF;
        data_idx++;
        datas[data_idx] = df >> 8;
        data_idx++;
    }
//son explosion
    sound_size = 8;
    header[0] = data_idx >> 8;
    header[1] = data_idx & 0xFF;
    header += 2;
    datas[data_idx] = ((sound_size * 4)) >> 8;
    data_idx++;
    datas[data_idx] = ((sound_size * 4)) & 0xFF;
    data_idx++;
    base_freq = 500;
    for (uint32 i = 0;i < sound_size;i++)
    {
        datas[data_idx] = i > 4 ? ~0x8 : ~0x9;
        data_idx++;
        datas[data_idx] = i & 1 ? 15 : 7;
        data_idx++;
        uint16 df = base_freq;
        datas[data_idx] = df & 0xFF;
        data_idx++;
        datas[data_idx] = df >> 8;
        data_idx++;
    }
	
//son fin de niveau
    sound_size = 120;
    header[0] = data_idx >> 8;
    header[1] = data_idx & 0xFF;
    header += 2;
    datas[data_idx] = ((sound_size * 4)) >> 8;
    data_idx++;
    datas[data_idx] = ((sound_size * 4)) & 0xFF;
    data_idx++;
    base_freq = 800;
    for (uint32 i = 0;i < sound_size;i++)
    {
        datas[data_idx] = ~0x1;
        data_idx++;
        datas[data_idx] = 0xF;
        data_idx++;
		uint32 n = i / 5;
        uint16 df = base_freq - (((n % 3) * 100) + (n / 3) * 40);
        datas[data_idx] = df & 0xFF;
        data_idx++;
        datas[data_idx] = df >> 8;
        data_idx++;
    }

//son porte ouverte
    sound_size = 20;
    header[0] = data_idx >> 8;
    header[1] = data_idx & 0xFF;
    header += 2;
    datas[data_idx] = ((sound_size * 4)) >> 8;
    data_idx++;
    datas[data_idx] = ((sound_size * 4)) & 0xFF;
    data_idx++;
    base_freq = 0;
    for (uint32 i = 0;i < sound_size;i++)
    {
        datas[data_idx] = ~0x1;
        data_idx++;
        datas[data_idx] = 0xF;
        data_idx++;
		uint32 n = i % 3;
        uint16 df = base_freq + n * 64;
        datas[data_idx] = df & 0xFF;
        data_idx++;
        datas[data_idx] = df >> 8;
        data_idx++;
    }	

//son amoeba
    sound_size = 60;
    header[0] = data_idx >> 8;
    header[1] = data_idx & 0xFF;
    header += 2;
    datas[data_idx] = ((sound_size * 4)) >> 8;
    data_idx++;
    datas[data_idx] = ((sound_size * 4)) & 0xFF;
    data_idx++;
    base_freq = 400;
	
    for (uint32 i = 0;i < sound_size;i++)
    {
        datas[data_idx] = ~0x1;
        data_idx++;
        datas[data_idx] = (uint8)(11 + cos(i *3.14159 * 20 / sound_size));
        data_idx++;
		if ((i % 5) == 0)
		{
			base_freq = 200 + (rand() & 0xff);
		}
        uint16 df = base_freq;
        datas[data_idx] = df & 0xFF;
        data_idx++;
        datas[data_idx] = df >> 8;
        data_idx++;
    }
    header[0] = data_idx >> 8;
    header[1] = data_idx & 0xFF;
    header += 2;
    header[0] = data_idx >> 8;
    header[1] = data_idx & 0xFF;
    header += 2;
    header[0] = data_idx >> 8;
    header[1] = data_idx & 0xFF;
    header += 2;
    header[0] = data_idx >> 8;
    header[1] = data_idx & 0xFF;
    header += 2;
    header[0] = data_idx >> 8;
    header[1] = data_idx & 0xFF;
    header += 2;
    header[0] = data_idx >> 8;
    header[1] = data_idx & 0xFF;
    header += 2;
    header[0] = data_idx >> 8;
    header[1] = data_idx & 0xFF;
    header += 2;
    header[0] = data_idx >> 8;
    header[1] = data_idx & 0xFF;
    header += 2;
    header[0] = data_idx >> 8;
    header[1] = data_idx & 0xFF;
    header += 2;
    datas[data_idx] = ((sound_size * 4)) >> 8;
    data_idx++;
    datas[data_idx] = ((sound_size * 4)) & 0xFF;
    data_idx++;	
    FILE* file = fopen("../ST/sound.bnk", "wb");
    fwrite(datas, data_idx, 1, file);
    fclose(file);
    return 0;
}

