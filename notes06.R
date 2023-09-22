# Notes 6 Code

fastfood <- read.csv("https://raw.githubusercontent.com/vank-stats/STS2300-Fall2023/main/FastFoodAccuracy.csv")

library(ggplot2)
ggplot(fastfood, aes(x = SecPerOrder, y = PctWithErrors)) +
  geom_point() +
  labs(x = "Average Seconds Per Drive-Thru Order",
       y = "Percentage of Orders with Errors",
       title = "Fast Food Drive Thru Accuracy") +
  theme_classic()


lm(PctWithErrors ~ SecPerOrder, data = fastfood)

library(dplyr)

fastfood %>%
  lm(PctWithErrors ~ SecPerOrder)

fastfood %>%
  lm(PctWithErrors ~ SecPerOrder, data = .)


# Predicting error percentage for average drive-thru time of 500 seconds

17.7152 - 0.0306 * 500

# And for 300 seconds

17.7152 - 0.0306 * 300



fastfood.lm <- lm(PctWithErrors ~ SecPerOrder, data = fastfood)
predict(fastfood.lm, newdata = data.frame(SecPerOrder = 500))


fastfood %>%
  lm(PctWithErrors ~ SecPerOrder, data = .) %>%
  predict(newdata = data.frame(SecPerOrder = 500))



# Predict for 100, 150, 200, 250, ..., 600
predict(fastfood.lm, newdata = data.frame(SecPerOrder = seq(from = 100,
                                                            to = 600,
                                                            by = 50)))

# Predcicted y value for each of the x values in our data
fastfood.lm$fitted.values
