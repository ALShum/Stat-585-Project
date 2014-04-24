source('../Data Sets/health.R')

healthstate = ddply(healthsex, .(state,coverage), summarise,
                       total = sum(freq))
healthstate = ddply(healthstate, .(state), transform,
                       state_total = sum(total))
healthstate$percentage = healthstate$total / healthstate$state_total

healthstate$region = tolower(healthstate$state)
healthno = subset(healthstate, coverage == 'No')
states <- map_data("state")
healthplotstates = merge(healthno,states,by='region')
healthplotstates$percentageind = NULL
healthplotstates$percentageind[healthplotstates$percentage <= .09 ] = '.09  and below'
healthplotstates$percentageind[healthplotstates$percentage > .09 & healthplotstates$percentage <= .12 ] = '.09 - .12' 
healthplotstates$percentageind[healthplotstates$percentage > .12 & healthplotstates$percentage <= .15 ] = '.12 - .15' 
healthplotstates$percentageind[healthplotstates$percentage > .15 & healthplotstates$percentage <= .18 ] = '.15 - .18' 
healthplotstates$percentageind[healthplotstates$percentage > .18 ] = '.18 and above'


healthstateplot = ggplot(healthplotstates, aes(long,lat)) + 
  geom_polygon(aes(long, lat, order=order, fill=percentageind, group=group)) +
  theme_bw() + coord_map() + 
  theme(axis.ticks = element_blank(), 
        axis.text.x = element_blank(), 
        axis.title.x=element_blank(), 
        axis.text.y = element_blank(), 
        axis.title.y=element_blank(), 
        panel.grid = element_blank(), 
        panel.border = element_blank()) +
  ggtitle("Proportion of people without health care") + 
  geom_path(aes(long, lat, order=order, group=group))

# private health care by state and income
privhealth.income = dPlot(x = "state", y = "freq", groups = "income", 
          data = subset(healthincome, coverage=="private"), type = "bar")
privhealth.income$xAxis(orderRule = "state")
privhealth.income$yAxis(type = "addPctAxis")





