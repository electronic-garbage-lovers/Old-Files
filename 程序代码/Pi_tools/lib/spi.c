#include <stdio.h>
#include <stdint.h>
#include <linux/spi/spidev.h>
#include <sys/ioctl.h>
#include <stdlib.h>
#include <fcntl.h>

#define ARRAY_SIZE(a) (sizeof(a) / sizeof((a)[0])) 

static void pabort(const char* s)
{
    perror(s);
    abort();
}

void spitx(int fd, uint8_t *data)
{
    int ret;
    struct spi_ioc_transfer tr =
    {
        .tx_buf = (unsigned long)data,
        .len = ARRAY_SIZE(&data),
    };
    ret = ioctl(fd, SPI_IOC_MESSAGE(1), &tr);
    if (ret < 1)
    {
        pabort("can't send spi message");
    }
}

int init_spi(const char* device, unsigned char mode, unsigned char bits, unsigned int speed)
{
    int fd, ret;
    fd = open(device, O_RDWR); //���豸��
    if (fd < 0)
        pabort("can't open device");
    /*
    * spi mode //����spi�豸ģʽ
    */
    ret = ioctl(fd, SPI_IOC_WR_MODE, &mode);    //дģʽ
    if (ret == -1)
        pabort("can't set spi mode");
    ret = ioctl(fd, SPI_IOC_RD_MODE, &mode);    //��ģʽ
    if (ret == -1)
        pabort("can't get spi mode");
    /*
    * bits per word    //����ÿ���ֺ�����λ
    */
    ret = ioctl(fd, SPI_IOC_WR_BITS_PER_WORD, &bits);   //д ÿ���ֺ�����λ
    if (ret == -1)
        pabort("can't set bits per word");

    ret = ioctl(fd, SPI_IOC_RD_BITS_PER_WORD, &bits);   //�� ÿ���ֺ�����λ
    if (ret == -1)
        pabort("can't get bits per word");


    /*
     * max speed hz     //��������
     */
    ret = ioctl(fd, SPI_IOC_WR_MAX_SPEED_HZ, &speed);   //д����
    if (ret == -1)
        pabort("can't set max speed hz");

    ret = ioctl(fd, SPI_IOC_RD_MAX_SPEED_HZ, &speed);   //������
    if (ret == -1)
        pabort("can't get max speed hz");
    return fd;
}