##' Bayesian Optimization for SVM (Gaussian Kernel)
##'
##' This function estimates parameters for SVM(Gaussian Kernel) based on bayesian optimization
##' @param train_data A data frame for training of xgboost
##' @param train_label The column of class to classify in the training data
##' @param test_data A data frame for training of xgboos
##' @param test_label The column of class to classify in the test data
##' @param gamma_range The range of gamma. Default is c(10 ^ (-5), 10 ^ 5)
##' @param c_range The range of C(Cost). Deafult is c(10 ^ (-2), 10 ^ 2)
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
##' @param kernel Kernel (aka correlation function) for the underlying Gaussian Process. This parameter should be a list
##'   that specifies the type of correlation function along with the smoothness parameter. Popular choices are square exponential (default) or matern 5/2
##'
##' @return The test accuracy and a list of Bayesian Optimization result is returned:
##' \itemize{
##'   \item \code{Best_Par} a named vector of the best hyperparameter set found
##'   \item \code{Best_Value} the value of metrics achieved by the best hyperparameter set
##'   \item \code{History} a \code{data.table} of the bayesian optimization history
##'   \item \code{Pred} a \code{data.table} with validation/cross-validation prediction for each round of bayesian optimization history
##' }
##'
##' @importFrom e1071 svm
##' @import rBayesianOptimization
##' @importFrom stats predict
##' @export
svm_opt <- function(train_data,
                    train_label,
                    test_data,
                    test_label,
                    gamma_range = c(10 ^ (-5), 10 ^ 5),
                    c_range = c(10 ^ (-2), 10 ^ 2),
                    init_points = 20,
                    n_iter = 1,
                    acq = "ei",
                    kappa = 2.576,
                    eps = 0.0,
                    kernel = list(type = "exponential", power = 2))
{

  dtrain <- train_data
  dtest <- test_data

  if (class(train_label) != "factor"){
    trainlabel <- as.factor(train_label)
  } else{
    trainlabel <- train_label}

  if (class(test_label) != "factor"){
    testlabel <- as.factor(train_label)
  } else{
    testlabel <- test_label}


  svm_holdout <- function(gamma_opt, cost_opt){
    model <- svm(trainlabel ~., dtrain, gamma = gamma_opt, cost = cost_opt)
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
                                  verbose = TRUE)

  return(opt_res)

}
