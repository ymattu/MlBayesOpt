##' Bayesian Optimization for SVM
##'
##' This function estimates parameters for SVM(Gaussian Kernel) based on bayesian optimization
##' @param data data
##' @param label label for classification
##' @param gamma_range The range of gamma. Default is c(10 ^ (-3), 10 ^ 1)
##' @param cost_range The range of C(Cost). Default is c(10 ^ (-2), 10 ^ 2)
##' @param svm_kernel Kernel used in SVM. You might consider changing some of the following parameters, depending on the kernel type.
##' \itemize{
##'   \item \strong{linear:} \eqn{u'v}
##'   \item \strong{polynomial:} \eqn{(\gamma u'v +coef0)^{degree}}
##'   \item \strong{radial basis:} \eqn{exp(-\gamma|u-v|^2)}
##'   \item \strong{sigmoid:} \eqn{tanh(\gamma u'v + coef0)}
##' }
##' @param degree_range Parameter needed for kernel of type polynomial. Default is c(3L, 10L)
##' @param coef0_range Parameter needed for kernels of type \code{polynomial} and \code{sigmoid}. Default is c(10 ^ (-1), 10 ^ 1)
##' @param n_folds if a integer value k>0 is specified, a k-fold cross validation on the training data is performed to assess the quality of the model: the accuracy rate for classification and the Mean Squared Error for regression
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
##' library(MlBayesOpt)
##'
##' set.seed(71)
##' res0 <- svm_cv_opt(data = iris,
##'                    label = Species,
##'                    n_folds = 3,
##'                    init_points = 10,
##'                    n_iter = 1)
##'
##' @importFrom e1071 svm
##' @import rBayesianOptimization
##' @importFrom stats predict
##' @importFrom rlang quo enquo eval_tidy !!
##' @importFrom dplyr select %>%
##' @export
svm_cv_opt <- function(data,
                       label,
                       gamma_range = c(10 ^ (-3), 10 ^ 1),
                       cost_range = c(10 ^ (-2), 10 ^ 2),
                       svm_kernel = "radial",
                       degree_range = c(3L, 10L),
                       coef0_range = c(10 ^ (-1), 10^1),
                       n_folds,
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

  # hyperparameter
  qgamma <- quo(gamma_range)
  qcost <- quo(cost_range)
  qdegree <- quo(degree_range)
  qcoef0 <- quo(coef0_range)

  # data
  ddata<- data

  quo_label <- enquo(label)
  data_label <- (ddata %>% select(!! quo_label))[[1]]

  if (class(data_label) != "factor"){
    dlabel <- as.factor(data_label)
  } else{
    dlabel <- data_label}

  # svm_kernel
  if (svm_kernel == "radial") {
    svm_cv1 <- function(gamma_opt, cost_opt){
      model <- svm(dlabel ~., ddata %>% select(- !! quo_label),
                   gamma = gamma_opt,
                   cost = cost_opt,
                   kernel = svm_kernel,
                   cross = n_folds)
      s <- model$tot.accuracy / 100
      p <- model$fitted
      list(Score = s, Pred = p)
    }

    grange <- eval_tidy(qgamma)
    crange <- eval_tidy(qcost)
    opt_res <- BayesianOptimization(svm_cv1,
                                    bounds = list(gamma_opt = grange,
                                                  cost_opt = crange),
                                    init_points,
                                    init_grid_dt = NULL,
                                    n_iter,
                                    acq,
                                    kappa,
                                    eps,
                                    optkernel,
                                    verbose = TRUE)
  } else if (svm_kernel == "polynomial") {
    svm_cv2 <- function(degree_opt, coef0_opt){
      model <- svm(dlabel ~., ddata %>% select(- !! quo_label),
                   degree = degree_opt,
                   coef0 = coef0_opt,
                   kernel = svm_kernel,
                   cross = n_folds)
      s <- model$tot.accuracy / 100
      p <- model$fitted
      list(Score = s, Pred = p)
    }

    drange <- eval_tidy(qdegree)
    c0range <- eval_tidy(qcoef0)
    opt_res <- BayesianOptimization(svm_cv2,
                                    bounds = list(degree_opt = drange,
                                                  coef0_opt = c0range),
                                    init_points,
                                    init_grid_dt = NULL,
                                    n_iter,
                                    acq,
                                    kappa,
                                    eps,
                                    optkernel,
                                    verbose = TRUE)
  } else if (svm_kernel == "sigmoid") {
    svm_cv3 <- function(gamma_opt, cost_opt, coef0_opt){
      model <- svm(dlabel ~., ddata %>% select(- !! quo_label),
                   gamma = gamma_opt,
                   cost = cost_opt,
                   coef0 = coef0_opt,
                   kernel = svm_kernel,
                   cross = n_folds)
      s <- model$tot.accuracy / 100
      p <- model$fitted
      list(Score = s, Pred = p)
    }

    crange <- eval_tidy(qcost)
    c0range <- eval_tidy(qcoef0)
    grange <- eval_tidy(qgamma)
    opt_res <- BayesianOptimization(svm_cv3,
                                    bounds = list(cost_opt = crange,
                                                  coef0_opt = c0range,
                                                  gamma_opt = grange),
                                    init_points,
                                    init_grid_dt = NULL,
                                    n_iter,
                                    acq,
                                    kappa,
                                    eps,
                                    optkernel,
                                    verbose = TRUE)
  } else if (svm_kernel == "linear") {
    svm_cv4 <- function(cost_opt){
      model <- svm(dlabel ~., ddata %>% select(- !! quo_label),
                   cost = cost_opt,
                   kernel = svm_kernel,
                   cross = n_folds)
      s <- model$tot.accuracy / 100
      p <- model$fitted
      list(Score = s, Pred = p)
    }

    crange <- eval_tidy(qcost)
    opt_res <- BayesianOptimization(svm_cv4,
                                    bounds = list(cost_opt = crange),
                                    init_points,
                                    init_grid_dt = NULL,
                                    n_iter,
                                    acq,
                                    kappa,
                                    eps,
                                    optkernel,
                                    verbose = TRUE)
  }
  return(opt_res)
}
