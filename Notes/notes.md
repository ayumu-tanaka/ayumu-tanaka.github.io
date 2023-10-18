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

### Stata: 日付、年月の処理
- 例えば、東京都のCovid-19データでは、公表_年月日が「2020-01-24」として記録されている。
- ここから、年、月、日を取り出すStataコードは以下の通り。なお、Stataでは、1960年1月1日を日付の起点としている。

```
*insheet using https://stopcovid19.metro.tokyo.lg.jp/data/130001_tokyo_covid19_patients.csv,clear  
insheet using https://ayumu-tanaka.github.io/Notes/130001_tokyo_covid19_patients.csv,clear

**YEAR 年次  
gen y=substr(公表_年月日,1,4)  
destring y,replace  

*Date　日付  
gen ymd=date(公表_年月日,"YMD")  
format ymd %td  

*Month　月次  
gen m = mofd(ymd)  
format m %tm  

*Days 経過日数1  
gen days=date(公表_年月日,"YMD")  
label variable days "days since 01jan1960"  

*Days since the first Covid　経過日数2  
g cdays=days-21937
```
参考）[Changing Daily Data into Monthly Data](https://www.statalist.org/forums/forum/general-stata-discussion/general/1395273-changing-daily-data-into-monthly-data)

- 逆に"2020m1"のような月次データから年、月を取り出す際は、
- まず、monthly関数で文字列2020m1"を時間に変換し、
- いったんdofm関数で日付変数を作成する：

```
g m=monthly(ym,"YM")  
format m %tm  

gen date = dofm(m)  
format date %d  

gen yr=year(date)  

gen month=month(date)  
format month %tm
```

参考）[HOW CAN I EXTRACT MONTH AND YEAR COMPONENT FROM A VARIABLE WITH %TM FORMAT?](https://stats.idre.ucla.edu/stata/faq/how-can-i-extract-month-and-year-component-from-a-variable-with-tm-format/)

- 曜日を日付から取り出すときは、dow関数を用いる。
```
gen week_days = dow(daily_date )
```
参考）[How to find the day of the week](https://www.statalist.org/forums/forum/general-stata-discussion/general/1487487-how-to-find-the-day-of-the-week)

- 作成した時間変数をif 関数で指定するときには時間関数が必要。
- 例) m==2021m7を指定したいときは、tm関数を用いてif関数で指定
```
browse if m==tm(2021m7)
```
- 例) ymd==13sep2021を指定したいときは、td関数を用いてif関数で指定
```
browse if ymd==td(13sep2021)
```
参考) [Statalist](https://www.stata.com/statalist/archive/2011-08/msg00363.html)

- 移動平均など計算する際に便利なように欠けている日付を埋める
```
tsfill, full
```

** 年、月別の変数から月別の変数を生成する。**

```
*年(2020)と月(1)から年月(2020m1)作成  
gen ym = ym(year, m)   
format ym %tm
```
参考) [Generating Monthly variable from Year and Month separate Variables.](https://www.statalist.org/forums/forum/general-stata-discussion/general/1582789-generating-monthly-variable-from-year-and-month-separate-variables)

参考) [チート・シート](https://surveydesign.com.au/docs/stata/stata-dates-and-times-cheat-sheet.pdf)

### weekly data

- Stataで2020/9/2~2020/9/8といった週次データを扱うには、まず~の手前の2020/9/2を取り出す。
```
split Week, parse("~") limit(1) gen(startdate)
```
- その上で、日変数を作成する。
```
gen ymd=date(startdate1,"YMD")
format ymd %td
```
- さらに週変数を作成する
```
gen w=wofd(ymd)
format w %tw
```
参考）[How to get a substring that ends before a certain symbol](https://stackoverflow.com/questions/25029862/how-to-get-a-substring-that-ends-before-a-certain-symbol)

- 時系列認証はweeklyでは"repeated time values in sample"となる可能性があるので、dailyでやる方が無難
```
tsset ymd
```

参考）[How to declare weekly data as time series data in Stata 15](https://www.statalist.org/forums/forum/general-stata-discussion/general/1481482-how-to-declare-weekly-data-as-time-series-data-in-stata-15)

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

