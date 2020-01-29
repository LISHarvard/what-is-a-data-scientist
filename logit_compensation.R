library(MASS)
library(nnet)
library(car)

# read in data
df = read.csv("/Users/hayleeham/Documents/what-is-a-data-scientist/data/compensation_data.csv")
df_usa = read.csv("/Users/hayleeham/Documents/what-is-a-data-scientist/data/compensation_data_usa.csv")
df10 = read.csv("/Users/hayleeham/Documents/what-is-a-data-scientist/data/compensation_data_10.csv")

linear_hypo <- function(model){
  jobs = c("data_sci", "software_eng", "data_ana", "r_sci", "r_ast", "consultant", "data_eng", "bus_ana", "manager")
  
  for (i1 in 1:length(jobs)){
    job1 = jobs[i1]
    print(c("JOB 1", job1))
    significant = c()
    not_significant = c()
    si = 1
    nsi = 1
    for (i2 in 1:length(jobs)){
      if (i2 > i1){
        job2 = jobs[i2]
        p <- linearHypothesis(model,c(paste(job1," = ", job2)))
        if (p$"Pr(>F)"[2] < 0.05){
          significant[si] = job2
          si = si + 1
        }
        else{
          not_significant[nsi] = job2
          nsi = nsi + 1
        }
      }
    }
    if (length(significant) > 0){
      print("Significant")
      print(significant)
    }
    if (length(not_significant) > 0){
      print("Not Significant")
      print(not_significant)
    }
  }
}

# try running the model as a simple OLS using the averages from the salary buckets
# restrict to US
model_fit_ols <- lm(avg~clean_data+data_viz+build_model+model_prod+comm_insights+female+tech+academia+exp+no_bach+masters+pro+phd+data_sci+software_eng+data_ana+r_sci+r_ast+consultant+data_eng+bus_ana+manager+other_job-1, data = df_usa)
summary(model_fit_ols)

# how about how time spent affects job title
# model_fit_title <- multinom(Q6~clean_data+data_viz+build_model+model_prod+comm_insights+female+tech+academia+exp+bachelors+masters+phd, data = df_usa)
# summary(model_fit_title)
# create the p values
# z <- summary(model_fit_title)$coefficients/summary(model_fit_title)$standard.errors
# p <- (1 - pnorm(abs(z), 0, 1)) * 2
# p

# how about how job title etc. effects time spent
model_clean_data <- lm(clean_data~female+india+china+other_country+tech+academia+exp+no_bach+masters+pro+phd+avg+data_sci+software_eng+data_ana+r_sci+r_ast+consultant+data_eng+bus_ana+manager+other_job-1, data = df)
summary(model_clean_data)

model_data_viz <- lm(data_viz~female+india+china+other_country+tech+academia+exp+no_bach+masters+pro+phd+avg+data_sci+software_eng+data_ana+r_sci+r_ast +consultant+data_eng+bus_ana+manager+other_job-1, data = df)
summary(model_data_viz)
# specify no constant
# include other dummy
# can plot with standard errors
# post hoc hypothesis test: 
# every row is a covariate and the diagonal with sqrt is the standard error
# the test is going to look like restriction vector multiplied through covariance matrix to get test statistic like chi squared

# Baseline: male, usa, other_industry, bachelors
model_build_model <- lm(build_model~female+india+china+other_country+tech+academia+exp+no_bach+masters+pro+phd+avg+data_sci+software_eng+data_ana+r_sci+r_ast+consultant+data_eng+bus_ana+manager+other_job-1, data = df)
summary(model_build_model)

model_model_prod <- lm(model_prod~female+india+china+other_country+tech+academia+exp+no_bach+masters+pro+phd+avg+data_sci+software_eng+data_ana+r_sci+r_ast+consultant+data_eng+bus_ana+manager+other_job-1, data = df)
summary(model_model_prod)

model_comm_insights <- lm(comm_insights~female+india+china+other_country+tech+academia+exp+no_bach+masters+pro+phd+avg+data_sci+software_eng+data_ana+r_sci+r_ast+consultant+data_eng+bus_ana+manager+other_job-1, data = df)
summary(model_comm_insights)
