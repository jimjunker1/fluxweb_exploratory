#March 29th HW assignment
load_packages = function(){
  if(!require("pacman")) install.packages("pacman")
  library(pacman)
  package.list <- c("fluxweb")
  p_load(char = package.list, install = T)
  rm("package.list")
  '%ni%' <- Negate('%in%')
}
load_packages();rm(load_packages)

#
spp.names = c("detritus","diatoms","mayfly","midge","pred_stonefly")

mat = matrix(c(0,0,1,1,0,
               0,0,1,1,0,
               0,0,0,0,1,
               0,0,0,0,1,
               0,0,0,0,0), byrow = T, nrow = 5, ncol = 5)

colnames(mat) <- rownames(mat) <- spp.names

biomasses = c(10000,10000,680,2000,100)

efficiencies = c(NA, NA, 0.3, 0.3, 0.9)

bodymasses = c(0.001,0.001,1,0.5,1.5)

met.rates = 17.17*bodymasses^(-0.29)
growth.rates = met.rates;growth.rates[3:5] <- NA

mat.fluxes = fluxing(mat = mat, efficiencies = efficiencies, 
                     biomasses = biomasses, losses = met.rates, 
                     bioms.losses = TRUE, bioms.prefs = FALSE, ef.level = "pred")


mat.fluxes
#               detritus diatoms   mayfly    midge pred_stonefly
# detritus             0       0 20872.78 71389.23        0.0000
# diatoms              0       0 20872.78 71389.23        0.0000
# mayfly               0       0     0.00     0.00      848.0693
# midge                0       0     0.00     0.00      848.0693
# pred_stonefly        0       0     0.00     0.00        0.0000
colSums(mat.fluxes)
# detritus       diatoms        mayfly         midge pred_stonefly 
# 0.000         0.000     41745.564    142778.455      1696.139 

## add gut content stuff but with constant efficiencies at 'prey level

spp.names = c("detritus","diatoms","mayfly","midge","pred_stonefly")

mat = matrix(c(0,0,0.30,0.60,0,
               0,0,0.70,0.40,0,
               0,0,0,0,0.25,
               0,0,0,0,0.75,
               0,0,0,0,0), byrow = T, nrow = 5, ncol = 5)

colnames(mat) <- rownames(mat) <- spp.names

efficiencies = c(0.35,0.35,0.9,0.9,0.9)

mat.fluxes = fluxing(mat = mat, efficiencies = efficiencies, 
                     biomasses = biomasses, losses = met.rates, 
                     bioms.losses = TRUE, bioms.prefs = FALSE, ef.level = "prey")
mat.fluxes
#               detritus diatoms   mayfly    midge pred_stonefly
# detritus             0       0 10371.12 74155.84        0.0000
# diatoms              0       0 24199.27 49437.22        0.0000
# mayfly               0       0     0.00     0.00      424.0346
# midge                0       0     0.00     0.00     1272.1039
# pred_stonefly        0       0     0.00     0.00        0.0000

colSums(mat.fluxes)
# detritus       diatoms        mayfly         midge pred_stonefly 
# 0.000         0.000     34570.385    123593.060      1696.139 
10371.12/34570.385 # == 0.3 same as relative gut content

#calculate stability
stability.value(mat.fluxes, biomasses = biomasses, losses = met.rates, 
                efficiencies = efficiencies, bioms.prefs = FALSE, bioms.losses = TRUE,
                growth.rate = met.rates, ef.level = 'prey', full.output = TRUE)
## add gut content stuff and changed efficiencies at prey level

spp.names = c("detritus","diatoms","mayfly","midge","pred_stonefly")

mat = matrix(c(0,0,0.30,0.60,0,
               0,0,0.70,0.40,0,
               0,0,0,0,0.25,
               0,0,0,0,0.75,
               0,0,0,0,0), byrow = T, nrow = 5, ncol = 5)

colnames(mat) <- rownames(mat) <- spp.names

efficiencies = c(0.1,0.35,0.9,0.9,0.9)

mat.fluxes = fluxing(mat = mat, efficiencies = efficiencies, 
                     biomasses = biomasses, losses = met.rates, 
                     bioms.losses = TRUE, bioms.prefs = FALSE, ef.level = "prey")
mat.fluxes
#               detritus diatoms   mayfly     midge pred_stonefly
# detritus             0       0 13199.60 129772.71        0.0000
# diatoms              0       0 30799.07  86515.14        0.0000
# mayfly               0       0     0.00      0.00      424.0346
# midge                0       0     0.00      0.00     1272.1039
# pred_stonefly        0       0     0.00      0.00        0.0000

colSums(mat.fluxes)
# detritus       diatoms        mayfly         midge pred_stonefly 
# 0.000         0.000     43998.671    216287.855      1696.139 
13199.60/43998.671 # == 0.3

## CHANGE JUST EFFICIENCIES
spp.names = c("detritus","diatoms","mayfly","midge","pred_stonefly")

mat = matrix(c(0,0,1,1,0,
               0,0,1,1,0,
               0,0,0,0,1,
               0,0,0,0,1,
               0,0,0,0,0), byrow = T, nrow = 5, ncol = 5)

colnames(mat) <- rownames(mat) <- spp.names

efficiencies = c(0.1,0.35,0.9,0.9,0.9)

mat.fluxes = fluxing(mat = mat, efficiencies = efficiencies, 
                     biomasses = biomasses, losses = met.rates, 
                     bioms.losses = TRUE, bioms.prefs = FALSE, ef.level = "prey")
mat.fluxes
#               detritus diatoms   mayfly    midge pred_stonefly
# detritus             0       0 27830.38 95185.64        0.0000
# diatoms              0       0 27830.38 95185.64        0.0000
# mayfly               0       0     0.00     0.00      848.0693
# midge                0       0     0.00     0.00      848.0693
# pred_stonefly        0       0     0.00     0.00        0.0000
colSums(mat.fluxes)
# detritus       diatoms        mayfly         midge pred_stonefly 
# 0.000         0.000     55660.752    190371.273      1696.139
27830.38/55660.752 # 0.5

##same with just biomass preferences
# should be the same for mayfly and midge
mat.fluxes = fluxing(mat = mat, efficiencies = efficiencies, 
                     biomasses = biomasses, losses = met.rates, 
                     bioms.losses = TRUE, bioms.prefs = TRUE, ef.level = "prey")
mat.fluxes
#               detritus diatoms   mayfly    midge pred_stonefly
# detritus             0       0 26902.14 96113.87        0.0000
# diatoms              0       0 26902.14 96113.87        0.0000
# mayfly               0       0     0.00     0.00      430.3635
# midge                0       0     0.00     0.00     1265.7750
# pred_stonefly        0       0     0.00     0.00        0.0000
colSums(mat.fluxes)
# detritus       diatoms        mayfly         midge pred_stonefly 
# 0.000         0.000     53804.282    192227.743      1696.139 
26902.14/53804.282 #== 0.5

## add gut content stuff but with changed efficiencies
spp.names = c("detritus","diatoms","mayfly","midge","pred_stonefly")

mat = matrix(c(0,0,0.30,0.60,0,
               0,0,0.70,0.40,0,
               0,0,0,0,0.25,
               0,0,0,0,0.75,
               0,0,0,0,0), byrow = T, nrow = 5, ncol = 5)

colnames(mat) <- rownames(mat) <- spp.names

efficiencies = c(0.1,0.35,0.9,0.9,0.9)

mat.fluxes = fluxing(mat = mat, efficiencies = efficiencies, 
                     biomasses = biomasses, losses = met.rates, 
                     bioms.losses = TRUE, bioms.prefs = FALSE, ef.level = "prey")
mat.fluxes
#               detritus diatoms   mayfly     midge pred_stonefly
# detritus             0       0 13199.60 129772.71        0.0000
# diatoms              0       0 30799.07  86515.14        0.0000
# mayfly               0       0     0.00      0.00      424.0346
# midge                0       0     0.00      0.00     1272.1039
# pred_stonefly        0       0     0.00      0.00        0.0000
colSums(mat.fluxes)
# detritus       diatoms        mayfly         midge pred_stonefly 
# 0.000         0.000     46586.829    229010.670      1795.911 
13976.05/46586.829 # == 0.3 same as relative gut content

## making this match with bioms.pref = TRUE
spp.names = c("detritus","diatoms","mayfly","midge","pred_stonefly")

mat = matrix(c(0,0,1.66,0.833,0,
               0,0,0.714,1.25,0,
               0,0,0,0,0.9852944,
               0,0,0,0,1.005,
               0,0,0,0,0), byrow = T, nrow = 5, ncol = 5)

colnames(mat) <- rownames(mat) <- spp.names

efficiencies = c(0.35,0.35,0.9,0.9,0.9)

mat.fluxes = fluxing(mat = mat, efficiencies = efficiencies, 
                     biomasses = biomasses, losses = met.rates, 
                     bioms.losses = TRUE, bioms.prefs = TRUE, ef.level = "prey")
mat.fluxes
#               detritus diatoms   mayfly     midge pred_stonefly
# detritus             0       0 51134.62  73258.79        0.0000
# diatoms              0       0 21994.05 109932.16        0.0000
# mayfly               0       0     0.00      0.00      448.9779
# midge                0       0     0.00      0.00     1346.9334
# pred_stonefly        0       0     0.00      0.00        0.0000
colSums(mat.fluxes)
# detritus       diatoms        mayfly         midge pred_stonefly 
# 0.000         0.000     71609.392    184255.487      1795.911 

###