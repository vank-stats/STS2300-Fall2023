# Notes 08 Code

# Packages we will use

library(ggplot2)
library(dplyr)
library(moderndive)
library(patchwork)


# Reading in data for our example

house_of_reps <- read.csv("https://raw.githubusercontent.com/vank-stats/STS2300-Fall2023/main/house_of_reps.csv")


# Graphing our population

pop_dist <- ggplot(house_of_reps) +
  geom_bar(aes(x = party, fill = party), 
           show.legend = FALSE) +
  theme_classic() +
  scale_fill_manual(values = c("blue", "red", "black")) 

pop_dist + labs(title = "House of Representatives Seats (Our Population)",
                subtitle = "As of September 2023")


# Taking a sample of 30 seats

mysamp <- rep_sample_n(house_of_reps, size = 30)


# Summarizing the sample with a table and a graph

table(mysamp$party)

sample_dist <- ggplot(mysamp) +
  geom_bar(aes(x = party, fill = party), 
           show.legend = FALSE) +
  theme_classic() +
  scale_fill_manual(values = c("blue", "red", "black"))

sample_dist + labs(title = "Sample of 30 House of Representatives Seats",
                   subtitle = "As of September 2023")


# Taking 1,000 samples of 30 seats

my1000samps_n30 <- house_of_reps %>%
  rep_sample_n(size = 30,
               reps = 1000)


# Calculating a sample proportion for each of the 1,000 samples

my1000phats_n30 <- my1000samps_n30 %>%
  summarize(prop_dem = mean(party == "Democratic"))


# Graphing our sample proportions (aka sampling distribution)

sampling_dist <- ggplot(my1000phats_n30) +
  geom_histogram(aes(x = prop_dem),
                 binwidth = 1/30,
                 color = "white") +
  theme_classic() +
  scale_fill_manual(values = c("blue", "red", "black"))

sampling_dist + 
  labs(title = "Sampling Distribution for Proportion of Dems in 30 HoR Seats",
       subtitle = "Estimated from 1,000 random samples",
       caption = "Blue line is the population proportion of Democratic seats") +
  geom_vline(xintercept = 212 / 435,
             color = "blue")


# Calculating the standard error of my estimates

sd(my1000phats_n30$prop_dem)


# Taking 1,000 random samples of size 50 and size 100
# Then calculating sample proportions for each sample

phat_50 <- house_of_reps %>%
  rep_sample_n(size = 50,
               reps = 1000) %>%
  summarize(prop_dem = mean(party == "Democratic"))

phat_100 <- house_of_reps %>%
  rep_sample_n(size = 100,
               reps = 1000) %>%
  summarize(prop_dem = mean(party == "Democratic"))


# Graphing our three sampling distributions (n = 30, n = 50, n = 100)

sampling_dist50 <- ggplot(phat_50) +
  geom_histogram(aes(x = prop_dem),
                 binwidth = 1/30,
                 color = "white") +
  theme_classic() +
  scale_fill_manual(values = c("blue", "red", "black")) +
  geom_vline(xintercept = 212 / 435,
             color = "blue") +
  xlim(c(.2, .8))

sampling_dist100 <- ggplot(phat_100) +
  geom_histogram(aes(x = prop_dem),
                 binwidth = 1/30,
                 color = "white") +
  theme_classic() +
  scale_fill_manual(values = c("blue", "red", "black")) +
  labs(caption = "Blue line is the population proportion of Democratic seats") +
  geom_vline(xintercept = 212 / 435,
             color = "blue") +
  xlim(c(.2, .8))

(sampling_dist + 
    xlim(c(.2, .8)) +
    labs(title = "Sampling Distribution (n = 30)") +
    geom_vline(xintercept = 212 / 435, color = "blue")) / 
  (sampling_dist50 +
     labs(title = "Sampling Distribution (n = 50")) / 
  (sampling_dist100 +
     labs(title = "Sampling Distribution (n = 100)",
          caption = "Blue line is population proportion"))


# Standard error estimates for each sample size

sd(my1000phats_n30$prop_dem)
sd(phat_50$prop_dem)
sd(phat_100$prop_dem)


# Taking a bootstrap resample from my original sample

myboot <- mysamp %>%
  rep_sample_n(size = 30,
               reps = 1000,
               replace = TRUE) %>%
  summarize(prop_dem = mean(party == "Democratic"))


# Graphing our bootstrap distribution

boot_dist <- ggplot(myboot) +
  geom_histogram(aes(x = prop_dem),
                 binwidth = 1/30,
                 color = "white") +
  theme_classic() +
  scale_fill_manual(values = c("blue", "red", "black")) +
  geom_vline(xintercept = 212 / 435,
             color = "blue") +
  geom_vline(xintercept = 13 / 30,
             color = "orange")

boot_dist +
  labs(title = "Bootstrap Distribution for Proportion of Dems in 30 HoR Seats",
       subtitle = "Estimated from 1,000 bootstrap re-samples",
       caption = "Blue line is the pop. proportion, Orange line is samp. prop.")


# Putting all four graphs together

((pop_dist +
    labs(title = "Distribution of Population")) + 
    (sampling_dist +
       labs(title = "Sampling Distribution") +
       geom_vline(xintercept = 212 / 435, color = "blue"))) / 
  ((sample_dist +
      labs(title = "Distribution of Sample")) + 
     (boot_dist +
        labs(title = "Bootstrap Resampling Distribution")))