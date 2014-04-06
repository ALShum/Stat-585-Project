library(acs)
library(ggplot2)
library(reshape2)
library(plyr)


#B01001
states = geo.make(state = "*")
age = acs.fetch(endyear = 2012, span = 5, geography = states, 
                table.number = "B01001", col.names="pretty")
age.df = data.frame(age@estimate)
names(age.df) = gsub("Sex.by.Age..", "", names(age.df))
age.df = age.df[,-c(1,2,26)]
age.df$state = rownames(age.df)
rownames(age.df) = NULL
age.melt = melt(age.df, id='state')
agecols = ldply(strsplit(as.character(age.melt$variable), "\\.\\."))
names(agecols) = c("gender", "age")
agesex = data.frame(state = age.melt$state, gender = agecols$gender, 
                     age = agecols$age, freq = age.melt$value)
agesex$age = factor(age.df2$age, levels(age.df2$age)[c(23, 12, 1:11, 13:22)])

qplot(age, freq, data=subset(agesex, state=="Alaska")) + coord_flip()
