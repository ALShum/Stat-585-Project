library(acs)
library(ggplot2)
library(reshape2)
library(plyr)


#B23001 - Sex by Age by Employment Status for the Population 16 Years and over

states = geo.make(state = "*")
employ = acs.fetch(endyear = 2012, span = 5, geography = states, 
                   table.number = "B23001", col.names="pretty")
employ.df = data.frame(employ@estimate)
names(employ.df) = gsub("Sex.by.Age.by.Employment.Status.for.the.Population.16.Years.and.over..", "", names(employ.df))
employ.df = employ.df[,-c(1,2,88)]
employ.df = employ.df[,grep('employed|forces',names(employ.df),ignore.case=T)]
names(employ.df) = gsub("Civilian..", "", names(employ.df))
employ.df$state = rownames(employ.df)
rownames(employ.df) = NULL
employ.melt = melt(employ.df, id='state')
employcols = ldply(strsplit(as.character(employ.melt$variable), "\\.\\."))
emp = data.frame(state = employ.melt$state, gender = employcols$V1, 
                        age = employcols$V2, type = employcols$V4, freq = employ.melt$value)
