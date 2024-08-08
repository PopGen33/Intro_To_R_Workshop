# Hello! This is a brief introduction to programming in R and programming in general
# We'll start with talking about some basic features of programming languages and how 
# to use them in R. This might not be immediately useful to you, but I feel it's 
# important to understand. Then, we'll move on to using R for data analysis. Throughout this, 
# I'll emphasize writing code that is not just functional but also *readable*.

# R has a really useful IDE (integrated development environment) called RStudio, so 
# I recommend using that for helping you write code even when you're just writing 
# simple scripts. It also has a lot of more advanced features geared toward 
# package development. You can get RStudio (and install R) from here:
# https://posit.co/download/rstudio-desktop/

##########################
## ! REALLY IMPORTANT ! ##
##########################
# A cool thing about RStudio is that you can run a line of code in a script 
# that you have open by putting your cursor in that line and pressing Crtl + Enter
# You can use that to run lines of code in this script and the other workshop scripts.

######################################
##  Basics: Comments and Variables  ##
######################################
# First, most programming languages give you the ability to make comments. In R,
# you use the '#' symbol to start a single line comment. In any line of this file, 
# everything after the '#' symbol is ignored by the program that interprets your 
# R code. Comments are very important for explaining your code to anyone who might 
# want to read it.

# When we need to store anything in R, we store that value in a variable. Variables 
# can be named any word that doesn't have a meaning in R's programming language. So, 
# for example, we can name a variable 'x' and store 1 to that variable using the 
# assignment operator '<-'.

x <- 1

# If you run the above line of code, you'll see that x is stored to your global 
# environment in the (shown in the upper right of RStudio). However, in most cases,
# you will want to name variables something descriptive of what's stored in them. 
# This will help make things more readable for you and anyone else who reads your
# code.

exampleString <- "Hello, World!"

# In the above line, the character string "Hello, World!" is stored to the variable
# "exampleString". Calling a variable in R simply prints its contents.

exampleString
x

# We can do simple math with variables...

y <- x + x # Addition; also storing the result to "y"
y - x # Subtraction; this line isn't storing the result anywhere, so it will just print
x * y # multiplication
x / y # division
y^y # exponentiation
11 %% y # Modulo; returns the remainder of 11 divided by y

################################################################
## More complex variables: Vectors, Matrices, and Data Frames ##
################################################################
# R is a statistics-oriented programming language, so it provides some 
# data structures that are useful for math and data analysis.

a_vector <- c(1,2,3,4,5) # A vector
the_same_vector <- c(1:5) # The same vector using R's built in range

a_matrix <- matrix(c(1,2,3,4), nrow = 2, ncol = 2) # A matrix that has 2 rows and 2 columns

a_data_frame <- as.data.frame(a_matrix) # A data frame created from the previous matrix

# Data frames seem superficially similar to matrices, but they're more flexible
# A matrix can only have one type of data in it (e.g. integer numbers), while a 
# data frame can have different columns that contain different types of data. 
# Data frames are how you'll store most data, so we'll focus on those in subsequent
# workshop modules.

##################
## Conditionals ##
##################
# It's common in programming to have parts of your code that only run if a given 
# condition is TRUE (or, conversely, if it's FALSE). R let's us have blocks of code 
# that only run when they need to by using IF and ELSE statements. For example, 
# the following will only run the code contained within the block bound by curly braces {} 
# if 'x' is greater than 0.

if(x > 0){
  paste0("X is greater than zero. X is ", x)
}

# We can make more complex conditionals by adding ELSE IF and ELSE statements (ELSE 
# statements only run if the conditional before them is false). Change the value of x
# in your console and run the following several times to see the different results:

if(x > 0){
  paste0("X is greater than zero. X is ", x)
}else if(x == 0){
  paste0("X is equal to zero. X is ", x)
}else{
  paste0("X is less than zero. X is ", x)
}

# The operations inside of if() are simple comparisons that return TRUE or FALSE. 
# We call these special TRUE or FALSE values logical or boolean values. There are several 
# kinds of comparison we can do...

x == y # x equals y?
x != y # x NOT equals y?
x > y # x greater than y?
x < y # x less than y?
x >= y # x greater than or equal to y?

# We can also combine these comparisons using special logical operators:

TRUE & TRUE # AND: Returns TRUE if both values are TRUE
TRUE | FALSE # OR: Returns TRUE if either value is TRUE
!TRUE # NOT: prepending ! to a boolean returns its opposite, so TRUE becomes FALSE and vice versa

# So, putting it all together, the following would run if x and y were both greater than zero:

if((x > 0) & (y > 0)){
  paste0("Both x and y are greater than zero.")
}

###########
## Loops ##
###########
# Sometimes you will need to perform the same operation several times for a set of values.
# For this, loops are used in most programming languages (R is a bit different, see below)
# Let's start with a vector of the integers 1 through 100 and an empty vector

example_vector <- 1:100
example_vector_squared <- c()

# We can perform an operation FOR each element in that vector:

for(i in example_vector){ # "For each element i in this vector, do...
  temp <- i^2 # ...store i^2 to a variable called 'temp'...
  example_vector_squared <- append(example_vector_squared, temp) # ... and put that value in the 2nd vector
}
rm(temp) # We can remove objects from our environment with rm (though, typically you don't need to)

# You can also write a loop that continues WHILE a certain condition is TRUE:

example_vector_squared <- c() # starting with an empty vector again
i = 1
while(i <= 100){
  example_vector_squared <- append(example_vector_squared, i^2)
  i <- i + 1
}

# *HOWEVER*, you often don't need to write loops in R because it understands loops implicitly for 
# some things and you can use apply() family functions (e.g., lapply, mapply) for others. For 
# example, squaring each element of example_vector doesn't need a loop:

example_vector_squared <- example_vector^2

# Apply family functions are quite a bit more complicated, but they let you apply a function to 
# each element of a vector or list or matrix or dataframe (depending on which apply you use). Here's 
# an example of getting the square root of each element of the example vector using lapply():

example_vector_sqrt <- unlist(lapply(example_vector, FUN = sqrt)) # lapply returns a list, unlist() converts it to vector

# Using apply family functions can get complicated, but there are lots of good tutorials online and
# you can read the documentation when you're struggling. Try help("lapply") .

###############
## Functions ##
###############
# In addition to the functions available in R and various R packages, we can also make our own 
# functions. This is particularly useful if you have a piece of code that needs to be executed 
# many times. Defining a function in R is a lot like making a variable:

a_function <- function(an_argument){
  a_return_value <- an_argument * 10
  return(a_return_value)
}

# The above shows the general form of defining a function. "a function" is the name of the function.
# "an_argument" is the name of a variable that will receive an input when the function is called.
# "a_return_value" is a variable that is returned (output) by the function in the return() statement.
# This function just take a number and multiplies it by 10:

a_function(10)

# The above is a trivial example. Here is more complex example that returns the population size 
# at time t of a population following a distrete logistic growth model given n_0 (the population 
# at time 0), r (the intrinic growth rate), t (the time step for which we're calculating popsize), 
# and k (carrying capacity):

popSize_DiscreteLogisticGrowth <- function(t, r, k, n_0 = 1){
  # check for valid inputs; throw errors if the inputs aren't valid
  if(k <= 0){
    stop("k must be greater than zero")
  }else if(n_0 <= 0){
    stop("n_0 must be greater than zero")
  }else if(t < 0){
    stop("t must be greater than or equal to zero")
  }
  # if t = 0, just return n_0
  if(t == 0){
    return(n_0)
  }
  # calculate popsize at time t given r, k, n_0 and return popsize
  popSize = n_0
  for(counter in 0:t){
    popSize <- popSize*(1+r*(1-(popSize/k)))
  }
  return(popSize)
}

# The above example also demonstrates n_0 having a default value of 1, so we don't need 
# to enter that argument when we call the function, but can if we need a value different from zero.
# *IMPORTANT* Notice that the different arguments to the function are separated by commas 
# and that arguments are in the same order as when the function was defined above.

popSize_DiscreteLogisticGrowth(10, 0.5, 200)
popSize_DiscreteLogisticGrowth(10, 0.5, 200, 100)
# The line below is identical to the line above but with arguments explicitly written out
popSize_DiscreteLogisticGrowth(t = 10, r = 0.5, k = 200, n_0 = 100)

# We can combine our function with lapply to make vectors of population sizes for many t:
times <- seq(from = 0, to = 100, by = 5)
popSizeHistory <- unlist(lapply(times, FUN = popSize_DiscreteLogisticGrowth, r = 0.1, k = 300, n_0 = 5))

# ... and plot them:
plot(x = times, y = popSizeHistory, type = "b", xlab = "Time", ylab = "PopSize")

# This is the end of the crash course basic programming portion of the workshop. Given the 
# above, you can write any program you need to, but keep in mind it's often easier and safer 
# to use software that others have already written (most often in the form of packages). Always 
# check if there are resources available for doing a particular analysis before you resort to 
# writing it yourself! We'll talk about how to use these resources in the next workshop module.
