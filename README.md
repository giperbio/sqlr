
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sqlr <a href='https://gipsousp.github.io/sqlr'><img src='man/figures/logo.png' align="right" height="139" /></a>

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
![CRAN status](https://www.r-pkg.org/badges/version/mctq) [![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/gipsousp/sqlr/workflows/R-CMD-check/badge.svg)](https://github.com/gipsousp/sqlr/actions)
[![Travis build
status](https://travis-ci.com/gipsousp/sqlr.svg?branch=master)](https://travis-ci.com/gipsousp/sqlr)
[![Codecov test
coverage](https://codecov.io/gh/gipsousp/sqlr/branch/master/graph/badge.svg)](https://codecov.io/gh/gipsousp/sqlr?branch=master)
[![License:
MIT](https://img.shields.io/badge/license-MIT-green)](https://choosealicense.com/licenses/mit/)
[![Contributor
Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](https://gipsousp.github.io/mctq/CODE_OF_CONDUCT.html)
<!-- badges: end -->

## Overview

`sqlr` is an R package that provides a complete and consistent toolkit
to process Systematic Quantitative Literature Reviews (SQLR), a method
of systematic reviews presented by Catherine Pickering and Jason Byrne
in [2014](https://doi.org/10.1080/07294360.2013.841651). The aim of
`sqlr` is to facilitate the work of PhD candidates and other
early-career researchers with evidence synthesis while also helping with
research reproducibility.

Learn more about systematic quantitative literature reviews at
<http://bit.ly/2OMxvcD> .

## Prerequisites

You only need to have some familiarity with the [R programming
language](https://www.r-project.org/) to use the `sqlr` main functions.

In case you don’t feel comfortable with R, we strongly recommend
checking Hadley Wickham and Garrett Grolemund free and online book [R
for data Science](https://r4ds.had.co.nz/) and the Coursera course from
John Hopkins University [Data Science: Foundations using
R](https://www.coursera.org/specializations/data-science-foundations-r)
(free for listeners).

## Installation

`sqlr` is still at the
[experimental](https://lifecycle.r-lib.org/articles/stages.html#experimental)
stage of development, that means that people can use the package and
provide feedback, but it comes with no promises for long term stability.

You can install `sqlr` from from GitHub with:

``` r
# install.packages("sqlr")
devtools::install_github("gipsousp/sqlr", dependencies = TRUE)
```

## Citation

If you use `sqlr` in your research, please consider citing it. We put a
lot of work to build and maintain a free and open-source R package. You
can find the `sqlr` citation below.

``` r
citation("sqlr")
#> 
#> To cite sqlr in publications use:
#> 
#>   Vartanian D., Benedito-Silva, A. A., Pedrazzoli, M. (2021). sqlr: An
#>   R package for systematic quantitative literature reviews. Retrieved
#>   from https://gipsousp.github.io/sqlr/ .
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Unpublished{,
#>     title = {sqlr: An R package for systematic quantitative literature reviews},
#>     author = {Daniel Vartanian and Ana Amelia Benedito-Silva and Mario Pedrazzoli},
#>     year = {2021},
#>     url = {https://gipsousp.github.io/sqlr/},
#>     note = {Lifecycle: experimental},
#>   }
```

## Contributing

`sqlr` is a community project, everyone is welcome to contribute. Take a
moment to review our [Guidelines for
Contributing](https://gipsousp.github.io/sqlr/CONTRIBUTING.html).

Please note that `sqlr` is released with a [Contributor Code of
Conduct](https://gipsousp.github.io/sqlr/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.
