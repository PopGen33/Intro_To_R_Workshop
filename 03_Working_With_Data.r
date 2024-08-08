# In this module, we'll learn to install and load packages, load data into an 
# R environment, and do a very basic analysis of that data. Then, at the end of this 
# script, there are comments to guide you in performing another analysis of a 
# similar data set.

# The package we'll be using for this analysis is 'wiqid'. This package was developed 
# by Mike Meredith specifically for quick and dirty analysis from simulations. It has 
# since evolved into a package suitable for teaching. A short description of the 
# package can be found here: https://mmeredith.net/R/wiqid/index.html
# While this package is suitable for teaching, there are many other packages you can 
# and should consider when doing your own analyses. Check the literature relevant to 
# your field and/or talk to experts to decide which statistical approaches are best 
# for your data and which R packages can aid in those analyses.

#######################################
##  Installing and Loading Packages  ##
#######################################
# Packages can functions and data that we can use for our analyses. These are usually
# imported at the top of a script using the library() command (after the package is 
# installed, see below).

# Installing packages using a command is quite easy. If you know the name of the
# package you want to install, you just run install.packages("packageName"). This
# only needs to run when you first install the package and when you want to update 
# The package.

install.packages("wiqid")

# To load a package, we use the library function. Note that while install.packages()
# takes a string as its argument (in quotes), library() takes the package name 
# as an argument (no quotes) under library()'s default settings. While packages 
# only need to be installed once, they need to be loaded every R session before 
# we can use them.

library(wiqid)

# Note that it is also possible to install and load packages from the "Packages" tab
# in the lower-right region of the RStudio interface.

# You can also check for citation information from a package by calling citation()
# on it (and get R's citation info by passing to arguments to it).

citation("wiqid")
citation()

######################################
##  Checking the Working Directory  ##
######################################
# To easily access the data we want to load, it helps to be in the correct directory.
# To check the directory we're currently in, we use the getwd() command:

getwd()

# If you opened this script by double-clicking, you should find that getwd() returns
# the file path to the directory that the script is in. IF you get any location other 
# than that, you need to change you're working directory. You can use the command
# setwd() to set your working directory, but it's also possible to do this in RStudio 
# through the GUI. In the menu bar at the top of the window, go to 
# Session -> Set Working Directory -> To Source File Location
# This will set the working directory to the one containing this script. You should 
# see the command run in your console.

####################
##  Loading Data  ##
####################
# Most often, you'll be loading data from a file in the form of a table. Here, 
# I've exported one of the test data sets that from the wiqid package ("dippers.txt").
# This is a tab-delimited file, so we need to tell R that the separator is '\t'. You
# can learn more about the read.table() function by calling 
# help("read.table"). The help() function is extremely, well, helpful, and will pull 
# of the documentation for any function name that you pass to it. This is also a 
# good way of checking the default settings of all the arguments passed to a function.

help("read.table")
?read.table # same as help("read.table")
??read.t # searches for help pages that match the string read.t* ; useful when you don't know full function name
help("read.table")

dippersData <- read.table("dippers.txt", sep = "\t")

# Note that dippersData now contains a data frame of the data imported from the file.

# The "dippers" data set is distributed with the program MARK, a program for estimating
# various population parameters from mark-recapture data. Notably, there is an R interface 
# for MARK in the form of the RMARK package, but we won't be using that to keep things a bit 
# simpler (and avoid having to install MARK). The "dipper" in question is the Eurasian or 
# White-throated Dipper: https://ebird.org/species/whtdip1 . This species is tightly associated
# with swift flowing streams and rivers in which it fully submerges itself while hunting aquatic 
# insect larvae and other small invertebrates. We'll explore the contents of this data in the 
# next section.

####################
##  Viewing Data  ##
####################
# First, let's find the size of our data frame using the dim() function:

dim(dippersData) # 294 rows, 8 columns
 
# The head() function shows the first few row of the data frame so we can see what the data look like:

head(dippersData) # Top Rows
tail(dippersData) # Bottom Rows
colnames(dippersData) # Column Names

# Here we see the data consist of 8 columns: Y1, Y2, Y3, Y4, Y5, Y6, Y7, sex
# Y1 - Y7 represent detection histories over a 7 year period (1 = detected; 2 = absent) 
# and sex is the sex of the individual (M = male; F = female). So, since each row is 
# an individual, we have detection histories for 294 dippers.

# str() is used to get a description of the structure of an R object, including 
# data frames. It gives us all the information we got from the functions above.
str(dippersData)

# For this particular data, the summary() function isn't particularly informative, but it 
# can be very useful depending on the data you're working with (e.g. you might have recorded 
# weights of individuals). We'll run it here to demonstrate it anyway:

summary(dippersData)

######################################
##  Analyzing Data (and data prep)  ##
######################################
# In the wiqid package, there is a function called survCJS(). This function is an 
# implementation of the Cormack-Jolly-Seber model that let's us estimate apparent 
# survival from binary mark-recapture data. We won't worry about the statistics 
# behind this model, but a good description can be found here: 
# https://www.montana.edu/rotella/documents/502/CJS.pdf

# First, let's call the help function on survCJS() to bring up its documentation:

help("survCJS")

# In particular, the Arguments section of this help page describes the inputs to the 
# function. The first thing you'll notice is that the "DH" argument is the mark-recapture
# data in the form of a *matrix* not a data frame. It also is can't have the column 
# indicating sex. So, we need to get rid of the last column in the data frame and 
# convert it to a matrix.

# The easiest way to subset a data frame is to use column and row indices, so let's 
# experiment with that. Here, I'm calling str() on a few subsets of our dippersData

str(dippersData[1,]) # Just the first row
str(dippersData[1:10,]) # Rows 1 - 10
str(dippersData[,1]) # Just the first column; note that this gets coerced to a vector of integers
str(dippersData[,1:7]) # Just columns 1-7; *This* is what we need!

# Now we just need to convert it to a matrix and store it as a variable so we 
# can use it in the survCJS() function.

dippersData_matrix <- as.matrix(dippersData[,1:7])

# So, now we can run the function:

survCJS(DH = dippersData_matrix) # phi(.) p(.) survival and recapture prob constant through time
survCJS(DH = dippersData_matrix, model = list(phi~.time, p~1)) # phi(t) p(.) survival prob varies through time, recapture prob constant

# In the first model, the phi estimate is the apparent survival which we've assumed 
# is constant through time. In the second model, we've estimated phi the interval 
# between each capture period (a more complex model with more parameters). Without 
# getting into what it is, models with lower AIC are preferred to models with higher 
# AIC, so we'd prefer the simpler model in this case.

# So that's a relatively simple analysis in which we went from reading in data to 
# actually running it. Again, the wiqid package we used here is meant for teaching.
# RMark is a more complete packages meant for analyzing mark-recapture data 
# that would be preferred in a real analysis.

###############################################################
##  A Larger Dataset: More robust data filtering with dplyr  ##
###############################################################
# Now, we'll work with a much larger dataset: The AVONET dataset. Briefly,
# this is a dataset consisting of morphological, ecological, and geographical data for
# all birds. It includes data from ~11k extant birds species (~90k individuals).
# This dataset is described in this paper: 
# https://onlinelibrary.wiley.com/doi/full/10.1111/ele.13898

# The specific portion of the dataset we'll work with is a collection of averages for 
# each species of the different measurements included in the dataset. Let's read it in!
# Note that here we have to give read.delim() an additional argument to let the function 
# know that our data has a header row. We also want the columns containing strings to be 
# treated as *factors*, R's term for categorical variables:

avonetData <- read.delim("AVONET_averages_BirdLifeInternationalTaxonomy.txt", sep = "\t", header = TRUE, stringsAsFactors = TRUE)

# Why read.delim() instead of read.table()? Try read.table() and check how many rows it 
# reads in. I will admit I don't know why the two behave differently in this case.

# Now, examine its structure:

str(avonetData) # Pretty Big!

# This would be a massive pain to filter using the row and column indexes we used earlier.
# Let's install and load the dplyr package to make our lives easier:

install.packages("dplyr") # https://dplyr.tidyverse.org/
library(dplyr) 

# This package provides really powerful ways of filtering data. It's part of tidyverse, 
# a collection of data science packages: https://www.tidyverse.org/
# We're just interested in filtering for now, though.

# This is also an opportune time to point out that some packages come with vignettes
# to show you how to use them. You can access a list of these with browseVignettes()
# Note that this function will open your default browser (e.g. Chrome, Firefox)

browseVignettes("dplyr")

# Let's say we're interested only in cranes (family Gruidae) we can easily filter our 
# data using dplyr's filter() function. First, let's check which families are included 
# included in this dataset by selecting just the "Family1" column and calling unique() 
# and sort() to get a nice list of families in alphabetical order:

sort(unique(avonetData$Family1)) # Gruidae is included. Nice!

avonetData_cranes <- filter(avonetData, Family1 == "Gruidae")
str(avonetData_cranes)

# We can then select only the columns we're interested in using select(). Let's just 
# examine wing length and body mass:

avonetData_cranes_MassWingLength <- select(avonetData_cranes, Species1, Mass, Wing.Length)

# We can summarize our data (useful this time!) to get averages, etc. across all cranes:

summary(avonetData_cranes_MassWingLength)

# We can fit a linear model:
cranes_lm <- lm(Wing.Length ~ Mass, data = avonetData_cranes_MassWingLength)
summary(cranes_lm) # Prints the results of fitting the linear model

# ... and make a simple plot. There are three commands here: plot(), text(), and abline():

plot(x = avonetData_cranes_MassWingLength$Mass, 
     y = avonetData_cranes_MassWingLength$Wing.Length, 
     main = "Crane Wing Length (mm) vs. Mass (g)", 
     xlab = "Body Mass (g)", 
     ylab = "Wing Length (mm)",
     ylim = c(425,700))
text(x = avonetData_cranes_MassWingLength$Mass, 
     y = avonetData_cranes_MassWingLength$Wing.Length, 
     labels = avonetData_cranes_MassWingLength$Species1,
     pos = 1,
     offset = 0.1,
     cex = 0.5)
abline(cranes_lm)

# You can fiddle with plots forever in R, especially if you're using the ggplot2 package.
# For now, let's practice saving the plot using the "Export" drop-down menu in RStudio.
# Save the file as an image (.png is a good format here).

###########################################
##  Exercise: Using what you've learned  ##
###########################################
# The AVONET dataset is will loaded in the variable 'avonetData', so let's see if you can 
# perform your own analysis given what you've learned. The key to writing to a script is 
# to recognize the logical steps that neet to happen to get yourself from what you have (data) 
# to your goal (results). Below, I've provided a goal and a skeletal outline of what needs to happen 
# to get your there, but you'll be writing the code yourself. This is meant to be challenging and 
# a bit confusing, but keep in mind working through that is part of developing your skills.

# ***Goal: Given the AVONET dataset, the dplyr package (already loaded), and the boxplot() function 
# (which you've never used before!), filter the data to just order Gruiformes (cranes, rails, and other 
# related species) and remove species that are partially migratory (Migration == 2 in the table). Then,
# produce a boxplot for each family within Gruiformes comparing Hand.Wing.Index in sedentary and 
# migratory species. Basically, you think this hand-wing index might be a good predictor of migration 
# status and you want to visualize that for each family.

# Step 1: Filtering. For this, you'll need to use the filter function. You'll be filtering based on 
# two columns: Order1 and Migration. For Order1, you want only "Gruiformes". For Migration, you want 
# species that are not partially migratory (!=2). Filter your data and store it to a new variable



# Step 2: Re-coding the Migration column. The function we'll be using expects this column to be
# encoded as 0 and 1 (currently it's encoded as 1 = Sedentary and 3 = Migratory). We'll re-encode this column 
# so that 0 = Sedentary and 1 = Migratory. This is a step that I'll give you the code for since it uses functions 
# we didn't cover (notably, the pipe operator %>%), but you'll have to fill in the variable name that references 
# your filtered data from step 1.

# This function re-encodes things to 0 and 1
your_var <- your_var  %>% 
  mutate(Migration = case_when(Migration == 3 ~ 1, .default = 0))
# This function makes the 0 and 1 encoding a factor instead of an integer
your_var  <- your_var  %>% 
  mutate(Migration = factor(Migration, levels = c(0,1), labels = c("Sedentary", "Migratory")))


# Step 3: Creating the boxplots. You've never run the boxplot() function before, so you should probably 
# read the documentation to understand what arguments you need to use (how do you do that?). Once you've 
# understood the boxplot function, you can take one of two approaches: (1) Write a separate boxplot() 
# call for each of the families (column Family1), or, (2) write a for loop that loops over each unique 
# family name (column Family 1) and calls boxplot() for each family. HINTS: You will need to use
# the filter() function again; the formula for the boxplot is Hand.Wing.Index ~ Migration


# My solution is in 04_Exercise_solution.r

# If you made it through this tutorial, you're more than ready to write your own R code. The skills 
# you've earned also transfer to other program languages, so you can take advantage of tools 
# written in other languages as well. The most important thing is practice.
