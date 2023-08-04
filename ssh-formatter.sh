#/bin/bash
set -eu

## usage
[ $# -ne 1 ] && echo 'USAGE: bash ssh-formatter.sh ${SSH_NUM}' && exit

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
  local _FORMAT=$1
  eval "echo $(eval "echo $(echo ${_FORMAT} | sed -r 's|@\{([1-9][0-9]*)\}|\\${$((\1+1))}|g')")"
}

create_cw() {
  [ $# -ne 1 ] && return
  local _N=$1
  local _PERCENT=''
  for _M in $(seq ${_N} $((${SSH_NUM} - 1))); do
    _PERCENT=''${_PERCENT}'%'
  done
  [ "${_PERCENT}" != '' ] && echo "-CW ${_PERCENT}h:${_PERCENT}p"
}

create_escape() {
  [ $# -ne 1 ] && return
  local _N=$1
  local _ESCAPE=''
  for _M in $(seq ${_N} $((${SSH_NUM} - 1))); do
    [ "${_M}" = "${_N}" ] && _ESCAPE=${QUOTE} && continue
    _ESCAPE=${QUOTE}${APOS}${_ESCAPE}${APOS}${QUOTE}
  done
  [ "${_ESCAPE}" != '' ] && echo ${_ESCAPE}
}

create_proxy_command() {
  [ $# -ne 1 ] && return
  local _N=$1
  local _PROXY_COMMAND='-o ProxyCommand='
  [ "${_N}" != '1' ] && echo ${_PROXY_COMMAND} 
}

create_tab() {
  [ $# -ne 1 ] && return
  local _N=$1
  local _FIRST_TAB=''
  for _M in $(seq ${_N} $((${SSH_NUM} - 1))); do
    _FIRST_TAB=${_FIRST_TAB}${SPACE}
  done
  [ "${_FIRST_TAB}" != '' ] && echo ${_FIRST_TAB}
}

build_ssh_format() {
  [ $# -ne 1 ] && return
  local _N=$1
  local _CW=$(create_cw ${_N})
  local _ESCAPE=$(create_escape ${_N})
  local _PROXY_COMMAND=$(create_proxy_command ${_N})
  local _TAB=$(create_tab ${_N})
  echo "${_ESCAPE}${NEWLINE}${_TAB}sshpass -p ${DOLLER_}PASS_${_N}} ssh ${DOLLER_}USER_${_N}}@${DOLLER_}IP_${_N}} -p ${DOLLER_}PORT_${_N}} ${DOLLER_}OPT_${_N}} ${_CW} ${_PROXY_COMMAND}@{1}${NEWLINE}${_TAB/${SPACE}/}${_ESCAPE}"
}

build_var_format() {
  [ $# -ne 1 ] && return
  local _N=$1
  echo "@{1}IP_${_N}=${NEWLINE}PORT_${_N}=${NEWLINE}OPT_${_N}=${NEWLINE}USER_${_N}=${NEWLINE}PASS_${_N}=${NEWLINE}"
}

## main
VAR_FORMAT=''
SSH_FORMAT=''
for _N in $(seq 1 ${SSH_NUM}); do
  _N=$((${SSH_NUM} - ${_N} + 1))
  _SSH_FORMAT=$(build_ssh_format ${_N})
  _VAR_FORMAT=$(build_var_format ${_N})
  [ "${_N}" = "${SSH_NUM}" ] && SSH_FORMAT=${_SSH_FORMAT} && VAR_FORMAT=${_VAR_FORMAT} && continue
  SSH_FORMAT=$(format "${SSH_FORMAT}" "${_SSH_FORMAT}")
  VAR_FORMAT=$(format "${VAR_FORMAT}" "${_VAR_FORMAT}")
done
echo "${VAR_FORMAT}${SSH_FORMAT}" | sed -e "s|@{1}||g" -e "s|${APOS}|'|g" -e 's|'${QUOTE}'|"|g' -e 's|'${DOLLER_}'|${|g' -e 's|'${SPACE}'| |g' -e 's|'${NEWLINE}'|\'$'\n|g'
