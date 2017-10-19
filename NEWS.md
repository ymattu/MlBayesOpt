# MlBayesOpt 0.3.3
- Fix Buggs for `xgb_cv_opt()`

# MlBayesOpt 0.3.2
- Add a vignette
- Changed a option `num_tree_range` in `rf_opt()` to `num_tree`
- Fix Bugs for SVM functions

# MlBayesOpt 0.3.1
Fixed bugs

# MlBayesOpt 0.3.0
- Add a function for cross validation (SVM), `svm_cv_opt()`.
- Add choices for SVM functions(`svm_opt()` and `svm_cv_opt()`). We can use `linear`, `polynomial`, `radial`(default), `sigmoid` kernels in `svm_kernel` option.
- We don't have to write the object name for specifying label column.
    - before:
    
    ```R
    res <- svm_opt(train_data = iris_train,
                   train_label = iris_train$Species,
                   test_data = iris_test,
                   test_label = iris_test$Species,
                   acq = "ucb"
                   )
    ```

    - after:
    
    ```R
    res <- svm_opt(train_data = iris_train,
                   train_label = Species,
                   test_data = iris_test,
                   test_label = Species,
                   acq = "ucb"
                   )
    ```

# MlBayesOpt 0.2.1
Fix minor bugs

# MlBayesOpt 0.2.0
Support for cross validation, `xgb_cv_opt()`

# MlBayesOpt 0.1.2
Fixed minor bugs

# MlBayesOpt 0.1.1
`xgb_opt()` supports objective function "binary:logistic"

# MlBayesOpt 0.1.0
Delete all warnings and notes

# MlBayesOpt 0.0.9300
Add `rf_opt()`

# MlBayesOpt 0.0.9200
Add parameter range to the arguments

# MlBayesOpt 0.0.9100
Add `svm_opt()`

# MlBayesOpt 0.0.9000
The first release. `xgb_opt()` only.
