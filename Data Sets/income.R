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
med$region = tolower(med$state)
head(med)
states <- map_data("state")
head(states)
medplot = merge(med,states,by='region')

# Plot median income
qplot(long, lat, data=medplot, geom="polygon", order=order, 
      group=group, fill = male_full)
qplot(long, lat, data=medplot, geom="polygon", order=order, 
      group=group, fill = female_full)

# Order of state plots
qplot(male_full, reorder(state, male_full), data=med)
qplot(female_full, reorder(state, female_full), data=med)

