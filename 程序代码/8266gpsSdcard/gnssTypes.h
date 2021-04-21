#include <inttypes.h>
#include <Arduino.h>

#define GPSP_SIZE 18

#define GPRMC 1
#define GPVTG 2
#define GPGGA 3
#define GPGSA 4

#ifndef __GNSSTYPES_H__
#define __GNSSTYPES_H__

/*===================================================struct=========================================================*/
//GPRMC（推荐定位信息数据格式）eg:$GPRMC,,V,,,,,,,,,,N*53  $GPRMC,024813.640,A,3158.4608,N,11848.3737,E,10.05,324.27,150706,,,A*50
typedef struct
{
    //字段1：UTC时间
    uint8_t UTC_Hour = 0;
    uint8_t UTC_Minute = 0;
    uint8_t UTC_Second = 0;
    //字段2：状态，A=定位，V=未定位
    char State = 0;
    //字段3：纬度
    double Latitude = 0.0;
    //字段4：纬度N（北纬）或S（南纬）
    char Ns = 0;
    //字段5：经度
    double Longitude = 0.0;
    //字段6：经度E（东经）或W（西经）
    char Ew = 0;
    //字段7：速度，节，Knots
    double Velocity = 0.0;
    //字段8：方位角，度
    double Azimuth = 0.0;
    //字段9：UTC日期
    uint8_t UTC_Day = 0;
    uint8_t UTC_Month = 0;
    uint16_t UTC_Year = 0;
    //字段10：磁偏角
    double Declination = 0.0;
    //字段11：磁偏角方向，E=东W=西
    char Dew = 0;
    //字段12：模式，A=自动，D=差分，E=估测，N=数据无效（3.0协议内容）
    char Mode = 0;

} xxrmc_t;

//GPVTG（地面速度信息） eg:$GPVTG,,,,,,,,,N*30  $GPVTG,89.68,T,,M,0.00,N,0.0,K*5F
typedef struct
{
    //字段1：运动角度，000 - 359，（前导位数不足则补0）
    double T_Angle = 0.0;
    //字段2：T=真北参照系
    char T_Reference = 'T';
    //字段3：运动角度，000 - 359，（前导位数不足则补0）
    double M_Angle = 0.0;
    //字段4：M=磁北参照系
    char M_Reference = 'M';
    //字段5：水平运动速度（0.00）（前导位数不足则补0）
    double N_Horizontal_Velocity = 0.0;
    //字段6：N=节，Knots
    char Knots = 'N';
    //字段7：水平运动速度（0.00）（前导位数不足则补0）
    double K_Horizontal_Velocity = 0.0;
    //字段8：K=公里/时，km/h
    char Kmh = 'K';

} xxvtg_t;

//GPGGA（定位信息） eg:$GPGGA,,,,,,0,00,99.99,,,,,,*48  $GPGGA,092204.999,4250.5589,S,14718.5084,E,1,04,24.4,12.2,M,19.7,M,,0000*1F
typedef struct
{
    //字段1：UTC 时间，hhmmss.sss，时分秒格式
    uint8_t UTC_Hour = 0;
    uint8_t UTC_Minute = 0;
    uint8_t UTC_Second = 0;
    //字段2：纬度ddmm.mmmm，度分格式（前导位数不足则补0）
    double Latitude = 0.0;
    //字段3：纬度N（北纬）或S（南纬）
    char Ns = 0;
    //字段4：经度dddmm.mmmm，度分格式（前导位数不足则补0）
    double Longitude = 0.0;
    //字段5：经度E（东经）或W（西经）
    char Ew = 0;
    //字段6：GPS状态，0=不可用(FIX NOT valid)，1=单点定位(GPS FIX)，2=差分定位(DGPS)，3=无效PPS，4=实时差分定位（RTK FIX），5=RTK FLOAT，6=正在估算
    uint8_t Fix = 0;
    //字段7：正在使用的卫星数量（00 - 12）（前导位数不足则补0）
    uint8_t S_Num = 0;
    //字段8：HDOP水平精度因子（0.5 - 99.9）
    double HDOP = 0.0;
    //字段9：海拔高度（-9999.9 - 99999.9）
    double Altitude = 0.0;
    //字段10：单位：M（米）
    char Metre = 'M';
    //字段11：地球椭球面相对大地水准面的高度 WGS84水准面划分
    double Level = 0.0;
    //字段12：WGS84水准面划分单位：M（米）
    char Level_Unit = 'M';
    //字段13：差分时间（从接收到差分信号开始的秒数，如果不是差分定位将为空）
    double Diff_Time = 0.0;
    //字段14：差分站ID号0000 - 1023（前导位数不足则补0，如果不是差分定位将为空）
    uint16_t Diff_ID = 0;

} xxgga_t;

//GPGSA（ 当前卫星信息） eg:$GPGSA,A,1,,,,,,,,,,,,,99.99,99.99,99.99*30  $GPGSA,A,3,01,20,19,13,,,,,,,,,40.4,24.4,32.2*0A
typedef struct
{
    //字段1：定位模式(选择2D/3D)，A=自动选择，M=手动选择
    char Mode = 0;
    //字段2：定位类型，1=未定位，2=2D定位，3=3D定位
    uint8_t Type = 0;
    //字段(3-14)：PRN码（伪随机噪声码），(第1信道-第12信道)正在使用的卫星PRN码编号（00）（前导位数不足则补0）
    uint8_t Sno[12] = {0};
    //字段15：PDOP综合位置精度因子（0.5 - 99.9）
    double PDOP = 0.0;
    //字段16：HDOP水平精度因子（0.5 - 99.9）
    double HDOP = 0.0;
    //字段17：VDOP垂直精度因子（0.5 - 99.9）
    double VDOP = 0.0;

} xxgsa_t;

//

class XGnss
{
private:
    /* data */
    uint8_t AllowRecv;
    String RawBuffer;
    char RawBufferProc[255];
    char *gpsp[GPSP_SIZE];


    xxrmc_t GPRMC_Proc;
    xxvtg_t GPVTG_Proc;
    xxgga_t GPGGA_Proc;
    xxgsa_t GPGSA_Proc;

    inline uint8_t GetNmeaType(char *tht_buf);

    uint8_t split_by_char(char *the_src, char the_char, char **the_des, uint8_t the_siz);
    uint8_t split_by_comma(char *the_src, char **the_des, uint8_t the_siz);
    uint8_t delete_crlf(char *the_buf);
    uint8_t delete_star(char *the_buf);

    uint8_t decToInt2(char *the_buf);
    uint16_t decToInt(char *theBuf, uint8_t theSize);
    uint8_t hexToInt2(char *the_buf);

    uint8_t gpsCalcChecksum(char *array);
    uint8_t gpsReadChecksumR(char *the_buf);

    void DecodeRMC(xxrmc_t *Dst, char **Buf);
    void DecodeVTG(xxvtg_t *Dst, char **Buf);
    void DecodeGGA(xxgga_t *Dst, char **Buf);
    void DecodeGSA(xxgsa_t *Dst, char **Buf);



public:
  
    XGnss();

    const char * fixStr[7] = {"FIX NOT valid", "GPS FIX", "DGPS", "NOT valid PPS", "RTK FIX", "RTK FLOAT", "LOAD"};
    
    uint8_t OnRecv(char c);
    uint8_t Parse();

    void RmcCpy(xxrmc_t *Dst, xxrmc_t Src);
    void VtgCpy(xxvtg_t *Dst, xxvtg_t Src);
    void GgaCpy(xxgga_t *Dst, xxgga_t Src);
    void GsaCpy(xxgsa_t *Dst, xxgsa_t Src);

    void printRMC(xxrmc_t Src);
    void printVTG(xxvtg_t Src);
    void printGGA(xxgga_t Src);
    void printGSA(xxgsa_t Src);

    void getRMC(xxrmc_t *Dst);
    void getVTG(xxvtg_t *Dst);
    void getGGA(xxgga_t *Dst);
    void getGSA(xxgsa_t *Dst);


};

#endif
/*


$GPRMC,,V,,,,,,,,,,N*53
Type = 1
CSum = 83,Rsum = 83 --> check_result is 1
0: $GPRMC
1: 
2: V
3: 
4: 
5: 
6: 
7: 
8: 
9: 
10: 
11: 
12: N


$GPVTG,,,,,,,,,N*30
Type = 2
CSum = 48,Rsum = 48 --> check_result is 1
0: $GPVTG
1: 
2: 
3: 
4: 
5: 
6: 
7: 
8: 
9: N


$GPGGA,,,,,,0,00,99.99,,,,,,*48
Type = 3
CSum = 72,Rsum = 72 --> check_result is 1
0: $GPGGA
1: 
2: 
3: 
4: 
5: 
6: 0
7: 00
8: 99.99
9: 
10: 
11: 
12: 
13: 
14: 


$GPGSA,A,1,,,,,,,,,,,,,99.99,99.99,99.99*30
Type = 4
CSum = 48,Rsum = 48 --> check_result is 1
0: $GPGSA
1: A
2: 1
3: 
4: 
5: 
6: 
7: 
8: 
9: 
10: 
11: 
12: 
13: 
14: 
15: 99.99
16: 99.99
17: 99.99

================================================================================================================

$GPRMC,123819.00,A,2001.55321,N,11018.38192,E,0.907,,170720,,,D*73
Type = 1
CSum = 115,Rsum = 115 --> check_result is 1
0: $GPRMC
1: 123819.00
2: A
3: 2001.55321
4: N
5: 11018.38192
6: E
7: 0.907
8: 
9: 170720
10: 
11: 
12: D


$GPVTG,,T,,M,0.907,N,1.679,K,D*21
Type = 2
CSum = 33,Rsum = 33 --> check_result is 1
0: $GPVTG
1: 
2: T
3: 
4: M
5: 0.907
6: N
7: 1.679
8: K
9: D


$GPGGA,123819.00,2001.55321,N,11018.38192,E,2,03,4.36,329.8,M,-12.0,M,,0000*78
Type = 3
CSum = 120,Rsum = 120 --> check_result is 1
0: $GPGGA
1: 123819.00
2: 2001.55321
3: N
4: 11018.38192
5: E
6: 2
7: 03
8: 4.36
9: 329.8
10: M
11: -12.0
12: M
13: 
14: 0000


$GPGSA,A,3,24,12,50,,,,,,,,,,6.06,4.36,4.21*04
Type = 4
CSum = 4,Rsum = 4 --> check_result is 1
0: $GPGSA
1: A
2: 3
3: 24
4: 12
5: 50
6: 
7: 
8: 
9: 
10: 
11: 
12: 
13: 
14: 
15: 6.06
16: 4.36
17: 4.21
*/

/*
$GPRMC,,V,,,,,,,,,,N*53
GPRMC
（推荐定位信息数据格式）
例：$GPRMC,024813.640,A,3158.4608,N,11848.3737,E,10.05,324.27,150706,,,A*50
字段0：$GPRMC，语句ID，表明该语句为Recommended Minimum Specific GPS/TRANSIT Data（RMC）推荐最小定位信息
字段1：UTC时间，hhmmss.sss格式
字段2：状态，A=定位，V=未定位
字段3：纬度ddmm.mmmm，度分格式（前导位数不足则补0）
字段4：纬度N（北纬）或S（南纬）
字段5：经度dddmm.mmmm，度分格式（前导位数不足则补0）
字段6：经度E（东经）或W（西经）
字段7：速度，节，Knots
字段8：方位角，度
字段9：UTC日期，DDMMYY格式
字段10：磁偏角，（000 - 180）度（前导位数不足则补0）
字段11：磁偏角方向，E=东W=西
字段12：模式，A=自动，D=差分，E=估测，N=数据无效（3.0协议内容）
字段13：校验值（$与*之间的数异或后的值）

$GPVTG,,,,,,,,,N*30
GPVTG
（地面速度信息）
例：$GPVTG,89.68,T,,M,0.00,N,0.0,K*5F
字段0：$GPVTG，语句ID，表明该语句为Track Made Good and Ground Speed（VTG）地面速度信息
字段1：运动角度，000 - 359，（前导位数不足则补0）
字段2：T=真北参照系
字段3：运动角度，000 - 359，（前导位数不足则补0）
字段4：M=磁北参照系
字段5：水平运动速度（0.00）（前导位数不足则补0）
字段6：N=节，Knots
字段7：水平运动速度（0.00）（前导位数不足则补0）
字段8：K=公里/时，km/h
字段9：校验值（$与*之间的数异或后的值）

$GPGGA,,,,,,0,00,99.99,,,,,,*48
GPGGA
（定位信息）
例：$GPGGA,092204.999,4250.5589,S,14718.5084,E,1,04,24.4,12.2,M,19.7,M,,0000*1F
字段0：$GPGGA，语句ID，表明该语句为Global Positioning System Fix Data（GGA）GPS定位信息
字段1：UTC 时间，hhmmss.sss，时分秒格式
字段2：纬度ddmm.mmmm，度分格式（前导位数不足则补0）
字段3：纬度N（北纬）或S（南纬）
字段4：经度dddmm.mmmm，度分格式（前导位数不足则补0）
字段5：经度E（东经）或W（西经）
字段6：GPS状态，0=不可用(FIX NOT valid)，1=单点定位(GPS FIX)，2=差分定位(DGPS)，3=无效PPS，4=实时差分定位（RTK FIX），5=RTK FLOAT，6=正在估算
字段7：正在使用的卫星数量（00 - 12）（前导位数不足则补0）
字段8：HDOP水平精度因子（0.5 - 99.9）
字段9：海拔高度（-9999.9 - 99999.9）
字段10：单位：M（米）
字段11：地球椭球面相对大地水准面的高度 WGS84水准面划分
字段12：WGS84水准面划分单位：M（米）
字段13：差分时间（从接收到差分信号开始的秒数，如果不是差分定位将为空）
字段14：差分站ID号0000 - 1023（前导位数不足则补0，如果不是差分定位将为空）
字段15：校验值（$与*之间的数异或后的值）

$GPGSA,A,1,,,,,,,,,,,,,99.99,99.99,99.99*30
GPGSA
（ 当前卫星信息）
例：$GPGSA,A,3,01,20,19,13,,,,,,,,,40.4,24.4,32.2*0A
字段0：$GPGSA，语句ID，表明该语句为GPS DOP and Active Satellites（GSA）当前卫星信息
字段1：定位模式(选择2D/3D)，A=自动选择，M=手动选择
字段2：定位类型，1=未定位，2=2D定位，3=3D定位
字段3：PRN码（伪随机噪声码），第1信道正在使用的卫星PRN码编号（00）（前导位数不足则补0）
字段4：PRN码（伪随机噪声码），第2信道正在使用的卫星PRN码编号（00）（前导位数不足则补0）
字段5：PRN码（伪随机噪声码），第3信道正在使用的卫星PRN码编号（00）（前导位数不足则补0）
字段6：PRN码（伪随机噪声码），第4信道正在使用的卫星PRN码编号（00）（前导位数不足则补0）
字段7：PRN码（伪随机噪声码），第5信道正在使用的卫星PRN码编号（00）（前导位数不足则补0）
字段8：PRN码（伪随机噪声码），第6信道正在使用的卫星PRN码编号（00）（前导位数不足则补0）
字段9：PRN码（伪随机噪声码），第7信道正在使用的卫星PRN码编号（00）（前导位数不足则补0）
字段10：PRN码（伪随机噪声码），第8信道正在使用的卫星PRN码编号（00）（前导位数不足则补0）
字段11：PRN码（伪随机噪声码），第9信道正在使用的卫星PRN码编号（00）（前导位数不足则补0）
字段12：PRN码（伪随机噪声码），第10信道正在使用的卫星PRN码编号（00）（前导位数不足则补0）
字段13：PRN码（伪随机噪声码），第11信道正在使用的卫星PRN码编号（00）（前导位数不足则补0）
字段14：PRN码（伪随机噪声码），第12信道正在使用的卫星PRN码编号（00）（前导位数不足则补0）
字段15：PDOP综合位置精度因子（0.5 - 99.9）
字段16：HDOP水平精度因子（0.5 - 99.9）
字段17：VDOP垂直精度因子（0.5 - 99.9）
字段18：校验值（$与*之间的数异或后的值）

$GPGSV,1,1,01,19,,,13*72
GPGSV
(可见卫星信息)
例：$GPGSV,3,1,10,20,78,331,45,01,59,235,47,22,41,069,,13,32,252,45*70
字段0：$GPGSV，语句ID，表明该语句为GPS Satellites in View（GSV）可见卫星信息
字段1：本次GSV语句的总数目（1 - 3）
字段2：本条GSV语句是本次GSV语句的第几条（1 - 3）
字段3：当前可见卫星总数（00 - 12）（前导位数不足则补0）
字段4：PRN 码（伪随机噪声码）（01 - 32）（前导位数不足则补0）
字段5：卫星仰角（00 - 90）度（前导位数不足则补0）
字段6：卫星方位角（00 - 359）度（前导位数不足则补0）
字段7：信噪比（00－99）dbHz
字段8：PRN 码（伪随机噪声码）（01 - 32）（前导位数不足则补0）
字段9：卫星仰角（00 - 90）度（前导位数不足则补0）
字段10：卫星方位角（00 - 359）度（前导位数不足则补0）
字段11：信噪比（00－99）dbHz
字段12：PRN 码（伪随机噪声码）（01 - 32）（前导位数不足则补0）
字段13：卫星仰角（00 - 90）度（前导位数不足则补0）
字段14：卫星方位角（00 - 359）度（前导位数不足则补0）
字段15：信噪比（00－99）dbHz
字段16：校验值（$与*之间的数异或后的值）

$GPGLL,,,,,,V,N*64
GPGLL
（地理定位信息）
例：$GPGLL,4250.5589,S,14718.5084,E,092204.999,A*2D
字段0：$GPGLL，语句ID，表明该语句为Geographic Position（GLL）地理定位信息
字段1：纬度ddmm.mmmm，度分格式（前导位数不足则补0）
字段2：纬度N（北纬）或S（南纬）
字段3：经度dddmm.mmmm，度分格式（前导位数不足则补0）
字段4：经度E（东经）或W（西经）
字段5：UTC时间，hhmmss.sss格式
字段6：状态，A=定位，V=未定位
字段7：校验值（$与*之间的数异或后的值）
*/
