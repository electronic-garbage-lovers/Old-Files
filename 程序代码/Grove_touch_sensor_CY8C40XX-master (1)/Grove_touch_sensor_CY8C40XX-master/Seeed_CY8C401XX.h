/*
    Seeed_CY8C401XX.h
    Driver for Grove touch sensor CY8C401XX

    Copyright (c) 2018 Seeed Technology Co., Ltd.
    Website    : www.seeed.cc
    Author     : downey
    Create Time: June 2018
    Change Log :

    The MIT License (MIT)

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
*/

#ifndef _SEEED_CY8C401XX_H
#define _SEEED_CY8C401XX_H


#include <Wire.h>
#include <Arduino.h>


#ifndef SEEED_DN_DEFINES
#define SEEED_DN_DEFINES

#ifdef ARDUINO_SAMD_VARIANT_COMPLIANCE
    #define SERIAL_DB SerialUSB
#else
    #define SERIAL_DB Serial
#endif


typedef int            s32;
typedef long unsigned int   u32;
typedef short          s16;
typedef unsigned short u16;
typedef char           s8;
typedef unsigned char  u8;

typedef enum {
    NO_ERROR = 0,
    ERROR_PARAM = -1,
    ERROR_COMM = -2,
    ERROR_OTHERS = -128,
} err_t;


#define CHECK_RESULT(a,b)   do{if(a=b)  {    \
            SERIAL_DB.print(__FILE__);    \
            SERIAL_DB.print(__LINE__);   \
            SERIAL_DB.print(" error code =");  \
            SERIAL_DB.println(a);                   \
            return a;   \
        }}while(0)

#endif

/*default iic addr is 0x08*/
#define DEFAULT_IIC_ADDR  0x08

#define TOUCH_BUTTON_VALUE_REG_ADDR  0X00
#define TOUCH_SLIDER_VALUE_REG_ADDR  0X01


class CY8C_IIC_OPRTS {
  public:
    void IIC_begin() {
        Wire.begin();
    }
    s32 IIC_write_byte(u8 reg, u8 byte);
    s32 IIC_read_byte(u8 reg, u8* byte);
    void set_iic_addr(u8 IIC_ADDR);
    void IIC_read_16bit(u8 start_reg, u16* value);
    s32 IIC_write_16bit(u8 reg, u16 value);
  private:
    u8 _IIC_ADDR;
};

class CY8C: public CY8C_IIC_OPRTS {
  public:
    CY8C(u8 addr = DEFAULT_IIC_ADDR);
    void init();
    s32 get_touch_button_value(u8* touch_value);
    s32 get_touch_slider_value(u8* value);
  private:
    u8 _IIC_ADDR;
};


#endif

