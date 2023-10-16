# Notes 09 Code

library(infer)
library(dplyr)
library(ggplot2)

# Example of general structure for using infer package to get a bootsrap dist.

bootstrap_dist <- data %>%
  specify(formula = response ~ explanatory) %>%
  generate(reps = 1000, type = "bootstrap") %>%
  calculate(stat = "ourstat")
visualize(bootstrap_dist)

# Read in House of Reps data and take a sample of size 30

house_of_reps <- read.csv("https://raw.githubusercontent.com/vank-stats/STS2300-Fall2023/main/house_of_reps.csv")

set.seed(82720)
mysamp <- sample_n(house_of_reps, size = 30)
table(mysamp$party)

# Applying infer package to House of Reps example

HOR_boot <- mysamp %>%
  specify(formula = party ~ NULL, success = "Democratic") %>%
  generate(reps = 1000, type = "bootstrap") %>%
  calculate(stat = "prop")


# If you have Vacant seats in your sample, this will bring your variable back
# to just two categories

# mysamp <- mysamp %>%
#   mutate(party = ifelse(party == "Democratic", "Democratic", "Not Democratic"))


visualize(HOR_boot) +
  geom_vline(xintercept = 13 / 30, 
             color = "yellow", 
             linewidth = 3) +
  labs(subtitle = "Yellow line is our original sample proportion")



# Calculating our sample proportion

phat <- mean(mysamp$party == "Democratic")
phat

# Calculating a theory-based 90% confidence interval

ci_theory <- c(phat - 1.645 * sqrt(phat * (1 - phat) / 30),
               phat + 1.645 * sqrt(phat * (1 - phat) / 30))
ci_theory


# Calculating a standard error method 90% CI

boot_sd <- sd(HOR_boot$stat)
c(phat - 1.645 * boot_sd, phat + 1.645 * boot_sd)

# Using the get_ci() function instead

ci_se <- HOR_boot %>%
  get_ci(level = 0.9, type = "se", point_estimate = phat)
ci_se


# Calculating a percentile method 90% CI

ci_perc <- HOR_boot %>%
  get_ci(level = 0.9, type = "percentile")
ci_perc


# Using shade_ci() to display our CIs on our bootstrap distribution

library(patchwork)

se <- visualize(HOR_boot) +
  shade_ci(ci_se)
perc <- visualize(HOR_boot) +
  shade_ci(ci_perc, 
           fill = "violet", 
           color = "lightpink")

se + perc
