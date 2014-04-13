#C27001A-H Health Insurance Coverage Status by Age (RACE)

library(acs)
library(ggplot2)
library(reshape2)
library(plyr)
library(dplyr)

#B27001 Health Insurance Coverage Status by Sex by Age
states = geo.make(state = "*")
health = acs.fetch(endyear = 2012, span = 5, geography = states, table.number = "B27001", col.names="pretty")
health.df = data.frame(health@estimate)
names(health.df) = gsub("Health.Insurance.Coverage.Status.by.Sex.by.Age..", "", names(health.df))
names(health.df) = gsub(".health.insurance.coverage", "", names(health.df))
health.df = health.df[,-c(1,2,30)]
health.df = health.df[,-seq(1,52,3)]
health.df$state = rownames(health.df)
rownames(health.df) = NULL
health.melt = melt(health.df, id='state')
healthcols = ldply(strsplit(as.character(health.melt$variable), "\\.\\."))
healthsex = data.frame(state = health.melt$state, gender = healthcols$V1, 
                 age = healthcols$V2, coverage = healthcols$V3, freq = health.melt$value)
healthsex$age = factor(healthsex$age, levels(healthsex$age)[c(9,6,1:5,7,8)])

#B27015 Health Insurance Coverage Status and Type by Household Income in the Past 12 Months
states = geo.make(state = "*")
health = acs.fetch(endyear = 2012, span = 5, geography = states, table.number = "B27015", col.names="pretty")
health.df = data.frame(health@estimate)
names(health.df) = gsub("Health.Insurance.Coverage.Status.and.Type.by.Household.Income.in.the.Past.12.Months..", "", names(health.df))
names(health.df) = gsub("health.insurance.|.health.insurance|.coverage|coverage.|With.", "", names(health.df))
names(health.df) = gsub("Under..", "Under.", names(health.df))
names(health.df) = gsub("to..", "to.", names(health.df))
health.df = health.df[,-c(1,seq(2,22,5),seq(3,23,5))]
health.df$state = rownames(health.df)
rownames(health.df) = NULL
health.melt = melt(health.df, id='state')
healthcols = ldply(strsplit(as.character(health.melt$variable), "\\.\\."))
healthincome = data.frame(state = health.melt$state, income = healthcols$V1, 
                       coverage = healthcols$V2, freq = health.melt$value)
healthincome$income = factor(healthincome$income, levels(healthincome$income)[c(5,2:4,1)])


# Plot percentage insured by state
healthsex = ddply(healthsex, .(state), transform,
                  state_total = sum(freq))
healthstate = ddply(healthsex, .(state,coverage), summarise,
                    total = sum(freq),
                    state_total = state_total)

# Plot percentage insured by state and age
healthsex = ddply(healthsex, .(state,age), transform,
                  state_total = sum(freq))
healthage = ddply(healthsex, .(state, age, coverage), summarise, 
                        freq = sum(freq),
                        state_total = state_total)

# Plot percentage insured by state and income
healthincome = ddply(healthincome, .(state,income), transform,
                  state_total = sum(freq))

qplot(freq/state_total, reorder(state, state_total), 
      data=healthage, colour = age,  facets = ~coverage)





