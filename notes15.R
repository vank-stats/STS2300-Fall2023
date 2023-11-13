# Notes 15 Code

library(infer)
library(ggplot2)
library(dplyr)

# Read in cereal data

cereal <- data.frame(design = c(rep("A", 5), rep("B", 5), 
                                rep("C", 5), rep("D", 5)),
                     sales = c(19, 17, 16, 19, 15, 12, 18, 15, 19, 11,
                               23, 20, 18, 17, 24, 27, 33, 22, 26, 20))

# Visualize the data

set.seed(123) # Used so the points don't shift each time I make the graph
ggplot(cereal, aes(x = design, y = sales)) +
  geom_boxplot() +
  geom_jitter(height = 0, width = 0.1, size = 3)


# Calculate F stat using infer

cereal %>%
  specify(sales ~ design) %>%
  calculate(stat = "F")

# Calculate F stat using base R functions

aov(sales ~ design, data = cereal) %>%
  summary()


# Creating a null distribution

set.seed(1010)
cereal_null <- cereal %>%
  specify(formula = sales ~ design) %>%
  hypothesize(null = "independence") %>%
  generate(reps = 1000, type = "permute") %>%
  calculate(stat = "F")

visualize(cereal_null) +
  shade_pvalue(obs_stat = 8.423,
               direction = "right")

get_pvalue(cereal_null,
           obs_stat = 8.423,
           direction = "right")




# Chi-squared example

# Read in data and view it as a table

college <- data.frame(worthit = factor(c(rep("def_yes", 263), rep("prob_yes", 197),
                                         rep("prob_no", 90), rep("def_no", 47),
                                         rep("def_yes", 527), rep("prob_yes", 331),
                                         rep("prob_no", 88), rep("def_no", 29)),
                                       levels = c("def_yes", "prob_yes",
                                                  "prob_no", "def_no")),
                      firstgen = c(rep("yes", 263 + 197 + 90 + 47),
                                   rep("no", 527 + 331 + 88 + 29)))

table(college$worthit, college$firstgen)


# Visualize the data

ggplot(college, aes(x = firstgen, fill = worthit)) +
  geom_bar(position = "fill")


# Calculate a Chi-Squared statistic (using infer)

college %>%
  specify(firstgen ~ worthit) %>%
  calculate(stat = "Chisq")

# Calculate a Chi-Squared statistic (using base R functions)

chisq.test(college$worthit, college$firstgen)


# Null distribution generic code

# null_dist <- data %>%
#   specify(formula = var1 ~ var2) %>%
#   hypothesize(null = "independence") %>%
#   generate(reps = 1000, type = "permute") %>%
#   calculate(stat = "Chisq")

# Null distribution for this example

set.seed(95113)
college_null <- college %>%
  specify(formula = worthit ~ firstgen) %>%
  hypothesize(null = "independence") %>%
  generate(reps = 1000, type = "permute") %>%
  calculate(stat = "Chisq")

visualize(college_null) +
  shade_pvalue(obs_stat = 37.809,
               direction = "right")

# Calculate a p-value

get_pvalue(college_null,
           obs_stat = 37.809,
           direction = "right")
