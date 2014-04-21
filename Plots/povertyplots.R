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
                 freq = sum(freq),
                 state_total = state_total)

# Plot percentage below by state and education
pov = ddply(pov, .(state,education), transform,
            state_total = sum(freq))
poved = ddply(pov, .(state, education, level), summarise, 
              freq = sum(freq),
              state_total = state_total)

povstate$region = tolower(povstate$state)
povbelow = subset(povstate, level == 'below.poverty.level')
states <- map_data("state")
povplot = merge(povbelow,states,by='region')
povplot$percentage = povplot$total / povplot$state_total



# Plot percentage below poverty line
qplot(long, lat, data=povplot, geom="polygon", order=order, 
      group=group, fill = total/state_total)







p = dPlot(x = "state", y = "freq", groups = "education", data = pov, type = "bar")
p$xAxis(orderRule = "state")
p$yAxis(type = "addPctAxis")
p

p = dPlot(x = "state", y = "freq", groups = "household", data = pov, type = "bar")
p$xAxis(orderRule = "state")
p$yAxis(type = "addPctAxis")
p

