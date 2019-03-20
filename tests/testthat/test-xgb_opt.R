library(MlBayesOpt)

context("xgb_opt")

tr <- MlBayesOpt:::tr
ts <- MlBayesOpt:::ts

suppressWarnings(RNGversion("3.5.0"))

set.seed(71)
res0 <- xgb_opt(train_data = tr,
                train_label = y,
                test_data = ts,
                test_label = y,
                objectfun = "multi:softmax",
                evalmetric = "merror",
                classes = 10,
                init_points = 20,
                n_iter = 1)
str(res0)
