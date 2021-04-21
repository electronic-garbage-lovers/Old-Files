#include "gpio.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

void pin_mod(int pin, int mod)
{
	FILE* p = NULL;
	char shell[40] = "/sys/class/gpio/gpio";
	char buf[5];
	if (mod == 10)
	{
		p = fopen("/sys/class/gpio/export", "w");
		fprintf(p, "%d", pin);
		fclose(p);
		sprintf(buf, "%d", pin);
		strcat(shell, buf);
		strcat(shell, "/direction");
		p = fopen(shell, "w");
		fprintf(p, "out");
		fclose(p);
	}
	if (mod == 0)
	{
		char shell[40] = "/sys/class/gpio/gpio";
		char buf[5];
		sprintf(buf, "%d", pin);
		strcat(shell, buf);
		strcat(shell, "/value");
		p = fopen(shell, "w");
		fprintf(p, "0");
		fclose(p);
	}
	if (mod == 1)
	{
		sprintf(buf, "%d", pin);
		strcat(shell, buf);
		strcat(shell, "/value");
		p = fopen(shell, "w");
		fprintf(p, "1");
		fclose(p);
	}
}
