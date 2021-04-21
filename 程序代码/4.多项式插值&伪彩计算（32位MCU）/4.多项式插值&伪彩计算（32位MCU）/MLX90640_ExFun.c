/********************************************************************
**                           包含头文件
********************************************************************/
#include "MLX90640_ExFun.h"
#include <math.h>


//多项式求模型求解（计算多项式各项系数）
void CalcPolyCoe(float *x,float *y,UINT8 termsCount,float *coes)
{
	if ((termsCount<2) || (termsCount>4))
        termsCount=2;
	if (termsCount==2)
	{
		coes[1]=(y[1]-y[0])/x[1];
        coes[0]=y[0];
	}
	else if (termsCount==3)
	{
		coes[2]=((y[2]-y[0])*x[1]-(y[1]-y[0])*x[2])/(x[1]*x[2]*x[2]-x[1]*x[1]*x[2]);
        coes[1]=(y[1]-y[0])/x[1]-coes[2]*x[1];
        coes[0]=y[0];
	}
	else if (termsCount==4)
	{
		coes[3]=((y[3]-y[0])*x[1]-(y[1]-y[0])*x[3])/x[1]-((y[2]-y[0])*x[1]-(y[1]-y[0])*x[2])/(x[1]*x[2]*x[2]-x[1]*x[1]*x[2])*(x[1]*x[3]*x[3]-x[1]*x[1]*x[3])/x[1];
        coes[3]=coes[3]/((x[1]*x[3]*x[3]*x[3]-x[1]*x[1]*x[1]*x[3])/x[1]-(x[1]*x[2]*x[2]*x[2]-x[1]*x[1]*x[1]*x[2])/(x[1]*x[2]*x[2]-x[1]*x[1]*x[2])*(x[1]*x[3]*x[3]-x[1]*x[1]*x[3])/x[1]);
        coes[2]=((y[2]-y[0])*x[1]-(y[1]-y[0])*x[2])/(x[1]*x[2]*x[2]-x[1]*x[1]*x[2])-coes[3]*((x[1]*x[2]*x[2]*x[2]-x[1]*x[1]*x[1]*x[2])/(x[1]*x[2]*x[2]-x[1]*x[1]*x[2]));
        coes[1]=((y[1]-y[0])-coes[2]*x[1]*x[1]-coes[3]*x[1]*x[1]*x[1])/x[1];
        coes[0]=y[0];
	}
}

//一维数组插值
void PolynomialInterpolationArr(float *SourceDatas,UINT32 datsCount,UINT8 Dir,UINT8 termsCount,float *TarGetDatas)
{
	UINT32 i,j;
    UINT16 startIndex;
    float OriginX[4];
	float OriginY[4];
    float tempDou;
    float coes[4];
	
	//源数据复制到目标数组Result
	if (Dir==0)	startIndex=2;
    else		startIndex=1;	
    for (i=0;i<datsCount;i++)
    {
        TarGetDatas[startIndex+i*4]=SourceDatas[i];
    }
	
	//插值，插值完成后是*4像素
    for (i=0;i<=datsCount-termsCount;i++)
    {
        for (j=0;j<termsCount;j++)//初始化拟合原始数据(从第i点开始，向后取j个数作为Y[]值)
        {
            OriginX[j]=j*4;
            OriginY[j]=SourceDatas[i+j];
        }
		CalcPolyCoe(OriginX,OriginY,termsCount,coes);
        //插值
        for (j=1;j<4;j++)
        {
            if (termsCount>=2)	tempDou=coes[0]+j*coes[1];
            if (termsCount>=3)	tempDou=tempDou+j*j*coes[2];
            if (termsCount>=4)	tempDou=tempDou+j*j*j*coes[3];

            TarGetDatas[startIndex+i*4+j]=tempDou;
        }
    }
	
	//两端插值，两端插值直接使用线性插值（一次多项式）
    //前端插值
    OriginX[0]=0;
    OriginY[0]=SourceDatas[0];
    OriginX[1]=4;
    OriginY[1]=SourceDatas[1];
	CalcPolyCoe(OriginX,OriginY,2,coes);
    if (Dir==0)
    {
        tempDou=coes[0]+(-1)*coes[1];
        TarGetDatas[1]=tempDou;
        tempDou=coes[0]+(-2)*coes[1];
        TarGetDatas[0]=tempDou;
    }
    else
    {
        tempDou=coes[0]+(-1)*coes[1];
        TarGetDatas[0]=tempDou;
    }
	//末端插值
    for (i=(datsCount-termsCount);i<=(datsCount-2);i++)
    {
        for (j=0;j<2;j++)//初始化拟合原始数据
        {
            OriginX[j]=j*4;
            OriginY[j]=SourceDatas[i+j];
        }
		CalcPolyCoe(OriginX,OriginY,2,coes);
        //插值
        for (j=1;j<4;j++)
        {
            tempDou=coes[0]+j*coes[1];
            TarGetDatas[startIndex+i*4+j]=tempDou;
        }
    }
    if (Dir==0)
    {
        tempDou=coes[0]+(5)*coes[1];
        TarGetDatas[datsCount*4-1]=tempDou;
    }
    else
    {
        tempDou=coes[0]+(5)*coes[1];
        TarGetDatas[datsCount*4-2]=tempDou;
        tempDou=coes[0]+(6)*coes[1];
        TarGetDatas[datsCount*4-1]=tempDou;
    }
}

/********************************************************************
** 函数名称:		TemperatureToRGB
** 功能描述:		插值，插值完成后是原行列数量的4倍
** 参    数:		*SourceDatas插值前的原数据序列
**					colCount	原数据序列数
**					rowCount	原数据序行数
**					Dir			两端插值数量设置
**								0:开始2个，末尾1个
**								1:开始1个，末尾2个
**					termsCount	多项式项数
**								2~4代表两项式、三项式和四项式(1次幂、2次幂、3次幂)
**					*ResultDatas插值完成后的数据序列
**								数据数量是插值前的16位，即：行数量*4，列数量*4
** 返 回 值:		无
********************************************************************/
void PolynomialInterpolation_Matrix(float *SourceDatas,UINT16 colCount,UINT16 rowCount,UINT8 Dir,UINT8 termsCount,float *ResultDatas)
{
	UINT32 i,j;
	float OriginDatas[128],TargetDatas[512];
	
	//逐行插值
    for (i=0;i<rowCount;i++)//第i行
    {
		for (j=0;j<colCount;j++)//取出第i行数据
		{
			OriginDatas[j]=SourceDatas[i*colCount+j];
		}
		PolynomialInterpolationArr(OriginDatas,colCount,Dir,termsCount,TargetDatas);
		for (j=0;j<colCount*4;j++)
		{
			ResultDatas[i*4*colCount+j]=TargetDatas[j];
		}
	}
	//以上代码完成后，ResultDatas内是rowCount行，每行是colCount*4列
	//逐列插值
    for (i=0;i<colCount*4;i++)
    {
        for (j=0;j<rowCount;j++)//取出第i列数据
		{
			OriginDatas[j]=ResultDatas[j*colCount*4+i];
		}
		PolynomialInterpolationArr(OriginDatas,rowCount,Dir,termsCount,TargetDatas);
		for (j=0;j<rowCount*4;j++)
		{
			ResultDatas[j*colCount*4+i]=TargetDatas[j];
		}
    }
}

UINT8 TemperatureToGray(float tempValue,float lowerLimit,float UpperLimit)
{
	float tempDou;
	
	if (tempValue<=lowerLimit)	return 0;
	if (tempValue>=UpperLimit)	return 255;
	
	tempDou=fabs(tempValue-lowerLimit);
	tempDou/=fabs(UpperLimit-lowerLimit);
	tempDou*=255;
	
	return (UINT8)tempDou;
}
void GrayToRGB(UINT8 grayValue,UINT8 *rgb)
{
	if (grayValue<=63)
	{
		rgb[0]=0;
		rgb[1]=0;
		rgb[2]=(UINT8)((float)grayValue*255/64);
	}
	else if ((grayValue>=64) && (grayValue<=127))
	{
		rgb[0]=0;
		rgb[1]=(UINT8)((float)(grayValue-64)*255/64);
		rgb[2]=(UINT8)((float)(127-grayValue)*255/64);
	}
	else if ((grayValue>=128) && (grayValue<=191))
	{
		rgb[0]=(UINT8)((float)(grayValue-128)*255/64);
		rgb[1]=255;
		rgb[2]=0;
	}
	else if ((grayValue>=192) && (grayValue<=255))
	{
		rgb[0]=255;
		rgb[1]=(UINT8)((float)(255-grayValue)*255/64);
		rgb[2]=0;
	}
}

/********************************************************************
** 函数名称:		TemperatureToRGB
** 功能描述:		温度值转换为颜色值
** 参    数:		tempValue	温度值
**					lowerLimit	温度下限参考值
**					UpperLimit	温度上限参考值
**					*color		计算完成的颜色数据,4个字节
**								[0]:颜色灰度值
**								[1]:由灰度转换为彩色，R值
**								[2]:由灰度转换为彩色，G值
**								[3]:由灰度转换为彩色，B值
** 返 回 值:		无
********************************************************************/
void TemperatureToRGB(float tempValue,float lowerLimit,float UpperLimit,UINT8 *color)
{	
	color[0]=TemperatureToGray(tempValue,lowerLimit,UpperLimit);
	GrayToRGB(color[0],&color[1]);
}

/********************************************************************
**                            End Of File
********************************************************************/


