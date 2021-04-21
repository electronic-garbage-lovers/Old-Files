import spi_test
import pn297_gpio

c=spi_test.pn()
c.tx_run()


import spi_test
import pn297_gpio

mk=spi_test.pn()
mk.rx_run()

import RPi.GPIO as GPIO
GPIO.cleanup()
quit()
