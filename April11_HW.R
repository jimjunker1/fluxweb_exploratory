# Homework 3 for April 11/18
library(fluxweb)
library(tidyverse)
source("./fluxweb_mod_function.R")
names = c("detritus", "diatoms","mayfly","midge","predatory stonefly")

mat = matrix(c(0,0,.8,.8,0,
               0,0,.2,.2,0,
               0,0,0,0,.7,
               0,0,0,0,.3,
               0,0,0,0,0), ncol = 5, byrow = TRUE)

colnames(mat) <- rownames(mat) <- names
mat
met.demand = c(1,1,500,1000,200)

efficiencies = c(0.1,0.35, 0.9,0.9, NA)
# debugonce(fluxing)
mat.fluxes = fluxing(mat = mat, losses = met.demand, efficiencies = efficiencies,
                     bioms.prefs = FALSE, bioms.losses = FALSE, ef.level = 'prey', method = "tbp")
mat.fluxes

# diag(met.demand) %/% 

mat.fluxes[,5] %/% diag(met.demand)
