# Лабораторная работа №2. Моделирование процессов принятия решений в разработке ПО

## 1. Титульные данные
* **Выполнил:** [Починова Татьяна Алексеевна]
* **Группа:** [3525П1ИН1]
* **Номер работы:** Лабораторная работа №2
* **Вариант:** Вариант 5 — Выбор системы отслеживания задач (Кандидаты: *YouTrack, Redmine, Taiga*; контекст: команда из 12 человек, работающая по Scrum)

## 2. Ссылка на репозиторий GitHub
* **Репозиторий проекта:** https://github.com/Tanya8333/lab-onboarding-pochinova/tree/develop

---

## 3. Листинги модулей и комментарии к ключевым участкам кода

### 3.1. Модуль выбора технологий (`chapter1.bat`)
Модуль формирует профиль проекта на основе 4 вопросов (бюджет, поддержка Scrum, опыт администрирования, сроки внедрения) и выбирает наиболее подходящий трекер задач.

```bat
@echo off
chcp 65001 > nul
set score_youtrack=0
set score_redmine=0
set score_taiga=0

echo ==================================================
echo   МОДУЛЬ 1: ВЫБОР СИСТЕМЫ ОТСЛЕЖИВАНИЯ ЗАДАЧ
echo ==================================================
echo.

echo Вопрос 1: Какой бюджет выделен на трекер задач для команды из 12 человек?
echo 1. Ограниченный / нулевой (нужен бесплатный open-source)
echo 2. Средний / коммерческий (готовы платить за удобство и поддержку)
echo 3. Минимальный, но нужен современный интерфейс для Scrum
choice /c 123 /n
if errorlevel==3 set /a score_taiga+=15
if errorlevel==2 set /a score_youtrack+=15
if errorlevel==1 set /a score_redmine+=15
echo.

echo Вопрос 2: Насколько важна встроенная поддержка Scrum (бэклог, спринты, диаграммы сгорания)?
echo 1. Критически важна из коробки без установки плагинов
echo 2. Достаточно базовых задач, остальное доработаем плагинами
echo 3. Нужны гибкие доски и умный поиск по задачам
choice /c 123 /n
if errorlevel==3 set /a score_youtrack+=15
if errorlevel==2 set /a score_redmine+=10
if errorlevel==1 set /a score_taiga+=15
echo.

echo Вопрос 3: Какова квалификация команды в администрировании серверов?
echo 1. Есть опытный DevOps / системный администратор (готовы настраивать Ruby/плагины)
echo 2. Разработчики не хотят тратить время на сложную настройку
echo 3. Нужен быстрый старт в облаке или через Docker
choice /c 123 /n
if errorlevel==3 set /a score_taiga+=10
if errorlevel==2 set /a score_youtrack+=10
if errorlevel==1 set /a score_redmine+=15
echo.

echo Вопрос 4: Какие сроки внедрения системы в рабочий процесс?
echo 1. Срочно (запустить спринт уже завтра)
echo 2. Есть 1-2 недели на установку и миграцию данных
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
```
**Ключевые участки кода:**
* `chcp 65001 > nul` — переводит кодировку консоли в UTF-8 для корректного отображения кириллицы.
* `choice /c 123 /n` — ожидает нажатия клавиш `1`, `2` или `3` без необходимости нажимать Enter.
* `if errorlevel==... set /a ...` — проверяет код нажатой клавиши (от большего к меньшему) и начисляет баллы соответствующему кандидату с помощью арифметического присваивания `set /a`.
* `set res_ch1=...` — сохраняет итоговую рекомендацию в переменную окружения для последующей передачи в главный модуль.

---

### 3.2. Модуль инспекции кода (`chapter2.bat`)
Модуль последовательно демонстрирует 3 фрагмента кода на Python из предметной области управления задачами и спринтами, проверяет умение находить дефекты, начисляет/снимает очки и определяет квалификацию ревьюера.

```bat
@echo off
chcp 65001 > nul
set correct=0
set points=0
set total=3

echo ==================================================
echo   МОДУЛЬ 2: ИНСПЕКЦИЯ КОДА (SCRUM / ТРЕКЕР ЗАДАЧ)
echo ==================================================
echo.

echo Фрагмент 1 (Расчёт оценки времени спринта):
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
echo Фрагмент 2 (Выгрузка задач из API трекера):
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
echo Фрагмент 3 (Сохранение отчёта о закрытии спринта):
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
```
**Ключевые участки кода:**
* Метки перехода (`:right1`, `:wrong1`, `:frag2` и т.д.) и команда `goto` — организуют ветвление для начисления `+10` очков за верный ответ и списания `-5` очков за ошибку.
* `set /a percentage=correct*100/total` — вычисляет процент точности ревьюера.
* Блок `if %percentage% geq ...` — классифицирует пользователя по уровням (`Senior`, `Middle` или `Junior Reviewer`) и сохраняет результат в переменную `res_ch2`.

---

### 3.3. Модуль сравнительного анализа (`chapter3.bat`)
Модуль реализует метод взвешенной суммы (WSM) для сравнения систем **YouTrack**, **Redmine** и **Taiga**.

```bat
@echo off
chcp 65001 > nul

:weights
echo ==================================================
echo   МОДУЛЬ 3: СРАВНИТЕЛЬНЫЙ АНАЛИЗ (МЕТОД WSM)
echo ==================================================
echo.
echo Назначьте веса критериям (сумма должна быть равна 100):
set /p w1="Вес критерия 1 (Удобство Scrum-досок): "
set /p w2="Вес критерия 2 (Стоимость лицензий): "
set /p w3="Вес критерия 3 (Простота настройки и поддержки): "

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
set /p y_1="YouTrack (Удобство Scrum-досок): "
set /p y_2="YouTrack (Стоимость лицензий): "
set /p y_3="YouTrack (Простота настройки): "

echo --- Redmine ---
set /p r_1="Redmine (Удобство Scrum-досок): "
set /p r_2="Redmine (Стоимость лицензий): "
set /p r_3="Redmine (Простота настройки): "

echo --- Taiga ---
set /p t_1="Taiga (Удобство Scrum-досок): "
set /p t_2="Taiga (Стоимость лицензий): "
set /p t_3="Taiga (Простота настройки): "

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
echo 
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
```
**Ключевые участки кода:**
* `if %total_weight% neq 100 goto weights` — валидация пользовательского ввода: если сумма весов не равна 100, скрипт возвращает пользователя к повторному вводу.
