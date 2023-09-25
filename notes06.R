# Notes 6 Code

# Read in our data

fastfood <- read.csv("https://raw.githubusercontent.com/vank-stats/STS2300-Fall2023/main/FastFoodAccuracy.csv")

# Create scatterplot of our data

library(ggplot2)
ggplot(fastfood, aes(x = SecPerOrder, y = PctWithErrors)) +
  geom_point() +
  labs(x = "Average Seconds Per Drive-Thru Order",
       y = "Percentage of Orders with Errors",
       title = "Fast Food Drive Thru Accuracy") +
#  scale_x_continuous(breaks = dalkjdag) +
  theme_classic()


# Generate intercept and slope for our simple linear regression line

lm(PctWithErrors ~ SecPerOrder, data = fastfood)


# Demonstration of using piping for SLR

library(dplyr) # to load %>%

# Produces an error because we don't want to pipe fastfood into the first
# argument of the lm() function

fastfood %>%
  lm(PctWithErrors ~ SecPerOrder)

# We can use a . to pipe into somewhere other than the first argument
# When we do this, we don't get an error

fastfood %>%
  lm(PctWithErrors ~ SecPerOrder, data = .)


# Predicting error percentage for average drive-thru time of 500 seconds

17.7152 - 0.0306 * 500

# And for 300 seconds

17.7152 - 0.0306 * 300


# Checking the range of x values

summary(fastfood$SecPerOrder)


# Using R to make predictions

# Without piping

fastfood.lm <- lm(PctWithErrors ~ SecPerOrder, data = fastfood)
predict(fastfood.lm, newdata = data.frame(SecPerOrder = 500))

# With piping

fastfood %>%
  lm(PctWithErrors ~ SecPerOrder, data = .) %>%
  predict(newdata = data.frame(SecPerOrder = 500))



# Exampls of prediction for 100, 150, 200, 250, ..., 600

predict(fastfood.lm, newdata = data.frame(SecPerOrder = seq(from = 100,
                                                            to = 600,
                                                            by = 50)))

# Predicted y value for each of the x values in our data

fastfood.lm$fitted.values


# Use summary to get more information from lm() output (like R^2, etc.)
summary(fastfood.lm)


# Graphical version of R^2

ggplot(fastfood, aes(x = SecPerOrder, y = PctWithErrors)) +
  geom_point() +
  labs(x = "Average Seconds Per Drive-Thru Order",
       y = "Percentage of Orders with Errors",
       title = "Fast Food Drive Thru Accuracy") +
  theme_classic() +
  geom_hline(data = NULL, yintercept = mean(fastfood$PctWithErrors)) +
  geom_smooth(method = "lm", se = FALSE)
