
<!-- README.md is generated from README.Rmd. Please edit that file -->
MlBayesOpt <img src="logo.png" align="right" />
===============================================

[![Build Status](https://travis-ci.org/ymattu/MlBayesOpt.svg?branch=master)](https://travis-ci.org/ymattu/MlBayesOpt) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ymattu/MlBayesOpt?branch=master&svg=true)](https://ci.appveyor.com/project/ymattu/MlBayesOpt) [![Coverage Status](https://img.shields.io/codecov/c/github/ymattu/MlBayesOpt/master.svg)](https://codecov.io/github/ymattu/MlBayesOpt?branch=master)

Overview
--------

This is an R package to tune hyperparameters for machine learning algorithms using Bayesian Optimization based on Gaussian Processes. Algorithms currently supported are: support vector machines, random forest, and xgboost.

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

``` r
library(MlBayesOpt)

set.seed(71)
res0 <- svm_opt(train_data = iris_train,
                train_label = Species,
                test_data = iris_test,
                test_label = Species,
                svm_kernel = "sigmoid",
                init_points = 10,
                n_iter = 1,
                kappa = 10)
#> elapsed = 0.01   Round = 1   cost_opt = 33.2995  coef0_opt = 1.2641  gamma_opt = 6.1526  Value = 0.8000 
#> elapsed = 0.00   Round = 2   cost_opt = 55.5148  coef0_opt = 7.6410  gamma_opt = 2.8756  Value = 0.6667 
#> elapsed = 0.00   Round = 3   cost_opt = 32.7437  coef0_opt = 1.5038  gamma_opt = 7.0828  Value = 0.8000 
#> elapsed = 0.01   Round = 4   cost_opt = 21.1746  coef0_opt = 7.6924  gamma_opt = 2.1974  Value = 0.6667 
#> elapsed = 0.01   Round = 5   cost_opt = 31.6190  coef0_opt = 8.4372  gamma_opt = 1.9315  Value = 0.5867 
#> elapsed = 0.01   Round = 6   cost_opt = 94.7272  coef0_opt = 7.7898  gamma_opt = 4.6338  Value = 0.6667 
#> elapsed = 0.00   Round = 7   cost_opt = 66.1748  coef0_opt = 1.4249  gamma_opt = 4.1679  Value = 0.8133 
#> elapsed = 0.01   Round = 8   cost_opt = 88.9432  coef0_opt = 8.0788  gamma_opt = 3.3089  Value = 0.6667 
#> elapsed = 0.01   Round = 9   cost_opt = 33.8076  coef0_opt = 8.9781  gamma_opt = 2.9911  Value = 0.6400 
#> elapsed = 0.00   Round = 10  cost_opt = 43.4807  coef0_opt = 9.2771  gamma_opt = 8.8706  Value = 0.6933 
#> elapsed = 0.00   Round = 11  cost_opt = 13.0177  coef0_opt = 1.3844  gamma_opt = 8.6246  Value = 0.8133 
#> 
#>  Best Parameters Found: 
#> Round = 7    cost_opt = 66.1748  coef0_opt = 1.4249  gamma_opt = 4.1679  Value = 0.8133
```

For Details
-----------

See the [vignette](https://ymattu.github.io/MlBayesOpt/articles/MlBayesOpt.html) (Coming Soon!)

ToDo
----

-   \[x\] Make functions to execute cross validation
-   \[ \] Fix minor bugs
