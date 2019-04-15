#install pacakges
load_packages = function(){
if(!require("pacman")) install.packages("pacman")
library(pacman)
package.list <- c("fluxweb")
p_load(char = package.list, install = T)
rm("package.list")
'%ni%' <- Negate('%in%')
}
load_packages();rm(load_packages)
##view the package example data sets
#  the data available
data(package = "fluxweb")

#look at the matrices of different data sets
colnames(simple.case$mat) <- rownames(simple.case$mat) <- simple.case$names
View(t(simple.case$mat))
#groups case 
colnames(groups.level$mat) <- rownames(groups.level$mat) <- unique(groups.level$species.tgs$TroG)
View(t(groups.level$mat))
#species level
colnames(species.level$mat) <- rownames(species.level$mat) <- species.level$names
View(species.level$mat)

#setting the metabolic rates for fluxing example

met.rates <- 0.71 + groups[['bodymasses']] ^ 0.25

mat.fluxes = fluxing(groups[[1]], groups[['biomasses']], met.rates,
        groups[['efficiencies']], bioms.losses = T, bioms.prefs = T, ef.level = "prey")

# attach(species.level)
attach(groups.level)

met.rates = 0.71+species.level$bodymasses^-0.25
met.rates = 0.71+groups$bodymasses^-0.25

colnames(simple['mat']$mat) <- rownames(simple['mat']$mat) <- simple['names']$names
# colnames(mat) <- rownames(mat) <- species.level$names
attach(species.level)
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
sum(herbivory,carnivory,detritivory)
##for some reason the sums don't match
identical(total,sum(herbivory, carnivory, detritivory))

simple.case$efficiencies[3] <- 1.0

colnames(simple.case$mat) <- rownames(simple.case$mat) <- simple.case$names

mat.fluxes = fluxing(mat = t(simple.case$mat), losses = simple.case$met.rate, biomasses = simple.case$biomasses,
                     efficiencies = simple.case$efficiencies, bioms.prefs = TRUE, bioms.losses = FALSE, ef.level = 'pred')
mat.fluxes

simple.case$mat

losses = 0.15 * $bodymasses^(-0.25)

growth.rates = rep(NA, dim(simple.case$mat)[1])
growth.rates[colSums(groups.level$mat) == 0] = 0.5

make.stability(mat.fluxes, biomasses = simple.case$biomasses, losses = simple.case$met.rates, efficiencies = simple.case$efficiencies, growth.rates, 
               bioms.prefs = TRUE, bioms.losses = TRUE, ef.level = "prey", interval = c(1e-12, 1))
 diag(simple.case$efficiencies)         
 