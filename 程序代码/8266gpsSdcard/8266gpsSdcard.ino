#include "gnssTypes.h"
#include <SPI.h>
#include <SD.h>
#include <stdio.h>
#include <ESP8266WiFi.h>
#include <WiFiClient.h>

/*
  $GPRMC,,V,,,,,,,,,,N*53
  $GPVTG,,,,,,,,,N*30
  $GPGGA,,,,,,0,00,99.99,,,,,,*48
  $GPGSA,A,1,,,,,,,,,,,,,99.99,99.99,99.99*30
  $GPGSV,1,1,04,03,,,17,04,,,16,06,,,22,08,,,25*72
  $GPGLL,,,,,,V,N*64

  $GPRMC,024813.640,A,3158.4608,N,11848.3737,E,10.05,324.27,150706,,,A*50
  $GPVTG,89.68,T,,M,0.00,N,0.0,K*5F
  $GPGSA,A,3,01,20,19,13,,,,,,,,,40.4,24.4,32.2*0A
  $GPGGA,092204.999,4250.5589,S,14718.5084,E,1,04,24.4,19.7,M,,,,0000*1F


  yyyy-mm-dd,hh:mm:ss,stu,lat,lon,alt,vlc,dir
  yyyy-mm-dd,hh:mm:ss,stu
*/
//gnss
XGnss x;
xxgga_t gga;
xxrmc_t rmc;
xxvtg_t vtg;
xxgsa_t gsa;
//sd
char writeStr[500];
uint8_t cnt[5] = {0};
//sys
uint8_t runMode = 0;
//wifi
const char *ssid = "8266GpsRec";
const char *password = "1234567890";
WiFiServer server(80);

void presaGNSS(xxrmc_t r, xxvtg_t v, xxgga_t g, xxgsa_t a)
{
  if (r.UTC_Year != 0)
  {
    sprintf(writeStr, "%d-%d-%d , %d:%d:%d , %d , %f %c , %f %c , %f M , %f K , %f T",
            r.UTC_Year, r.UTC_Month, r.UTC_Day,
            r.UTC_Hour, r.UTC_Minute, r.UTC_Second,
            a.Type,
            r.Longitude, r.Ew,
            r.Latitude, r.Ns,
            g.Altitude,
            v.K_Horizontal_Velocity,
            v.T_Angle);
    Serial.println(writeStr);
    writeLog(writeStr);
  }
}

void writeLog(char *str)
{
  if (!SD.exists("log.txt")) //判断LSLAB.txt文件是否存在
  {
    Serial.println("log.txt doesn't exist , creat a new one.");
  }

  File fileh = SD.open("log.txt", FILE_WRITE);

  if (fileh)
  {
    fileh.println(str);
    fileh.close();
  }

  else
  {
    Serial.println("error opening datalog.txt");
  }
}

void httpGetMain()
{
  WiFiClient client = server.available();
  if (client)
  {
    Serial.println(F("new client"));

    client.setTimeout(5000); //默认为 1000

    //读取客户端发起的TCP请求
    String req = client.readStringUntil('\r');
    Serial.println(F("request: "));
    Serial.println(req);

    uint8_t val = 0;
    //检查发起的请求内容是否包含"/delLog"
    if (req.indexOf(F("/delLog")) != -1)
    {
      val = 1;
    }
    else
    {
      Serial.println(F("invalid request"));
    }

    //读取剩余的内容,用于清除缓存
    while (client.available())
    {
      client.read();
    }
    
    //del logFile or show logFile
    if (val == 1)
    {
      client.print(F("HTTP/1.1 200 OK\r\n"));
      client.print(F("Content-Type: text/html\r\n\r\n"));
      client.println(F("<!DOCTYPE HTML>"));
      client.println(F("<html>"));

      if (!SD.exists("log.txt")) //判断LSLAB.txt文件是否存在
      {
        client.print("log.txt doesn't exist.\r\n");
      } //no exists
      else
      {
        SD.remove("log.txt");
        client.print("delete log OK");
      }

      client.println(F("</html>"));
    } //del ok
    else
    {
      client.print(F("HTTP/1.1 200 OK\r\n"));
      client.print(F("Content-Type: text/html\r\n\r\n"));
      client.println(F("<!DOCTYPE HTML>"));
      client.println(F("<html>"));

      if (!SD.exists("log.txt")) //判断LSLAB.txt文件是否存在
      {
        client.print("log.txt doesn't exist.\r\n");
      } //no exists
      else
      {

        File myFile = SD.open("log.txt"); //打开指定文件
        if (myFile)
        {
          //从文件中读取，直到没有其他内容
          while (myFile.available())
          {
            client.write(myFile.read()); //不断循环读取直到没有其他内容
          }
          //关闭文件
          myFile.close();
        }
        else
        {
          //如果文件没有打开，打印错误：
          client.print(F("error opening log.txt\r\n"));
        }

      } //exists
      client.println(F("</html>"));

    } //else
  }   //clint
}

void setup()
{
  // put your setup code here, to run once:
  pinMode(16, OUTPUT);
  pinMode(5, INPUT);
  digitalWrite(16, 1);
  Serial.begin(9600); //gnss
  Serial.setRxBufferSize(1024);
  Serial.print("...\r\n");

  Serial.print("Initializing SD card...");

  if (!SD.begin(SS))
  {
    Serial.println("initialization failed!");
    return;
  }
  Serial.println("initialization done.");

  if (digitalRead(5) == 0)
  {
    runMode = 1;
  }

  if (runMode == 0)
  {
    writeLog("==========power on==========");

    digitalWrite(16, 0);
  }
  if (runMode == 1)
  {
    WiFi.softAP(ssid, password);
    IPAddress myIP = WiFi.softAPIP();
    Serial.print("AP IP address: ");
    Serial.println(myIP);
    server.begin();
  }
}

void loop()
{
  // put your main code here, to run repeatedly:
  //Serial.println(digitalRead(5));
  if (runMode == 0)
  {
    /////////////////////////////////////////////////////////////////////

    if (Serial.available())
    {
      char c = Serial.read();
      if (x.OnRecv(c) == 1)
      {
        uint8_t type = x.Parse();
        //Serial.println(type);
        delay(1);
        if (type == GPGGA)
        {
          x.getGGA(&gga);
          cnt[GPGGA]++;
        }
        else if (type == GPGSA)
        {
          x.getGSA(&gsa);
          cnt[GPGSA]++;
        }
        else if (type == GPVTG)
        {
          x.getVTG(&vtg);
          cnt[GPVTG]++;
        }
        else if (type == GPRMC)
        {
          x.getRMC(&rmc);
          cnt[GPRMC]++;
        }
        if (cnt[GPGGA] != 0 && cnt[GPGSA] != 0 && cnt[GPVTG] != 0 && cnt[GPRMC] != 0)
        {
          memset(cnt, 0, 5);
          digitalWrite(16, 1);
          presaGNSS(rmc, vtg, gga, gsa);
          digitalWrite(16, 0);
        }
      }
    }

    /////////////////////////////////////////////////////////////////////
  }
  else if (runMode == 1)
  {
    /////////////////////////////////////////////////////////////////////
    httpGetMain();
    /////////////////////////////////////////////////////////////////////
  }
}
