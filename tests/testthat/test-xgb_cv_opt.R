library(MlBayesOpt)

context("xgb_cv_opt")

tr <- MlBayesOpt:::tr

suppressWarnings(RNGversion("3.5.0"))

set.seed(71)
res0 <- xgb_cv_opt(data = tr,
                   label = y,
                   objectfun = "multi:softmax",
                   evalmetric = "merror",
                   n_folds = 3,
                   classes = 10,
                   init_points = 20,
                   n_iter = 1)
str(res0)
