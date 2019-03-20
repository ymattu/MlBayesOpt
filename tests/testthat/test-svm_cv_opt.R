library(MlBayesOpt)

context("svm_cv_opt")

tr <- MlBayesOpt:::tr

suppressWarnings(RNGversion("3.5.0"))

set.seed(71)
res0 <- svm_cv_opt(data = tr,
                   label = y,
                   n_folds = 3,
                   init_points = 20,
                   n_iter = 1)
str(res0)
