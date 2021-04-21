import time
#import spidev
 


class pn297(object):
    def __init__(self, device):
        #self.bus = bus  #//设置SPI编号
        self.device = device  #//设置SPI channel即CE（CS）线,(spi0有CE0,CE1,SPI1有CE0,CE2)
        #self.spi = spidev.SpiDev()  #//定义spi对象

        #命令<命令字：由高位到低位（每字节）> <数据字节：低字节到高字节，每一字节高位在前>
        #R_REGISTER 和 W_REGISTER 寄存器可能操作单字节或多字节寄存器。
        # 当访问多字节寄存器时首先要读/写的是最低字节的高位。对于多字节寄存器可以只写部分字节，
        # 没有写的高字节保持原有内容不变。例如：RX_ADDR_P0
        # 寄存器的最低字节可以通过写一个字节给寄存器 RX_ADDR_P0 来改变。

        self.R_REGISTER = 0x00
        #读状态寄存器 加AAAAA=5bit 寄存器地址   后带数据1 to 5低字节在前
        self.W_REGISTER = 0x20
        #写状态寄存器 加AAAAA=5bit 寄存器地址，仅在休眠和待机模式-I 下执行。
        # 后带数据1 to 5低字节在前

        self.R_RX_PAYLOAD = 0x61
        #读接收数据，读操作通常由第 0 字节开始，读完过后数据将从 RX FIFO 中删除，接收模式下执行。
        # 后带数据1 to 32/64
        self.W_TX_PAYLOAD = 0xA0
        #写发射数据，写操作通常由 0 字节开始。后带数据1 to 32/64
        self.FLUSH_TX = 0xE1
        #清 TX FIFO, TX 模式下执行。后带数据0
        self.FLUSH_RX = 0xE2
        #清 RX FIFO, RX 模式下执行。后带数据0
        self.REUSE_TX_PL = 0xE3
        #用在 PTX 端，再次使用最后一帧发送的数据并且发送。后带数据0
        # #该命令在刚发送数据并执行 FLUSH_TX 命令后可用。该命令不可以在发送数据的过程中使用。
        self.ACTIVATE = 0x50
        #用该命令后跟数据 0x73，将激活以下功能•
        # R_RX_PL_WID• W_TX_PAYLOAD_NOACK• W_ACK_PAYLOAD
        # 该命令仅在休眠模式和待机模式下执行。用该命令后跟数据 0x8C，将关闭上述功能。
        # 后带数据1
        self.R_RX_PL_WID = 0x60
        #读 RX FIFO 最顶部 RX-payload数据宽度。后带数据0
        self.W_ACK_PAYLOAD = 0xA8
        #Rx 模式可用写PIPE PPP（PPP 的值从000 到101）响应ACK 时同时回传的数据。
        # 最多可设置2个ACK 数据包。同PIPE 的数据将以先进先出的原则发送。
        # 写操作通常从 0 字节开始。
        #后带数据1 to 64
        self.W_TX_PAYLOAD_NOACK = 0xB0
        #写发射数据，写操作通常由 0 字节开始。TX 模式下执行，使用该命令发送数据不判自动应答。
        #后带数据1 to 32/64
        self.NOP_N = 0xFF
        #无操作。后带数据0
        self.CE_SPI_0 = 0xFC
        #SPI 命令使 CE 内部逻辑置 1，用该命令后跟数据 0x00。后带数据1
        self.CE_SPI_1 = 0xFD
        #SPI 命令使 CE 内部逻辑置 0，用该命令后跟数据 0x00。后带数据1
        self.RST_FSPI = 0x53
        #RST_FSPI_HOLD
        #用该命令后跟数据 0x5A，使得进入复位状态并保持。后带数据1
        #RST_FSPI_RELS
        #用该命令后跟数据 0xA5，使得释放复位状态并开始正常工作。后带数据1

        #控制寄存器地址
        self.CONFIG = 0x00
        self.EN_AA = 0x01
        self.EN_RXADDR = 0x02
        self.SETUP_AW = 0x03
        self.SETUP_RETR = 0x04
        self.RF_CH = 0x05
        self.RF_SETUP = 0x06
        self.STATUS = 0x07
        self.OBSERVE_TX = 0x08
        self.DATAOUT = 0x09
        self.RX_ADDR_P = [
            0x0A,  #默认值0xE7E7E7E7E7
            0x0B,  #默认值0xC2C2C2C2C2
            0x0C,  #默认值0xC3
            0x0D,  #默认值0xC4
            0x0E,  #默认值0xC5
            0x0F  #默认值0xC6
        ]
        self.TX_ADDR = 0x10  #默认值0xE7E7E7E7E7
        self.RX_PW_P = [0x11, 0x12, 0x13, 0x14, 0x15, 0x16]
        self.FIFO_STATUS = 0x17
        self.TX_PLD = []  #255:0,数据存放在2级32字节或1级64字节FIFO中
        self.RX_PLD = []  #255:0,数据存放在2级32字节或1级64字节FIFO中
        self.DEM_CAL = 0x19
        self.RF_CAL2 = 0x1A
        self.DEM_CAL2 = 0x1B
        self.DYNPD = 0x1C
        self.FEATURE = 0x1D
        self.RF_CAL = 0x1E
        self.BB_CAL = 0x1F

        self.CHANNEL_TABLE = [
            2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62, 66,
            70, 74, 78
        ]
        self.TX_ADDRESS_DEF = [0xCC, 0xCC, 0xCC, 0xCC, 0xCC]
        #TX P0地址设置，P2-P5仅能设置最低位地址。
        self.RX_ADDRESS_DEF = [[0xCC, 0xCC, 0xCC, 0xCC, 0xCC],
                               [0xBC, 0xBC, 0xBC, 0xBC, 0x01], [0x02], [0x03],
                               [0x04], [0x05]]
        #TX P0地址设置，P2-P5仅能设置最低位地址。

        self.RX_DR_FLAG = 0X40  #// 接收中断标志位
        self.TX_DS_FLAG = 0X20  #  // 发送完成中断标志位
        self.RX_TX_FLAG = 0X60  # // 发送接收完成中断标志位，ack_payload 模式下使用
        self.MAX_RT_FLAG = 0X10  # // 发送重传超时中断标志位

        self.NORMAL_MODE = 1
        self.ENHANCE_MODE = 2

        self.Channel_Index = 0
        self.Channel_Set = []
        self.Payload_Count = 0

        self.TRANSMIT_TYPE = self.ENHANCE_MODE

        #self.Data_Bits=64 #fifo数据模式，32bits,64bits
        self.PAYLOAD_WIDTH = 32  #fifo数据模式，32bits,64bits

        self.DR_1M = 1
        self.DR_2M = 2
        self.DR_250K = 3

        self.DATA_RATE = self.DR_1M

        self.CE_USE_SPI = 1
        if self.TRANSMIT_TYPE == self.NORMAL_MODE:
            self.EN_DYNPLOAD = 0
            self.EN_ACK_PAYLOAD = 0
        else:
            self.EN_DYNPLOAD = 1
            self.EN_ACK_PAYLOAD = 1
        #self.rxdata1 = []

        #使能 W_TX_PAYLOAD_NOACK 命令
        self.EN_NOACK = 1
        """ 
        if (self.TRANSMIT_TYPE == self.ENHANCE_MODE):
            self.EN_ACK_PAYLOAD = 1
            self.EN_DYNPLOAD = 1
        """

        # if (self.CE_USE_SPI == 0):

        #     def CE_LOW(self):
        #         pass

        #     #CE_PIN_LOW()
        #     def CE_HIGH(self):
        #         pass

        #     #CE_PIN_HIGH()
        # else:
        #     def CE_LOW(self):
        #         CE_SPI_L()

        #     def CE_HIGH(self):
        #         CE_SPI_H()
    def CE_LOW(self):
        self.RF_WRite(self.CE_SPI_0, 0)

    def CE_HIGH(self):
        self.RF_WRite(self.CE_SPI_1, 0)

    def spi_gpio_init(self):
        #gpiochannl: data = 19,sck=23,cs0=24,cs1=26
        GPIO.setmode(GPIO.BOARD)
        GPIO_Channel = [19, 23, 24, 26]
        for x in GPIO_Channel:
            try:
                GPIO.setup(x, GPIO.OUT)
            except:
                pass

    def gpio_input(self, pin=19):
        if GPIO.input(pin) == GPIO.HIGH:
            return 1
        else:
            return 0

    def gpio_output(self, pin, bit):
        if bit == 0:
            GPIO.output(pin, GPIO.LOW)
        else:
            GPIO.output(pin, GPIO.HIGH)

    def dataoutmode(self):
        GPIO.setup(19, GPIO.OUT)

    def datainmode(self):
        GPIO.setup(19, GPIO.IN)

    def dataout(self, bit):
        #GPIO.setup(19, GPIO.OUT)
        self.gpio_output(19, bit=bit)

    def datain(self):
        #GPIO.setup(19, GPIO.IN)
        return GPIO.input(19)

    def sck(self, bit):
        self.gpio_output(23, bit)

    def cs(self, bit):
        if self.device == 0:
            self.gpio_output(24, bit)
        else:
            self.gpio_output(26, bit)

    # def cs0(self, bit):
    #     self.gpio_output(24, bit)

    # def cs1(self, bit):
    #     self.gpio_output(26, bit)

    # union
    # {
    #     unsigned char ucPayload[self.PAYLOAD_WIDTH];

    # }RF_PAYLOAD;

    # MAX_RT = 0x10
    # TX_DS  = 0x20
    # RX_DR  = 0x40
    # RX_TX_CMP=0x60

    def PL_CMD(self, mode):
        if mode == 'RFIDLE_CMD':
            return 0x00
        elif mode == 'MATCH_REQ_CMD':
            return 0x01
        elif mode == 'MATCH_RES_CMD':
            return 0x02
        elif mode == 'MOUSE_CMD':
            return 0x03
        elif mode == 'CHNHOP_CMD':
            return 0x04
        elif mode == 'ADDR_CHG_CMD':
            return 0x05
        elif mode == 'FACTORY_TEST':
            return 0x06
        elif mode == 'CHN_CHG_CMD2':
            return 0x07
        elif mode == 'TEST_MODE_CMD':
            return 0x08
        elif mode == 'PL_CMD_BITS':
            return 0x0f

    # enum PL_CMD
    # {
    #     RFIDLE_CMD      = 0x00,
    #     MATCH_REQ_CMD   = 0x01,
    #     MATCH_RES_CMD   = 0x02,
    #     MOUSE_CMD       = 0x03,
    #     CHNHOP_CMD      = 0x04,
    #     ADDR_CHG_CMD    = 0x05,
    #     FACTORY_TEST    = 0x06,
    #     CHN_CHG_CMD2    = 0x07,
    #     TEST_MODE_CMD   = 0x08,
    #     PL_CMD_BITS     = 0x0f
    # };

    # /******************************************************************************/
    # //            SPI_WW
    # //                SPI Write BYTE
    # /******************************************************************************/
    """ 
    def SPI_WR(self, R_REG):
        self.spi.writebytes([R_REG])
    """

    def SPI_WR(self, R_REG):
        R_REG_ww = R_REG
        for i in range(8):
            self.sck(0)
            if (R_REG_ww & 0x80):
                self.dataout(1)
            else:
                self.dataout(0)
            R_REG_ww = R_REG_ww << 1
            self.sck(1)
        self.sck(0)

    # /******************************************************************************/
    # //            SPI_RD
    # //                SPI Read BYTE
    # /******************************************************************************/
    """ 
    def SPI_RD(self):
        return self.spi.readbytes(1)
    """

    def SPI_RD_w(self, R_REG):
        R_REG_wr = R_REG
        for i in range(8):
            self.sck(0)
            if (R_REG_wr & 0x80):
                self.dataout(1)
            else:
                self.dataout(0)
            R_REG_wr = R_REG_wr << 1
            self.sck(1)
        self.datainmode()
        self.sck(0)

    def SPI_RD_r(self):
        rd_data = 0
        for i in range(8):
            self.sck(0)
            rd_data = rd_data << 1
            self.sck(1)
            if (self.datain()):
                rd_data = rd_data | 0x01
        self.sck(0)
        # re=hex(rd_data)
        # print(re)
        return rd_data

    # def SPI_RD(self, R_REG):
    #     self.cs(0)
    #     self.SPI_RD_w(R_REG)
    #     data_RD = self.SPI_RD_r()
    #     self.dataoutmode()
    #     self.cs(1)
    #     return data_RD

    # /******************************************************************************/
    # //            RF_WRite_BUF
    # //                SPI Write Buffer
    # /******************************************************************************/
    def RF_WRite_BUF(self, T_ADDR, W_BUF, T_WIDTH):
        self.cs(0)
        self.SPI_WR(T_ADDR)
        for j in range(T_WIDTH):
            self.SPI_WR(W_BUF[j])
        self.cs(1)

    # /******************************************************************************/
    # //            RF_WRite
    # //                SPI Write Data(1 Byte Address ,1 byte data)
    # /******************************************************************************/

    def RF_WRite(self, address, wdata):
        self.cs(0)
        self.SPI_WR(address)
        self.SPI_WR(wdata)
        self.cs(1)

    #//***************************************************************

    # def CE_SPI_H(self):
    #     self.RF_WRite(self.CE_SPI_1, 0)

    # def CE_SPI_L(self):
    #     self.RF_WRite(self.CE_SPI_0, 0)

    # /******************************************************************************/
    # //            RF_SPIRead
    # //                SPI Read Data(1 Byte Address ,1 byte data return)
    # /******************************************************************************/

    # def RF_SPIRead(self, address):
    #     self.SPI_WR(address)
    #     tmp = self.SPI_RD()
    #     return tmp

    def RF_Read(self, address):
        self.cs(0)
        self.SPI_RD_w(address)
        data_RD = self.SPI_RD_r()
        self.dataoutmode()
        self.cs(1)
        #print('rf_read=',hex(data_RD))
        return data_RD

    # /******************************************************************************/
    # //            xn297_var_init
    # //                set default channel
    # /******************************************************************************/
    def xn297_var_init(self):
        self.Channel_Set = self.CHANNEL_TABLE[3]

    # /******************************************************************************/
    # //            XN297_Initial
    # //                Initial RF
    # /******************************************************************************/
    # def SPI_init(self):
    #     self.spi.open(self.bus, self.device)
    #     self.spi.mode = 0b00
    #     self.spi.max_speed_hz = 1000
    #     self.spi.threewire = True

    def close(self):
        #self.spi.close()
        GPIO.cleanup()

    # /******************************************************************************/
    # //            XN297_Initial
    # //                Initial RF
    # /******************************************************************************/
    def Initial(self):
        self.BB_CAL_data = [0x0A, 0x6D, 0x67, 0x9C, 0x46]
        self.RF_CAL_data = [0xF6, 0x37, 0x5D]
        self.RF_CAL2_data = [0x45, 0x21, 0xef, 0x2C, 0x5A,
                             0x50]  #[0x45, 0x21, 0xef, 0x2C, 0x5A, 0x50]
        self.DEM_CAL_data = [0x01]
        self.DEM_CAL2_data = [0x0b, 0xDF, 0x02]

        self.feature1 = 0x00
        time.sleep(0.2)
        #self.SPI_init()
        self.spi_gpio_init()
        self.xn297_var_init()
        #delay_ms(2)
        time.sleep(0.002)

        self.RF_WRite(self.RST_FSPI, 0x5A)  #//Software Reset
        self.RF_WRite(self.RST_FSPI, 0XA5)
        #dd=self.RF_Read(self.RST_FSPI)
        #print(dd)

        self.RF_WRite(self.FLUSH_TX, 0)  #//清FIFO
        self.RF_WRite(self.FLUSH_RX, 0)
        self.RF_WRite(self.W_REGISTER + self.STATUS, 0x70)  #//清状态寄存器
        #self.RF_WRite(self.W_REGISTER + self.EN_RXADDR, 0b00111111)  #// Enable Pipe0-Pipe5
        self.RF_WRite(self.W_REGISTER + self.SETUP_AW,
                      0x03)  #// address witdth is 5 bytes
        self.RF_WRite(self.W_REGISTER + self.RF_CH, 78)  #//设置通道channel
        #设置每个通道接收数据的长度，应与TX芯片发送数据的长度相等，当使用动态PAYLOAD时，可不管此命令。
        for i in range(6):
            if i < 2:
                self.RF_WRite(self.W_REGISTER + self.RX_PW_P[i], 8)
            else:
                self.RF_WRite(self.W_REGISTER + self.RX_PW_P[i], 8)

        self.RF_WRite_BUF(
            self.W_REGISTER + self.TX_ADDR, self.TX_ADDRESS_DEF,
            len(self.TX_ADDRESS_DEF))  #// Writes self.TX_ADDRess to XN24L01
        for i in range(6):
            self.RF_WRite_BUF(self.W_REGISTER + self.RX_ADDR_P[i],
                              self.RX_ADDRESS_DEF[i],
                              len(self.RX_ADDRESS_DEF[i]
                                  ))  #// RX_Addr0 same as TX_Adr for Auto.Ack
        self.RF_WRite_BUF(self.W_REGISTER + self.BB_CAL, self.BB_CAL_data,
                          len(self.BB_CAL_data))
        self.RF_WRite_BUF(self.W_REGISTER + self.RF_CAL2, self.RF_CAL2_data,
                          len(self.RF_CAL2_data))
        self.RF_WRite_BUF(self.W_REGISTER + self.DEM_CAL, self.DEM_CAL_data,
                          len(self.DEM_CAL_data))
        self.RF_WRite_BUF(self.W_REGISTER + self.RF_CAL, self.RF_CAL_data,
                          len(self.RF_CAL_data))
        self.RF_WRite_BUF(self.W_REGISTER + self.DEM_CAL2, self.DEM_CAL2_data,
                          len(self.DEM_CAL2_data))
        self.RF_WRite(self.W_REGISTER + self.DYNPD, 0x00)  #//禁止动态PAYLOAD

        #设置RF最大速率及发送接收功率
        if (self.DATA_RATE == self.DR_1M):
            self.RF_WRite(self.W_REGISTER + self.RF_SETUP, 0x3f)  #15
        elif (self.DATA_RATE == self.DR_2M):
            self.RF_WRite(self.W_REGISTER + self.RF_SETUP, 0x7f)
        elif (self.DATA_RATE == self.DR_250K):
            self.RF_WRite(self.W_REGISTER + self.RF_SETUP, 0xcf)

        if (self.TRANSMIT_TYPE == self.ENHANCE_MODE):
            #// 自动重传延时及次数设置 250us*self.SETUP_RETR&0xf0, 重传次数self.SETUP_RETR&0x0f
            self.RF_WRite(self.W_REGISTER + self.SETUP_RETR, 0xff)
            #//  pipe0-5自动应答
            self.RF_WRite(self.W_REGISTER + self.EN_AA, 0x3f)
            #//  en pipe0-5自动接收
            self.RF_WRite(self.W_REGISTER + self.EN_RXADDR, 0x3f)
            #//使能 self.W_ACK_PAYLOAD 等命令 仅在休眠和待机模式下执行
            self.RF_WRite(self.ACTIVATE, 0x73)

        # if (self.PAYLOAD_WIDTH < 33):
        #     #//payload=32bits,1：CE 由命令方式控制,使能动态 PAYLOAD 长度
        #     #使能 ACK 带 PAYLOAD,W_TX_PAYLOAD_NOACK 命令
        #     self.RF_WRite(self.W_REGISTER + self.FEATURE, 0x27)
        # else:
        #     #//payload=64bits,1：CE 由命令方式控制,使能动态 PAYLOAD 长度
        #     #使能 ACK 带 PAYLOAD,W_TX_PAYLOAD_NOACK 命令
        #     self.RF_WRite(self.W_REGISTER + self.FEATURE, 0x3f)

        #设置FEATURE寄存器
        #//SPI控制CE
        if (1 == self.CE_USE_SPI):
            self.feature1 |= 0x20
        #//payload=64bits
        if (self.PAYLOAD_WIDTH > 32):
            self.feature1 |= 0x18
        #使能动态 PAYLOAD 长度
        if (1 == self.EN_DYNPLOAD):
            self.feature1 |= 0x04
            self.RF_WRite(self.W_REGISTER + self.DYNPD, 0x3f)
        #//使能ACK带PAYLOAD
        if (1 == self.EN_ACK_PAYLOAD):
            self.feature1 |= 0x02
        #//使能W_TX_PAYLOAD_NOACK 命令
        if (1 == self.EN_NOACK):
            self.feature1 |= 0x01
        self.RF_WRite(self.W_REGISTER + self.FEATURE, self.feature1)

        if (self.TRANSMIT_TYPE == self.NORMAL_MODE):
            #关闭自动重传
            self.RF_WRite(self.W_REGISTER + self.SETUP_RETR,
                          0x00)  #// Disable retrans..
            #关闭自动ACK
            self.RF_WRite(self.W_REGISTER + self.EN_AA,
                          0x00)  #// Disable AutoAck

    # /******************************************************************************/
    # //            RF_self.STATUS_Read
    # //                read RF IRQ self.STATUS,3bits return
    # /******************************************************************************/
    def RF_STATUS_Read(self):
        data = self.RF_Read(self.STATUS) & 0x70
        return data

    # /******************************************************************************/
    # //            RF_self.STATUS_Clr
    # //                clear RF IRQ
    # /******************************************************************************/
    def RF_STATUS_Clr(self):
        self.RF_WRite(self.W_REGISTER + self.STATUS, 0x70)

    # /******************************************************************************/
    # //            RF_FIFO_Flush
    # //                clear RF TX/RX FIFO
    # /******************************************************************************/
    def RF_FIFO_Flush(self):
        self.RF_WRite(self.FLUSH_TX, 0)
        self.RF_WRite(self.FLUSH_RX, 0)

    # /******************************************************************************/
    # //            TX_Mode
    # //                Set RF into TX mode
    # /******************************************************************************/
    def TX_Mode(self):
        #self.CE_LOW()
        self.RF_WRite(
            self.W_REGISTER + self.CONFIG, 0x8e
        )  #// Set PWR_UP bit, enable CRC(2 bytes) & Prim:TX. MAX_RT & TX_DS enabled.
        #delay_ms(10);
        time.sleep(0.01)
        self.CE_HIGH()
        #  delay_ms(10);
        time.sleep(0.01)

    # /******************************************************************************/
    # //            RX_Mode
    # //                Set RF into RX mode and start to receive
    # /******************************************************************************/
    def RX_Mode(self):
        #self.CE_LOW()
        self.RF_WRite(
            self.W_REGISTER + self.CONFIG, 0x8F
        )  #// Set PWR_UP bit, enable CRC(2 bytes) & Prim:TX. MAX_RT & TX_DS enabled.
        #delay_ms(10);
        time.sleep(0.01)
        RF_cal_data = [0x06, 0xB7, 0x5D]  #[0x06, 0x37, 0x5D]
        self.RF_WRite_BUF(self.W_REGISTER + self.RF_CAL, RF_cal_data,
                          len(RF_cal_data))
        #time.sleep(0.01)
        self.CE_HIGH()
        #  delay_ms(10);
        time.sleep(0.01)

    # /******************************************************************************/
    # //            SetRfChannel
    # //                Set RF TX/RX channel:Channel
    # /******************************************************************************/
    def SetRfChannel(self, Channel):
        self.RF_WRite(self.W_REGISTER + self.RF_CH, Channel)

    # /******************************************************************************/
    # //            self.RF_CHannel_Next
    # //                Hop to next channel
    # /******************************************************************************/

    def RF_CHannel_Next(self, Channel_Index):
        if ((self.Channel_Index == 0)
                or (self.Channel_Index >= len(self.CHANNEL_TABLE))):
            self.Channel_Index = len(self.CHANNEL_TABLE) - 1
        else:
            self.Channel_Index = self.Channel_Index - 1
        self.Channel_Set = self.CHANNEL_TABLE[self.Channel_Index]
        self.SetRfChannel(self.Channel_Set)

    # /******************************************************************************/
    # //            RF_SetCurrentChannel
    # //                write RF channel
    # /******************************************************************************/
    def RF_SetCurrentChannel(self):
        self.SetRfChannel(self.Channel_Set)

    # /******************************************************************************/
    # //            ucXN2401_TX
    # //                Transmit data(*Payload) from RF(without clear IRQ)
    # /******************************************************************************/
    def uc_TX(self, Payload, length):
        #self.CE_HIGH()
        time.sleep(0.01)
        self.RF_WRite_BUF(self.W_TX_PAYLOAD, Payload, length)
        #delay_ms(2);
        time.sleep(0.01)

        #self.CE_LOW()


# /******************************************************************************/
# //            SPI_Read_Buf
# //                SPI Read Data(1 Byte Address ,length byte data read)
# /******************************************************************************/
# def SPI_Read_Buf(self, length):
#     self.CE_LOW()
#     temp = self.RF_SPIRead(self.STATUS)
#     print(temp)
#     if ((temp[0] & self.RX_DR_FLAG) == self.RX_DR_FLAG):
#         self.SPI_WR(
#             self.R_RX_PAYLOAD
#         )  #// Select register to write to and read self.STATUS byte
#         for i in range(length):
#             self.rxdata1.append(self.SPI_RD(
#             ))  #// Perform SPI_RW to read byte from XN24L01
#         return 0  #// return XN24L01 self.STATUS byte
#     else:
#         print('NO SING')

    def uc_RX(self, reg, length):
        self.cs(0)
        #self.CE_HIGH()
        time.sleep(0.01)
        self.SPI_RD_w(reg)
        buf_temp = []
        for i in range(length):
            buf_temp.append(self.SPI_RD_r())
       # self.CE_LOW()
        time.sleep(0.01)
        self.dataoutmode()
        self.cs(1)
        #buf = buf_temp
        #print('buf_temp=',buf_temp,'buf=',buf)
        return buf_temp

    #// 用于统计收到ACK数量
    def RF_Tx_CheckResult(self):
        self.STATUS1 = 0
        self.STATUS1 = self.RF_STATUS_Read()
        if (self.STATUS1 == self.RX_TX_FLAG):  #//增强型发送成功且收到payload
            dd = self.uc_RX(self.R_RX_PAYLOAD, 16)
            print('增强型发送成功且收到payload')
            print('R_RX_PAYLOAD=', dd)
        elif (self.STATUS1 == self.TX_DS_FLAG):  #// 普通型发送完成 或 增强型发送成功
            print('普通型发送完成 或 增强型发送成功')
            self.Payload_Count = self.Payload_Count + 1  #// 增强型模式，累计ack次数
            print('发送端收到ACK的数量：', self.Payload_Count)
            self.Payload_Count = 0
        elif (self.STATUS1 == self.MAX_RT_FLAG):  #// 增强型发送超时失败
            #self.RF_FIFO_Flush()
            #self.RF_STATUS_Clr()
            print('发送超时')

    # /******************************************************************************/
    # //            RF_CARRIER_TEST
    # //                Set RF into carry mode
    # /******************************************************************************/
    def RF_CARRIER_TEST(self):
        self.BB_CAL_data = [0x0a, 0x6d, 0x67, 0x9c, 0x46]
        self.RF_CAL_data = [0xf6, 0x33, 0x5d]
        self.RF_CAL2_data = [0x45, 0x21, 0xef, 0x2c, 0x5a, 0x40]
        self.DEM_CAL_data = [0xE1]
        self.DEM_CAL2_data = [0x0b, 0xdf, 0x02]

        self.CE_LOW()
        #delay_10us(500);								//delay 500us
        self.RF_WRite(self.W_REGISTER + self.CONFIG, 0x8E)
        self.RF_WRite(self.W_REGISTER + self.RF_CH, 0x4e)
        self.RF_WRite(self.W_REGISTER + self.RF_SETUP, 0xd5)
        self.RF_WRite_BUF(self.W_REGISTER + self.BB_CAL, self.BB_CAL_data,
                          len(self.BB_CAL_data))
        self.RF_WRite_BUF(self.W_REGISTER + self.RF_CAL2, self.RF_CAL2_data,
                          len(self.RF_CAL2_data))
        self.RF_WRite_BUF(self.W_REGISTER + self.DEM_CAL, self.DEM_CAL_data,
                          len(self.DEM_CAL_data))
        self.RF_WRite_BUF(self.W_REGISTER + self.RF_CAL, self.RF_CAL_data,
                          len(self.RF_CAL_data))
        self.RF_WRite_BUF(self.W_REGISTER + self.DEM_CAL2, self.DEM_CAL2_data,
                          len(self.DEM_CAL2_data))
        #delay_10us(500);								//delay 500us

    def TRANS_RESAULT(self, mode):
        #ucPayload=[1,2,3,4,5,6,7,8]
        if mode == self.MAX_RT_FLAG:  # // 发送重传超时中断标志位
            print('发送重传超时中断标志位')
            # self.RF_FIFO_Flush()
            # self.RF_STATUS_Clr()
        if mode == self.TX_DS_FLAG:  #  // 发送完成中断标志位
            print('发送完成中断标志位')
            # self.RF_FIFO_Flush()
            # self.RF_STATUS_Clr()
        if mode == self.RX_DR_FLAG:  #// 接收中断标志位
            print('接收中断标志位')
            # self.RX_Mode()
            # self.uc_rx1 = []
            # self.len_rx1 = self.RF_Read(self.R_RX_PL_WID)
            # self.uc_rx1 = self.uc_RX(self.R_RX_PAYLOAD, self.len_rx1)
            # print('DATA', self.data_num, f'接收到{self.len_rx1}个数据=', self.uc_rx1)
            # self.TX_Mode()
            # self.RF_FIFO_Flush()
            # self.RF_STATUS_Clr()
        if mode == self.RX_TX_FLAG:  # // 发送接收完成中断标志位，ack_payload 模式下使用
            print('发送接收完成中断标志位，ack_payload 模式下使用')

        self.RF_FIFO_Flush()
        self.RF_STATUS_Clr()

        # self.uc_TX(ucPayload,len(ucPayload))
        # time.sleep(1)
        # fifo=self.RF_Read(self.R_REGISTER+self.FIFO_STATUS)
        # print('fifo=',bin(fifo))
        # self.CE_HIGH()
        # time.sleep(0.1)
        # self.CE_LOW()
        #self.TX_Mode()

    #//***************************************end of file *************************************