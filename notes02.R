# Notes 02 Code

# Practice - using str() to see how variables are stored

str(mtcars)
?mtcars

# We see categorical variables like vs and am are treated as quantitative

summary(mtcars)



# Practice - Quantitative summary of mtcars

mean(mtcars$mpg)
min(mtcars$hp)
quantile(mtcars$wt, probs = 0.8)
sd(mtcars$disp)



# The summarize() function is in the dplyr package

library(dplyr)

# We can create our own summaries as data frames with summarize()

car_summary <- summarize(mtcars,
          min_mpg = min(mpg),
          max_mpg = max(mpg),
          avg_hp = mean(hp),
          sd_hp = sd(hp))

# It can also be done without named columns

summarize(mtcars, min(mpg), max(mpg), mean(hp), sd(hp))



# Exploring a categorical data set in the moderndive package

library(moderndive)
str(MA_schools)


# Table of school sizes - counts with table() and proportions with prop.table()

table(MA_schools$size)
prop.table(table(MA_schools$size))

# If we create an object, we see the results are not stored as a data frame

size_table <- table(MA_schools$size)



# Summarizing data by groups

# This can be used for categorical data to get a data frame as an object

summarize(MA_schools,
          count = n(),
          .by = size)

# We can also do this for quantitative data (like the class statement in SAS)

# Code for Practice prompt

car_summary_by_am <- summarize(mtcars,
                         min_mpg = min(mpg),
                         max_mpg = max(mpg),
                         avg_hp = mean(hp),
                         sd_hp = sd(hp),
                         .by = am)
car_summary_by_am


# Example in notes with two grouping variables

summarize(mtcars,
          count = n(),
          .by = c(am, cyl))


# Code for Practice prompt

summarize(mtcars,
          min_mpg = min(mpg),
          max_mpg = max(mpg),
          avg_hp = mean(hp),
          sd_hp = sd(hp),
          .by = c(am, cyl))
