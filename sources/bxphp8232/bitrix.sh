#!/bin/sh
#
if [[ -f /opt/www/bitrix/.settings.php ]];
then
    if [[ ! -f /opt/www/install.config && ! -f /opt/www/license.php && ! -f /opt/www/readme.php ]];
    then
        su - bitrix -c 'php -f /opt/www/bitrix/modules/main/tools/cron_events.php; > /dev/null 2>&1'
    fi
fi
#
