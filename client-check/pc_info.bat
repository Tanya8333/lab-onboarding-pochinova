@echo off
chcp 65001 > nul
REM Практическая работа. Диагностика клиентского компьютера
REM Автор: Выполняющий студент
REM Результат: Сбор сведений о системе в файл %~dp0pc_report.txt
REM Путь к итоговому файлу отчета в той же папке, где лежит скрипт
set "REPORT_FILE=%~dp0pc_report.txt"
REM Очищаем старый отчет, если он существовал, и пишем общий заголовок
echo         ДИАГНОСТИКА КОМПЬЮТЕРА           >> "%REPORT_FILE%"
echo Дата и время проверки: %DATE% %TIME%     >> "%REPORT_FILE%"
REM Вывод стартового заголовка в консоль для пользователя
echo         ДИАГНОСТИКА КОМПЬЮТЕРА           
echo.
REM REM СВЕДЕНИЯ ОБ ОПЕРАЦИОННОЙ СИСТЕМЕ
echo [Операционная система] > "%~dp0os_temp.txt"
for /f "tokens=2 delims==" %%i in ('wmic os get Caption /value 2^>nul') do if not "%%i"=="" echo Название: %%i >> "%~dp0os_temp.txt"
for /f "tokens=2 delims==" %%i in ('wmic os get Version /value 2^>nul') do if not "%%i"=="" echo Версия: %%i >> "%~dp0os_temp.txt"
REM Выводим ОС на экран и в отчет
type "%~dp0os_temp.txt"
type "%~dp0os_temp.txt" >> "%REPORT_FILE%"
del "%~dp0os_temp.txt"
echo.
REM REM СВЕДЕНИЯ О ПРОЦЕССОРЕ
echo [Процессор] > "%~dp0cpu_temp.txt"
for /f "tokens=2 delims==" %%i in ('wmic cpu get Name /value 2^>nul') do if not "%%i"=="" echo Модель: %%i >> "%~dp0cpu_temp.txt"
REM Выводим процессор на экран и в отчет
type "%~dp0cpu_temp.txt"
type "%~dp0cpu_temp.txt" >> "%REPORT_FILE%"
del "%~dp0cpu_temp.txt"
echo.
REM REM СВЕДЕНИЯ ОБ ОПЕРАТИВНОЙ ПАМЯТИ
for /f "tokens=2 delims==" %%i in ('wmic os get TotalVisibleMemorySize /value 2^>nul') do set "total_mem=%%i"
for /f "tokens=2 delims==" %%i in ('wmic os get FreePhysicalMemory /value 2^>nul') do set "free_mem=%%i"
REM Перевод из КБ в ГБ (деление на 1048576)
set /a total_gb=%total_mem% / 1048576
set /a free_gb=%free_mem% / 1048576
echo [Оперативная память] > "%~dp0ram_temp.txt"
echo Всего памяти: %total_gb% ГБ >> "%~dp0ram_temp.txt"
echo Свободно памяти: %free_gb% ГБ >> "%~dp0ram_temp.txt"
REM Выводим ОЗУ на экран и в отчет
type "%~dp0ram_temp.txt"
type "%~dp0ram_temp.txt" >> "%REPORT_FILE%"
del "%~dp0ram_temp.txt"
echo.
REM REM СВОБОДНОЕ МЕСТО НА ДИСКЕ
for /f "tokens=2 delims==" %%i in ('wmic logicaldisk where DeviceID^="C:" get Size /value 2^>nul') do set "disk_size=%%i"
for /f "tokens=2 delims==" %%i in ('wmic logicaldisk where DeviceID^="C:" get FreeSpace /value 2^>nul') do set "disk_free=%%i"
REM Так как числа в байтах слишком большие для 32-битной арифметики set /a (лимит 2 млрд),
REM мы сначала программно отсекаем последние 6 символов (делим на 1 000 000), а затем переводим в ГБ
set "disk_size_short=%disk_size:~0,-6%"
set "disk_free_short=%disk_free:~0,-6%"
set /a disk_size_gb=%disk_size_short% / 1073
set /a disk_free_gb=%disk_free_short% / 1073
echo [Диск C] > "%~dp0disk_temp.txt"
echo Общий размер: %disk_size_gb% ГБ >> "%~dp0disk_temp.txt"
echo Свободно места: %disk_free_gb% ГБ >> "%~dp0disk_temp.txt"
REM Выводим диск на экран и в отчет
type "%~dp0disk_temp.txt"
type "%~dp0disk_temp.txt" >> "%REPORT_FILE%"
del "%~dp0disk_temp.txt"
echo.
REM REM СПИСОК УСТАНОВЛЕННЫХ ПРОГРАММ (ЧЕРЕЗ РЕЕСТР — БЫСТРЫЙ ВАРИАНТ)
echo [Установленные программы]
echo [Установленные программы] >> "%REPORT_FILE%"
REM Создаем временный файл для чистки названий от лишних пробелов findstr
set "PROG_TEMP=%~dp0prog_temp.txt"
if exist "%PROG_TEMP%" del "%PROG_TEMP%"
REM Опрашиваем ветки реестра 64-бит и 32-бит
for /f "tokens=2*" %%a in ('reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /f DisplayName 2^>nul ^| findstr "DisplayName"') do echo %%b >> "%PROG_TEMP%"
for /f "tokens=2*" %%a in ('reg query "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /f DisplayName 2^>nul ^| findstr "DisplayName"') do echo %%b >> "%PROG_TEMP%"
REM Сортируем список программ по алфавиту, убираем дубли, выводим на экран и в отчет
if exist "%PROG_TEMP%" (
    sort "%PROG_TEMP%" > "%~dp0sorted_temp.txt"
    type "%~dp0sorted_temp.txt"
    type "%~dp0sorted_temp.txt" >> "%REPORT_FILE%"
    del "%PROG_TEMP%"
    del "%~dp0sorted_temp.txt"
) else (
    echo Программ не найдено или доступ ограничен.
    echo Программ не найдено или доступ ограничен. >> "%REPORT_FILE%"
)
echo.
echo Конец отчета. >> "%REPORT_FILE%"
REM REM ЗАВЕРШЕНИЕ РАБОТЫ
echo.
echo Отчет сохранен в файл: pc_report.txt
echo.
pause
