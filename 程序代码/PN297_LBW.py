import time
import spidev


class xn297(object):
    def __init__(self, bus, device):
        self.bus = bus  #//设置SPI编号
        self.device = device  #//设置SPI channel即CE（CS）线,(spi0有CE0,CE1,SPI1有CE0,CE2)
        self.spi = spidev.SpiDev()  #//定义spi对象

        self.R_REGISTER = 0x00
        self.W_REGISTER = 0x20

        self.R_RX_PAYLOAD = 0x61
        self.W_TX_PAYLOAD = 0xA0
        self.FLUSH_TX = 0xE1
        self.FLUSH_RX = 0xE2
        self.REUSE_TX_PL = 0xE3
        self.ACTIVATE = 0x50
        self.R_RX_PL_WID = 0x60
        self.W_ACK_PAYLOAD = 0xA8
        self.W_TX_PAYLOAD_NOACK = 0xB0
        self.NOP_N = 0xFF
        self.CE_SPI_0 = 0xFC
        self.CE_SPI_1 = 0xFD
        self.RST_FSPI = 0x53

        self.CONFIG = 0x00
        self.EN_AA = 0x01
        self.EN_RXADDR = 0x02
        self.SETUP_AW = 0x03
        self.SETUP_RETR = 0x04
        self.RF_CH = 0x05
        self.RF_SETUP = 0x06
        self.STATUS = 0x07
        self.OBSERVE_TX = 0x08
        self.RPD = 0x09
        self.RX_ADDR_P0 = 0x0A
        self.RX_ADDR_P1 = 0x0B
        self.RX_ADDR_P2 = 0x0C
        self.RX_ADDR_P3 = 0x0D
        self.RX_ADDR_P4 = 0x0E
        self.RX_ADDR_P5 = 0x0F
        self.TX_ADDR = 0x10
        self.RX_PW_P0 = 0x11
        self.RX_PW_P1 = 0x12
        self.RX_PW_P2 = 0x13
        self.RX_PW_P3 = 0x14
        self.RX_PW_P4 = 0x15
        self.RX_PW_P5 = 0x16
        self.FIFO_STATUS = 0x17

        self.DYNPD = 0x1C
        self.FEATURE = 0x1D
        self.DEM_CAL = 0x19
        self.RF_CAL2 = 0x1A
        self.DEM_CAL2 = 0x1B
        self.RF_CAL = 0x1E
        self.BB_CAL = 0x1F

        self.PAYLOAD_WIDTH = 8
        self.CHANNEL_TABLE = [
            2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62, 66,
            70, 74, 78
        ]
        self.TX_ADDRESS_DEF = [0xCC, 0xCC, 0xCC, 0xCC, 0xCC]

        self.RX_DR_FLAG = 0X40  #// 接收中断标志位
        self.TX_DS_FLAG = 0X20  #  // 发送完成中断标志位
        self.RX_TX_FLAG = 0X60  # // 发送接收完成中断标志位，ack_payload 模式下使用
        self.MAX_RT_FLAG = 0X10  # // 发送重传超时中断标志位

        self.NORMAL_MODE = 1
        self.ENHANCE_MODE = 2

        self.Channel_Index = 0
        self.Channel_Set = []
        self.Payload_Count = 2

        self.TRANSMIT_TYPE = self.NORMAL_MODE

        self.DR_1M = 1
        self.DR_2M = 2
        self.DR_250K = 3

        self.DATA_RATE = self.DR_1M

        self.CE_USE_SPI = 1
        self.EN_DYNPLOAD = 0
        self.EN_ACK_PAYLOAD = 0

        if (self.TRANSMIT_TYPE == self.ENHANCE_MODE):
            self.EN_ACK_PAYLOAD = 1
            self.EN_DYNPLOAD = 1

        self.rxdata1 = []
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
        self.SPI_WRite(self.CE_SPI_0, 0)

    def CE_HIGH(self):
        self.SPI_WRite(self.CE_SPI_1, 0)

    # union
    # {
    #     unsigned char ucPayload[self.PAYLOAD_WIDTH];

    # }RF_PAYLOAD;

    def TRANS_RESAULT(self, mode):
        if mode == 'MAX_RT':
            return 0x10
        elif mode == 'TX_DS':
            return 0x20
        elif mode == 'RX_DR':
            return 0x40

    # {
    #     MAX_RT = 0x10,
    #     TX_DS  = 0x20,
    #     RX_DR  = 0x40
    # }

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

    def SPI_WR(self, R_REG):
        self.spi.writebytes([R_REG])

    # /******************************************************************************/
    # //            SPI_RD
    # //                SPI Read BYTE
    # /******************************************************************************/
    def SPI_RD(self):
        return self.spi.readbytes(1)

    # /******************************************************************************/
    # //            SPI_WRITE_BUF
    # //                SPI Write Buffer
    # /******************************************************************************/
    def SPI_WRITE_BUF(self, T_ADDR, W_BUF, T_WIDTH):
        self.SPI_WR(T_ADDR)
        for j in range(T_WIDTH):
            self.SPI_WR(W_BUF[j])

    # /******************************************************************************/
    # //            SPI_Write
    # //                SPI Write Data(1 Byte Address ,1 byte data)
    # /******************************************************************************/

    def SPI_WRite(self, address, wdata):
        self.SPI_WR(address)
        self.SPI_WR(wdata)

    #//***************************************************************

    # def CE_SPI_H(self):
    #     self.SPI_WRite(self.CE_SPI_1, 0)

    # def CE_SPI_L(self):
    #     self.SPI_WRite(self.CE_SPI_0, 0)

    # /******************************************************************************/
    # //            RF_SPIRead
    # //                SPI Read Data(1 Byte Address ,1 byte data return)
    # /******************************************************************************/
    def RF_SPIRead(self, address):
        self.SPI_WR(address)
        tmp = self.SPI_RD()
        return tmp

    # /******************************************************************************/
    # //            SPI_Read_Buf
    # //                SPI Read Data(1 Byte Address ,length byte data read)
    # /******************************************************************************/
    def SPI_Read_Buf(self,length):
        self.CE_LOW()
        temp=self.RF_SPIRead(self.STATUS)
        print(temp)
        if((temp[0]&self.RX_DR_FLAG)==self.RX_DR_FLAG):
            self.SPI_WR(
                self.R_RX_PAYLOAD)  #// Select register to write to and read self.STATUS byte
            for i in range(length):
                self.rxdata1.append(self.SPI_RD())  #// Perform SPI_RW to read byte from XN24L01
            return 0  #// return XN24L01 self.STATUS byte
        else:
            print('NO SING')

    # /******************************************************************************/
    # //            xn297_var_init
    # //                set default channel
    # /******************************************************************************/
    def xn297_var_init(self):
        self.Channel_Set = self.CHANNEL_TABLE[-1]

    # /******************************************************************************/
    # //            XN297_Initial
    # //                Initial RF
    # /******************************************************************************/
    def SPI_init(self):
        self.spi.open(self.bus, self.device)
        self.spi.mode = 0b10
        self.spi.max_speed_hz = 1000000
        self.spi.threewire = True

    # /******************************************************************************/
    # //            XN297_Initial
    # //                Initial RF
    # /******************************************************************************/
    def XN297_Initial(self):
        self.BB_CAL_data = [0x0A, 0x6D, 0x67, 0x9C, 0x46]
        self.RF_CAL_data = [0xF6, 0x37, 0x5D]
        self.RF_CAL2_data = [0xd7, 0x21, 0xef, 0x2C, 0x5A, 0x40]
        self.DEM_CAL_data = [0x01]
        self.DEM_CAL2_data = [0x0b, 0xDF, 0x02]

        self.feature1 = 0x00
        time.sleep(0.2)
        self.SPI_init()
        self.xn297_var_init()
        #delay_ms(2)
        time.sleep(0.002)

        self.SPI_WRite(self.RST_FSPI, 0x5A)  #//Software Reset
        self.SPI_WRite(self.RST_FSPI, 0XA5)

        self.SPI_WRite(self.FLUSH_TX, 0)  #//清FIFO
        self.SPI_WRite(self.FLUSH_RX, 0)
        self.SPI_WRite(self.W_REGISTER + self.STATUS, 0x70)  #//清状态寄存器
        self.SPI_WRite(self.W_REGISTER + self.EN_RXADDR,
                       0x01)  #// Enable Pipe0
        self.SPI_WRite(self.W_REGISTER + self.SETUP_AW,
                       0x03)  #// address witdth is 5 bytes
        self.SPI_WRite(self.W_REGISTER + self.RF_CH, 78)  #//设置通道channel
        self.SPI_WRite(self.W_REGISTER + self.RX_PW_P0,
                       self.PAYLOAD_WIDTH)  #// 16 bytes
        self.SPI_WRITE_BUF(
            self.W_REGISTER + self.TX_ADDR, self.TX_ADDRESS_DEF,
            len(self.TX_ADDRESS_DEF))  #// Writes self.TX_ADDRess to XN24L01
        self.SPI_WRITE_BUF(
            self.W_REGISTER + self.RX_ADDR_P0, self.TX_ADDRESS_DEF,
            len(self.TX_ADDRESS_DEF))  #// RX_Addr0 same as TX_Adr for Auto.Ack
        self.SPI_WRITE_BUF(self.W_REGISTER + self.BB_CAL, self.BB_CAL_data,
                           len(self.BB_CAL_data))
        self.SPI_WRITE_BUF(self.W_REGISTER + self.RF_CAL2, self.RF_CAL2_data,
                           len(self.RF_CAL2_data))
        self.SPI_WRITE_BUF(self.W_REGISTER + self.DEM_CAL, self.DEM_CAL_data,
                           len(self.DEM_CAL_data))
        self.SPI_WRITE_BUF(self.W_REGISTER + self.RF_CAL, self.RF_CAL_data,
                           len(self.RF_CAL_data))
        self.SPI_WRITE_BUF(self.W_REGISTER + self.DEM_CAL2, self.DEM_CAL2_data,
                           len(self.DEM_CAL2_data))
        self.SPI_WRite(self.W_REGISTER + self.DYNPD, 0x00)  #//禁止动态PAYLOAD

        if (self.CE_USE_SPI == 1):  #//SPI控制CE
            self.feature1 |= 0x20

        if (self.PAYLOAD_WIDTH > 32):
            self.feature1 |= 0x18

        if (self.DATA_RATE == self.DR_1M):
            self.SPI_WRite(self.W_REGISTER + self.RF_SETUP, 0x15)
        elif (self.DATA_RATE == self.DR_2M):
            self.SPI_WRite(self.W_REGISTER + self.RF_SETUP, 0x7f)
        elif (self.DATA_RATE == self.DR_250K):
            self.SPI_WRite(self.W_REGISTER + self.RF_SETUP, 0xcf)

        if (self.TRANSMIT_TYPE == self.ENHANCE_MODE):
            self.SPI_WRite(self.W_REGISTER + self.SETUP_RETR,
                           0x01)  #// 250us us, 3 retrans..
            self.SPI_WRite(self.W_REGISTER + self.EN_AA, 0x01)  #//  pipe0自动应答
            self.SPI_WRite(self.ACTIVATE,
                           0x73)  #//使能 self.W_ACK_PAYLOAD 等命令 仅在休眠和待机模式下执行

        if (1 == self.EN_DYNPLOAD):
            self.feature1 |= 0x04
            self.SPI_WRite(self.W_REGISTER + self.DYNPD, 0x01)

        if (1 == self.EN_ACK_PAYLOAD):  #//使能ACK带PAYLOAD
            self.feature1 |= 0x02
            self.SPI_WRite(self.W_REGISTER + self.FEATURE, self.feature1)
        if (self.TRANSMIT_TYPE == self.NORMAL_MODE):
            self.SPI_WRite(self.W_REGISTER + self.SETUP_RETR,
                           0x00)  #// Disable retrans..
            self.SPI_WRite(self.W_REGISTER + self.EN_AA,
                           0x00)  #// Disable AutoAck

    # /******************************************************************************/
    # //            RF_self.STATUS_Read
    # //                read RF IRQ self.STATUS,3bits return
    # /******************************************************************************/
    def RF_STATUS_Read(self):
        data = self.RF_SPIRead(self.STATUS)  #//& 0x70
        return data

    # /******************************************************************************/
    # //            RF_self.STATUS_Clr
    # //                clear RF IRQ
    # /******************************************************************************/
    def RF_STATUS_Clr(self):
        self.SPI_WRite(self.W_REGISTER + self.STATUS, 0x70)

    # /******************************************************************************/
    # //            RF_FIFO_Flush
    # //                clear RF TX/RX FIFO
    # /******************************************************************************/
    def RF_FIFO_Flush(self):
        self.SPI_WRite(self.FLUSH_TX, 0)
        self.SPI_WRite(self.FLUSH_RX, 0)

    # /******************************************************************************/
    # //            TX_Mode
    # //                Set RF into TX mode
    # /******************************************************************************/
    def TX_Mode(self):
        self.SPI_WRite(
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
        self.SPI_WRite(
            self.W_REGISTER + self.CONFIG, 0x8F
        )  #// Set PWR_UP bit, enable CRC(2 bytes) & Prim:TX. MAX_RT & TX_DS enabled.
        #delay_ms(10);
        time.sleep(0.01)
        self.CE_HIGH()
        #  delay_ms(10);
        time.sleep(0.01)

    # /******************************************************************************/
    # //            SetRfChannel
    # //                Set RF TX/RX channel:Channel
    # /******************************************************************************/
    def SetRfChannel(self, Channel):
        self.SPI_WRite(self.W_REGISTER + self.RF_CH, Channel)

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
    def ucXN297_TX(self, Payload, length):
        self.SPI_WRITE_BUF(self.W_TX_PAYLOAD, Payload, length)
        #delay_ms(2);
        time.sleep(0.002)

    #// 用于统计收到ACK数量
    def RF_Tx_CheckResult(self, ucAckPayload, length):
        self.STATUS1 = 0
        self.STATUS1 = self.RF_self.STATUS_Read()
        if (self.STATUS1 == self.RX_TX_FLAG):  #//增强型发送成功且收到payload
            self.SPI_Read_Buf(self.R_RX_PAYLOAD, ucAckPayload, length)
        elif (self.STATUS1 == self.TX_DS_FLAG):  #// 普通型发送完成 或 增强型发送成功
            self.Payload_Count = self.Payload_Count + 1  #// 增强型模式，累计ack次数
        elif (self.STATUS1 == self.MAX_RT_FLAG):  #// 增强型发送超时失败
            self.RF_FIFO_Flush()
            self.RF_self.STATUS_Clr()

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
        self.SPI_WRite(self.W_REGISTER + self.CONFIG, 0x8E)
        self.SPI_WRite(self.W_REGISTER + self.RF_CH, 0x4e)
        self.SPI_WRite(self.W_REGISTER + self.RF_SETUP, 0xd5)
        self.SPI_WRITE_BUF(self.W_REGISTER + self.BB_CAL, self.BB_CAL_data,
                           len(self.BB_CAL_data))
        self.SPI_WRITE_BUF(self.W_REGISTER + self.RF_CAL2, self.RF_CAL2_data,
                           len(self.RF_CAL2_data))
        self.SPI_WRITE_BUF(self.W_REGISTER + self.DEM_CAL, self.DEM_CAL_data,
                           len(self.DEM_CAL_data))
        self.SPI_WRITE_BUF(self.W_REGISTER + self.RF_CAL, self.RF_CAL_data,
                           len(self.RF_CAL_data))
        self.SPI_WRITE_BUF(self.W_REGISTER + self.DEM_CAL2, self.DEM_CAL2_data,
                           len(self.DEM_CAL2_data))
        #delay_10us(500);								//delay 500us

    def RF_Read_PIL(self):
        data = self.RF_SPIRead(self.RF_Read_PIL)  #//& 0x70
        return data

    #//***************************************end of file *************************************