# Notes 13 Code

library(infer)
library(ggplot2)
library(dplyr)


# Reading data into R for HT for p example

mice <- read.csv("https://raw.githubusercontent.com/vank-stats/STS2300-Fall2023/main/mice.csv")


# Calculating sample proportion of mice with drug resistant bacteria

mice_phat <- mean(mice$drugresist == "Yes")


# Generic null distribution code for hypothesis tests for p

# null_dist <- data %>%
#   specify(formula = response ~ NULL, success = "level") %>%
#   hypothesize(null = "point", p = nullvalue) %>%
#   generate(reps = 1000, type = "draw") %>%
#   calculate(stat = "prop")


# Generating our null distribution

set.seed(1008111)
mice_null <- mice %>%
  specify(formula = drugresist ~ NULL, success = "Yes") %>%
  hypothesize(null = "point", p = 0.25) %>%
  generate(reps = 1000, type = "draw") %>%
  calculate(stat = "prop")

visualize(mice_null) +
  shade_pvalue(obs_stat = mice_phat,
               direction = "left")




# Differences in proportions example

# Reading in data

library(readr)
ACA_survey <- read_delim("https://www.openintro.org/data/tab-delimited/healthcare_law_survey.txt", "\t", 
                         escape_double = FALSE, 
                         trim_ws = TRUE) %>%
  mutate(response = ifelse(response == "approve", "approve", "dont"))


# Stacked bar graph to visualize data

ggplot(ACA_survey, aes(x = order, fill = response)) +
  geom_bar(position = "fill")


# Calculate a difference in sample proportions

ACA_obsphatdiff <- ACA_survey %>%
  specify(formula = response ~ order, success = "approve") %>%
  calculate(stat = "diff in props", 
            order = c("cannot_afford_second", "penalty_second"))
ACA_obsphatdiff


# Generic code for a null distribution

# null_dist <- data %>%
#   specify(formula = response ~ explanatory, success = "level") %>%
#   hypothesize(null = "independence") %>%
#   generate(reps = 1000, type = "permute") %>%
#   calculate(stat = "diff in props", order = c("first", "second"))


# Generate a null distribution for this example

set.seed(1002113)
ACA_boot <- ACA_survey %>%
  specify(formula = response ~ order, success = "approve") %>%
  hypothesize(null = "independence") %>%
  generate(reps = 10000, type = "permute") %>%
  calculate(stat = "diff in props", 
            order = c("cannot_afford_second", "penalty_second"))

# Graph null distribution with p-value shaded

visualize(ACA_boot) +
  shade_pvalue(obs_stat = ACA_obsphatdiff,
               direction = "both")

# Calculate the p-value (pay attention to the warning!)

ACA_boot %>%
  get_pvalue(obs_stat = ACA_obsphatdiff,
             direction = "both")




# Theory-based test for single proportion mice example

table(mice$drugresist) # to find values for x and n

prop.test(x = 95,
          n = 321 + 95,
          p = 0.25,
          alternative = "less")


# Theory-based test for diff in proportions ACA example

table(ACA_survey$order, ACA_survey$response)

prop.test(x = c(365, 249),
          n = c(365 + 406, 249 + 483),
          alternative = "two.sided")
