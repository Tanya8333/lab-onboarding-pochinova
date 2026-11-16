@echo off
chcp 65001 > nul
set score_youtrack=0
set score_redmine=0
set score_taiga=0

echo 
echo   МОДУЛЬ 1: ВЫБОР СИСТЕМЫ ОТСЛЕЖИВАНИЯ ЗАДАЧ
echo 
echo.

choice /c 123 /n
if errorlevel==3 set /a score_taiga+=15
if errorlevel==2 set /a score_youtrack+=15
if errorlevel==1 set /a score_redmine+=15
echo.


choice /c 123 /n
if errorlevel==3 set /a score_youtrack+=15
if errorlevel==2 set /a score_redmine+=10
if errorlevel==1 set /a score_taiga+=15
echo.


choice /c 123 /n
if errorlevel==3 set /a score_taiga+=10
if errorlevel==2 set /a score_youtrack+=10
if errorlevel==1 set /a score_redmine+=15
echo.


choice /c 12 /n
if errorlevel==2 set /a score_redmine+=10
if errorlevel==1 (
    set /a score_youtrack+=10
    set /a score_taiga+=10
)
echo.

echo --- Результаты оценки ---
echo YouTrack: %score_youtrack% баллов
echo Redmine:  %score_redmine% баллов
echo Taiga:    %score_taiga% баллов
echo.

if %score_youtrack% geq %score_redmine% if %score_youtrack% geq %score_taiga% (
    set res_ch1=YouTrack
    goto show_res1
)
if %score_redmine% geq %score_youtrack% if %score_redmine% geq %score_taiga% (
    set res_ch1=Redmine
    goto show_res1
)
set res_ch1=Taiga

:show_res1
echo Рекомендация по выбору технологии: %res_ch1%
echo.
pause
