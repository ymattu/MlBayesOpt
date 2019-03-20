library(MlBayesOpt)

context("rf_opt")

tr <- MlBayesOpt:::tr
ts <- MlBayesOpt:::ts

suppressWarnings(RNGversion("3.5.0"))

set.seed(71)
res0 <- rf_opt(train_data = tr,
               train_label = y,
               test_data = ts,
               test_label = y,
               num_tree = 10L,
               init_points = 20,
               n_iter = 1,
               kappa = 10)
str(res0)
