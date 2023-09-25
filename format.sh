format() {
  [ $# -lt 1 ] && return 1
  local FORMAT=$1
  shift 1
  eval "echo ${FORMAT}"
}

A='$3 A B C D E $1 ${2} \(\)'
format "${A}"
