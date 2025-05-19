#!/bin/bash
#
# Push Server on NodeJS variables
#
# REDIS_HOST - redis host
# REDIS_PORT - redis port
#
# PUSH_SECURITY_KEY - push security key
# PUSH_PUB_MODE - push pub
# PUSH_PUB_PORT - push pub port
# PUSH_SUB_MODE - push sub
# PUSH_SUB_PORT - push sub port
#
# RUN_DIR - temporary directory for service; default /tmp/push-server
# PUB_URI - pub service uri
# REST_URI - rest service uri
# SUB_URI - sub service uri
#
export WORKDIR=/opt/push-server
export CONFIG_DIR=/etc/push-server
PUB_TMPL=$CONFIG_DIR/push-server-pub.json
SUB_TMPL=$CONFIG_DIR/push-server-sub.json
CONFIG=$CONFIG_DIR/config.json
export LOG_DIR=/var/log/push-server
[[ -z $RUN_DIR ]] && RUN_DIR=/tmp/push-server
export RUN_DIR
#
log() {
    msg="${1}"
    printf "%-16s: [%d]> %s\n" "$(date +%Y/%m/%dT%H:%M)" "$$" "$msg"
}
#
error() {
    msg="${1}"
    rtn="${2:-1}"
    log "$msg"
    exit $rtn
}
#
pushd $WORKDIR || error "Cannot access $WORKDIR"
[[ -z $PUSH_PUB_MODE && -z $PUSH_SUB_MODE ]] && error "Not defind push-server mode environment variables: PUSH_PUB_MODE or PUSH_SUB_MODE"
[[ $PUSH_PUB_MODE != "pub" && -z $PUSH_SUB_MODE ]] && error "Incorrect value in PUSH_PUB_MODE=$PUSH_PUB_MODE variable"
[[ -z $PUSH_PUB_MODE && $PUSH_SUB_MODE != "sub" ]] && error "Incorrect value in PUSH_SUB_MODE=$PUSH_SUB_MODE variable"
#
if [[ $PUSH_PUB_MODE == "pub" ]];
then
    log "PUSH_PUB_MODE=$PUSH_PUB_MODE"
    TEMPLATE=$PUB_TMPL
    [[ -z $REST_URI ]] && REST_URI="/bitrix/rest/"
    [[ -z $PUB_URI ]] && PUB_URI="/bitrix/pub/"
    log "REST_URI=$REST_URI"
    log "PUB_URI=$PUB_URI"
    export REST_URI
    export PUB_URI
elif [[ $PUSH_SUB_MODE == "sub" ]];
then
    log "PUSH_SUB_MODE=$PUSH_SUB_MODE"
    TEMPLATE=$SUB_TMPL
    [[ -z $SUB_URI ]] && SUB_URI="/bitrix/subws/"
    log "SUB_URI=$SUB_URI"
    export SUB_URI
fi
#
popd
#
log "Create $CONFIG"
envsubst <$TEMPLATE >$CONFIG
#
log "Start server"
node server.js --config $CONFIG
#
