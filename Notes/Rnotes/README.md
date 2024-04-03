Rメモ
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

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
