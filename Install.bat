chcp 65001
@echo off
setlocal enableDelayedExpansion
color 2F
TITLE Amedtec ECGPro Settings Adjuster Tool
cls
echo.
if exist "C:\Program Files (x86)\AMEDTEC ECGpro\s05Main.exe" goto startscript
if exist "C:\Program Files\AMEDTEC ECGpro\s05Main.exe" goto startscript
echo.
echo Error: Amedtec ECGPro not installed in the default path. Please contact local support!
echo.
pause
exit

:startscript
SET MyProcess=s05Main.exe
:B
TASKLIST | FINDSTR /I "%MyProcess%"
cls
IF ERRORLEVEL 1 (GOTO continue) ELSE (ECHO Waiting until ECGPro is closed... Please close this manually...)
ping 127.0.0.1 -n 3 >NUL
GOTO :B

:continue
echo.
echo.
echo Amedtec ECGPro Settings Adjuster
echo.
echo Please follow the prompts or close the window to abort
echo.
set UpdateClinicDetails=0
Choice /C YN /M "Would you like to set the clinic details now?"
IF %ERRORLEVEL% EQU 1 GOTO SetClinicDetails
IF %ERRORLEVEL% EQU 2 GOTO SetAllOptions




:SetClinicDetails
rem ########################################
rem ########################################
set UpdateClinicDetails=1

cls
echo.
echo.

set /p Clinic_Name="Enter Clinic Name: "
IF "%Clinic_Name%" == "" (
  Choice /C YN /M "Would you like to clear this field in ECGPro?"
  IF ERRORLEVEL 1 Set Clinic_Name=1Clear1
  IF ERRORLEVEL 2 Set Clinic_Name=1DoNotTouch1
)
cls
echo.
echo.

set /p Clinic_Address1="Enter Clinic Address (in one line): "
IF "%Clinic_Address1%" == "" (
  Choice /C YN /M "Would you like to clear this field in ECGPro?"
  IF ERRORLEVEL 1 Set Clinic_Address1=1Clear1
  IF ERRORLEVEL 2 Set Clinic_Address1=1DoNotTouch1
)
cls
echo.
echo.

set /p Clinic_Phone="Enter Clinic Phone Number: "
IF "%Clinic_Phone%" == "" (
  Choice /C YN /M "Would you like to clear this field in ECGPro?"
  IF ERRORLEVEL 1 Set Clinic_Phone=1Clear1
  IF ERRORLEVEL 2 Set Clinic_Phone=1DoNotTouch1
)
cls
echo.
echo.

set /p Clinic_Fax="Enter Clinic Fax Number: "
IF "%Clinic_Fax%" == "" (
  Choice /C YN /M "Would you like to clear this field in ECGPro?"
  IF ERRORLEVEL 1 Set Clinic_Fax=1Clear1
  IF ERRORLEVEL 2 Set Clinic_Fax=1DoNotTouch1
)
cls
echo.
echo.

rem ########################################

echo Here are the values you had provided:
IF "%Clinic_Name%"=="1Clear1" (
  @echo    Clinic Name: -Clear this setting-
) ELSE IF "%Clinic_Name%"=="1DoNotTouch1" (
  @echo    Clinic Name: -Keep current settings-
) ELSE (
  @echo    Clinic Name: %Clinic_Name%
)
IF "%Clinic_Address1%"=="1Clear1" (
  @echo Clinic Address: -Clear this setting-
) ELSE IF "%Clinic_Address1%"=="1DoNotTouch1" (
  @echo Clinic Address: -Keep current settings-
) ELSE (
  @echo Clinic Address: %Clinic_Address1%
)
IF "%Clinic_Phone%"=="1Clear1" (
  @echo   Clinic Phone: -Clear this setting-
) ELSE IF "%Clinic_Phone%"=="1DoNotTouch1" (
  @echo   Clinic Phone: -Keep current settings-
) ELSE (
  @echo   Clinic Phone: %Clinic_Phone%
)
IF "%Clinic_Fax%"=="1Clear1" (
  @echo     Clinic Fax: -Clear this setting-
) ELSE IF "%Clinic_Fax%"=="1DoNotTouch1" (
  @echo     Clinic Fax: -Keep current settings-
) ELSE (
  @echo     Clinic Fax: %Clinic_Fax%
)
echo.
echo.
echo Close the window to abort or
pause
GOTO SetAllOptions

rem ########################################
rem ########################################




:SetAllOptions

del PCSettingsCustom.cnf /f /q
del PCSettingsCustom-Done.cnf /f /q
del 2ndSegment.txt /f /q
del 4thSegment.txt /f /q
cls
echo.
echo.
echo Please select filter options:
echo.
echo 1 - Power filter  ON  and EMG muscle filter  ON  (EMG @ 40Hz)
echo 2 - Power filter  OFF and EMG muscle filter  ON
echo 3 - Power filter  ON  and EMG muscle filter  OFF
echo 4 - All filters   OFF
echo.
echo ECGPro default option is 3 though option 1 is recommended.
echo "Please note that turning on the muscle filter can change the ECG trace"
Choice /C 1234 /M "Please choose option from the list above:"
IF %ERRORLEVEL% EQU 1 SET filteroption=1
IF %ERRORLEVEL% EQU 2 SET filteroption=2
IF %ERRORLEVEL% EQU 3 SET filteroption=3
IF %ERRORLEVEL% EQU 4 SET filteroption=4


IF %filteroption%==1 (
echo Choice 1 selected - Power filter ON and EMG muscle filter ON (EMG @ 40Hz)
echo F|xcopy "%~dp0mainstrue_muscletrue.txt" "%~dp04thSegment.txt" /r /c /k /y /h
)


IF %filteroption%==2 (
echo Choice 2 selected - Power filter OFF and EMG muscle filter ON
echo F|xcopy "%~dp0mainsfalse_muscletrue.txt" "%~dp04thSegment.txt" /r /c /k /y /h
)


IF %filteroption%==3 (
echo Choice 3 selected - Power filter ON and EMG muscle filter OFF
echo F|xcopy "%~dp0mainstrue_musclefalse.txt" "%~dp04thSegment.txt" /r /c /k /y /h
)


IF %filteroption%==4 (
echo Choice 4 selected - All filters OFF
echo F|xcopy "%~dp0mainsfalse_musclefalse.txt" "%~dp04thSegment.txt" /r /c /k /y /h
)



IF %UpdateClinicDetails%==1 (
  IF "%Clinic_Name%"=="1Clear1" (
    @echo   ^<setting id="S05_Clinic_Name" type="5"^>^</setting^>>> 2ndSegment.txt
  ) ELSE IF "%Clinic_Name%"=="1DoNotTouch1" (
    @echo Nothing to do
  ) ELSE (
    @echo   ^<setting id="S05_Clinic_Name" type="5"^>%Clinic_Name%^</setting^>>> 2ndSegment.txt
  )
)


IF %UpdateClinicDetails%==1 (
  IF "%Clinic_Address1%"=="1Clear1" (
    @echo   ^<setting id="S05_Clinic_Address1" type="5"^>^</setting^>>> 2ndSegment.txt
  ) ELSE IF "%Clinic_Address1%"=="1DoNotTouch1" (
    @echo Nothing to do
  ) ELSE (
    @echo   ^<setting id="S05_Clinic_Address1" type="5"^>%Clinic_Address1%^</setting^>>> 2ndSegment.txt
  )
)


IF %UpdateClinicDetails%==1 (
  IF "%Clinic_Phone%"=="1Clear1" (
    @echo   ^<setting id="S05_Clinic_Phone" type="5"^>^</setting^>>> 2ndSegment.txt
  ) ELSE IF "%Clinic_Phone%"=="1DoNotTouch1" (
    @echo Nothing to do
  ) ELSE (
    @echo   ^<setting id="S05_Clinic_Phone" type="5"^>%Clinic_Phone%^</setting^>>> 2ndSegment.txt
  )
)


IF %UpdateClinicDetails%==1 (
  IF "%Clinic_Fax%"=="1Clear1" (
    @echo   ^<setting id="S05_Clinic_Fax" type="5"^>^</setting^>>> 2ndSegment.txt
  ) ELSE IF "%Clinic_Fax%"=="1DoNotTouch1" (
    @echo Nothing to do
  ) ELSE (
    @echo   ^<setting id="S05_Clinic_Fax" type="5"^>%Clinic_Fax%^</setting^>>> 2ndSegment.txt
  )
)

:combinefilesnow
del PCSettingsCustom.cnf /f /q
echo Now to concatenate the files...
copy /B 1stSegment.txt + 2ndSegment.txt + 3rdSegment.txt + 4thSegment.txt + 5thSegment.txt PCSettingsCustom.cnf
cls
echo.
echo.
if exist "C:\Program Files (x86)\AMEDTEC ECGpro\s05Main.exe" (
    "C:\Program Files (x86)\AMEDTEC ECGpro\s05Main.exe" -importsettings PCSettingsCustom.cnf
) else (
    "C:\Program Files\AMEDTEC ECGpro\s05Main.exe" -importsettings PCSettingsCustom.cnf
)
echo.
echo.
pause
exit