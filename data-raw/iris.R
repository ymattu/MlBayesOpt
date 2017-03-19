odd.n <- 2 * (1:75) - 1
iris_train <- iris[odd.n, ] # 奇数を訓練データ
iris_test <- iris[-odd.n, ] # 偶数を検証データ

devtools::use_data(iris_train)
devtools::use_data(iris_test)
