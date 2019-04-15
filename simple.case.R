rm(list = ls())
library(fluxweb)
library(tidyverse)

#adding column and row names to the matrix
simple.case$mat
colnames(simple.case$mat) <- rownames(simple.case$mat) <- simple.case$names
simple.case$mat

#error in dataset. . matrix needs to be transposed
mat <- t(simple.case$mat)

#View pieces of data, if you'd like
#View(simple.case$biomasses)
#View(simple.case$met.rate)
#View(simple.case$efficiencies)
#View(simple.case$names)


#let's flux it up folks, biom.prefs = FALSE (this divides all fluxes to a predator evenly), bioms.losses = FALSE 
#(you do this when metabolic rates are directly measured on whole population, instead of by individual; i.e., no need for equation 8), ef.level = pred 
fluxes <- fluxing(mat, simple.case$biomasses, simple.case$met.rate, simple.case$efficiencies, 
                  bioms.prefs = FALSE, bioms.losses = FALSE, ef.level = "pred")
                  
#View(fluxes)

#the conceptual logic we used to calculate fluxes
#total flux into (consumption by) Palaemonetes is the total metabolic loss (30.56306) divided by 2 (two food sources) - and then divided by the efficiency of the pred (0.906)
#so, each flux is 15.28153/0.906 = 16.86703
#next for Gammarus, its total metabolic loss plus fluxes out divided by the efficiency (0.00000913 + 16.86703/0.545) = 30.94869
#etc.(see supplementary info for equation)

#####CODE STEP THROUGH. . . .now, we're going to step through the pieces of code that actually give us the fluxes.  Have a look at the code:
View(fluxing)

#if biom.prefs = FALSE, then the code splits fluxes evenly among food categories for a given consumer
#Here is how it does that:   mat[, column.sum > 0] = sweep(as.matrix(mat[, column.sum > 0]), 2, column.sum[column.sum > 0], "/")
#this code pulls out the columns of the matrix with something in them (i.e., 'mat[, column.sum > 0]' or all consumers and no basal food resources), 
#and then it divides each number in the matrix (in a given column) by the columnsum for that column. 
#let's look at the column sums
column.sum = colSums(mat)

#now, here's just the columns of the matrix that have something in them 
mat[, column.sum > 0]

#and here's what the code below is doing: each number in the last column of 'mat[, column.sum > 0]', for example, is divided by the column sum for that column (i.e., '2'), 
#each number in column 1 is divided by 1, etc.  This gives you a new matrix
mat[, column.sum > 0] = sweep(as.matrix(mat[, column.sum > 0]), 2, column.sum[column.sum > 0], "/")

#check it out 
mat[, column.sum > 0]

#and here is the full new matrix
mat

#now, since biomass losses are FALSE, we just use the 'met.rate' as the total losses, and the 'biomasses' data are not needed
#the code then calculates the flux matrix as 'F = (diag(E)-mat ^-1) * losses  (see supplementary for derivation)
#let's step through how the code does this.  First, we subtract the new full matrix from a diagonal matrix of the predator efficiencies (efficiencies on the diagonals, zeros otherwise)
first <- diag(simple.case$efficiencies) - mat
#next, we take the inverse of this matrix (in R, this is the 'solve' function - same as raising to the negative 1)
second <- solve(first)
#finally, we multiply by losses (make sure you use this 'matrix' multiplication syntax - i.e., %*%)
third <- second %*% simple.case$met.rate

#now, we need to finish out the flux code by multiplying our matrix values, now called 'third' by the new full matrix: flux.mat = sweep(mat, 2, third, "*")
#this is basically multiplying the numbers in 'third' by each row of numbers in 'mat' (when you select sweep by column (i.e., '2'), it takes the vector (i.e., 'third') and distributes the operation - in this case, *, 
#across columns in the first row of the matrix. So, if you look at 'mat' and 'third' for this example, 30.94869 is multiplied by 0, 30.94870 is multiplied by 0, 
#61.94319 is multiplied by 0, and 33.7340563 is multiplied by 0.5; thus, if you run the code below, we get 16.86703 as row 1, column 4 in our final flux matrix called 'flux.mat' 
flux.mat = sweep(mat, 2, third, "*"); flux.mat

###################################################################################################################
######now. . let's clear the deck, start over, and set biom.prefs to 'TRUE'. It's all the same logic, except that fluxes are weighted by the biomass of different prey
rm(list = ls())

library(fluxweb)
library(tidyverse)

simple.case$mat
colnames(simple.case$mat) <- rownames(simple.case$mat) <- simple.case$names
simple.case$mat

mat <- t(simple.case$mat)

fluxes <- fluxing(mat, simple.case$biomasses, simple.case$met.rate, simple.case$efficiencies, 
                  bioms.prefs = TRUE, bioms.losses = FALSE, ef.level = "pred")

#View(fluxes)

#####CODE STEP THROUGH. . . .
column.sum = colSums(mat)
mat[, column.sum > 0]

# now, for each column of the matrix, each value has to be 'weighted' to account for differences in biomass among food categories. In each column of the matrix, these should add up to 1.
mat[, column.sum > 0] = apply(as.matrix(mat[, column.sum > 0]), 2, function(vec) vec * simple.case$biomasses/sum(vec * simple.case$biomasses))

mat
first <- diag(simple.case$efficiencies) - mat
second <- solve(first)
third <- second %*% simple.case$met.rate
flux.mat = sweep(mat, 2, third, "*"); flux.mat

##playing with weighting the matrix
mat2 = matrix(c(0,0,0,2,
                0,0,0,1,
                1,1,0,0,
                0,0,0,0), byrow = T, ncol = 4)
column.sum2 = colSums(mat2)
mat2[, column.sum2 > 0]



mat2[,column.sum2 > 0 ] = apply(as.matrix(mat2[,column.sum2 > 0 ]),2,function(vec) vec*simple.case$biomasses/sum(vec*simple.case$biomasses))
mat2
###
########################################################################################################################################
####let's move onto changing the 'ef.level' to "prey"; this is important for assigning efficiency values to foods, rather than consumers
###we'll set the biom.prefs back to FALSE to keep it simple
rm(list = ls())

library(fluxweb)
library(tidyverse)

simple.case$mat
colnames(simple.case$mat) <- rownames(simple.case$mat) <- simple.case$names
simple.case$mat

mat <- t(simple.case$mat)

fluxes <- fluxing(mat, simple.case$biomasses, simple.case$met.rate, simple.case$efficiencies, 
                  bioms.prefs = FALSE, bioms.losses = FALSE, ef.level = "prey")

#View(fluxes)
######CODE STEP THROUGH. . . .
column.sum = colSums(mat)
mat[, column.sum > 0]
mat[, column.sum > 0] = sweep(as.matrix(mat[, column.sum > 0]), 2, column.sum[column.sum > 0], "/")

#Below there is some data manipulation that I can walk through, but don't fully understand (i.e., transposing the matrix, etc).  
#now, if (ef.level == "prey") 
  vec.in = as.vector(t(mat) %*% simple.case$efficiencies)
#adding a nutrient node on which all basal species feed with an efficiency of 1
  vec.1p = rep(0, dim(mat)[1])
  vec.1p[colSums(mat) == 0] = 1
#solving fluxes (vec.in + vec.1p is basically making a new set of efficiencies)
  F = solve(diag(vec.in + vec.1p) - mat) %*% simple.case$met.rate
  flux.mat = sweep(mat, 2, F, "*"); flux.mat

  
########################################################################################################################################
####now, let's keep the 'ef.level' to "prey"; and now change biom.prefs back to TRUE
  
  rm(list = ls())
  
  library(fluxweb)
  library(tidyverse)
  
  simple.case$mat
  colnames(simple.case$mat) <- rownames(simple.case$mat) <- simple.case$names
  simple.case$mat
  
  mat <- t(simple.case$mat)
  
  fluxes <- fluxing(mat, simple.case$biomasses, simple.case$met.rate, simple.case$efficiencies, 
                    bioms.prefs = TRUE, bioms.losses = FALSE, ef.level = "prey")
  
  
  #####CODE STEP THROUGH. . . .
  column.sum = colSums(mat)
  mat[, column.sum > 0]
  
  # now, for each column of the matrix, each value has to be 'weighted' to account for differences in biomass among food categories. In each column of the matrix, these should add up to 1.
  mat[, column.sum > 0] = apply(as.matrix(mat[, column.sum > 0]), 2, function(vec) vec * simple.case$biomasses/sum(vec * simple.case$biomasses))
  mat
  #now, if (ef.level == "prey") 
  vec.in = as.vector(t(mat) %*% simple.case$efficiencies)
  #adding a nutrient node on which all basal species feed with an efficiency of 1
  vec.1p = rep(0, dim(mat)[1])
  vec.1p[colSums(mat) == 0] = 1
  #solving fluxes (vec.in + vec.1p is basically making a new set of efficiencies)
  F = solve(diag(vec.in + vec.1p) - mat) %*% simple.case$met.rate
  flux.mat = sweep(mat, 2, F, "*"); flux.mat
  
########################################################################################################################################
####now, let's keep preferences TRUE and now pretend that the met.rates in this example are equal to metabolic rates of individuals 
#(so, biom.losses = TRUE), instead of the experimental population
  rm(list = ls())
  
  library(fluxweb)
  library(tidyverse)
  
  simple.case$mat
  colnames(simple.case$mat) <- rownames(simple.case$mat) <- simple.case$names
  simple.case$mat
  
  mat <- t(simple.case$mat)
  mat
  fluxes <- fluxing(mat, simple.case$biomasses, simple.case$met.rate, simple.case$efficiencies, 
                    bioms.prefs = TRUE, bioms.losses = TRUE, ef.level = "prey")
  
  #####CODE STEP THROUGH. . . .
  column.sum = colSums(mat)
  mat[, column.sum > 0]
  
  # now, for each column of the matrix, each value has to be 'weighted' to account for differences in biomass among food categories. In each column of the matrix, these should add up to 1.
  mat[, column.sum > 0] = apply(as.matrix(mat[, column.sum > 0]), 2, function(vec) vec * simple.case$biomasses/sum(vec * simple.case$biomasses))
  mat
  #now, if (ef.level == "prey") 
  vec.in = as.vector(t(mat) %*% simple.case$efficiencies)
  #adding a nutrient node on which all basal species feed with an efficiency of 1
  vec.1p = rep(0, dim(mat)[1])
  vec.1p[colSums(mat) == 0] = 1
  #solving fluxes (vec.in + vec.1p is basically making a new set of efficiencies) (adding in the inclusion of biomasses to the equation below)
  F = solve(diag(vec.in + vec.1p) - mat) %*% simple.case$met.rate * simple.case$biomasses
  flux.mat = sweep(mat, 2, F, "*"); flux.mat
  
  