source('../Data Sets/foodstamps.R')

foodtablestate = ddply(foodtable, .(state,foodstamps), summarise,
                       total = sum(freq))
foodtablestate = ddply(foodtablestate, .(state), transform,
                       state_total = sum(total))
foodtablestate$percentage = foodtablestate$total / foodtablestate$state_total

foodtablestate$region = tolower(foodtablestate$state)
foodstampsyes = subset(foodtablestate, foodstamps == 'yes')
states <- map_data("state")
foodplotstates = merge(foodstampsyes,states,by='region')
foodplotstates$percentageind = NULL
foodplotstates$percentageind[foodplotstates$percentage <= .08 ] = '.08  and below'
foodplotstates$percentageind[foodplotstates$percentage > .08 & foodplotstates$percentage <= .10 ] = '.08 - .10'
foodplotstates$percentageind[foodplotstates$percentage > .10 & foodplotstates$percentage <= .12 ] = '.10 - .12'
foodplotstates$percentageind[foodplotstates$percentage > .12 & foodplotstates$percentage <= .14 ] = '.12 - .14'
foodplotstates$percentageind[foodplotstates$percentage > .14 ] = '.14 and above'


stampstateplot = ggplot(foodplotstates, aes(long,lat)) + 
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





