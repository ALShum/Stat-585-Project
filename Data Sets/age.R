library(acs)
library(ggplot2)
library(reshape2)
library(plyr)
#B01001
# ages 0-4, 5-9, 10-14, *15-19*, *20-24*, 25-29, 30-34, 35-39, 40-44, 45-49,
# 50-54, 55-59, *60-64*, *65-69*, 70-74, 75-79, *80+*
states = geo.make(state = "*")
age = acs.fetch(endyear = 2012, span = 5, geography = states, 
                table.number = "B01001", col.names="pretty")
age.df = data.frame(age@estimate)
names(age.df) = gsub("Sex.by.Age..", "", names(age.df))

age.df = age.df[,-c(1,2,26)]
age.df$state = rownames(age.df)
rownames(age.df) = NULL

age.df$Male..15.to.19.years = age.df[,4] + age.df[,5]
age.df$Female..15.to.19.years = age.df[,27] + age.df[,28]

age.df$Male..20.to.24.years = age.df[,6] + age.df[,7] + age.df[,8]
age.df$Female..20.to.24.years = age.df[,29] + age.df[,30] + age.df[,31]

age.df$Male..60.to.64.years = age.df[,16] + age.df[,17]
age.df$Female..60.to.64.years = age.df[,39] + age.df[,40]

age.df$Male..65.to.69.years = age.df[,18] + age.df[,19]
age.df$Female..65.to.69.years = age.df[,41] + age.df[,42]

age.df = age.df[,-c(4:8, 16:19, 27:31, 39:42)]

age.melt = melt(age.df, id='state')
agecols = ldply(strsplit(as.character(age.melt$variable), "\\.\\."))
names(agecols) = c("gender", "age")
agesex = data.frame(state = age.melt$state, gender = agecols$gender, 
                     age = agecols$age, freq = age.melt$value)
agesex$age = factor(agesex$age, levels(agesex$age)[c(18, 9, 1:8, 10:17)])
levels(agesex$age) = gsub(".years", "", levels(agesex$age))
agesextable = agesex
