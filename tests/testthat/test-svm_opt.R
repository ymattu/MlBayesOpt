library(MlBayesOpt)

context("xgb_opt")

data(iris_train, package = "MlBayesOpt")
data(iris_test, package = "MlBayesOpt")

set.seed(71)
res0 <- svm_opt(train_data = iris_train,
                train_label = Species,
                test_data = iris_test,
                test_label = Species,
                svm_kernel = "sigmoid",
                kappa = 10,
                init_points = 20,
                n_iter = 1)
str(res0)
