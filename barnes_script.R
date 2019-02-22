#barnes working script
#load packages
library(splitstackshape)
library(igraph)

barnes_data = read.csv(file = "Barnes_data.csv",T)

idat = expandRows(barnes_data, "abundance", drop = F)

idat$dw = idat$biomass/idat$abundance

idat$fw = idat$dw * 4

idat$mr = idat$mlO2.mg.h * idat$fw * 20.1

idat$mr[idat$species == "Fundulus heteroclitus"] = exp(-0.919-0.204 * log(idat$fw[idat$species == "Fundulus heteroclitus"]/1000) + (0.028 * 23)) * (idat$fw[idat$species == "Fundulus heteroclitus"]/1000)*20.1

idat$mr[idat$species == "Syngnathus spp."] = exp(0.8 * log(idat$fw[idat$species == "Syngnathus spp."]/1000)-5.43)* 22.391 * 20.1

idat$mr[idat$species == "Callinectes spadius"] = 0.0741 * (idat$fw[idat$species == "Callinectes spadius"]/1000) *20.1

idat$mr[idat$species == "Hippolyte pleuracanthus"] = 46.5 * (idat$fw[idat$species == "Hippolyte pleuracanthus"]/1000) * 0.22391 *20.1

#group individual

ids = unique(idat$sample)
ids = sort(ids)

richness = as.numeric(tapply(idat$richness, idat$sample, mean))

abundance = as.numeric(tapply(idat$sample, idat$sample, length))

pred.abund = as.numeric(tapply(idat$sample[idat$trophic.level == "Predator"], idat$sample[idat$trophic.level == "Predator"], length))
pred.abund[is.na(pred.abund)] = 0

herb.abund = as.numeric(tapply(idat$sample[idat$trophic.level == "Herbivore"], idat$sample[idat$trophic.level == "Herbivore"], length))
herb.abund[is.na(herb.abund)] = 0

prim.abund = as.numeric(tapply(idat$sample[idat$trophic.level == "Primary producer"], idat$sample[idat$trophic.level == "Primary producer"], length))

biomass.fresh = as.numeric(tapply(idat$fw, idat$sample, sum))

pred.biomass = as.numeric(tapply(idat$fw[idat$trophic.level == "Predator"], idat$sample[idat$trophic.level == "Predator"], sum, na.rm = T))
pred.biomass[is.na(pred.biomass)] = 0

herb.biomass = as.numeric(tapply(idat$fw[idat$trophic.level == "Herbivore"], idat$sample[idat$trophic.level == "Herbivore"], sum, na.rm = T))
herb.biomass[is.na(herb.biomass)] = 0

prim.biomass = as.numeric(tapply(idat$fw[idat$trophic.level == "Primary producer"], idat$sample[idat$trophic.level == "Primary producer"], sum, na.rm = T))
prim.biomass[is.na(prim.biomass)] = 0

pred.met = as.numeric(tapply(idat$mr[idat$trophic.level == "Predator"], idat$sample[idat$trophic.level == "Predator"], sum, na.rm = T))

herb.met = as.numeric(tapply(idat$mr[idat$trophic.level == "Herbivore"], idat$sample[idat$trophic.level == "Herbivore"], sum, na.rm = T))

sampledata= data.frame(ids = ids, richness = richness, abundance = abundance, pred.abund = pred.abund, herb.abund = herb.abund, prim.abund = prim.abund,
                       biomass.fresh = biomass.fresh, pred.biomass = pred.biomass, herb.biomass = herb.biomass, prim.biomass = prim.biomass, 
                       pred.met = pred.met, herb.met = herb.met)

ePre = 0.906

eHer = 0.545

sampledata = subset(sampledata, pred.abund != 0 & herb.abund != 0)

F_Ps = c()
F_Hs = c()
samplefluxs = c()

for(i in 1:length(sampledata$ids)){
  temp.id = sampledata$ids[i]
  X_P = sampledata$pred.met[i]
  X_H = sampledata$herb.met[i]
  if(sampledata$pred.abund[i]>0 && sampledata$herb.abund[i]>0){
    F_P = (1/ePre) * X_P
    F_H = (1/eHer) * (X_H+F_P)
  }
if(sampledata$pred.abund[i]==0 && sampledata$herb.abund[i]>0){
  F_P = 0
  F_H = (1/eHer)*X_H
}
F_Ps = c(F_Ps, F_P)
F_Hs = c(F_Hs, F_H)

sampleflux = sum(F_P, F_H)
samplefluxs = c(samplefluxs, sampleflux)
}

sampledata = cbind(sampledata, flux.to.pred=F_Ps, flux.to.herb = F_Hs, energyflux = samplefluxs)

par(mfrow = c(1,2), oma = c(0,0,2,1), mar = c(4,4,0,0))

richness = sampledata$richness
energyflux = sampledata$energyflux
predflux = sampledata$flux.to.pred
herbflux = sampledata$flux.to.herb

chain = graph(c("Primary producers", "Herbivores", "Herbivores", "Predators"))

layout_chain = matrix(c(1,1,1,1,2,3,1,1,1), nrow = 3, ncol = 3)

plot(chain, 
     layout = layout_chain, 
     vertex.color = c("grey", "#fbbf17", "#ef3729"),
     vertex.frame.color = FALSE, 
     vertex.size = c(log10(mean(prim.biomass))*20,
                     log10(mean(herb.biomass))*20,
                     log10(mean(pred.biomass))*20),
     edge.color = c("#fbbf17", "#ef3729"), 
     edge.arrow.size = 0,
     edge.width = c(mean(herbflux), mean(predflux)), 
     vertex.label.cex = 1.2, 
     vertex.label.dist = c(14,11,10), 
     vertex.label.degree = 0)

mtext("a)", side = 3, line = 1.5, cex = 1.2, adj = 0, font = 2)

modfull = lm(energyflux~richness)
summary(modfull)

modpred = lm(predflux~richness)
summary(modpred)

modherb = lm(herbflux~richness)
summary(modherb)

plot(richness, energyflux, type = "n", xlab = "Richness txt", ylab = "Energyflux [J/h]")
points(richness, energyflux, col = "black", pch = 19)
points(richness+0.5, predflux, col = "#ef3729", pch = 19)
points(richness+0.1, herbflux, col = "#fbbf17", pch = 19)

legend("topleft", legend = c("Multitrophc flux", "Herbivory", "Predation"), bty = "n", 
       col = c("black", "#fbbf17", "#ef3729"), lty = c(1,2,2), lwd = 2.5, pch = NULL, cex = 1)
x = seq(min(richness), max(richness), length.out = length(richness))
yfull = predict(modfull, newdata = list(richness = x))
lines(x, yfull, col = "black", lwd = 2.5)

ypred = predict(modpred, newdata = list(richness = x))
lines(x, ypred, col = "#ef3729", lwd = 2.5)
yherb = predict(modherb, newdata = list(richness = x))
lines(x, yherb, col = "#fbbf17", lwd = 2.5)

mtext("b)", side = 3, line = 1.5, cex = 1.2, adj = 0, font = 2)

