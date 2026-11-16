@echo off
chcp 65001 > nul
set correct=0
set points=0
set total=3

echo 
echo   МОДУЛЬ 2: ИНСПЕКЦИЯ КОДА (SCRUM / ТРЕКЕР ЗАДАЧ)
echo 
echo.

echo Фрагмент 1:
echo 10: def calculate_sprint_hours(tasks):
echo 11:     total_hours = 0
echo 12:     for task in tasks:
echo 13:         total_hours += task.story_points * 6  # коэффициент перевода
echo 14:     return total_hours
echo.
echo Какой дефект здесь скрыт?
echo 1. Неинициализированная переменная
echo 2. Магическое число (6)
echo 3. Утечка ресурса
choice /c 123 /n
if errorlevel==3 goto wrong1
if errorlevel==2 goto right1
if errorlevel==1 goto wrong1

:right1
echo [+] Верно! Коэффициент 6 нужно вынести в именованную константу. (+10 очков)
set /a correct+=1
set /a points+=10
goto frag2

:wrong1
echo [-] Неверно. Правильный ответ: 2 (Магическое число). (-5 очков)
set /a points-=5

:frag2
echo.
echo Фрагмент 2:
echo 20: def fetch_sprint_issues(api_url):
echo 21:     response = requests.get(api_url)
echo 22:     issues = response.json()
echo 23:     return issues
echo.
echo Какой дефект здесь скрыт?
echo 1. Отсутствие обработки ошибок
echo 2. Мёртвое присваивание
echo 3. Утечка ресурса
choice /c 123 /n
if errorlevel==3 goto wrong2
if errorlevel==2 goto wrong2
if errorlevel==1 goto right2

:right2
echo [+] Верно! Нет проверки статуса ответа и блока try/except при сбое сети. (+10 очков)
set /a correct+=1
set /a points+=10
goto frag3

:wrong2
echo [-] Неверно. Правильный ответ: 1 (Отсутствие обработки ошибок). (-5 очков)
set /a points-=5

:frag3
echo.
echo Фрагмент 3:
echo 30: def export_burndown_chart(data):
echo 31:     f = open("sprint_report.csv", "w")
echo 32:     f.write(data)
echo 33:     status = "exported"
echo 34:     return status
echo.
echo Какой дефект здесь скрыт?
echo 1. Магическое число
echo 2. Неинициализированная переменная
echo 3. Утечка ресурса (файл не закрыт)
choice /c 123 /n
if errorlevel==3 goto right3
if errorlevel==2 goto wrong3
if errorlevel==1 goto wrong3

:right3
echo [+] Верно! Файл открыт через open(), но не закрыт (нужен контекстный менеджер with). (+10 очков)
set /a correct+=1
set /a points+=10
goto summary2

:wrong3
echo [-] Неверно. Правильный ответ: 3 (Утечка ресурса). (-5 очков)
set /a points-=5

:summary2
echo.
echo === Итоговый отчёт ревью ===
echo Просмотрено фрагментов: %total%
echo Правильных ответов: %correct% из %total%
echo Итоговые очки: %points%
set /a percentage=correct*100/total
echo Точность: %percentage%%%

if %percentage% geq 80 (
    set res_ch2=Senior Reviewer
) else if %percentage% geq 50 (
    set res_ch2=Middle Reviewer
) else (
    set res_ch2=Junior Reviewer
)
echo Уровень ревьюера: %res_ch2%
echo.
pause
