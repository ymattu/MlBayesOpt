library(MlBayesOpt)
library(testthat)

context("rf_opt")

set.seed(123)

# Default example.
# This will generate an error in GP_deviance()
# "Infinite values of the Deviance Function, unable to find optimum parameters"
mod <- rf_opt(
  train_data = iris_train,
  train_label = iris_train$Species,
  test_data = iris_test,
  test_label = iris_test$Species,
  mtry_range = c(1L, 4L)
)

print(mod)

########################################3
# Boston test.
data(Boston, package = "MASS")

dim(Boston)

# Divide into training, test, and holdout.
# 50% into training, 20% into test, 30% into holdout.
n = nrow(Boston)
n_training = ceiling(n * 0.5)
n_test = ceiling(n * 0.2)
n_holdout = n - n_training - n_test
c(n_training, n_test, n_holdout)

# Create assignment pool.
pool = c(rep(1, n_training), rep(2, n_test), rep(3, n_holdout))

# Randomize.
set.seed(1, "L'Ecuyer-CMRG")
assignment = sample(pool)

#y = Boston$medv
y_bin = as.factor(Boston$medv > 23)
y_gaus = Boston$medv
y = y_bin

# Remove outcome from covariate dataframe.
x = Boston[, -14]
# Convert to a matrix and remove intercept.
x_mat = data.frame(model.matrix(~ ., data = x)[, -1])

x_train = x_mat[pool == 1, ]
x_test = x_mat[pool == 2, ]
x_holdout = x_mat[pool == 3, ]

y_train = y[pool == 1]
y_test = y[pool == 2]
y_holdout = y[pool == 3]

set.seed(71)
res1 <- rf_opt(train_data = x_train,
               train_label = y_train,
               test_data = x_test,
               test_label = y_test,
               mtry_range = c(1L, ncol(x_train)),
               # Doesn't work:
               #num_tree_range = c(500L, 500L)
               num_tree_range = c(500L, 501L)
)
str(res1)
