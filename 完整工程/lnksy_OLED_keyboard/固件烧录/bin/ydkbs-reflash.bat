@echo off
setlocal enabledelayedexpansion
chcp 936
rem 下面这句在其中一人的电脑上有问题。执行时直接闪退了
ver|find "版本" >nul&& set IS_CHN=1 || set IS_CHN=0
SET APP_VER=v3.5
if %IS_CHN%==1 (title YDKBs刷固件工具 %APP_VER%) else title YDKBs Reflash Tool %APP_VER%
cd %~dp0
rem 判断DEVCON是32位还是64位，并且处理好路径的空格
if "%PROCESSOR_ARCHITECTURE%"=="x86" set DEVCON=%~dp0devcon32.exe 
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" set DEVCON=%~dp0devcon64.exe 
for %%x in ("%DEVCON%") do set DEVCON=%%~sx
SET DFUP="%~dp0dfu-programmer.exe"
:FILE
echo\
if exist "%~1" (goto HASFILE) else (goto NOFILE)
:HASFILE
goto START
:NOFILE
echo\
if %IS_CHN%==1 (
echo ----请将eep或hex拖放到此exe的图标上运行。
echo ----不要先双击打开exe再拖文件，
echo ----不要先双击打开exe再拖文件，
echo ----不要先双击打开exe再拖文件。
echo ----本工具目前仅用于基于Ateml 32u4、32u2、328p、at90usb1286和部分stm32的设备，以及V-USB。
echo ----支持的bootloader为DFU、Arduino、HID(K.T.E.C版^)、HID^(BootHID^)、stm32duino bootloader
) else (
echo ----Please drag eep or hex file onto this exe.
echo ----Don't double click this exe to open a window then drag eep or hex file，
echo ----Don't double click this exe to open a window then drag eep or hex file，
echo ----Don't double click this exe to open a window then drag eep or hex file，
echo ----This tool is for some devices that use Atmel 32u4, 32u2, 328p, at90usb1286 and some stm32 microcontroller。
echo ----It supports bootloader like DFU,Arduino,HID(K.T.E.C version^), HID(BootHID^), stm32duino bootloader, stm32 hidbootloader
)
echo\
goto end
:START 
set "FilePath=%~1"
for %%a in ("%FilePath%") do set FileExt=%%~xa
if "%FileExt%" == ".hex" (goto TO_FIND_DEVICE)
if "%FileExt%" == ".eep" (goto TO_FIND_DEVICE)
goto b
:TO_FIND_DEVICE
setlocal enabledelayedexpansion
set FIRST=1
set "COM="
set "PREVLIST="

:FIND_DEVICE_LOOP
cls
echo\
if %IS_CHN%==1 (
echo ---YDKBs刷固件工具 %APP_VER%---
echo ---支持32u4芯片的DFU Bootloader、Arduino、HID Bootloader---
echo ---支持32u2芯片的DFU Bootloader（死大鱼）---
echo ---支持AVR芯片，使用V-USB HID Bootloader的部分设备---
echo ---支持stm32芯片使用stm32duino bootloader部分设备---
echo\
echo ----设备进入刷机模式后自动识别并执行更新...
) else (
echo ---YDKBs Reflash Tool %APP_VER%---
echo ---Support DFU Bootloader, Arduino, HID Bootloader for atmega32u4---
echo ---Support DFU Bootloader for atmega32u2 as Staryu---
echo ---Support V-USB HID Bootloader for some devices that use AVR---
echo ---Support some stm32duino bootloader for stm32---
echo\
echo ----Please get your device into bootloader. The bat will recognize your bootloader then reflash the firmware...
)
"%~dp0sleep"  100

rem Arduino查找COM口
set "PORTLIST="
for /f "DELIMS=" %%a in ('mode') do (
	set OUTPUT=%%a
	set "TEST=!OUTPUT:COM=!"
	if not "!TEST!"=="!OUTPUT!" (
		set PORT=!OUTPUT:*COM=!
		set PORT=!PORT::=!
		set "PORTLIST=!PORTLIST! !PORT!"
	)
)
if not "%FIRST%" == "1" (
	for %%a in (!PORTLIST!) do (
		if not "%%a" == "" (
			set FOUND=0
			for %%b in (!PREVLIST!) do (
				if "!FOUND!" == "0" if %%a == %%b set FOUND=1
			)
			if "!FOUND!" == "0" (
				set COM=%%a
				goto :FOUND_DEVICE_ADR
			)
		)
	)
)
set FIRST=0
set PREVLIST=%PORTLIST%

rem HID查找cw40
"%DEVCON%" find @hid\vid_1209^&pid_2327* > temp.txt
For /f "usebackq tokens=1 delims= " %%H in ( "temp.txt" ) do (
    if not "%%H" == "No"   (
	goto :FOUND_DEVICE_HID
	)
)

rem DFU查找32U4
"%DEVCON%" find @usb\vid_03eb^&pid_2ff4* > temp.txt
For /f "usebackq tokens=1 delims= " %%H in ( "temp.txt" ) do (
    if not "%%H" == "No"   (
    set TARGET=atmega32u4
    goto FOUND_DEVICE_DFU
	)
)

rem DFU查找32U2
"%DEVCON%" find @usb\vid_03eb^&pid_2ff0* > temp.txt
For /f "usebackq tokens=1 delims= " %%H in ( "temp.txt" ) do (
    if not "%%H" == "No"   (
    echo --------------------
    set TARGET=atmega32u2
    goto FOUND_DEVICE_DFU
    )
	)
)

rem DFU查找AT90USB1286
"%DEVCON%" find @usb\vid_03eb^&pid_2ffb* > temp.txt
For /f "usebackq tokens=1 delims= " %%H in ( "temp.txt" ) do (
    if not "%%H" == "No"   (
    echo --------------------
    set TARGET=at90usb1286
    goto FOUND_DEVICE_DFU
    )
	)
)

rem BOOTHID
"%DEVCON%" find @usb\vid_16c0^&pid_05df* > temp.txt
For /f "usebackq tokens=1 delims= " %%H in ( "temp.txt" ) do (
  if not "%%H" == "No"   (
	goto FOUND_DEVICE_BOOTHID_USB
	)
)

rem STM32_DFU
"%DEVCON%" find @usb\vid_1eaf^&pid_0003* > temp.txt
For /f "usebackq tokens=1 delims= " %%H in ( "temp.txt" ) do (
  if not "%%H" == "No"   (
	goto FOUND_DEVICE_STM32_DFU
	)
)

rem STM32_HID_Bootloader
"%DEVCON%" find @usb\vid_1209^&pid_babe* > temp.txt
For /f "usebackq tokens=1 delims= " %%H in ( "temp.txt" ) do (
  if not "%%H" == "No"   (
	goto FOUND_DEVICE_STM32_HID
	)
)

goto :FIND_DEVICE_LOOP

rem BOOTHID HID
:FOUND_DEVICE_BOOTHID_USB
"%DEVCON%" find @hid\vid_16c0^&pid_05df* > temp.txt
For /f "usebackq tokens=1 delims= " %%H in ( "temp.txt" ) do (
  if not "%%H" == "No"   (
	goto FOUND_DEVICE_BOOTHID
	) else (
    if %IS_CHN%==1 (echo ----找到设备BootHID但是驱动错误----) else echo -----Found device with BootHID Bootloader but with wrong driver.----
    goto end
  )
)
:FOUND_DEVICE_DFU
rem 确认驱动类型
"%~dp0dfu-programmer" %TARGET% get
    IF ERRORLEVEL 0 (
      if %IS_CHN%==1 (echo ----使用的是winusb驱动----) else echo ----The driver is winusb.---- 
    )
    IF ERRORLEVEL 1 (
      "%~dp0dfu-programmer-libusb" %TARGET% get
      IF ERRORLEVEL 1 goto FIND_DEVICE_LOOP
      IF ERRORLEVEL 0 (
      if %IS_CHN%==1 (echo ----使用的是libusb驱动----) else echo ----The driver is libuse.----
      SET DFUP="%~dp0dfu-programmer-libusb"
      )
    )
if %IS_CHN%==1 (echo ----找到设备为DFU Bootloader，%TARGET%) else echo ----Found device with DFU Bootloader，%TARGET%
rem get bootloader version
for /f "tokens=3 delims= " %%t in ('%DFUP% %TARGET% get') do (
   set str=%%t
  )
if "%FileExt%" == ".hex" (
	echo\
	if %IS_CHN%==1 (echo ----擦除芯片) else	echo ----Erase flash
	%DFUP% %TARGET% erase --force
	echo\
	if %IS_CHN%==1 (echo ----开始刷新"%FilePath%") else echo ---Start to reflash "%FilePath%"
		%DFUP% %TARGET% flash "%FilePath%"
		%DFUP% %TARGET% launch --no-reset
	echo\
	if %IS_CHN%==1 (echo ----更新HEX成功) else echo ---HEX reflash complete.
	goto end
)
if "%FileExt%" == ".eep" (
  rem lufa dfu is 0x20
  if "%str%" == "0x20" (
    echo ----Lufa Dfu bootloader
  	if %IS_CHN%==1 (echo ----开始刷新"%FilePath%") else echo ----Start to reflash "%FilePath%"
    %DFUP% %TARGET% flash --force --eeprom "%FilePath%"
    %DFUP% %TARGET% launch --no-reset
    echo\
    if %IS_CHN%==1 (echo ----更新EEP成功) else echo ----EEP reflash complete.
    goto end
  )
  rem Atmel dfu need hex file
	if not exist "%~dp0dfu.hex"  goto NO_DFU_HEX
	echo\
	if %IS_CHN%==1 (echo ----擦除芯片) else echo ---Erase flash
	%DFUP% %TARGET% erase --force
	echo\
	if %IS_CHN%==1 (echo ----开始刷新对应固件dfu.hex) else echo ----Start to reflash dfu.hex for this eep file.
	%DFUP% %TARGET% flash "%~dp0dfu.hex"
	echo\
	if %IS_CHN%==1 (echo ----开始刷新"%FilePath%") else echo ----Start to reflash "%FilePath%"
	%DFUP% %TARGET% flash --force --eeprom "%FilePath%"
	%DFUP% %TARGET% launch --no-reset
	echo\
	if %IS_CHN%==1 (echo ----更新dfu.hex和EEP成功) else echo ----dfu.hex and EEP reflash complete.
	goto end
)

:NO_DFU_HEX
if %IS_CHN%==1 (
echo ----DFU刷eep，需要先将对应的固件改名为dfu.hex，再放在本工具同目录下。
echo ----请先执行此操作后再重试刷eep。
) else (
echo ----To reflash eep file with DFU bootloader, dfu.hex for thie eep file is required to put in the folder with this tool.
echo ----Put in dfu.hex first then try to drag this eep file again to reflash it.
)
goto end

:FOUND_DEVICE_ADR
if %IS_CHN%==1 (echo ----找到设备为Arduino，使用接口是COM%COM%) else echo ----Found device with Arduino bootloader. It is using COM%COM%
echo\
if %IS_CHN%==1 (echo ----开始刷新"%FilePath%") else echo ----Start to reflash "%FilePath%"
if "%FileExt%" == ".hex" (
    "%~dp0avrdude" -patmega32u4 -PCOM%COM% -cavr109 -Uflash:w:"%FilePath%":i
    )
if "%FileExt%" == ".eep" (
    "%~dp0avrdude" -patmega32u4 -PCOM%COM% -cavr109 -Ueeprom:w:"%FilePath%":i
    )
echo\
if %IS_CHN%==1 (echo ----刷新完成) else echo ----Reflash complete.
echo\ 
goto end

:FOUND_DEVICE_HID
if %IS_CHN%==1 (echo ----找到设备为HID Bootloader) else echo ----Found device with HID Bootloader.
echo\
if %IS_CHN%==1 (echo ----开始刷新"%FilePath%") else echo ----Start to reflash "%FilePath%"
if "%FileExt%" == ".hex" (
  "%~dp0hid_bootloader_cli" -mmcu=atmega32u4 "%FilePath%"
  "%~dp0hid_bootloader_cli" -mmcu=atmega32u4 -f "%FilePath%"
  )
if "%FileExt%" == ".eep" (
  "%~dp0hid_bootloader_cli" -mmcu=atmega32u4 "%FilePath%"
  "%~dp0hid_bootloader_cli" -mmcu=atmega32u4 -e "%FilePath%"
  )
echo\
if %IS_CHN%==1 (echo ----刷新完成) else echo ----Reflash complete.
echo\ 
goto end

:FOUND_DEVICE_BOOTHID
if %IS_CHN%==1 (echo ----找到设备为BootHID Bootloader) else echo ----Found device with BootHID Bootloader.
echo\
if %IS_CHN%==1 (echo ----开始刷新"%FilePath%") else echo ----Start to reflash "%FilePath%"
"%~dp0bootloadHID" -r "%FilePath%"
echo\
if %IS_CHN%==1 (echo ----刷新完成) else echo ----Reflash complete.
echo\ 
goto end

:FOUND_DEVICE_STM32_DFU
if %IS_CHN%==1 (echo ----找到设备为stm32duino bootloader) else echo ----Found device with stm32duino bootloader.
SET "BIN_Path=%FilePath:.hex=.bin%
echo %BIN_Path%
"%~dp0hex2bin"  %FilePath%
"%~dp0dfu-util" -a 2 -D "%BIN_Path%" -R
del/f/q %BIN_Path%
goto end

:FOUND_DEVICE_STM32_HID
if %IS_CHN%==1 (echo ----找到设备为stm32 hid_bootloader) else echo ----Found device with stm32 hid_bootloader.
SET "BIN_Path=%FilePath:.hex=.bin%
echo %BIN_Path%
"%~dp0hex2bin"  %FilePath%
"%~dp0hid-flash" "%BIN_Path%"
del/f/q %BIN_Path%
goto end

:end
del temp.txt
rem if "%FilePath:factory=%"=="%FilePath%" goto FIND_DEVICE_LOOP
pause
