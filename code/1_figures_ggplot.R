# Lesson 7: Figures and tables
# Created by: Caitlin Allen Akselrud
# Contact: caitlin.allen_akselrud@noaa.gov
# Created: 2020-01-04
# Modified: 2021-01-18

# Notes: the '# ~' is used to indicate the difference between data specification at different levels

# packages ----------------------------------------------------------------

library(tidyverse)

library(tidytuesdayR)

library(gt)

library(here)

# data --------------------------------------------------------------------

mpg # this is a built-in data set to R 

# intro to ggplot2 --------------------------------------------------------

# * grammar of ggplot -----------------------------------------------------
# note: code modified from: https://uc-r.github.io/ggplot_intro


# * * basic plot ----------------------------------------------------------

ggplot()      # create an empty plot

ggplot(data = mpg)   # empty plot, with data set specified

ggplot(data = mpg, aes(x = displ, y = hwy)) # aesthetics: empty plot with axes specified

ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point() # add the data as points


# * * adding data: 3 ways of doing the same thing -------------------------

# ADDING DATA METHOD 1:
# # you are adding one data specification to the entire graph
ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point()

# ADDING DATA METHOD 2:
# # you are adding specific data as points
ggplot() +
  geom_point(data = mpg, aes(x = displ, y = hwy))

# ADDING DATA METHOD 3:
# # you are adding one data set, with specific data as points
ggplot(data = mpg) +
  geom_point(aes(x = displ, y = hwy))

# ~ What's the point of all this?
# # a) flexibility
# # b) depends on what/how you want to plot (we'll come back to that)

# * * adding aesthetics ---------------------------------------------------

# add to your aesthetics: color the data by car class
# # change color INSIDE aes() to group by variable
ggplot(data = mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point()

# change color OUTSIDE aes() to manually designate the color of points
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(color = "blue")


# * * geometry ------------------------------------------------------------

# some types of geometry only require an x input, e.g.
# bar chart
ggplot(data = mpg, aes(x = class)) +
  geom_bar() 

# histogram
ggplot(data = mpg, aes(x = hwy)) +
  geom_histogram()

ggplot(data = mpg, aes(x = displ)) +
  geom_histogram()

# note that bar plots and histograms produce a 'count' y-axis
# # this is an automatic statistical transformation built into these plotting functions
# # it is equivalent to tidyverse dplyr::count()
# # it is not part of the *original* data set

# some require x and y inputs, e.g.
# plot points (like before)
ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point()

# plot your data as a line
ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_line()

# plot a smoothed version of your data (default method = 'loess')
ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_smooth()

# now you can stack your geometry in... LAYERS!
ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

# ooohhhh....

# * * layers of geometry and aesthetics -----------------------------------

# let's mix and match some of our specifications:
# make the points blue, and the smoothed line red

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(color = "blue") +
  geom_smooth(color = "red")


# ~ The difference between specifying at the ggplot level vs the geom level:
# the color aesthetic is passed to every geom layer
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  geom_smooth(se = FALSE) # se = FALSE turns off the confidence interval

# color aesthetic specified for only the geom_point layer
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE)


# * * statistical geometry ------------------------------------------------

# you can use the 'stat_' family of functions to add statistical geometry
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(color = "grey") + 
  stat_summary(fun = "mean", geom = "line") 
  

# * * position adjustments ------------------------------------------------

# bar chart of class, colored by drive (front, rear, 4-wheel)
ggplot(mpg, aes(x = class, fill = drv)) + 
  geom_bar()

# use the position argument to specify what position adjustment rules to follow
# position = "dodge": values next to each other
ggplot(mpg, aes(x = class, fill = drv)) + 
  geom_bar(position = "dodge")

# position = "fill": percentage chart
ggplot(mpg, aes(x = class, fill = drv)) + 
  geom_bar(position = "fill")

# * * scale  --------------------------------------------------------------

# color the data by engine type
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point()

# same as above, with explicit scales
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  scale_x_continuous() +
  scale_y_continuous() +
  scale_colour_discrete()

# sometimes you will run into plotting issues or errors, and will need to change the scale
# # a continuous scale will handle things like numeric data (where there is a continuous set of numbers), 
# # a discrete scale will handle things like colors (since there is a small list of distinct colors).

# reverse x and/or y axis from max -> min
ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point() +
  scale_x_reverse() +
  scale_y_reverse()

# there are lots of things you can do with scale_x and scale_y arguments
# type 'scale_x' or 'scale_y' to see the options that pop up

# * * coordinates ---------------------------------------------------------
# we're talking about x and y axes coordinates, not lat/long

# set x or y limits with coord_cartesian
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  coord_cartesian(xlim = c(0, 5), ylim = c(20,40))

# flip x and y axis with coord_flip
ggplot(mpg, aes(x = class)) +
  geom_bar() +
  coord_flip()

# you can set a fixed aspect ratio (such as widescreen) with coord_fixed
# you can plot polar coordinated (point and angle) with coord_polar
# and others- check out 'coord_' to see options

# * * facets aka subplots -------------------------------------------------

# facet by one variable
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_grid(~ class) #create subplots by car class

# facet by 2 variables:
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_grid(year ~ cyl)

# * * labels and annotations ----------------------------------------------

# labels are 'labs'
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  labs(title = "Fuel Efficiency by Engine Power",
       subtitle = "Fuel economy data from 1999 and 2008 for 38 popular models of cars",
       x = "Engine power (litres displacement)",
       y = "Fuel Efficiency (miles per gallon)",
       color = "Car Type")

# you can also plot labels for specific points
# # check out 'geom_text' or 'geom_label'
# # if your labels overlap, load the 'ggrepel' package and use 'geom_text_repel' function 

# * * colors --------------------------------------------------------------

# color cheatsheet: https://www.nceas.ucsb.edu/sites/default/files/2020-04/colorPaletteCheatsheet.pdf

# standard colors
# named colors: http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(color = "blue3") +
  geom_smooth(color = "cornflowerblue")

# hex colors: standard number and letter combos to indicate specific colors
# # many websites; I like this one: https://www.color-hex.com/
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(color = "#483d8b") + # purple color
  geom_smooth(color = "#3d8b48")  # green color


# color packages:
# # color brewer: https://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3
# ....
# default color brewer
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  scale_color_brewer()

# specifying color palette
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  scale_color_brewer(palette = "Set3")

# there are many other pre-made palettes available online

# * * themes --------------------------------------------------------------

# you can change the base look of your plot using themes
# # you can use pre-loaded themes: https://ggplot2.tidyverse.org/reference/ggtheme.html
# # or you can make your own: https://rpubs.com/mclaire19/ggplot2-custom-themes

# check out the differen themes
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  scale_color_brewer(palette = "Set3") +
  theme_classic()

ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  scale_color_brewer(palette = "Set3") +
  theme_bw()

ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  scale_color_brewer(palette = "Set3") +
  theme_dark()

# type 'theme_' to see all the pre-loaded theme options

# * * save plots ----------------------------------------------------------

# you can assign your plot to a variable name
# # this allows you to build on, manipulate later, and save your plot

p_disp_mpg <- 
  ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  scale_color_brewer(palette = "Set3")

p_disp_mpg

# how to save your plot to a file
ggsave(p_disp_mpg, filename = "plot_displ_mpg.png", path = here("output"))

# * tables (briefly) ------------------------------------------------------

# 'gt' package for tables
# # we're back to using the pipe %>% 

# base table
mpg %>% 
  gt() 

# add a title
mpg %>% 
  gt() %>% 
  tab_header(title = "Car Data",
             subtitle = "Lots of info on cars")

# summarize some columns, then make a table
mpg %>% 
  group_by(year, manufacturer) %>% 
  summarise(mpg_cty = mean(cty), mpg_hwy = mean(hwy), min_cyl = min(cyl), max_cyl = max(cyl)) %>% 
  gt() %>% 
  tab_header(title = "Car Data",
             subtitle = "Lots of info on cars")

# clean up the summarized table names and numbers
mpg %>% 
  group_by(year, manufacturer) %>% 
  summarise(mpg_cty = round(mean(cty), digits = 1), mpg_hwy = round(mean(hwy), digits = 1), min_cyl = min(cyl), max_cyl = max(cyl)) %>% 
  gt() %>% 
  tab_header(title = "Car Data",
             subtitle = "Summary info on cars") %>% 
  tab_spanner(label = "MPG",
              columns = vars(mpg_cty, mpg_hwy)) %>% 
  tab_spanner(label = "Number Cylinders",
              columns = vars(min_cyl, max_cyl)) %>% 
  cols_label(manufacturer = "Manufacturer",
             mpg_cty = "City",
             mpg_hwy = "Highway",
             min_cyl = "Min",
             max_cyl = "Max")
  
# there are many additional settings you can fiddle with to adjust the table to your preference
