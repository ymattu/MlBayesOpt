##' Bayesian Optimization for SVM
##'
##' This function estimates parameters for SVM(Gaussian Kernel) based on bayesian optimization
##' @param train_data A data frame for training of xgboost
##' @param train_label The column of class to classify in the training data
##' @param test_data A data frame for training of xgboos
##' @param test_label The column of class to classify in the test data
##' @param gamma_range The range of gamma. Default is c(10 ^ (-3), 10 ^ 1)
##' @param c_range The range of C(Cost). Deafult is c(10 ^ (-2), 10 ^ 2)
##' @param svm_kernel Kernel used in SVM. You might consider changing some of the following parameters, depending on the kernel type.
##' \itemize{
##'   \item \strong{linear:} \eqn{u'v}
##'   \item \strong{polynomial:} \eqn{(\gamma u'v +coef0)^{degree}}
##'   \item \strong{radial basis:} \eqn{\exp(-\gamma|u-v|^2)}
##'   \item \strong{sigmoid:} \eqn{tanh(\gamma u'v + coef0)}
##' }
##' @param degree Parameter needed for kernel of type polynomial (default: 3)
##' @param init_points Number of randomly chosen points to sample the
##'   target function before Bayesian Optimization fitting the Gaussian Process.
##' @param n_iter Total number of times the Bayesian Optimization is to repeated.
##' @param acq Acquisition function type to be used. Can be "ucb", "ei" or "poi".
##' \itemize{
##'   \item \code{ucb} GP Upper Confidence Bound
##'   \item \code{ei} Expected Improvement
##'   \item \code{poi} Probability of Improvement
##' }
##' @param kappa tunable parameter kappa of GP Upper Confidence Bound, to balance exploitation against exploration,
##'   increasing kappa will make the optimized hyperparameters pursuing exploration.
##' @param eps tunable parameter epsilon of Expected Improvement and Probability of Improvement, to balance exploitation against exploration,
##'   increasing epsilon will make the optimized hyperparameters are more spread out across the whole range.
##' @param optkernel Kernel (aka correlation function) for the underlying Gaussian Process. This parameter should be a list
##'   that specifies the type of correlation function along with the smoothness parameter. Popular choices are square exponential (default) or matern 5/2
##'
##' @return The test accuracy and a list of Bayesian Optimization result is returned:
##' \itemize{
##'   \item \code{Best_Par} a named vector of the best hyperparameter set found
##'   \item \code{Best_Value} the value of metrics achieved by the best hyperparameter set
##'   \item \code{History} a \code{data.table} of the bayesian optimization history
##'   \item \code{Pred} a \code{data.table} with validation/cross-validation prediction for each round of bayesian optimization history
##' }
##' @examples
##' \dontrun{
##' library(MlBayesOpt)
##'
##' # This takes a lot of time
##' res0 <- svm_opt(train_data = fashion_train,
##'                 train_label = y,
##'                 test_data = fashion_test,
##'                 test_label = y)
##' }
##'
##' @importFrom e1071 svm
##' @import rBayesianOptimization
##' @importFrom stats predict
##' @importFrom rlang enquo !!
##' @importFrom dplyr select %>%
##' @export
svm_opt <- function(train_data,
                    train_label,
                    test_data,
                    test_label,
                    gamma_range = c(10 ^ (-3), 10 ^ 1),
                    c_range = c(10 ^ (-2), 10 ^ 2),
                    svm_kernel = "radial",
                    degree = 3,
                    init_points = 4,
                    n_iter = 10,
                    acq = "ei",
                    kappa = 2.576,
                    eps = 0.0,
                    optkernel = list(type = "exponential", power = 2))
{
  pkernel <- pmatch(svm_kernel,
                    c("linear",
                      "polynomial",
                      "radial",
                      "sigmoid"), 99) - 1

  if (pkernel > 10) stop("wrong kernel specification!")

  dtrain <- train_data
  dtest <- test_data

  quo_train_label <- enquo(train_label)
  data_train_label <- (dtrain %>% select(!! quo_train_label))[[1]]

  quo_test_label <- enquo(test_label)
  data_test_label <- (dtest %>% select(!! quo_test_label))[[1]]

  if (class(data_train_label) != "factor"){
    trainlabel <- as.factor(data_train_label)
  } else{
    trainlabel <- data_train_label}

  if (class(data_test_label) != "factor"){
    testlabel <- as.factor(data_test_label)
  } else{
    testlabel <- data_test_label}


  svm_holdout <- function(gamma_opt, cost_opt){
    model <- svm(trainlabel ~., dtrain,
                 gamma = gamma_opt,
                 cost = cost_opt,
                 kernel = svm_kernel,
                 degree = degree)
    t.pred <- predict(model, newdata = dtest)
    Pred <- sum(diag(table(testlabel, t.pred)))/nrow(dtest)
    list(Score = Pred, Pred = Pred)
  }

  opt_res <- BayesianOptimization(svm_holdout,
                                  bounds = list(gamma_opt = gamma_range,
                                                cost_opt = c_range),
                                  init_points,
                                  init_grid_dt = NULL,
                                  n_iter,
                                  acq,
                                  kappa,
                                  eps,
                                  optkernel,
                                  verbose = TRUE)

  return(opt_res)

}
