#include "sys.h"

#ifndef _SPI_H_
#define _SPI_H_




#define SPI_SCLK        GPIO_Pin_15	//PB13--->>TFT --SCL/SCK
#define SPI_MOSI        GPIO_Pin_3	//PB15 MOSI--->>TFT --SDA/DIN

//Òº¾§¿ØÖÆ¿ÚÖÃ1²Ù×÷Óï¾äºê¶¨Òå

#define	SPI_MOSI_SET  	GPIOB->BSRR=SPI_MOSI    
#define	SPI_SCLK_SET  	GPIOA->BSRR=SPI_SCLK    


//Òº¾§¿ØÖÆ¿ÚÖÃ0²Ù×÷Óï¾äºê¶¨Òå

#define	SPI_MOSI_CLR  	GPIOB->BRR=SPI_MOSI    
#define	SPI_SCLK_CLR  	GPIOA->BRR=SPI_SCLK    

void  SPIv_WriteData(u8 Data);

#endif
