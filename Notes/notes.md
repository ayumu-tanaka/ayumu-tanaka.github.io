# R
## data.table
- 大規模データの読み込み
- [https://okumuralab.org/~okumura/stat/datatable.html](https://okumuralab.org/~okumura/stat/datatable.html)
- [http://kohske.github.io/ESTRELA/201410/index.html](http://kohske.github.io/ESTRELA/201410/index.html)

## here
- パッケージhereは、相対パスを使うためのもの。
- Posit Cloudでは、hereはルートディレクトリーを"/cloud/project"と認識。
- 例えば、"/cloud/project/qss/INTRO/UNpop.csv"を読み込む時は、以下のようにする。

```
#データの読み込み例
library(here)
a <- read.csv(here("qss", "INTRO", "UNpop.csv"))
```

- 作業ディレクトリ自体をサブフォルダ"/cloud/project/qss/INTRO"に変更するには、以下のようにする。

```
#作業ディレクトリの変更(1)
library(here)
setwd(here("qss", "INTRO"))
getwd()
```

```
#作業ディレクトリの変更(2)
library(here)
i_am("qss/INTRO/chap01.Rmd") #Rマークダウンがある場所をルートディレクトリからの相対パスとして表現
setwd(here("qss", "INTRO"))
getwd()
```


# Stata
## Stataの時間処理

### Stata: Excelのシリアル値形式の日付の変換
- Excelのシリアル値形式の日付（1900年1月1日からの日数=シリアル値、例：42776）をStataで通常の日付表示（例：12feb2017）に変換する。
```
generate stata`var' = `var' + td(30dec1899)
format stata`var' %td
```
[Format dates from serial number to date format](https://www.statalist.org/forums/forum/general-stata-discussion/general/1610701-format-dates-from-serial-number-to-date-format)

- さらに日付から年を取り出すには、以下のようなコマンドを使う
```
gen year_of_birth = year(month_year_of_birth)
```
[Convert date into years](https://www.statalist.org/forums/forum/general-stata-discussion/general/1355783-convert-date-into-years)


## Stata VS codeからの実行
- stataRunをインストール。StataMPに変更。
- shift+command+aでRun All

## 相関行列のLatex形式のテーブル

```
estpost correlate price mpg rep78, matrix listwise
esttab using correlationresults.csv, replace unstack not noobs compress b(2) nonote label
```

- [https://thedatahall.com/reporting-publication-style-correlation-tables-in-stata/](https://thedatahall.com/reporting-publication-style-correlation-tables-in-stata/)

## 複数行の注があるLatex形式のテーブル（方法1）
latexでthreeparttableパッケージを使用。
```
\usepackage{threeparttable}
```
esttab で以下のようにpostfootを利用。
```
	esttab modelA modelB   ///
	using "../Tables/table_baseline.tex",b(3) se(3) bracket  ///
	drop(*cty_* *indcode* *year* _cons)  ///
	mtitle(All OECD Non-OECD All OECD Non-OECD)  compress booktab replace label  ///
	title(Baseline fractional logit results \label{baseline}) ///
postfoot("\hline\hline \end{tabular} \begin{tablenotes} \footnotesize \item Notes: Robust standard errors are clustered by parent firm. Dep. var.: Parent firms' ownership ratio of foreign subsidiaries ($ t $). Columns (1)--(5) are estimated by the fractional logit model. Host countries' log GDP, log per capita GDP, level of IPR protection, and financial development are included in the estimation. * 10\% level, ** 5\% level, and *** 1\% level. \end{tablenotes} \end{table}")   /// 
	scalars( "N Obs." "NA N of Subsidiaries" "NP N of Parent firms" "NB N of Banks"   "NC N of Countries"  "ymean Mean of Dep. Var." "FEC Country FE" "FEI Parent Industry FE" "FEY Year FE") sfmt(3) ///
	star(* 0.1 ** 0.05 *** 0.01) nonotes eqlabels(" ") ///
	mgroups("Baseline" "Extended model", pattern(1 0 0  1 0 0) ///
	prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
```

[Export a LaTeX three part table using esttab](https://gist.github.com/luizaandrade/a9b830f4284b414ffe8d8271a83cbbe9)


## 複数行の注があるLatex形式のテーブル（方法2）
- 「\newcommand{\tabnotes}[2]{\bottomrule \multicolumn{#1}{@{}p{0.70\linewidth}@{}}{\footnotesize #2 }\end{tabular}\end{table}}」をLatexに加えた上で、Stataで以下のように、postfoot("\tabnotes{6}{ Notes: ABCDEFG.}")をesttabに加える。推定結果表の列数が6列でなければ、適切な列数を{}内に指定する。
```
	esttab model1 using "../Tables/TableXX_reg2018.tex",b(3) se(3) bracket ///
	drop(_cons )  ///
	 compress booktab replace label  ///
	title(Gravity equations \label{regression1}) ///
		postfoot("\tabnotes{6}{ Notes: Robust standard errors are clustered by the host country. * 10\% level, ** 5\% level, and *** 1\% level.}") ///
	  sfmt(3) ///
		star(* 0.1 ** 0.05 *** 0.01) nonotes eqlabels(" ")
```
- [https://www.hargaden.com/enda/long-or-multiple-line-notes-in-esttab-with-automatic-wrapping/](https://www.hargaden.com/enda/long-or-multiple-line-notes-in-esttab-with-automatic-wrapping/)


# VS code
## ２画面表示
- Command + Shift + n

# Overleaf
## [マルチカーソル](https://twitter.com/toddrjones/status/1690031631111946240?s=20)
- hold down Option and drag the cursor.
- Hold down Command (⌘) and click

# 日本語論文の設定

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

