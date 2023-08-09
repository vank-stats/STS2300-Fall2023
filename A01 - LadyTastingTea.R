# Code for Activity 01 - The Lady Tasting Tea


# Create a coin object that contains "heads" and "tails"

coin <- c("heads", "tails")


# "Flip" the coin once

sample(coin, size = 1)


# "Flip" the coin eight times

sample(coin, size = 8, replace = TRUE)




# Bonus code to simulate the process 1000 times

coin_sim <- replicate(1000, sample(coin,
                                   size = 8, 
                                   replace = TRUE))
sim_heads <- apply(coin_sim, 
                   MARGIN = 2, 
                   FUN = function(x) { sum(x == "heads")} )
table(sim_heads)
prop.table(table(sim_heads))
hist(sim_heads, breaks = seq(-0.5, 8.5, 1))
