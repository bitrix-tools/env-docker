# dev сайт - контейнерное окружение для Битрикс

Проект представляет собой dev сайт, он же девелоперский сайт, предназначенный для тестирования, разработки, примера использования окружения на базе технологий [Docker](https://www.docker.com/).

Программы, необходимые для работы технологий Битрикс, запускаются в контейнерах (`Docker Containers`). По шаблону из образов (`Docker Images`). Данные хранят в томах (`Docker Volumes`). Связаны между собой посредством сети (`Docker Network`). И управляются (оркестируются) используюя compose (`Docker Compose`).

> [!CAUTION]
> Внимание! dev сайт не предназначен для использования в продакшене. (___!!!ToDo_дополнить_и_расписать___)

# Содержимое

* [Docker и Docker Compose](#docker)
* [Сборка или скачивание Docker образов](#dockerimages)
  * [Базовые образы](#basicimages)
  * [Битрикс образы (bx-*)](#bitriximages)
* [Пароли к базам данных mysql и postgresql](#databasespasswords)
* [Секретный ключ для push сервера](#pushserversecretkey)
* [Управление](#management)
* [Часовой пояс (timezone)](#timezone)
* [Адресация](#iporurls)
* [Порты](#ports)
* [Доступ к сайту](#siteaccess)
* [Базовая проверка конфигурации окружения](#bitrixservertestphp)
* [BitrixSetup / Restore](#bitrixsetupphprestorephp)
  * [Установка дистрибутивов](#installdistro)
  * [Восстановление из резервной копии](#restorebackup)
* [Лицензия, обновления платформы и решений](#licenceandupdates)
* [Настройки модулей](#modulessettings)
* [Проверка системы](#sitechecker)
* [Тест производительности](#perfmonpanel)
* [Cron](#cron)
  * [Выполнение агентов на cron](#agentsoncron)
  * [Кастомные cron задания](#owncrontasks)
* [Хранение временных файлов вне корневой директории сайта](#bxtemporaryfilesdirectory)
* [Push & pull](#pushpull)
  * [Push сервер](#pushserver)
* [Sphinx](#sphinx)
  * [Поиск с помощью Sphinx](#sphinxsearch)
* [Почта](#email)
  * [Отправка почты с помощью msmtp](#msmtpmta)
  * [Отправка почты через SMTP-сервера отправителя](#emailsmtpmailer)
  * [Логирование отправки почты в файл](#emaildebuglog)
* [PHP](#php)
  * [Composer](#phpcomposer)
  * [Browser Capabilities](#phpbrowsercapabilities)
  * [GeoIP2](#phpgeoip2)
  * [Расширения (extensions)](#phpextensions)
  * [Imagick Engine для изображений](#phpimagickimageengine)
  * [security: Веб-антивирус](#phpsecurityantivirus)
* [Memcache и Redis](#memcacheandredis)
  * [Memcache](#memcache)
  * [Redis](#redis)
  * [Кеширование](#cachestorage)
  * [Хранение сессий](#sessionstorage)
  * [Кеширование с помощью модуля Веб-кластер](#clustercachestorage)
    * [Memcache](#clustercachememcache)
    * [Redis](#clustercacheredis)
* [HTTPS/SSL/TLS/WSS](#httpsssltlswss)
  * [Самоподписанный сертификат](#selfsignedcerts)
  * [Бесплатный Lets Encrypt сертификат](#presentcerts)
* [Консоль сервисов](#servicesconsole)
  * [Контейнер](#containerconsole)
  * [MySQL](#mysqlconsole)
  * [PostgreSQL](#postgresqlconsole)
  * [Memcache](#memcacheconsole)
  * [Redis](#redisconsole)
* [Кастомизация](#customization)

<a id="docker"></a>
# Docker и Docker Compose

Для запуска проекта понадобится `Docker`. Для оркестировки и управления `Docker Compose`.

Способ развертывания зависит от вашей операционной системы, используемой на хосте.

Возможны варианты:
- рабочая станция, персональный компьютер, ноутбук и т.д. с рабочим столом и графической средой, он же desktop
- сервер, без графической среды, но с консолью или удаленным доступом, он же server

Для взаимодействия с `Docker` в графическом режиме будем использовать продукт [Docker Desktop](https://docs.docker.com/desktop/), который возможно запустить на ОС `Windows`, `Linux`, `MacOS`.

Ознакомтесь с документацией и выполните развертывание `Docker`, в зависимости от используемой вами ОС:
- `Docker Desktop on Windows`: https://docs.docker.com/desktop/setup/install/windows-install/
- `Docker Desktop on Linux`: https://docs.docker.com/desktop/setup/install/linux/
- `Docker Desktop on Mac`: https://docs.docker.com/desktop/setup/install/mac-install/

Для взаимодействия с `Docker` в режиме командной строки (без графического режима) будем использовать продукт [Docker Engine](https://docs.docker.com/engine/), который возможно запустить на ОС `Linux`.

Ознакомтесь с документацией и выполните развертывание `Docker Engine`, в зависимости от используемой вами ОС `Linux`:
- `Docker Engine`: https://docs.docker.com/engine/install/

В современных версиях продуктов `Docker` обычно в их состав уже включен `Docker Compose`.

Ознакомтесь с документацией и выполните развертывание `Docker Compose`, если это требуется отдельно:
- `Docker Compose`: https://docs.docker.com/compose/

<a id="dockerimages"></a>
# Сборка или скачивание Docker образов

Наша цель - подготовить или собрать максимально совместимые и готовые для Битрикс образы, запускающие набор ПО в контейнерах.

<a id="basicimages"></a>
## Базовые образы

Там где возможно будем использовать официальные Docker образы ПО, теги для которых будем брать с [DockerHub](https://hub.docker.com/):
- `PostgreSQL`: https://hub.docker.com/_/postgres
- `Redis`: https://hub.docker.com/_/redis
- `Memcached`: https://hub.docker.com/_/memcached

В этот список попадают (формат `название`:`полный_тег_с_указанием_версии_и_ос`):
- `postgres:16.8-bookworm`
- `redis:7.2.8-alpine`
- `memcached:1.6.38-alpine`

Можно предварительно скачать список выше, используя команды:
```bash
docker pull postgres:16.8-bookworm
docker pull redis:7.2.8-alpine
docker pull memcached:1.6.38-alpine
```

<a id="bitriximages"></a>
## Битрикс образы (bx-*)

Так же нам понадобятся:
- база данных mysql: используем стабильный образ `percona/percona-server:8.0.41`, добавляем слоем сверху конфигурацию бд, собираем `bx-percona-server:8.0.41-v1-rhel`
- веб сервер: используем стабильный образ `nginx:1.28.0-alpine-slim`, добавляем модули слоем сверху, собираем `bx-nginx:1.28.0-v1-alpine`
- интерпретатор php кода: готового совместимого образа php увы нет, берем по умолчанию образ `php:8.2.28-fpm-alpine` и добавляем то, что нам надо через пару слоев сверху, собираем `bx-php:8.2.28-fpm-v1-alpine`
- поиск: готового образа sphinx нет, но есть собранный пакет `sphinx` на базе `alpine` linux в официальном репозитории ОС, собираем `bx-sphinx:2.2.11-v1-alpine`, установив пакет
- push сервер: готового образа нет, используем образ NodeJS 20-ой версии, собираем `bx-push:3.0-v1-alpine`, используя его исходники `push-server-0.4.0`
- генератор самоподписных ssl сертификатов: небольшой образ с пакетами на базе `alpine` linux, собираем `bx-ssl:1.0-v1-alpine`

Список официальных Docker образов, которые будем брать с [DockerHub](https://hub.docker.com/):
- `Percona Server`: https://hub.docker.com/r/percona/percona-server
- `Nginx`: https://hub.docker.com/_/nginx
- `PHP`: https://hub.docker.com/_/php
- `NodeJS`: https://hub.docker.com/_/node
- `Alpine`: https://hub.docker.com/_/alpine

Для сборки нам понадобятся следующие образы (их можно предварительно скачать используя команды):
```bash
docker pull percona/percona-server:8.0.41
docker pull nginx:1.28.0-alpine-slim
docker pull php:8.2.28-fpm-alpine
docker pull node:20
docker pull node:20-alpine
docker pull alpine:3.21
```

Собираем образы, в названии используем `bx-`:

- bx-sphinx:
```bash
cd dev/sources/bxsphinx2211/
docker build -f Dockerfile -t bx-sphinx:2.2.11-v1-alpine --no-cache .
```

- bx-push:
```bash
cd dev/sources/bxpush30/
docker build -f Dockerfile -t bx-push:3.0-v1-alpine --no-cache .
```

- bx-php:
```bash
cd dev/sources/bxphp8228/
docker build -f Dockerfile -t bx-php:8.2.28-fpm-v1-alpine --no-cache .
```

- bx-nginx:
```bash
cd dev/sources/bxnginx1280/
docker build -f Dockerfile -t bx-nginx:1.28.0-v1-alpine --no-cache .
```

- bx-ssl:
```bash
cd dev/sources/bxssl10/
docker build -f Dockerfile -t bx-ssl:1.0-v1-alpine --no-cache .
```

- bx-percona-server:
```bash
cd dev/sources/bxpercona8041/
docker build -f Dockerfile -t bx-percona-server:8.0.41-v1-rhel --no-cache .
```

Во всех образах `bx-` в названии тега указывается `v1`, состоит из:
- общая отметка версии, указывается буквой `v`
- номер сборки, начинается с цифры `1`

<a id="databasespasswords"></a>
# Пароли к базам данных mysql и postgresql

> [!CAUTION]
> Внимание! Перед первым запуском обязательно придумайте или сгенерируйте ваши уникальные пароли суперпользователей баз данных `mysql` и `postgresql`.

Для этого используем образ `alpine` linux:
```bash
docker pull alpine:3.21
```

Cгенерируем ваш уникальный пароль для суперпользователя `root` базы данных `mysql` с помощью команды:
```bash
docker container run --rm --name mysql_password_generate alpine:3.21 sh -c "(cat /dev/urandom | tr -dc A-Za-z0-9\?\!\@\-\_\+\%\(\)\{\}\[\]\= | head -c 16) | tr -d '\' | tr -d '^' && echo ''"
```

Cгенерируем ваш уникальный пароль для суперпользователя `postgres` базы данных `postgresql` с помощью команды:
```bash
docker container run --rm --name postgresql_password_generate alpine:3.21 sh -c "(cat /dev/urandom | tr -dc A-Za-z0-9\?\!\@\-\_\+\%\(\)\{\}\[\]\= | head -c 16) | tr -d '\' | tr -d '^' && echo ''"
```

Шаблон пароля для суперпользователя `root` базы данных `mysql` (`CHANGE_MYSQL_ROOT_PASSWORD_HERE`) и шаблон пароля для суперпользователя `postgres` базы данных `postgresql` (`CHANGE_POSTGRESQL_POSTGRES_PASSWORD_HERE`) хранятся в файле `.env_sql` в виде:
```bash
MYSQL_ROOT_PASSWORD="CHANGE_MYSQL_ROOT_PASSWORD_HERE"
POSTGRES_PASSWORD="CHANGE_POSTGRESQL_POSTGRES_PASSWORD_HERE"
```

Обязательно измените значения в файле `.env_sql`, заменив шаблоны `CHANGE_MYSQL_ROOT_PASSWORD_HERE` и `CHANGE_POSTGRESQL_POSTGRES_PASSWORD_HERE` на ваши значения.

<a id="pushserversecretkey"></a>
# Секретный ключ для push сервера

> [!CAUTION]
> Внимание! Перед первым запуском обязательно придумайте или сгенерируйте ваш уникальный секретный ключ для push сервера.

Для этого используем образ `alpine` linux:
```bash
docker pull alpine:3.21
```

Cгенерируем ваш уникальный секретный ключ с помощью команды:
```bash
docker container run --rm --name push_server_key_generate alpine:3.21 sh -c "(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 128) && echo ''"
```

Шаблон секретного ключа (`CHANGE_SECURITY_KEY_HERE`) для подписи соединения между клиентом и push-сервером хранится в файле `.env_push` в виде:
```bash
PUSH_SECURITY_KEY=CHANGE_SECURITY_KEY_HERE
```
Обязательно измените значение вашего уникального секретного ключа в файле `.env_push`, заменив шаблон `CHANGE_SECURITY_KEY_HERE` на ваше значение.

<a id="management"></a>
# Управление

Управление (или оркестровка) набором контейнеров или одним из контейнеров осуществляется через `Docker Compose`.

Переходим в каталог проекта `cd dev` и выполняем команды ниже:

Запустить все контейнеры и оставить их работать в фоне:
```bash
docker compose up -d
```

Отобразить список контейнеров и их статус:
```bash
docker compose ps
```

Показать логи сразу всех контейнеров:
```bash
docker compose logs
```

Показать лог определенного сервиса-контейнера:
```bash
docker compose logs redis
```

Перезапустить определенный контейнер:
```bash
docker compose restart nginx
```

Перезапустить все контейнеры:
```bash
docker compose restart
```

Остановить все контейнеры:
```bash
docker compose stop
```

Остановить все контейнеры, удалить их:
```bash
docker compose down
```

Остановить все контейнеры, удалить их и удалить все тома этих контейнеров:
```bash
docker compose down -v
```

Зайти в sh консоль определенного контейнера, например nginx:
```bash
docker compose exec nginx sh
```

Подробней в документации docker compose: https://docs.docker.com/reference/cli/docker/compose/

<a id="timezone"></a>
# Часовой пояс (timezone)

Значение таймзоны, используемой контейнерами, хранится в файле `.env`.
Значение по умолчание задано как:
```bash
TZ=Europe/Kaliningrad
```

Исключение составляет контейнер с `php`, значение тамйзоны для которого продублировано в отдельном файле `confs/php/etc/php/conf.d/timezone.ini` как:
```bash
date.timezone = Europe/Kaliningrad
```

При необходимости смените значение в обоих файлах. Перезапустите все контейнеры:
```bash
docker compose restart
```

<a id="iporurls"></a>
# Адресация

Обращение к запущенному сайту может быть:
1) через `localhost` или `127.0.0.1`
2) по IP вашей локальной сети вида `10.X.X.X`, `192.X.X.X`, `172.X.X.X` и т.д.
3) по имени локального домена в вашей локальной сети вида `dev.bx`
4) по IP глобальной сети интернет вида `85.86.87.88`
5) по имени настоящего домена вида `devexample.com`

Выбор зависит от вашей конфигурации.

Так же стоит учесть: при использовании https нужен ssl сертификат, который можно сгенерировать или получить на доменное имя, но не на IP.

<a id="ports"></a>
# Порты

Запущенный сайт для своей работы по умолчанию использует порты:
- `8588` для http
- `8589` для https

В случае если вы используете файрвол необходимо открыть порты. Пример команд для разных ОС:

- Debian/Ubuntu и т.д.:
```bash
ufw allow 8588 && ufw allow 8589
```

- RHEL/CentOS/AlmaLinux/RockyLinux/OracleLinux/ArchLinux и т.д.:
```bash
firewall-cmd --add-port=8588/tcp --permanent && firewall-cmd --add-port=8589/tcp --permanent && firewall-cmd --reload
```

Для других ОС смотрите документацию по работе с файрволлом.

<a id="siteaccess"></a>
# Доступ к сайту

Итак, согласно разделам `Адресация` и `Порты` выше, к сайту можно обратиться по http/https следующим образом:

- через локалхост:
  - http://127.0.0.1:8588/
  - https://127.0.0.1:8589/

- по локальному ip:
  - http://10.0.1.119:8588/
  - https://10.0.1.119:8589/

- используя домен:
  - http://dev.bx:8588/
  - https://dev.bx:8589/

> [!IMPORTANT]
> <b>НЕ</b> используйте `127.0.0.1` или `localhost` при работе с сайтом на локальной машине. Используйте ip или домен, пример `10.0.1.119` или `dev.bx`.

В примерах ниже будет использоваться локальный ip `10.0.1.119` или локальный домен `dev.bx`.

<a id="bitrixservertestphp"></a>
# Базовая проверка конфигурации окружения

После запуска сайта необходимо провести базовую проверку конфигурации веб-сервера. Она выполняется с помощью скрипта `bitrix_server_test.php`.

Используем способ, который работает одинаково на всех ОС.

Заходим в sh-консоль контейнера `php` из под пользователя `bitrix`:
```bash
docker compose exec --user=bitrix php sh
```

Переходим в корневой каталог сайта и скачиваем скрипт `bitrix_server_test.php`:
```bash
cd /opt/www/
wget https://dev.1c-bitrix.ru/download/scripts/bitrix_server_test.php
```

В браузере переходим по ссылке вида:
```bash
http://10.0.1.119:8588/bitrix_server_test.php
```

> [!CAUTION]
> Внимание! После проверки конфигурации окружения скрипт `bitrix_server_test.php` нужно удалить.

PS: для Docker Engine на Linux расположение каталога сайта на хосте зависит от режима работы docker-а:
- rootfull:
```bash
/var/lib/docker/volumes/dev_www_data/_data/
```

- rootless:
```bash
/home/[USERNAME]/.local/share/docker/volumes/dev_www_data/_data
```

<a id="bitrixsetupphprestorephp"></a>
# BitrixSetup / Restore

Для установки продуктов Битрикс можно использовать скрипт `bitrixsetup.php`: https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=135&LESSON_ID=4523&LESSON_PATH=10495.4495.4523

Для восстановления из резервной копии скрипт `restore.php`: https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=135&CHAPTER_ID=02014&LESSON_PATH=10495.4496.2014

Заходим в sh-консоль контейнера `php` из под пользователя `bitrix`:
```bash
docker compose exec --user=bitrix php sh
```

Переходим в корневой каталог сайта и скачиваем скрипт(ы):
```bash
cd /opt/www/
wget https://www.1c-bitrix.ru/download/scripts/bitrixsetup.php
wget https://www.1c-bitrix.ru/download/scripts/restore.php
```

В браузере переходим по ссылке вида:
- для установки:
```bash
http://10.0.1.119:8588/bitrixsetup.php
```

- для восстановления:
```bash
http://10.0.1.119:8588/restore.php
```

Устанавливаем продукт или восстанавливаем сайт, зависит от вашего выбора.

<a id="installdistro"></a>
## Установка дистрибутивов

Используем скрипт `bitrixsetup.php`, скачиваем дистрибутив Битрикс, будь это демо версия или лицензионная версия.

Редакция и тип базы зависит от вашего выбора.

После переходим на сайт используя урл:
```bash
http://10.0.1.119:8588/
```

Проходим мастер установки дистрибутива:
- `1С-Битрикс: Управление сайтом` - https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=135&CHAPTER_ID=04522&LESSON_PATH=10495.4495.4522
- `1С-Битрикс24` - https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=135&CHAPTER_ID=04522&LESSON_PATH=10495.4495.4522

На шаге создания базы вводим параметры подключения к ней:

- для `mysql` версии:
  - Имя хоста (алиас) - `mysql`
  - Имя суперпользователя - `root`
  - Пароль суперпользователя - был создан вами в главе `Пароли к базам данных mysql и postgresql`, хранится в файле `.env_sql`

- для `postgresql` версии:
  - Имя хоста (алиас) - `postgres`
  - Имя суперпользователя - `postgres`
  - Пароль суперпользователя - был создан вами в главе `Пароли к базам данных mysql и postgresql`, хранится в файле `.env_sql`

<a id="restorebackup"></a>
## Восстановление из резервной копии

Используем скрипт `restore.php`, восстанавливаем сайт из резервной копии.

Если архив сайта был размещен на сайте (в облаке) клиента, то необходимо выбрать вариант `Скачать резервную копию с другого сайта` и указать путь к архиву.

Если архив сайта был размещен в облаке 1С-Битрикс, то необходимо выбрать вариант `Развернуть резервную копию из облака "1С-Битрикс"` и указать активный лицензионный ключ.

Так же архив сайта можно `Загрузить с локального диска`, выбрав нужные файлы.

Если `Архив загружен в корневую папку сервера` то появится пункт, который позволит распаковать файлы в корень сайта соответственно.

После скачивания архива и завершения распаковки файлов необходимо будет указать настройки соединения с базой данных, если при создании резервной копии был создан дамп базы данных.

Нажимаем кнопку `Восстановить` и ждем завершения работы сценария.

После успешного восстановления нажимаем кнопку `Удалить локальную копию и служебные скрипты`.

<a id="licenceandupdates"></a>
# Лицензия, обновления платформы и решений

Перед дальнейшим использованием продуктов Битрикс рекомендуется обновить их до последних версий.

Для этого вам понадобится лицензионный ключ для продукта выбранной вами редакции.

Дальше нужно зайти в настройки `Главный модуль (main)` (`/bitrix/admin/settings.php?lang=ru&mid=main`), на табе `Система обновлений` заполнить поле `Лицензионный ключ`.

Перейти на страницу `Обновление платформы` (`/bitrix/admin/update_system.php?lang=ru`), обновить систему обновлений и принять новые лицензионные соглашения (если это потребуется) и установить все доступные обновления.

Так же рекомендуется перейти на страницу `Обновление решений` (`/bitrix/admin/update_system_partner.php?lang=ru`) и установить обновления сторонних решений.

<a id="modulessettings"></a>
# Настройки модулей

После установки дистрибутива или восстановления сайта из бекапа необходимо настроить модули Битрикс этого сайта.

Настроим `Главный модуль (main)` (`/bitrix/admin/settings.php?lang=ru&mid=main`):

- на табе `Настройки`:
  - указываем `Название сайта`
  - задаем `URL сайта (без http://, например www.mysite.com)` -  10.0.1.119:8588 или 10.0.1.119:8589, dev.bx:8588 или dev.bx:8589 и т.д.
  - отмечаем опцию `Быстрая отдача файлов через Nginx` - она сконфигурирована

- на табе `Авторизация`
  - снимаем отметку у опции `Продлевать сессию при активности посетителя в окне браузера`

- на табе `Журнал событий`
  - отмечаем опции записи событий в журнал событий (на выбор из множества опций)

- на табе Система обновлений
  - заполняем поле `Лицензионный ключ`
  - заполняем поле `Имя сервера, содержащего обновления`

Сохраняем настройки.

Для остальных модулей производим настройки, если они нужны.

По описанию значений полей смотрите документацию модуля.

<a id="sitechecker"></a>
# Проверка системы

Для всесторонней проверки соответствия параметров системы, на которой осуществляется функционирование сайта, минимальным и рекомендуемым техническим требованиям продукта используйте страницу `Проверка системы` (`/bitrix/admin/site_checker.php?lang=ru`).

Документация:
- https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=35&LESSON_ID=14020&LESSON_PATH=3906.4493.4506.2024.14020
- https://dev.1c-bitrix.ru/user_help/settings/utilities/site_checker.php

<a id="perfmonpanel"></a>
# Тест производительности

Для оценки производительности перейдите на страницу `Панель производительности` (`/bitrix/admin/perfmon_panel.php?lang=ru`).

Выполните тест конфигурации. Результаты подскажут "узкие" места системы или её конфигурации.

Документация: https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=35&CHAPTER_ID=03376&LESSON_PATH=3906.6663.4904.3376

<a id="cron"></a>
# Cron

<a id="agentsoncron"></a>
## Выполнение агентов на cron

Для работы cron заданий используется отдельный контейнер `cron` на базе образа `bx-php`.

По умолчанию контейнер сконфигурирован на выполнение заданий модуля `Главный модуль (main)` раз в минуту, запуская это исполнение от пользователя `bitrix`:
```bash
php -f /opt/www/bitrix/modules/main/tools/cron_events.php
```

Это задание будет выполнятся только если дистрибутив установлен.

Для включения выполнения агентов на кроне нужно в административной части продукта на странице `Управление структурой` (`/bitrix/admin/fileman_admin.php?lang=ru&path=%2F`) отредактировать файл `/bitrix/php_interface/dbconn.php`, добавить строку:
```bash
define('BX_CRONTAB_SUPPORT', true);
```

И сохранить.

Проверить настройку можно на странице `Проверка системы` (`/bitrix/admin/site_checker.php?lang=ru`) и на странице `Список агентов` (`/bitrix/admin/agent_list.php?lang=ru`).

<a id="owncrontasks"></a>
## Кастомные cron задания

Cron задания хранятся в папке `/etc/periodic/` контейнера `cron`.

Внутри каталога размещены подкаталоги, указывающие на периодичность запуска заданий:
```bash
1min
15min
hourly
daily
weekly
monthly
```

Для примера создадим задание, которое выполняется раз в сутки - создание резервной копии сайта с базой MySQL - бекап.

Заходим в sh-консоль контейнера `cron` из под пользователя `root`:
```bash
docker compose exec --user=root cron sh
```

В каталоге `/etc/periodic/daily/` создадим файл `backup` без указания расширения файла.
```bash
apk add mc
mcedit /etc/periodic/daily/backup
```

Заполним содержимое файла:
```bash
#!/bin/sh
#
su - bitrix -c 'php -f /opt/www/bitrix/modules/main/tools/backup.php; > /dev/null 2>&1'
#
```

Сохраняем файл.
Делаем его исполняемым:
```bash
chmod -R a+x /etc/periodic/daily
```

Создаем файл `/etc/crontabs/cron.update`, чтобы `crond` демон перезапустил задания крона:
```bash
touch /etc/crontabs/cron.update
```

Итог: раз в день (в 2ч ночи) контейнер запустит `backup` задание и выполнит резервное копирование.

Детали создания резервной копии будут доступны в логе контейнера `cron`. Пример:
```
crond: USER root pid 122 cmd run-parts /etc/periodic/15min
0.19 sec	Backup started to file: /opt/www/bitrix/backup/20250423_113000_full_vnw0wuf76rq6e5je.tar
0.19 sec	Dumping database
14.18 sec	Archiving database dump
14.2 sec	Archiving files
167.01 sec	Finished.
Data size: 2569.42 M
Archive size: 2569.42 M
Time: 166.76 sec
```

Документация: https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=35&LESSON_ID=4464&LESSON_PATH=3906.4833.4464

<a id="bxtemporaryfilesdirectory"></a>
# Хранение временных файлов вне корневой директории сайта

По умолчанию, конфигурация `nginx` предварительно подготовлена таким образом, чтобы временные файлы хранились вне пределов корневой директории сайта, т.к. это существенно повышает защищенность от известных атак.

Для завершения настройки и усиления безопасности, необходимо в административной части продукта на странице `Управление структурой` (`/bitrix/admin/fileman_admin.php?lang=ru&path=%2F`) отредактировать файл `/bitrix/php_interface/dbconn.php`, добавить строку:
```bash
define("BX_TEMPORARY_FILES_DIRECTORY", "/opt/.bx_temp");
```

Cохранить.

Проверить настройку можно на странице `Сканер безопасности` (`/bitrix/admin/security_scanner.php?lang=ru`) модуля `Проактивной защиты (security)`.

<a id="pushpull"></a>
# Push & pull

<a id="pushserver"></a>
## Push сервер

Для работы push сервера будет запущено два контейнера: один для режима `pub`, второй для режима `sub`. Оба используют один образ `bx-push`.

Параметры переменных сред контейнеров хранятся в файлах `.env_push_pub` и `.env_push_sub`.

Cекретный ключ для подписи соединения между клиентом и push-сервером хранится в файле `.env_push` и был создан вами в главе `Секретный ключ для push сервера`.

Возвращаемся к главам `Адресация` и `Порты` этого документа. Определяемся по какой схеме работает сайт. Например:
- используется локальный IP вида `10.0.1.119`
- порт для http `8588`
- порт для https `8589`

Итого получается:
- для http: `10.0.1.119:8588`
- для https: `10.0.1.119:8589`

Запоминаем эти значения.

В административной части продукта на странице `Управление структурой` (`/bitrix/admin/fileman_admin.php?lang=ru&path=%2F`) редактируем файл `/bitrix/.settings.php`:
- добавляем блок настроек push сервера
- меняем значения опции `signature_key`, указываем ваш сгенерированный уникальный секретный ключ вместо шаблона `CHANGE_SECURITY_KEY_HERE`
- меняем значения для `http` и `https` на ваши
- пример:
```bash
  'pull' => array(
    'value' => array(
      'path_to_listener' => 'http://10.0.1.119:8588/bitrix/sub/',
      'path_to_listener_secure' => 'https://10.0.1.119:8589/bitrix/sub/',
      'path_to_modern_listener' => 'http://10.0.1.119:8588/bitrix/sub/',
      'path_to_modern_listener_secure' => 'https://10.0.1.119:8589/bitrix/sub/',
      'path_to_mobile_listener' => 'http://#DOMAIN#:8893/bitrix/sub/',
      'path_to_mobile_listener_secure' => 'https://#DOMAIN#:8894/bitrix/sub/',
      'path_to_websocket' => 'ws://10.0.1.119:8588/bitrix/subws/',
      'path_to_websocket_secure' => 'wss://10.0.1.119:8589/bitrix/subws/',
      'path_to_publish' => 'http://10.0.1.119:8588/bitrix/pub/',
      'path_to_publish_web' => 'http://10.0.1.119:8588/bitrix/rest/',
      'path_to_publish_web_secure' => 'https://10.0.1.119:8589/bitrix/rest/',
      'path_to_json_rpc' => 'http://10.0.1.119:8588/bitrix/api/',
      'nginx_version' => '4',
      'nginx_command_per_hit' => '100',
      'nginx' => 'Y',
      'nginx_headers' => 'N',
      'push' => 'Y',
      'websocket' => 'Y',
      'signature_key' => 'CHANGE_SECURITY_KEY_HERE',
      'signature_algo' => 'sha1',
      'guest' => 'N',
    ),
  ),
```

Сохраняем файл.

Для продукта Битрикс24 проверить настройку push сервера можно на странице `Проверка системы` (`/bitrix/admin/site_checker.php?lang=ru`), используя таб `Работа портала`.

<a id="sphinx"></a>
# Sphinx

<a id="sphinxsearch"></a>
## Поиск с помощью Sphinx

Для работы полнотекстового поиска, используя `Sphinx`, будет запущен один контейнер на базе образа `bx-sphinx`.

Для запуска и настройки:
- переходим в настройки модуля `Поиск` (`/bitrix/admin/settings.php?lang=ru&mid=search`)
- на табе `Морфология`:
  - выбираем `Полнотекстовый поиск с помощью` - `Sphinx`
  - заполняем строку `Строка подключения для управления индексом (протокол MySql)` - `sphinx:9306`
  - поле `Идентификатор индекса` не меняем - `bitrix`

Сохраняем настройки модуля.

На странице `Переиндексация сайта` (`/bitrix/admin/search_reindex.php?lang=ru`) снимаем галку `Переиндексировать только измененные` и выполняем полную переиндексацию сайта.

Настройка завершена.

Для продукта Битрикс24 проверить работу можно в разделе `/search/` сайта.

Документация: https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=35&CHAPTER_ID=04507&LESSON_PATH=3906.4507

> [!IMPORTANT]
> Для продуктов, использующих базу данных PostgreSQL, нужно обновление модуля `search` версии `25.0.0` и выше.

<a id="email"></a>
# Почта

<a id="msmtpmta"></a>
## Отправка почты с помощью msmtp

Образ `bx-php` в своем составе содержит mta `msmtp`, предназначенный для отправки писем.

Настройки msmtp для аккаунта `default` хранятся в файле `/opt/msmtp/.msmtprc`.

Значения настроек msmtp зависят от smtp сервера, с которым он будет взаимодействовать при работе.

Например, локальный почтовый сервер, отвечает на порту `25`, расположен на хосте `mail.server.local`, не использует в своей работе `tls` - в файле `/opt/msmtp/.msmtprc` настройки будут выглядеть:
```bash
...
host mail.server.local
port 25
from info@mail.server.local
user info@mail.server.local
password password_example
...
tls off
tls_starttls off
tls_certcheck off
...
```

Другой пример, почтовые сервисы вида `gmail`, `yahoo`, `yandex`, `rambler` и т.д.

Настройки почтовых сервисов приведены в курсе: https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=37&LESSON_ID=12265

Для `gmail`, который отвечает на порту `587`, расположен на хосте `smtp.gmail.com`, использует в своей работе `tls` - в файле `/opt/msmtp/.msmtprc` полный список настроек выглядит так:

```bash
# smtp account configuration for default
account default
logfile /proc/self/fd/2
host smtp.gmail.com
port 587
from [LOGIN]@gmail.com
user [LOGIN]@gmail.com
password [APP_PASSWORD]
auth login
aliases /etc/aliases
keepbcc off
tls on
tls_starttls on
tls_certcheck on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
protocol smtp
```

Настроим отправку писем через `gmail`.

В блоке настроек выше меняем `APP_PASSWORD` на пароль приложения, `LOGIN` на ваш логин в почте Google.

Заходим в sh-консоль контейнера `php` из под пользователя `root`:
```bash
docker compose exec --user=root php sh
```

Устанавливаем `mc` и выходим:
```bash
apk add mc
exit
```

Заходим в sh-консоль контейнера `php` из под пользователя `bitrix`:
```bash
docker compose exec --user=bitrix php sh
```

Редактируем файл `/opt/msmtp/.msmtprc`, указываем приготовленный блок настроек:
```bash
mcedit /opt/msmtp/.msmtprc
```

Сохраняем файл и выходим из контейнера `php`.

После в административной части продукта необходимо настроить модули, указав email отправителя (или От кого):
- `Главный модуль (main)` (`bitrix/admin/settings.php?lang=ru&mid=main`)
- `Email-маркетинг (sender)` (`/bitrix/admin/settings.php?lang=ru&mid=sender`)
- `Интернет-магазин (sale)` (`/bitrix/admin/settings.php?lang=ru&mid=sale`)
- `Подписка, рассылки (subscribe)` (`/bitrix/admin/settings.php?lang=ru&mid=subscribe`)
- `Форум (forum)` (`/bitrix/admin/settings.php?lang=ru&mid=forum`)

Проверить отправку почты можно на странице `Проверка системы` (`/bitrix/admin/site_checker.php?lang=ru`), запустив `Тестирование конфигурации`.

Результаты будут отображены в блоке отчета `Дополнительные функции`:
```
Отправка почты - Отправлено. Время отправки: 1.36 сек.
Отправка почтового сообщения больше 64Кб - Отправлено. Время отправки: 1.55 сек.
```

Детали отправки (или возникающие ошибки) будут доступны в логе контейнера `php`. Пример для двух писем из тестирования конфигурации:
```
Apr 12 22:52:14 host=smtp.gmail.com tls=on auth=on user=***@gmail.com from=***@gmail.com recipients=hosting_test@bitrixsoft.com mailsize=211 smtpstatus=250 smtpmsg='250 2.0.0 OK  1744498333 2adb3069b0e04-54d3d502717sm712937e87.144 - gsmtp' exitcode=EX_OK
Apr 12 22:52:15 host=smtp.gmail.com tls=on auth=on user=***@gmail.com from=***@gmail.com recipients=hosting_test@bitrixsoft.com,noreply@bitrixsoft.com mailsize=200205 smtpstatus=250 smtpmsg='250 2.0.0 OK  1744498335 2adb3069b0e04-54d3d502618sm743850e87.107 - gsmtp' exitcode=EX_OK
```

<a id="emailsmtpmailer"></a>
## Отправка почты через SMTP-сервера отправителя

Для отправки почты используем возможности `Главного модуля (main)` без каких либо дополнительных контейнеров и т.д.

Активируем возможность использования SMTP-сервера отправителя: https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=43&LESSON_ID=23612&LESSON_PATH=3913.3516.5062.2795.23612

Для этого в административной части продукта на странице `Управление структурой` (`/bitrix/admin/fileman_admin.php?lang=ru&path=%2F`) редактируем файл `/bitrix/.settings.php`, добавляем блок настроек:
```bash
    'smtp' => [
        'value' => [
            'enabled' => true,
            'debug' => true,
            'log_file' => $_SERVER["DOCUMENT_ROOT"]."/bitrix/modules/smtp_mailer.log",
        ],
        'readonly' => false,
    ],
```

После переходим на страницу `Добавление SMTP подключения` (`/bitrix/admin/smtp_edit.php?lang=ru`).

Заполняем поля на странице, указываем параметры smtp и сохраняем настройки.

После необходимо настроить модули, указав email отправителя (или От кого):
- `Главный модуль (main)` (`bitrix/admin/settings.php?lang=ru&mid=main`)
- `Email-маркетинг (sender)` (`/bitrix/admin/settings.php?lang=ru&mid=sender`)
- `Интернет-магазин (sale)` (`/bitrix/admin/settings.php?lang=ru&mid=sale`)
- `Подписка, рассылки (subscribe)` (`/bitrix/admin/settings.php?lang=ru&mid=subscribe`)
- `Форум (forum)` (`/bitrix/admin/settings.php?lang=ru&mid=forum`)

Настройки почтовых сервисов: https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=37&LESSON_ID=12265

Проверить настройки можно отправив письмо самому себе. Для этого нужно отредактировать параметры пользователя, указав `E-Mail` и отметим опцию `Оповестить пользователя`.

Лог отправки будет в файле `/bitrix/modules/smtp_mailer.log`.

> [!NOTE]
> Проверка системы при тестировании параметров не использует SMTP-сервера отправителя. Два теста почты будут красными. Можно это проигнорировать.

<a id="emaildebuglog"></a>
## Логирование отправки почты в файл

Если почта не ходит, можно залогировать ход отправки в файл.

Для этого в административной части продукта на странице `Управление структурой` (`/bitrix/admin/fileman_admin.php?lang=ru&path=%2F`) редактируем файл `/bitrix/php_interface/dbconn.php`, добавляем строку:
```bash
define('LOG_FILENAME', $_SERVER["DOCUMENT_ROOT"]."/bitrix/modules/mail_log.txt");
```

Создаем файл `/bitrix/php_interface/init.php` если его нет, добавляем код функции `custom_mail`:
```bash
function custom_mail($to, $subject, $message, $additional_headers='', $additional_parameters='')
{
    AddMessage2Log(
        'To: '.$to.PHP_EOL.
        'Subject: '.$subject.PHP_EOL.
        'Message: '.$message.PHP_EOL.
        'Headers: '.$additional_headers.PHP_EOL.
        'Params: '.$additional_parameters.PHP_EOL
    );
    if ($additional_parameters!='')
    {
        return @mail($to, $subject, $message, $additional_headers, $additional_parameters);
    }
    else
    {
        return @mail($to, $subject, $message, $additional_headers);
    }
}
```

Лог отправки будет в файле `/bitrix/modules/mail_log.txt`.

Документация: https://dev.1c-bitrix.ru/api_help/main/functions/other/bxmail.php

<a id="php"></a>
# PHP

<a id="phpcomposer"></a>
## PHP Composer

В контейнере с `php` по умолчанию доступен [PHP Composer](https://getcomposer.org/).

Чтобы его использовать, заходим в sh-консоль контейнера `php` из под пользователя `bitrix`:
```bash
docker compose exec --user=bitrix php sh
```

Проверяем его версию командой:
```bash
composer --version
```

Устанавливаем зависимости:
```bash
cd /opt/www/bitrix/
COMPOSER=composer-bx.json composer install
```

После запусаем Bitrix CLI:
```bash
php bitrix.php -h
```

Полный набор команд и параметров доступен в документции: https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=43&LESSON_ID=11685&LESSON_PATH=3913.3516.4776.2483.11685

<a id="phpbrowsercapabilities"></a>
## PHP Browser Capabilities

Возможно пригодится настроить если нужна `История входов`: https://helpdesk.bitrix24.ru/open/16615982/

Заходим в sh-консоль контейнера `php` из под пользователя `root`:
```bash
docker compose exec --user=root php sh
```

Устанавливаем `curl`, подключаем ini файл в настройках php, выходим:
```bash
apk add curl
echo 'browscap = /opt/browscap/php_browscap.ini' > /usr/local/etc/php/conf.d/browscap.ini
exit
```

Заходим в sh-консоль контейнера `php` из под пользователя `bitrix`:
```bash
docker compose exec --user=bitrix php sh
```

В каталог `/opt/browscap` загрузим `browscap.ini`. Выполняем:
```bash
cd /opt/browscap
curl http://browscap.org/stream?q=PHP_BrowsCapINI -o php_browscap.ini
exit
```

Перезапускаем контейнеры `php` и `cron`:
```bash
docker compose restart php cron
```

На странице настроек `Главного модуля (main)` (`/bitrix/admin/settings.php?lang=ru&mid=main`) на табе `Журнал событий`:
- отмечаем опцию - `Сохранять историю входов с устройств пользователя` - `Да`
- запоняем поле - `Сколько дней хранить историю входов` - `365`

Сохраняем настройки.

<a id="phpgeoip2"></a>
## PHP GeoIP2

Возможно пригодится настроить если нужно отслеживать геопозицию устройства для `Истории входов`: https://helpdesk.bitrix24.ru/open/16615982/

Заходим в sh-консоль контейнера `php` из под пользователя `bitrix`:
```bash
docker compose exec --user=bitrix php sh
```

Переходим в каталог `/opt/geoip2`:
```bash
cd /opt/geoip2
```

Размещаем в нем файлы в формате mmdb, список:
```bash
GeoLite2-ASN.mmdb
GeoLite2-City.mmdb
GeoLite2-Country.mmdb
```

На странице `Список обработчиков геолокации` (`/bitrix/admin/geoip_handlers_list.php?lang=ru`) редактируем обработчик `GeoIP2` (`/bitrix/admin/geoip_handler_edit.php?lang=ru&ID=1&CLASS_NAME=%5CBitrix%5CMain%5CService%5CGeoIp%5CGeoIP2`).

На табе `Дополнительные`:
- выбираем - `Тип базы данных` - `GeoIP2/GeoLite2 City`
- заполняем - `Абсолютный путь к файлу базы данных (*.mmdb)` - `/opt/geoip2/GeoLite2-City.mmdb`

или

- выбираем - `Тип базы данных` - `GeoIP2/GeoLite2 Country`
- заполняем - `Абсолютный путь к файлу базы данных (*.mmdb)` - `/opt/geoip2/GeoLite2-Country.mmdb`

Сохраняем настройки.

На странице настроек `Главного модуля (main)` (`/bitrix/admin/settings.php?lang=ru&mid=main`) на табе `Журнал событий`:
- отмечаем опцию - `Собирать IP-геоданные для истории входов` - `Да`

Сохраняем настройки.

<a id="phpextensions"></a>
## PHP расширения (extensions)

Образ `bx-php` в своем составе содержит следующие php расширения (extensions):
```bash
amqp
apcu
bz2
calendar
exif
gd
gettext
igbinary
imagick
intl
ldap
mcrypt
memcache
memcached
msgpack
mysqli
opcache
pdo_mysql
pdo_pgsql
pgsql
pspell
redis
shmop
sockets
sodium
ssh2
sysvmsg
sysvsem
sysvshm
xdebug
xhprof
xml
xmlwriter
xsl
zip
```

Большинство из них активны по умолчанию.

Чтобы активировать php расширение:

- заходим в sh-консоль контейнера `php` из под пользователя `root`:
```bash
docker compose exec --user=root php sh
```

- находим файл `/usr/local/etc/php/conf.d/docker-php-ext-***.ini`, где `***` название расширения, пример для `imagick`:
```bash
apk add mc
mcedit /usr/local/etc/php/conf.d/docker-php-ext-imagick.ini
```

- внутри файла меняем строку активируем подключение: `extension=***.so`, где `***` название расширения:
```bash
extension=imagick.so
```

- сохраняем изменения и выходим

- перезапускаем контейнеры `php` и `cron`:
```bash
docker compose restart php cron
```

Чтобы  деактивировать php расширение:

- заходим в sh-консоль контейнера `php` из под пользователя `root`:
```bash
docker compose exec --user=root php sh
```

- находим файл `/usr/local/etc/php/conf.d/docker-php-ext-***.ini`, где `***` название расширения, пример для `imagick`:
```bash
apk add mc
mcedit /usr/local/etc/php/conf.d/docker-php-ext-imagick.ini
```

- внутри файла меняем строку деактивируем подключение: `; extension=***.so`, где `***` название расширения:
```bash
; extension=imagick.so
```

- сохраняем изменения и выходим
- перезапускаем контейнеры `php` и `cron`:
```bash
docker compose restart php cron
```

<a id="phpimagickimageengine"></a>
## PHP Imagick Engine для изображений

Чтобы работать с изображениями с помощью PHP расширения `Imagick` (а не `GD`) активируем библиотеку для работы с изображениями на базе `ImagickImageEngine`.

Убедимся что в файле `/usr/local/etc/php/conf.d/docker-php-ext-imagick.ini` активировано подключение расширения `imagick`. Как это сделать описано в главе `PHP расширения (extensions)`.

Заходим в sh-консоль контейнера `php` из под пользователя `bitrix`:
```bash
docker compose exec --user=bitrix php sh
```

Выполняем команду:
```bash
\cp /usr/local/etc/image.png /opt/www/bitrix/images/
```

В административной части продукта:
- на странице `Управление структурой` (`/bitrix/admin/fileman_admin.php?lang=ru&path=%2F`) редактируем файл `/bitrix/.settings.php`
- добавляем блок настроек:
```bash
        'services' => [
                'value' => [
                        'main.imageEngine' => [
                                'className' => '\Bitrix\Main\File\Image\Imagick',
                                'constructorParams' => [
                                        null,
                                        [
                                                'allowAnimatedImages' => true,
                                                'maxSize' => [
                                                        7000,
                                                        7000
                                                ],
                                                'jpegLoadSize' => [
                                                        2000,
                                                        2000
                                                ],
                                                'substImage' => $_SERVER['DOCUMENT_ROOT'].'/bitrix/images/image.png',
                                        ]
                                ],
                        ],
                ],
                'readonly' => true,
        ],
```

Сохраняем файл.

Для выключения в административной части продукта на странице `Управление структурой` (`/bitrix/admin/fileman_admin.php?lang=ru&path=%2F`) отредактируем файл `/bitrix/.settings.php` и уберем блок настроек выше.

<a id="phpsecurityantivirus"></a>
## PHP веб-антивирус

Веб-антивирус включен в состав модуля `Проактивная защита (security)`, с помощью которого реализуется целый комплекс защитных мероприятий для сайта и сторонних приложений.

Для детектирования вирусов, внедренных до старта буферизации вывода, добавим в контейнер `php` файл `/usr/local/etc/php/conf.d/security.ini`.

Заходим в sh-консоль контейнера `php` из под пользователя `root`:
```bash
docker compose exec --user=root php sh
```

Выполняем команду:
```bash
echo "auto_prepend_file = /opt/www/bitrix/modules/security/tools/start.php" > /usr/local/etc/php/conf.d/security.ini
```

Перезапускаем контейнеры `php` и `cron`:
```bash
docker compose restart php cron
```

На странице `Веб-антивирус` (`/bitrix/admin/security_antivirus.php?lang=ru`) включаем его, нажимаем кнопку `Включить веб-антивирус`.

Для выключения обратный порядок действий.

На странице `Веб-антивирус` (`/bitrix/admin/security_antivirus.php?lang=ru`) выключаем его, нажимаем кнопку `Выключить веб-антивирус`.

Заходим в sh-консоль контейнера `php` из под пользователя `root`:
```bash
docker compose exec --user=root php sh
```

Выполняем команду:
```bash
rm -f /usr/local/etc/php/conf.d/security.ini
```

Перезапускаем контейнеры `php` и `cron`:
```bash
docker compose restart php cron
```

Документация:
https://dev.1c-bitrix.ru/user_help/settings/security/security_antivirus.php
https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=35&LESSON_ID=2674#antivirus

<a id="memcacheandredis"></a>
# Memcache и Redis

<a id="memcache"></a>
## Memcache

Контейнер `memcached` может быть использован для хранения кеша и для хранения данных сессий.

<a id="redis"></a>
## Redis

Контейнер `redis` используется в связке с `push` сервером.

Так же может быть использован для хранения кеша и для хранения данных сессий.

<a id="cachestorage"></a>
## Кеширование

Ядро поддерживает несколько вариантов для хранения кеша: `файлы`, `redis`, `memcache` и т.д.

В административной части продукта на странице `Управление структурой` (`/bitrix/admin/fileman_admin.php?lang=ru&path=%2F`) отредактируем файл `/bitrix/.settings.php`, добавляем блок настроек, который определит вариант хранения:

- `memcache`:
```bash
        'cache' => [
                'value' => [
                        'type' => [
                                'class_name' => '\\Bitrix\\Main\\Data\\CacheEngineMemcache',
                                'extension' => 'memcache'
                        ],
                        'memcache' => [
                                'host' => 'memcached',
                                'port' => '11211',
                        ]
                ],
                'sid' => $_SERVER["DOCUMENT_ROOT"]."#01234"
        ],
```

- `redis`:
```bash
        'cache' => [
                'value' => [
                        'type' => [
                                'class_name' => '\\Bitrix\\Main\\Data\\CacheEngineRedis',
                                'extension' => 'redis'
                        ],
                        'redis' => [
                                'host' => 'redis',
                                'port' => '6379',
                        ]
                ],
                'sid' => $_SERVER["DOCUMENT_ROOT"]."#01234"
        ],
```

Документация: https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=43&CHAPTER_ID=02795&LESSON_PATH=3913.3516.5062.2795#cache

<a id="sessionstorage"></a>
## Хранение сессий

Ядро поддерживает четыре варианта для хранения данных сессии: `файлы`, `database`, `redis`, `memcache`.

В административной части продукта на странице `Управление структурой` (`/bitrix/admin/fileman_admin.php?lang=ru&path=%2F`) отредактируем файл `/bitrix/.settings.php`, добавляем блок настроек, который определит вариант хранения:

- `memcache`, разделённая сессия:
```bash
        // memcache separated
        'session' => [
                'value' => [
                        'lifetime' => 14400,
                        'mode' => 'separated',
                        'handlers' => [
                                'kernel' => 'encrypted_cookies',
                                'general' => [
                                        'type' => 'memcache',
                                        'port' => '11211',
                                        'host' => 'memcached',
                                ],
                        ],
                ],
        ],
```

- `redis`:
```bash
        // redis
        'session' => [
                'value' => [
                        'mode' => 'default',
                        'handlers' => [
                                'general' => [
                                        'type' => 'redis',
                                        'port' => '6379',
                                        'host' => 'redis',
                                ],
                        ],
                ],
        ],
```

- `database`:
```bash
        // database
        'session' => [
                'value' => [
                        'mode' => 'default',
                        'handlers' => [
                                'general' => [
                                        'type' => 'database',
                                ],
                        ],
                ],
        ],
```

Сохраняем файл.

Все возможные варианты доступны в документации: https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=43&LESSON_ID=14026

<a id="clustercachestorage"></a>
## Кеширование с помощью модуля Веб-кластер

Альтернативный способ использования кеширования для продуктов `1С-Битрикс: Управление сайтом` и `1С-Битрикс24` при условии, что в редакции есть модуль `Веб-кластер` (`cluster`).

<a id="clustercachememcache"></a>
### Memcache

В административной части продукта на странице настроек модуля `Веб-кластер` (`/bitrix/admin/settings.php?lang=ru&mid=cluster`) выбираем `Использовать для хранения кеша` - `Memcache`.

Сохраняем настройки.

В административной части продукта на странице `Подключения к memcached` (`/bitrix/admin/cluster_memcache_list.php?lang=ru&group_id=1`) добавляем новое подключение и указываем:
- `Сервер` - `memcached`
- `Порт` - `11211`
- `Процент распределения нагрузки (0..100)` - `100`

Сохраняем подключение. В списке подключений для созданного нажимаем `Начать использовать`.

Процесс отключения и удаления обратный добавлению.

<a id="clustercacheredis"></a>
### Redis

В административной части продукта на странице настроек модуля `Веб-кластер` (`/bitrix/admin/settings.php?lang=ru&mid=cluster`) выбираем `Использовать для хранения кеша` - `Redis`.

Сохраняем настройки.

В административной части продукта на странице `Подключения к redis` (`/bitrix/admin/cluster_redis_list.php?lang=ru&group_id=1`) добавляем новое подключение и указываем:
- `Сервер` - `redis`
- `Порт` - `6379`

Сохраняем подключение. В списке подключений для созданного нажимаем `Начать использовать`.

Процесс отключения и удаления обратный добавлению.

<a id="httpsssltlswss"></a>
# HTTPS/SSL/TLS/WSS

<a id="selfsignedcerts"></a>
## Самоподписанный сертификат

Сгенерировать и использовать ssl сертификат в режиме самоподписи возможно с помощью отдельного контейнера `ssl` на базе образа `bx-ssl`.

Данные, отображаемые в сертификатах корневого и промежуточного центров сертификации, хранятся в файле `.env_ssl`. Строки настроек начинаются с `CA_`.

При необходимости отредактируйте файл `.env_ssl`, укажимте ваши данные по примеру:
- `Название страны`: введите двухбуквенный код вашей страны (пример, `RU`)
- `Название штата или провинции`: введите название штата, в котором официально зарегистрирована ваша организация (пример, `Kaliningrad Region`)
- `Название населенного пункта`: введите название населенного пункта или города, в котором находится ваша компания (пример, `Kaliningrad`)
- `Название организации`: укажите официальное название вашей организации (пример, `Dev Corporation Ltd`)
- `Имя организационного подразделения`: введите название подразделения в вашей организации, отвечающего за управление сертификатами (пример, `Dev Corporation Ltd Unit`)
- `Адрес электронной почты`: пример, `info@devcorporation.ltd`

Данные, отображаемые в сертификате для домена, так же хранятся в файле `.env_ssl`. Строки настроек начинаются с `CERT_`.

При необходимости отредактируйте файл `.env_ssl`, укажимте ваши данные по примеру:
- `Название страны`: введите двухбуквенный код вашей страны (пример, `RU`)
- `Название штата или провинции`: введите название штата, в котором официально зарегистрирована ваша организация (пример, `Kaliningrad Region`)
- `Название населенного пункта`: введите название населенного пункта или города, в котором находится ваша компания (пример, `Kaliningrad`)
- `Название организации`: укажите официальное название вашей организации (пример, `Dev Corporation Ltd`)
- `Имя организационного подразделения`: введите название подразделения в вашей организации, отвечающего за управление сертификатами (пример, `Dev Corporation Ltd Unit`)
- `Адрес электронной почты`: пример, `info@devcorporation.ltd`

> [!IMPORTANT]
> Если данные, отображаемые в сертификатах корневого и промежуточного центров сертификации, были изменены в файле `.env_ssl` необходимо пересоздать контейнер `ssl`.
>
> Для этого выполните последовательно команды остановки, удаления, пересоздания и запуска контейнера `ssl`:
> ```bash
> docker compose stop ssl
> docker compose rm -f ssl
> docker compose up -d
> ```

Одной командой разово генерируем сертификаты корневого и промежуточного центров сертификации:
```bash
docker compose exec --user=bitrix ssl bash -c "~/cas.sh"
```

Второй - сертификат и приватный ключ для домена `dev.bx`:
```bash
docker compose exec --user=bitrix ssl bash -c "~/srv.sh dev.bx"
```

Итого в папке `/ssl/` внутри контейнера `ssl` будет набор файлов:
- `rootCA.cert.pem` - сертификат корневого центра сертификации
- `intermediateCA.cert.pem` - сертификат промежуточного центра сертификации, подписанный корневым сертификатом
- `ca-chain.cert.pem` - цепочка сертификатов обоих центров сертификации
- `dev.bx.cert.pem` - сертификат домена, подписанный промежуточным центром сертификации
- `dev.bx.key.pem` - приватный ключ сертификата
- `dev.bx.chain.cert.pem` - цепочка сертификатов, содержит сертификат домена и сертификат промежуточного центра сертификации
- `dev.bx.fullchain.cert.pem` - полная цепочка всех сертификатов, содержит сертификат домена, сертификат промежуточного центра сертификации, сертификат корневого центра сертификации
- `dhparam.pem` - секретный криптографический ключ, созданный по алгоритму Диффи-Хеллмана для обмена сессионными ключами с клиентом

Файл `dhparam.pem` не создается, а поставляется для примера. Если нужно его сделать уникальным выполните команду:
```bash
docker compose exec --user=bitrix ssl bash -c "openssl dhparam -out /ssl/dhparam.pem 4096"
```

> [!IMPORTANT]
> Создание dhparam.pem файла может занять продолжительное время, которое зависит от вашего железа.

Сертификат корневого центра сертификации (`rootCA.cert.pem`) и сертификат промежуточного центра сертификации (`intermediateCA.cert.pem`) нужно добавить в траст контейнеров `nginx` и `php`.

Заходим в sh-консоль контейнера `php` из под пользователя `root`:
```bash
docker compose exec --user=root php sh
```

Выполняем:
```bash
mkdir -p /usr/local/share/ca-certificates/
ln -s /ssl/rootCA.cert.pem /usr/local/share/ca-certificates/rootCA.cert.pem
ln -s /ssl/intermediateCA.cert.pem /usr/local/share/ca-certificates/intermediateCA.cert.pem
update-ca-certificates
```

Если локальный домен не резолвится в вашей сети, нужно в файле `/etc/hosts` контейнера `php` добавить:
```bash
apk add mc
mcedit /etc/hosts
10.0.1.119 dev.bx
exit
```

Заходим в sh-консоль контейнера `nginx` из под пользователя `root`:
```bash
docker compose exec --user=root nginx sh
```

Выполняем:
```bash
mkdir -p /usr/local/share/ca-certificates/
ln -s /ssl/rootCA.cert.pem /usr/local/share/ca-certificates/rootCA.cert.pem
ln -s /ssl/intermediateCA.cert.pem /usr/local/share/ca-certificates/intermediateCA.cert.pem
update-ca-certificates
```

Так же нам нужно в ssl конфигурацию `nginx` прописать новые сертификаты. Редактируем файл `/etc/nginx/ssl/ssl.conf`, меняем настройки опций `ssl_*`:
```bash
apk add mc
mcedit /etc/nginx/ssl/ssl.conf
```

Меняем опции на:
```bash
ssl_certificate /ssl/dev.bx.fullchain.cert.pem;
ssl_certificate_key /ssl/dev.bx.key.pem;
ssl_trusted_certificate /ssl/ca-chain.cert.pem;
ssl_dhparam /ssl/dhparam.pem;
```

Так же скопируем файлы сертификата корневого центра сертификации (`rootCA.cert.pem`) и сертификата промежуточного центра сертификации (`intermediateCA.cert.pem`) в корень сайта:
```bash
cp /ssl/rootCA.cert.pem /opt/www/
cp /ssl/intermediateCA.cert.pem /opt/www/
chown bitrix:bitrix /opt/www/rootCA.cert.pem
chown bitrix:bitrix /opt/www/intermediateCA.cert.pem
exit
```

Проверям настройки `nginx`:
```bash
docker compose exec --user=bitrix nginx sh -c "nginx -t"
```

Если никаких ошибок нет, перезапускаем nginx:
```bash
docker compose restart nginx
```

На хосте, где будем использовать браузер, скачиваем файлы центров сертификации по ссылкам:
```bash
http://dev.bx:8588/rootCA.cert.pem
http://dev.bx:8588/intermediateCA.cert.pem
```

Добавляем их в траст ОС, на которой работает браузер.

Все ОС: `Windows`, `Linux`, `MacOS`

Общая часть для всех - браузер `Mozilla Firefox`. Имеет своё хранилище сертификатов центров сертификации. Работает одинаково вне зависимости от ОС.

Идем в `Настройки` -> `Приватность и защита` -> `Защита` -> `Сертификаты`.

Нажимаем кнопку `Просмотр сертификатов`, в окне переходим на таб `Центры сертификации`.

Нажимаем кнопку `Импортировать`:
- первый раз выбираем файл сертификата корневого центра сертификации (`rootCA.cert.pem`)
- второй раз выбираем файл сертификата промежуточного центра сертификации (`intermediateCA.cert.pem`)

ОС: `Windows`

Браузеры `Google Chrome` и `Microsoft Edge` (и другие на их базе) используют системное хранилище ОС для сертификатов центров сертификации.

Скачанные файлы переименовываем, меняем расширение с `pem` на `crt`:
- `rootCA.cert.pem` -> `rootCA.cert.crt`
- `intermediateCA.cert.pem` -> `intermediateCA.cert.crt`

Дважды кликаем на файле `rootCA.cert.crt`, откроект просмотр сертификата.

Нажимаем кнопку `Установить сертификат`.

Проходим мастер импорта. Выбираем `Поместить все сертификаты в следующие хранилища`, в окне выбираем `Доверенные корневые центры сертификации`.

ОС: `Linux`

ToDo

ОС: `MacOS`

ToDo

Итог: после настройки выше переходим на сайт по урлу с доменом `dev.bx`, используя `https` и порт `8589` в урле:
```bash
https://dev.bx:8589/
```

Устанавливаем дистрибутив, восстанавливаем бекап сайта - выбора за вами.

Выполняем подстройку сайта как указано выше в этом readme файле.

Страница `Проверка системы` (`/bitrix/admin/site_checker.php?lang=ru`) открывается по `https` и сама проверка проходит, испольхуя `ssl` коннект вида:
```bash
Connection to ssl://dev.bx:8589	Success
```

Push сервер использует "секурные" веб сокеты, коннект происходит по `wss`. Пуши ходят, интерактивность работает.

> [!IMPORTANT]
> При удалении сайта не забудьте удалить сертификат корневого центра сертификации (`rootCA.cert.pem`) и сертификат промежуточного центра сертификации (`intermediateCA.cert.pem`) из ОС и браузера.

Для браузера `Mozilla Firefox`процесс удаления обратный добавлению.

Для удаления сертификатов центров сертификации в ОС `Windows`:
- запустите оснастку сертификатов, выполнив команду `certmgr.msc`
- в ней перейдите `Сертификаты` - `Доверенные корневые центры сертификации` - `Сертификаты`
- найдите сертификаты центров сертификации
- сначала удалите сертификат промежуточного центра сертификации, затем сертификат корневого центра сертификации, выбрав их в списке по одному и в меню выбрав пункт `удалить`
- подтвердите удаление

<a id="presentcerts"></a>
## Бесплатный Lets Encrypt сертификат

ToDo

<a id="servicesconsole"></a>
# Консоль сервисов

<a id="containerconsole"></a>
## Контейнер

Для входа в консоль контейнера используется следующий шаблон команды:
```bash
docker compose exec [--user=[пользователь]] [сервис] [оболочка]
```

Где:
- `пользователь`: пользователь ОС внутри контейнера:
  - если пусто и ничего не указывать берется поведение по умолчанию
  - для пользователя `bitrix` шаблон команды принимает вид `--user=bitrix`
  - для пользователя `root` шаблон команды выглядит как `--user=root`
- `сервис`: имя сервиса, указанное в файле `docker-compose.yml`, пример `mysql`, `nginx`, `php` и т.д.
- `оболочка`: тип запускаемой оболочки внутри контейнера, пример `sh`, `bash`, `ash` и т.д.

В результате возможны варианты вида:

- заходим в bash-консоль контейнера `mysql`, пользователя не указываем:
```bash
docker compose exec mysql bash
```

- заходим в sh-консоль контейнера `php` из под пользователя `bitrix`:
```bash
docker compose exec --user=bitrix php sh
```

- заходим в sh-консоль контейнера `php` из под пользователя `root`:
```bash
docker compose exec --user=root php sh
```

Так же можно выполнять команды, указав параметр `-c` и саму команду, пример запроса `id`:
```bash
docker compose exec --user=root redis sh -c "id"
```

<a id="mysqlconsole"></a>
## MySQL

Заходим в bash-консоль контейнера `mysql`, выполняя команду входа в консоль `mysql` из под пользователя `root` базы данных:
```bash
docker compose exec mysql bash -c "mysql -u root -p"
```

Вводим пароль суперпользователя `root`, который был создан вами в главе `Пароли к базам данных mysql и postgresql`. Его значение хранится в файле `.env_sql`.

Выполняем sql запросы. Для выхода вводим `exit`.

<a id="postgresqlconsole"></a>
## PostgreSQL

Заходим в bash-консоль контейнера `postgres`, выполняя команду входа в консоль `psql` из под пользователя `postgres` базы данных:
```bash
docker compose exec --user=postgres postgres bash -c "psql"
```

Вводим пароль суперпользователя `postgres`, который был создан вами в главе `Пароли к базам данных mysql и postgresql`. Его значение хранится в файле `.env_sql`.

Выполняем sql запросы. Для выхода вводим `\q`.

<a id="memcacheconsole"></a>
## Memcache

Заходим в sh-консоль контейнера `memcached`, запуская консоль `nc`, указывая хост `127.0.0.1` и порт `11211`:
```bash
docker compose exec --user=root memcached sh -c "nc 127.0.0.1 11211"
```

Выполняем запросы (пример, `stats`). Для выхода вводим `exit`.

<a id="redisconsole"></a>
## Redis

Заходим в sh-консоль контейнера `redis`, запуская консоль `redis-cli`, указывая хост `127.0.0.1` и порт `6379`:
```bash
docker compose exec --user=root redis sh -c "redis-cli -h 127.0.0.1 -p 6379"
```

Выполняем запросы (пример, `ping` или `KEYS *`). Для выхода вводим `exit`.

<a id="customization"></a>
# Кастомизация

Конечно же, встает вопрос "как мне запустить свои разработки" рядом с проектом или внутри него.

Есть два пути, позволяюще это сделать:

- создать отдельный `docker-compose-my.yml` файл, разместить код внутри файла - описать тома, сервисы, сеть и т.д.

Тогда во всех командах компоуза указываем `.yml` файлы через опцию `-f`, пример:
```bash
docker compose -f docker-compose.yml -f docker-compose-my.yml ps
```

- интеграция в существующий `docker-compose.yml` файл проекта - добавить тома, сервисы, указать сеть и т.д.

Для примера, запустим [Valkey](https://hub.docker.com/r/valkey/valkey/), добавив его в проект в сущесвующий `yml` файл.

На странице valkey на DockerHub-е находим нужный нам тег, пример `7.2.8-alpine`.

Редактируем `docker-compose.yml` файл:

- в раздел `volumes` добавляем описание тома:
```bash
  valkey_data:
    driver: local
```

- в раздел `services` добавляем описание сервиса:
```bash
  valkey:
    image: valkey/valkey:7.2.8-alpine
    container_name: dev_valkey
    restart: unless-stopped
    command: valkey-server
    env_file:
      - .env
#    ports:
#      - "6379:6379"
    volumes:
      - valkey_data:/data
    networks:
      dev:
        aliases:
          - valkey
```

Запускаем контейнеры, оставляем их работать в фоне:
```bash
docker compose up -d
```

Заходим в sh-консоль контейнера `valkey`, запуская консоль `valkey-cli`, указывая хост `127.0.0.1` и порт `6379`:
```bash
docker compose exec --user=root valkey sh -c "valkey-cli -h 127.0.0.1 -p 6379"
```

Выполняем запросы (пример, `ping` или `KEYS *`). Выходим `exit`.

Итого: мы успешно запустили новый контейнер valkey, проверили его работу. Теперь его можно использовать для хранения кеша или хранения сессий по примеру как описано выше в этом файле.

------------------------------------------------

[1С-Битрикс: Разработчикам](https://dev.1c-bitrix.ru/)
