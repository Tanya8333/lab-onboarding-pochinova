@echo off
chcp 65001 > nul
set res_ch1=Модуль 1 ещё не пройден
set res_ch2=Модуль 2 ещё не пройден
set res_ch3=Модуль 3 ещё не пройден

:menu
cls
echo 
echo   СИСТЕМА МОДЕЛИРОВАНИЯ ПРОЦЕССОВ РАЗРАБОТКИ ПО
echo   Вариант 5: Выбор системы отслеживания задач
echo 
echo.
echo 1. Модуль выбора технологий (chapter1.bat)
echo 2. Модуль инспекции кода (chapter2.bat)
echo 3. Модуль сравнительного анализа (chapter3.bat)
echo 4. Запустить все модули последовательно и создать отчёт
echo 5. Выход
echo.
set /p choice="Ваш выбор (1-5): "

if "%choice%"=="1" (
    cls
    call chapter1.bat
    goto menu
)
if "%choice%"=="2" (
    cls
    call chapter2.bat
    goto menu
)
if "%choice%"=="3" (
    cls
    call chapter3.bat
    goto menu
)
if "%choice%"=="4" (
    cls
    call chapter1.bat
    cls
    call chapter2.bat
    cls
    call chapter3.bat
    cls
    echo 
    echo   ИТОГОВЫЙ ОТЧЁТ СИСТЕМЫ (ВАРИАНТ 5)
    echo 
    echo Модуль 1: %res_ch1%
    echo Модуль 2:  %res_ch2%
    echo Модуль 3:  %res_ch3%
    echo
    echo.

    (
        echo 
        echo   ИТОГОВЫЙ ОТЧЁТ СИСТЕМЫ (ВАРИАНТ 5)
        echo   Предметная область: Выбор системы отслеживания задач
        echo 
        echo Дата формирования: %DATE% %TIME%
        echo.
        echo 1. Рекомендация по выбору технологии: %res_ch1%
        echo 2. Уровень ревьюера кода: %res_ch2%
        echo 3. Победитель сравнительного анализа (WSM): %res_ch3%
        echo
    ) > report.txt

    echo [OK] Итоговый отчёт успешно сохранён в файл report.txt!
    echo.
    pause
    goto menu
)
if "%choice%"=="5" exit
goto menu
