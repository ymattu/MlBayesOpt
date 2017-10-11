library(MlBayesOpt)

context("rf_opt")

data(iris_train, package = "MlBayesOpt")
data(iris_test, package = "MlBayesOpt")

set.seed(71)
res0 <- rf_opt(train_data = iris_train,
               train_label = Species,
               test_data = iris_test,
               test_label = Species,
               mtry_range = c(1L, ncol(iris_train)),
               num_tree_range = 10L,
               init_points = 20,
               n_iter = 1,
               kappa = 10)
str(res0)
