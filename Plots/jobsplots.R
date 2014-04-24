source('../Data Sets/jobs.R')

empstate = ddply(emp, .(state,type), summarise,
                    total = sum(freq))
empstate = ddply(empstate, .(state), transform,
                    state_total = sum(total))
empstate$percentage = empstate$total / empstate$state_total

empstate$region = tolower(empstate$state)
empunemp = subset(empstate, type == 'Unemployed')
states <- map_data("state")
empplotstates = merge(empunemp,states,by='region')
empplotstates$percentageind = NULL
empplotstates$percentageind[empplotstates$percentage <= .06 ] = '.06  and below'
empplotstates$percentageind[empplotstates$percentage > .06 & empplotstates$percentage <= .08 ] = '.06 - .08' 
empplotstates$percentageind[empplotstates$percentage > .08 & empplotstates$percentage <= .10 ] = '.08 - .10' 
empplotstates$percentageind[empplotstates$percentage > .10 ] = '.10 and above'


empstateplot = ggplot(empplotstates, aes(long,lat)) + 
  geom_polygon(aes(long, lat, order=order, fill=percentageind, group=group)) +
  theme_bw() + coord_map() + 
  theme(axis.ticks = element_blank(), 
        axis.text.x = element_blank(), 
        axis.title.x=element_blank(), 
        axis.text.y = element_blank(), 
        axis.title.y=element_blank(), 
        panel.grid = element_blank(), 
        panel.border = element_blank()) +
  ggtitle("Proportion of people unemployed") + 
  geom_path(aes(long, lat, order=order, group=group))


library(rCharts)
state.age.unemployed = dPlot(x = "state", y = "freq", groups = "age", data = subset(emp, type=="Unemployed"), type = "bar")
state.age.unemployed$xAxis(orderRule = "state")
state.age.unemployed$yAxis(type = "addPctAxis")
state.age.unemployed

type.age = dPlot(x = "type", y = "freq", groups = "age", data = emp, type = "bar")
type.age$xAxis(orderRule = "type")
type.age$yAxis(type = "addPctAxis")
type.age



