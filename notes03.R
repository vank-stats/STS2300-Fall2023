# Notes 03 Code

# Put NC_Bridges.csv in same folder as this R script.
# Session -> Set Working Directory -> To Source File Location

library(readr)
bridges <- read_csv("NC Bridges.csv", 
                    col_types = cols(DIVISION = col_character()), 
                    na = "Not Posted")

# Once I'm convinced the data was read in correctly, I will remove (or comment
# out) the View() function because I don't want something that creates a pop-up
# window in my R script.


# What is the pipe operator?

library(dplyr) # filter, mutate, summarize, and %>% are part of this package

# Subset the mtcars dataset to only include cars with automatic transmission
auto <- filter(mtcars, am == 0)

# Create variable for car weight in pounds (instead of 1000s of pounds)
auto <- mutate(auto, wt_lbs = 1000 * wt)

# Then calculate the mean weight for each number of cylinders
mean_wt_by_cyl <- summarize(auto, mean_wt = mean(wt_lbs), .by = cyl)

# Then arrange in ascending order by number of cylinders
mean_wt_by_cyl <- arrange(mean_wt_by_cyl, cyl)

# Look at our new dataset with averages by cylinder for automatic transmission cars
mean_wt_by_cyl


# Same example as above, but using the pipe operator (read as "and then")

mean_wt_by_cyl <- mtcars %>%
  filter(am == 0) %>%
  mutate(wt_lbs = 1000 * wt) %>%
  summarize(mean_wt = mean(wt_lbs), .by = cyl) %>%
  arrange(cyl)
mean_wt_by_cyl




# Practice with filter()

# Create alam_bridges which only includes bridges in Alamance County

alam_bridges <- filter(bridges, COUNTY == "ALAMANCE")


# Create subset that includes all bridges that are both structurally deficient
# and functionally obsolete - These three methods all give us the same result

bad_bridges <- filter(bridges, 
                  STRUCTURALLYDEFICIENT == "SD" & FUNCTIONALLYOBSOLETE == "FO")
bad_bridges <- filter(bridges, 
                      STRUCTURALLYDEFICIENT == "SD",
                      FUNCTIONALLYOBSOLETE == "FO")
bad_bridges <- bridges %>%
  filter(STRUCTURALLYDEFICIENT == "SD") %>%
  filter(FUNCTIONALLYOBSOLETE == "FO")

# This could be used to check that we got the right number of bridges
table(bridges$STRUCTURALLYDEFICIENT, bridges$FUNCTIONALLYOBSOLETE)


# Create a subset of Alamance county bridges that are either structurally
# deficient OR functionally obsolete (or both)

alam_watchout <- bridges %>%
  filter(COUNTY == "ALAMANCE",
         STRUCTURALLYDEFICIENT == "SD" | FUNCTIONALLYOBSOLETE == "FO")

alam_watchout <- filter(alam_bridges, 
                  STRUCTURALLYDEFICIENT == "SD" | FUNCTIONALLYOBSOLETE == "FO")

table(alam_watchout$COUNTY)
table(alam_watchout$STRUCTURALLYDEFICIENT, alam_watchout$FUNCTIONALLYOBSOLETE)



# Practice with select()

alam_bridges <- select(alam_bridges, ROUTE, ACROSS, YEARBUILT, SR)





# Practice with mutate()

mycars <- mutate(mtcars, wt_lbs = wt * 1000)

mycars %>%
  select(wt, wt_lbs) %>%
  head(n = 5)

# Create AGE variable (2023 - YEARBUILT). Print just AGE/YEARBUILT for last 10.

bridges <- mutate(bridges, AGE = 2023 - YEARBUILT)

# Option 1

bridges %>%
  select(AGE, YEARBUILT) %>%
  tail(n = 10)

# Option 2

select(bridges, AGE, YEARBUILT) %>%
  tail(n = 10)




# Long vs. Wide Data

birds_wide <- read.csv("https://raw.githubusercontent.com/vank-stats/STS2300-Fall2023/main/nestbox_lands_wide.csv")
birds_long <- read.csv("https://raw.githubusercontent.com/vank-stats/STS2300-Fall2023/main/nestbox_lands_long.csv")



library(tidyr) # pivot_longer() and pivot_wider() are in this package
library(dplyr)
library(stringr) 

# Option 1 with %>%

birds_wide %>%
  pivot_longer(cols = X2012:X2023, 
               names_to = "Year", 
               values_to = "Fledged") %>%
  mutate(Year = str_remove(Year, "X"),
         Year = as.numeric(Year))

# Option 2 without %>%

pivot_longer(birds_wide, 
             cols = -Species, 
             names_to = "Year", 
             values_to = "Fledged") 



birds_long %>%
  pivot_wider(names_from = Year, values_from = Fledged)

