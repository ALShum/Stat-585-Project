source('../Data Sets/university.R')


# Plot percentage below by state on state map
univ = ddply(univ, .(state), transform,
             state_total = sum(freq))
univstate = ddply(univ, .(state,school), summarise,
                  total = sum(freq),
                  state_total = state_total)

# Plot percentage below by state and gender
univ = ddply(univ, .(state,gender), transform,
             state_total = sum(freq))
univgender = ddply(univ, .(state, gender, school), summarise, 
                   freq = sum(freq),
                   state_total = state_total)

# Plot percentage below by state and age
univ = ddply(univ, .(state,age), transform,
             state_total = sum(freq))
univage = ddply(univ, .(state, age, school), summarise, 
                freq = sum(freq),
                state_total = state_total)

#rcharts
library(rCharts)

p = dPlot(x = "state", y = "freq", groups = "school", data = subset(univ, age=="18.to.24"), type = "bar")
p$xAxis(orderRule = "state")
p$yAxis(type = "addPctAxis")
p



