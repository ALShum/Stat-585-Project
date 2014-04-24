source('../Data Sets/poverty.R')

# Plot percentage below by state on state map
pov = ddply(pov, .(state), transform,
            state_total = sum(freq))
povstate = ddply(pov, .(state,level), summarise,
                 total = sum(freq))
povstate = ddply(povstate, .(state), transform,
                 state_total = sum(total))

povstate$region = tolower(povstate$state)
povbelow = subset(povstate, level == 'below.poverty.level')
states <- map_data("state")
povplot = merge(povbelow,states,by='region')
povplot$percentage = povplot$total / povplot$state_total
povplot$percentageind = NULL
povplot$percentageind[povplot$percentage > .05 & povplot$percentage <= .07 ] = '.07  and below'
povplot$percentageind[povplot$percentage > .07 & povplot$percentage <= .09 ] = '.07 - .09'
povplot$percentageind[povplot$percentage > .09 & povplot$percentage <= .11 ] = '.09 - .11'
povplot$percentageind[povplot$percentage > .11 & povplot$percentage <= .13 ] = '.11 - .13'
povplot$percentageind[povplot$percentage > .13 ] = '.13 and above'

# Plot pov by state
povstateplot = ggplot(povplot, aes(long,lat)) + 
  geom_polygon(aes(long, lat, order=order, fill=percentageind, group=group)) +
  theme_bw() + coord_map() + 
  theme(axis.ticks = element_blank(), 
        axis.text.x = element_blank(), 
        axis.title.x=element_blank(), 
        axis.text.y = element_blank(), 
        axis.title.y=element_blank(), 
        panel.grid = element_blank(), 
        panel.border = element_blank()) +
  ggtitle("Percentage of people below the poverty line") + 
  geom_path(aes(long, lat, order=order, group=group))

## below poverty level by state and education
povstateedu = dPlot(x = "state", y = "freq", groups = "education", data = subset(pov, level == "below.poverty.level"), type = "bar")
povstateedu$xAxis(orderRule = "state")
povstateedu$yAxis(type = "addPctAxis")


## Totals by state and education
povstateedutotal = dPlot(x = "state", y = "freq", groups = "education", data = pov, type = "bar")
povstateedutotal$xAxis(orderRule = "state")
povstateedutotal$yAxis(type = "addPctAxis")




