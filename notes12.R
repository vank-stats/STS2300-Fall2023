# Notes 12 Code

library(infer)
library(ggplot2)


# Age discrimination example

# Step 1 - Determine hypotheses (no code)


# Step 2 - Gather and summarize data

layoffs <- data.frame(age = c(25, 33, 35, 38, 48, 55, 55, 55, 56, 64),
                      laidoff = c("No", "No", "No", "No", "No", 
                                  "Yes", "Yes", "No", "No", "Yes"))

## Calculating a difference in sample means
obs_xbardiff <- layoffs %>%
  specify(formula = age ~ laidoff) %>%
  calculate(stat = "diff in means", order = c("Yes", "No"))
obs_xbardiff

## Calculating a t statistic

obs_t <- layoffs %>%
  specify(formula = age ~ laidoff) %>%
  calculate(stat = "t", order = c("Yes", "No"))
obs_t


# Step 3 - Comparing data to null hypothesis using infer

set.seed(201005)

# Generates a null distribution of 1,000 differences in sample means from a 
#   world where layoffs are random (i.e. age is independent of being laid off)

layoff_perm <- layoffs %>%
  specify(formula = age ~ laidoff) %>%
  hypothesize(null = "independence") %>%
  generate(reps = 1000, type = "permute") %>%
  calculate(stat = "diff in means", order = c("Yes", "No"))

# Graphs the null distribution with p-value shaded on graph

visualize(layoff_perm) +
  shade_pvalue(obs_stat = obs_xbardiff, direction = "right")

# Calculate the p-value using the null distribution

layoff_perm %>%
  get_pvalue(obs_stat = obs_xbardiff, direction = "right")


# Step 4 - Reaching conclusions (no code)