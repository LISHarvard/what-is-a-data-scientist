library(MASS)
library(ggplot2)
library(nnet)

# read in data
df = read.csv("/Users/hayleeham/Documents/what-is-a-data-scientist/compensation_data.csv")

# how does time spent affect compensation
# model_fit <- polr(Q9~Q34_Part_1+Q34_Part_2+Q34_Part_3+Q34_Part_4+Q34_Part_5+gender+usa+india+china+tech+academia+exp, data = df, Hess = TRUE)
# summary(model_fit)
# # create the p values
# summary_table <- coef(summary(model_fit))
# pval <- pnorm(abs(summary_table[, "t value"]),lower.tail = FALSE)* 2
# summary_table <- cbind(summary_table, "p value" = round(pval,3))
# summary_table

# try running the model as a simple OLS using the averages from the buckets
model_fit_ols <- lm(avg~clean_data+data_viz+build_model+model_prod+comm_insights+female+usa+india+china+tech+academia+exp+Data.Scientist+Software.Engineer+Data.Analyst+Research.Scientist+Consultant+Data.Engineer+Business.Analyst+Manager+Research.Assistant, data = df)
summary(model_fit_ols)

# read in data
df10 = read.csv("/Users/hayleeham/Documents/what-is-a-data-scientist/compensation_data_10.csv")

# how about how time spent affects job title
model_fit_title <- multinom(Q6~clean_data+data_viz+build_model+model_prod+comm_insights+female+usa+india+china+tech+academia+exp, data = df10)
summary(model_fit_title)
# create the p values
z <- summary(model_fit_title)$coefficients/summary(model_fit_title)$standard.errors
p <- (1 - pnorm(abs(z), 0, 1)) * 2
p
