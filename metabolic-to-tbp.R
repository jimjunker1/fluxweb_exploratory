# modeling consumer level GPE with varying diets
library(tidyverse)
theme_set(theme_bw())
# So here is an interesting question and something I 

leaves = seq(0,1,0.05)
animal = 1 - leaves

df = data.frame(leaves, animal)
df = df %>% mutate(GPE = ((leaves*0.05)+(animal*0.7))*0.5) %>%
  mutate(GPErel = (GPE/mean(GPE))*100)

ggplot(df, aes(x = animal, y = GPE)) + geom_path(size = 2)
ggplot(df, aes(x = animal, y = GPErel)) + geom_path(size = 2) + geom_abline(intercept = 100)

#So using the global mean GPE of 0.1875 and a total production of 1000
# estimated consumption is 1000/0.1875

1000/0.1875#5333

# But the realized GPE of the consumer can vary based on diet shifts and 
# differences in assimilation among diet items. If we

1000/min(df$GPE)#40000

1000/max(df$GPE)#2857

