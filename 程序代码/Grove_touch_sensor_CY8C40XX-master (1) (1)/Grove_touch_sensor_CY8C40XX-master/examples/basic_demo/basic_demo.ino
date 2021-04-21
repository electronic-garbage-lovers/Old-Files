/*
    basic_demo.ino
    Example for Grove touch sensor CY8C401XX

    Copyright (c) 2018 Seeed Technology Co., Ltd.
    Website    : www.seeed.cc
    Author     : downey
    Create Time: April 2018
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

#ifdef ARDUINO_SAMD_VARIANT_COMPLIANCE
    #define SERIAL SerialUSB
#else
    #define SERIAL Serial
#endif

CY8C sensor;
void setup() {
    SERIAL.begin(115200);

    sensor.init();
}


void loop() {
    u8 value = 0;
    sensor.get_touch_button_value(&value);
    SERIAL.print("button value is");
    SERIAL.println(value, HEX);
    if (value & 0x01) {
        SERIAL.println("button 1 is pressed");
    }
    if (value & 0x2) {
        SERIAL.println("button 2 is pressed");
    }

    sensor.get_touch_slider_value(&value);
    SERIAL.print("slider value is");
    SERIAL.println(value, HEX);
    SERIAL.println(" ");


    delay(1000);
}



