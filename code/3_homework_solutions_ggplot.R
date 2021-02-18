# Lesson 7: Figures and tables homework solutions: example plots
# Created by: Caitlin Allen Akselrud
# Contact: caitlin.allen_akselrud@noaa.gov
# Created: 2020-01-08
# Modified: 2021-01-18

# Notes: the '# ~' is used to indicate the difference between data specification at different levels


# workflow ----------------------------------------------------------------

dirs = c("code", "data", "documentation", "figures", "functions", "output")

for(i in 1:length(dirs)){
  if(dir.exists(dirs[i])==FALSE){
    dir.create(dirs[i])
  }
}

# packages ----------------------------------------------------------------

library(tidyverse)

library(tidytuesdayR)

library(gt)

library(here)

# data --------------------------------------------------------------------

penguins <- tidytuesdayR::tt_load('2020-07-28')
peng_dat <- penguins$penguins
peng_dat


# homework ----------------------------------------------------------------

# make a plot of peng_dat to share with the class

# here are some example plots:

ggplot(data = peng_dat) +
  geom_point(aes(x = bill_length_mm, y = bill_depth_mm, color = body_mass_g))

  
ggplot(data = peng_dat) +
  geom_point(aes(x = bill_length_mm, y = bill_depth_mm, color = sex))

ggplot(data = peng_dat) +
  geom_histogram(aes(x = body_mass_g, color = island))

ggplot(data = peng_dat) +
  geom_histogram(aes(x = body_mass_g, fill = island))

ggplot(data = peng_dat) +
  geom_bar(aes(x = species, fill = sex), position = "fill") +
  coord_flip() +
  facet_grid(~ island)

# here's the one I want to save...
peng_plot <- ggplot(data = peng_dat) +
  geom_bar(aes(x = island, fill = sex), position = "fill") +
  coord_flip() +
  facet_grid(~ species) +
  labs(title = "Sex ratio of penguins by species and location",
       x = "Number of penguins",
       y = "Location",
       fill = "Sex")

peng_plot

ggsave(peng_plot, filename = "plot_penguin_sexratio.png", path = here("output"))
