# R

## R MarkdownでのBibTexの使用

- 冒頭に、「bibliography: ref.bib」と書き入れておく。
- 「ref.bib」ファイルに文献情報を記載しておく。
- 本文で文献を引用するときは、「@joseph2022effect」のように「@key」とする。
- 自動的に文献リストが生成される。
- 参考) [4.5 参考文献と引用](https://gedevan-aleksizde.github.io/rmarkdown-cookbook/bibliography.html)

例）

```
---
title: "Bibtexの練習"
author: "田中鮎夢"
date: "2023-12-12"
output:
  html_document: default
bibliography: ref.bib
---

@joseph2022effect はハイチの研究

# 参考文献
```


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

## 会社名、企業名検索

企業名変数=name、従業員数=Lのとき
```
browse if ustrpos(name, "アサヒビール")>0

browse L if ustrpos(name, "トヨタ自動車（株）")>0
```


## 変数ラベル使って変数名変更

- エクセルで読み込んだ列1990 2000などの変数名はB, C, Dなどとなる。
- これをyear1990,year2000に変更する

```
foreach v of varlist B C{
local x : variable label `v' //変数B,Cの変数ラベル(1990,2000)をローカルxに保存
rename `v' year`x' //変数B,Cの変数名をyear1990,year2000に変更
}
```
* 参考：[Rename variable with its own label](https://www.statalist.org/forums/forum/general-stata-discussion/general/1367292-rename-variable-with-its-own-label)


## 変数名使って変数ラベル変更
```
ds
foreach v of varlist `r(varlist)' {
lab var `v' "`v'"
}
```


## 変数名リストをExcelに出力

```
sysuse auto,clear
describe, replace clear
export excel using varlist.xlsx,replace first(variables)
```
[Exporting variable names and corresponding labels](https://www.statalist.org/forums/forum/general-stata-discussion/general/1335719-exporting-variable-names-and-corresponding-labels)


## 文字列n.a.を除き、変数を数値化

```
ds , has(type string) //文字列を含む変数を特定
foreach var of varlist `r(varlist)' {
replace `var' = "" if `var' == "n.a."
replace `var' = "" if `var' == "n.s."
}
```
参考) [Replacing "NA" with missing](https://www.statalist.org/forums/forum/general-stata-discussion/general/1566228-replacing-na-with-missing)

## graph combine / grc1leg: 複数のグラフの結合。

legendが同じ時は、grc1legが便利。それ以外は、graph combineで良い。

コード例
```
 grc1leg "StataGraph/AMCE_task1.gph" /// 
 "StataGraph/AMCE_nfalse0.gph" /// 
 ,rows(1) cols(2) title("") legendfrom(StataGraph/AMCE_task1.gph)
```

コード例
```
 graph combine "StataGraph/AMCE_task1.gph" /// 
 "StataGraph/AMCE_nfalse0.gph" /// 
 ,rows(1) cols(2) title("") 
```

Stata: 複数のグラフでlegendが同じ時

一つだけlegendを表示するには、grc1legをインストールする必要あり。

optionのlegendfrom(../Figures/Unmatched/eventdd_procure_employment.gph)でどのグラフのlegendを使うか指定する。

新しいgrc1leg2もあるよう。

公式のgr combineではできない。

コード例
```
*net install grc1leg,from( http://www.stata.com/users/vwiggins/) 

grc1leg "../Figures/Unmatched/eventdd_procure_employment.gph" /// 
 "../Figures/Unmatched/eventdd_procure_sales.gph" /// 
 "../Figures/Unmatched/eventdd_procure_productivity.gph" /// 
 "../Figures/matched/eventdd_procure_employment_psmatch.gph" /// 
 "../Figures/matched/eventdd_procure_sales_psmatch.gph" /// 
 "../Figures/matched/eventdd_procure_productivity_psmatch.gph" /// 
 ,rows(3) cols(3) title("Transaction type: Procure") legendfrom(../Figures/Unmatched/eventdd_procure_employment.gph)
```

[https://www.techtips.surveydesign.com.au/post/combining-graphs-and-including-a-common-legend-in-stata](https://www.techtips.surveydesign.com.au/post/combining-graphs-and-including-a-common-legend-in-stata)

[https://www.statalist.org/forums/forum/general-stata-discussion/general/1654767-combined-graphs-with-a-single-legend-update-of-grc1leg2-to-version-2-11](https://www.statalist.org/forums/forum/general-stata-discussion/general/1654767-combined-graphs-with-a-single-legend-update-of-grc1leg2-to-version-2-11)


## texで複数のグラフを配置

### コード例1)２つのグラフ
```
\begin{figure}[htbp]
    \begin{tabular}{cc}
         \begin{minipage}[t]{0.45\hsize}
        \centering
        \includegraphics[width = 6 cm]{fig/Fig04_KOR_all.jpg}
        \subcaption{Korea}
        \label{KOR}
      \end{minipage} &
      \begin{minipage}[t]{0.45\hsize}
        \centering
        \includegraphics[width = 6 cm]{fig/Fig04_USA_all.jpg}
        \subcaption{USA}
        \label{USA}
      \end{minipage} 
    \end{tabular}
\caption{Evolving distribution of Japanese firms' ownership ratio in Korea and USA, 1990--2018. \label{fig:distribution}}

\footnotesize{Source: Authors' compilation based on Toyo Keizai Inc.'s OJC data.}

\footnotesize{Notes: The line inside the box indicates the median, while the lower and upper hinges of the box indicate the 25th and 75th percentiles, respectively. The lower and upper adjacent lines of the whiskers show the lower and upper adjacent values that are the furthest observations that are within 1.5 times the interquartile range. The dots indicate the outside values.}

  \end{figure}
```

### コード例2)４つのグラフ
```
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\begin{figure}[htbp]
    \begin{tabular}{cc}
      \begin{minipage}[t]{0.45\hsize}
        \centering
        \includegraphics[width = 6 cm]{fig2_trend_average_ratio.eps}
        \subcaption{All}
        \label{composite}
      \end{minipage} &
      \begin{minipage}[t]{0.45\hsize}
        \centering
        \includegraphics[width = 6 cm]{fig2_trend_average_ratio_CHN.eps}
        \subcaption{China}
        \label{Gradation}
      \end{minipage} \\
   
      \begin{minipage}[t]{0.45\hsize}
        \centering
        \includegraphics[width = 6 cm]{fig2_trend_average_ratio_THA.eps}
        \subcaption{Thailand}
        \label{fill}
      \end{minipage} &
      \begin{minipage}[t]{0.45\hsize}
        \centering
        \includegraphics[width = 6 cm]{fig2_trend_average_ratio_USA.eps}
        \subcaption{USA}
        \label{transform}
      \end{minipage} 
    \end{tabular}
\caption{Number of new foreign subsidiaries and their average ownership ratio in manufacturing, 1989--2016. \label{fig:trend3}}

\footnotesize{Source: Authors' compilation based on Toyo Keizai Inc.'s OJC data.}
  \end{figure}

%des03_trend.do, des04_trend_by_country.do
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
```

## 国名から国名コード（ISO3など）の変数作成
### 例1
```
ssc install kountry
use "kountry.dta",clear

*ISO2桁コードからISO3桁コード（_ISO3C_）の生成
kountry CountryISOCode,from(iso2c) to(iso3c)

*ISO2桁コードから国名（NAMES_STD）の生成
kountry CountryISOCode,from(iso2c)
```
### 例2
```
ssc install kountry

kountry Country, from(other) stuck //国名コード番号_ISO3N_ 作成
rename _ISO3N_ ison
kountry ison, from(iso3n) to(iso3c) //国名コード番号から国名コード作成
rename _ISO3C_ countrycode
```
[kountry: A Stata utility for merging cross-country data from multiple sources](https://www.stata-journal.com/article.html?article=dm0038)

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

** 月次変数の作成例 **

```
g ym1="2018m01"
g ym=monthly(ym,"YM")
format ym %tm
drop ym1
```

参考) [チート・シート](https://surveydesign.com.au/docs/stata/stata-dates-and-times-cheat-sheet.pdf)

### weekly data

- Stataで2020/9/2 ~ 2020/9/8といった週次データを扱うには、まず~の手前の2020/9/2を取り出す。
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

### Stata: 年齢や日数計算

* 東京で初めてコロナが確認されてからの年数
```
display age(td(25jan2020), td(27dec2021))
```
* 東京で初めてコロナが確認されてからの月数
```
display datediff(td(24jan2020), td(27dec2021), "month")
```
* 東京で初めてコロナが確認されてからの日数
```
display datediff(td(24jan2020), td(27dec2021), "day")
```
 
参考）[New date and time functions](https://www.stata.com/new-in-stata/date-time-functions/)

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

