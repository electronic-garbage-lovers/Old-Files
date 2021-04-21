#ifndef _ILI9613_H
#define _ILI9613_H

#define LCD		12
#define LcdA0	20
#define LcdRst	16

#define WIDCH 128 //16����
#define HIGH 160	//10��

#define WHITE_Color  0XFFFF
#define WHITE        0xFFFF	//��ɫ
#define BLACK        0x0000	//��ɫ
#define BLUE         0xF800//0x001F	//��ɫ ��
#define BRED         0xF81F//0XF81F
#define GRED 	     0X07FF//0XFFE0	//��ɫ
#define GBLUE  	     0XFFE0//0X07FF	//
#define RED          0x001F//0xF800	//��
#define MAGENTA      0xF81F
#define GREEN        0x07E0	//��ɫ
#define CYAN         0xFFEF//0x7FFF	//��ɫ
#define YELLOW       0X07FF//0xFFE0	//��ɫ
#define BROWN 	     0x0457//0XBC40 //��ɫ
#define BRRED 		 0x3C1F//0XFC07 //�غ�ɫ
#define GRAY  		 0X8430 //��ɫ
#define DARKBLUE     0X01CF	//����ɫ
#define LIGHTBLUE    0X7D7C	//ǳ��ɫ  
#define GRAYBLUE     0X5458 //����ɫ
#define Orchid       0XF11F //��ɫ



static const char *ili9163_device = "/dev/spidev0.0";
static unsigned char ili9163_mode;
static unsigned char ili9163_bits = 8;
static unsigned int ili9163_speed = 1000000;
static short unsigned int ili9163_delay;

int ili9163_fd;

void init_ili9163(void);
void LCD_WR_REG(unsigned char COM);
void LCD_WR_DATA8(unsigned char Data);
void Lcd_Clear(unsigned short Color);				//�򵥴�ɫ���
void Lcd_SetRegion(unsigned short x_start, unsigned short y_start, unsigned short x_end, unsigned short y_end);

void Gui_DrawPoint(unsigned short x, unsigned short y, unsigned short Data);
void Gui_DrawFont_GBK16(unsigned short x, unsigned short y, unsigned short fc, unsigned short bc, unsigned char* s);
unsigned short Color888to565(unsigned char r, unsigned char g, unsigned char b);

#endif