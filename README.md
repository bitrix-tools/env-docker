# dev сайт - контейнерное окружение для Битрикс

Проект представляет собой dev сайт, он же девелоперский сайт, предназначенный для тестирования, разработки, примера использования окружения на базе технологий [Docker](https://www.docker.com/).

Программы, необходимые для работы технологий Битрикс, запускаются в контейнерах (`Docker Containers`). По шаблону из образов (`Docker Images`). Данные хранят в томах (`Docker Volumes`). Связаны между собой посредством сети (`Docker Network`). И управляются (оркестируются) используя compose (`Docker Compose`).

> [!CAUTION]
> Внимание! dev сайт не предназначен для использования в продакшене. (___!!!ToDo_дополнить_и_расписать___)

# Содержимое

* [Docker и Docker Compose](#docker)
* [Сборка или скачивание Docker образов](#dockerimages)
  * [Базовые образы](#basicimages)
  * [Битрикс образы (bx-*)](#bitriximages)
* [Пароли к базам данных MySQL и PostgreSQL](#databasespasswords)
* [Секретный ключ для Push-сервера](#pushserversecretkey)
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
  * [Push-сервер](#pushserver)
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
    * [Выпуск сертификатов](#selfsigneddeploys)
    * [Доверие к сертификатам центров сертификации для PHP и Nginx](#selfsignedtrustforphpandnginx)
    * [Установка сертификатов](#installselfsignedcerts)
    * [Импорт сертификатов в ОС или браузер](#importselfsignedcertstoosorbrowser)
    * [Удаление сертификатов из ОС или браузера](#removeselfsignedcertsfromosorbrowser)
  * [Бесплатный Lets Encrypt сертификат](#presentcerts)
    * [Lego](#lego)
    * [Перенаправление или перенос домена](#domaintransfer)
    * [Челленджи](#letsencryptchallenges)
      * [HTTP челлендж (http-01)](#letsencrypthttpchallenge)
      * [DNS челлендж (dns-01)](#letsencryptdnschallenge)
    * [Команды lego](#legocommands)
      * [Команда для HTTP челленджа (http-01)](#legocommandhttpchallenge)
      * [Команда для DNS челленджа (dns-01)](#legocommanddnschallenge)
    * [Выпуск сертификатов](#legodeploys)
      * [HTTP челлендж (http-01) для одного домена (singledomain SSL-сертификат)](#httpchallengesingledomain)
      * [HTTP челлендж (http-01) для множества поддоменов домена (multidomain SSL-сертификат)](#httpchallengemultidomain)
      * [DNS челлендж (dns-01) для одного домена (singledomain SSL-сертификат)](#dnschallengesingledomain)
      * [DNS челлендж (dns-01) для множества поддоменов домена (multidomain SSL-сертификат)](#dnschallengemultidomain)
      * [DNS челлендж (dns-01) на все множество поддоменных имен домена (wildcard SSL-сертификат)](#dnschallengewildcard)
    * [Установка сертификатов](#installpresentcerts)
* [Консоль сервисов](#servicesconsole)
  * [Контейнер](#containerconsole)
  * [MySQL](#mysqlconsole)
  * [PostgreSQL](#postgresqlconsole)
  * [Memcache](#memcacheconsole)
  * [Redis](#redisconsole)
* [Кастомизация](#customization)

<a id="docker"></a>
# Docker и Docker Compose

Для запуска проекта понадобится `Docker`. Для оркестровки и управления `Docker Compose`.

Способ развертывания зависит от вашей операционной системы, используемой на хосте.

Возможны варианты:
- рабочая станция, персональный компьютер, ноутбук и т.д. с рабочим столом и графической средой, он же desktop
- сервер, без графической среды, но с консолью или удаленным доступом, он же server

Для взаимодействия с `Docker` в графическом режиме будем использовать продукт [Docker Desktop](https://docs.docker.com/desktop/), который возможно запустить на ОС `Windows`, `Linux`, `MacOS`.

Ознакомьтесь с документацией и разверните `Docker` в зависимости от используемой вами ОС:
- `Docker Desktop on Windows`: https://docs.docker.com/desktop/setup/install/windows-install/
- `Docker Desktop on Linux`: https://docs.docker.com/desktop/setup/install/linux/
- `Docker Desktop on Mac`: https://docs.docker.com/desktop/setup/install/mac-install/

Для взаимодействия с `Docker` в режиме командной строки (без графической среды) будем использовать продукт [Docker Engine](https://docs.docker.com/engine/), который возможно запустить на ОС `Linux`.

Ознакомьтесь с документацией и разверните `Docker Engine` в зависимости от используемой вами ОС `Linux`:
- `Docker Engine`: https://docs.docker.com/engine/install/

В современных версиях продуктов `Docker` обычно в их состав уже включен `Docker Compose`.

Ознакомьтесь с документацией и разверните `Docker Compose`, если это требуется отдельно:
- `Docker Compose`: https://docs.docker.com/compose/

<a id="dockerimages"></a>
# Сборка или скачивание Docker образов

Наша цель - подготовить или собрать максимально совместимые и готовые образы для продуктов компании 1С-Битрикс, запускающие набор ПО в контейнерах.

<a id="basicimages"></a>
## Базовые образы

Там где возможно будем использовать официальные Docker образы ПО, теги для которых будем брать с [DockerHub](https://hub.docker.com/):
- `PostgreSQL`: https://hub.docker.com/_/postgres
- `Redis`: https://hub.docker.com/_/redis
- `Memcached`: https://hub.docker.com/_/memcached

В этот список попадают (формат `название`:`полный_тег_с_указанием_версии_и_ос`):
- `postgres:16.9-bookworm`
- `redis:7.2.8-alpine`
- `memcached:1.6.38-alpine`

Можно предварительно скачать ПО из списка выше с помощью команд:
```bash
docker pull postgres:16.9-bookworm
docker pull redis:7.2.8-alpine
docker pull memcached:1.6.38-alpine
```

<a id="bitriximages"></a>
## Битрикс образы (bx-*)

Также нам понадобятся:
- база данных MySQL: используем стабильный образ `percona/percona-server:8.0.41`, добавляем слоем сверху конфигурацию бд, собираем `bx-percona-server:8.0.41-v1-rhel`
- веб сервер: используем стабильный образ `nginx:1.28.0-alpine-slim`, добавляем модули слоем сверху, собираем `bx-nginx:1.28.0-v1-alpine`
- интерпретатор PHP-кода: готового совместимого образа PHP нет, берем по умолчанию образ `php:8.2.28-fpm-alpine` и добавляем то, что нам надо через пару слоев сверху, собираем `bx-php:8.2.28-fpm-v1-alpine`
- поиск: готового образа Sphinx нет, но есть собранный пакет `sphinx` на базе `alpine` linux в официальном репозитории ОС, собираем `bx-sphinx:2.2.11-v1-alpine`, установив пакет
- Push-сервер: готового образа нет, используем образ NodeJS 22-ой версии, собираем `bx-push:3.1-v1-alpine`, используя его исходники `push-server-0.4.0`
- сервис для бесплатных SSL-сертификатов от `LetsEncrypt`: используем стабильный образ `goacme/lego:v4.23.1`, добавляем логику слоем сверху, собираем `bx-lego:4.23.1-v1-alpine`
- генератор самоподписных SSL-сертификатов: небольшой образ с пакетами на базе `alpine` linux, собираем `bx-ssl:1.0-v1-alpine`

Список официальных Docker образов, которые будем брать с [DockerHub](https://hub.docker.com/):
- `Percona Server`: https://hub.docker.com/r/percona/percona-server
- `Nginx`: https://hub.docker.com/_/nginx
- `PHP`: https://hub.docker.com/_/php
- `NodeJS`: https://hub.docker.com/_/node
- `Alpine`: https://hub.docker.com/_/alpine
- `Lego`: https://hub.docker.com/r/goacme/lego

Для сборки нам понадобятся следующие образы (их можно предварительно скачать, используя команды):
```bash
docker pull percona/percona-server:8.0.41
docker pull nginx:1.28.0-alpine-slim
docker pull php:8.2.28-fpm-alpine
docker pull node:22
docker pull node:22-alpine
docker pull alpine:3.21
docker pull goacme/lego:v4.23.1
```

Собираем образы, в названии используем `bx-`:

- bx-sphinx:
```bash
cd dev/sources/bxsphinx2211/
docker build -f Dockerfile -t bx-sphinx:2.2.11-v1-alpine --no-cache .
```

- bx-push:
```bash
cd dev/sources/bxpush31/
docker build -f Dockerfile -t bx-push:3.1-v1-alpine --no-cache .
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

- bx-percona-server:
```bash
cd dev/sources/bxpercona8041/
docker build -f Dockerfile -t bx-percona-server:8.0.41-v1-rhel --no-cache .
```

- bx-lego:
```bash
cd dev/sources/bxlego4231/
docker build -f Dockerfile -t bx-lego:4.23.1-v1-alpine --no-cache .
```

- bx-ssl:
```bash
cd dev/sources/bxssl10/
docker build -f Dockerfile -t bx-ssl:1.0-v1-alpine --no-cache .
```

Во всех образах `bx-` в названии тега указывается `v1`, состоит из:
- общая отметка версии, указывается буквой `v`
- номер сборки, начинается с цифры `1`

<a id="databasespasswords"></a>
# Пароли к базам данных MySQL и PostgreSQL

> [!CAUTION]
> Внимание! Перед первым запуском обязательно придумайте или сгенерируйте ваши уникальные пароли суперпользователей баз данных `MySQL` и `PostgreSQL`.

Для этого используем образ `alpine` linux:
```bash
docker pull alpine:3.21
```

Cгенерируем уникальный пароль для суперпользователя `root` базы данных `MySQL` с помощью команды:
```bash
docker container run --rm --name mysql_password_generate alpine:3.21 sh -c "(cat /dev/urandom | tr -dc A-Za-z0-9\?\!\@\-\_\+\%\(\)\{\}\[\]\= | head -c 16) | tr -d '\' | tr -d '^' && echo ''"
```

Cгенерируем уникальный пароль для суперпользователя `postgres` базы данных `PostgreSQL` с помощью команды:
```bash
docker container run --rm --name postgresql_password_generate alpine:3.21 sh -c "(cat /dev/urandom | tr -dc A-Za-z0-9\?\!\@\-\_\+\%\(\)\{\}\[\]\= | head -c 16) | tr -d '\' | tr -d '^' && echo ''"
```

Шаблон пароля для суперпользователя `root` базы данных `MySQL` (`CHANGE_MYSQL_ROOT_PASSWORD_HERE`) и шаблон пароля для суперпользователя `postgres` базы данных `PostgreSQL` (`CHANGE_POSTGRESQL_POSTGRES_PASSWORD_HERE`) хранятся в файле `.env_sql` в виде:
```bash
MYSQL_ROOT_PASSWORD="CHANGE_MYSQL_ROOT_PASSWORD_HERE"
POSTGRES_PASSWORD="CHANGE_POSTGRESQL_POSTGRES_PASSWORD_HERE"
```

Обязательно измените значения в файле `.env_sql`, заменив шаблоны `CHANGE_MYSQL_ROOT_PASSWORD_HERE` и `CHANGE_POSTGRESQL_POSTGRES_PASSWORD_HERE` на ваши значения.

<a id="pushserversecretkey"></a>
# Секретный ключ для Push-сервера

> [!CAUTION]
> Внимание! Перед первым запуском обязательно придумайте или сгенерируйте ваш уникальный секретный ключ для Push-сервера.

Для этого используем образ `alpine` linux:
```bash
docker pull alpine:3.21
```

Cгенерируем уникальный секретный ключ с помощью команды:
```bash
docker container run --rm --name push_server_key_generate alpine:3.21 sh -c "(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 128) && echo ''"
```

Шаблон секретного ключа (`CHANGE_SECURITY_KEY_HERE`) для подписи соединения между клиентом и Push-сервером хранится в файле `.env_push` в виде:
```bash
PUSH_SECURITY_KEY=CHANGE_SECURITY_KEY_HERE
```
Обязательно измените значение вашего уникального секретного ключа в файле `.env_push`, заменив шаблон `CHANGE_SECURITY_KEY_HERE` на ваше значение.

<a id="management"></a>
# Управление

Управление (или оркестровка) набором контейнеров или одним из контейнеров осуществляется через `Docker Compose`.

Переходим в каталог проекта `cd dev` и выполняем команды ниже.

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

Зайти в sh-консоль определенного контейнера, например nginx:
```bash
docker compose exec nginx sh
```

Подробней можно прочитать в документации docker compose: https://docs.docker.com/reference/cli/docker/compose/

<a id="timezone"></a>
# Часовой пояс (timezone)

Значение часового пояса (timezone), используемой контейнерами, хранится в файле `.env`.

Значение по умолчанию задано как:
```bash
TZ=Europe/Kaliningrad
```

Исключение составляет контейнер с `php`, значение часового пояса (timezone) которого продублировано в отдельном файле `confs/php/etc/php/conf.d/timezone.ini` как:
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

Учтите, что при использовании `https` нужен SSL-сертификат, который можно сгенерировать или получить на доменное имя, но не на IP адрес.

<a id="ports"></a>
# Порты

Запущенный сайт для своей работы по умолчанию использует порты:
- `8588` для http
- `8589` для https

В случае, если вы используете фаервол, необходимо открыть порты. Пример команд для разных ОС:

- Debian/Ubuntu и т.д.:
```bash
ufw allow 8588 && ufw allow 8589
```

- RHEL/CentOS/AlmaLinux/RockyLinux/OracleLinux/ArchLinux и т.д.:
```bash
firewall-cmd --add-port=8588/tcp --permanent && firewall-cmd --add-port=8589/tcp --permanent && firewall-cmd --reload
```

Для других ОС смотрите документацию по работе с фаерволом.

<a id="siteaccess"></a>
# Доступ к сайту

Итак, согласно разделам `Адресация` и `Порты` выше, к сайту можно обратиться по `http` или `https` следующим образом:

- через localhost:
  - http://127.0.0.1:8588/
  - https://127.0.0.1:8589/

- по локальному IP адресу:
  - http://10.0.1.119:8588/
  - https://10.0.1.119:8589/

- используя домен:
  - http://dev.bx:8588/
  - https://dev.bx:8589/

> [!IMPORTANT]
> <b>НЕ</b> используйте `127.0.0.1` или `localhost` при работе с сайтом на локальной машине. Используйте IP адрес или домен, пример: `10.0.1.119` или `dev.bx`.

В примерах ниже будет использоваться локальный IP адрес `10.0.1.119` или локальный домен `dev.bx`.

<a id="bitrixservertestphp"></a>
# Базовая проверка конфигурации окружения

После запуска сайта необходимо провести базовую проверку конфигурации веб-сервера. Она выполняется с помощью скрипта `bitrix_server_test.php`.

Используем способ, который работает одинаково на всех ОС.

Заходим в sh-консоль контейнера `php` из-под пользователя `bitrix`:
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

Для Docker Engine на Linux расположение каталога сайта на хосте зависит от режима работы docker-а:
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

Для установки продуктов компании 1С-Битрикс можно использовать скрипт `bitrixsetup.php`: https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=135&LESSON_ID=4523&LESSON_PATH=10495.4495.4523

Для восстановления из резервной копии скрипт `restore.php`: https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=135&CHAPTER_ID=02014&LESSON_PATH=10495.4496.2014

Заходим в sh-консоль контейнера `php` из-под пользователя `bitrix`:
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

Используем скрипт `bitrixsetup.php`, скачиваем дистрибутив продукта компании 1С-Битрикс, демо или лицензионную версию.

Редакция и тип базы зависит от вашего выбора.

После переходим на сайт, используя URL:
```bash
http://10.0.1.119:8588/
```

Проходим мастер установки дистрибутива:
- `1С-Битрикс: Управление сайтом` - https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=135&CHAPTER_ID=04522&LESSON_PATH=10495.4495.4522
- `1С-Битрикс24` - https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=135&CHAPTER_ID=04522&LESSON_PATH=10495.4495.4522

На шаге создания базы вводим параметры подключения к ней:

- для `MySQL` версии:
  - Имя хоста (алиас) - `mysql`
  - Имя суперпользователя - `root`
  - Пароль суперпользователя - был создан вами в главе `Пароли к базам данных MySQL и PostgreSQL`, хранится в файле `.env_sql`

- для `PostgreSQL` версии:
  - Имя хоста (алиас) - `postgres`
  - Имя суперпользователя - `postgres`
  - Пароль суперпользователя - был создан вами в главе `Пароли к базам данных MySQL и PostgreSQL`, хранится в файле `.env_sql`

<a id="restorebackup"></a>
## Восстановление из резервной копии

Используем скрипт `restore.php`, восстанавливаем сайт из резервной копии.

Если архив сайта был размещен на сайте (в облаке) клиента, то необходимо выбрать вариант `Скачать резервную копию с другого сайта` и указать путь к архиву.

Если архив сайта был размещен в облаке 1С-Битрикс, то необходимо выбрать вариант `Развернуть резервную копию из облака "1С-Битрикс"` и указать активный лицензионный ключ.

Также архив сайта можно `Загрузить с локального диска`, выбрав нужные файлы.

Если `Архив загружен в корневую папку сервера`, то появится пункт, который позволит распаковать файлы в корень сайта соответственно.

После скачивания архива и завершения распаковки файлов необходимо будет указать настройки соединения с базой данных, если при создании резервной копии был создан дамп базы данных.

Нажимаем кнопку `Восстановить` и ждем завершения работы сценария.

После успешного восстановления нажимаем кнопку `Удалить локальную копию и служебные скрипты`.

<a id="licenceandupdates"></a>
# Лицензия, обновления платформы и решений

Перед дальнейшим использованием продуктов 1С-Битрикс рекомендуется обновить их до последних версий.

Для этого вам понадобится лицензионный ключ для продукта выбранной редакции.

Дальше нужно зайти в настройки `Главный модуль (main)` (`/bitrix/admin/settings.php?lang=ru&mid=main`), на табе `Система обновлений` заполнить поле `Лицензионный ключ`.

Перейти на страницу `Обновление платформы` (`/bitrix/admin/update_system.php?lang=ru`), обновить систему обновлений, принять новые лицензионные соглашения (если это потребуется) и установить все доступные обновления.

Рекомендуется перейти на страницу `Обновление решений` (`/bitrix/admin/update_system_partner.php?lang=ru`) и установить обновления сторонних решений.

<a id="modulessettings"></a>
# Настройки модулей

После установки дистрибутива или восстановления сайта из бекапа необходимо настроить модули этого сайта.

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

Описание значений полей смотрите документации модуля.

<a id="sitechecker"></a>
# Проверка системы

Для всесторонней проверки соответствия параметров системы, на которой осуществляется функционирование сайта, минимальным и рекомендуемым техническим требованиям продукта используйте страницу `Проверка системы` (`/bitrix/admin/site_checker.php?lang=ru`).

Документация:
- https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=35&LESSON_ID=14020&LESSON_PATH=3906.4493.4506.2024.14020
- https://dev.1c-bitrix.ru/user_help/settings/utilities/site_checker.php

<a id="perfmonpanel"></a>
# Тест производительности

Для оценки производительности перейдите на страницу `Панель производительности` (`/bitrix/admin/perfmon_panel.php?lang=ru`).

Выполните тест конфигурации. Результаты подскажут "узкие" места системы или ее конфигурации.

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

Это задание будет выполнятся только в том случае, если дистрибутив установлен.

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

Заходим в sh-консоль контейнера `cron` из-под пользователя `root`:
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

По умолчанию конфигурация `nginx` предварительно подготовлена таким образом, чтобы временные файлы хранились вне пределов корневой директории сайта, так как это существенно повышает защищенность от известных атак.

Для завершения настройки и усиления безопасности, необходимо в административной части продукта на странице `Управление структурой` (`/bitrix/admin/fileman_admin.php?lang=ru&path=%2F`) отредактировать файл `/bitrix/php_interface/dbconn.php`, добавить строку:
```bash
define("BX_TEMPORARY_FILES_DIRECTORY", "/opt/.bx_temp");
```

Cохранить.

Проверить настройку можно на странице `Сканер безопасности` (`/bitrix/admin/security_scanner.php?lang=ru`) модуля `Проактивной защиты (security)`.

<a id="pushpull"></a>
# Push & pull

<a id="pushserver"></a>
## Push-сервер

Для работы Push-сервера будет запущено два контейнера: один для режима `pub`, второй для режима `sub`. Оба используют один образ `bx-push`.

Параметры переменных сред контейнеров хранятся в файлах `.env_push_pub` и `.env_push_sub`.

Cекретный ключ для подписи соединения между клиентом и push-сервером хранится в файле `.env_push` и был создан вами в главе `Секретный ключ для push-сервера`.

Возвращаемся к главам `Адресация` и `Порты` этого документа. Определяемся по какой схеме работает сайт. Например:
- используется локальный IP вида `10.0.1.119`
- порт для http `8588`
- порт для https `8589`

Итого получается:
- для http: `10.0.1.119:8588`
- для https: `10.0.1.119:8589`

Запоминаем эти значения.

В административной части продукта на странице `Управление структурой` (`/bitrix/admin/fileman_admin.php?lang=ru&path=%2F`) редактируем файл `/bitrix/.settings.php`:
- добавляем блок настроек Push-сервера
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

Для продукта Битрикс24 проверить настройку Push-сервера можно на странице `Проверка системы` (`/bitrix/admin/site_checker.php?lang=ru`), используя таб `Работа портала`.

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

Значения настроек msmtp зависят от smtp-сервера, с которым он будет взаимодействовать при работе.

Например, локальный почтовый сервер, отвечает на порту `25`, расположен на хосте `mail.server.local`, не использует в своей работе `tls`. В файле `/opt/msmtp/.msmtprc` настройки будут выглядеть:
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

Другой пример: почтовые сервисы вида `Gmail`, `Yahoo`, `Yandex`, `Rambler` и т.д.

Настройки почтовых сервисов приведены в курсе: https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=37&LESSON_ID=12265

Для `Gmail`, который отвечает на порту `587`, расположен на хосте `smtp.gmail.com`, использует в своей работе `tls`. В файле `/opt/msmtp/.msmtprc` полный список настроек выглядит так:

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

Настроим отправку писем через `Gmail`.

В блоке настроек выше меняем `APP_PASSWORD` на пароль приложения, `LOGIN` на ваш логин в почте Google.

Заходим в sh-консоль контейнера `php` из-под пользователя `root`:
```bash
docker compose exec --user=root php sh
```

Устанавливаем `mc` и выходим:
```bash
apk add mc
exit
```

Заходим в sh-консоль контейнера `php` из-под пользователя `bitrix`:
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

Для отправки почты используем возможности `Главного модуля (main)` без каких-либо дополнительных контейнеров и т.д.

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

Проверить настройки можно отправив письмо самому себе. Для этого нужно отредактировать параметры пользователя, указав `E-Mail` и отметить опцию `Оповестить пользователя`.

Лог отправки будет в файле `/bitrix/modules/smtp_mailer.log`.

> [!NOTE]
> Проверка системы при тестировании параметров не использует SMTP-сервера отправителя. Два теста почты будут красными. Можно это проигнорировать.

<a id="emaildebuglog"></a>
## Логирование отправки почты в файл

Если отправка почты не работает, можно включить логирование процесса отправки в файл для диагностики проблемы.

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

Чтобы его использовать, заходим в sh-консоль контейнера `php` из-под пользователя `bitrix`:
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

После запускаем Bitrix CLI:
```bash
php bitrix.php -h
```

Полный набор команд и параметров доступен в документации: https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=43&LESSON_ID=11685&LESSON_PATH=3913.3516.4776.2483.11685

<a id="phpbrowsercapabilities"></a>
## PHP Browser Capabilities

Возможно, пригодится настроить, если нужна `История входов`: https://helpdesk.bitrix24.ru/open/16615982/

Заходим в sh-консоль контейнера `php` из-под пользователя `root`:
```bash
docker compose exec --user=root php sh
```

Устанавливаем `curl`, подключаем ini-файл в настройках PHP, выходим:
```bash
apk add curl
echo 'browscap = /opt/browscap/php_browscap.ini' > /usr/local/etc/php/conf.d/browscap.ini
exit
```

Заходим в sh-консоль контейнера `php` из-под пользователя `bitrix`:
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
- отмечаем опцию `Сохранять историю входов с устройств пользователя` - `Да`
- заполняем поле `Сколько дней хранить историю входов` - `365`

Сохраняем настройки.

<a id="phpgeoip2"></a>
## PHP GeoIP2

Возможно, пригодится настроить, если нужно отслеживать геопозицию устройства для `Истории входов`: https://helpdesk.bitrix24.ru/open/16615982/

Заходим в sh-консоль контейнера `php` из-под пользователя `bitrix`:
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
- выбираем `Тип базы данных` - `GeoIP2/GeoLite2 City`
- заполняем `Абсолютный путь к файлу базы данных (*.mmdb)` - `/opt/geoip2/GeoLite2-City.mmdb`

или

- выбираем `Тип базы данных` - `GeoIP2/GeoLite2 Country`
- заполняем `Абсолютный путь к файлу базы данных (*.mmdb)` - `/opt/geoip2/GeoLite2-Country.mmdb`

Сохраняем настройки.

На странице настроек `Главного модуля (main)` (`/bitrix/admin/settings.php?lang=ru&mid=main`) на табе `Журнал событий`:
- отмечаем опцию `Собирать IP-геоданные для истории входов` - `Да`

Сохраняем настройки.

<a id="phpextensions"></a>
## PHP расширения (extensions)

Образ `bx-php` в своем составе содержит следующие PHP расширения (extensions):
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

Чтобы активировать PHP расширение:

- заходим в sh-консоль контейнера `php` из-под пользователя `root`:
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

Чтобы  деактивировать PHP расширение:

- заходим в sh-консоль контейнера `php` из-под пользователя `root`:
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

Чтобы работать с изображениями с помощью PHP расширения `Imagick` (а не `GD`), активируем библиотеку для работы с изображениями на базе `ImagickImageEngine`.

Убедимся, что в файле `/usr/local/etc/php/conf.d/docker-php-ext-imagick.ini` активировано подключение расширения `imagick`. Как это сделать, описано в главе `PHP расширения (extensions)`.

Заходим в sh-консоль контейнера `php` из-под пользователя `bitrix`:
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

Заходим в sh-консоль контейнера `php` из-под пользователя `root`:
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

Заходим в sh-консоль контейнера `php` из-под пользователя `root`:
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

Контейнер `redis` используется в связке с Push-сервером.

Также может быть использован для хранения кеша и для хранения данных сессий.

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

- `memcache`, разделенная сессия:
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

Сохраняем подключение. В списке подключений для созданного подключения нажимаем `Начать использовать`.

Процесс отключения и удаления обратный добавлению.

<a id="clustercacheredis"></a>
### Redis

В административной части продукта на странице настроек модуля `Веб-кластер` (`/bitrix/admin/settings.php?lang=ru&mid=cluster`) выбираем `Использовать для хранения кеша` - `Redis`.

Сохраняем настройки.

В административной части продукта на странице `Подключения к redis` (`/bitrix/admin/cluster_redis_list.php?lang=ru&group_id=1`) добавляем новое подключение и указываем:
- `Сервер` - `redis`
- `Порт` - `6379`

Сохраняем подключение. В списке подключений для созданного подключения нажимаем `Начать использовать`.

Процесс отключения и удаления обратный добавлению.

<a id="httpsssltlswss"></a>
# HTTPS/SSL/TLS/WSS

<a id="selfsignedcerts"></a>
## Самоподписанный сертификат

Сгенерировать и использовать SSL-сертификат в режиме самоподписи возможно с помощью отдельного контейнера `ssl` на базе образа `bx-ssl`.

Данные, отображаемые в сертификатах корневого и промежуточного центров сертификации, хранятся в файле `.env_ssl`. Строки настроек начинаются с `CA_`.

При необходимости отредактируйте файл `.env_ssl`, укажите ваши данные по примеру:
- `Название страны`: введите двухбуквенный код вашей страны (пример, `RU`)
- `Название штата или провинции`: введите название штата, в котором официально зарегистрирована ваша организация (пример, `Kaliningrad Region`)
- `Название населенного пункта`: введите название населенного пункта или города, в котором находится ваша компания (пример, `Kaliningrad`)
- `Название организации`: укажите официальное название вашей организации (пример, `Dev Corporation Ltd`)
- `Имя организационного подразделения`: введите название подразделения в вашей организации, отвечающего за управление сертификатами (пример, `Dev Corporation Ltd Unit`)
- `Адрес электронной почты`: пример, `info@devcorporation.ltd`

Данные, отображаемые в сертификате для домена, также хранятся в файле `.env_ssl`. Строки настроек начинаются с `CERT_`.

При необходимости отредактируйте файл `.env_ssl`, укажите ваши данные по примеру:
- `Название страны`: введите двухбуквенный код вашей страны (пример, `RU`)
- `Название штата или провинции`: введите название штата, в котором официально зарегистрирована ваша организация (пример, `Kaliningrad Region`)
- `Название населенного пункта`: введите название населенного пункта или города, в котором находится ваша компания (пример, `Kaliningrad`)
- `Название организации`: укажите официальное название вашей организации (пример, `Dev Corporation Ltd`)
- `Имя организационного подразделения`: введите название подразделения в вашей организации, отвечающего за управление сертификатами (пример, `Dev Corporation Ltd Unit`)
- `Адрес электронной почты`: пример, `info@devcorporation.ltd`

> [!IMPORTANT]
> Если данные, отображаемые в сертификатах корневого и промежуточного центров сертификации, были изменены в файле `.env_ssl`, необходимо пересоздать контейнер `ssl`.
>
> Для этого выполните последовательно команды остановки, удаления, пересоздания и запуска контейнера `ssl`:
> ```bash
> docker compose stop ssl
> docker compose rm -f ssl
> docker compose up -d
> ```

<a id="selfsigneddeploys"></a>
### Выпуск сертификатов

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

Файл `dhparam.pem` не создается, а поставляется для примера. Если нужно его сделать уникальным, выполните команду:
```bash
docker compose exec --user=bitrix ssl bash -c "openssl dhparam -out /ssl/dhparam.pem 4096"
```

> [!IMPORTANT]
> Создание файла dhparam.pem может занять значительное время, зависящее от производительности вашего оборудования.

<a id="selfsignedtrustforphpandnginx"></a>
### Доверие к сертификатам центров сертификации для PHP и Nginx

Сертификат корневого центра сертификации (`rootCA.cert.pem`) и сертификат промежуточного центра сертификации (`intermediateCA.cert.pem`) нужно добавить в траст контейнеров `nginx` и `php`.

Заходим в sh-консоль контейнера `php` из-под пользователя `root`:
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

Если локальный домен не определяется в вашей сети, нужно в файле `/etc/hosts` контейнера `php` добавить:
```bash
apk add mc
mcedit /etc/hosts
10.0.1.119 dev.bx
exit
```

Заходим в sh-консоль контейнера `nginx` из-под пользователя `root`:
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

<a id="installselfsignedcerts"></a>
### Установка сертификатов

Также нам нужно в SSL конфигурацию `nginx` прописать новые сертификаты. Редактируем файл `/etc/nginx/ssl/ssl.conf`, меняем настройки опций `ssl_*`:
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

Также скопируем файлы сертификата корневого центра сертификации (`rootCA.cert.pem`) и сертификата промежуточного центра сертификации (`intermediateCA.cert.pem`) в корень сайта:
```bash
cp /ssl/rootCA.cert.pem /opt/www/
cp /ssl/intermediateCA.cert.pem /opt/www/
chown bitrix:bitrix /opt/www/rootCA.cert.pem
chown bitrix:bitrix /opt/www/intermediateCA.cert.pem
exit
```

Проверяем настройки `nginx`:
```bash
docker compose exec --user=bitrix nginx sh -c "nginx -t"
```

Если никаких ошибок нет, перезапускаем контейнер `nginx`:
```bash
docker compose restart nginx
```

<a id="importselfsignedcertstoosorbrowser"></a>
### Импорт сертификатов в ОС или браузер

На хосте, где будем использовать браузер, скачиваем файлы центров сертификации по ссылкам:
```bash
http://dev.bx:8588/rootCA.cert.pem
http://dev.bx:8588/intermediateCA.cert.pem
```

Добавляем их в траст ОС, на которой работает браузер.

Все ОС: `Windows`, `Linux`, `MacOS`

Общая часть для всех - браузер `Mozilla Firefox`. Имеет своё хранилище сертификатов центров сертификации. Работает одинаково вне зависимости от ОС.

В браузере переходим `Настройки` -> `Приватность и защита` -> `Защита` -> `Сертификаты`.

Нажимаем кнопку `Просмотр сертификатов`, в окне переходим на таб `Центры сертификации`.

Нажимаем кнопку `Импортировать`:
- первый раз выбираем файл сертификата корневого центра сертификации (`rootCA.cert.pem`)
- второй раз выбираем файл сертификата промежуточного центра сертификации (`intermediateCA.cert.pem`)

ОС: `Windows`

Браузеры `Google Chrome` и `Microsoft Edge` (и другие на их базе) используют системное хранилище ОС для сертификатов центров сертификации.

Скачанные файлы переименовываем, меняем расширение с `pem` на `crt`:
- `rootCA.cert.pem` -> `rootCA.cert.crt`
- `intermediateCA.cert.pem` -> `intermediateCA.cert.crt`

Дважды кликаем на файле `rootCA.cert.crt`, откроется просмотр сертификата.

Нажимаем кнопку `Установить сертификат`.

Проходим мастер импорта. Выбираем `Поместить все сертификаты в следующие хранилища`, в окне выбираем `Доверенные корневые центры сертификации`.

ОС: `Linux`

Выбор пути зависит от используемой вами ОС Linux.

Для ОС Debian, Ubuntu и ОС на их базе

Устанавливаем пакет `ca-certificates` и создаем объединенный траст файл со всеми сертификатами:
```bash
apt install -y ca-certificates
update-ca-certificates
```

Скачанные файлы переименовываем, меняем расширение с `.pem` на `.crt`:
- `rootCA.cert.pem` -> `rootCA.cert.crt`
- `intermediateCA.cert.pem` -> `intermediateCA.cert.crt`

Например, с помощью команды `cp` выполняем:
```bash
cp rootCA.cert.pem rootCA.cert.crt
cp intermediateCA.cert.pem intermediateCA.cert.crt
```

Для файлов сертификата корневого центра сертификации (`rootCA.cert.crt`) и сертификата промежуточного центра сертификации (`intermediateCA.cert.crt`) создаем символические ссылки в каталоге `/usr/local/share/ca-certificates/`:
```bash
ln -s rootCA.cert.crt /usr/local/share/ca-certificates/rootCA.cert.crt
ln -s intermediateCA.cert.crt /usr/local/share/ca-certificates/intermediateCA.cert.crt
```

Обновляем объединенный траст файл со всеми сертификатами командой:
```bash
update-ca-certificates
```

Для ОС RHEL, CentOS Stream, Rocky Linux, AlmaLinux, Oracle Linux, EuroLinux, Fedora и ОС на их базе

Устанавливаем пакет `ca-certificates`:
```bash
dnf install -y ca-certificates
```

Для операционных систем 9-ой серии и выше (пример, RHEL 9, CentOS Stream 9 и т.д.) выполняем команду:
```bash
update-ca-trust
```

Для операционных систем ниже 9-ой серии (пример, Rocky Linux 8.x и т.д.) выполняем команды:
```bash
update-ca-trust force-enable
update-ca-trust enable
```

Для файлов сертификата корневого центра сертификации (`rootCA.cert.pem`) и сертификата промежуточного центра сертификации (`intermediateCA.cert.pem`) создаем символические ссылки в каталоге `/etc/pki/ca-trust/source/anchors/`:
```bash
ln -s rootCA.cert.pem /etc/pki/ca-trust/source/anchors/rootCA.cert.pem
ln -s intermediateCA.cert.pem /etc/pki/ca-trust/source/anchors/intermediateCA.cert.pem
```

Обновляем траст корневых сертификатов (CA Trust) машины командой:
```bash
update-ca-trust extract
```

Для ОС Arch, Bluestar, Manjaro, EndeavourOS, Garuda, Mabox, RebornOS, Archcraft, ArchLabs, CachyOS и ОС на их базе

Устанавливаем пакет `ca-certificates` и обновляем траст корневых сертификатов (CA Trust) машины:
```bash
pacman -Syu ca-certificates
update-ca-trust
```

Скачанные файлы переименовываем, меняем расширение с `.pem` на `.crt`:
- `rootCA.cert.pem` -> `rootCA.cert.crt`
- `intermediateCA.cert.pem` -> `intermediateCA.cert.crt`

Например, с помощью команды `cp` выполняем:
```bash
cp rootCA.cert.pem rootCA.cert.crt
cp intermediateCA.cert.pem intermediateCA.cert.crt
```

Для файлов сертификата корневого центра сертификации (`rootCA.cert.crt`) и сертификата промежуточного центра сертификации (`intermediateCA.cert.crt`) создаем символические ссылки в каталоге `/etc/ca-certificates/trust-source/anchors/`:
```bash
ln -s rootCA.cert.crt /etc/ca-certificates/trust-source/anchors/rootCA.cert.crt
ln -s intermediateCA.cert.crt /etc/ca-certificates/trust-source/anchors/intermediateCA.cert.crt
```

Обновляем траст корневых сертификатов (CA Trust) машины командой:
```bash
update-ca-trust extract
```

ОС: `MacOS`

Открываем приложение `Связка ключей`.

Чтобы быстро открыть `Связку ключей`, найдите ее через `Spotlight`, затем нажмите клавишу `Ввод`.

В категории `Системные связки ключей` выбираем `Система`, кликаем для открытия и выбора.

В меню `Файл` выбираем `Импортировать объекты`, выбираем файл сертификата корневого центра сертификации (`rootCA.cert.pem`).

На табе `Сертификаты` находим добавленный сертификат, выделяем его, в меню выбираем `Свойства`.

В окне просмотра сертификата разворачиваем группу настроек `Доверие`.

В настройке `Параметры использования сертификата` выбираем `Всегда доверять`.

Закрываем окно, подтверждаем доверие сертификата.

Аналогичным способом проходим путь для файла сертификата промежуточного центра сертификации (`intermediateCA.cert.pem`).

Итог: после настройки выше переходим на сайт по URL с доменом `dev.bx`, используя `https` и порт `8589` в URL:
```bash
https://dev.bx:8589/
```

Устанавливаем дистрибутив, восстанавливаем бекап сайта - выбора за вами.

Выполняем подстройку сайта как указано выше в этом README-файле.

Страница `Проверка системы` (`/bitrix/admin/site_checker.php?lang=ru`) открывается по `https` и сама проверка проходит, используя `ssl` коннект вида:
```bash
Connection to ssl://dev.bx:8589	Success
```

Push-сервер использует безопасные веб-сокеты, соединение устанавливается по протоколу `wss`. Пуши отправляются корректно, интерактивность функционирует.

<a id="removeselfsignedcertsfromosorbrowser"></a>
### Удаление сертификатов из ОС или браузера

> [!IMPORTANT]
> При удалении сайта не забудьте удалить сертификат корневого центра сертификации (`rootCA.cert.pem`) и сертификат промежуточного центра сертификации (`intermediateCA.cert.pem`) из ОС и браузера.

Для браузера `Mozilla Firefox` процесс удаления обратный добавлению.

Для удаления сертификатов центров сертификации в ОС `Windows`:
- запустите оснастку сертификатов, выполнив команду `certmgr.msc`
- в ней перейдите `Сертификаты` - `Доверенные корневые центры сертификации` - `Сертификаты`
- найдите сертификаты центров сертификации
- сначала удалите сертификат промежуточного центра сертификации, затем сертификат корневого центра сертификации, выбрав их в списке по одному и в меню выбрав пункт `удалить`
- подтвердите удаление

Для удаления сертификатов центров сертификации в ОС `Linux`:

Выбор пути зависит от используемой вами ОС Linux.

Для ОС Debian, Ubuntu и ОС на их базе

Удаляем символические ссылки для файлов сертификата корневого центра сертификации (`rootCA.cert.crt`) и сертификата промежуточного центра сертификации (`intermediateCA.cert.crt`):
```bash
rm -f /usr/local/share/ca-certificates/rootCA.cert.crt
rm -f /usr/local/share/ca-certificates/intermediateCA.cert.crt
```

Обновляем объединенный траст файл со всеми сертификатами командой:
```bash
update-ca-certificates
```

Для ОС RHEL, CentOS Stream, Rocky Linux, AlmaLinux, Oracle Linux, EuroLinux, Fedora и ОС на их базе

Удаляем символические ссылки для файлов сертификата корневого центра сертификации (`rootCA.cert.pem`) и сертификата промежуточного центра сертификации (`intermediateCA.cert.pem`):
```bash
rm -f /etc/pki/ca-trust/source/anchors/rootCA.cert.pem
rm -f /etc/pki/ca-trust/source/anchors/intermediateCA.cert.pem
```

Обновляем траст корневых сертификатов (CA Trust) машины командой:
```bash
update-ca-trust extract
```

Для ОС Arch, Bluestar, Manjaro, EndeavourOS, Garuda, Mabox, RebornOS, Archcraft, ArchLabs, CachyOS и ОС на их базе

Удаляем символические ссылки для файлов сертификата корневого центра сертификации (`rootCA.cert.crt`) и сертификата промежуточного центра сертификации (`intermediateCA.cert.crt`):
```bash
rm -f /etc/ca-certificates/trust-source/anchors/rootCA.cert.crt
rm -f /etc/ca-certificates/trust-source/anchors/intermediateCA.cert.crt
```

Обновляем траст корневых сертификатов (CA Trust) машины командой:
```bash
update-ca-trust extract
```
Для удаления сертификатов центров сертификации в ОС `MacOS`:

Откройте приложение `Связка ключей`.

Чтобы быстро открыть `Связку ключей`, найдите ее через `Spotlight`, затем нажмите клавишу `Ввод`.

В категории `Системные связки ключей` выбираем `Система`, кликаем для открытия и выбора.

Переходим на таб `Сертификаты`.

Находим файл сертификата промежуточного центра сертификации (`intermediateCA.cert.pem`).

Выбираем его и в меню кликаем `Удалить`.

Подтверждаем удаление сертификата промежуточного центра сертификации из связки ключей `Система`.

Аналогичным способом проходим путь для удаления из связки ключей `Система` сертификата корневого центра сертификации (`rootCA.cert.pem`).

<a id="presentcerts"></a>
## Бесплатный Lets Encrypt сертификат

<a id="lego"></a>
### Lego

Выпустить и использовать бесплатный SSL-сертификат от LetsEncrypt возможно с помощью отдельного контейнера `lego` на базе образа `bx-lego`.

Внутри образа находится `LetsEncrypt` клиент и `ACME` библиотека, написанная на `Go`. По сокращениям первых букв слов получаем название проекта `LeGo` ([GitHub](https://github.com/go-acme/lego), [DockerHub](https://hub.docker.com/r/goacme/lego)).

Основные возможности проекта `Lego`:
- ACME v2 с поддержкой множества RFC и draft-ов
- поддержка 150 DNS-провайдеров
- выпуск, перевыпуск, отзыв SSL-сертификатов
- HTTPS, DNS, TLS челленджи
- выпуск сертификатов:
  - на один домен (singledomain)
  - на множество поддоменов домена (не больше 100 в одном сертификате) (multidomain)
  - на все множество поддоменных имен домена (*) (wildcard)
- и многое другое

<a id="domaintransfer"></a>
### Перенаправление или перенос домена

Перед тем как выполнять запросы на получение или обновление SSL-сертификатов с помощью LetsEncrypt нам необходимо перенаправить (или перенести) домен от поставщика услуг на DNS-хостинг провайдера.

Рассмотрим примеры в общих чертах, в деталях информацию необходимо найти в документации поставщиков услуг и DNS-провайдеров.

Пример 1: домен `example.dev` приобретен в `Reg.ru`, переносим его в `YandexCloud`.

В консоли `YandexCloud` добавляем домен, система потребует от нас прописать DNS-сервера у поставщика услуг. Возвращаемся в `Reg.ru`, прописываем требуемые DNS-записи `Yandex`, сохраняем.

Ожидаем завершения процесса переноса. Проверить DNS-записи можно с помощью сервиса https://dnschecker.org/.

Пример 2: домен `proj.site` приобретен в `Reg.ru`, переносим его в `CloudFlare`.

В консоли `CloudFlare` добавляем домен, система потребует от нас прописать DNS-сервера у поставщика услуг. Возвращаемся в `Reg.ru`, прописываем требуемые DNS-записи `CloudFlare`, сохраняем.

Ожидаем завершения процесса переноса. Проверить DNS-записи можно с помощью сервиса https://dnschecker.org/.

<a id="letsencryptchallenges"></a>
### Челленджи

Челлендж - дословно это `вызов`, который `бросает` ваш клиент сервису `LetsEncrypt`. Эти задания содержат домен(ы) и способ его(их) проверки (верификации). При успешном выполнении клиент получает сертификат.

`Lego` поддерживает три типа челленджей: `HTTP`, `DNS`, `TLS`.

`TLS` челлендж рассматривать не будем в виду сложности реализации и использования.

Рассмотрим `HTTP` и `DNS` челленджи как самые часто используемые.

> [!CAUTION]
> Внимание! `HTTP` челлендж возможно пройти `ТОЛЬКО` на порту `80`.
>
> Внимание! С помощью `HTTP` челленджа невозможно получить `wildcard` сертификаты.

Подробней в документации LetsEncrypt: https://letsencrypt.org/docs/challenge-types/

<a id="letsencrypthttpchallenge"></a>
#### HTTP челлендж (http-01)

Чтобы выполнить это задание, завершить `HTTP` челлендж и в итоге получить бесплатный SSL-сертификат, вам необходимо:

- в управлении DNS-записями вашего домена добавить:
  - `А` запись на один домен (singledomain), пример: `example.dev` или `chat.example.dev` и т.д.
  - `A` записи для каждого из множества поддоменов домена (multidomain), пример: `example.dev`, `chat.example.dev`, `forum.example.dev` и т.д.

- с помощью сервиса https://dnschecker.org/ проверить распределение и доступность добавленных DNS-записей

- запустить сайт, проверить что он отвечает по `http` и заданному домену из сети интернет, используя порт `80` для `HTTP` челленджа

- запустить `HTTP` челлендж, указать домен, тип сертификата и другие параметры

<a id="letsencryptdnschallenge"></a>
#### DNS челлендж (dns-01)

Чтобы выполнить это задание, завершить `DNS` челлендж и в итоге получить бесплатный SSL-сертификат, вам необходимо:

- в управлении DNS-записями вашего домена добавить:
  - `А` запись на один домен (singledomain), пример: `example.dev` или `chat.example.dev` и т.д.
  - `A` записи для каждого из множества поддоменов домена (multidomain), пример: `example.dev`, `chat.example.dev`, `forum.example.dev` и т.д.
  - `А` запись для множества имен домена (wildcard), пример: `example.dev` или `*.example.dev`

- с помощью сервиса https://dnschecker.org/ проверить распределение и доступность добавленных DNS-записей

- запустить `DNS` челлендж, указать домен, тип сертификата и другие параметры

<a id="legocommands"></a>
### Команды lego

Заходим в sh-консоль контейнера `lego` из-под пользователя `bitrix`:
```bash
docker compose exec --user=bitrix lego sh
```

Основная точка входа - это команда `/lego`, после которой следует набор параметров. Узнать их можно, добавив запрос справки `help` одним из способов:
```bash
/lego help
/lego -h
/lego --help
```

Также можно узнать справку по выбранной команде, выполнив:

```bash
/lego run --help
/lego renew --help
/lego revoke --help
/lego list --help
/lego dnshelp --help
```

где:
- `run` - создание аккаунта, выпуск и установка ssl сертификата
- `renew` - перевыпуск (обновление) ssl сертификата
- `revoke` - отзыв ssl сертификата
- `list` - отображение сертификатов и аккаунтов
- `dnshelp` - справка по параметрам dns сервиса (для DNS челленджа)

Все возможные варианты параметров команд указаны в документации: https://go-acme.github.io/lego/usage/cli/options/index.html

<a id="legocommandhttpchallenge"></a>
#### Команда для HTTP челленджа (http-01)

Общая команда `lego` для прохождения `HTTP` челленджа имеет вид:

```bash
/lego \
[SERVER]
[TOS]
[EMAIL]
[PATH]
[DOMAINS]
[HTTP_PARAMS]
[TYPE]
```

где:

- `SERVER` - URL корневого центра сертификации (CA).

Для проверки работы всей цепочки используется `stage` среда LetsEncrypt. Тогда блок принимает вид:
```bash
--server="https://acme-staging-v02.api.letsencrypt.org/directory"
```

Для использования в "боевом" режиме блок принимает вид:
```bash
--server="https://acme-v02.api.letsencrypt.org/directory"
```

- `TOS` - принятие текущих условий сервиса LetsEncrypt. Блок принимает вид:
```bash
--accept-tos
```

- `EMAIL` - адрес электронной почты, используемый для регистрации и восстановления контакта. Блок принимает вид:
```bash
--email "info@site.dev"
```

- `PATH` - каталог, используемый для хранения данных.

В пути всегда должна быть папка `/ssl/`, чтобы сертификаты можно было использовать в контейнере `nginx` и прочих.  Блок принимает вид:
```bash
--path="/ssl/site.dev/"
```

- `DOMAINS` - домен, для которого выпускаются или перевыпускаются SSL-сертификаты.

Если сертификат на один домен, то блок принимает вид:
```bash
--domains "site.dev"
```

В случае multidomain-сертификата домены можно указать несколько раз, блок принимает вид:
```bash
--domains "shop.site.dev"
--domains "wiki.site.dev"
--domains "forum.site.dev"
```

- `HTTP_PARAMS` - обязательный блок параметров `HTTP` челленджа, нужно указать:
```bash
--http
--http.port ":80"
```

- `TYPE` - тип команды, `run` - выпуск, `renew` - перевыпуск и т.д. Блок принимает вид:
```bash
run
```

Итого, собрав все воедино, получаем следующие команды:

- выпуск сертификата на единственный домен `site.dev` с сохранением данных в папке `/ssl`:

```bash
/lego \
--server="https://acme-v02.api.letsencrypt.org/directory" \
--accept-tos \
--email "info@site.dev" \
--path="/ssl/site.dev/" \
--domains "site.dev" \
--http \
--http.port ":80" \
run
```

- перевыпуск сертификата на домен `site.dev`:

```bash
/lego \
--server="https://acme-v02.api.letsencrypt.org/directory" \
--accept-tos \
--email "info@site.dev" \
--path="/ssl/site.dev/" \
--domains "site.dev" \
--http \
--http.port ":80" \
renew
```

- выпуск сертификата для нескольких доменов (`shop.site.dev`, `wiki.site.dev`, `forum.site.dev`) с сохранением данных в папке `/ssl`, используя `stage` среду:

```bash
/lego \
--server="https://acme-staging-v02.api.letsencrypt.org/directory" \
--accept-tos \
--email "info@site.dev" \
--path="/ssl/site.dev/" \
--domains "shop.site.dev" \
--domains "wiki.site.dev" \
--domains "forum.site.dev" \
--http \
--http.port ":80" \
run
```

- перевыпуск сертификата для нескольких доменов, используя `stage` среду:

```bash
/lego \
--server="https://acme-staging-v02.api.letsencrypt.org/directory" \
--accept-tos \
--email "info@site.dev" \
--path="/ssl/site.dev/" \
--domains "shop.site.dev" \
--domains "wiki.site.dev" \
--domains "forum.site.dev" \
--http \
--http.port ":80" \
renew
```

<a id="legocommanddnschallenge"></a>
#### Команда для DNS челленджа (dns-01)

Общая команда `lego` для прохождения `DNS` челленджа имеет вид:

```bash
[API_STRING]
/lego \
[SERVER]
[TOS]
[EMAIL]
[PATH]
[DOMAINS]
[DNS_RESOLVERS]
[DNS_PROVIDER]
[TYPE]
```

где:

- `API_STRING` - строка с API выбранного DNS-провайдера. Приобретает разный вид в зависимости от API провайдера.

Узнать параметры строки можно через справку в команде `lego` или на сайте проекта.

Пример для DNS-провайдера `cloudflare`, команда:
```bash
/lego dnshelp --code cloudflare
```

Или документация на сайте: https://go-acme.github.io/lego/dns/cloudflare/index.html

В итоге блок кода размещается до команды `/lego` и в нашем примере для DNS-провайдера `cloudflare` принимает вид:
```bash
CLOUDFLARE_DNS_API_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

где `XXXXXXXXX...` - API токен провайдера.

Для других DNS-провайдеров действуем аналогичным путем.

Документацию по всем DNS-провайдерам можно изучить на сайте: https://go-acme.github.io/lego/dns/index.html

- `SERVER` - URL корневого центра сертификации (CA).

Для проверки работы всей цепочки используется `stage` среда LetsEncrypt. Тогда блок принимает вид:
```bash
--server="https://acme-staging-v02.api.letsencrypt.org/directory"
```

Для использования в "боевом" режиме блок принимает вид:
```bash
--server="https://acme-v02.api.letsencrypt.org/directory"
```

- `TOS` - принятие текущих условий сервиса LetsEncrypt. Блок принимает вид:
```bash
--accept-tos
```

- `EMAIL` - адрес электронной почты, используемый для регистрации и восстановления контакта. Блок принимает вид:
```bash
--email "info@site.dev"
```

- `PATH` - каталог, используемый для хранения данных.

В пути всегда должна быть папка `/ssl/`, чтобы сертификаты можно было использовать в контейнере `nginx` и прочих.  Блок принимает вид:
```bash
--path="/ssl/site.dev/"
```

- `DOMAINS` - домен, для которого выпускаются или перевыпускаются SSL-сертификаты.

Если сертификат на один домен, то блок принимает вид:
```bash
--domains "site.dev"
```

В случае multidomain-сертификата домены можно указать несколько раз, блок принимает вид:
```bash
--domains "shop.site.dev"
--domains "wiki.site.dev"
--domains "forum.site.dev"
```

В случае wildcard-сертификата нужно указать домен и *.домен, блок принимает вид:
```bash
--domains "site.dev"
--domains "*.site.dev"
```

- `DNS_RESOLVERS` - список DNS-резолверов, используемых для рекурсивного сканирования DNS записей домена. Одна или несколько строчек в формате `host:port`, блок принимает вид:
```bash
--dns.resolvers 1.1.1.1:53
--dns.resolvers 8.8.8.8:53
--dns.resolvers 9.9.9.9:53
--dns.resolvers 1.0.0.1:53
--dns.resolvers 8.8.4.4:53
```

- `DNS_PROVIDER` - короткое название используемого провайдера для прохождения DNS челленджа, например, блок принимает вид:
```bash
--dns cloudflare
```
Полный список всех DNS-провайдеров доступен в документации: https://go-acme.github.io/lego/dns/index.html

- `TYPE` - тип команды, `run` - выпуск, `renew` - перевыпуск и т.д. Блок принимает вид:
```bash
run
```

Итого, собрав все воедино, получаем следующие команды (в примерах используется `cloudflare`):

- выпуск сертификата на единственный домен `site.dev` с сохранением данных в папке `/ssl`, используя DNS-провайдер `cloudflare`, обращаясь к API с токеном `CLOUDFLARE_DNS_API_TOKEN`:

```bash
CLOUDFLARE_DNS_API_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \
/lego \
--server="https://acme-v02.api.letsencrypt.org/directory" \
--accept-tos \
--email "info@site.dev" \
--path="/ssl/site.dev/" \
--domains "site.dev" \
--dns.resolvers 1.1.1.1:53 \
--dns.resolvers 8.8.8.8:53 \
--dns.resolvers 9.9.9.9:53 \
--dns.resolvers 1.0.0.1:53 \
--dns.resolvers 8.8.4.4:53 \
--dns cloudflare \
run
```

- перевыпуск сертификата на домен `site.dev`:

```bash
CLOUDFLARE_DNS_API_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \
/lego \
--server="https://acme-v02.api.letsencrypt.org/directory" \
--accept-tos \
--email "info@site.dev" \
--path="/ssl/site.dev/" \
--domains "site.dev" \
--dns.resolvers 1.1.1.1:53 \
--dns.resolvers 8.8.8.8:53 \
--dns.resolvers 9.9.9.9:53 \
--dns.resolvers 1.0.0.1:53 \
--dns.resolvers 8.8.4.4:53 \
--dns cloudflare \
renew
```

- выпуск сертификата для нескольких доменов (`shop.site.dev`, `wiki.site.dev`, `forum.site.dev`) с сохранением данных в папке `/ssl`, используя `stage` среду и DNS-провайдер `cloudflare`, обращаясь к API с токеном `CLOUDFLARE_DNS_API_TOKEN`:

```bash
CLOUDFLARE_DNS_API_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \
/lego \
--server="https://acme-staging-v02.api.letsencrypt.org/directory" \
--accept-tos \
--email "info@site.dev" \
--path="/ssl/site.dev/" \
--domains "shop.site.dev" \
--domains "wiki.site.dev" \
--domains "forum.site.dev" \
--dns.resolvers 1.1.1.1:53 \
--dns.resolvers 8.8.8.8:53 \
--dns.resolvers 9.9.9.9:53 \
--dns.resolvers 1.0.0.1:53 \
--dns.resolvers 8.8.4.4:53 \
--dns cloudflare \
run
```

- перевыпуск сертификата для нескольких доменов, используя `stage` среду:

```bash
CLOUDFLARE_DNS_API_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \
/lego \
--server="https://acme-staging-v02.api.letsencrypt.org/directory" \
--accept-tos \
--email "info@site.dev" \
--path="/ssl/site.dev/" \
--domains "shop.site.dev" \
--domains "wiki.site.dev" \
--domains "forum.site.dev" \
--dns.resolvers 1.1.1.1:53 \
--dns.resolvers 8.8.8.8:53 \
--dns.resolvers 9.9.9.9:53 \
--dns.resolvers 1.0.0.1:53 \
--dns.resolvers 8.8.4.4:53 \
--dns cloudflare \
renew
```

- выпуск wildcard-сертификата на множество поддоменов основного домена (`site.dev`, `*.site.dev`) с сохранением данных в папке `/ssl`, используя DNS-провайдер `cloudflare`, обращаясь к API с токеном `CLOUDFLARE_DNS_API_TOKEN`:

```bash
CLOUDFLARE_DNS_API_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \
/lego \
--server="https://acme-v02.api.letsencrypt.org/directory" \
--accept-tos \
--email "info@site.dev" \
--path="/ssl/site.dev/" \
--domains "site.dev" \
--domains "*.site.dev" \
--dns.resolvers 1.1.1.1:53 \
--dns.resolvers 8.8.8.8:53 \
--dns.resolvers 9.9.9.9:53 \
--dns.resolvers 1.0.0.1:53 \
--dns.resolvers 8.8.4.4:53 \
--dns cloudflare \
run
```

- перевыпуск сертификата для нескольких доменов, используя `stage` среду:

```bash
CLOUDFLARE_DNS_API_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \
/lego \
--server="https://acme-v02.api.letsencrypt.org/directory" \
--accept-tos \
--email "info@site.dev" \
--path="/ssl/site.dev/" \
--domains "site.dev" \
--domains "*.site.dev" \
--dns.resolvers 1.1.1.1:53 \
--dns.resolvers 8.8.8.8:53 \
--dns.resolvers 9.9.9.9:53 \
--dns.resolvers 1.0.0.1:53 \
--dns.resolvers 8.8.4.4:53 \
--dns cloudflare \
renew
```

<a id="legodeploys"></a>
### Выпуск сертификатов

Рассмотрим процедуру получения SSL-сертификатов на практике.

Для примера используем настоящий домен `proqacf.fun`, запустим все челленджи, получим ответы и настоящие "боевые" сертификаты для домена(ов).

> [!CAUTION]
> Внимание! Данные в публикуемых ответах слегка изменены для их безопасности.

<a id="httpchallengesingledomain"></a>
#### HTTP челлендж (http-01) для одного домена (singledomain SSL-сертификат)

Запрос:
```bash
/lego \
--server="https://acme-v02.api.letsencrypt.org/directory" \
--accept-tos \
--email "info@proqacf.fun" \
--path="/ssl/singledomain.http.b24.proqacf.fun/" \
--domains "b24.proqacf.fun" \
--http \
--http.port ":80" \
run
```

Ответ:
```
2025/04/30 23:17:03 No key found for account info@proqacf.fun. Generating a P256 key.
2025/04/30 23:17:03 Saved key to /ssl/singledomain.http.b24.proqacf.fun/accounts/acme-v02.api.letsencrypt.org/info@proqacf.fun/keys/info@proqacf.fun.key
2025/04/30 23:17:04 [INFO] acme: Registering account for info@proqacf.fun
!!!! HEADS UP !!!!

Your account credentials have been saved in your
configuration directory at "/ssl/singledomain.http.b24.proqacf.fun/accounts".

You should make a secure backup of this folder now. This
configuration directory will also contain certificates and
private keys obtained from the ACME server so making regular
backups of this folder is ideal.
2025/04/30 23:17:04 [INFO] [b24.proqacf.fun] acme: Obtaining bundled SAN certificate
2025/04/30 23:17:05 [INFO] [b24.proqacf.fun] AuthURL: https://acme-v02.api.letsencrypt.org/acme/authz/197567964/1710482XXXX
2025/04/30 23:17:05 [INFO] [b24.proqacf.fun] acme: Could not find solver for: tls-alpn-01
2025/04/30 23:17:05 [INFO] [b24.proqacf.fun] acme: use http-01 solver
2025/04/30 23:17:05 [INFO] [b24.proqacf.fun] acme: Trying to solve HTTP-01
2025/04/30 23:17:06 [INFO] [b24.proqacf.fun] Served key authentication
2025/04/30 23:17:06 [INFO] [b24.proqacf.fun] Served key authentication
2025/04/30 23:17:06 [INFO] [b24.proqacf.fun] Served key authentication
2025/04/30 23:17:06 [INFO] [b24.proqacf.fun] Served key authentication
2025/04/30 23:17:06 [INFO] [b24.proqacf.fun] Served key authentication
2025/04/30 23:17:13 [INFO] [b24.proqacf.fun] The server validated our request
2025/04/30 23:17:13 [INFO] [b24.proqacf.fun] acme: Validations succeeded; requesting certificates
2025/04/30 23:17:13 [INFO] Wait for certificate [timeout: 30s, interval: 500ms]
2025/04/30 23:17:15 [INFO] [b24.proqacf.fun] Server responded with a certificate.
```

Последняя строка в ответе `Server responded with a certificate` означает успешное выполнение задания и выпуск SSL-сертификата.

Файлы сертификатов будут расположены в папке `/ssl/singledomain.http.b24.proqacf.fun/certificates/`.

<a id="httpchallengemultidomain"></a>
#### HTTP челлендж (http-01) для множества поддоменов домена (multidomain SSL-сертификат)

Запрос:
```bash
/lego \
--server="https://acme-v02.api.letsencrypt.org/directory" \
--accept-tos \
--email "info@proqacf.fun" \
--path="/ssl/multidomain.http.all.proqacf.fun/" \
--domains "b24.proqacf.fun" \
--domains "wiki.proqacf.fun" \
--domains "shop.proqacf.fun" \
--http \
--http.port ":80" \
run
```

Ответ:
```
2025/04/30 23:17:30 No key found for account info@proqacf.fun. Generating a P256 key.
2025/04/30 23:17:30 Saved key to /ssl/multidomain.http.all.proqacf.fun/accounts/acme-v02.api.letsencrypt.org/info@proqacf.fun/keys/info@proqacf.fun.key
2025/04/30 23:17:31 [INFO] acme: Registering account for info@proqacf.fun
!!!! HEADS UP !!!!

Your account credentials have been saved in your
configuration directory at "/ssl/multidomain.http.all.proqacf.fun/accounts".

You should make a secure backup of this folder now. This
configuration directory will also contain certificates and
private keys obtained from the ACME server so making regular
backups of this folder is ideal.
2025/04/30 23:17:31 [INFO] [b24.proqacf.fun, wiki.proqacf.fun, shop.proqacf.fun] acme: Obtaining bundled SAN certificate
2025/04/30 23:17:32 [INFO] [b24.proqacf.fun] AuthURL: https://acme-v02.api.letsencrypt.org/acme/authz/197567994/1710483XXXX
2025/04/30 23:17:32 [INFO] [shop.proqacf.fun] AuthURL: https://acme-v02.api.letsencrypt.org/acme/authz/197567994/1710483XXXX
2025/04/30 23:17:32 [INFO] [wiki.proqacf.fun] AuthURL: https://acme-v02.api.letsencrypt.org/acme/authz/197567994/1710483XXXX
2025/04/30 23:17:32 [INFO] [b24.proqacf.fun] acme: Could not find solver for: tls-alpn-01
2025/04/30 23:17:32 [INFO] [b24.proqacf.fun] acme: use http-01 solver
2025/04/30 23:17:32 [INFO] [shop.proqacf.fun] acme: Could not find solver for: tls-alpn-01
2025/04/30 23:17:32 [INFO] [shop.proqacf.fun] acme: use http-01 solver
2025/04/30 23:17:32 [INFO] [wiki.proqacf.fun] acme: Could not find solver for: tls-alpn-01
2025/04/30 23:17:32 [INFO] [wiki.proqacf.fun] acme: use http-01 solver
2025/04/30 23:17:32 [INFO] [b24.proqacf.fun] acme: Trying to solve HTTP-01
2025/04/30 23:17:32 [INFO] [b24.proqacf.fun] Served key authentication
2025/04/30 23:17:33 [INFO] [b24.proqacf.fun] Served key authentication
2025/04/30 23:17:33 [INFO] [b24.proqacf.fun] Served key authentication
2025/04/30 23:17:33 [INFO] [b24.proqacf.fun] Served key authentication
2025/04/30 23:17:33 [INFO] [b24.proqacf.fun] Served key authentication
2025/04/30 23:17:35 [INFO] [b24.proqacf.fun] The server validated our request
2025/04/30 23:17:35 [INFO] [shop.proqacf.fun] acme: Trying to solve HTTP-01
2025/04/30 23:17:35 [INFO] [shop.proqacf.fun] Served key authentication
2025/04/30 23:17:36 [INFO] [shop.proqacf.fun] Served key authentication
2025/04/30 23:17:36 [INFO] [shop.proqacf.fun] Served key authentication
2025/04/30 23:17:36 [INFO] [shop.proqacf.fun] Served key authentication
2025/04/30 23:17:36 [INFO] [shop.proqacf.fun] Served key authentication
2025/04/30 23:17:38 [INFO] [shop.proqacf.fun] The server validated our request
2025/04/30 23:17:38 [INFO] [wiki.proqacf.fun] acme: Trying to solve HTTP-01
2025/04/30 23:17:39 [INFO] [wiki.proqacf.fun] Served key authentication
2025/04/30 23:17:39 [INFO] [wiki.proqacf.fun] Served key authentication
2025/04/30 23:17:39 [INFO] [wiki.proqacf.fun] Served key authentication
2025/04/30 23:17:39 [INFO] [wiki.proqacf.fun] Served key authentication
2025/04/30 23:17:39 [INFO] [wiki.proqacf.fun] Served key authentication
2025/04/30 23:17:43 [INFO] [wiki.proqacf.fun] The server validated our request
2025/04/30 23:17:43 [INFO] [b24.proqacf.fun, wiki.proqacf.fun, shop.proqacf.fun] acme: Validations succeeded; requesting certificates
2025/04/30 23:17:43 [INFO] Wait for certificate [timeout: 30s, interval: 500ms]
2025/04/30 23:17:45 [INFO] [b24.proqacf.fun] Server responded with a certificate.
```

Последняя строка в ответе `Server responded with a certificate` означает успешное выполнение задания и выпуск SSL-сертификата.

Файлы сертификатов будут расположены в папке `/ssl/multidomain.http.all.proqacf.fun/certificates/`.

<a id="dnschallengesingledomain"></a>
#### DNS челлендж (dns-01) для одного домена (singledomain SSL-сертификат)

Запрос:
```bash
CLOUDFLARE_DNS_API_TOKEN=A3n9tXXX-BuiBd5RlITXXXXXX-5LBuWreZXXXXXX \
/lego \
--server="https://acme-v02.api.letsencrypt.org/directory" \
--accept-tos \
--email "info@proqacf.fun" \
--path="/ssl/singledomain.dns.b25.proqacf.fun/" \
--domains "b25.proqacf.fun" \
--dns.resolvers 1.1.1.1:53 \
--dns.resolvers 8.8.8.8:53 \
--dns.resolvers 9.9.9.9:53 \
--dns.resolvers 1.0.0.1:53 \
--dns.resolvers 8.8.4.4:53 \
--dns cloudflare \
run
```

Ответ:
```
2025/04/30 23:20:07 [INFO] [b25.proqacf.fun] acme: Obtaining bundled SAN certificate
2025/04/30 23:20:08 [INFO] [b25.proqacf.fun] AuthURL: https://acme-v02.api.letsencrypt.org/acme/authz/197568154/1710485XXXX
2025/04/30 23:20:08 [INFO] [b25.proqacf.fun] acme: Could not find solver for: tls-alpn-01
2025/04/30 23:20:08 [INFO] [b25.proqacf.fun] acme: Could not find solver for: http-01
2025/04/30 23:20:08 [INFO] [b25.proqacf.fun] acme: use dns-01 solver
2025/04/30 23:20:08 [INFO] [b25.proqacf.fun] acme: Preparing to solve DNS-01
2025/04/30 23:20:10 [INFO] cloudflare: new record for b25.proqacf.fun, ID fbc9f8e6f11bd574496a8d9135a4XXXX
2025/04/30 23:20:10 [INFO] [b25.proqacf.fun] acme: Trying to solve DNS-01
2025/04/30 23:20:11 [INFO] [b25.proqacf.fun] acme: Checking DNS record propagation. [nameservers=1.1.1.1:53,8.8.8.8:53,9.9.9.9:53,1.0.0.1:53,8.8.4.4:53]
2025/04/30 23:20:13 [INFO] Wait for propagation [timeout: 2m0s, interval: 2s]
2025/04/30 23:20:13 [INFO] [b25.proqacf.fun] acme: Waiting for DNS record propagation.
2025/04/30 23:20:15 [INFO] [b25.proqacf.fun] acme: Waiting for DNS record propagation.
2025/04/30 23:20:20 [INFO] [b25.proqacf.fun] The server validated our request
2025/04/30 23:20:20 [INFO] [b25.proqacf.fun] acme: Cleaning DNS-01 challenge
2025/04/30 23:20:21 [INFO] [b25.proqacf.fun] acme: Validations succeeded; requesting certificates
2025/04/30 23:20:21 [INFO] Wait for certificate [timeout: 30s, interval: 500ms]
2025/04/30 23:20:24 [INFO] [b25.proqacf.fun] Server responded with a certificate.
```

Последняя строка в ответе `Server responded with a certificate` означает успешное выполнение задания и выпуск SSL-сертификата.

Файлы сертификатов будут расположены в папке `/ssl/singledomain.dns.b25.proqacf.fun/`.

<a id="dnschallengemultidomain"></a>
#### DNS челлендж (dns-01) для множества поддоменов домена (multidomain SSL-сертификат)

Запрос:
```bash
CLOUDFLARE_DNS_API_TOKEN=A3n9tXXX-BuiBd5RlITXXXXXX-5LBuWreZXXXXXX \
/lego \
--server="https://acme-v02.api.letsencrypt.org/directory" \
--accept-tos \
--email "info@proqacf.fun" \
--path="/ssl/multidomain.dns.all.proqacf.fun/" \
--domains "b25.proqacf.fun" \
--domains "wiki.proqacf.fun" \
--domains "shop.proqacf.fun" \
--dns.resolvers 1.1.1.1:53 \
--dns.resolvers 8.8.8.8:53 \
--dns.resolvers 9.9.9.9:53 \
--dns.resolvers 1.0.0.1:53 \
--dns.resolvers 8.8.4.4:53 \
--dns cloudflare \
run
```

Ответ:
```
2025/04/30 23:21:20 No key found for account info@proqacf.fun. Generating a P256 key.
2025/04/30 23:21:20 Saved key to /ssl/multidomain.dns.all.proqacf.fun/accounts/acme-v02.api.letsencrypt.org/info@proqacf.fun/keys/info@proqacf.fun.key
2025/04/30 23:21:21 [INFO] acme: Registering account for info@proqacf.fun
!!!! HEADS UP !!!!

Your account credentials have been saved in your
configuration directory at "/ssl/multidomain.dns.all.proqacf.fun/accounts".

You should make a secure backup of this folder now. This
configuration directory will also contain certificates and
private keys obtained from the ACME server so making regular
backups of this folder is ideal.
2025/04/30 23:21:21 [INFO] [b25.proqacf.fun, wiki.proqacf.fun, shop.proqacf.fun] acme: Obtaining bundled SAN certificate
2025/04/30 23:21:22 [INFO] [b25.proqacf.fun] AuthURL: https://acme-v02.api.letsencrypt.org/acme/authz/197568584/1710486XXXX
2025/04/30 23:21:22 [INFO] [shop.proqacf.fun] AuthURL: https://acme-v02.api.letsencrypt.org/acme/authz/197568584/1710486XXXX
2025/04/30 23:21:22 [INFO] [wiki.proqacf.fun] AuthURL: https://acme-v02.api.letsencrypt.org/acme/authz/197568584/1710486XXXX
2025/04/30 23:21:22 [INFO] [b25.proqacf.fun] acme: Could not find solver for: tls-alpn-01
2025/04/30 23:21:22 [INFO] [b25.proqacf.fun] acme: Could not find solver for: http-01
2025/04/30 23:21:22 [INFO] [b25.proqacf.fun] acme: use dns-01 solver
2025/04/30 23:21:22 [INFO] [shop.proqacf.fun] acme: Could not find solver for: tls-alpn-01
2025/04/30 23:21:22 [INFO] [shop.proqacf.fun] acme: Could not find solver for: http-01
2025/04/30 23:21:22 [INFO] [shop.proqacf.fun] acme: use dns-01 solver
2025/04/30 23:21:22 [INFO] [wiki.proqacf.fun] acme: Could not find solver for: tls-alpn-01
2025/04/30 23:21:22 [INFO] [wiki.proqacf.fun] acme: Could not find solver for: http-01
2025/04/30 23:21:22 [INFO] [wiki.proqacf.fun] acme: use dns-01 solver
2025/04/30 23:21:22 [INFO] [b25.proqacf.fun] acme: Preparing to solve DNS-01
2025/04/30 23:21:25 [INFO] cloudflare: new record for b25.proqacf.fun, ID d7988d0a8952175b7480b2636065XXXX
2025/04/30 23:21:25 [INFO] [shop.proqacf.fun] acme: Preparing to solve DNS-01
2025/04/30 23:21:26 [INFO] cloudflare: new record for shop.proqacf.fun, ID e202bae64f3cb22c8ae543fb6563XXXX
2025/04/30 23:21:26 [INFO] [wiki.proqacf.fun] acme: Preparing to solve DNS-01
2025/04/30 23:21:27 [INFO] cloudflare: new record for wiki.proqacf.fun, ID e7c3e21d948f97315cb4cb6c4f1dXXXX
2025/04/30 23:21:27 [INFO] [b25.proqacf.fun] acme: Trying to solve DNS-01
2025/04/30 23:21:27 [INFO] [b25.proqacf.fun] acme: Checking DNS record propagation. [nameservers=1.1.1.1:53,8.8.8.8:53,9.9.9.9:53,1.0.0.1:53,8.8.4.4:53]
2025/04/30 23:21:29 [INFO] Wait for propagation [timeout: 2m0s, interval: 2s]
2025/04/30 23:21:29 [INFO] [b25.proqacf.fun] acme: Waiting for DNS record propagation.
2025/04/30 23:21:38 [INFO] [b25.proqacf.fun] The server validated our request
2025/04/30 23:21:38 [INFO] [shop.proqacf.fun] acme: Trying to solve DNS-01
2025/04/30 23:21:38 [INFO] [shop.proqacf.fun] acme: Checking DNS record propagation. [nameservers=1.1.1.1:53,8.8.8.8:53,9.9.9.9:53,1.0.0.1:53,8.8.4.4:53]
2025/04/30 23:21:40 [INFO] Wait for propagation [timeout: 2m0s, interval: 2s]
2025/04/30 23:21:40 [INFO] [shop.proqacf.fun] acme: Waiting for DNS record propagation.
2025/04/30 23:21:42 [INFO] [shop.proqacf.fun] acme: Waiting for DNS record propagation.
2025/04/30 23:21:45 [INFO] [shop.proqacf.fun] acme: Waiting for DNS record propagation.
2025/04/30 23:21:47 [INFO] [shop.proqacf.fun] acme: Waiting for DNS record propagation.
2025/04/30 23:21:49 [INFO] [shop.proqacf.fun] acme: Waiting for DNS record propagation.
2025/04/30 23:21:55 [INFO] [shop.proqacf.fun] The server validated our request
2025/04/30 23:21:55 [INFO] [wiki.proqacf.fun] acme: Trying to solve DNS-01
2025/04/30 23:21:55 [INFO] [wiki.proqacf.fun] acme: Checking DNS record propagation. [nameservers=1.1.1.1:53,8.8.8.8:53,9.9.9.9:53,1.0.0.1:53,8.8.4.4:53]
2025/04/30 23:21:57 [INFO] Wait for propagation [timeout: 2m0s, interval: 2s]
2025/04/30 23:22:03 [INFO] [wiki.proqacf.fun] The server validated our request
2025/04/30 23:22:03 [INFO] [b25.proqacf.fun] acme: Cleaning DNS-01 challenge
2025/04/30 23:22:04 [INFO] [shop.proqacf.fun] acme: Cleaning DNS-01 challenge
2025/04/30 23:22:05 [INFO] [wiki.proqacf.fun] acme: Cleaning DNS-01 challenge
2025/04/30 23:22:06 [INFO] [b25.proqacf.fun, wiki.proqacf.fun, shop.proqacf.fun] acme: Validations succeeded; requesting certificates
2025/04/30 23:22:06 [INFO] Wait for certificate [timeout: 30s, interval: 500ms]
2025/04/30 23:22:09 [INFO] [b25.proqacf.fun] Server responded with a certificate.
```

Последняя строка в ответе `Server responded with a certificate` означает успешное выполнение задания и выпуск SSL-сертификата.

Файлы сертификатов будут расположены в папке `/ssl/multidomain.dns.all.proqacf.fun/`.

<a id="dnschallengewildcard"></a>
#### DNS челлендж (dns-01) на все множество поддоменных имен (*) домена (wildcard SSL-сертификат)

Запрос:
```bash
CLOUDFLARE_DNS_API_TOKEN=A3n9tXXX-BuiBd5RlITXXXXXX-5LBuWreZXXXXXX \
/lego \
--server="https://acme-v02.api.letsencrypt.org/directory" \
--accept-tos \
--email "info@proqacf.fun" \
--path="/ssl/wildcard.dns.proqacf.fun/" \
--domains "proqacf.fun" \
--domains "*.proqacf.fun" \
--dns.resolvers 1.1.1.1:53 \
--dns.resolvers 8.8.8.8:53 \
--dns.resolvers 9.9.9.9:53 \
--dns.resolvers 1.0.0.1:53 \
--dns.resolvers 8.8.4.4:53 \
--dns cloudflare \
run
```

Ответ:
```
2025/04/30 23:24:23 No key found for account info@proqacf.fun. Generating a P256 key.
2025/04/30 23:24:23 Saved key to /ssl/wildcard.dns.proqacf.fun/accounts/acme-v02.api.letsencrypt.org/info@proqacf.fun/keys/info@proqacf.fun.key
2025/04/30 23:24:24 [INFO] acme: Registering account for info@proqacf.fun
!!!! HEADS UP !!!!

Your account credentials have been saved in your
configuration directory at "/ssl/wildcard.dns.proqacf.fun/accounts".

You should make a secure backup of this folder now. This
configuration directory will also contain certificates and
private keys obtained from the ACME server so making regular
backups of this folder is ideal.
2025/04/30 23:24:24 [INFO] [proqacf.fun, *.proqacf.fun] acme: Obtaining bundled SAN certificate
2025/04/30 23:24:25 [INFO] [*.proqacf.fun] AuthURL: https://acme-v02.api.letsencrypt.org/acme/authz/197568934/1710489XXXX
2025/04/30 23:24:25 [INFO] [proqacf.fun] AuthURL: https://acme-v02.api.letsencrypt.org/acme/authz/197568934/1710489XXXX
2025/04/30 23:24:25 [INFO] [*.proqacf.fun] acme: use dns-01 solver
2025/04/30 23:24:25 [INFO] [proqacf.fun] acme: Could not find solver for: tls-alpn-01
2025/04/30 23:24:25 [INFO] [proqacf.fun] acme: Could not find solver for: http-01
2025/04/30 23:24:25 [INFO] [proqacf.fun] acme: use dns-01 solver
2025/04/30 23:24:25 [INFO] [*.proqacf.fun] acme: Preparing to solve DNS-01
2025/04/30 23:24:27 [INFO] cloudflare: new record for proqacf.fun, ID 89d9516b6d1eb7c3dab27a614e2cXXXX
2025/04/30 23:24:27 [INFO] [proqacf.fun] acme: Preparing to solve DNS-01
2025/04/30 23:24:28 [INFO] cloudflare: new record for proqacf.fun, ID f6b4267536ad6391637367c10c27XXXX
2025/04/30 23:24:28 [INFO] [*.proqacf.fun] acme: Trying to solve DNS-01
2025/04/30 23:24:28 [INFO] [*.proqacf.fun] acme: Checking DNS record propagation. [nameservers=1.1.1.1:53,8.8.8.8:53,9.9.9.9:53,1.0.0.1:53,8.8.4.4:53]
2025/04/30 23:24:30 [INFO] Wait for propagation [timeout: 2m0s, interval: 2s]
2025/04/30 23:24:30 [INFO] [*.proqacf.fun] acme: Waiting for DNS record propagation.
2025/04/30 23:24:33 [INFO] [*.proqacf.fun] acme: Waiting for DNS record propagation.
2025/04/30 23:24:40 [INFO] [*.proqacf.fun] The server validated our request
2025/04/30 23:24:40 [INFO] [proqacf.fun] acme: Trying to solve DNS-01
2025/04/30 23:24:40 [INFO] [proqacf.fun] acme: Checking DNS record propagation. [nameservers=1.1.1.1:53,8.8.8.8:53,9.9.9.9:53,1.0.0.1:53,8.8.4.4:53]
2025/04/30 23:24:42 [INFO] Wait for propagation [timeout: 2m0s, interval: 2s]
2025/04/30 23:24:49 [INFO] [proqacf.fun] The server validated our request
2025/04/30 23:24:49 [INFO] [*.proqacf.fun] acme: Cleaning DNS-01 challenge
2025/04/30 23:24:50 [INFO] [proqacf.fun] acme: Cleaning DNS-01 challenge
2025/04/30 23:24:50 [INFO] [proqacf.fun, *.proqacf.fun] acme: Validations succeeded; requesting certificates
2025/04/30 23:24:50 [INFO] Wait for certificate [timeout: 30s, interval: 500ms]
2025/04/30 23:24:53 [INFO] [proqacf.fun] Server responded with a certificate.
```

Последняя строка в ответе `Server responded with a certificate` означает успешное выполнение задания и выпуск SSL-сертификата.

Файлы сертификатов будут расположены в папке `/ssl/wildcard.dns.proqacf.fun/`.

<a id="installpresentcerts"></a>
### Установка сертификатов

После выпуска SSL-сертификатов одним из способов выше нам нужно в SSL конфигурацию `nginx` прописать новые сертификаты.

Пример ниже для домена `proqacf.fun`, wildcard-сертификаты выпущены и содержатся в папке `/ssl/wildcard.dns.proqacf.fun/`.

Заходим в sh-консоль контейнера `nginx` из-под пользователя `root`:
```bash
docker compose exec --user=root nginx sh
```

Выполняем:
```bash
apk add mc
exit
```

Заходим в sh-консоль контейнера `nginx` из-под пользователя `bitrix`:
```bash
docker compose exec --user=bitrix nginx sh
```

Редактируем файл `/etc/nginx/ssl/ssl.conf`:
```bash
mcedit /etc/nginx/ssl/ssl.conf
```

Меняем настройки для опций `ssl_*`:
```bash
ssl_certificate /ssl/wildcard.dns.proqacf.fun/certificates/proqacf.fun.crt;
ssl_certificate_key /ssl/wildcard.dns.proqacf.fun/certificates/proqacf.fun.key;
ssl_trusted_certificate /ssl/wildcard.dns.proqacf.fun/certificates/proqacf.fun.issuer.crt;
ssl_dhparam /ssl/dhparam.pem;
```

Выходим из консоли контейнера и проверяем настройки `nginx`:
```bash
docker compose exec --user=bitrix nginx sh -c "nginx -t"
```

Если никаких ошибок нет, перезапускаем контейнер `nginx`:
```bash
docker compose restart nginx
```

Итог: после настройки выше переходим на сайт по URL с доменом `b24.proqacf.fun`, используя `https` и порт `8589` в URL:
```bash
https://b24.proqacf.fun:8589/
```

Работа сайта перешла на безопасную схему, используется `https`, `ssl`, `wss` и т.д. Никаких дополнительных манипуляций внутри контейнеров не требуется.

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
  - если пусто и ничего не указывать, берется поведение по умолчанию
  - для пользователя `bitrix` шаблон команды принимает вид `--user=bitrix`
  - для пользователя `root` шаблон команды выглядит как `--user=root`
- `сервис`: имя сервиса, указанное в файле `docker-compose.yml`, пример `mysql`, `nginx`, `php` и т.д.
- `оболочка`: тип запускаемой оболочки внутри контейнера, пример `sh`, `bash`, `ash` и т.д.

В результате возможны варианты вида:

- заходим в bash-консоль контейнера `mysql`, пользователя не указываем:
```bash
docker compose exec mysql bash
```

- заходим в sh-консоль контейнера `php` из-под пользователя `bitrix`:
```bash
docker compose exec --user=bitrix php sh
```

- заходим в sh-консоль контейнера `php` из-под пользователя `root`:
```bash
docker compose exec --user=root php sh
```

Также можно выполнять команды, указав параметр `-c` и саму команду, пример запроса `id`:
```bash
docker compose exec --user=root redis sh -c "id"
```

<a id="mysqlconsole"></a>
## MySQL

Заходим в bash-консоль контейнера `mysql`, выполняя команду входа в консоль `mysql` из-под пользователя `root` базы данных:
```bash
docker compose exec mysql bash -c "mysql -u root -p"
```

Вводим пароль суперпользователя `root`, который был создан вами в главе `Пароли к базам данных MySQL и PostgreSQL`. Его значение хранится в файле `.env_sql`.

Выполняем SQL-запросы. Для выхода вводим `exit`.

<a id="postgresqlconsole"></a>
## PostgreSQL

Заходим в bash-консоль контейнера `postgres`, выполняя команду входа в консоль `psql` из-под пользователя `postgres` базы данных:
```bash
docker compose exec --user=postgres postgres bash -c "psql"
```

Вводим пароль суперпользователя `postgres`, который был создан вами в главе `Пароли к базам данных MySQL и PostgreSQL`. Его значение хранится в файле `.env_sql`.

Выполняем SQL-запросы. Для выхода вводим `\q`.

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

Есть два пути, позволяющие это сделать:

- создать отдельный `docker-compose-my.yml` файл, разместить код внутри файла - описать тома, сервисы, сеть и т.д.

Тогда во всех командах указываем `.yml` файлы через опцию `-f`, пример:
```bash
docker compose -f docker-compose.yml -f docker-compose-my.yml ps
```

- интеграция в существующий `docker-compose.yml` файл проекта - добавить тома, сервисы, указать сеть и т.д.

Для примера, запустим [Valkey](https://hub.docker.com/r/valkey/valkey/), добавив его в проект в существующий `yml` файл.

На странице valkey на DockerHub-е находим нужный нам тег, пример `7.2.9-alpine`.

Редактируем `docker-compose.yml` файл:

- в раздел `volumes` добавляем описание тома:
```bash
  valkey_data:
    driver: local
```

- в раздел `services` добавляем описание сервиса:
```bash
  valkey:
    image: valkey/valkey:7.2.9-alpine
    container_name: dev_valkey
    restart: unless-stopped
    command: valkey-server
    env_file:
      - .env
#    ports:
#      - "6379:6379"
    volumes:
      - valkey_data:/data
    init: true
    cgroup: private
    security_opt:
      - no-new-privileges
    cap_drop:
      - ALL
    cap_add:
      - CHOWN
      - SETUID
      - SETGID
    tmpfs:
      - /tmp:noexec,nodev,nosuid
      - /var/tmp:noexec,nodev,nosuid
      - /dev/shm:noexec,nodev,nosuid
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

Итого: мы успешно запустили новый контейнер valkey, проверили его работу. Теперь его можно использовать для хранения кеша или хранения сессий по примеру, как описано выше в этом файле.

------------------------------------------------

[1С-Битрикс: Разработчикам](https://dev.1c-bitrix.ru/)
