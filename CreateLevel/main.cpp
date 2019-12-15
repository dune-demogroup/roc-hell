#include <stdio.h>
#include <stdlib.h>
#define TYPE_NULL 0
#define TYPE_BRICK		2
#define TYPE_ANT		3
#define TYPE_ROCK		4
#define TYPE_DIAMOND		5
#define TYPE_DOOR		 6
#define TYPE_FIREFLIES		7
#define TYPE_DOOR_OPEN	 8
#define TYPE_EXPLODE	 9
#define TYPE_BUTTERFLIES	 10
#define TYPE_AMOEBA			 11
#define TYPE_BORDERBRICK	 12
#define TYPE_MAGIC_BRICK		13


typedef unsigned long long int  uint64;
typedef unsigned int            uint32;
typedef unsigned short          uint16;
typedef unsigned char           uint8;
typedef long long int           int64;
typedef int                     int32;
typedef short                   int16;
typedef char                    int8;
static uint8 Level[64*256];
static void SaveType(FILE* file, uint8 type)
{
    uint16 count = 0;
    for (uint32 i = 0;i < 64 * 256;i++)
    {
        if (Level[i] == type)
        {
            count++;
        }
    }
    uint8 n = count >> 8;
    fwrite(&n, 1, 1, file);
    n = count & 255;
    fwrite(&n, 1, 1, file);
    for (uint16 i = 0;i < 64 * 256;i++)
    {
        if (Level[i] == type)
        {
            n = i >> 8;
            fwrite(&n, 1, 1, file);
            n = i & 255;
            fwrite(&n, 1, 1, file);
        }
    }    
}

int main(int argc, char** argv)
{
    uint8  n[4];
    FILE*  file = fopen("../ST/066.LVL", "wb");
    //version
    n[0] = 0x80;
    n[1] = 0x04;
    fwrite(&n, 2, 1, file);
    //bounds
    n[0] = 64-12;
    n[1] = 256-20;
    fwrite(&n, 2, 1, file);
    //skin
    n[0] = '1';
    fwrite(&n, 1, 1, file);
    //door
    n[0] = 5;
    n[1] = 5;
    fwrite(&n, 2, 1, file);
    //diamond sup
    n[0] = 0;
    fwrite(&n, 1, 1, file);
    //pos ant
    n[0] = 5;
    n[1] = 6;
    fwrite(&n, 2, 1, file);
    uint8 types[] = {TYPE_NULL, TYPE_ROCK, TYPE_ROCK, TYPE_ROCK, TYPE_ROCK, 
                    TYPE_NULL, TYPE_NULL, TYPE_NULL, 
                    TYPE_DIAMOND };
    for (uint16 i = 0;i < 64 * 256;i++)
    {
        uint16 x = i % 256;
        uint16 y = i / 256;
        Level[i] = 1;
        if (x >= 64 || y >= 32)
        {
            continue;
        }
        if (x == 0 || y == 0 || x == 63 || y == 31)
        {
            Level[i] = TYPE_BORDERBRICK;
        }
        else if ((y %  11) == 0 || ((x % 19) == 0))
        {
            Level[i] = TYPE_BRICK;            
        }
        else 
        {
            uint32 n = rand() % 32;
            if (n < sizeof(types))
            {
                Level[i] = types[n];
            }
        }
    }
    SaveType(file, TYPE_NULL);
    SaveType(file, TYPE_BRICK);
    SaveType(file, TYPE_ROCK);
    SaveType(file, TYPE_DIAMOND);
    SaveType(file, TYPE_FIREFLIES);
    SaveType(file, TYPE_BUTTERFLIES);
    SaveType(file, TYPE_AMOEBA);
    SaveType(file, TYPE_BORDERBRICK);
    SaveType(file, TYPE_MAGIC_BRICK);    
    fclose(file);
    
    return 0;
}

