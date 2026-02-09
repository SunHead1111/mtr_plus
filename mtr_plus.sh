#!/usr/bin/env bash
set -euo pipefail

if ! command -v mtr >/dev/null 2>&1; then
  echo "找不到 mtr，請先安裝，例如: sudo apt install mtr-tiny 或 mtr" >&2
  exit 1
fi

ask_value() {
  local prompt="$1"
  local default_value="${2-}"
  local value=""
  if [[ -n "${default_value}" ]]; then
    read -r -p "${prompt} (預設: ${default_value}): " value
    value="${value:-$default_value}"
  else
    read -r -p "${prompt}: " value
  fi
  echo "$value"
}

ask_yn() {
  local prompt="$1"
  local default_value="${2:-n}"
  local value=""
  while true; do
    read -r -p "${prompt} [y/n] (預設: ${default_value}): " value
    value="${value:-$default_value}"
    case "$value" in
      y|Y) return 0 ;;
      n|N) return 1 ;;
    esac
  done
}

echo "mtr 互動式設定"

host=""
while [[ -z "$host" ]]; do
  host=$(ask_value "目標主機或 IP (留空則用檔案)" "")
  if [[ -z "$host" ]]; then
    file=$(ask_value "主機清單檔案路徑" "")
    if [[ -n "$file" ]]; then
      host="@file"
      filename="$file"
      break
    fi
  fi
done

args=()

echo "選擇協定: 1) ICMP  2) TCP  3) UDP"
read -r -p "輸入選項 [1-3] (預設: 1): " proto
proto="${proto:-1}"
case "$proto" in
  2) args+=("-T") ;;
  3) args+=("-u") ;;
esac

echo "選擇 IP 版本: 1) 自動  2) IPv4  3) IPv6"
read -r -p "輸入選項 [1-3] (預設: 1): " ipver
ipver="${ipver:-1}"
case "$ipver" in
  2) args+=("-4") ;;
  3) args+=("-6") ;;
esac

if ask_yn "是否設定來源介面" "n"; then
  iface=$(ask_value "介面名稱" "")
  [[ -n "$iface" ]] && args+=("-I" "$iface")
fi

if ask_yn "是否綁定來源位址" "n"; then
  addr=$(ask_value "來源位址" "")
  [[ -n "$addr" ]] && args+=("-a" "$addr")
fi

if ask_yn "是否設定目的埠" "n"; then
  port=$(ask_value "目的埠" "")
  [[ -n "$port" ]] && args+=("-P" "$port")
fi

if ask_yn "是否設定來源埠" "n"; then
  lport=$(ask_value "來源埠" "")
  [[ -n "$lport" ]] && args+=("-L" "$lport")
fi

if ask_yn "是否設定封包大小" "n"; then
  psize=$(ask_value "封包大小" "")
  [[ -n "$psize" ]] && args+=("-s" "$psize")
fi

if ask_yn "是否設定位元樣式" "n"; then
  bitpattern=$(ask_value "位元樣式" "")
  [[ -n "$bitpattern" ]] && args+=("-B" "$bitpattern")
fi

if ask_yn "是否設定間隔秒數" "y"; then
  interval=$(ask_value "間隔秒數" "1")
  [[ -n "$interval" ]] && args+=("-i" "$interval")
fi

if ask_yn "是否設定回應等待秒數" "n"; then
  gracetime=$(ask_value "回應等待秒數" "")
  [[ -n "$gracetime" ]] && args+=("-G" "$gracetime")
fi

if ask_yn "是否設定逾時秒數" "n"; then
  timeout=$(ask_value "逾時秒數" "")
  [[ -n "$timeout" ]] && args+=("-Z" "$timeout")
fi

if ask_yn "是否設定 TOS" "n"; then
  tos=$(ask_value "TOS 值" "")
  [[ -n "$tos" ]] && args+=("-Q" "$tos")
fi

if ask_yn "是否顯示 MPLS 資訊" "n"; then
  args+=("-e")
fi

if ask_yn "是否設定封包標記" "n"; then
  mark=$(ask_value "標記值" "")
  [[ -n "$mark" ]] && args+=("-M" "$mark")
fi

if ask_yn "是否設定起始 TTL" "n"; then
  first_ttl=$(ask_value "起始 TTL" "")
  [[ -n "$first_ttl" ]] && args+=("-f" "$first_ttl")
fi

if ask_yn "是否設定最大 TTL" "n"; then
  max_ttl=$(ask_value "最大 TTL" "")
  [[ -n "$max_ttl" ]] && args+=("-m" "$max_ttl")
fi

if ask_yn "是否設定未知節點上限" "n"; then
  max_unknown=$(ask_value "未知節點上限" "")
  [[ -n "$max_unknown" ]] && args+=("-U" "$max_unknown")
fi

if ask_yn "是否使用報表模式" "y"; then
  args+=("-r")
fi

if ask_yn "是否使用寬版報表" "y"; then
  args+=("-w")
fi

if ask_yn "是否設定報表次數" "y"; then
  cycles=$(ask_value "報表次數" "10")
  [[ -n "$cycles" ]] && args+=("-c" "$cycles")
fi

echo "輸出格式: 1) 一般  2) JSON  3) XML  4) CSV  5) RAW  6) SPLIT"
read -r -p "輸入選項 [1-6] (預設: 1): " fmt
fmt="${fmt:-1}"
case "$fmt" in
  2) args+=("-j") ;;
  3) args+=("-x") ;;
  4) args+=("-C") ;;
  5) args+=("-l") ;;
  6) args+=("-p") ;;
esac

if ask_yn "是否使用 curses 介面" "n"; then
  args+=("-t")
fi

if ask_yn "是否設定顯示模式" "n"; then
  dmode=$(ask_value "顯示模式" "")
  [[ -n "$dmode" ]] && args+=("--displaymode" "$dmode")
fi

if ask_yn "是否使用 GTK 介面" "n"; then
  args+=("-g")
fi

if ask_yn "是否停用 DNS 解析" "y"; then
  args+=("-n")
fi

if ask_yn "是否顯示 IP 與主機名" "y"; then
  args+=("-b")
fi

if ask_yn "是否自訂輸出欄位" "n"; then
  order_fields=$(ask_value "輸出欄位" "")
  [[ -n "$order_fields" ]] && args+=("-o" "$order_fields")
fi

if ask_yn "是否顯示 IP 資訊" "n"; then
  ipinfo=$(ask_value "IP 資訊等級" "")
  [[ -n "$ipinfo" ]] && args+=("-y" "$ipinfo")
fi

if ask_yn "是否顯示 AS 資訊" "n"; then
  args+=("-z")
fi

if [[ "${host}" == "@file" ]]; then
  args+=("-F" "$filename")
  host=""
fi

extra_line=$(ask_value "其他 mtr 參數 (可留空)" "")
if [[ -n "$extra_line" ]]; then
  read -r -a extra_args <<< "$extra_line"
  args+=("${extra_args[@]}")
fi

if [[ -n "$host" ]]; then
  exec mtr "${args[@]}" "$host"
else
  exec mtr "${args[@]}"
fi
