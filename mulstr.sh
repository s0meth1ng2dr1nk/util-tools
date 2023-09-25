mul_str() {
  [ $# -ne 2 ] && return 1
  [[ ! $2 =~ ^[1-9][0-9]*$ ]] && return 1
  printf '%'$2's' | sed -e "s/ /$1/g"
}

mul_str "abc" "1"