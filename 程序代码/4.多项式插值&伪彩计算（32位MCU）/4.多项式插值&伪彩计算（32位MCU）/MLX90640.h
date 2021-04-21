#ifndef _MLX640_API_H
#define _MLX640_API_H
#include "cpu.h"

typedef struct
    {
        SINT16 kVdd;
        SINT16 vdd25;
        float KvPTAT;
        float KtPTAT;
        UINT16 vPTAT25;
        float alphaPTAT;
        SINT16 gainEE;
        float tgc;
        float cpKv;
        float cpKta;
        UINT8 resolutionEE;
        UINT8 calibrationModeEE;
        float KsTa;
        float ksTo[4];
        SINT16 ct[4];
        float alpha[768];    
        SINT16 offset[768];    
        float kta[768];    
        float kv[768];
        float cpAlpha[2];
        SINT16 cpOffset[2];
        float ilChessC[3]; 
        UINT16 brokenPixels[5];
        UINT16 outlierPixels[5];  
    } paramsMLX90640;
	
#define	MLX_Addr	0x66

void MLX90640_I2CInit(void);
UINT8 MLX90640_I2CRead(UINT16 startAddress, UINT16 nWordsRead, UINT16 *datas);
UINT8 MLX90640_I2CWrite(UINT16 writeAddress, UINT16 word);
SINT8 MLX90640_DataReady(void);
void MLX90640_SetResolution(UINT8 resolution);
UINT8 MLX90640_GetCurResolution(void);
void MLX90640_SetRefreshRate(UINT8 refreshRate);
UINT8 MLX90640_GetRefreshRate(void);
void MLX90640_SetArrangeMode(UINT8 mode);
UINT8 MLX90640_GetArrangeMode(void);

UINT16 MLX90640_ExtractParameters(UINT16 *eeData, paramsMLX90640 *mlx90640);
float MLX90640_GetVdd(UINT16 *frameData, const paramsMLX90640 *params);
float MLX90640_GetTa(UINT16 *frameData, const paramsMLX90640 *params);
void MLX90640_CalculateTo(UINT16 *frameData, const paramsMLX90640 *params, float emissivity, float tr, float *result);
void MLX90640_GetImage(UINT16 *frameData, const paramsMLX90640 *params, float *result);
void MLX90640_BadPixelsCorrection(UINT16 *pixels, float *to, int mode, paramsMLX90640 *params);	
#endif
