# Notes 11 Code

library(infer)
library(dplyr)
library(ggplot2)
library(palmerpenguins)


# Generic code for single mean bootstrap dist.

# boot_dist <- data %>%
#   specify(formula = response ~ NULL) %>%
#   generate(reps = 1000, type = "bootstrap") %>%
#   calculate(stat = "mean")


# Penguins example

# Calculating the sample mean bill length

bill_xbar <- mean(penguins$bill_length_mm, na.rm = TRUE)
bill_xbar

# Create a graph for your sample bill lengths

ggplot(penguins, aes(x = bill_length_mm)) +
  geom_histogram(binwidth = 1,
                 boundary = 40,
                 color = "cyan")

# Generate a bootstrap distribution for sample mean bill lengths

set.seed(4392)
bill_boot <- penguins %>%
  specify(formula = bill_length_mm ~ NULL) %>%
  generate(reps = 1000, type = "bootstrap") %>%
  calculate(stat = "mean")

# Graph bootstrap distribution with sample mean plotted on graph

visualize(bill_boot) +
  geom_vline(xintercept = bill_xbar,
             color = "orange",
             linewidth = 2)

# 95% CI for pop mean bill length using percentile or SE method

bill_boot %>%
  get_ci(level = 0.95, type = "percentile")

bill_boot %>%
  get_ci(level = 0.95, type = "se", point_estimate = bill_xbar)

# 95% CI for pop mean bill length using theory-based method

t.test(x = penguins$bill_length_mm, conf.level = 0.95)


# Practice 99% bootstrap CI for penguin body mass

set.seed(4392)
mass_boot <- penguins %>%
  specify(formula = body_mass_g ~ NULL) %>%
  generate(reps = 1000, type = "bootstrap") %>%
  calculate(stat = "mean")
get_ci(mass_boot, level = 0.99, type = "percentile")



# Differences in means

# Creating a new sample of just Adelie penguins who aren't missing sex variable

adelie <- filter(penguins, species == "Adelie",
                 !is.na(sex))

# Graph comparing bill length across sexes

ggplot(adelie, aes(x = bill_length_mm, y = sex)) +
  geom_boxplot()


adelie_boot <- adelie %>%
  specify(formula = bill_length_mm ~ sex) %>%
  generate(reps = 1000, type = "bootstrap") %>%
  calculate(stat = "diff in means", order = c("female", "male"))

adelie_estimate <- adelie %>%
  specify(formula = bill_length_mm ~ sex) %>%
  calculate(stat = "diff in means", order = c("female", "male"))
adelie_estimate

adelie_boot %>%
  get_ci(level = 0.9, type = "se", point_estimate = adelie_estimate)


# 90% Theory-based CI

t.test(bill_length_mm ~ sex, conf.level = 0.9, data = adelie)
