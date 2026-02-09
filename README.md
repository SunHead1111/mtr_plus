# mtr_plus 使用說明

這個腳本提供 mtr 快速模式，只需輸入目標與少量數字選項，其餘直接以「完整顯示」預設跑。

## 需求

- 需要先安裝 mtr
  - Debian/Ubuntu：`sudo apt install mtr-tiny` 或 `sudo apt install mtr`
  - CentOS/RHEL：`sudo yum install mtr`

## 使用方式

```bash
./mtr_plus.sh
```

腳本會用互動式選單引導設定，只需要輸入 IP/主機與數字選項。

## 常用範例

```bash
./mtr_plus.sh
```

## 互動式設定內容

- 目標主機或 IP
- 報表次數與間隔秒數
- 協定：ICMP/TCP/UDP
- IP 版本：IPv4/IPv6/自動
- 目的埠（TCP/UDP 時）

## 預設輸出

- 報表模式 + 寬版輸出
- 顯示 IP 與主機名
- 顯示 AS 與 IP 資訊

## 小提示

- 若需要更完整的欄位說明，可用 `mtr --help`
