# Notes 10 Code

library(infer)
library(dplyr)
library(ggplot2)

# Template for bootstrap distribution for a single proportion

# boot_dist <- data %>%
#   specify(formula = response ~ NULL, success = "level") %>%
#   generate(reps = 1000, type = "bootstrap") %>%
#   calculate(stat = "prop")


# House of Representatives Example
# Read in data and take sample of 30 seats

house_of_reps <- read.csv("https://raw.githubusercontent.com/vank-stats/STS2300-Fall2023/main/house_of_reps.csv")

set.seed(82720)
HOR_samp <- sample_n(house_of_reps, size = 30)


# Generate our bootstrap distribution and graph it

HOR_boot <- HOR_samp %>%
  specify(formula = party ~ NULL, success = "Democratic") %>%
  generate(reps = 1000, type = "bootstrap") %>%
  calculate(stat = "prop")
visualize(HOR_boot)


# Calculate a 90% CI using the percentile method (and graph it)

HOR_ci_perc <- HOR_boot %>%
  get_ci(level = 0.9, type = "percentile")
HOR_ci_perc

visualize(HOR_boot) +
  shade_ci(HOR_ci_perc)


# Calculate a 90% CI using the standard error method

# We can first calculate our estimate by removing the generate() line from our 
#   bootstrap code

HOR_phat <- HOR_samp %>%
  specify(formula = party ~ NULL, success = "Democratic") %>%
  calculate(stat = "prop")

HOR_ci_se <- HOR_boot %>%
  get_ci(level = 0.9, type = "se", point_estimate = HOR_phat)
HOR_ci_se


# Calculate a 90% CI using the theory-based method

HOR_ci_theory <- prop.test(x = 13, n = 30, conf.level = 0.9)$conf.int
HOR_ci_theory



# Template for bootstrap distribution for a difference in proportions

# boot_dist <- data %>%
#   specify(formula = response ~ explanatory, success = "level") %>%
#   generate(reps = 1000, type = "bootstrap") %>%
#   calculate(stat = "diff in props", order = c("group 1", "group 2"))


# Penguins example - read in data and restrict sampel

library(palmerpenguins)
penguin_samp <- filter(penguins, species != "Adelie", 
                       !is.na(sex))


# Generate a bootstrap distribution for a diff in means and graph it

penguin_boot <- penguin_samp %>%
  specify(formula = sex ~ species, success = "female") %>%
  generate(reps = 1000, type = "bootstrap") %>%
  calculate(stat = "diff in props", order = c("Chinstrap", "Gentoo"))

visualize(penguin_boot)


# Calculate a 99% confidence interval using the percentile method 

penguin_boot %>%
  get_ci(level = 0.99, type = "percentile")


# Calculate a 99% confidence interval using the SE method 

penguin_phatdiff <- penguin_samp %>%
  specify(formula = sex ~ species, success = "female") %>%
  calculate(stat = "diff in props", order = c("Chinstrap", "Gentoo"))

penguin_boot %>%
  get_ci(level = 0.99, type = "se", point_estimate = penguin_phatdiff)


# Calculate a 99% CI using the theory-based method

table(penguin_samp$species, penguin_samp$sex)
prop.test(x = c(34, 58), n = c(68, 119), conf.level = 0.99)$conf.int