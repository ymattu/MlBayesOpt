
<!-- README.md is generated from README.Rmd. Please edit that file -->
MlBayesOpt
==========

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

`fashion` is a data made by the function `bind_rows(fashion_train, fashion_test)`.

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
                kappa = 10,
                init_points = 20,
                n_iter = 1)
#> elapsed = 0.05   Round = 1   cost_opt = 33.2995  coef0_opt = 6.1907  gamma_opt = 3.7650  Value = 0.6800 
#> elapsed = 0.11   Round = 2   cost_opt = 55.5148  coef0_opt = 2.9461  gamma_opt = 6.1946  Value = 0.8000 
#> elapsed = 0.00   Round = 3   cost_opt = 32.7437  coef0_opt = 7.1117  gamma_opt = 0.3714  Value = 0.3733 
#> elapsed = 0.00   Round = 4   cost_opt = 21.1746  coef0_opt = 2.2747  gamma_opt = 6.5964  Value = 0.7600 
#> elapsed = 0.00   Round = 5   cost_opt = 31.6190  coef0_opt = 2.0113  gamma_opt = 4.0519  Value = 0.8000 
#> elapsed = 0.00   Round = 6   cost_opt = 94.7272  coef0_opt = 4.6869  gamma_opt = 6.3842  Value = 0.8133 
#> elapsed = 0.00   Round = 7   cost_opt = 66.1748  coef0_opt = 4.2256  gamma_opt = 5.4706  Value = 0.7867 
#> elapsed = 0.01   Round = 8   cost_opt = 88.9432  coef0_opt = 3.3751  gamma_opt = 1.2263  Value = 0.8000 
#> elapsed = 0.00   Round = 9   cost_opt = 33.8076  coef0_opt = 3.0605  gamma_opt = 0.3956  Value = 1.0000 
#> elapsed = 0.00   Round = 10  cost_opt = 43.4807  coef0_opt = 8.8818  gamma_opt = 8.2328  Value = 0.6800 
#> elapsed = 0.00   Round = 11  cost_opt = 11.7670  coef0_opt = 0.6194  gamma_opt = 0.2384  Value = 1.0000 
#> elapsed = 0.00   Round = 12  cost_opt = 76.1740  coef0_opt = 6.0815  gamma_opt = 1.2542  Value = 0.6667 
#> elapsed = 0.00   Round = 13  cost_opt = 14.1882  coef0_opt = 7.9847  gamma_opt = 6.0368  Value = 0.6533 
#> elapsed = 0.00   Round = 14  cost_opt = 76.6932  coef0_opt = 0.7139  gamma_opt = 5.0405  Value = 0.8400 
#> elapsed = 0.01   Round = 15  cost_opt = 84.2154  coef0_opt = 7.8487  gamma_opt = 9.5295  Value = 0.6933 
#> elapsed = 0.00   Round = 16  cost_opt = 77.6772  coef0_opt = 8.3927  gamma_opt = 9.9104  Value = 0.6533 
#> elapsed = 0.00   Round = 17  cost_opt = 13.3914  coef0_opt = 4.6207  gamma_opt = 4.7610  Value = 0.6533 
#> elapsed = 0.00   Round = 18  cost_opt = 80.5955  coef0_opt = 2.2961  gamma_opt = 6.2712  Value = 0.7867 
#> elapsed = 0.00   Round = 19  cost_opt = 89.6793  coef0_opt = 4.7502  gamma_opt = 6.5775  Value = 0.7467 
#> elapsed = 0.00   Round = 20  cost_opt = 92.6987  coef0_opt = 0.4899  gamma_opt = 1.8751  Value = 0.8533 
#> elapsed = 0.01   Round = 21  cost_opt = 3.0690   coef0_opt = 1.9483  gamma_opt = 0.2771  Value = 1.0000 
#> 
#>  Best Parameters Found: 
#> Round = 9    cost_opt = 33.8076  coef0_opt = 3.0605  gamma_opt = 0.3956  Value = 1.0000
```

For Details
-----------

See the [vignette](https://ymattu.github.io/MlBayesOpt/articles/MlBayesOpt.html) (Coming Soon!)

ToDo
----

-   \[x\] Make functions to execute cross validation
-   \[ \] Fix minor bugs
