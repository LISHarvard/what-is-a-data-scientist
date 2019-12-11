library(MASS)
library(ggplot2)
library(nnet)

# read in data
df = read.csv("/Users/hayleeham/Documents/what-is-a-data-scientist/compensation_data.csv")

# how does time spent affect compensation
# model_fit <- polr(Q9~Q34_Part_1+Q34_Part_2+Q34_Part_3+Q34_Part_4+Q34_Part_5+gender+usa+india+china+tech+academia+exp+bachelors+masters+phd, data = df, Hess = TRUE)
# summary(model_fit)
# # create the p values
# summary_table <- coef(summary(model_fit))
# pval <- pnorm(abs(summary_table[, "t value"]),lower.tail = FALSE)* 2
# summary_table <- cbind(summary_table, "p value" = round(pval,3))
# summary_table

# try running the model as a simple OLS using the averages from the salary buckets
model_fit_ols <- lm(avg~clean_data+data_viz+build_model+model_prod+comm_insights+female+usa+india+china+tech+academia+exp+Data.Scientist+Software.Engineer+Data.Analyst+Research.Scientist+Consultant+Data.Engineer+Business.Analyst+Manager+Research.Assistant, data = df)
summary(model_fit_ols)

# read in data
df10 = read.csv("/Users/hayleeham/Documents/what-is-a-data-scientist/compensation_data_10.csv")

# how about how time spent affects job title
model_fit_title <- multinom(Q6~clean_data+data_viz+build_model+model_prod+comm_insights+female+usa+india+china+tech+academia+exp+bachelors+masters+phd, data = df10)
summary(model_fit_title)
# create the p values
z <- summary(model_fit_title)$coefficients/summary(model_fit_title)$standard.errors
p <- (1 - pnorm(abs(z), 0, 1)) * 2
p

# how about how job title etc. effects time spent
model_clean_data <- lm(clean_data~female+usa+india+china+tech+academia+exp+bachelors+masters+phd+avg+data_sci+software_eng+data_ana+r_sci+r_ast+consultant+data_eng+bus_ana+manager, data = df)
summary(model_data_clean)

model_data_viz <- lm(data_viz~female+usa+india+china+tech+academia+exp+bachelors+masters+phd+avg+data_sci+software_eng+data_ana+r_sci+r_ast +consultant+data_eng+bus_ana+manager, data = df)
summary(model_data_viz)

model_build_model <- lm(build_model~female+usa+india+china+tech+academia+exp+bachelors+masters+phd+avg+data_sci+software_eng+data_ana+r_sci+r_ast+consultant+data_eng+bus_ana+manager, data = df)
summary(model_build_model)

model_model_prod <- lm(model_prod~female+usa+india+china+tech+academia+exp+bachelors+masters+phd+avg+data_sci+software_eng+data_ana+r_sci+r_ast+consultant+data_eng+bus_ana+manager, data = df)
summary(model_model_prod)

model_comm_insights <- lm(comm_insights~female+usa+india+china+tech+academia+exp+bachelors+masters+phd+avg+data_sci+software_eng+data_ana+r_sci+r_ast+consultant+data_eng+bus_ana+manager, data = df)
summary(model_comm_insights)
