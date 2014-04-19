library(acs)
library(ggplot2)
library(reshape2)
library(plyr)
library(maps)

#api.key.install('f68ba33043f9a8cd289bf4e910b52e1332e8e96a')

#B19326 - Median Income by Sex by Work Experience for the Population 15+ Years
states = geo.make(state = "*")
median = acs.fetch(endyear = 2012, span = 5, geography = states, 
                   table.number = "B19326", col.names="pretty")
med = data.frame(median@estimate)
names(med) = gsub("Median.Income.by.Sex.by.Work.Experience.for.the.Population.15..Years..Median.income.in.the.past.12.months..in.2012.inflation.adjusted.dollars.....", "", names(med))
names(med) = c('total','male_total','male_full','male_other',
                     'female_total','female_full','female_other')
med$state = factor(rownames(med))
rownames(med) = NULL
med = med[,c(3:4,6:8)]
med.melt = subset(melt(med, id='state'))
medcols = ldply(strsplit(as.character(med.melt$variable), "_"))
medincome = data.frame(state = med.melt$state, gender = medcols$V1, 
                       part.full = medcols$V2, income = med.melt$value)

medincometable = medincome


