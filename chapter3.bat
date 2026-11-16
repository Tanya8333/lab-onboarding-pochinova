@echo off
chcp 65001 > nul

:weights
echo
echo   МОДУЛЬ 3: СРАВНИТЕЛЬНЫЙ АНАЛИЗ (МЕТОД WSM)
echo 
echo.
echo Назначьте веса критериям (сумма должна быть равна 100):
set /p w1="Вес критерия 1: "
set /p w2="Вес критерия 2: "
set /p w3="Вес критерия 3: "

set /a total_weight=w1+w2+w3
if %total_weight% neq 100 (
    echo.
    echo [Ошибка] Сумма весов равна %total_weight%, а должна быть 100! Попробуйте снова.
    echo.
    goto weights
)

echo.
echo Оцените альтернативы по шкале от 1 до 5:
echo --- YouTrack ---
set /p y_1="YouTrack: "
set /p y_2="YouTrack: "
set /p y_3="YouTrack (Простота настройки): "

echo --- Redmine ---
set /p r_1="Redmine: "
set /p r_2="Redmine: "
set /p r_3="Redmine: "

echo --- Taiga ---
set /p t_1="Taiga: "
set /p t_2="Taiga: "
set /p t_3="Taiga: "

set /a score_y=y_1*w1+y_2*w2+y_3*w3
set /a score_r=r_1*w1+r_2*w2+r_3*w3
set /a score_t=t_1*w1+t_2*w2+t_3*w3

echo.
echo ================= МАТРИЦА РЕШЕНИЙ =================
echo Критерий             ^| Вес ^| YouTrack ^| Redmine ^| Taiga
echo ---------------------------------------------------
echo Scrum-доски          ^| %w1%  ^| %y_1%        ^| %r_1%       ^| %t_1%
echo Стоимость лицензий   ^| %w2%  ^| %y_2%        ^| %r_2%       ^| %t_2%
echo Простота настройки   ^| %w3%  ^| %y_3%        ^| %r_3%       ^| %t_3%
echo ---------------------------------------------------
echo ИТОГО (баллы WSM)    ^| 100 ^| %score_y%      ^| %score_r%     ^| %score_t%
echo ===================================================
echo.

if %score_y% geq %score_r% if %score_y% geq %score_t% (
    set res_ch3=YouTrack
    goto show_res3
)
if %score_r% geq %score_y% if %score_r% geq %score_t% (
    set res_ch3=Redmine
    goto show_res3
)
set res_ch3=Taiga

:show_res3
echo Победитель сравнительного анализа: %res_ch3%
echo.
pause
