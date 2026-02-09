#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
用法: ./mtr_plus.sh <host> [選項] [-- 其他 mtr 參數]

常用選項:
  -r, --report             報表模式
  -w, --wide               寬版輸出
  -c, --count N            測試次數
  -i, --interval SEC       間隔秒數
  -t, --timeout SEC        逾時秒數
  -n, --no-dns             不解析 DNS
  -a, --address IP         綁定來源位址
  -p, --port N             TCP/UDP 目的埠
  -T, --tcp                使用 TCP
  -U, --udp                使用 UDP
  -I, --icmp               使用 ICMP
  -4, --ipv4               強制 IPv4
  -6, --ipv6               強制 IPv6
  -o, --order FIELDS       自訂輸出欄位
  -b, --both               顯示 IP 與主機名
      --aslookup           顯示 AS 資訊
      --json               JSON 輸出
      --csv                CSV 輸出
      --xml                XML 輸出
      --help               顯示說明

範例:
  ./mtr_plus.sh 1.1.1.1 -r -c 100 -i 0.2
  ./mtr_plus.sh example.com -T -p 443 -r --json
  ./mtr_plus.sh 8.8.8.8 -- -G 1 -F 2
EOF
}

if ! command -v mtr >/dev/null 2>&1; then
  echo "找不到 mtr，請先安裝，例如: sudo apt install mtr-tiny 或 mtr" >&2
  exit 1
fi

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

host="$1"
shift

args=()
extra=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help)
      usage
      exit 0
      ;;
    --)
      shift
      while [[ $# -gt 0 ]]; do
        extra+=("$1")
        shift
      done
      ;;
    -r|--report) args+=("-r"); shift ;;
    -w|--wide) args+=("-w"); shift ;;
    -c|--count) args+=("-c" "$2"); shift 2 ;;
    -i|--interval) args+=("-i" "$2"); shift 2 ;;
    -t|--timeout) args+=("-t" "$2"); shift 2 ;;
    -n|--no-dns) args+=("-n"); shift ;;
    -a|--address) args+=("-a" "$2"); shift 2 ;;
    -p|--port) args+=("-P" "$2"); shift 2 ;;
    -T|--tcp) args+=("-T"); shift ;;
    -U|--udp) args+=("-U"); shift ;;
    -I|--icmp) args+=("-I"); shift ;;
    -4|--ipv4) args+=("-4"); shift ;;
    -6|--ipv6) args+=("-6"); shift ;;
    -o|--order) args+=("-o" "$2"); shift 2 ;;
    -b|--both) args+=("-b"); shift ;;
    --aslookup) args+=("--aslookup"); shift ;;
    --json) args+=("--json"); shift ;;
    --csv) args+=("--csv"); shift ;;
    --xml) args+=("--xml"); shift ;;
    *)
      extra+=("$1")
      shift
      ;;
  esac
done

exec mtr "${args[@]}" "${extra[@]}" "$host"
