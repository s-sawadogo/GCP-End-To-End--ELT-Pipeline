-- Training with BOOSTED TREE REGRESSOR
CREATE OR REPLACE MODEL `possible-coast-463614-i9.ml_dataset.boosted_tree_model`
  OPTIONS (model_type="BOOSTED_TREE_REGRESSOR", enable_global_explain=TRUE, input_label_cols=["total_amount"])
AS 
SELECT * FROM `possible-coast-463614-i9.ml_dataset.preprocessed_train_data` LIMIT 1000; -- on peut prendre tout le dataset


-- Training with RANDOM FOREST REGRESSOR
CREATE OR REPLACE MODEL `possible-coast-463614-i9.ml_dataset.yellow_trips_rf`
  OPTIONS (model_type="RANDOM_FOREST_REGRESSOR", enable_global_explain=TRUE, input_label_cols=["total_amount"])
AS 
SELECT * FROM `possible-coast-463614-i9.ml_dataset.preprocessed_train_data` LIMIT 1000;










SELECT COUNT(*) FROM `possible-coast-463614-i9.ml_dataset.preprocessed_test_data`;


-- Evaluate the trained model with the test data
SELECT * FROM 
ML.EVALUATE(MODEL `possible-coast-463614-i9.ml_dataset.boosted_tree_model`, 
(SELECT * FROM `possible-coast-463614-i9.ml_dataset.preprocessed_test_data`));


-- Example for making predictions from the model
SELECT * FROM
ML.PREDICT (MODEL `possible-coast-463614-i9.ml_dataset.boosted_tree_model`, 
(SELECT * FROM `possible-coast-463614-i9.ml_dataset.preprocessed_test_data` LIMIT 10));


-- Query the model's global explanations
SELECT * FROM ML.GLOBAL_EXPLAIN(MODEL `possible-coast-463614-i9.ml_dataset.boosted_tree_model`);









-- Training with RANDOM FOREST REGRESSOR
CREATE OR REPLACE MODEL `possible-coast-463614-i9.ml_dataset.yellow_trips_rf`
  OPTIONS (model_type="RANDOM_FOREST_REGRESSOR", enable_global_explain=TRUE, input_label_cols=["total_amount"])
AS 
SELECT * FROM `possible-coast-463614-i9.ml_dataset.preprocessed_train_data` LIMIT 1000000;


SELECT * FROM 
ML.EVALUATE(MODEL `possible-coast-463614-i9.ml_dataset.yellow_trips_rf`, 
(SELECT * FROM `possible-coast-463614-i9.ml_dataset.preprocessed_test_data`));








-- Training with DNN REGRESSOR
CREATE OR REPLACE MODEL `nyc-yellow-trips.ml_dataset.yellow_trips_dnn`
  OPTIONS (model_type="DNN_REGRESSOR", enable_global_explain=TRUE, input_label_cols=["total_amount"])
AS 
SELECT * FROM `nyc-yellow-trips.ml_dataset.preprocessed_train_data`;


-- Training with AUTOML REGRESSOR
CREATE OR REPLACE MODEL `nyc-yellow-trips.ml_dataset.yellow_trips_automl`
  OPTIONS (model_type="AUTOML_REGRESSOR", enable_global_explain=TRUE, input_label_cols=["total_amount"])
AS 
SELECT * FROM `nyc-yellow-trips.ml_dataset.preprocessed_train_data`;


