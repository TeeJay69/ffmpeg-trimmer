@echo off
setlocal enabledelayedexpansion

REM Prompt for the input file path
set /p "filepath=Enter the full path to the file: "

REM Prompt for the cut time (format: HH:MM:SS)
set /p "cutTime=Enter the time to cut the file (HH:MM:SS): "

REM Extract directory, filename, and extension from the input file path
for %%a in ("%filepath%") do (
    set "dir=%%~dpa"
    set "name=%%~na"
    set "ext=%%~xa"
)

REM Build the output file name (appending _trimmed to the original file name)
set "output=%dir%%name%_trimmed%ext%"

REM Run ffmpeg to trim the file starting at the specified time
ffmpeg -i "%filepath%" -ss %cutTime% -c copy "%output%"

REM Check if ffmpeg succeeded by verifying ERRORLEVEL (0 means success)
if errorlevel 1 (
    echo ffmpeg encountered an error. The file was not trimmed.
    pause
    exit /b 1
) else (
    echo ffmpeg succeeded.
)

REM Delete the original file and replace it with the trimmed file
del "%filepath%"
move /Y "%output%" "%filepath%"

echo.
echo Original file has been replaced with the trimmed version.
pause
