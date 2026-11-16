@echo off
chcp 65001 > nul
echo ========================================================
echo   DEMO CHU DE 12: PROVIDER & CHANGENOTIFIER (FLUTTER)
echo ========================================================
echo.
echo 1. Chay tren Windows Desktop
echo 2. Chay tren trinh duyet Chrome (nhanh gon)
echo.
set /p choice="Nhap lua chon (1 hoac 2): "

if "%choice%"=="1" (
    echo Dang khoi chay tren Windows Desktop...
    flutter run -d windows
) else (
    echo Dang khoi chay tren Chrome Web...
    flutter run -d chrome
)
pause
