# Code from Notes 01


### Writing Code in R Section

## Sample Code

mynumbers <- c(4, 8, 15, 16, 23, 42)
mynumbers * 2
max(mynumbers)


# Question 5 solution

mynums <- c(3, 7, 65, 23)
my_max <- max(mynums)
min(mynums)
mean(mynums)
median(mynums)
sd(mynums)


# Question 6 & 7 - Produces an error because R is case sensitive and because
#   object and functions names can't have spaces in them.

Max(mynums)
my numbers <- c(1, 2, 3)


# There was a question about missing values. They are denoted with NA

new_vector <- c("elon university", "high point", NA, "nc a&t")
new_vector



## Data frames

# Either option will open the help files for the mtcars data

?mtcars
help(mtcars)


# We can use these for functions too

?c


# head() shows us the first few rows. The n argument specifies how many.

head(mtcars, n = 5)
head(mtcars, n = 1)


# We can use tail() to see the last few rows

tail(mtcars, n = 10)


# View() (capital V) opens a pop-up window of the full data set.
# summary() gives us min, max, mean, median, Q1, Q3 for each variable

View(mtcars)
summary(mtcars)



# For functions in new packages, we need to install them (once, in console)
#   and then load them (once per R session, in script)
# Download dplyr if necessary using install.packages("dplyr") in console
# The library() function loads the package for us to use

library(dplyr)
glimpse(mtcars)


# We can also download the skimr package and use the skim() function

library(skimr)
skim(mtcars)


## The $ operator

# Practice quetsion solutions

mtcars$wt
min(mtcars$mpg)
?Loblolly
max(Loblolly$age)
min(Loblolly$height)