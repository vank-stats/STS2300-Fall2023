# Notes 14 Code

library(infer)
library(ggplot2)
library(dplyr)


# Hypothesis tests for a single mean

# Reading data into R

bodytemps <- data.frame(temperature = c(97.39, 97.45, 97.96, 97.35, 96.74, 99.66,
                                        98.21, 99.02, 96.78, 97.70, 96.90, 97.29,
                                        97.99, 97.73, 98.18, 97.78, 97.17, 97.34,
                                        97.56, 98.13, 97.77, 97.07, 97.13, 96.74, 
                                        99.10, 96.76, 96.19, 97.84, 96.80, 98.09))

# Create a graph of the data

ggplot(bodytemps, aes(x = temperature)) +
  geom_histogram(binwidth = .5, color = "white")


# One way to find a sample mean

temp_xbar <- mean(bodytemps$temperature)

# Another way to find a sample mean

temp_xbar <- bodytemps %>%
  specify(temperature ~ NULL) %>%
  calculate(stat = "mean")


# Generic null distribution code for a single mean

# null_dist <- data %>%
#   specify(formula = response ~ NULL) %>%
#   hypothesize(null = "point", mu = nullvalue) %>%
#   generate(reps = 1000, type = "bootstrap") %>%
#   calculate(stat = "mean")


# Generate a null distribution

set.seed(947116)

temps_null <- bodytemps %>%
  specify(formula = temperature ~ NULL) %>%
  hypothesize(null = "point", mu = 98.6) %>%
  generate(reps = 1000, type = "bootstrap") %>%
  calculate(stat = "mean")

visualize(temps_null) +
  shade_pvalue(obs_stat = temp_xbar,
               direction = "both")

# Calculate a p-value

temps_null %>%
  get_pvalue(obs_stat = temp_xbar,
             direction = "both")



# Difference in means ESP example

# Read in the data

esp <- read.csv("https://raw.githubusercontent.com/vank-stats/STS2300-Fall2023/main/esp.csv")


# Calculate a difference in sample means (using infer)

esp_stat <- esp %>%
  specify(Matches ~ Group) %>%
  calculate(stat = "diff in means", order = c("believer", "skeptic"))
esp_stat


# Two ways to graph our data

ggplot(esp, aes(x = Matches, y = Group)) +
  geom_boxplot()

ggplot(esp, aes(x = Matches)) +
  geom_histogram(binwidth = 2, color = "white") +
  facet_wrap(vars(Group), ncol = 1)


# Generate a null distribution

set.seed(1312)
esp_null <- esp %>%
  specify(formula = Matches ~ Group) %>%
  hypothesize(null = "independence") %>%
  generate(reps = 1000, type = "permute") %>%
  calculate(stat = "diff in means", order = c("believer", "skeptic"))

visualize(esp_null) +
  shade_pvalue(obs_stat = esp_stat,
               direction = "right")

esp_null %>%
  get_pvalue(obs_stat = esp_stat,
             direction = "right")



# Theory-based test for single mean (bodytemps)

t.test(bodytemps$temperature, mu = 98.6, alternative = "two.sided")

# Theory-based test for a difference in means (esp)

t.test(Matches ~ Group, data = esp, alternative = "greater")
