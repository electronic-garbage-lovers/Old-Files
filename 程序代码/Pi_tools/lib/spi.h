#ifndef _SPI_H
#define _SPI_H

static const char* device = "/dev/spidev0.1";
static uint8_t mode;
static uint8_t bits = 8;
static uint32_t speed = 500000;
static uint16_t delay;


/*
 devicei设备名,如/dev/spidev0.0
 mode:
SPI_LOOP;回送模式 SPI_CPHA;时钟相位 SPI_CPOL;时钟极性
SPI_LSB_FIRST;lsb 最低有效位 SPI_CS_HIGH;片选高电平
SPI_3WIRE;3线传输模式 SPI_NO_CS;没片选
SPI_READY;从机拉低电平停止数据传输
bits:设置每个字含多少位
speed:设置速率
*/
int init_spi(const char *device, unsigned char mode, unsigned char bits, unsigned int speeds);
/*
*
*/
void spitx(int fd, uint8_t *data);

#endif