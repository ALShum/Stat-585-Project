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
age.melt = melt(age.df, id='state')
agecols = ldply(strsplit(as.character(age.melt$variable), "\\.\\."))
names(agecols) = c("gender", "age")
agesex = data.frame(state = age.melt$state, gender = agecols$gender, 
                     age = agecols$age, freq = age.melt$value)
agesex$age = factor(age.df2$age, levels(age.df2$age)[c(23, 12, 1:11, 13:22)])

qplot(age, freq, data=subset(agesex, state=="Alaska")) + coord_flip()
