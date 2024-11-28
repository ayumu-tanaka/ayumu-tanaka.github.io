---
layout: default
---

# その他メモ
---

- [その他メモ](#その他メモ)
- [VS code](#vs-code)
  - [２画面表示](#２画面表示)
- [Overleaf](#overleaf)
  - [マルチカーソル](#マルチカーソル)
  - [日本語論文の設定](#日本語論文の設定)



# VS code
## ２画面表示
- Command + Shift + n

<a id="Overleaf"></a>

# Overleaf
## [マルチカーソル](https://twitter.com/toddrjones/status/1690031631111946240?s=20)
- hold down Option and drag the cursor.
- Hold down Command (⌘) and click

## 日本語論文の設定

ドキュメントクラスは以下のいずれかにする
```
\documentclass{jsarticle}
```

```
\documentclass[uplatex]{jsarticle}
```

latexmkrcという名前のファイルに以下の内容をコピー。
```
$latex = 'uplatex';
$bibtex = 'upbibtex';
$dvipdf = 'dvipdfmx %O -o %D %S';
$makeindex = 'mendex -U %O -o %D %S';
$pdf_mode = 3; 
```


- [Overleafを使った日本語論文の作成](https://qiita.com/fujino-fpu/items/d92d185da730e25743cb)

