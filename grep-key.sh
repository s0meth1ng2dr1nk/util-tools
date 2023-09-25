make_grep_key() {
  [ $# -ne 3 ] && return 1
  local S_VAL="$1"
  local F_STR="$2"
  local L_STR="$3"
  F_LEN=${#F_STR}
  L_LEN=${#L_STR}
  F_STR="$(echo ${F_STR} | sed -e 's#/#@SLASH#g')"
  L_STR="$(echo ${L_STR} | sed -e 's#/#@SLASH#g')"
  echo "${S_VAL}" | sed -e 's/^ */ /g' -e 's/ *$/ /g' -e "s/ /${L_STR}|${F_STR}/g" -e 's#@SLASH#/#g' -e "s/^..\{${L_LEN}\}//" -e "s/..\{${F_LEN}\}$//g"
}

A=(A B C D E)
make_grep_key "${A[*]}" '/"/' "bc"