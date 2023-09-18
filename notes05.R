# Notes 05 Code

library(ggplot2)
library(palmerpenguins)

graphA <- ggplot(penguins, aes(x = bill_length_mm, y = body_mass_g,
                               color = species, shape = island)) +
  geom_point(size = 3, alpha = 0.5) +
  labs(title = "Comparing penguin bill lengths to body mass",
       subtitle = "Across species and island",
       caption = "Created for STS 2300 Notes 05",
       x = "Bill Length (in mm)",
       y = "Body Mass (in grams)",
       shape = "Islands",
       color = "Penguin \nSpecies")

graphA



# Manually changing the shape scale

graphA +
  scale_shape_manual(values = c(8, 18, 25))

# Manually choosing colors

graphA +
  scale_color_manual(values = c("green", "blue", "pink"))




majors <- read.csv("https://raw.githubusercontent.com/vank-stats/STS2300-Fall2023/main/data_hw2_q3.csv")

ggplot(majors, aes(y = Major, x = Count)) +
  geom_boxplot(fill = "gold", color = "maroon", alpha = .5) +
  geom_point() +
  scale_y_discrete(limits = c("Math", "Applied_Math", "Data_Analytics", "Stats"))
