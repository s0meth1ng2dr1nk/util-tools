#/bin/bash
set -e

## usage
usage() {
  echo 'USAGE: bash ssh-formatter.sh [number of hosts]'
  exit 1
}
[ $# -ne 1 ] && usage
[ $1 -le 1 ] && usage 

## vars
SSH_NUM=$1
APOS=@APOS
QUOTE=@QUOTE
DOLLER_=@{
NEWLINE=@NL
SPACE=@SPACE
LF=$(printf '\n_');LF=${LF%_}

## func
format() {
  eval "echo $(eval "echo $(echo $1 | sed -r 's|@\{([1-9][0-9]*)\}|\\${$((\1+1))}|g')")"
}
mulstr() {
  [ $2 -gt 0 ] && \
   local _STR=$(printf '%'$2's')
  echo ${_STR// /$1}
}
build_ssh_format() {
  local N_=$1
  [ ${N_} -lt ${SSH_NUM} ] && \
    local _MUL_NUM=$((${SSH_NUM} - ${N_})) && \
    local _MUL_NUM_1=$((${_MUL_NUM} - 1)) && \
    local _PERCENT=$(mulstr % ${_MUL_NUM}) && \
    local _CW="-CW ${_PERCENT}h:${_PERCENT}p" && \
    local _TAB=$(mulstr ${SPACE} ${_MUL_NUM}) && \
    local _ESCAPE=$(mulstr ${QUOTE}${APOS} ${_MUL_NUM_1})${QUOTE}$(mulstr ${APOS}${QUOTE} ${_MUL_NUM_1})
  [ ${N_} -gt 1 ] && \
    local _PROXY_COMMAND='-o ProxyCommand='
  echo "${_ESCAPE}${NEWLINE}${_TAB}sshpass -p ${DOLLER_}PASS_${N_}} ssh ${DOLLER_}USER_${N_}}@${DOLLER_}IP_${N_}} -p ${DOLLER_}PORT_${N_}} ${DOLLER_}OPT_${N_}} ${_CW} ${_PROXY_COMMAND}@{1}${NEWLINE}${_TAB/${SPACE}/}${_ESCAPE}"
}
build_config_format() {
  local N_=$1
  echo "@{1}## config${N_}${NEWLINE}HOST${N_}=${NEWLINE}PORT${N_}=${NEWLINE}OPT${N_}=${NEWLINE}USER${N_}=${NEWLINE}PASS${N_}=${NEWLINE}"
}

## main
CONFIG_FORMAT=$(build_config_format ${SSH_NUM})
SSH_FORMAT=$(build_ssh_format ${SSH_NUM})
for ((N_=$((${SSH_NUM} - 1)); N_ > 0; N_--)); do
  CONFIG_FORMAT=$(format "${CONFIG_FORMAT}" "$(build_config_format ${N_})")
  SSH_FORMAT=$(format "${SSH_FORMAT}" "$(build_ssh_format ${N_})")
done
echo "${CONFIG_FORMAT}${NEWLINE}## ssh${SSH_FORMAT}" | sed -e "s|@{1}||g" -e "s|${APOS}|'|g" -e 's|'${QUOTE}'|"|g' -e 's|'${DOLLER_}'|${|g' -e 's|'${SPACE}'| |g' -e 's|'${NEWLINE}'|\'$'\n|g'
