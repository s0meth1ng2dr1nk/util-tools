#/bin/bash
set -e

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
  eval "echo $(eval "echo $(echo $1 | sed -r 's|@\{([1-9][0-9]*)\}|\\${$((\1+1))}|g')")"
}

mulstr() {
  local _STR=$(printf '%'$2's')
  echo ${_STR// /$1}
}

create_cw() {
  local N_=$1
  local _PERCENT=$(mulstr '%' $((${SSH_NUM} - ${N_}))) && [ "${_PERCENT}" != '' ] && echo "-CW ${_PERCENT}h:${_PERCENT}p"
}

create_escape() {
  local N_=$1
  local _ESCAPE=''
  for _M in $(seq ${N_} $((${SSH_NUM} - 1))); do
    [ "${_M}" = "${N_}" ] && _ESCAPE=${QUOTE} && continue
    _ESCAPE=${QUOTE}${APOS}${_ESCAPE}${APOS}${QUOTE}
  done
  [ "${_ESCAPE}" != '' ] && echo ${_ESCAPE}
}

create_tab() {
  local N_=$1
  local _TAB=''
  for _M in $(seq ${N_} $((${SSH_NUM} - 1))); do
    _TAB=${_TAB}${SPACE}
  done

  [ "${_TAB}" != '' ] && echo ${_TAB}
}

build_ssh_format() {
  local N_=$1
  local _CW=$(create_cw ${N_})
  local _ESCAPE=$(create_escape ${N_})
  [ "${N_}" -gt 1 ] && local _PROXY_COMMAND='-o ProxyCommand='
  local _TAB=$(create_tab ${N_})
  echo "${_ESCAPE}${NEWLINE}${_TAB}sshpass -p ${DOLLER_}PASS_${N_}} ssh ${DOLLER_}USER_${N_}}@${DOLLER_}IP_${N_}} -p ${DOLLER_}PORT_${N_}} ${DOLLER_}OPT_${N_}} ${_CW} ${_PROXY_COMMAND}@{1}${NEWLINE}${_TAB/${SPACE}/}${_ESCAPE}"
}

build_var_format() {
  local N_=$1
  echo "@{1}IP_${N_}=${NEWLINE}PORT_${N_}=${NEWLINE}OPT_${N_}=${NEWLINE}USER_${N_}=${NEWLINE}PASS_${N_}=${NEWLINE}"
}

## main
VAR_FORMAT=''
SSH_FORMAT=''
for _N in $(seq 1 ${SSH_NUM}); do
  N_=$((${SSH_NUM} - ${_N} + 1))
  _SSH_FORMAT=$(build_ssh_format ${N_})
  _VAR_FORMAT=$(build_var_format ${N_})
  [ "${N_}" = "${SSH_NUM}" ] && SSH_FORMAT=${_SSH_FORMAT} && VAR_FORMAT=${_VAR_FORMAT} && continue
  SSH_FORMAT=$(format "${SSH_FORMAT}" "${_SSH_FORMAT}")
  VAR_FORMAT=$(format "${VAR_FORMAT}" "${_VAR_FORMAT}")
done
echo "${VAR_FORMAT}${SSH_FORMAT}" | sed -e "s|@{1}||g" -e "s|${APOS}|'|g" -e 's|'${QUOTE}'|"|g' -e 's|'${DOLLER_}'|${|g' -e 's|'${SPACE}'| |g' -e 's|'${NEWLINE}'|\'$'\n|g'
