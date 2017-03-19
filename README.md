# MlBayesOpt
## Overview
This is a R Pckage to tune parameters for machine learning(Support Vector Machine(RBF kernel), Random Forest, Xgboost), using Bayesian Optimization based on Gaussian Process. We can exxecute only Hold-Out tuning so far.

## Dependencies
- rBayesianOptimization
- Matrix
- e1071
- ranger
- xgboost

# Installation
* the latest development version:
```r
devtools::install_github("ymattu/MlBayesOpt")
```

# Usage
## Data

### MNIST
`train_mnist` and `test_mnist` are included in this pacakge. These are from https://github.com/ozt-ca/tjo.hatenablog.samples/tree/master/r_samples/public_lib/jp/mnist_reproduced

### iris
`iris_train` and `iris_test` are included in this pacakge. `iris_train` is odd-numbered rows of `iris` data, and `iris_test`is even-numbered rows of `iris` data.

## SVM

```r
set.seed(123)
res <- svm_opt(
  train_data = iris_train,
  train_label = iris_train$Species,
  test_data = iris_test,
  test_label = iris_test$Species,
  acq = "ucb"
  )
```

This function returns best parameters, gamma and cost, of RBF kernel for SVM.

```
elapsed = 0.00	Round = 1	gamma_opt = 6.e+04	cost_opt = 42.9050	Value = 0.3333
elapsed = 0.01	Round = 2	gamma_opt = 6.e+04	cost_opt = 12.0327	Value = 0.3333
elapsed = 0.00	Round = 3	gamma_opt = 7.e+04	cost_opt = 92.1573	Value = 0.3333
elapsed = 0.01	Round = 4	gamma_opt = 9.e+04	cost_opt = 18.3716	Value = 0.3333
elapsed = 0.01	Round = 5	gamma_opt = 8.e+04	cost_opt = 56.2588	Value = 0.3333
elapsed = 0.01	Round = 6	gamma_opt = 2252.2930	cost_opt = 31.7409	Value = 0.3733
elapsed = 0.01	Round = 7	gamma_opt = 1.e+05	cost_opt = 90.3354	Value = 0.3333
elapsed = 0.01	Round = 8	gamma_opt = 8.e+04	cost_opt = 67.4079	Value = 0.3333
elapsed = 0.01	Round = 9	gamma_opt = 3.e+04	cost_opt = 60.7380	Value = 0.4267
elapsed = 0.00	Round = 10	gamma_opt = 4.e+04	cost_opt = 1.0265	Value = 0.4267
elapsed = 0.01	Round = 11	gamma_opt = 8.e+04	cost_opt = 6.9141	Value = 0.3333
elapsed = 0.00	Round = 12	gamma_opt = 1.e+04	cost_opt = 22.3618	Value = 0.5333
elapsed = 0.01	Round = 13	gamma_opt = 5.e+04	cost_opt = 50.8926	Value = 0.3333
elapsed = 0.01	Round = 14	gamma_opt = 7.e+04	cost_opt = 19.7729	Value = 0.3333
elapsed = 0.00	Round = 15	gamma_opt = 1.e+04	cost_opt = 79.5983	Value = 0.6133
elapsed = 0.00	Round = 16	gamma_opt = 2.e+04	cost_opt = 96.6198	Value = 0.4800
elapsed = 0.00	Round = 17	gamma_opt = 8.e+04	cost_opt = 96.4806	Value = 0.3333
elapsed = 0.01	Round = 18	gamma_opt = 5.e+04	cost_opt = 49.0600	Value = 0.3333
elapsed = 0.00	Round = 19	gamma_opt = 2453.1625	cost_opt = 84.8863	Value = 0.3733
elapsed = 0.00	Round = 20	gamma_opt = 1.e+05	cost_opt = 62.2435	Value = 0.3333
elapsed = 0.01	Round = 21	gamma_opt = 1.e+04	cost_opt = 23.6688	Value = 0.5867

 Best Parameters Found:
Round = 15	gamma_opt = 1.e+04	cost_opt = 79.5983	Value = 0.6133
```

## Random Forest

```r
set.seed(123)

mod <- rf_opt(
  train_data = iris_train,
  train_label = iris_train$Species,
  test_data = iris_test,
  test_label = iris_test$Species,
  mtry_range = c(1L, 4L)
  )

```


This function returns best parameters, num.trees and mtry, for Random Forest.

```
elapsed = 0.01	Round = 1	num_trees_opt = 288.0000	mtry_opt = 4.0000	Value = 1.0000
elapsed = 0.03	Round = 2	num_trees_opt = 789.0000	mtry_opt = 3.0000	Value = 1.0000
elapsed = 0.02	Round = 3	num_trees_opt = 410.0000	mtry_opt = 3.0000	Value = 1.0000
elapsed = 0.04	Round = 4	num_trees_opt = 883.0000	mtry_opt = 4.0000	Value = 1.0000
elapsed = 0.03	Round = 5	num_trees_opt = 941.0000	mtry_opt = 3.0000	Value = 1.0000
elapsed = 0.01	Round = 6	num_trees_opt = 47.0000	mtry_opt = 3.0000	Value = 1.0000
elapsed = 0.02	Round = 7	num_trees_opt = 529.0000	mtry_opt = 3.0000	Value = 1.0000
elapsed = 0.03	Round = 8	num_trees_opt = 893.0000	mtry_opt = 3.0000	Value = 1.0000
elapsed = 0.02	Round = 9	num_trees_opt = 552.0000	mtry_opt = 2.0000	Value = 1.0000
elapsed = 0.02	Round = 10	num_trees_opt = 457.0000	mtry_opt = 1.0000	Value = 0.9867
elapsed = 0.03	Round = 11	num_trees_opt = 957.0000	mtry_opt = 4.0000	Value = 1.0000
elapsed = 0.02	Round = 12	num_trees_opt = 454.0000	mtry_opt = 4.0000	Value = 1.0000
elapsed = 0.02	Round = 13	num_trees_opt = 678.0000	mtry_opt = 3.0000	Value = 1.0000
elapsed = 0.02	Round = 14	num_trees_opt = 573.0000	mtry_opt = 3.0000	Value = 1.0000
elapsed = 0.01	Round = 15	num_trees_opt = 104.0000	mtry_opt = 1.0000	Value = 0.9733
elapsed = 0.03	Round = 16	num_trees_opt = 900.0000	mtry_opt = 2.0000	Value = 1.0000
elapsed = 0.01	Round = 17	num_trees_opt = 247.0000	mtry_opt = 3.0000	Value = 1.0000
elapsed = 0.00	Round = 18	num_trees_opt = 43.0000	mtry_opt = 2.0000	Value = 1.0000
elapsed = 0.01	Round = 19	num_trees_opt = 329.0000	mtry_opt = 2.0000	Value = 1.0000
elapsed = 0.03	Round = 20	num_trees_opt = 955.0000	mtry_opt = 2.0000	Value = 1.0000
elapsed = 0.01	Round = 21	num_trees_opt = 101.0000	mtry_opt = 2.0000	Value = 1.0000

 Best Parameters Found:
Round = 1	num_trees_opt = 288.0000	mtry_opt = 4.0000	Value = 1.0000
```

## XGboost
```r
set.seed(71)

res1 <- xgb_opt(train_data = iris_train,
               train_label = iris_train$Species,
               test_data = iris_test,
               test_label = iris_test$Species,
               objectfun = "multi:softmax",
               classes = 3,
               evalmetric = "merror"
)
```

This function returns best parameters of eta, max_depth, nrounds, subsample, colsample_bytree. For Details of these parameters, see https://github.com/dmlc/xgboost/blob/master/doc/parameter.md

```
elapsed = 0.02	Round = 1	eta_opt = 0.8729	max_depth_opt = 6.0000	nrounds_opt = 123.8761	subsample_opt = 0.2789	bytree_opt = 0.5343	Value = 0.7467
elapsed = 0.02	Round = 2	eta_opt = 0.5779	max_depth_opt = 6.0000	nrounds_opt = 144.4570	subsample_opt = 0.4523	bytree_opt = 0.4854	Value = 0.6933
elapsed = 0.01	Round = 3	eta_opt = 0.3202	max_depth_opt = 6.0000	nrounds_opt = 88.6309	subsample_opt = 0.1219	bytree_opt = 0.4910	Value = 0.7467
elapsed = 0.01	Round = 4	eta_opt = 0.5614	max_depth_opt = 4.0000	nrounds_opt = 76.5790	subsample_opt = 0.3092	bytree_opt = 0.6768	Value = 0.9600
elapsed = 0.02	Round = 5	eta_opt = 0.3955	max_depth_opt = 6.0000	nrounds_opt = 157.8434	subsample_opt = 0.3799	bytree_opt = 0.9856	Value = 0.9867
elapsed = 0.02	Round = 6	eta_opt = 0.6823	max_depth_opt = 5.0000	nrounds_opt = 112.9514	subsample_opt = 0.7601	bytree_opt = 0.7533	Value = 0.9733
elapsed = 0.02	Round = 7	eta_opt = 0.9972	max_depth_opt = 5.0000	nrounds_opt = 105.8205	subsample_opt = 0.6274	bytree_opt = 0.4897	Value = 0.7067
elapsed = 0.02	Round = 8	eta_opt = 0.5091	max_depth_opt = 4.0000	nrounds_opt = 96.5076	subsample_opt = 0.7869	bytree_opt = 0.6712	Value = 0.9600
elapsed = 0.01	Round = 9	eta_opt = 0.6789	max_depth_opt = 4.0000	nrounds_opt = 70.7323	subsample_opt = 0.8556	bytree_opt = 0.9084	Value = 0.9867
elapsed = 0.01	Round = 10	eta_opt = 0.4986	max_depth_opt = 5.0000	nrounds_opt = 94.3087	subsample_opt = 0.9980	bytree_opt = 0.9219	Value = 1.0000
elapsed = 0.01	Round = 11	eta_opt = 0.5696	max_depth_opt = 5.0000	nrounds_opt = 79.2296	subsample_opt = 0.4966	bytree_opt = 0.4736	Value = 0.6933
elapsed = 0.01	Round = 12	eta_opt = 0.6584	max_depth_opt = 5.0000	nrounds_opt = 79.4404	subsample_opt = 0.2275	bytree_opt = 0.8184	Value = 0.9467
elapsed = 0.01	Round = 13	eta_opt = 0.9543	max_depth_opt = 5.0000	nrounds_opt = 86.8093	subsample_opt = 0.3577	bytree_opt = 0.5010	Value = 0.7067
elapsed = 0.02	Round = 14	eta_opt = 0.6237	max_depth_opt = 5.0000	nrounds_opt = 142.3521	subsample_opt = 0.7687	bytree_opt = 0.7682	Value = 0.9733
elapsed = 0.02	Round = 15	eta_opt = 0.5146	max_depth_opt = 5.0000	nrounds_opt = 117.2944	subsample_opt = 0.8118	bytree_opt = 0.5428	Value = 0.7200
elapsed = 0.02	Round = 16	eta_opt = 0.3253	max_depth_opt = 5.0000	nrounds_opt = 156.8916	subsample_opt = 0.6678	bytree_opt = 0.8257	Value = 0.9733
elapsed = 0.02	Round = 17	eta_opt = 0.9906	max_depth_opt = 4.0000	nrounds_opt = 97.0353	subsample_opt = 0.9648	bytree_opt = 0.5380	Value = 0.7333
elapsed = 0.02	Round = 18	eta_opt = 0.2514	max_depth_opt = 5.0000	nrounds_opt = 138.2968	subsample_opt = 0.4424	bytree_opt = 0.7201	Value = 0.9733
elapsed = 0.01	Round = 19	eta_opt = 0.6466	max_depth_opt = 5.0000	nrounds_opt = 82.4813	subsample_opt = 0.1647	bytree_opt = 0.6055	Value = 0.9733
elapsed = 0.02	Round = 20	eta_opt = 0.7080	max_depth_opt = 4.0000	nrounds_opt = 94.7421	subsample_opt = 0.7886	bytree_opt = 0.9739	Value = 0.9867
elapsed = 0.02	Round = 21	eta_opt = 0.1000	max_depth_opt = 6.0000	nrounds_opt = 93.1294	subsample_opt = 0.6490	bytree_opt = 0.9329	Value = 1.0000

Best Parameters Found:
Round = 10	eta_opt = 0.4986	max_depth_opt = 5.0000	nrounds_opt = 94.3087	subsample_opt = 0.9980	bytree_opt = 0.9219	Value = 1.0000
```

# ToDo
- [ ] Make functions to execute cross validation
- [ ] Fix minor bugs
