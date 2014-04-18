source('../Data Sets/foodstamps.R')

qplot(total, reorder(state, total), data=total_pct)


#rcharts
library(rCharts)
total.melt = melt(total, id = 'state')
#food stamp by state
p = dPlot(x = "state", y = "value", groups = "variable", data = subset(total.melt, variable != "total"), type = "bar")
p$xAxis(orderRule = "state")
p$yAxis(type = "addPctAxis")
p

#food stamp broken down by race
final = rbind(white, latino, black, indian_pacific, asian, other)
final.melt = melt(final, id=c('state', 'race'))
p = dPlot(x = "state", y = "SNAP", groups = "race", data = final, type = "bar")
p$xAxis(orderRule = "state")
p$yAxis(type = "addPctAxis")
p


#same as above, flipped axis

final.melt = melt(food, id=c('state', 'race'))
p = dPlot(x = "SNAP", y = "state", groups = "race", data = final, type = "bar")
p$xAxis(type = "addPctAxis")
p$yAxis(type = "addCategoryAxis", orderRule = "state")
p
