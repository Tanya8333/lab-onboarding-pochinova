@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

set "REPORT_FILE=%~dp0pc_report.txt"
set "TEMP_APPS=%TEMP%\apps_list.txt"
set "SORTED_APPS=%TEMP%\apps_list_sorted.txt"

if exist "%REPORT_FILE%" del /q "%REPORT_FILE%"
if exist "%TEMP_APPS%" del /q "%TEMP_APPS%"
if exist "%SORTED_APPS%" del /q "%SORTED_APPS%"

call :log "ДИАГНОСТИКА И АУДИТ КОМПЬЮКТЕРА"
call :log ""
call :log "Дата и времья проверки: %DATE% %TIME%"
call :log "Имя компуктера: %COMPUTERNAME%"
call :log "Имя пользывателя: %USERNAME%"
call :log ""

call :log "[Операцеоная система]"
set "os_name="
set "os_version="
for /f "tokens=2 delims==" %%i in ('wmic os get Caption /value 2^>nul') do if not "%%i"==" " set "os_name=%%i"
for /f "tokens=2 delims==" %%i in ('wmic os get Version /value 2^>nul') do if not "%%i"==" " set "os_version=%%i"

if not defined os_name (
    for /f "usebackq tokens=*" %%A in (`powershell -NoProfile -Command "(Get-CimInstance Win32_OperatingSystem).Caption" 2^>nul`) do set "os_name=%%A"
)
if not defined os_version (
    for /f "usebackq tokens=*" %%A in (`powershell -NoProfile -Command "(Get-CimInstance Win32_OperatingSystem).Version" 2^>nul`) do set "os_version=%%A"
)

if defined os_name (
    call :log "Названее: %os_name%"
) else (
    call :log "Названее: [ОШЫБКА] Ниудалось получить даные"
)

if defined os_version (
    call :log "Верьсия: %os_version%"
) else (
    call :log "Верьсия: [ОШЫБКА] Ниудалось получить даные"
)
call :log ""

call :log "[Процесор]"
set "cpu_name="
for /f "tokens=2 delims==" %%i in ('wmic cpu get Name /value 2^>nul') do if not "%%i"==" " set "cpu_name=%%i"

if not defined cpu_name (
    for /f "usebackq tokens=*" %%A in (`powershell -NoProfile -Command "(Get-CimInstance Win32_Processor).Name" 2^>nul`) do set "cpu_name=%%A"
)

if defined cpu_name (
    call :log "Моделька: %cpu_name%"
) else (
    call :log "Моделька: [ОШЫБКА] Ниудалось получить даные"
)
call :log ""

call :log "[Оперативная паметь]"
set "total_mem="
set "free_mem="
for /f "tokens=2 delims==" %%i in ('wmic os get TotalVisibleMemorySize /value 2^>nul') do set "total_mem=%%i"
for /f "tokens=2 delims==" %%i in ('wmic os get FreePhysicalMemory /value 2^>nul') do set "free_mem=%%i"

if defined total_mem (
    set /a total_gb=%total_mem% / 1048576
    call :log "Всево памети: !total_gb! ГБ"
) else (
    for /f "usebackq" %%A in (`powershell -NoProfile -Command "[math]::round((Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize / 1MB)" 2^>nul`) do set "total_gb=%%A"
    if defined total_gb (
        call :log "Всево памети: !total_gb! ГБ"
    ) else (
        call :log "Всево памети: [ОШЫБКА] Ошыбка ращета"
    )
)

if defined free_mem (
    set /a free_gb=%free_mem% / 1048576
    call :log "Свабодно памети: !free_gb! ГБ"
) else (
    for /f "usebackq" %%A in (`powershell -NoProfile -Command "[math]::round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB)" 2^>nul`) do set "free_gb=%%A"
    if defined free_gb (
        call :log "Свабодно памети: !free_gb! ГБ"
    ) else (
        call :log "Свабодно памети: [ОШЫБКА] Ошыбка ращета"
    )
)
call :log ""

call :log "[Диск Ц]"
set "disk_size="
set "disk_free="
for /f "tokens=2 delims==" %%i in ('wmic logicaldisk where DeviceID^="C:" get Size /value 2^>nul') do set "disk_size=%%i"
for /f "tokens=2 delims==" %%i in ('wmic logicaldisk where DeviceID^="C:" get FreeSpace /value 2^>nul') do set "disk_free=%%i"

if not defined disk_size (
    for /f "usebackq" %%A in (`powershell -NoProfile -Command "[math]::round((Get-CimInstance Win32_LogicalDisk -Filter ""DeviceID='C:'"").Size / 1GB)" 2^>nul`) do set "disk_size_gb=%%A"
) else (
    for /f "usebackq" %%A in (`powershell -NoProfile -Command "[math]::round(%disk_size% / 1GB)" 2^>nul`) do set "disk_size_gb=%%A"
)

if not defined disk_free (
    for /f "usebackq" %%A in (`powershell -NoProfile -Command "[math]::round((Get-CimInstance Win32_LogicalDisk -Filter ""DeviceID='C:'"").FreeSpace / 1GB)" 2^>nul`) do set "disk_free_gb=%%A"
) else (
    for /f "usebackq" %%A in (`powershell -NoProfile -Command "[math]::round(%disk_free% / 1GB)" 2^>nul`) do set "disk_free_gb=%%A"
)

if defined disk_size_gb (
    call :log "Общей размер: %disk_size_gb% ГБ"
) else (
    call :log "Общей размер: [ОШЫБКА] Нисмог рассчитать"
)

if defined disk_free_gb (
    call :log "Свабодно места: %disk_free_gb% ГБ"
) else (
    call :log "Свабодно места: [ОШЫБКА] Нисмог рассчитать"
)
call :log ""

for /f "tokens=2* %%a in ('reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /f DisplayName 2^>nul ^| findstr "DisplayName"') do echo %%b >> "%TEMP_APPS%"
for /f "tokens=2* %%a in ('reg query "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /f DisplayName 2^>nul ^| findstr "DisplayName"') do echo %%b >> "%TEMP_APPS%"

if exist "%TEMP_APPS%" (
    powershell -NoProfile -Command "Get-Content '%TEMP_APPS%' | Select-Object -Unique | Sort-Object | Out-File -FilePath '%SORTED_APPS%' -Encoding utf8"
)

call :log "[Рекомендацыи по недостающему ПО]"
if not exist "%SORTED_APPS%" (
    call :log " [КРИТИЧЕСКИЙ СБОЙ] Нисмог проанализировать риестр програм."
) else (
    set "found_app="
    for /f "usebackq delims=" %%A in (`findstr /I /C:"Office" /C:"LibreOffice" /C:"OpenOffice" /C:"МойОфис" "%SORTED_APPS%" 2^>nul`) do set "found_app=%%A"
    if defined found_app (
        call :log " [ОК] Офисный пакэт: Нашолся (!found_app!)"
    ) else (
        call :log " [ВНИМАНИЕ] Ненашли офисный пакэт! Для какай-то работы с доками лучше поставить LibreOffice или МойОфис."
    )

    set "found_app="
    for /f "usebackq delims=" %%A in (`findstr /I /C:"7-Zip" /C:"WinRAR" /C:"WinZip" "%SORTED_APPS%" 2^>nul`) do set "found_app=%%A"
    if defined found_app (
        call :log " [ОК] Архиватар: Нашолся (!found_app!)"
    ) else (
        call :log " [ВНИМАНИЕ] Нету архиватора... Чтобы открывать файлы из почьты паставьте 7-Zip или WinRAR."
    )

    set "found_app="
    for /f "usebackq delims=" %%A in (`findstr /I /C:"Acrobat" /C:"Foxit" /C:"SumatraPDF" "%SORTED_APPS%" 2^>nul`) do set "found_app=%%A"
    if defined found_app (
        call :log " [ОК] Сматреть PDF: Нашолся (!found_app!)"
    ) else (
        call :log " [ВНИМАНИЕ] Не нашли ПДФ читалку. Для работы с щет-фактурами и инсрукциями скачайте Foxit или SumatraPDF."
    )

    set "found_app="
    for /f "usebackq delims=" %%A in (`findstr /I /C:"Chrome" /C:"Firefox" /C:"Yandex" "%SORTED_APPS%" 2^>nul`) do set "found_app=%%A"
    if defined found_app (
        call :log " [ОК] Другой браузер: Нашолся (!found_app!)"
    ) else (
        call :log " [ИНФО] Других браузеров нету. Стандартный Microsoft Edge пашет по умолчанию."
    )

    set "found_app="
    for /f "usebackq delims=" %%A in (`findstr /I /C:"Kaspersky" /C:"ESET" /C:"Dr.Web" /C:"Defender" "%SORTED_APPS%" 2^>nul`) do set "found_app=%%A"
    if defined found_app (
        call :log " [ОК] Антивируска: Нашлась или система сама бдит (!found_app!)"
    ) else (
        call :log " [ВНИМАНИЕ] Чужой антивирус не виден. Проверьте что виндовс дефендер включон."
    )
)
call :log ""

call :log "[Рекомендацыи по лишнему ПО]"
if exist "%SORTED_APPS%" (
    set "has_excess=0"
    set "group_found=0"
    for /f "usebackq delims=" %%A in (`findstr /I /C:"Steam" /C:"Epic Games" /C:"GOG" /C:"Origin" /C:"Ubisoft" /C:"Battle.net" /C:"Riot" /C:"game" /C:"gaming" "%SORTED_APPS%" 2^>nul`) do (
        if !group_found!==0 (
            call :log " -> Нашли игрульки (это не для работы, надо бы проверить):"
            set "group_found=1"
            set "has_excess=1"
        )
        call :log "   - %%A"
    )

    set "group_found=0"
    for /f "usebackq delims=" %%A in (`findstr /I /C:"torrent" /C:"uTorrent" /C:"BitTorrent" /C:"qBittorrent" /C:"Vuze" "%SORTED_APPS%" 2^>nul`) do (
        if !group_found!==0 (
            call :log " -> Нашли торренты (опасно для сити и трафика, лучше перепроверить):"
            set "group_found=1"
            set "has_excess=1"
        )
        call :log "   - %%A"
    )

    set "group_found=0"
    for /f "usebackq delims=" %%A in (`findstr /I /C:"Discord" /C:"Telegram" /C:"WhatsApp" /C:"Viber" /C:"Skype" "%SORTED_APPS%" 2^>nul`) do (
        if !group_found!==0 (
            call :log " -> Нашли болталки и месенджеры (надо спросить у Айтишников можно ли их юзать):"
            set "group_found=1"
            set "has_excess=1"
        )
        call :log "   - %%A"
    )

    if !has_excess!==0 (
        call :log " [ОК] Фсяких левых и не целевых програм не нашли."
    )
)
call :log ""

call :log "Конец атчота. Все даные успешна записались."

if exist "%TEMP_APPS%" del /q "%TEMP_APPS%"
if exist "%SORTED_APPS%" del /q "%SORTED_APPS%"

echo.
echo Атчот сохранился в файл: pc_report.txt
echo.
pause
exit /b 0

:log
if "%~1" == "" (
    echo(
    echo(>> "%REPORT_FILE%"
    exit /b
)
echo %~1
echo %~1>> "%REPORT_FILE%"
exit /b
