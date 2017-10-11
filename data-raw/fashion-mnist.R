library(tidyverse)

fashion_train <- read_csv("https://github.com/ymattu/fashion-mnist-csv/blob/master/fashion_train.csv")
fashion_test <- read_csv("https://github.com/ymattu/fashion-mnist-csv/blob/master/fashion_test.csv")

load("/Volumes/Transcend/dev/MlBayesOpt/data/fashion_test.rda")

fashion <- bind_rows(fashion_train, fashion_test)

devtools::use_data(fashion_train)
devtools::use_data(fashion_test)
devtools::use_data(fashion)
