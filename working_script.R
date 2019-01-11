#install pacakges
install.packages('fluxweb')
'%ni%' <- Negate('%in%')

#load packages
library(fluxweb)

## pull the package example data sets
# view the data available
data(package = "fluxweb")

#load in different data sets
groups = groups.level#aggregated case

species = species.level#complicated case

simple = simple.case##

#setting the metabolic rates for fluxing example

met.rates <- 0.71 + groups[['bodymasses']] ^ 0.25

mat.fluxes = fluxing(groups[[1]], groups[['biomasses']], met.rates,
        groups[['efficiencies']], bioms.losses = T, bioms.prefs = T, ef.level = "prey")

attach(species.level)
met.rates = 0.71+species.level$bodymasses^-0.25

colnames(mat) <- rownames(mat) <- species.level$names

mat.fluxes <- fluxing(mat, biomasses, met.rates, efficiencies)

basals <- colSums(mat.fluxes) == 0
names[basals]

plants <- basals

plants[which(names == "dead organic matter" | names == "root exudates")] = F

herbivory = sum(rowSums(mat.fluxes[plants,]))

carnivory = sum(rowSums(mat.fluxes[!basals,]))

detritivory = sum(mat.fluxes[names == "dead organic matter",])

total <- sum(mat.fluxes)

herbivory
carnivory
detritivory
total
sum(herbivory,carnivory,detritory)
