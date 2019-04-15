### Code for HW for April 5th
library(plyr)
library(tidyverse)
library(fluxweb)
names = c("prod_mg_m_y","diet_item","diet_prop","assim_eff","npe")

data = as.data.frame(matrix(c(5000,"diatom",0.2,0.35,0.5,
              5000,"detritus",0.8,0.1,0.5),
              ncol = 5, nrow = 2, byrow = TRUE), stringsAsFactors = FALSE)

colnames(data) <- names

##
data = data %>% 
  mutate_at(vars(prod_mg_m_y, diet_prop, assim_eff, npe),as.numeric) %>%
  mutate(rel_prod = (diet_prop*assim_eff*npe)*100,
                       rel_attr = rel_prod/sum(rel_prod),
                       prod_attr = rel_attr*prod_mg_m_y,
                       consum = prod_attr/(assim_eff*npe))
###
names = c("diatoms", "detritus", "consumer")

mat = matrix(c(0,0,0.2,
               0,0,0.8,
               0,0,0), ncol = 3, nrow = 3, byrow = TRUE)

colnames(mat) <- rownames(mat) <- names

met.rates <- c(0, 0, 10000)

efficiencies = c(0.35,0.1,NA)

mat.fluxes = fluxing(mat=mat, losses = met.rates, efficiencies = efficiencies,
                     bioms.losses = FALSE, bioms.prefs = FALSE, ef.level = "prey")
mat.fluxes
colSums(mat.fluxes)

## add in a top predator now
names = c("diatoms", "detritus", "consumer", "predator")

mat = matrix(c(0,0,0.2,0,
               0,0,0.8,0,
               0,0,0,1,
               0,0,0,0), ncol = 4, nrow = 4, byrow = TRUE)

colnames(mat) <- rownames(mat) <- names

met.rates <- c(0, 0, 10000, 2000)

efficiencies = c(0.35,0.1,0.9, NA)

mat.fluxes = fluxing(mat=mat, losses = met.rates, efficiencies = efficiencies,
                     bioms.losses = FALSE, bioms.prefs = FALSE, ef.level = "prey")
mat.fluxes
colSums(mat.fluxes)

## now try to get consumption of primary consumer to match with a predator

names = c("diatoms", "detritus", "consumer", "predator")

mat = matrix(c(0,0,0.2,0,
               0,0,0.8,0,
               0,0,0,1,
               0,0,0,0), ncol = 4, nrow = 4, byrow = TRUE)

colnames(mat) <- rownames(mat) <- names

biomasses <- c(10000,70000,1000, 200)

met.rates <- c(2, 1,7.777777777, 10)

efficiencies = c(0.35,0.1,0.9, NA)

mat.fluxes = fluxing(mat=mat, biomasses = biomasses, losses = met.rates, efficiencies = efficiencies,
                     bioms.losses = TRUE, bioms.prefs = FALSE, ef.level = "prey")
mat.fluxes
colSums(mat.fluxes)

10-((2222.2222222/10000)*10)

growth.rates = rep(NA, dim(mat)[1])
growth.rates[colSums(mat) == 0] = 0.5

make.stability(mat.fluxes, biomasses = biomasses, losses = met.rates, efficiencies = efficiencies, growth.rates, 
               bioms.prefs = FALSE, bioms.losses = TRUE, ef.level = "prey", interval = c(1e-12, 1))
