library(MlBayesOpt)

context("svm_cv_opt")

set.seed(71)
res0 <- svm_cv_opt(data = iris,
                   lablr = Species,
                   n_folds = 3,
                   init_points = 20,
                   n_iter = 1)
str(res0)
