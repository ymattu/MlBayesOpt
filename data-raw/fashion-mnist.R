library(tidyverse)

fashion_train <- read_csv("https://github.com/ymattu/fashion-mnist-csv/blob/master/fashion_train.csv")
fashion_test <- read_csv("https://github.com/ymattu/fashion-mnist-csv/blob/master/fashion_test.csv")

load("/Volumes/Transcend/dev/MlBayesOpt/data/fashion_test.rda")

fashion <- bind_rows(fashion_train, fashion_test)

# data for test
tr <- fashion %>%
  sample_n(100) %>%
  select(2:10, y)

ts <- fashion %>%
  sample_n(100) %>%
  select(2:10, y)

devtools::use_data(fashion_train)
devtools::use_data(fashion_test)
devtools::use_data(fashion)

devtools::use_data(tr, ts, internal = TRUE)
