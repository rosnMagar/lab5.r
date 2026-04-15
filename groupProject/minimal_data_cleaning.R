# Minimal Data Cleaning Script for Bank Marketing Dataset
# This script performs only essential cleaning steps that cannot be easily done in Excel

# Load required packages
library(tidyverse)

# Load data
bank <- read.csv("bank-additional/bank-additional/bank-additional-full.csv", sep = ";")
cat("Original dataset:", nrow(bank), "rows,", ncol(bank), "columns\n")

# Step 1: Handle "unknown" values (convert to NA for consistency)
bank_clean <- bank
bank_clean[bank_clean == "unknown"] <- NA
cat("Converted 'unknown' to NA values\n")

# Step 2: One-hot encode categorical variables (essential for ML models)
# This is the main step that's difficult to do efficiently in Excel
categorical_vars <- c("job", "marital", "education", "default", "housing", 
                      "loan", "contact", "month", "day_of_week", "poutcome")

bank_encoded <- bank_clean
for (var in categorical_vars) {
  if (var %in% names(bank_encoded)) {
    # Create dummy variables using model.matrix
    temp_var <- factor(bank_encoded[[var]], exclude = NULL)
    dummy_matrix <- model.matrix(~ temp_var)[, -1, drop = FALSE]
    colnames(dummy_matrix) <- sub("^temp_var", "", colnames(dummy_matrix))
    colnames(dummy_matrix) <- paste0(var, "_", colnames(dummy_matrix))
    bank_encoded <- cbind(bank_encoded, dummy_matrix)
  }
}

# Create binary target variable
bank_encoded$y_binary <- ifelse(bank_encoded$y == "yes", 1, 0)

# Remove original categorical columns (keep y for reference)
bank_encoded <- bank_encoded[, !names(bank_encoded) %in% categorical_vars]

cat("Encoding complete. Final dataset:", nrow(bank_encoded), "rows,", ncol(bank_encoded), "columns\n")

# Step 3: Save cleaned dataset
write.csv(bank_encoded, "bank_cleaned_minimal.csv", row.names = FALSE)
cat("Cleaned dataset saved as 'bank_cleaned_minimal.csv'\n")

# Display summary
cat("\nDataset Summary:\n")
cat("- Rows:", nrow(bank_encoded), "\n")
cat("- Columns:", ncol(bank_encoded), "\n")
cat("- Missing values:", sum(is.na(bank_encoded)), "\n")
cat("- Target distribution:\n")
print(table(bank_encoded$y, useNA = "ifany"))
