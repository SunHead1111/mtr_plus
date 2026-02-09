# mtr_plus 使用說明

這個腳本封裝了 mtr 的常用與進階功能，並支援把原生參數直接傳給 mtr。

## 需求

- 需要先安裝 mtr
  - Debian/Ubuntu：`sudo apt install mtr-tiny` 或 `sudo apt install mtr`
  - CentOS/RHEL：`sudo yum install mtr`

## 使用方式

```bash
./mtr_plus.sh <host> [選項] [-- 其他 mtr 參數]
```

## 常用範例

```bash
./mtr_plus.sh 1.1.1.1 -r -c 100 -i 0.2
./mtr_plus.sh example.com -T -p 443 -r --json
./mtr_plus.sh 8.8.8.8 -- -G 1 -F 2
```

## 參數說明

- `-r, --report`：報表模式
- `-w, --wide`：寬版輸出
- `-c, --count N`：測試次數
- `-i, --interval SEC`：間隔秒數
- `-t, --timeout SEC`：逾時秒數
- `-n, --no-dns`：不解析 DNS
- `-a, --address IP`：綁定來源位址
- `-p, --port N`：TCP/UDP 目的埠
- `-T, --tcp`：使用 TCP
- `-U, --udp`：使用 UDP
- `-I, --icmp`：使用 ICMP
- `-4, --ipv4`：強制 IPv4
- `-6, --ipv6`：強制 IPv6
- `-o, --order FIELDS`：自訂輸出欄位
- `-b, --both`：顯示 IP 與主機名
- `--aslookup`：顯示 AS 資訊
- `--json`：JSON 輸出
- `--csv`：CSV 輸出
- `--xml`：XML 輸出

## 小提示

- `--` 後面的內容會原樣傳給 mtr
- 若需要更完整的欄位說明，可用 `mtr --help`
