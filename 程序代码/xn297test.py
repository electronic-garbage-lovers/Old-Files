import PN297_LBW as xn
xn1=xn.xn297(0,0)
xn1.XN297_Initial()
xn1.RX_Mode()
xn2=xn.xn297(0,1)
xn2.XN297_Initial()
xn2.TX_Mode()
txdata=[0x01,0x02,0x03,0x04,0x05,0x06]
xn2.ucXN297_TX(txdata,len(txdata))
xn1.SPI_Read_Buf(5)
xn1.RF_SPIRead(xn1.R_RX_PL_WID)
xn1.RF_SPIRead(xn1.STATUS)
xn2.RF_SPIRead(xn2.STATUS)
xn1.RF_SPIRead(xn1.FIFO_STATUS)
xn2.RF_SPIRead(xn2.FIFO_STATUS)
print(txdata)
print(xn1.rxdata1)

