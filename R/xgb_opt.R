##' Bayesian optimization for xgboost
##'
##' This function estimates parameters for xgboost based on bayesian optimization.
##' @param train_data A data frame for training of xgboost
##' @param train_label The column of class to classify in the training data
##' @param test_data A data frame for training of xgboost
##' @param test_label The column of class to classify in the test data
##' @param objectfun Specify the learning task and the corresponding learning objective
##' \itemize{
##'     \item \code{reg:linear} linear regression (Default).
##'     \item \code{reg:logistic} logistic regression.
##'     \item \code{binary:logistic} logistic regression for binary classification. Output probability.
##'     \item \code{binary:logitraw} logistic regression for binary classification, output score before logistic transformation.
##'     \item \code{num_class} set the number of classes. To use only with multiclass objectives.
##'     \item \code{multi:softmax} set xgboost to do multiclass classification using the softmax objective. Class is represented by a number and should be from 0 to \code{num_class - 1}.
##'     \item \code{multi:softprob} same as softmax, but prediction outputs a vector of ndata * nclass elements, which can be further reshaped to ndata, nclass matrix. The result contains predicted probabilities of each data point belonging to each class.
##'     \item \code{rank:pairwise} set xgboost to do ranking task by minimizing the pairwise loss.
##'   }
##' @param evalmetric evaluation metrics for validation data. Users can pass a self-defined function to it. Default: metric will be assigned according to objective(rmse for regression, and error for classification, mean average precision for ranking). List is provided in detail section.
##' @param eta_range The range of eta
##' @param max_depth_range The range of max_depth
##' @param nrounds_range The range of nrounds
##' @param subsample_range The range of subsample rate
##' @param bytree_range The range of colsample_bytree rate
##' @param init_points Number of randomly chosen points to sample the
#'   target function before Bayesian Optimization fitting the Gaussian Process.
##' @param n_iter Total number of times the Bayesian Optimization is to repeated.
##' @param acq Acquisition function type to be used. Can be "ucb", "ei" or "poi".
##' \itemize{
##'   \item \code{ucb} GP Upper Confidence Bound
##'   \item \code{ei} Expected Improvement
##'   \item \code{poi} Probability of Improvement
##' }
##' @param kappa tunable parameter kappa of GP Upper Confidence Bound, to balance exploitation against exploration,
##'   increasing kappa will make the optimized hyperparameters pursuing exploration.
##' @param eps  tunable parameter epsilon of Expected Improvement and Probability of Improvement, to balance exploitation against exploration,
##'   increasing epsilon will make the optimized hyperparameters are more spread out across the whole range.
##' @param kernel Kernel (aka correlation function) for the underlying Gaussian Process. This parameter should be a list
##'   that specifies the type of correlation function along with the smoothness parameter. Popular choices are square exponential (default) or matern 5/2
##' @param classes set the number of classes. To use only with multiclass objectives.
##'
##' @return The test accuracy and a list of Bayesian Optimization result is returned:
##' \itemize{
##'   \item \code{Best_Par} a named vector of the best hyperparameter set found
##'   \item \code{Best_Value} the value of metrics achieved by the best hyperparameter set
##'   \item \code{History} a \code{data.table} of the bayesian optimization history
##'   \item \code{Pred} a \code{data.table} with validation/cross-validation prediction for each round of bayesian optimization history
##' }
##'
##' @import xgboost
##' @importFrom Matrix sparse.model.matrix
##' @import rBayesianOptimization
##' @importFrom stats predict
##' @export
##'
xgb_opt <- function(train_data,
                    train_label,
                    test_data,
                    test_label,
                    objectfun,
                    evalmetric,
                    eta_range = c(0.1, 1L),
                    max_depth_range = c(4L, 6L),
                    nrounds_range = c(70, 160L),
                    subsample_range = c(0.1, 1L),
                    bytree_range = c(0.4, 1L),
                    init_points = 20,
                    n_iter = 1,
                    acq = "ei",
                    kappa = 2.576,
                    eps = 0.0,
                    kernel = list(type = "exponential", power = 2),
                    classes = NULL
)
{

  train_mx <- sparse.model.matrix(train_label ~ ., train_data)
  test_mx <- sparse.model.matrix(test_label ~ ., test_data)

  if (class(train_label) == "factor"){
    dtrain <- xgb.DMatrix(train_mx, label = as.integer(train_label) - 1)
  } else{
    dtrain <- xgb.DMatrix(train_mx, label = train_label)}


  if (class(test_label) == "factor"){
    dtest <- xgb.DMatrix(test_mx, label = as.integer(test_label) - 1)

  } else{
    dtest <- xgb.DMatrix(test_mx, label = test_label)}


  #about classes
  if (objectfun == "binary:logistic"){
    xgb_holdout <- function(object_fun,
                            eval_met,
                            num_classes,
                            eta_opt,
                            max_depth_opt,
                            nrounds_opt,
                            subsample_opt,
                            bytree_opt) {

      object_fun <- objectfun
      eval_met <- evalmetric

      model <- xgb.train(params = list(objective = object_fun,
                                       eval_metric = eval_met,
                                       nthread = 1,
                                       eta = eta_opt,
                                       max_depth = max_depth_opt,
                                       subsample = subsample_opt,
                                       colsample_bytree = bytree_opt),
                         data = dtrain,
                         nrounds = nrounds_opt)
      t_pred <- predict(model, newdata = dtest)
      Pred <- sum(diag(table(test_label, t_pred)))/nrow(test_data)
      list(Score = Pred, Pred = Pred)
    }
  } else{
    xgb_holdout <- function(object_fun,
                            eval_met,
                            num_classes,
                            eta_opt,
                            max_depth_opt,
                            nrounds_opt,
                            subsample_opt,
                            bytree_opt) {

      object_fun <- objectfun
      eval_met <- evalmetric

      num_classes <- classes

      model <- xgb.train(params = list(objective = object_fun,
                                       num_class = num_classes,
                                       nthread = 1,
                                       eval_metric = eval_met,
                                       eta = eta_opt,
                                       max_depth = max_depth_opt,
                                       subsample = subsample_opt,
                                       colsample_bytree = bytree_opt),
                         data = dtrain,
                         nrounds = nrounds_opt)
      t_pred <- predict(model, newdata = dtest)
      Pred <- sum(diag(table(test_label, t_pred)))/nrow(test_data)
      list(Score = Pred, Pred = Pred)
    }
  }

  opt_res <- BayesianOptimization(xgb_holdout,
                                  bounds = list(eta_opt = eta_range,
                                                max_depth_opt = max_depth_range,
                                                nrounds_opt = nrounds_range,
                                                subsample_opt = subsample_range,
                                                bytree_opt = bytree_range),
                                  init_points,
                                  init_grid_dt = NULL,
                                  n_iter,
                                  acq,
                                  kappa,
                                  eps,
                                  kernel,
                                  verbose = TRUE)

  return(opt_res)

}
