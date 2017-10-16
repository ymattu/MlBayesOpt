
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
#> elapsed = 0.01   Round = 1   gamma_opt = 3.3299  cost_opt = 61.5259  Value = 0.8267 
#> elapsed = 0.00   Round = 2   gamma_opt = 5.5515  cost_opt = 28.7558  Value = 0.8267 
#> elapsed = 0.00   Round = 3   gamma_opt = 3.2744  cost_opt = 70.8278  Value = 0.8267 
#> elapsed = 0.00   Round = 4   gamma_opt = 2.1175  cost_opt = 21.9740  Value = 0.8533 
#> elapsed = 0.01   Round = 5   gamma_opt = 3.1619  cost_opt = 19.3146  Value = 0.8133 
#> elapsed = 0.00   Round = 6   gamma_opt = 9.4727  cost_opt = 46.3378  Value = 0.8133 
#> elapsed = 0.00   Round = 7   gamma_opt = 6.6175  cost_opt = 41.6790  Value = 0.8133 
#> elapsed = 0.00   Round = 8   gamma_opt = 8.8943  cost_opt = 33.0888  Value = 0.8133 
#> elapsed = 0.00   Round = 9   gamma_opt = 3.3808  cost_opt = 29.9110  Value = 0.8133 
#> elapsed = 0.00   Round = 10  gamma_opt = 4.3481  cost_opt = 88.7062  Value = 0.8133 
#> elapsed = 0.00   Round = 11  gamma_opt = 1.1767  cost_opt = 5.2563   Value = 0.8800 
#> elapsed = 0.00   Round = 12  gamma_opt = 7.6174  cost_opt = 60.4227  Value = 0.8133 
#> elapsed = 0.00   Round = 13  gamma_opt = 1.4188  cost_opt = 79.6450  Value = 0.8800 
#> elapsed = 0.00   Round = 14  gamma_opt = 7.6693  cost_opt = 6.2103   Value = 0.8000 
#> elapsed = 0.00   Round = 15  gamma_opt = 8.4215  cost_opt = 78.2717  Value = 0.8133 
#> elapsed = 0.00   Round = 16  gamma_opt = 7.7677  cost_opt = 83.7658  Value = 0.8133 
#> elapsed = 0.01   Round = 17  gamma_opt = 1.3391  cost_opt = 45.6691  Value = 0.8933 
#> elapsed = 0.00   Round = 18  gamma_opt = 8.0596  cost_opt = 22.1903  Value = 0.8133 
#> elapsed = 0.01   Round = 19  gamma_opt = 8.9679  cost_opt = 46.9767  Value = 0.8133 
#> elapsed = 0.00   Round = 20  gamma_opt = 9.2699  cost_opt = 3.9481   Value = 0.8000 
#> elapsed = 0.00   Round = 21  gamma_opt = 0.7340  cost_opt = 46.7122  Value = 0.9200 
#> 
#>  Best Parameters Found: 
#> Round = 21   gamma_opt = 0.7340  cost_opt = 46.7122  Value = 0.9200
```

For Details
-----------

See the [vignette](https://ymattu.github.io/MlBayesOpt/articles/MlBayesOpt.html) (Coming Soon!)

ToDo
----

-   \[x\] Make functions to execute cross validation
-   \[ \] Fix minor bugs
