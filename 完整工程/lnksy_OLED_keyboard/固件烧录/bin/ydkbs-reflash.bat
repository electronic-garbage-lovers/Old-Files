@echo off
setlocal enabledelayedexpansion
chcp 936
rem �������������һ�˵ĵ����������⡣ִ��ʱֱ��������
ver|find "�汾" >nul&& set IS_CHN=1 || set IS_CHN=0
SET APP_VER=v3.5
if %IS_CHN%==1 (title YDKBsˢ�̼����� %APP_VER%) else title YDKBs Reflash Tool %APP_VER%
cd %~dp0
rem �ж�DEVCON��32λ����64λ�����Ҵ����·���Ŀո�
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
echo ----�뽫eep��hex�Ϸŵ���exe��ͼ�������С�
echo ----��Ҫ��˫����exe�����ļ���
echo ----��Ҫ��˫����exe�����ļ���
echo ----��Ҫ��˫����exe�����ļ���
echo ----������Ŀǰ�����ڻ���Ateml 32u4��32u2��328p��at90usb1286�Ͳ���stm32���豸���Լ�V-USB��
echo ----֧�ֵ�bootloaderΪDFU��Arduino��HID(K.T.E.C��^)��HID^(BootHID^)��stm32duino bootloader
) else (
echo ----Please drag eep or hex file onto this exe.
echo ----Don't double click this exe to open a window then drag eep or hex file��
echo ----Don't double click this exe to open a window then drag eep or hex file��
echo ----Don't double click this exe to open a window then drag eep or hex file��
echo ----This tool is for some devices that use Atmel 32u4, 32u2, 328p, at90usb1286 and some stm32 microcontroller��
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
echo ---YDKBsˢ�̼����� %APP_VER%---
echo ---֧��32u4оƬ��DFU Bootloader��Arduino��HID Bootloader---
echo ---֧��32u2оƬ��DFU Bootloader�������㣩---
echo ---֧��AVRоƬ��ʹ��V-USB HID Bootloader�Ĳ����豸---
echo ---֧��stm32оƬʹ��stm32duino bootloader�����豸---
echo\
echo ----�豸����ˢ��ģʽ���Զ�ʶ��ִ�и���...
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

rem Arduino����COM��
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

rem HID����cw40
"%DEVCON%" find @hid\vid_1209^&pid_2327* > temp.txt
For /f "usebackq tokens=1 delims= " %%H in ( "temp.txt" ) do (
    if not "%%H" == "No"   (
	goto :FOUND_DEVICE_HID
	)
)

rem DFU����32U4
"%DEVCON%" find @usb\vid_03eb^&pid_2ff4* > temp.txt
For /f "usebackq tokens=1 delims= " %%H in ( "temp.txt" ) do (
    if not "%%H" == "No"   (
    set TARGET=atmega32u4
    goto FOUND_DEVICE_DFU
	)
)

rem DFU����32U2
"%DEVCON%" find @usb\vid_03eb^&pid_2ff0* > temp.txt
For /f "usebackq tokens=1 delims= " %%H in ( "temp.txt" ) do (
    if not "%%H" == "No"   (
    echo --------------------
    set TARGET=atmega32u2
    goto FOUND_DEVICE_DFU
    )
	)
)

rem DFU����AT90USB1286
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
    if %IS_CHN%==1 (echo ----�ҵ��豸BootHID������������----) else echo -----Found device with BootHID Bootloader but with wrong driver.----
    goto end
  )
)
:FOUND_DEVICE_DFU
rem ȷ����������
"%~dp0dfu-programmer" %TARGET% get
    IF ERRORLEVEL 0 (
      if %IS_CHN%==1 (echo ----ʹ�õ���winusb����----) else echo ----The driver is winusb.---- 
    )
    IF ERRORLEVEL 1 (
      "%~dp0dfu-programmer-libusb" %TARGET% get
      IF ERRORLEVEL 1 goto FIND_DEVICE_LOOP
      IF ERRORLEVEL 0 (
      if %IS_CHN%==1 (echo ----ʹ�õ���libusb����----) else echo ----The driver is libuse.----
      SET DFUP="%~dp0dfu-programmer-libusb"
      )
    )
if %IS_CHN%==1 (echo ----�ҵ��豸ΪDFU Bootloader��%TARGET%) else echo ----Found device with DFU Bootloader��%TARGET%
rem get bootloader version
for /f "tokens=3 delims= " %%t in ('%DFUP% %TARGET% get') do (
   set str=%%t
  )
if "%FileExt%" == ".hex" (
	echo\
	if %IS_CHN%==1 (echo ----����оƬ) else	echo ----Erase flash
	%DFUP% %TARGET% erase --force
	echo\
	if %IS_CHN%==1 (echo ----��ʼˢ��"%FilePath%") else echo ---Start to reflash "%FilePath%"
		%DFUP% %TARGET% flash "%FilePath%"
		%DFUP% %TARGET% launch --no-reset
	echo\
	if %IS_CHN%==1 (echo ----����HEX�ɹ�) else echo ---HEX reflash complete.
	goto end
)
if "%FileExt%" == ".eep" (
  rem lufa dfu is 0x20
  if "%str%" == "0x20" (
    echo ----Lufa Dfu bootloader
  	if %IS_CHN%==1 (echo ----��ʼˢ��"%FilePath%") else echo ----Start to reflash "%FilePath%"
    %DFUP% %TARGET% flash --force --eeprom "%FilePath%"
    %DFUP% %TARGET% launch --no-reset
    echo\
    if %IS_CHN%==1 (echo ----����EEP�ɹ�) else echo ----EEP reflash complete.
    goto end
  )
  rem Atmel dfu need hex file
	if not exist "%~dp0dfu.hex"  goto NO_DFU_HEX
	echo\
	if %IS_CHN%==1 (echo ----����оƬ) else echo ---Erase flash
	%DFUP% %TARGET% erase --force
	echo\
	if %IS_CHN%==1 (echo ----��ʼˢ�¶�Ӧ�̼�dfu.hex) else echo ----Start to reflash dfu.hex for this eep file.
	%DFUP% %TARGET% flash "%~dp0dfu.hex"
	echo\
	if %IS_CHN%==1 (echo ----��ʼˢ��"%FilePath%") else echo ----Start to reflash "%FilePath%"
	%DFUP% %TARGET% flash --force --eeprom "%FilePath%"
	%DFUP% %TARGET% launch --no-reset
	echo\
	if %IS_CHN%==1 (echo ----����dfu.hex��EEP�ɹ�) else echo ----dfu.hex and EEP reflash complete.
	goto end
)

:NO_DFU_HEX
if %IS_CHN%==1 (
echo ----DFUˢeep����Ҫ�Ƚ���Ӧ�Ĺ̼�����Ϊdfu.hex���ٷ��ڱ�����ͬĿ¼�¡�
echo ----����ִ�д˲�����������ˢeep��
) else (
echo ----To reflash eep file with DFU bootloader, dfu.hex for thie eep file is required to put in the folder with this tool.
echo ----Put in dfu.hex first then try to drag this eep file again to reflash it.
)
goto end

:FOUND_DEVICE_ADR
if %IS_CHN%==1 (echo ----�ҵ��豸ΪArduino��ʹ�ýӿ���COM%COM%) else echo ----Found device with Arduino bootloader. It is using COM%COM%
echo\
if %IS_CHN%==1 (echo ----��ʼˢ��"%FilePath%") else echo ----Start to reflash "%FilePath%"
if "%FileExt%" == ".hex" (
    "%~dp0avrdude" -patmega32u4 -PCOM%COM% -cavr109 -Uflash:w:"%FilePath%":i
    )
if "%FileExt%" == ".eep" (
    "%~dp0avrdude" -patmega32u4 -PCOM%COM% -cavr109 -Ueeprom:w:"%FilePath%":i
    )
echo\
if %IS_CHN%==1 (echo ----ˢ�����) else echo ----Reflash complete.
echo\ 
goto end

:FOUND_DEVICE_HID
if %IS_CHN%==1 (echo ----�ҵ��豸ΪHID Bootloader) else echo ----Found device with HID Bootloader.
echo\
if %IS_CHN%==1 (echo ----��ʼˢ��"%FilePath%") else echo ----Start to reflash "%FilePath%"
if "%FileExt%" == ".hex" (
  "%~dp0hid_bootloader_cli" -mmcu=atmega32u4 "%FilePath%"
  "%~dp0hid_bootloader_cli" -mmcu=atmega32u4 -f "%FilePath%"
  )
if "%FileExt%" == ".eep" (
  "%~dp0hid_bootloader_cli" -mmcu=atmega32u4 "%FilePath%"
  "%~dp0hid_bootloader_cli" -mmcu=atmega32u4 -e "%FilePath%"
  )
echo\
if %IS_CHN%==1 (echo ----ˢ�����) else echo ----Reflash complete.
echo\ 
goto end

:FOUND_DEVICE_BOOTHID
if %IS_CHN%==1 (echo ----�ҵ��豸ΪBootHID Bootloader) else echo ----Found device with BootHID Bootloader.
echo\
if %IS_CHN%==1 (echo ----��ʼˢ��"%FilePath%") else echo ----Start to reflash "%FilePath%"
"%~dp0bootloadHID" -r "%FilePath%"
echo\
if %IS_CHN%==1 (echo ----ˢ�����) else echo ----Reflash complete.
echo\ 
goto end

:FOUND_DEVICE_STM32_DFU
if %IS_CHN%==1 (echo ----�ҵ��豸Ϊstm32duino bootloader) else echo ----Found device with stm32duino bootloader.
SET "BIN_Path=%FilePath:.hex=.bin%
echo %BIN_Path%
"%~dp0hex2bin"  %FilePath%
"%~dp0dfu-util" -a 2 -D "%BIN_Path%" -R
del/f/q %BIN_Path%
goto end

:FOUND_DEVICE_STM32_HID
if %IS_CHN%==1 (echo ----�ҵ��豸Ϊstm32 hid_bootloader) else echo ----Found device with stm32 hid_bootloader.
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
