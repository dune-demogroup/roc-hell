/* 
 * File:   main.cpp
 * Author: fanch le fraka
 *
 * Created on 10 May 2019, 10:07
 */
#include <stdio.h>
#include <cstdlib>
#include <stdint.h>
#define BEGIN_NAMED_ENUM(x)\
	struct E##x {

#define ENUM_MEMBER(x)\
	static const intptr_t x = (const intptr_t) #x;

#define END_NAMED_ENUM(x)\
	}; static E##x x;

BEGIN_NAMED_ENUM(NAmedEnum)
	ENUM_MEMBER(E0)
	ENUM_MEMBER(E1)
	ENUM_MEMBER(E2)
	ENUM_MEMBER(E3)
END_NAMED_ENUM(NAmedEnum)

void TestEnum(intptr_t x)
{
	switch (x)
	{
	case NAmedEnum.E0:
		break;
	case NAmedEnum.E1:
		break;
	case NAmedEnum.E2:
		break;
	case NAmedEnum.E3:
		break;
	default:
		break;
	}
}

typedef unsigned long long int  uint64;
typedef unsigned int            uint32;
typedef unsigned short          uint16;
typedef unsigned char           uint8;
typedef long long int           int64;
typedef int                     int32;
typedef short                   int16;
typedef char                    int8;
static uint16* GetSprite(uint16* dst, const uint16* src, uint32 x, uint32 y, bool reverse)
{
    src += y * 80;
    src += ((x >> 2) & 0xFFFC);
    for (uint32 i = 0;i < 16;i++)
    {
        for (uint32 j = 0;j < 4;j++)
        {
            uint16 x = *src;
            if (reverse)
            {
                int y = 0;
                for (uint16 k = 0;k < 16;k++)
                {
                    y |= ((x & (1 << k)) >> k) << (15 - k);
                }
                x = y;
            }
            *dst = x;
            dst++;
            src++;
        }
        src += 80 - 4;
    }
    return dst;
}

static uint16* GetMask(uint16* dst, const uint16* src, uint32 x, uint32 y, bool reverse)
{
    src += y * 80;
    src += ((x >> 2) & 0xFFFC);
    for (uint32 i = 0;i < 16;i++)
    {
        *dst = 0;
        for (uint32 j = 0;j < 4;j++)
        {
            uint16 x = *src;
            if (reverse)
            {
                int y = 0;
                for (uint16 k = 0;k < 16;k++)
                {
                    y |= ((x & (1 << k)) >> k) << (15 - k);
                }
                x = y;
            }
            *dst |= x;
            src++;
        }
        dst++;
        src += 80 - 4;
    }
    return dst;
}

int main(int argc, char** argv)
{
	static uint8 datas[65536];
	{
		FILE* file = fopen("../ST/r_march.bin", "wb");
		for (uint32 i = 0;i < 1024;i++)
		{
			uint32 n = std::rand();
			fwrite(&n, 1, 1, file);
		}
		fclose(file);
	}
	{
        FILE* file = fopen("INTRO.RST", "rb");
		fread(datas, 6800, 1, file);
        fclose(file);
		uint8* p =  datas + 2 + 8 * 4;
		
		uint32 timerb_param = 0;
        file = fopen("../ST/intro.s", "wb");
		fprintf(file, "intro_palette:\n");
		for (uint32 i = 0;i < 200;i++)
		{
			uint32 y;
			y = (p[0] << 8U) + p[1];
			if (i <= y)
			{
				if (i != 0)
				{
					fprintf(file, "\tclr.b	$fffffa1b.w\n");
					fprintf(file, "\tmove.b #%u,$fffffa21.w\n",  y - timerb_param);
					fprintf(file, "\tmove.b #8,$fffffa1b.w\n");
					fprintf(file, "\tmove.l #.p%u,$120.w\n", y);
					fprintf(file, "\tbclr #0,$fffffa0f.w\n");
					fprintf(file, "\trte\n");					
				}
				fprintf(file, ".p%u", y);
				p += 2;
				for (uint32 j = 0;j < 8;j++)
				{
					uint32 color;
					color = (p[0] << 24U) + (p[1] << 16U) + (p[2] << 8U) + p[3];
					//color = j == 0 ? (color & 0xFFFFU) + i * 0x1010000U : color;
					fprintf(file, "\tmove.l #$%x,$%x.w\n", color, 0xFFFF8240U + j * 4);
					p += 4;
				}
				timerb_param = y;
			}
		}
		fprintf(file, "\tclr.b $fffffa1b.w\n");
		fprintf(file, "\tmove.b #%u,$fffffa21.w\n",  200 - timerb_param);
		p =  datas;
		uint32 y;
		y = (p[0] << 8U) + p[1];
		fprintf(file, "\tmove.b #8,$fffffa1b.w\n");
		fprintf(file, "\tmove.l #.p%u,$120.w\n", y);
		fprintf(file, "\tbclr #0,$fffffa0f.w\n");
		fprintf(file, "\trte\n");					
		fprintf(file, ".p%u", y);
		p += 2;
		for (uint32 j = 0;j < 8;j++)
		{
			uint32 color;
			color = (p[0] << 24U) + (p[1] << 16U) + (p[2] << 8U) + p[3];
			//color = j == 0 ? (color & 0xFFFF) + 0x70000 : color;
			fprintf(file, "\tmove.l #$%x,$%x.w\n", color, 0xFFFF8240U + j * 4);
			p += 4;
		}
		fprintf(file, "\tclr.b $fffffa1b.w\n");
		fprintf(file, "\tbclr #0,$fffffa0F.w\n");
		fprintf(file, "\trte\n");	
		fclose(file);
	}
	{
        FILE* file = fopen("INTRO.PI1", "rb");
        fread(datas, 34, 1, file);
        fread(datas, 32000, 1, file);
        fclose(file);
        file = fopen("../ST/intro.bin", "wb");
        fwrite(datas, 32000, 1, file);
        fclose(file);		
	}
    {
        FILE* file = fopen("MENU.PI1", "rb");
        fread(datas, 2, 1, file);
        fread(datas, 32, 1, file);
        fread(datas + 32, 8 * 320 / 2, 1, file);
        fclose(file);
        file = fopen("../ST/menu.bin", "wb");
        fwrite(datas, 8 * 320 / 2 + 32, 1, file);
        fclose(file);
    }
    {
        FILE* file = fopen("FONT.PI1", "rb");
        fread(datas, 2, 1, file);
        fread(datas, 32, 1, file);
        fread(datas + 32, 8 * 320 / 2, 1, file);
        fclose(file);
        uint8* dst = datas + 32768;
        for (uint32 i = 0;i < 40;i++)
        {
            uint32 idx = i * 8;
            idx &= ~15;
            idx /= 2;
            idx += (i & 1);
            uint8* src = datas + 160 + 32;
            src += idx;
            for (uint32 j = 0;j < 6;j++)
            {
                dst[0] = src[0];
                dst[1] = src[2];
                dst[2] = src[4];
                dst[3] = src[6];
                dst += 4;
                src += 160;
            }
        }
        file = fopen("../ST/font.bin", "wb");
        fwrite(datas, 32, 1, file);
        fwrite(datas + 32768, 4*6*40, 1, file);
        fclose(file);
    }
    for (uint32 n_bnk = 1;n_bnk < 6;n_bnk++)
    {
        uint8* bnk = datas + 32768;
        FILE* file;
        char name[256];
        sprintf(name, "0%i_B.pi1", n_bnk);
        file = fopen(name, "rb");
        fread(bnk, 2, 1, file);
        fread(bnk, 32, 1, file);
        fread(datas, 32000, 1, file);
        fclose(file);
        uint32 x = 0;
        uint32 y = 0;
        uint16* dst = (uint16*)(bnk+32);
        uint16* src = (uint16*)datas;
        
        //0
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16, 0, false);
        }
        //4
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16, 16, false);
        }
        //8
        for (uint32 i = 0;i < 4;i++)
        {
           dst = GetSprite(dst, src, i * 16, 32, false);
        }
        //12
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16, 0, true);
        }
        //16
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16, 48, false);
        }
        //20
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16, 64, false);
        }
        //24
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16, 80, false);
        }
        //28
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16, 96, false);
        }
        //32
        for (uint32 i = 0;i < 6;i++)
        {
            dst = GetSprite(dst, src, i * 16 + 16 * 4, 0, false);
        }
        //38
        dst = GetSprite(dst, src, 16 * 10, 0, false);
        dst = GetSprite(dst, src, 16 * 11, 0, false);
        //40
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16 + 16 * 12, 0, false);
        }
        //44
        dst = GetSprite(dst, src, 16 * 4, 16, false);
        dst = GetSprite(dst, src, 16 * 10, 16, false);
        dst = GetSprite(dst, src, 16 * 11, 16, false);
        //47
        for (uint32 i = 0;i < 5;i++)
        {
            dst = GetSprite(dst, src, i * 16 + 16 * 12, 16, false);
        }
        //52
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16 + 16 * 11, 32, false);
        }
        //56
        dst = GetSprite(dst, src, 16 * 10, 48, false);
        dst = GetSprite(dst, src, 16 * 11, 48, false);
        //58
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16, 112, false);
        }
        //62
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16 + 16 * 10, 64, false);
        }
        //66
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16 + 16 * 5, 16, false);
        }
        //70
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16 + 16 * 10, 80, false);
        }           
        //74
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16 + 16 * 10, 96, false);
        }       
        //78
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16 + 16 * 10, 112, false);
        }    
        //82
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16 + 16 * 10, 128, false);
        }
        
        //86
        for (uint32 i = 0;i < 5;i++)
        {
            dst = GetSprite(dst, src, i * 16 + 16 * 12, 48, false);
        }
        //91
        for (uint32 i = 0;i < 3;i++)
        {
            dst = GetSprite(dst, src, i * 16 + 16 * 14, 64, false);
        }
        //94
        for (uint32 i = 0;i < 2;i++)
        {
            dst = GetSprite(dst, src, i * 16 + 16 * 14, 80, false);
        }
		//96
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16 + 16 * 5, 32, false);
        }
		//100
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16 + 16 * 5, 48, false);
        }
		//104
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16 + 16 * 5, 64, false);
        }
		//108
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16 + 16 * 5, 32, true);
        }		
		//112
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16 + 16 * 5, 80, false);
        }
		//116
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16 + 16 * 5, 96, false);
        }
		//120
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16 + 16 * 5, 112, false);
        }
		//124
        for (uint32 i = 0;i < 4;i++)
        {
            dst = GetSprite(dst, src, i * 16 + 16 * 5, 80, true);
        }


        if (1)//n_bnk == 1)
        {
        //128
            for (uint32 i = 0;i < 16;i++)
            {
                *dst = -1;
                dst++;
            }
            for (uint32 i = 0;i < 4;i++)
            {
                dst = GetMask(dst, src, i * 16, 144, false);
            }        
            for (uint32 i = 0;i < 16;i++)
            {
                *dst = -1;
                dst++;
            }
            for (uint32 i = 0;i < 4;i++)
            {
                dst = GetMask(dst, src, i * 16, 144, false);
            }        
            for (uint32 i = 0;i < 16;i++)
            {
                *dst = -1;
                dst++;
            }
            for (uint32 i = 0;i < 4;i++)
            {
                dst = GetMask(dst, src, i * 16, 144, false);
            }        
            for (uint32 i = 0;i < 16;i++)
            {
                *dst = -1;
                dst++;
            }
            for (uint32 i = 0;i < 4;i++)
            {
                dst = GetMask(dst, src, i * 16, 144, false);
            }        
        }
        else
        {
            dst += 16*4*5;
        }
        uint16 size = (uint16)(((uint8*)dst) - bnk);
        sprintf(name, "../ST/0%i.BNK", n_bnk);
        file = fopen(name, "wb");
        fwrite(bnk, size, 1, file);
        printf("file size: %u\n", size);
        fclose(file);

    }

	return 0;
}

