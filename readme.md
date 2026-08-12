文件連結： [https://botnana.github.io/botnana-book/](https://botnana.github.io/botnana-book/)

PDF 檔案下載連結: [https://drive.google.com/file/d/17MOBkEqNVOuN4Zg8fdbMBsCs7Ws-be-H/view?usp=sharing](https://drive.google.com/file/d/17MOBkEqNVOuN4Zg8fdbMBsCs7Ws-be-H/view?usp=sharing)

## 建置 HTML 與 PDF

建置前需要安裝 `mdbook`、`mdbook-pdf`，以及 Google Chrome 或 Chromium：

```bash
cargo install mdbook
cargo install mdbook-pdf
```

在 repository 根目錄執行：

```bash
./build-book.bash
```

成功後會更新繁體中文網站 `docs/`，並產生：

```text
botnana-book_en-us.pdf
botnana-book_zh-tw.pdf
```

所有語言和格式都成功建置後才會取代既有輸出；建置失敗不會刪除目前發布的
網站或 PDF。
