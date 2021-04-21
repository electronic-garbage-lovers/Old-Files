#import spidev
import pn297_gpio
import time


class pn(object):
    def __init__(self):
        self.tx_data = [1, 2, 3, 4, 5, 6, 7]
        #self.TX_ADDR1 = []
        self.TX_addr_read_tx = []
        self.TX_addr_read_rx = []
        self.RX_addr_read = []
        self.RX_ADDRESS_DEF = [[0xCC, 0xCC, 0xCC, 0xCC, 0xCC],
                               [0xBC, 0xBC, 0xBC, 0xBC, 0x01],
                               [0xBC, 0xBC, 0xBC, 0xBC, 0x02],
                               [0xBC, 0xBC, 0xBC, 0xBC, 0x03],
                               [0xBC, 0xBC, 0xBC, 0xBC, 0x04],
                               [0xBC, 0xBC, 0xBC, 0xBC, 0x05]]
        self.spi0 = pn297_gpio.pn297(0)
        self.spi1 = pn297_gpio.pn297(1)

    def tx_init(self):

        #spi0 = pn297_gpio.pn297(0)
        self.spi0.TRANSMIT_TYPE = self.spi0.ENHANCE_MODE
        #spi0.TX_ADDR=RX_ADDRESS_DEF0
        self.spi0.close()
        self.spi0.Initial()
        self.spi0.TX_Mode()

    def rx_init(self):
        #self.spi1 = pn297_gpio.pn297(1)
        self.spi1.TRANSMIT_TYPE = self.spi1.ENHANCE_MODE
        self.spi1.close()
        self.spi1.Initial()
        self.spi1.RX_Mode()

    #spi1.RF_Read(spi1.STATUS)
    def tx_test(self):
        while(True):
            for i in range(6):
                ##设置TX芯片与RX芯片的发送及接收地址。
                self.TX_ADDR = self.RX_ADDRESS_DEF[i]
                print(self.TX_ADDR)
                self.spi0.RF_WRite_BUF(self.spi0.W_REGISTER + self.spi0.TX_ADDR,
                                    self.TX_ADDR, len(self.TX_ADDR))
                self.spi0.RF_WRite_BUF(
                    self.spi0.W_REGISTER + self.spi0.RX_ADDR_P[0], self.TX_ADDR,
                    len(self.TX_ADDR))
                #检测接收到的ACK
                # self.spi0.RF_Tx_CheckResult()  #发送端收到ACK的数量
                self.mode = self.spi0.RF_STATUS_Read()
                print('TX_mode=', hex(self.mode))
                if self.mode == 0:
                    print('发送数据')
                    self.tx_data1 = self.tx_data + [i]
                    self.spi0.uc_TX(self.tx_data1, len(self.tx_data1))
                    time.sleep(1)
                self.spi0.RF_Tx_CheckResult()  #发送端收到ACK的数量
                #显示丢失数据包及重传计数次数
                self.plos_arc_count = self.spi0.RF_Read(self.spi0.R_REGISTER +
                                                        self.spi0.OBSERVE_TX)
                self.plos_count = self.plos_arc_count >> 8
                self.arc_count = self.plos_arc_count & 0xf
                print(f'丢失数据包数量：{self.plos_count},重传计数值：{self.arc_count}')
                #清除中断
                self.spi0.TRANS_RESAULT(self.spi0.RF_STATUS_Read())
                # fifo=spi0.RF_Read(spi0.R_REGISTER+spi0.FIFO_STATUS)
                # print('TX_fifo=',bin(fifo))
                print('TX ok')
                #time.sleep(2)
    def rx_test(self):
        while(True):
            for i in range(6):
                self.uc_rx = []
                #fifo=spi1.RF_Read(spi1.R_REGISTER+spi1.FIFO_STATUS)
                #print('RX_fifo=',bin(fifo))
                self.rx_flag = self.spi1.RF_Read(
                    self.spi1.R_REGISTER +
                    self.spi1.STATUS)  #self.spi1.RF_STATUS_Read()
                print('Rx_flag=', hex(self.rx_flag))
                if ((self.rx_flag & 0x0e) >> 1) == 7:
                    print('FIFO无数据')
                else:
                    print('pipe 通道=', (self.rx_flag & 0x0e) >> 1)
                if ((self.rx_flag & 0x70) == self.spi1.RX_DR_FLAG):
                    # if rx_flag==0:
                    print('Rx start')
                    self.rssi = self.spi1.RF_Read(self.spi1.R_REGISTER +
                                                self.spi1.DATAOUT)
                    self.back_rssi = self.rssi >> 8
                    self.data_rssi = self.rssi & 0xf
                    print(
                        f'背景信号={self.back_rssi},数据信号={self.data_rssi}'
                    )
                    #print('RX_PW_P0=',spi1.RF_Read(spi1.RX_PW_P0))
                    self.len_rx = self.spi1.RF_Read(self.spi1.R_RX_PL_WID)
                    #print('len_rx=', self.len_rx)
                    self.uc_rx = self.spi1.uc_RX(self.spi1.R_RX_PAYLOAD,
                                                self.len_rx)
                    print(f'地址{i}接收到{self.len_rx}个数据=', self.uc_rx)
                    self.spi1.RF_FIFO_Flush()
                    self.spi1.RF_STATUS_Clr()
                    time.sleep(1)
                    print('RX OK')
                else:
                    print('没有收到数据！')
                    self.spi1.RF_FIFO_Flush()
                    self.spi1.RF_STATUS_Clr()

    def tx_rx_test(self):
        # TX_addr_read=spi0.uc_RX(spi0.R_REGISTER+spi0.TX_ADDR1,5)
        # print('TX_ADDR=',TX_addr_read)
        # RX_addr_read=spi1.uc_RX(spi1.R_REGISTER+spi1.RX_ADDR_P0,5)
        # print('RX_DDR=',RX_addr_read)
        for i in range(6):
            ##设置TX芯片与RX芯片的发送及接收地址。
            self.TX_ADDR = self.RX_ADDRESS_DEF[i]
            print(self.TX_ADDR)
            self.spi0.RF_WRite_BUF(self.spi0.W_REGISTER + self.spi0.TX_ADDR,
                                   self.TX_ADDR, len(self.TX_ADDR))
            self.spi0.RF_WRite_BUF(
                self.spi0.W_REGISTER + self.spi0.RX_ADDR_P[0], self.TX_ADDR,
                len(self.TX_ADDR))
            #检测接收到的ACK
            # self.spi0.RF_Tx_CheckResult()  #发送端收到ACK的数量
            self.mode = self.spi0.RF_STATUS_Read()
            print('TX_mode=', hex(self.mode))
            if self.mode == 0:
                print('发送数据')
                self.tx_data1 = self.tx_data + [i]
                self.spi0.uc_TX(self.tx_data1, len(self.tx_data1))
                time.sleep(1)
            self.spi0.RF_Tx_CheckResult()  #发送端收到ACK的数量
            #显示丢失数据包及重传计数次数
            self.plos_arc_count = self.spi0.RF_Read(self.spi0.R_REGISTER +
                                                    self.spi0.OBSERVE_TX)
            self.plos_count = self.plos_arc_count >> 8
            self.arc_count = self.plos_arc_count & 0xf
            print(f'丢失数据包数量：{self.plos_count},重传计数值：{self.arc_count}')
            #清除中断
            self.spi0.TRANS_RESAULT(self.spi0.RF_STATUS_Read())
            # fifo=spi0.RF_Read(spi0.R_REGISTER+spi0.FIFO_STATUS)
            # print('TX_fifo=',bin(fifo))
            print('TX ok')
            #time.sleep(2)
            self.uc_rx = []
            #fifo=spi1.RF_Read(spi1.R_REGISTER+spi1.FIFO_STATUS)
            #print('RX_fifo=',bin(fifo))
            self.rx_flag = self.spi1.RF_Read(
                self.spi1.R_REGISTER +
                self.spi1.STATUS)  #self.spi1.RF_STATUS_Read()
            print('Rx_flag=', hex(self.rx_flag))
            if ((self.rx_flag & 0x0e) >> 1) == 7:
                print('FIFO无数据')
            else:
                print('pipe 通道=', (self.rx_flag & 0x0e) >> 1)
            if ((self.rx_flag & 0x70) == self.spi1.RX_DR_FLAG):
                # if rx_flag==0:
                print('Rx start')
                self.rssi = self.spi1.RF_Read(self.spi1.R_REGISTER +
                                              self.spi1.DATAOUT)
                self.back_rssi = self.rssi >> 8
                self.data_rssi = self.rssi & 0xf
                print(
                    f'背景信号={self.back_rssi},数据信号={self.data_rssi}'
                )
                #print('RX_PW_P0=',spi1.RF_Read(spi1.RX_PW_P0))
                self.len_rx = self.spi1.RF_Read(self.spi1.R_RX_PL_WID)
                #print('len_rx=', self.len_rx)
                self.uc_rx = self.spi1.uc_RX(self.spi1.R_RX_PAYLOAD,
                                             self.len_rx)
                print(f'地址{i}接收到{self.len_rx}个数据=', self.uc_rx)
                self.spi1.RF_FIFO_Flush()
                self.spi1.RF_STATUS_Clr()
                time.sleep(1)
                print('RX OK')
            else:
                print('没有收到数据！')
                self.spi1.RF_FIFO_Flush()
                self.spi1.RF_STATUS_Clr()
            ##设置TX芯片与RX芯片的发送及接收地址。
            self.TX_ADDR = self.RX_ADDRESS_DEF[i]
            print(self.TX_ADDR)
            self.spi0.RF_WRite_BUF(self.spi0.W_REGISTER + self.spi0.TX_ADDR,
                                   self.TX_ADDR, len(self.TX_ADDR))
            self.spi0.RF_WRite_BUF(
                self.spi0.W_REGISTER + self.spi0.RX_ADDR_P[0], self.TX_ADDR,
                len(self.TX_ADDR))
            #检测接收到的ACK
            # self.spi0.RF_Tx_CheckResult()  #发送端收到ACK的数量
            self.mode = self.spi0.RF_STATUS_Read()
            print('TX_mode=', hex(self.mode))
            if self.mode == 0:
                print('发送数据')
                self.tx_data1 = self.tx_data + [i]
                self.spi0.uc_TX(self.tx_data1, len(self.tx_data1))
                time.sleep(1)
            self.spi0.RF_Tx_CheckResult()  #发送端收到ACK的数量
            #显示丢失数据包及重传计数次数
            self.plos_arc_count = self.spi0.RF_Read(self.spi0.R_REGISTER +
                                                    self.spi0.OBSERVE_TX)
            self.plos_count = self.plos_arc_count >> 8
            self.arc_count = self.plos_arc_count & 0xf
            print(f'丢失数据包数量：{self.plos_count},重传计数值：{self.arc_count}')
            #清除中断
            self.spi0.TRANS_RESAULT(self.spi0.RF_STATUS_Read())
            # fifo=spi0.RF_Read(spi0.R_REGISTER+spi0.FIFO_STATUS)
            # print('TX_fifo=',bin(fifo))
            print('TX ok')
            #time.sleep(2)
            self.uc_rx = []
            #fifo=spi1.RF_Read(spi1.R_REGISTER+spi1.FIFO_STATUS)
            #print('RX_fifo=',bin(fifo))
            self.rx_flag = self.spi1.RF_Read(
                self.spi1.R_REGISTER +
                self.spi1.STATUS)  #self.spi1.RF_STATUS_Read()
            print('Rx_flag=', hex(self.rx_flag))
            if ((self.rx_flag & 0x0e) >> 1) == 7:
                print('FIFO无数据')
            else:
                print('pipe 通道=', (self.rx_flag & 0x0e) >> 1)
            if ((self.rx_flag & 0x70) == self.spi1.RX_DR_FLAG):
                # if rx_flag==0:
                print('Rx start')
                self.rssi = self.spi1.RF_Read(self.spi1.R_REGISTER +
                                              self.spi1.DATAOUT)
                self.back_rssi = self.rssi >> 8
                self.data_rssi = self.rssi & 0xf
                print(
                    f'背景信号={self.back_rssi},数据信号={self.data_rssi}'
                )
                #print('RX_PW_P0=',spi1.RF_Read(spi1.RX_PW_P0))
                self.len_rx = self.spi1.RF_Read(self.spi1.R_RX_PL_WID)
                #print('len_rx=', self.len_rx)
                self.uc_rx = self.spi1.uc_RX(self.spi1.R_RX_PAYLOAD,
                                             self.len_rx)
                print(f'地址{i}接收到{self.len_rx}个数据=', self.uc_rx)
                self.spi1.RF_FIFO_Flush()
                self.spi1.RF_STATUS_Clr()
                time.sleep(1)
                print('RX OK')
            else:
                print('没有收到数据！')
                self.spi1.RF_FIFO_Flush()
                self.spi1.RF_STATUS_Clr()

    def tx_run(self):
        self.tx_init()
        self.tx_test()
        
    def rx_run(self):
        self.rx_init()
        self.rx_test()
