###########################
##  Variables and Types  ##
###########################
# Let's talk about variables and types. When you store things in a computer,
# it's all stored as binary (1s and 0s), so a computer needs to know what a 
# variable's *type* to interpret it correctly. In R, numbers (mostly) have two
# different types: integers (whole numbers) and floating point numbers (decimals; 
# R stores these as double precision floats, so their type is "double").
# To store a variable in R, we use the '<-' operator, so let's store a few numbers:

x <- 1L # The 'L' immediately after the integer number here forces it to be stored as integer
y <- 1.5

# You can also store character data in quotes (words!; often called 'strings')
# Note that the quotes aren't stored as part of this; they're there to delimit 
# what you want to store from the rest of your code:

z <- "Hello, World!"

# If we just type a variable into the console, R simply prints its value:

z

# Finally, there are special types for the logical values True and False
# These are called Boolean or logical variables and, in R, they're declared 
# by typing TRUE or FALSE (no quotes!). Note that here I've given the variable
# a descriptive name. Giving your variables descriptive names makes your code more 
# readable for you and anyone who might want to use it.

aBooleanVariable <- TRUE

# You'll almost never store booleans yourself, but they're the type returned by 
# logical comparison operations.

# R also has a special type for categorical variables called a 'factor'. It's
# important to make sure things you consider categorical variables have this 
# type so that stats functions interpret your data correctly.

a_factor <- factor("Treatment")

# R let's you ask for information about variables using two functions: typeof() and 
# class(). You can think of functions as short programs that take an input and return
# an output. In this case, the input is our variables and the output is information 
# about them.
typeof(x)
typeof(y)
typeof(z)
typeof(aBooleanVariable)
typeof(a_factor) # Note that this returns int even though we initialized it with a string!

class(x)
class(y) # Note that this returns 'numeric', which is apparently equivalent in R:
# https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/numeric
class(z)
class(aBooleanVariable)
class(a_factor)

# So, these functions seem to give the similar answers for very basic types, but let's
# call them on a matrix.

a_matrix <- matrix(c(1.1,2,3,4), nrow = 2, ncol = 2)
typeof(a_matrix) # Returns 'double' because the things stored in the matrix are doubles
class(a_matrix) # Returns 'matrix' and 'array' because you can *use* this object as a matrix or array!

# So, typeof() tells you what something fundamentally is and class() tells you how you are
# allowed to use it. Very useful!

# Alright, let's get an error on purpose and talk about what it's 
# telling you:

x + z # 1 + "Hello, World!"? Total nonsense. R doesn't understand.

# The error above says "Error in x + z : non-numeric argument to binary operator"
# So, what is it telling us? The operator in question is "+". It doesn't take 
# non-numeric inputs, so z, the string "Hello, World!" is causing the problem. 
# Adding two numbers performs normally

x + y

# I know this might seem trivial, but it's very common to get errors when you're 
# programming. It's important to be able to read them and understand what they're
# telling you. Knowing some of the terminology, including types and classes, can help 
# you understand the errors you'll inevitably get and help you ask better questions
# when you need help (or just Google answers more efficiently).
