source('../Data Sets/income.R')


# Make new datasets
emp = ddply(emp, .(state), transform,
            state_total = sum(freq))
empage = ddply(emp, .(state, age, type), summarise, 
               freq = sum(freq),
               state_total = state_total)
empgender = ddply(emp, .(state, gender, type), summarise, 
                  freq = sum(freq),
                  state_total = state_total)

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

library(rCharts)
p = dPlot(x = "state", y = "freq", groups = "gender", data = subset(emp, type=="Unemployed"), type = "bar")
p$xAxis(orderRule = "state")
p$yAxis(type = "addPctAxis")
p

p = dPlot(x = "state", y = "freq", groups = "age", data = subset(emp, type=="Employed"), type = "bar")
p$xAxis(orderRule = "state")
p$yAxis(type = "addPctAxis")
p



