library(tidyverse)
library(randomForest)

# Load data
basic_income_clean <- read.csv("basic_income.csv")

# Recreate simpler_vote
simple_vote <- basic_income_clean %>%
  drop_na() %>%
    mutate(voteInFavor=as.factor(case_when(
	vote == "I would vote for it" ~ TRUE,
	vote == "I would probably vote for it" ~ TRUE,
	vote == "I would probably vote against it" ~ FALSE,
	vote == "I would vote against it" ~ FALSE)))

simpler_vote <- simple_vote %>%
  select(-vote, -pro_count, -con_count, -pro_none, -effect) %>%
  drop_na()

# Split data
set.seed(2000)
vote_train <- sample_frac(simpler_vote, .7)

# Run Random Forest
set.seed(052020)
vote.rf <- randomForest(voteInFavor ~ ., data=vote_train)

# Print variable importance
importance_df <- as.data.frame(importance(vote.rf))
importance_df$Variable <- rownames(importance_df)
importance_df <- importance_df %>% arrange(desc(MeanDecreaseGini))

print(importance_df)
