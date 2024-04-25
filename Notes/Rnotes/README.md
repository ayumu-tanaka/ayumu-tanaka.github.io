Rメモ
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

# `$`と`[[]]`の使い方

- `$`と`[[]]`のいずれを使っても、データの中の特定の変数を指定できる。
- どちらもBase Rのオペレーター。
- 既存変数の対数を作成する例。
- `[[]]`を使う場合、変数名を引用符で囲む必要があることに注意。例）“wage”

``` r
# AERパッケージのデータを使う
library(AER)
#> Loading required package: car
#> Loading required package: carData
#> Loading required package: lmtest
#> Loading required package: zoo
#> 
#> Attaching package: 'zoo'
#> The following objects are masked from 'package:base':
#> 
#>     as.Date, as.Date.numeric
#> Loading required package: sandwich
#> Loading required package: survival
data("CPS1985")

# `$`を用いた変数の指定
CPS1985$lnwage1 = log(CPS1985$wage)

head(CPS1985$lnwage1)
#> [1] 1.629241 1.599388 1.897620 1.386294 2.014903 2.570320

# [[]]を用いた変数の指定
CPS1985[["lnwage2"]] = log(CPS1985[["wage"]])

head(CPS1985$lnwage2)
#> [1] 1.629241 1.599388 1.897620 1.386294 2.014903 2.570320
```

# 複数の変数の対数をとる。

``` r
# 既存データを一旦削除
rm(list =ls())

# AERパッケージのデータを使う
library(AER)
data("CPS1985")

# 対数変換したい変数のリスト
variables <- c("age", "wage")

for (var in variables) {
  # 新しい変数名
  new_var_name <- paste0("ln", var) 
  # 対数変換
  CPS1985[[new_var_name]] <- log(CPS1985[[var]])
}

head(CPS1985$lnwage)
#> [1] 1.629241 1.599388 1.897620 1.386294 2.014903 2.570320

head(CPS1985$lnage)
#> [1] 3.555348 4.043051 2.944439 3.091042 3.555348 3.332205

#CPS1985 <- data.frame(CPS1985) 
```

# Rマークダウンからマークダウンを生成

YAMLの例

    ---
    title: Rメモ
    output: github_document
    ---

# グローバルチャンクの例


    knitr::opts_chunk$set(
      collapse = TRUE,
      comment = "#>",
      fig.path = "figures/fig-",
      out.width = "100%",
      dpi = 300
      )

    knitr::opts_chunk$set(echo = TRUE, #コードを表示
                          cache = FALSE, #キャッシュを残さない
                          fig.path = "figures/fig-",
                          out.width = "100%",
                          dpi = 300,
                          message=FALSE, warning=FALSE)

# パイプ・オペレータの使い方

``` r
1+1
#> [1] 2

a <- 1:3 |> sum()

a
#> [1] 6
```

# グラフ作成・保存の基本

``` r
plot(1:5, 6:10)
```

<img src="figures/fig-plot-1.png" width="100%" />

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following object is masked from 'package:car':
#> 
#>     recode
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

state <- state.x77

library(ggplot2)
ggplot(data = state) +
  geom_point(mapping = aes(x = Income, y = Population) )
```

<img src="figures/fig-ggplot-1.png" width="100%" />

# 回帰分析

    install.packages("wooldridge")
    install.packages("AER")

``` r
library(wooldridge)

data("wage1")
wageModel <- lm(lwage ~ educ + exper + tenure, data = wage1)

summary(wageModel)
#> 
#> Call:
#> lm(formula = lwage ~ educ + exper + tenure, data = wage1)
#> 
#> Residuals:
#>      Min       1Q   Median       3Q      Max 
#> -2.05802 -0.29645 -0.03265  0.28788  1.42809 
#> 
#> Coefficients:
#>             Estimate Std. Error t value Pr(>|t|)    
#> (Intercept) 0.284360   0.104190   2.729  0.00656 ** 
#> educ        0.092029   0.007330  12.555  < 2e-16 ***
#> exper       0.004121   0.001723   2.391  0.01714 *  
#> tenure      0.022067   0.003094   7.133 3.29e-12 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Residual standard error: 0.4409 on 522 degrees of freedom
#> Multiple R-squared:  0.316,  Adjusted R-squared:  0.3121 
#> F-statistic: 80.39 on 3 and 522 DF,  p-value: < 2.2e-16
```
