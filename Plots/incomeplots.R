source('../Data Sets/income.R')
medincome$region = tolower(med$state)

medmalefull = subset(medincome,part.full == 'full' & gender == 'male')
medfemalefull = subset(medincome,part.full == 'full' & gender == 'female')
medmalefull$incomeind = NULL
medmalefull$incomeind[medmalefull$income > 40000 & medmalefull$income <= 45000 ] = '40,000 - 45,000'
medmalefull$incomeind[medmalefull$income > 45000 & medmalefull$income <= 50000 ] = '45,000 - 50,000'
medmalefull$incomeind[medmalefull$income > 50000 & medmalefull$income <= 55000 ] = '50,000 - 55,000'
medmalefull$incomeind[medmalefull$income > 55000 & medmalefull$income <= 60000 ] = '55,000 - 60,000'
medmalefull$incomeind[medmalefull$income > 60000 ] = '60,000 and above'

states <- map_data("state")
medplot = merge(medmalefull,states,by='region')

# Plot median income
ggplot(medplot, aes(long,lat)) + 
  geom_polygon(aes(long, lat, order=order, fill=incomeind, group=group)) +
      theme_bw() + coord_map() + 
      theme(axis.ticks = element_blank(), 
            axis.text.x = element_blank(), 
            axis.title.x=element_blank(), 
            axis.text.y = element_blank(), 
            axis.title.y=element_blank(), 
            panel.grid = element_blank(), 
            panel.border = element_blank()) +
      geom_path(aes(long, lat, order=order, group=group))


# Order of state plots
qplot(income, reorder(state, income), 
      data=medmalefull)


