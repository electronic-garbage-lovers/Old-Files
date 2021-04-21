/*
    Seeed_CY8C401XX.cpp
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
#include "Seeed_CY8C401XX.h"



/*Reset slave IIC addr*/
CY8C::CY8C(u8 addr) {
    set_iic_addr(addr);
}


void CY8C::init() {
    IIC_begin();
}




/** The target touch sensor has only two registers.
    addr 0x00:button value,bit0~bit1 indicate button0~button1 status,when the button is pressed,the corresponding light will turn on,otherwise off.
    addr 0x01:slider value,range of 0~100,when the slider has been pressed,user can read slider value,the corresponding light will turn on,otherwise off
 * */
s32 CY8C::get_touch_button_value(u8* touch_value) {
    IIC_read_byte(TOUCH_BUTTON_VALUE_REG_ADDR, touch_value);
    return 0;
}


s32 CY8C::get_touch_slider_value(u8* value) {
    IIC_read_byte(TOUCH_SLIDER_VALUE_REG_ADDR, value);
    return 0;

}

/**********************************************************************************************************/
/************************************************IIC PART************************************************/
/**********************************************************************************************************/

s32 CY8C_IIC_OPRTS::IIC_write_byte(u8 reg, u8 byte) {
    Wire.beginTransmission(_IIC_ADDR);
    Wire.write(reg);
    Wire.write(byte);
    return Wire.endTransmission();
}


s32 CY8C_IIC_OPRTS::IIC_write_16bit(u8 reg, u16 value) {
    Wire.beginTransmission(_IIC_ADDR);
    Wire.write(reg);

    Wire.write((u8)(value >> 8));
    Wire.write((u8)value);
    return Wire.endTransmission();
}




s32 CY8C_IIC_OPRTS::IIC_read_byte(u8 reg, u8* byte) {
    u8 timeout_count = 0;
    Wire.beginTransmission(_IIC_ADDR);
    Wire.write(reg);
    Wire.endTransmission(false);

    Wire.requestFrom(_IIC_ADDR, (u8)1);
    while (1 != Wire.available()) {
        timeout_count++;
        if (timeout_count > 10) {
            return -1;
        }
        delay(1);
    }
    *byte = Wire.read();
    return 0;

}

void CY8C_IIC_OPRTS::IIC_read_16bit(u8 start_reg, u16* value) {
    u8 val = 0;
    *value = 0;
    Wire.beginTransmission(_IIC_ADDR);
    Wire.write(start_reg);
    Wire.endTransmission(false);

    Wire.requestFrom(_IIC_ADDR, sizeof(u16));
    while (sizeof(u16) != Wire.available());
    val = Wire.read();
    *value |= (u16)val << 8;
    val = Wire.read();
    *value |= val;
}



void CY8C_IIC_OPRTS::set_iic_addr(u8 IIC_ADDR) {
    _IIC_ADDR = IIC_ADDR;
}


