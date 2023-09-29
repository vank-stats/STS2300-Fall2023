# Notes 07 Code

# Packages used

library(ggplot2)
library(dplyr)
library(patchwork)
library(Lock5Data)

# Data for our example

cars <- Cars2015 %>%
  select(HwyMPG, Length, Height, Acc060, Weight)


# Create graphs comparing explanatory variables each
# to the response variable

g <- ggplot(cars, aes(y = HwyMPG))

g1 <- g + geom_point(aes(x = Length)) + theme_classic()
g2 <- g + geom_point(aes(x = Height)) + theme_classic()
g3 <- g + geom_point(aes(x = Acc060)) + theme_classic()
g4 <- g + geom_point(aes(x = Weight)) + theme_classic()

(g1 + g2) / (g3 + g4) 

# Each of the graphs above is at least close to linear with varying strengths
# The graph below shows more of a curved pattern, so we would NOT want to
# use HighPrice as an explanatory variable in a linear regression

ggplot(Cars2015, aes(x = HighPrice, y = HwyMPG)) + 
  geom_point()


# Generate multiple linear regression equation

lm(HwyMPG ~ Length + Height + Acc060 + Weight, data = cars)


# Making a prediction for a specific car (without piping)

cars.lm <- lm(HwyMPG ~ Length + Height + Acc060 + Weight, data = cars)
predict(cars.lm, newdata = data.frame(Length = 192, 
                                      Height = 72, 
                                      Acc060 = 7.7,
                                      Weight = 4505))


# Making the same prediction (with piping)

cars %>%
  lm(HwyMPG ~ Length + Height + Acc060 + Weight, data = .) %>%
  predict(newdata = data.frame(Length = 192, 
                               Height = 72, 
                               Acc060 = 7.7,
                               Weight = 4505))


# We could also make predictions for a new data set of cars
# (as long as it has the same variable names)

cars %>%
  lm(HwyMPG ~ Length + Height + Acc060 + Weight, data = .) %>%
  predict(newdata = Cars2020)


# Graph to see how closely our predicted responses match actual responses

cars$predictedHwyMPG <- predict(cars.lm)
ggplot(cars) +
  geom_point(aes(x = HwyMPG, 
                 y = predictedHwyMPG)) +
  geom_abline(slope = 1) +
  labs(title = "Actual vs. Predicted MPG", 
       x = "Actual Highway MPG", 
       y = "Predicted Highway MPG")



# Backward elimination

# Original "full model"

Cars2015 %>%
  lm(HwyMPG ~ Length + Width + Height + Weight + Acc030 + Acc060, data = .) %>%
  summary()

# In this model, Acc030 had a p-value over 0.50. This suggests that our data
# looks a lot like what you'd see if the true value for the slope was 0.
# We are going to remove Acc030 from our model and re-check it.

Cars2015 %>%
  lm(HwyMPG ~ Length + Width + Height + Weight + Acc060, data = .) %>%
  summary()


# Now the biggest p-value belongs to width (around 0.3). This is also above
# any significance cutoff we would use, which suggests we aren't convinced
# width is helping our predictions, so we will remove it, and re-check our
# model again.

Cars2015 %>%
  lm(HwyMPG ~ Length + Height + Weight + Acc060, data = .) %>%
  summary()

# At this point we have one slope with a p-value above 0.05 (but below 0.1).
# We could either remove it if our plan was to remove slopes until all of them
# had p-values below 0.05. Or we could check if removing it improved or hurt
# our adjusted R-squared value.

Cars2015 %>%
  lm(HwyMPG ~ Length + Weight + Acc060, data = .) %>%
  summary()
