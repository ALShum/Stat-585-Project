source('../Data Sets/health.R')

# Plot percentage insured by state on state map
healthsex = ddply(healthsex, .(state), transform,
                  state_total = sum(freq))
healthstate = ddply(healthsex, .(state,coverage), summarise,
                    total = sum(freq))

# Plot percentage insured by state and age
healthsex = ddply(healthsex, .(state,age), transform,
                  state_total = sum(freq))
healthage = ddply(healthsex, .(state, age, coverage), summarise, 
                  freq = sum(freq))

# Plot percentage insured by state and income
healthincome = ddply(healthincome, .(state,income), transform,
                     state_total = sum(freq))

qplot(freq/state_total, reorder(state, state_total), 
      data=healthage, colour = age,  facets = ~coverage)


#rcharts
library(rCharts)
p = dPlot(x = "state", y = "freq", groups = "age", data = subset(healthsex, coverage=="No"), type = "bar")
p$xAxis(orderRule = "state")
p$yAxis(type = "addPctAxis")
p

#rcharts
library(rCharts)
p = dPlot(x = "state", y = "freq", groups = "income", data = subset(healthincome, coverage=="private"), type = "bar")
p$xAxis(orderRule = "state")
p$yAxis(type = "addPctAxis")
p




