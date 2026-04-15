# Bank Marketing Dataset Analysis - Project Overview

## What You're Going to Explore

- Explore how many clients will subscribe to term deposits for the next term
- Understand which factors influence "yes" or "no" decisions
- Identify patterns between client characteristics (age, job type, call duration, previous contacts) and subscription behavior

## What Kinds of Variables Do You Have?

**Dataset**: 21 variables, 41,188 observations

**Key variables**: age (17-98 years), job (categorical: services, management, student, retired, blue-collar, technician, etc.), marital status, education, housing loan, personal loan, duration (0-4,918 seconds), campaign contacts (1-56), previous contacts (0-7), y (target: "yes"/"no"). Additional: contact type, month, day, previous outcome, economic indicators.

## Why They Matter?

**Demographic factors**: Age, job, and housing status affect financial behavior. Retired people and students have different savings levels. Clients with housing loans may be less likely to subscribe due to existing commitments.

**Key findings**: **Call Duration** - Strongest predictor: subscribers average 553 seconds (9.2 min) vs non-subscribers 221 seconds (3.7 min), 2.5x difference. **Job Type** - Retired clients ~25% rate (highest), students/management higher rates, blue-collar/technicians lower rates. **Campaign Contacts** - Subscribers received fewer (2.05 vs 2.63), suggesting quality over quantity. **Previous Contacts** - Subscribers had more (0.49 vs 0.13), indicating repeat interactions build trust.

## Explain Your Dataset in a Paragraph, Including at Least One Outside Source

The bank marketing dataset contains 41,188 observations of banking clients contacted during a term deposit marketing campaign. Similar to Moro et al. (2014), which uses machine learning to predict bank depositor behavior, our analysis explores the same patterns through exploratory data analysis. Both studies examine how demographic variables (age, job, education, marital status) and campaign variables (duration, contacts) influence subscription decisions. However, Moro et al. use decision trees with accuracy metrics, while we focus on visualizations and summary statistics. Our approach reveals call duration as the strongest factor (2.5x longer for subscribers), aligning with research showing customer engagement during contact is critical for subscription success. **Reference**: Moro, S., Cortez, P., & Rita, P. (2014). A Data-Driven Approach to Predict the Success of Bank Telemarketing. *Decision Support Systems*, 62, 22-31.

## Did You Use All of Your Data or a Subset?

- Used full dataset: 41,188 rows
- After cleaning: maintained all 41,188 observations (removed 12 duplicates)
- Created 55 features after one-hot encoding
- No data excluded - analysis represents entire population

## What Variables Are Probably Important?

**Strong predictors**: **Duration** - Most important (subscribers ~550s median vs non-subscribers ~220s, distributions barely overlap). **Job Type** - Retired ~25%, students ~20%, management higher, blue-collar/technicians lower. **Previous Contacts** - Subscribers 0.49 average (4x higher than non-subscribers 0.13). **Campaign Contacts** - Subscribers received fewer (2.05 vs 2.63), conversions happen early. **Age** - Weak relationship (subscribers 40.9 vs non-subscribers 39.9 years).

**Weak/no relationship**: Age vs Duration (-0.001), Duration vs Campaign (-0.072), Age vs Previous (0.024).

## Conclusion

**Subscription rate**: Only 11.3% subscribed (4,640 out of 41,188). Class imbalance: 88.7% "no" vs 11.3% "yes" - important for predictive modeling.

**Key findings**: (1) Call duration strongest predictor - subscribers spend 2.5x longer, distributions barely overlap, engagement critical. (2) Job type matters - retired/students highest rates, blue-collar/technicians lower. (3) Quality over quantity - fewer campaign contacts but more previous contacts, meaningful conversations matter. (4) Demographics less predictive - age shows minimal difference, engagement factors more important.

**Implications**: Focus on longer, engaging conversations and target specific job types (retired, students, management) to improve subscription rates. Findings guide machine learning analysis to identify strongest predictors and build predictive models.