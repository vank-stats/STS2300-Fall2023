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
