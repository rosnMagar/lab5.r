# ============================================================================
# Bank Marketing Prediction Models
# Authors: Yuchen Hsiao, Roshan Thapa Magar, Shiori Umekawa
# ============================================================================
# This script builds three prediction models to predict if clients will 
# subscribe to a term deposit: Linear Regression, CART, and Random Forest
# ============================================================================

# Load required libraries
library(tidyverse)      # For data manipulation
library(rpart)          # For CART model
library(rpart.plot)     # For visualizing decision tree
library(randomForest)   # For Random Forest model
library(caret)          # For confusion matrix

# ============================================================================
# 1. LOAD AND PREPARE DATA
# ============================================================================

# Load cleaned dataset
bank <- read.csv("bank_cleaned_minimal.csv")

# Check the data
cat("Dataset dimensions:", dim(bank), "\n")
cat("Target variable distribution:\n")
print(table(bank$y))

# Convert target variable to factor for classification
bank$y <- as.factor(bank$y)

# ============================================================================
# 2. SPLIT DATA INTO TRAINING AND TEST SETS
# ============================================================================

# Set seed for reproducibility
set.seed(123)

# Create 70% training, 30% test split
train_index <- sample(1:nrow(bank), 0.7 * nrow(bank))
train_data <- bank[train_index, ]
test_data <- bank[-train_index, ]

cat("\nTraining set size:", nrow(train_data), "\n")
cat("Test set size:", nrow(test_data), "\n")

# ============================================================================
# 3. MODEL 1: LINEAR REGRESSION
# ============================================================================

cat("\n========================================\n")
cat("MODEL 1: LINEAR REGRESSION\n")
cat("========================================\n")

# Create binary version of target (0/1) for linear regression
train_data$y_binary <- ifelse(train_data$y == "yes", 1, 0)
test_data$y_binary <- ifelse(test_data$y == "yes", 1, 0)

# Build linear regression model
# Using key predictors identified from EDA
lm_model <- lm(y_binary ~ age + duration + campaign + previous + 
                 emp.var.rate + cons.price.idx + cons.conf.idx + 
                 euribor3m + nr.employed, 
               data = train_data)

# Model summary
cat("\nLinear Regression Summary:\n")
print(summary(lm_model))

# Make predictions on test set
lm_predictions <- predict(lm_model, test_data)

# Convert predictions to binary (threshold = 0.5)
lm_pred_class <- ifelse(lm_predictions > 0.5, "yes", "no")
lm_pred_class <- as.factor(lm_pred_class)

# Evaluate model
lm_confusion <- confusionMatrix(lm_pred_class, test_data$y)
cat("\nLinear Regression Performance:\n")
print(lm_confusion)

lm_accuracy <- lm_confusion$overall['Accuracy']
cat("\nLinear Regression Accuracy:", round(lm_accuracy * 100, 2), "%\n")

# ============================================================================
# 4. MODEL 2: CART (Classification and Regression Tree)
# ============================================================================

cat("\n========================================\n")
cat("MODEL 2: CART (Decision Tree)\n")
cat("========================================\n")

# Build CART model with constraints for a smaller, more interpretable tree
cart_model <- rpart(y ~ age + duration + campaign + previous + 
                      emp.var.rate + cons.price.idx + cons.conf.idx + 
                      euribor3m + nr.employed,
                    data = train_data,
                    method = "class",
                    control = rpart.control(cp = 0.01, maxdepth = 5))

# Display tree structure
cat("\nCART Model Structure:\n")
print(cart_model)

# Visualize the decision tree
cat("\nGenerating decision tree plot...\n")
rpart.plot(cart_model, 
           main = "Decision Tree for Term Deposit Subscription",
           extra = 104,  # Show probabilities and percentages
           box.palette = "GnBu",
           shadow.col = "gray",
           nn = TRUE)

# Make predictions on test set
cart_predictions <- predict(cart_model, test_data, type = "class")

# Evaluate model
cart_confusion <- confusionMatrix(cart_predictions, test_data$y)
cat("\nCART Model Performance:\n")
print(cart_confusion)

cart_accuracy <- cart_confusion$overall['Accuracy']
cat("\nCART Accuracy:", round(cart_accuracy * 100, 2), "%\n")

# Variable importance
cat("\nVariable Importance in CART:\n")
print(cart_model$variable.importance)

# ============================================================================
# 5. MODEL 3: RANDOM FOREST
# ============================================================================

cat("\n========================================\n")
cat("MODEL 3: RANDOM FOREST\n")
cat("========================================\n")

# Build Random Forest model
# Retraining with 500 trees (default)
cat("\nRetraining Random Forest with 500 trees...\n")
rf_model <- randomForest(y ~ age + duration + campaign + previous + 
                           emp.var.rate + cons.price.idx + cons.conf.idx + 
                           euribor3m + nr.employed,
                         data = train_data,
                         ntree = 500,
                         importance = TRUE)

# Model summary
cat("\nRandom Forest Summary:\n")
print(rf_model)

# Make predictions on test set
rf_predictions <- predict(rf_model, test_data)

# Evaluate model
rf_confusion <- confusionMatrix(rf_predictions, test_data$y)
cat("\nRandom Forest Performance:\n")
print(rf_confusion)

rf_accuracy <- rf_confusion$overall['Accuracy']
cat("\nRandom Forest Accuracy:", round(rf_accuracy * 100, 2), "%\n")

# Variable importance
cat("\nVariable Importance in Random Forest:\n")
print(importance(rf_model))

# Plot variable importance
varImpPlot(rf_model, 
           main = "Variable Importance in Random Forest",
           pch = 19,
           col = "steelblue")

# ============================================================================
# 6. CROSS-VALIDATION
# ============================================================================

cat("\n========================================\n")
cat("6. CROSS-VALIDATION (5-FOLD)\n")
cat("========================================\n")

# Define training control
cv_control <- trainControl(method = "cv", number = 5)

# 1. Linear Model (using Logistic Regression for CV Accuracy)
cat("\nRunning CV for Linear Model (Logistic)...\n")
set.seed(123)
lm_cv <- train(y ~ age + duration + campaign + previous + 
                 emp.var.rate + cons.price.idx + cons.conf.idx + 
                 euribor3m + nr.employed,
               data = train_data,
               method = "glm",
               family = "binomial",
               trControl = cv_control)
lm_cv_acc <- lm_cv$results$Accuracy

# 2. CART
cat("Running CV for CART...\n")
set.seed(123)
cart_cv <- train(y ~ age + duration + campaign + previous + 
                   emp.var.rate + cons.price.idx + cons.conf.idx + 
                   euribor3m + nr.employed,
                 data = train_data,
                 method = "rpart",
                 trControl = cv_control,
                 tuneLength = 5)
cart_cv_acc <- max(cart_cv$results$Accuracy)

# 3. Random Forest
cat("Running CV for Random Forest (50 trees for speed)...\n")
set.seed(123)
rf_cv <- train(y ~ age + duration + campaign + previous + 
                 emp.var.rate + cons.price.idx + cons.conf.idx + 
                 euribor3m + nr.employed,
               data = train_data,
               method = "rf",
               trControl = cv_control,
               ntree = 50, # Reduced trees for CV speed
               tuneGrid = data.frame(mtry = floor(sqrt(9))))
rf_cv_acc <- rf_cv$results$Accuracy

cat("\nCV Results (Accuracy):\n")
cat("Linear (Logistic):", round(lm_cv_acc * 100, 2), "%\n")
cat("CART:", round(cart_cv_acc * 100, 2), "%\n")
cat("Random Forest:", round(rf_cv_acc * 100, 2), "%\n")

# ============================================================================
# 7. MODEL COMPARISON
# ============================================================================

cat("\n========================================\n")
cat("MODEL COMPARISON SUMMARY\n")
cat("========================================\n")

# Create comparison table
# Create comparison table
comparison <- data.frame(
  Model = c("Linear Regression", "CART (Decision Tree)", "Random Forest"),
  Test_Accuracy = c(
    round(lm_accuracy * 100, 2),
    round(cart_accuracy * 100, 2),
    round(rf_accuracy * 100, 2)
  ),
  CV_Accuracy = c(
    round(lm_cv_acc * 100, 2),
    round(cart_cv_acc * 100, 2),
    round(rf_cv_acc * 100, 2)
  )
)

cat("\nAccuracy Comparison:\n")
print(comparison)

# Determine best model
# Determine best model based on Test Accuracy
best_model <- comparison$Model[which.max(comparison$Test_Accuracy)]
best_accuracy <- max(comparison$Test_Accuracy)

cat("\n*** BEST MODEL:", best_model, "***\n")
cat("*** ACCURACY:", best_accuracy, "% ***\n")

# ============================================================================
# 8. INTERPRETATION AND INSIGHTS
# ============================================================================

cat("\n========================================\n")
cat("KEY INSIGHTS\n")
cat("========================================\n")

cat("\n1. LINEAR REGRESSION:\n")
cat("   - Simple but not ideal for binary classification\n")
cat("   - Assumes linear relationships\n")
cat("   - Accuracy:", round(lm_accuracy * 100, 2), "%\n")

cat("\n2. CART (Decision Tree):\n")
cat("   - Easy to interpret and visualize\n")
cat("   - Shows clear decision rules\n")
cat("   - Accuracy:", round(cart_accuracy * 100, 2), "%\n")

cat("\n3. RANDOM FOREST:\n")
cat("   - Combines multiple trees for better predictions\n")
cat("   - Usually most accurate but less interpretable\n")
cat("   - Accuracy:", round(rf_accuracy * 100, 2), "%\n")

cat("\n4. MOST IMPORTANT VARIABLES:\n")
cat("   - Duration (call length) is the strongest predictor\n")
cat("   - Economic indicators (euribor3m, nr.employed) are important\n")
cat("   - Campaign contacts and previous contacts matter\n")

cat("\n========================================\n")
cat("ANALYSIS COMPLETE!\n")
cat("========================================\n")
