@echo off
echo ========================================
echo TEST KONEKSI LARAVEL API
echo ========================================
echo.

echo 1. Cek apakah Laravel server running di http://127.0.0.1:8000
echo.
curl -s http://127.0.0.1:8000 >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Laravel server RUNNING
) else (
    echo [ERROR] Laravel server TIDAK RUNNING!
    echo.
    echo Cara menjalankan Laravel:
    echo   1. Buka CMD/PowerShell
    echo   2. cd ke folder Laravel project
    echo   3. Ketik: php artisan serve
    echo.
    goto :end
)

echo.
echo 2. Test endpoint /api/login
echo.
curl -X POST http://127.0.0.1:8000/api/login ^
  -H "Content-Type: application/json" ^
  -H "Accept: application/json" ^
  -d "{\"email\":\"test@example.com\",\"password\":\"password123\"}"

echo.
echo.
echo 3. Test endpoint /api/register
echo.
curl -X POST http://127.0.0.1:8000/api/register ^
  -H "Content-Type: application/json" ^
  -H "Accept: application/json" ^
  -d "{\"name\":\"Test User\",\"email\":\"test2@example.com\",\"password\":\"password123\",\"password_confirmation\":\"password123\"}"

echo.
echo.
echo ========================================
echo SELESAI
echo ========================================
echo.
echo Jika muncul "Connection refused" atau error:
echo   - Pastikan Laravel server running: php artisan serve
echo   - Cek apakah port 8000 sudah terpakai
echo   - Coba jalankan: php artisan serve --port=8001
echo.

:end
pause
