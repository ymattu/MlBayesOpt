
<!-- README.md is generated from README.Rmd. Please edit that file -->
MlBayesOpt <img src="man/figures/logo.png" align="right" />
===========================================================

[![Build Status](https://travis-ci.org/ymattu/MlBayesOpt.svg?branch=master)](https://travis-ci.org/ymattu/MlBayesOpt) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ymattu/MlBayesOpt?branch=master&svg=true)](https://ci.appveyor.com/project/ymattu/MlBayesOpt) [![Coverage Status](https://img.shields.io/codecov/c/github/ymattu/MlBayesOpt/master.svg)](https://codecov.io/github/ymattu/MlBayesOpt?branch=master)

Overview
--------

This is an R package to tune hyperparameters for machine learning algorithms using Bayesian Optimization based on Gaussian Processes. Algorithms currently supported are: Support Vector Machines, Random Forest, and XGboost.

Dependencies
------------

-   rBayesianOptimization
-   Matrix
-   e1071
-   ranger
-   xgboost
-   dplyr(&gt;= 0.7.0)

Installation
------------

You can install MlBayesOpt from github with:

``` r
# install.packages("githubinstall")
githubinstall::githubinstall("MlBayesOpt")

# install.packages("devtools")
devtools::install_github("ymattu/MlBayesOpt")
```

Data
----

### Small Fashion MNIST

`fashion_train` and `fashion_test` are data reproduced from [Fashion-MNIST](https://github.com/zalandoresearch/fashion-mnist). Each data has 1,000 rows and 784 feature column, and 1 label column named `y`.

`fashion` is a data made by the function `dplyr::bind_rows(fashion_train, fashion_test)`.

### iris

`iris_train` and `iris_test` are included in this pacakge. `iris_train` is odd-numbered rows of `iris` data, and `iris_test`is even-numbered rows of `iris` data.

Example
-------

3-fold cross validation for `iris` data, using SVM.

``` r
library(MlBayesOpt)

set.seed(71)
res0 <- svm_cv_opt(data = iris,
                   label = Species,
                   n_folds = 3,
                   init_points = 10,
                   n_iter = 1)
#> elapsed = 0.03   Round = 1   gamma_opt = 3.3299  cost_opt = 11.7670  Value = 0.9333 
#> elapsed = 0.17   Round = 2   gamma_opt = 5.5515  cost_opt = 76.1740  Value = 0.9067 
#> elapsed = 0.01   Round = 3   gamma_opt = 3.2744  cost_opt = 14.1882  Value = 0.9400 
#> elapsed = 0.01   Round = 4   gamma_opt = 2.1175  cost_opt = 76.6932  Value = 0.9200 
#> elapsed = 0.01   Round = 5   gamma_opt = 3.1619  cost_opt = 84.2154  Value = 0.9600 
#> elapsed = 0.02   Round = 6   gamma_opt = 9.4727  cost_opt = 77.6772  Value = 0.8933 
#> elapsed = 0.01   Round = 7   gamma_opt = 6.6175  cost_opt = 13.3914  Value = 0.9267 
#> elapsed = 0.01   Round = 8   gamma_opt = 8.8943  cost_opt = 80.5955  Value = 0.8733 
#> elapsed = 0.01   Round = 9   gamma_opt = 3.3808  cost_opt = 89.6793  Value = 0.9333 
#> elapsed = 0.01   Round = 10  gamma_opt = 4.3481  cost_opt = 92.6987  Value = 0.9000 
#> elapsed = 0.01   Round = 11  gamma_opt = 2.9508  cost_opt = 84.8600  Value = 0.9467 
#> 
#>  Best Parameters Found: 
#> Round = 5    gamma_opt = 3.1619  cost_opt = 84.2154  Value = 0.9600
```

For Details
-----------

See the [vignette](https://ymattu.github.io/MlBayesOpt/articles/MlBayesOpt.html) (Coming Soon!)

ToDo
----

-   \[x\] Make functions to execute cross validation
-   \[ \] Fix minor bugs
