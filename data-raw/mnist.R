library(readr)

train_mnist <- read_csv("https://github.com/ozt-ca/tjo.hatenablog.samples/tree/master/r_samples/public_lib/jp/mnist_reproduced/short_prac_train.csv")
test_mnist <- read_csv("https://github.com/ozt-ca/tjo.hatenablog.samples/tree/master/r_samples/public_lib/jp/mnist_reproduced/short_prac_test.csv")

devtools::use_data(train_mnist)
devtools::use_data(test_mnist)




















