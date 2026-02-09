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

echo "mtr 快速模式"

host=""
while [[ -z "$host" ]]; do
  host=$(ask_value "目標主機或 IP" "")
done

cycles=$(ask_value "報表次數" "10")
interval=$(ask_value "間隔秒數" "1")

args=("-r" "-w" "-b" "-z" "-y" "1" "-c" "$cycles" "-i" "$interval")

echo "選擇協定: 1) ICMP  2) TCP  3) UDP"
read -r -p "輸入選項 [1-3] (預設: 1): " proto
proto="${proto:-1}"
case "$proto" in
  2)
    args+=("-T")
    port=$(ask_value "目的埠" "443")
    [[ -n "$port" ]] && args+=("-P" "$port")
    ;;
  3)
    args+=("-u")
    port=$(ask_value "目的埠" "53")
    [[ -n "$port" ]] && args+=("-P" "$port")
    ;;
esac

echo "選擇 IP 版本: 1) 自動  2) IPv4  3) IPv6"
read -r -p "輸入選項 [1-3] (預設: 1): " ipver
ipver="${ipver:-1}"
case "$ipver" in
  2) args+=("-4") ;;
  3) args+=("-6") ;;
esac

exec mtr "${args[@]}" "$host"
