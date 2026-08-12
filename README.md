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

## 發布 GitHub Release

推送 `v` 開頭的版本 tag 時，GitHub Actions 會使用固定版本且經 SHA-256 驗證的
mdBook 工具建置兩種語言的 PDF。Tag 版本必須和英文、繁體中文封面的版本相同。
兩個 PDF 都建置成功後，workflow 才會發布 GitHub Release 並附加 PDF：

```bash
git tag v1.14.3
git push origin v1.14.3
```

也可以從 GitHub Actions 手動執行 **Build release PDFs**。手動執行只會保留
30 天的 workflow artifact，不會建立 GitHub Release。
