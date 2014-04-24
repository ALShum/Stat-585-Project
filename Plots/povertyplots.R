source('../Data Sets/poverty.R')

# Plot percentage below by state on state map
pov = ddply(pov, .(state), transform,
            state_total = sum(freq))
povstate = ddply(pov, .(state,level), summarise,
                 total = sum(freq))
povstate = ddply(povstate, .(state), transform,
                 state_total = sum(total))

# Plot percentage below by state and household
pov = ddply(pov, .(state,household), transform,
            state_total = sum(freq))
povhouse = ddply(pov, .(state, household, level), summarise, 
                 freq = sum(freq))

# Plot percentage below by state and education
pov = ddply(pov, .(state,education), transform,
            state_total = sum(freq))
poved = ddply(pov, .(state, education, level), summarise, 
              freq = sum(freq))

povstate$region = tolower(povstate$state)
povbelow = subset(povstate, level == 'below.poverty.level')
states <- map_data("state")
povplot = merge(povbelow,states,by='region')
povplot$percentage = povplot$total / povplot$state_total
povplot$percentageind = NULL
povplot$percentageind[povplot$percentage > .05 & povplot$percentage <= .07 ] = '.069 and below'
povplot$percentageind[povplot$percentage > .07 & povplot$percentage <= .09 ] = '.07 - .09'
povplot$percentageind[povplot$percentage > .09 & povplot$percentage <= .11 ] = '.09 - .11'
povplot$percentageind[povplot$percentage > .11 & povplot$percentage <= .13 ] = '.11 - .13'
povplot$percentageind[povplot$percentage > .13 ] = '.13 and above'

# Plot pov income
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

#education of people below poverty level
#p = dPlot(x = "state", y = "freq", groups = "education", data = subset(pov, level == "below.poverty.level"), type = "bar")
#p$xAxis(orderRule = "state")
#p$yAxis(type = "addPctAxis")
#p

#education of people above povery level
#p = dPlot(x = "state", y = "freq", groups = "education", data = subset(pov, level == "at.or.above.poverty.level"), type = "bar")
#p$xAxis(orderRule = "state")
#p$yAxis(type = "addPctAxis")
#p