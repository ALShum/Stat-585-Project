library(acs)
library(ggplot2)
library(reshape2)
library(plyr)
library(dplyr)
library(stringr)
library(rCharts)

#B23001 - Sex by Age by Employment Status for the Population 16 Years and over
# age bracket 0-15, *16-24*, *25-34*, 35-44, 45-54, *55-64*, *65-74*, 75*
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

employ.df$Male..16.to.24.years..In.labor.force..In.Armed.Forces = 
  employ.df[,1] + employ.df[,4] + employ.df[,7]
employ.df$Male..16.to.24.years..In.labor.force..Employed = 
  employ.df[,2] + employ.df[,5] + employ.df[,8]
employ.df$Male..16.to.24.years..In.labor.force..Unemployed = 
  employ.df[,3] + employ.df[,6] + employ.df[,9]
employ.df$Female..16.to.24.years..In.labor.force..In.Armed.Forces = 
  employ.df[,37] + employ.df[,40] + employ.df[,43]
employ.df$Female..16.to.24.years..In.labor.force..Employed = 
  employ.df[,38] + employ.df[,41] + employ.df[,44]
employ.df$Female..16.to.24.years..In.labor.force..Unemployed = 
  employ.df[,39] + employ.df[,42] + employ.df[,45]

employ.df$Male..25.to.34.years..In.labor.force..In.Armed.Forces = 
  employ.df[,10] + employ.df[,13] 
employ.df$Male..25.to.34.years..In.labor.force..Employed = 
  employ.df[,11] + employ.df[,14] 
employ.df$Male..25.to.34.years..In.labor.force..Unemployed = 
  employ.df[,12] + employ.df[,15] 
employ.df$Female..25.to.34.years..In.labor.force..In.Armed.Forces = 
  employ.df[,46] + employ.df[,49] 
employ.df$Female..25.to.34.years..In.labor.force..Employed = 
  employ.df[,47] + employ.df[,50] 
employ.df$Female..25.to.34.years..In.labor.force..Unemployed = 
  employ.df[,48] + employ.df[,51] 

employ.df$Male..55.to.64.years..In.labor.force..In.Armed.Forces = 
  employ.df[,22] + employ.df[,25] + employ.df[,28]
employ.df$Male..55.to.64.years..In.labor.force..Employed = 
  employ.df[,23] + employ.df[,26] + employ.df[,29]
employ.df$Male..55.to.64.years..In.labor.force..Unemployed = 
  employ.df[,24] + employ.df[,27] + employ.df[,30]
employ.df$Male..55.to.64.years..In.labor.force..In.Armed.Forces = 
  employ.df[,58] + employ.df[,61] + employ.df[,64]
employ.df$Male..55.to.64.years..In.labor.force..Employed = 
  employ.df[,59] + employ.df[,62] + employ.df[,65]
employ.df$Male..55.to.64.years..In.labor.force..Unemployed = 
  employ.df[,60] + employ.df[,63] + employ.df[,66]


employ.df$Male..65.to.74.years..In.labor.force..Employed = 
  employ.df[,31] + employ.df[,33] 
employ.df$Male..65.to.74.years..In.labor.force..Unemployed = 
  employ.df[,32] + employ.df[,34] 
employ.df$Female..65.to.74.years..In.labor.force..Employed = 
  employ.df[,67] + employ.df[,69] 
employ.df$Female..65.to.74.years..In.labor.force..Unemployed = 
  employ.df[,68] + employ.df[,70] 

employ.df = employ.df[,-c(1:15, 22:34, 37:51, 58:70)]

employ.melt = melt(employ.df, id='state')
employcols = ldply(strsplit(as.character(employ.melt$variable), "\\.\\."))
emp = data.frame(state = employ.melt$state, gender = employcols$V1, 
                        age = employcols$V2, type = employcols$V4, freq = employ.melt$value)
emp$age = factor(emp$age)
levels(emp$age) = gsub(".years", "", levels(emp$age))




# Add total
emp = ddply(emp, .(state), transform,
               state_total = sum(freq))
empgender = ddply(emp, .(state, age, type), summarise, 
      freq = sum(freq),
      state_total = state_total)
empage = ddply(emp, .(state, gender, type), summarise, 
               freq = sum(freq),
               state_total = sum(freq))

# Filter by type ignore gender
qplot(freq/state_total, reorder(state, state_total), 
      data=subset(empgender, type == 'Employed'), colour = age)

# Filter by type ignore age
qplot(freq/state_total, reorder(state, state_total), 
      data=subset(empage, type == 'Employed'), colour = gender)

# Filter by type facet by gender
qplot(freq/state_total, reorder(state, state_total), 
      data=subset(emp, type == 'Employed'), 
      colour = age, facets = ~gender)

# Filter by type facet by age
qplot(freq/state_total, reorder(state, state_total), 
      data=subset(emp, type == 'Employed'), 
      colour = gender, facets = ~age)

#write.csv(emp,'emptotal.csv')






