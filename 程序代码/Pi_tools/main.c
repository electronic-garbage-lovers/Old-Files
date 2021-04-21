#include <stdio.h>
#include <stdlib.h>

#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>

#include <unistd.h>
#include <string.h>
#include <stdint.h>

#include <netdb.h>  
#include <net/if.h>  
#include <arpa/inet.h> 
 #include <sys/ioctl.h>
#include <sys/types.h>
 #include <sys/socket.h>
#include <errno.h>

#include "lib/ili9163.h"
#include "lib/gpio.h"

#define TEMP_PATH "/sys/class/thermal/thermal_zone0/temp"
#define MAX_SIZE 32

void Gui_DrawLine(uint16_t x0, uint16_t y0, uint16_t x1, uint16_t y1, uint16_t Color);
void DisplayButtonUp(uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2);
int get_local_ip(char* ifname, char* ip);


int main(int argc, char* argv[])
{
//	struct ifreq ifr;
	int i = 1;
	int fd, f;
	double temp = 0;
	char buf[MAX_SIZE];

	system("echo restart >/tmp/lcd");
	sleep(2);
	system("echo boot >/tmp/lcd");

	if (argc > 1) {
		if (strcmp(argv[1], "boot") == 0)
		{
			pin_mod(LCD, GPIO_OUT);
			pin_mod(LCD, 1);
			sleep(10);
		}
	}

	init_ili9163();
	Lcd_Clear(WHITE);
	if (argc > 1) {
		if (strcmp(argv[1], "boot") == 0)
		{
			Gui_DrawFont_GBK16(8 * 6, 16 * 2, BLACK, 0xEF7D, "BOOT\0");
			Gui_DrawFont_GBK16(8 * 1, 16 * 6, WHITE, 0xEF7D, "              ");
			DisplayButtonUp(8 * 1 - 1, 16 * 6 - 1, 8 * 15 + 1, 16 * 7 + 1);
			for (size_t i = 0; i < 15; i++)
			{
				Gui_DrawFont_GBK16(8 * (1 + i), 16 * 6, 0xEF7D, Orchid, " ");
				//			DisplayButtonUp(8 * 1-1, 16 * 6-1, 8 * 15+1, 16 * 7+1);
				sleep(1);
			}
			Lcd_Clear(WHITE);
			//		sleep(20);
		}
	}

	unsigned char test[] = "CPU_Temp: \0";
//	printf("%d\r\n", sizeof(&test));
//	printf("%d\r\n", sizeof(test[0]));
	Gui_DrawFont_GBK16(8 * 1, 16 * 0, WHITE, BLACK, "     Temp     ");
	Gui_DrawFont_GBK16(8 * 1, 16 * 2, WHITE, BLACK, "      IP      ");
	Gui_DrawFont_GBK16(8 * 1, 16 * 7, WHITE, BLACK, "     END      ");
	Gui_DrawFont_GBK16(8 * 1, 16 * 3, WHITE, Color888to565(0x66, 0xcc, 0xff), "etc0:");
	Gui_DrawFont_GBK16(8 * 1, 16 * 5, WHITE, Color888to565(0xcc, 0x66, 0xff), "wlan:");

	while (i == 1)
		{
		//	int sd;
		//	struct sockaddr_in sin;
		//	struct ifreq ifr;

		//	sd = socket(AF_INET, SOCK_DGRAM, 0);
		//	if (-1 == sd)
		//		      {
		//		          printf("socket error: %s\n", strerror(errno));
		//		          return -1;
		//				  strncpy(ifr.ifr_name, "eth0", IFNAMSIZ);
		//				        ifr.ifr_name[IFNAMSIZ - 1] = 0;
		//				   
		//					        // if error: No such device  
		//					        if (ioctl(sd, SIOCGIFADDR, &ifr) < 0)
		//					        {
		//					            printf("ioctl error: %s\n", strerror(errno));
		//					            close(sd);
		//					            return -1;
		//					        }
		//				   
		//					        memcpy(&sin, &ifr.ifr_addr, sizeof(sin));
		//				        snprintf(buf, 16, "%s", inet_ntoa(sin.sin_addr));
		//				   
		//					        close(sd);
		//	}

		char data[10] = { ' ',' ',' ',' ',' ',' ',' ',' ',' ' };

		f = get_local_ip("eth0", buf);
		printf("%s", f);
	data[0] = buf[0];
	data[1] = buf[1];
	data[2] = buf[2];
	data[3] = buf[3];
	data[4] = buf[4];
	data[5] = buf[5];
	data[6] = buf[6];
	data[7] = buf[7];
	data[8] = ' ';
	data[10] = '\0';
	if(data[0]=='b')
	{
		Gui_DrawFont_GBK16(8 * 6, 16 * 3, BLACK, GBLUE, "NO LINK  ");
		Gui_DrawFont_GBK16(8 * 6, 16 * 4, BLACK, GBLUE, "NO DATA  ");
	}
	else
	{
		Gui_DrawFont_GBK16(8 * 6, 16 * 3, BLACK, GBLUE, data);
		if (buf[9] == '.') {
			data[0] = ' ';
			data[1] = ' ';
			data[2] = buf[8];
			data[3] = buf[9];
			data[4] = buf[10];
			data[5] = buf[11];
			data[6] = buf[12];
			data[7] = ' ';
			data[8] = ' ';
			data[9] = '\0';
		}
		else if (buf[10] == '.') {
			data[0] = ' ';
			data[1] = buf[8];
			data[2] = buf[9];
			data[3] = buf[10];
			data[4] = buf[11];
			data[5] = buf[12];
			data[6] = buf[13];
			data[7] = ' ';
			data[8] = ' ';
			data[9] = '\0';
		}
		else
		{
			data[0] = buf[8];
			data[1] = buf[9];
			data[2] = buf[10];
			data[3] = buf[11];
			data[4] = buf[12];
			data[5] = buf[13];
			data[6] = buf[14];
			data[7] = ' ';
			data[8] = ' ';
			data[9] = '\0';
		}
		//		data = { buf[7],buf[8], buf[9], buf[10], buf[11], buf[12], buf[13],'\0' };
		Gui_DrawFont_GBK16(8 * 6, 16 * 4, BLACK, GBLUE, data);
	}
//		Gui_DrawFont_GBK16(8 * 6, 16 * 5, BLACK, Color888to565(0xcc, 0xff, 0x66), "255.255\0");
		//sd = socket(AF_INET, SOCK_DGRAM, 0);
		//if (-1 == sd)
		//{
		//	printf("socket error: %s\n", strerror(errno));
		//	return -1;
		//	strncpy(ifr.ifr_name, "wlan0", IFNAMSIZ);
		//	ifr.ifr_name[IFNAMSIZ - 1] = 0;

		//	// if error: No such device  
		//	if (ioctl(sd, SIOCGIFADDR, &ifr) < 0)
		//	{
		//		printf("ioctl error: %s\n", strerror(errno));
		//		close(sd);
		//		return -1;
		//	}

		//	memcpy(&sin, &ifr.ifr_addr, sizeof(sin));
		//	snprintf(buf, 16, "%s", inet_ntoa(sin.sin_addr));

		//	close(sd);
		//}
		get_local_ip("wlan0", buf);
		data[0] = buf[0];
		data[1] = buf[1];
		data[2] = buf[2];
		data[3] = buf[3];
		data[4] = buf[4];
		data[5] = buf[5];
		data[6] = buf[6];
		data[7] = buf[7];
		data[8] = ' ';
		data[10] = '\0';
		if (buf[0] == 'b') {
			Gui_DrawFont_GBK16(8 * 6, 16 * 5, BLACK, Color888to565(0xcc, 0xff, 0x66), "NO LINK  ");
			Gui_DrawFont_GBK16(8 * 6, 16 * 6, BLACK, Color888to565(0xcc, 0xff, 0x66), "NO DATA  ");
		}
		else {
			Gui_DrawFont_GBK16(8 * 6, 16 * 5, BLACK, Color888to565(0xcc, 0xff, 0x66), data);
			if (buf[9] == '.') {
				data[0] = ' ';
				data[1] = ' ';
				data[2] = buf[8];
				data[3] = buf[9];
				data[4] = buf[10];
				data[5] = buf[11];
				data[6] = buf[12];
				data[7] = ' ';
				data[8] = ' ';
				data[9] = '\0';
			}
			else if (buf[10] == '.') {
				data[0] = ' ';
				data[1] = buf[8];
				data[2] = buf[9];
				data[3] = buf[10];
				data[4] = buf[11];
				data[5] = buf[12];
				data[6] = buf[13];
				data[7] = ' ';
				data[8] = ' ';
				data[9] = '\0';
			}
			else
			{
				data[0] = buf[8];
				data[1] = buf[9];
				data[2] = buf[10];
				data[3] = buf[11];
				data[4] = buf[12];
				data[5] = buf[13];
				data[6] = buf[14];
				data[7] = ' ';
				data[8] = ' ';
				data[9] = '\0';
			}
			Gui_DrawFont_GBK16(8 * 6, 16 * 6, BLACK, Color888to565(0xcc, 0xff, 0x66), data);
		}
		// 打开/sys/class/thermal/thermal_zone0/temp
		//cpu温度
		fd = open(TEMP_PATH, O_RDONLY);
		if (fd < 0) {
			fprintf(stderr, "faiLED to open thermal_zone0/temp\n");
			return -1;
		}

		// 读取内容
		if (read(fd, buf, MAX_SIZE) < 0) {
			fprintf(stderr, "failed to read temp\n");
			return -1;
		}
		// 转换为浮点数打印
		temp = atoi(buf) / 1000.0;
//		printf("temp: %.2f\n", temp);
		sprintf(buf, "%.4f\r", temp);
		strcat(buf, " \0");
		//strcat("CPU:", buf);
		if (temp < 50)
		{
			Gui_DrawFont_GBK16(8 * 1, 16 * 1, BLACK, Orchid, "CPU: \0");
			Gui_DrawFont_GBK16(8 * 6, 16 * 1, BLACK, Color888to565(0, 0xff, 0x00), buf);

		}
		else if (temp > 60)
		{
			Gui_DrawFont_GBK16(8 * 1, 16 * 1, BLACK, Orchid, "CPU: \0");
			Gui_DrawFont_GBK16(8 * 6, 16 * 1, BLACK, Color888to565(0xff, 0x00, 0x00), buf);

		}else
		{
			Gui_DrawFont_GBK16(8 * 1, 16 * 1, BLACK, Orchid, "CPU: \0");
			Gui_DrawFont_GBK16(8 * 6, 16 * 1, BLACK, Color888to565(0xff,0x7f,0x00), buf);
		}
		close(fd);
		sleep(2);
//		i = 0;
		//判断关机
//		char buff[11];
		fd = open("/tmp/lcd", O_RDONLY);
		if (fd < 0) {
			fprintf(stderr, "/tmp/lcd open error");
		}
		if (read(fd, buf, MAX_SIZE) < 0) {
			fprintf(stderr, "failed to read temp\n");
		}
//		printf(buf);
		if (buf[0] == 'p' && buf[1] == 'o' && buf[2] == 'w' && buf[3] == 'e' && buf[4] == 'r' && buf[5] == 'o' && buf[6] == 'f' && buf[7] == 'f')
		{
			Gui_DrawFont_GBK16(8 * 0, 20, BLACK, WHITE, "    Power OFF   \0");
			return 1;
			i = 0;
		}
		if (buf[0] == 'r' && buf[1] == 'e' && buf[2] == 's' && buf[3] == 't' && buf[4] == 'a' && buf[5] == 'r' && buf[6] == 't')
		{
			Gui_DrawFont_GBK16(8 * 0, 20, BLACK, WHITE, "   Hello fool    \0");
//			DisplayButtonUp(8 * 3 - 1, 20 - 1, 8 * 13 + 1, (16 * 1 + 1)+20);
			return 1;
			i = 0;
		}
		close(fd);
//		return 1;
	}
//	system("reboot");
	

}


/**************************************************************************************
功能描述: 在屏幕显示一凹下的按钮框
输    入: u16 x1,y1,x2,y2 按钮框左上角和右下角坐标
输    出: 无
**************************************************************************************/
void DisplayButtonUp(uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2)
{
#define GRAY0   0xEF7D   	//灰色0 3165 00110 001011 00101
#define GRAY1   0x8410      	//灰色1      00000 000000 00000
#define GRAY2   0x4208      	//灰色2  1111111111011111

	Gui_DrawLine(x1, y1, x2, y1, WHITE); //H
	Gui_DrawLine(x1, y1, x1, y2, WHITE); //V

	Gui_DrawLine(x1 + 1, y2 - 1, x2, y2 - 1, GRAY1);  //H
	Gui_DrawLine(x1, y2, x2, y2, GRAY2);  //H
	Gui_DrawLine(x2 - 1, y1 + 1, x2 - 1, y2, GRAY1);  //V
	Gui_DrawLine(x2, y1, x2, y2, GRAY2); //V
}
//画线函数，使用Bresenham 画线算法
void Gui_DrawLine(uint16_t x0, uint16_t y0, uint16_t x1, uint16_t y1, uint16_t Color)
{
	int dx,             // difference in x's
		dy,             // difference in y's
		dx2,            // dx,dy * 2
		dy2,
		x_inc,          // amount in pixel space to move during drawing
		y_inc,          // amount in pixel space to move during drawing
		error,          // the discriminant i.e. error i.e. decision variable
		index;          // used for looping	


	Lcd_SetRegion(x0, y0, x0, y0);
	dx = x1 - x0;//计算x距离
	dy = y1 - y0;//计算y距离

	if (dx >= 0)
	{
		x_inc = 1;
	}
	else
	{
		x_inc = -1;
		dx = -dx;
	}

	if (dy >= 0)
	{
		y_inc = 1;
	}
	else
	{
		y_inc = -1;
		dy = -dy;
	}

	dx2 = dx << 1;
	dy2 = dy << 1;

	if (dx > dy)//x距离大于y距离，那么每个x轴上只有一个点，每个y轴上有若干个点
	{//且线的点数等于x距离，以x轴递增画点
		// initialize error term
		error = dy2 - dx;

		// draw the line
		for (index = 0; index <= dx; index++)//要画的点数不会超过x距离
		{
			//画点
			Gui_DrawPoint(x0, y0, Color);

			// test if error has overflowed
			if (error >= 0) //是否需要增加y坐标值
			{
				error -= dx2;

				// move to next line
				y0 += y_inc;//增加y坐标值
			} // end if error overflowed

			// adjust the error term
			error += dy2;

			// move to the next pixel
			x0 += x_inc;//x坐标值每次画点后都递增1
		} // end for
	} // end if |slope| <= 1
	else//y轴大于x轴，则每个y轴上只有一个点，x轴若干个点
	{//以y轴为递增画点
		// initialize error term
		error = dx2 - dy;

		// draw the line
		for (index = 0; index <= dy; index++)
		{
			// set the pixel
			Gui_DrawPoint(x0, y0, Color);

			// test if error overflowed
			if (error >= 0)
			{
				error -= dy2;

				// move to next line
				x0 += x_inc;
			} // end if error overflowed

			// adjust the error term
			error += dx2;

			// move to the next pixel
			y0 += y_inc;
		} // end for
	} // end else |slope| > 1
}

int get_local_ip(char* ifname, char* ip)
{
	char* temp = NULL;
	int inet_sock;
	struct ifreq ifr;

	inet_sock = socket(AF_INET, SOCK_DGRAM, 0);

	memset(ifr.ifr_name, 0, sizeof(ifr.ifr_name));
	memcpy(ifr.ifr_name, ifname, strlen(ifname));

	if (0 != ioctl(inet_sock, SIOCGIFADDR, &ifr))
	{
		perror("ioctl error");
		return -1;
	}

	temp = inet_ntoa(((struct sockaddr_in*)&(ifr.ifr_addr))->sin_addr);
	memcpy(ip, temp, strlen(temp));

	close(inet_sock);

	return 0;
}
