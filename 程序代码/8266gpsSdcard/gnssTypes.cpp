#include "gnssTypes.h"

XGnss::XGnss()
{
  AllowRecv = 0;
  RawBuffer = "";
  for (uint8_t i = 0; i < GPSP_SIZE; i++)
  {
    gpsp[i] = (char *)malloc(50);
  }
}

//
uint8_t XGnss::OnRecv(char c)
{
  if (c == '$')
  {
    AllowRecv = 1;
  } //tempCh == '$'

  if (AllowRecv == 1)
  {
    RawBuffer += c;
    if (c == '\n')
    {
      AllowRecv = 0;

      strcpy(RawBufferProc, RawBuffer.c_str());

      RawBuffer = "";
      return 1;
    } //c == '\n'

  } //AllowRecv == 1

  return 0;
}

uint8_t XGnss::Parse()
{
  //GPRMC,GPVTG,GPGGA,GPGSA,GPGSV,GPGLL
  if (strncmp(RawBufferProc + 1, "GPRMC", 5) == 0 || strncmp(RawBufferProc + 1, "GPVTG", 5) == 0 || strncmp(RawBufferProc + 1, "GPGGA", 5) == 0 || strncmp(RawBufferProc + 1, "GPGSA", 5) == 0)
  {

    //Serial.print(RawBufferProc);

    uint8_t NmeaType = GetNmeaType(RawBufferProc);
    //Serial.printf("Type = %d\r\n", NmeaType);

    delete_crlf(RawBufferProc);
    uint8_t CalcSum = gpsCalcChecksum(RawBufferProc);
    uint8_t ReadSum = gpsReadChecksumR(RawBufferProc);
    uint8_t wordNum = split_by_comma(RawBufferProc, gpsp, sizeof(gpsp) / sizeof(char *));
    bool check_result = (CalcSum == ReadSum);

    //Serial.printf("CSum = %d,Rsum = %d --> check_result is %d\r\n", CalcSum, ReadSum, check_result);

    for (int i = 0; i < wordNum; i++)
    {
      delete_star(gpsp[i]);
      //Serial.print(i);
      //Serial.print(": ");
      //Serial.println(gpsp[i]);
    }

    if (check_result == 1)
    {

      switch (NmeaType)
      {
      case GPRMC:
        DecodeRMC(&GPRMC_Proc, gpsp);
        //printRMC(GPRMC_Proc);
        break;
      case GPVTG:
        DecodeVTG(&GPVTG_Proc, gpsp);
        //printVTG(GPVTG_Proc);
        break;
      case GPGGA:
        DecodeGGA(&GPGGA_Proc, gpsp);
        //printGGA(GPGGA_Proc);
        break;
      case GPGSA:
        DecodeGSA(&GPGSA_Proc, gpsp);
        //printGSA(GPGSA_Proc);
        break;

      default:
        //Serial.println("BUF_ERR");
        break;
      } //switch

      return NmeaType;

    } //check_result == 1

  } //GPRMC,GPVTG,GPGGA,GPGSA,GPGSV,GPGLL
  return 0;
}

void XGnss::DecodeRMC(xxrmc_t *Dst, char **Buf)
{
  double temp = 0.0;

  // GPRMC
  // （推荐定位信息数据格式）
  // 例：$GPRMC,024813.640,A,3158.4608,N,11848.3737,E,10.05,324.27,150706,,,A*50

  // 字段1：UTC时间，hhmmss.sss格式
  if (Buf[1][0])
  {
    Dst->UTC_Hour = decToInt2(Buf[1]);
    Dst->UTC_Minute = decToInt2(Buf[1] + 2);
    Dst->UTC_Second = decToInt2(Buf[1] + 4);
  }
  else
  {
    Dst->UTC_Hour = 0;
    Dst->UTC_Minute = 0;
    Dst->UTC_Second = 0;
  }

  // 字段2：状态，A=定位，V=未定位
  Dst->State = Buf[2][0];

  // 字段3：纬度ddmm.mmmm，度分格式（前导位数不足则补0）
  if (Buf[3][0])
  {
    temp = (double)decToInt(gpsp[3], 2);
    Dst->Latitude = temp + atof(gpsp[3] + 2) / 60.0;
  }
  else
    Dst->Latitude = 0.0;

  // 字段4：纬度N（北纬）或S（南纬）
  if (Buf[4][0])
    Dst->Ns = Buf[4][0];
  else
    Dst->Ns = 0;

  // 字段5：经度dddmm.mmmm，度分格式（前导位数不足则补0）
  if (Buf[5][0])
  {
    temp = (double)decToInt(gpsp[5], 3);
    Dst->Longitude = temp + atof(gpsp[5] + 3) / 60.0;
  }
  else
    Dst->Longitude = 0.0;

  // 字段6：经度E（东经）或W（西经）
  if (Buf[6][0])
    Dst->Ew = Buf[6][0];
  else
    Dst->Ew = 0;

  // 字段7：速度，节，Knots
  if (Buf[7][0])
    Dst->Velocity = atof(Buf[7]);
  else
    Dst->Velocity = 0.0;

  // 字段8：方位角，度
  if (Buf[8][0])
    Dst->Azimuth = atof(Buf[8]);
  else
    Dst->Azimuth = 0.0;

  // 字段9：UTC日期，DDMMYY格式
  if (Buf[9][0])
  {
    Dst->UTC_Day = decToInt2(Buf[9]);
    Dst->UTC_Month = decToInt2(Buf[9] + 2);
    Dst->UTC_Year = decToInt2(Buf[9] + 4);
  }
  else
  {
    Dst->UTC_Day = 0;
    Dst->UTC_Month = 0;
    Dst->UTC_Year = 0;
  }

  // 字段10：磁偏角，（000 - 180）度（前导位数不足则补0）
  if (Buf[10][0])
    Dst->Declination = atof(Buf[10]);
  else
    Dst->Declination = 0;

  // 字段11：磁偏角方向，E=东W=西
  if (Buf[11][0])
    Dst->Dew = Buf[11][0];
  else
    Dst->Dew = 0;

  // 字段12：模式，A=自动，D=差分，E=估测，N=数据无效（3.0协议内容）
  Dst->Mode = Buf[12][0];
}

void XGnss::DecodeVTG(xxvtg_t *Dst, char **Buf)
{

  //   GPVTG
  // （地面速度信息）
  // 例：$GPVTG,89.68,T,,M,0.00,N,0.0,K*5F

  // 字段1：运动角度，000 - 359，（前导位数不足则补0）
  if (Buf[1][0])
    Dst->T_Angle = atof(Buf[1]);
  else
    Dst->T_Angle = 0;

  // 字段2：T=真北参照系
  if (Buf[2][0])
    Dst->T_Reference = Buf[2][0];
  else
    Dst->T_Reference = 0;

  // 字段3：运动角度，000 - 359，（前导位数不足则补0）
  if (Buf[3][0])
    Dst->M_Angle = atof(Buf[3]);
  else
    Dst->M_Angle = 0;

  // 字段4：M=磁北参照系
  if (Buf[4][0])
    Dst->M_Reference = Buf[4][0];
  else
    Dst->M_Reference = 0;

  // 字段5：水平运动速度（0.00）（前导位数不足则补0）
  if (Buf[5][0])
    Dst->N_Horizontal_Velocity = atof(Buf[5]);
  else
    Dst->N_Horizontal_Velocity = 0;

  // 字段6：N=节，Knots
  if (Buf[6][0])
    Dst->Knots = Buf[6][0];
  else
    Dst->Knots = 0;

  // 字段7：水平运动速度（0.00）（前导位数不足则补0）
  if (Buf[7][0])
    Dst->K_Horizontal_Velocity = atof(Buf[7]);
  else
    Dst->K_Horizontal_Velocity = 0;

  // 字段8：K=公里/时，km/h
  if (Buf[8][0])
    Dst->Kmh = Buf[8][0];
  else
    Dst->Kmh = 0;
}

void XGnss::DecodeGGA(xxgga_t *Dst, char **Buf)
{
  double temp = 0.0;

  //   GPGGA
  // （定位信息）
  // 例：$GPGGA,092204.999,4250.5589,S,14718.5084,E,1,04,24.4,12.2,M,19.7,M,,0000*1F
  // 字段0：$GPGGA，语句ID，表明该语句为Global Positioning System Fix Data（GGA）GPS定位信息

  // 字段1：UTC 时间，hhmmss.sss，时分秒格式
  if (Buf[1][0])
  {
    Dst->UTC_Hour = decToInt2(Buf[1]);
    Dst->UTC_Minute = decToInt2(Buf[1] + 2);
    Dst->UTC_Second = decToInt2(Buf[1] + 4);
  }
  else
  {
    Dst->UTC_Hour = 0;
    Dst->UTC_Minute = 0;
    Dst->UTC_Second = 0;
  }

  // 字段2：纬度ddmm.mmmm，度分格式（前导位数不足则补0）
  if (Buf[2][0])
  {
    temp = (double)decToInt(gpsp[2], 2);
    Dst->Latitude = temp + atof(gpsp[2] + 2) / 60.0;
  }
  else
    Dst->Latitude = 0;

  // 字段3：纬度N（北纬）或S（南纬）
  if (Buf[3][0])
    Dst->Ns = Buf[3][0];
  else
    Dst->Ns = 0;

  // 字段4：经度dddmm.mmmm，度分格式（前导位数不足则补0）
  if (Buf[4][0])
  {
    temp = (double)decToInt(gpsp[4], 3);
    Dst->Longitude = temp + atof(gpsp[4] + 3) / 60.0;
  }
  else
    Dst->Longitude = 0.0;

  // 字段5：经度E（东经）或W（西经）
  if (Buf[5][0])
    Dst->Ew = Buf[5][0];
  else
    Dst->Ew = 0;

  // 字段6：GPS状态，0=不可用(FIX NOT valid)，1=单点定位(GPS FIX)，2=差分定位(DGPS)，3=无效PPS，4=实时差分定位（RTK FIX），5=RTK FLOAT，6=正在估算
  Dst->Fix = Buf[6][0] - '0';

  // 字段7：正在使用的卫星数量（00 - 12）（前导位数不足则补0）
  Dst->S_Num = atoi(Buf[7]);

  // 字段8：HDOP水平精度因子（0.5 - 99.9）
  Dst->HDOP = atof(Buf[8]);

  // 字段9：海拔高度（-9999.9 - 99999.9）
  if (Buf[9][0])
    Dst->Altitude = atof(Buf[9]);
  else
    Dst->Altitude = 0;

  // 字段10：单位：M（米）
  Dst->Metre = 'M';

  // 字段11：地球椭球面相对大地水准面的高度 WGS84水准面划分
  if (Buf[11][0])
    Dst->Level = atof(Buf[11]);
  else
    Dst->Level = 0;

  // 字段12：WGS84水准面划分单位：M（米）
  if (Buf[12][0])
    Dst->Level_Unit = Buf[12][0];
  else
    Dst->Level_Unit = 0;

  // 字段13：差分时间（从接收到差分信号开始的秒数，如果不是差分定位将为空）(dont have)
  Dst->Diff_Time = 0.0;

  // 字段14：差分站ID号0000 - 1023（前导位数不足则补0，如果不是差分定位将为空）
  Dst->Diff_ID = 0;

} //DecodeGGA

void XGnss::DecodeGSA(xxgsa_t *Dst, char **Buf)
{

  //   GPGSA
  // （ 当前卫星信息）
  // 例：$GPGSA,A,3,01,20,19,13,,,,,,,,,40.4,24.4,32.2*0A

  // 字段1：定位模式(选择2D/3D)，A=自动选择，M=手动选择
  Dst->Mode = Buf[1][0];

  // 字段2：定位类型，1=未定位，2=2D定位，3=3D定位
  Dst->Type = Buf[2][0] - '0';

  // 字段3：PRN码（伪随机噪声码），第1信道正在使用的卫星PRN码编号（00）（前导位数不足则补0）
  for (uint8_t i = 3; i <= 14; i++)
  {
    if (Buf[i][0])
      Dst->Sno[i - 3] = atoi(Buf[i]);
    else
      Dst->Sno[i - 3] = 0;
  }

  //字段14：PRN码（伪随机噪声码），第12信道正在使用的卫星PRN码编号（00）（前导位数不足则补0）

  // 字段15：PDOP综合位置精度因子（0.5 - 99.9）
  Dst->PDOP = atof(Buf[15]);

  // 字段16：HDOP水平精度因子（0.5 - 99.9）
  Dst->HDOP = atof(Buf[16]);

  // 字段17：VDOP垂直精度因子（0.5 - 99.9）
  Dst->VDOP = atof(Buf[17]);
}

//
void XGnss::RmcCpy(xxrmc_t *Dst, xxrmc_t Src)
{
  Dst->UTC_Hour = Src.UTC_Hour;
  Dst->UTC_Minute = Src.UTC_Minute;
  Dst->UTC_Second = Src.UTC_Second;
  Dst->State = Src.State;
  Dst->Latitude = Src.Latitude;
  Dst->Ns = Src.Ns;
  Dst->Longitude = Src.Longitude;
  Dst->Ew = Src.Ew;
  Dst->Velocity = Src.Velocity;
  Dst->Azimuth = Src.Azimuth;
  Dst->UTC_Day = Src.UTC_Day;
  Dst->UTC_Month = Src.UTC_Month;
  Dst->UTC_Year = Src.UTC_Year;
  Dst->Declination = Src.Declination;
  Dst->Dew = Src.Dew;
  Dst->Mode = Src.Mode;
}

void XGnss::VtgCpy(xxvtg_t *Dst, xxvtg_t Src)
{
  Dst->T_Angle = Src.T_Angle;
  Dst->T_Reference = Src.T_Reference;
  Dst->M_Angle = Src.M_Angle;
  Dst->M_Reference = Src.M_Reference;
  Dst->N_Horizontal_Velocity = Src.N_Horizontal_Velocity;
  Dst->Knots = Src.Knots;
  Dst->K_Horizontal_Velocity = Src.K_Horizontal_Velocity;
  Dst->Kmh = Src.Kmh;
}

void XGnss::GgaCpy(xxgga_t *Dst, xxgga_t Src)
{
  Dst->UTC_Hour = Src.UTC_Hour;
  Dst->UTC_Minute = Src.UTC_Minute;
  Dst->UTC_Second = Src.UTC_Second;
  Dst->Latitude = Src.Latitude;
  Dst->Ns = Src.Ns;
  Dst->Longitude = Src.Longitude;
  Dst->Ew = Src.Ew;
  Dst->Fix = Src.Fix;
  Dst->S_Num = Src.S_Num;
  Dst->HDOP = Src.HDOP;
  Dst->Altitude = Src.Altitude;
  Dst->Metre = Src.Metre;
  Dst->Level = Src.Level;
  Dst->Level_Unit = Src.Level_Unit;
  Dst->Diff_Time = Src.Diff_Time;
  Dst->Diff_ID = Src.Diff_ID;
}

void XGnss::GsaCpy(xxgsa_t *Dst, xxgsa_t Src)
{
  Dst->Mode = Src.Mode;
  Dst->Type = Src.Type;
  for (uint8_t i = 0; i < 12; i++)
  {
    Dst->Sno[i] = Src.Sno[i];
  }
  Dst->PDOP = Src.PDOP;
  Dst->HDOP = Src.HDOP;
  Dst->VDOP = Src.VDOP;
}

//
inline uint8_t XGnss::GetNmeaType(char *tht_buf)
{
  if (strncmp(tht_buf + 1, "GPRMC", 5) == 0)
  {
    return GPRMC;
  }
  if (strncmp(tht_buf + 1, "GPVTG", 5) == 0)
  {
    return GPVTG;
  }
  if (strncmp(tht_buf + 1, "GPGGA", 5) == 0)
  {
    return GPGGA;
  }
  if (strncmp(tht_buf + 1, "GPGSA", 5) == 0)
  {
    return GPGSA;
  }
  return 0xff;
}

uint8_t XGnss::split_by_char(char *the_src, char the_char, char **the_des, uint8_t the_siz)
{
  uint8_t src_len = strlen(the_src);
  uint8_t di = 0;
  the_des[di++] = the_src;
  for (uint8_t si = 0; si < src_len && di < the_siz; si++)
  {
    if (the_src[si] == the_char)
    {
      the_des[di++] = the_src + si + 1;
      the_src[si] = '\0';
    }
  }
  return di;
}

uint8_t XGnss::split_by_comma(char *the_src, char **the_des, uint8_t the_siz)
{
  return split_by_char(the_src, ',', the_des, the_siz);
}

uint8_t XGnss::delete_crlf(char *the_buf)
{
  uint8_t leng = strlen(the_buf);
  for (uint8_t i = 0; i < leng - 1; i++)
  {
    if (the_buf[i] == '\r' && the_buf[i + 1] == '\n')
    {
      the_buf[i] = '\0';
      return 1;
    }
  }
  return 0;
}

uint8_t XGnss::delete_star(char *the_buf)
{
  uint8_t leng = strlen(the_buf);
  for (uint8_t i = 0; i < leng - 1; i++)
  {
    if (the_buf[i] == '*')
    {
      the_buf[i] = '\0';
      return 1;
    }
  }
  return 0;
}

uint8_t XGnss::decToInt2(char *the_buf)
{
  uint8_t value = 0;
  value += (the_buf[0] - '0') * 10;
  value += (the_buf[1] - '0');
  return value;
}

uint16_t XGnss::decToInt(char *theBuf, uint8_t theSize)
{
  uint16_t value = 0;
  for (int i = 0; i < theSize; i++)
  {
    value *= 10;
    value += (theBuf[i] - '0');
  }
  return value;
}

uint8_t XGnss::hexToInt2(char *the_buf)
{
  uint8_t value = 0;
  if (the_buf[0] >= '0' && the_buf[0] <= '9')
  {
    value += (the_buf[0] - '0') * 16;
  }
  else
  {
    value += (the_buf[0] - 'A' + 10) * 16;
  }

  if (the_buf[1] >= '0' && the_buf[1] <= '9')
  {
    value += (the_buf[1] - '0');
  }
  else
  {
    value += (the_buf[1] - 'A' + 10);
  }
  return value;
}

// check CalcSum using xor
uint8_t XGnss::gpsCalcChecksum(char *array)
{
  uint8_t CalcSum = array[1];
  for (uint8_t i = 2; array[i] != '*'; i++)
  {
    CalcSum ^= array[i];
  }
  return CalcSum;
}

//get gga checksum
uint8_t XGnss::gpsReadChecksumR(char *the_buf)
{
  uint8_t leng = strlen(the_buf);
  uint8_t i = 0;

  for (i = leng - 1; i < 0; i--)
  {
    if (the_buf[i] == '*')
      break;
  }

  if (i < 6)
    return 0;

  //Serial.printf("RSS = %s\r\n", the_buf + i - 1);

  uint8_t CalcSum = hexToInt2(the_buf + i - 1);
  return CalcSum;
}

//print
void XGnss::printRMC(xxrmc_t Src)
{
  Serial.println("==========RMC==========");
  Serial.printf("UTC1 : %d : %d : %d \r\n", Src.UTC_Hour, Src.UTC_Minute, Src.UTC_Second);
  Serial.printf("State : %c\r\n", Src.State);
  Serial.printf("Latitude : %f %c\r\n", Src.Latitude, Src.Ns);
  Serial.printf("Longitude : %f %c\r\n", Src.Longitude, Src.Ew);
  Serial.printf("Velocity : %f | %f\r\n", Src.Velocity, Src.Azimuth);
  Serial.printf("UTC2 : %d - %d - %d \r\n", Src.UTC_Year, Src.UTC_Month, Src.UTC_Day);
  Serial.printf("Declination : %f %c\r\n", Src.Declination, Src.Dew);
  Serial.printf("Mode : %c\r\n", Src.Mode);
  Serial.println("\r\n\r\n");
}

void XGnss::printVTG(xxvtg_t Src)
{
  Serial.println("==========VTG==========");
  Serial.print("TA:");
  Serial.print(Src.T_Angle);
  Serial.println(Src.T_Reference);

  Serial.print("MA:");
  Serial.print(Src.M_Angle);
  Serial.println(Src.M_Reference);

  Serial.print("HV:");
  Serial.print(Src.N_Horizontal_Velocity);
  Serial.println(Src.Knots);

  Serial.print("HV:");
  Serial.print(Src.K_Horizontal_Velocity);
  Serial.println(Src.Kmh);
}

void XGnss::printGGA(xxgga_t Src)
{
  Serial.println("==========GGA==========");
  Serial.print("LAT:");
  Serial.print(Src.Latitude);
  Serial.println(Src.Ns);
  Serial.print("LON:");
  Serial.print(Src.Longitude);
  Serial.println(Src.Ns);
  Serial.print("FIX:");
  Serial.println(Src.Fix);
  Serial.print("SNUM:");
  Serial.println(Src.S_Num);
  Serial.print("ALT:");
  Serial.print(Src.Altitude);
  Serial.println(Src.Metre);
}

void XGnss::printGSA(xxgsa_t Src)
{
  Serial.println("==========GSA==========");
  Serial.printf("Mode : %c\r\n", Src.Mode);
  Serial.printf("Type : %d\r\n", Src.Type);
  for (uint8_t i = 0; i < 12; ++i)
    Serial.printf("Sno%d : %d\r\n", i, Src.Sno[i]);
  Serial.printf("PDOP : %f\r\n", Src.PDOP);
  Serial.printf("HDOP : %f\r\n", Src.HDOP);
  Serial.printf("VDOP : %f\r\n", Src.VDOP);
}

void XGnss::getRMC(xxrmc_t *Dst)
{
  this->RmcCpy(Dst, this->GPRMC_Proc);
}
void XGnss::getVTG(xxvtg_t *Dst)
{
  this->VtgCpy(Dst, this->GPVTG_Proc);
}
void XGnss::getGGA(xxgga_t *Dst)
{
  this->GgaCpy(Dst, this->GPGGA_Proc);
}
void XGnss::getGSA(xxgsa_t *Dst)
{
  this->GsaCpy(Dst, this->GPGSA_Proc);
}
