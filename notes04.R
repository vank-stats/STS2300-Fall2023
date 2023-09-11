# Notes 4 Code

library(ggplot2)


# Practice Questions

# Run initial code

ggplot(data = mtcars) +
  geom_point(aes(x = wt, y = mpg))


# Create scatterplot of hp (x) by mpg (y)

ggplot(data = mtcars) +
  geom_point(aes(x = hp, y = mpg))


# Create bar graph of am

ggplot(data = mtcars) +
  geom_bar(aes(x = am))

# To make the x-axis categorical instead of numeric, use as.factor()

ggplot(data = mtcars) +
  geom_bar(aes(x = as.factor(am)))



# Scatterplot Practice

ggplot(data = mtcars) +
  geom_point(aes(x = wt, 
                 y = mpg), 
             color = "purple",
             alpha = 0.3,
             size = 3,
             shape = 17)



# Creating a histogram
# We get a message telling us to specify bins / binwidth

ggplot(data = mtcars) +
  geom_histogram(aes(x = mpg))

# We specified that we wanted 10 bins
ggplot(data = mtcars) +
  geom_histogram(aes(x = mpg), bins = 10)

# Or we specified that we wanted each bin to be 5 mpg wide
ggplot(data = mtcars) +
  geom_histogram(aes(x = mpg), binwidth = 5)


# Practice histogram

ggplot(data = airquality) +
  geom_histogram(aes(x = Temp),
                 fill = "orange",
                 color = "white",
                 binwidth = 5,
                 boundary = 55)
