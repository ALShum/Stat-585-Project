library(acs)
library(ggplot2)
library(reshape2)
library(plyr)

#B17018
#POVERTY STATUS IN THE PAST 12 MONTHS OF FAMILIES BY 
#HOUSEHOLD TYPE BY EDUCATIONAL ATTAINMENT OF HOUSEHOLDER

states = geo.make(state = "*")
poverty = acs.fetch(endyear = 2012, span = 5, geography = states, 
                   table.number = "B17018", col.names="pretty")
poverty.df = data.frame(poverty@estimate)
names(poverty.df) = gsub("POVERTY.STATUS.IN.THE.PAST.12.MONTHS.OF.FAMILIES.BY.HOUSEHOLD.TYPE.BY.EDUCATIONAL.ATTAINMENT.OF.HOUSEHOLDER..Income.in.the.past.12.months.", "", names(poverty.df))
names(poverty.df) = gsub("..Other.families", "", names(poverty.df))
names(poverty.df) = gsub("..no.wife.present|..no.husband.present", "", names(poverty.df))
names(poverty.df) = gsub("..includes.equivalency.|..Some.college|.s.", "", names(poverty.df))

poverty.df = poverty.df[,c(4:7,10:13,15:18,21:24,27:30,32:35)]
poverty.df$state = rownames(poverty.df)
rownames(poverty.df) = NULL

poverty.melt = melt(poverty.df, id='state')
povertycols = ldply(strsplit(as.character(poverty.melt$variable), "\\.\\."))

pov = data.frame(state = poverty.melt$state, level = povertycols$V1, 
                    household = povertycols$V2, education = povertycols$V3, freq = poverty.melt$value)

