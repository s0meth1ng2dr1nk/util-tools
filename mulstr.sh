mul_str() {
  [ $# -ne 2 ] && exit 1
  [[ ! $2 =~ ^[1-9][0-9]*$ ]] && exit 1
  printf '%'$2's' | sed -e "s/ /$1/g"
}

mul_str "abc" "1"