library(MlBayesOpt)

context("xgb_opt")

data(iris_train, package = "MlBayesOpt")
data(iris_test, package = "MlBayesOpt")

res0 <- xgb_opt(train_data = iris_train,
                train_label = Species,
                test_data = iris_test,
                test_label = Species,
                objectfun = "multi:softmax",
                evalmetric = "merror",
                classes = 3,
                init_points = 20,
                n_iter = 1)
str(res0)
