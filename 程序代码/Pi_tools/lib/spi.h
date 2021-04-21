#ifndef _SPI_H
#define _SPI_H

static const char* device = "/dev/spidev0.1";
static uint8_t mode;
static uint8_t bits = 8;
static uint32_t speed = 500000;
static uint16_t delay;


/*
 devicei�豸��,��/dev/spidev0.0
 mode:
SPI_LOOP;����ģʽ SPI_CPHA;ʱ����λ SPI_CPOL;ʱ�Ӽ���
SPI_LSB_FIRST;lsb �����Чλ SPI_CS_HIGH;Ƭѡ�ߵ�ƽ
SPI_3WIRE;3�ߴ���ģʽ SPI_NO_CS;ûƬѡ
SPI_READY;�ӻ����͵�ƽֹͣ���ݴ���
bits:����ÿ���ֺ�����λ
speed:��������
*/
int init_spi(const char *device, unsigned char mode, unsigned char bits, unsigned int speeds);
/*
*
*/
void spitx(int fd, uint8_t *data);

#endif