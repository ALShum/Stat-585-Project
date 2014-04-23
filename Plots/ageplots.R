source('../Data Sets/age.R')
source('../Data Sets/health.R')

# Add total
agesex = ddply(agesex, .(state), transform,
               state_total = sum(freq))

# Pyramid Plot default (all states)
pop.py = ggplot(data = agesex, aes(x = age, y = freq, fill=gender)) +
  coord_flip() + geom_bar(subset = .(gender=="Female"), stat="identity") +
  geom_bar(subset = .(gender=="Male"), stat="identity", aes(y=-freq))

#rcharts
library(rCharts)
p = dPlot(x = "state", y = "freq", groups = "age", data = healthsex, type = "bar")
p$xAxis(orderRule = "state")
p$yAxis(type = "addPctAxis")
p$addParams(width = 600, height = 300, dom = 'chart1',
             title = "Percentage of age by state")
p
