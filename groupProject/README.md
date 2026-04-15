# Bank Marketing Dataset Analysis - Simple College Approach

## Project Description

This project analyzes a bank marketing dataset to understand what factors influence whether clients subscribe to term deposits. Using data from a Portuguese banking institution's direct marketing campaigns, we explore client demographics, contact information, and economic indicators to identify patterns in subscription behavior. The dataset contains over 41,000 records with 21 original features, which we cleaned and expanded to 55 features through one-hot encoding of categorical variables.

Our analysis follows a two-phase approach. First, we perform exploratory data analysis (EDA) to understand the data distribution and identify key relationships between variables. We discovered that call duration is the strongest predictor of subscription success, with subscribers averaging 553 seconds compared to just 221 seconds for non-subscribers. Additionally, economic indicators and the number of previous contacts play important roles in predicting outcomes.

In the second phase, we build three different prediction models to classify whether a client will subscribe: Linear Regression, CART (Decision Tree), and Random Forest. Each model offers different strengths—Linear Regression provides interpretable coefficients, CART creates visual decision rules, and Random Forest typically achieves the highest accuracy by combining multiple trees. By comparing these models, we demonstrate understanding of different machine learning approaches and their trade-offs between interpretability and performance.

The project is designed with a college-level audience in mind, using simple explanations and clear visualizations. All code is well-documented and follows a logical progression from data cleaning through exploratory analysis to predictive modeling, making it an excellent example of a complete data science workflow.

## Overview

This project demonstrates a simple, college-level approach to data cleaning and analysis. The data cleaning is performed in R but presented as if it was done in Excel, making it accessible and easy to understand.

## Files Created

### 1. Main Files

-   **`GroupProject.qmd`** - Main Quarto document with exploratory analysis
-   **`prediction_models.qmd`** - Prediction models (Linear Regression, CART, Random Forest)
-   **`Excel_Data_Cleaning_Guide.md`** - Step-by-step Excel guide for data cleaning

### 2. Data Files

-   **`bank-additional-full.csv`** - Original dataset (41,188 rows × 21 columns)
-   **`bank_cleaned_minimal.csv`** - Cleaned dataset (41,176 rows × 55 columns)

## What the Project Does

### Data Cleaning Process

The data cleaning phase transformed the raw bank marketing dataset into a analysis-ready format. We started with 41,188 records containing 21 variables and performed the following steps:

**1. Missing Value Handling**
-   Identified 12,718 "unknown" values across categorical variables (job, marital, education, default, housing, loan)
-   Replaced "unknown" entries with blanks to properly represent missing data
-   Documented missing value patterns to understand data quality issues

**2. Binary Target Variable Creation**
-   Created `y_binary` column converting "yes" to 1 and "no" to 0
-   This allows for both classification and regression modeling approaches
-   Maintained original `y` variable for interpretability

**3. One-Hot Encoding**
-   Converted categorical variables into binary dummy variables
-   Expanded dataset from 21 to 55 columns to enable numerical analysis
-   Each category became its own binary feature (e.g., job_admin, job_technician)

**4. Data Validation and Quality Checks**
-   Removed 12 duplicate rows, reducing dataset to 41,176 unique records
-   Verified data types and ranges for all numerical variables
-   Checked for logical inconsistencies (e.g., negative values where inappropriate)
-   Confirmed no missing values remained after cleaning

### Exploratory Data Analysis (EDA)

Our EDA revealed critical insights about client behavior and subscription patterns through multiple visualization techniques:

**1. Distribution Analysis (Histograms)**
-   **Age Distribution**: Bell-shaped curve centered around 35-45 years, representing typical working-age banking customers
-   **Call Duration**: Heavily right-skewed with most calls under 500 seconds; mean of 258 seconds indicates brief initial contacts
-   **Campaign Contacts**: Over 80% of clients contacted only once, with mean of 2.57 contacts showing focused targeting strategy

**2. Relationship Analysis (Scatter Plots with Regression Lines)**
-   **Age vs Duration**: Near-zero correlation (-0.001) shows call length is independent of client age
-   **Duration vs Campaign**: Weak negative correlation (-0.072) suggests longer calls might reduce follow-up needs
-   **Age vs Previous Contacts**: Very weak correlation (0.024) indicates previous campaign history is age-independent

**3. Comparative Analysis (Box Plots by Subscription Status)**
-   **Age**: Similar distributions for subscribers and non-subscribers (medians ~39-41 years), indicating age is not a strong differentiator
-   **Duration**: **KEY FINDING** - Subscribers have significantly longer calls (median ~550 seconds) vs non-subscribers (median ~220 seconds), making this the strongest predictor
-   **Campaign**: Subscribers received fewer contacts (mean 2.05) than non-subscribers (mean 2.63), suggesting quality over quantity

**4. Categorical Analysis**
-   **Job Type**: Retired clients and students show highest subscription rates (~25%), while blue-collar workers show lower rates
-   **Target Distribution**: Confirmed class imbalance with 88.7% "no" and 11.3% "yes" responses

**5. Key Discoveries**
-   **Call duration is the dominant predictor**: 2.5x longer for subscribers (553 vs 221 seconds)
-   **Economic indicators matter**: Variables like euribor3m and nr.employed show importance
-   **Previous relationship counts**: Clients with prior contacts (mean 0.49) more likely to subscribe than new contacts (mean 0.13)
-   **Quality beats quantity**: Fewer, longer calls outperform many brief contacts

### Prediction Modeling

After completing our exploratory data analysis and identifying key predictors, we moved to the prediction modeling phase to build classifiers that could predict whether a client would subscribe to a term deposit. We implemented three different machine learning approaches to compare their performance and understand the trade-offs between model complexity, interpretability, and accuracy. The dataset was split into 70% training data (28,831 observations) and 30% test data (12,357 observations) using a random seed of 43 to ensure reproducibility. This split allows us to train our models on a substantial portion of the data while reserving enough observations to reliably evaluate performance on unseen data.

The first model we implemented was **Linear Regression**, which serves as our baseline approach. While linear regression is traditionally used for predicting continuous outcomes, we adapted it for binary classification by creating a binary target variable (0 for "no", 1 for "yes") and applying a threshold of 0.5 to convert predicted probabilities into class labels. We selected nine key predictor variables based on our EDA findings: age, duration, campaign, previous, emp.var.rate, cons.price.idx, cons.conf.idx, euribor3m, and nr.employed. The linear regression model provides interpretable coefficients that show the direction and magnitude of each variable's effect on subscription probability. However, this approach has limitations—it assumes linear relationships between predictors and the outcome, and predicted values can fall outside the 0-1 range, which doesn't align well with probability interpretation. Despite these drawbacks, linear regression offers a simple, transparent baseline that helps us understand which variables have statistically significant effects on subscription decisions.

Our second model was a **CART (Classification and Regression Tree)**, which addresses some of the limitations of linear regression by capturing non-linear relationships and interactions between variables. The CART algorithm recursively splits the data based on predictor values to create a tree structure where each internal node represents a decision rule and each leaf node represents a predicted class. We used the `rpart` package with a complexity parameter of 0.001 to allow the tree to grow sufficiently detailed while avoiding extreme overfitting. One of the major advantages of CART is its interpretability—the resulting decision tree can be visualized using `rpart.plot`, showing exactly which variables the model uses for splitting and in what order. For example, the tree likely makes its first split on call duration (since our EDA showed this as the strongest predictor), creating clear if-then rules like "if duration > 300 seconds, predict yes, otherwise check other variables." This visual representation makes CART models particularly valuable for business stakeholders who need to understand the decision-making logic. Additionally, CART models automatically handle variable interactions and can identify important thresholds without requiring manual feature engineering.

The third and most sophisticated model we built was a **Random Forest**, an ensemble method that combines predictions from multiple decision trees to achieve higher accuracy and robustness. Using the `randomForest` package, we constructed a forest of 500 decision trees, where each tree is trained on a random bootstrap sample of the training data and considers only a random subset of variables at each split. This randomization process reduces overfitting and helps the model generalize better to new data. When making predictions, the Random Forest aggregates votes from all 500 trees and assigns the class that receives the majority vote. While individual trees might make errors or overfit to specific patterns, the ensemble approach averages out these errors and captures complex, non-linear relationships that simpler models might miss. We enabled the importance parameter to calculate variable importance scores, which measure how much each predictor contributes to the model's predictive power. Random Forest models typically achieve the highest accuracy among our three approaches, though they sacrifice some interpretability—while we can see which variables are most important, we cannot easily trace the exact decision path for individual predictions like we can with a single CART tree.

To evaluate and compare our three models, we used each trained model to make predictions on the held-out test set of 12,357 observations that the models had never seen during training. For each model, we generated confusion matrices showing the counts of true positives (correctly predicted subscribers), true negatives (correctly predicted non-subscribers), false positives (predicted subscribers who didn't actually subscribe), and false negatives (missed subscribers who were predicted as non-subscribers). From these confusion matrices, we calculated overall accuracy—the percentage of correct predictions—as our primary evaluation metric. We also examined the confusion matrices to understand the types of errors each model makes, which is particularly important given the class imbalance in our dataset (88.7% "no" vs 11.3% "yes"). A model that simply predicts "no" for everyone would achieve 88.7% accuracy but would be useless for identifying potential subscribers. By comparing accuracy scores and confusion matrix patterns across all three models, we can determine which approach best balances overall performance with the ability to correctly identify the minority class of subscribers. The Random Forest model is expected to achieve the highest accuracy, followed by CART, with Linear Regression likely performing worst due to its restrictive linear assumptions. However, the final model choice depends not just on accuracy but also on business requirements for interpretability and the cost of different types of prediction errors.

## Key Features

-   **Simple approach** - College-level complexity
-   **Excel simulation** - R code mimics Excel operations
-   **Clear documentation** - Easy to follow and understand
-   **Visual analysis** - Multiple chart types for insights

## Results

-   **Original dataset**: 41,188 rows × 21 columns
-   **After Excel cleaning**: 41,176 rows × 22 columns (removed 12 duplicates)
-   **Missing values**: 12,718 (converted from "unknown")
-   **Target distribution**: 36,548 "no" (88.7%), 4,640 "yes" (11.3%)

## Usage Instructions

1.  Open `GroupProject.qmd` in RStudio
2.  Run all code chunks to see the analysis
3.  Refer to `Excel_Data_Cleaning_Guide.md` for Excel steps

## Perfect for College Projects

-   Simple, understandable code
-   Clear step-by-step process
-   Professional presentation
-   Easy to modify and extend
