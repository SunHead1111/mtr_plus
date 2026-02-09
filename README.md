# mtr_plus 使用說明

這個腳本封裝了 mtr 的常用與進階功能，並支援把原生參數直接傳給 mtr。

## 需求

- 需要先安裝 mtr
  - Debian/Ubuntu：`sudo apt install mtr-tiny` 或 `sudo apt install mtr`
  - CentOS/RHEL：`sudo yum install mtr`

## 使用方式

```bash
./mtr_plus.sh
```

腳本會用互動式選單引導設定，輸入主機/IP 與數字或 y/n 即可。

## 常用範例

```bash
./mtr_plus.sh
```

## 互動式設定內容

- 協定：ICMP/TCP/UDP
- IP 版本：IPv4/IPv6/自動
- 介面/來源位址/目的埠/來源埠
- 封包大小、位元樣式
- 間隔、逾時、回應等待時間
- TTL 起始/最大、未知節點上限
- 報表模式、寬版、報表次數
- 輸出格式：一般/JSON/XML/CSV/RAW/SPLIT
- curses/GTK 介面與顯示模式
- DNS 解析、顯示 IP 與主機名
- 輸出欄位順序、IP 資訊、AS 資訊
- 其他 mtr 原生參數直接透傳

## 小提示

- 其他 mtr 原生參數可直接輸入
- 若需要更完整的欄位說明，可用 `mtr --help`
