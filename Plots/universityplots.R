source('../Data Sets/university.R')

univpp = subset(univ, school != 'not enrolled')
univstate = ddply(univpp, .(state,school), summarise,
                  total = sum(freq))
univstate = ddply(univstate, .(state), transform,
                  state_total = sum(total))
univstate$percentage = univstate$total / univstate$state_total
univstate$region = tolower(univstate$state)
univstateprivate = subset(univstate, school == 'private')
states <- map_data("state")
univprivateplot = merge(univstateprivate,states,by='region')
univprivateplot$percentageind = NULL
univprivateplot$percentageind[univprivateplot$percentage <= .15 ] = '.15  and below'
univprivateplot$percentageind[univprivateplot$percentage > .15 & univprivateplot$percentage <= .20 ] = '.15 - .20'
univprivateplot$percentageind[univprivateplot$percentage > .20 & univprivateplot$percentage <= .25 ] = '.20 - .25'
univprivateplot$percentageind[univprivateplot$percentage > .25 & univprivateplot$percentage <= .30 ] = '.25 - .30'
univprivateplot$percentageind[univprivateplot$percentage > .30 & univprivateplot$percentage <= .40 ] = '.30 - .40'
univprivateplot$percentageind[univprivateplot$percentage > .40 ] = '.40 and above'


univprivplot = ggplot(univprivateplot, aes(long,lat)) + 
  geom_polygon(aes(long, lat, order=order, fill=percentageind, group=group)) +
  theme_bw() + coord_map() + 
  theme(axis.ticks = element_blank(), 
        axis.text.x = element_blank(), 
        axis.title.x=element_blank(), 
        axis.text.y = element_blank(), 
        axis.title.y=element_blank(), 
        panel.grid = element_blank(), 
        panel.border = element_blank()) +
  geom_path(aes(long, lat, order=order, group=group))

