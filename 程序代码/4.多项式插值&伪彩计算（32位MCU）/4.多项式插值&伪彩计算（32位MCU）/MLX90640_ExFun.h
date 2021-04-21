#ifndef _MLX640_EX_H
#define _MLX640_EX_H
#include "cpu.h"

void PolynomialInterpolation_Matrix(float *SourceDatas,UINT16 colCount,UINT16 rowCount,UINT8 Dir,UINT8 termsCount,float *ResultDatas);
void TemperatureToRGB(float tempValue,float lowerLimit,float UpperLimit,UINT8 *rgb);

#endif
