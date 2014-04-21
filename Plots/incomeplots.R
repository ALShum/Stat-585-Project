source('../Data Sets/income.R')
medincome$region = tolower(med$state)

medmalefull = subset(medincome,part.full == 'full' & gender == 'male')
medfemalefull = subset(medincome,part.full == 'full' & gender == 'female')

#categories for male
medmalefull$incomeind = NULL
medmalefull$incomeind[medmalefull$income > 40000 & medmalefull$income <= 45000 ] = '40,000 - 45,000'
medmalefull$incomeind[medmalefull$income > 45000 & medmalefull$income <= 50000 ] = '45,000 - 50,000'
medmalefull$incomeind[medmalefull$income > 50000 & medmalefull$income <= 55000 ] = '50,000 - 55,000'
medmalefull$incomeind[medmalefull$income > 55000 & medmalefull$income <= 60000 ] = '55,000 - 60,000'
medmalefull$incomeind[medmalefull$income > 60000 ] = '60,000 and above'

#categories for female
medfemalefull$incomeind = NULL
medfemalefull$incomeind[medfemalefull$income > 30000 & medfemalefull$income <= 35000 ] = '30,000 - 35,000'
medfemalefull$incomeind[medfemalefull$income > 35000 & medfemalefull$income <= 40000 ] = '35,000 - 40,000'
medfemalefull$incomeind[medfemalefull$income > 40000 & medfemalefull$income <= 45000 ] = '40,000 - 45,000'
medfemalefull$incomeind[medfemalefull$income > 45000 & medfemalefull$income <= 50000 ] = '45,000 - 50,000'
medfemalefull$incomeind[medfemalefull$income > 50000 ] = '50,000 and above'

states <- map_data("state")
medplot = merge(medmalefull,states,by='region')
med2plot = merge(medfemalefull,states,by='region')

# Plot median income (male)
plot.income.male = ggplot(medplot, aes(long,lat)) + 
  geom_polygon(aes(long, lat, order=order, fill=incomeind, group=group)) +
      theme_bw() + coord_map() + 
      theme(axis.ticks = element_blank(), 
            axis.text.x = element_blank(), 
            axis.title.x=element_blank(), 
            axis.text.y = element_blank(), 
            axis.title.y=element_blank(), 
            panel.grid = element_blank(), 
            panel.border = element_blank()) +
            ggtitle("Full time workers (male)") + 
      geom_path(aes(long, lat, order=order, group=group))

# Plot median income (female)
ggplot(med2plot, aes(long,lat)) + 
  geom_polygon(aes(long, lat, order=order, fill=incomeind, group=group)) +
  theme_bw() + coord_map() + 
  theme(axis.ticks = element_blank(), 
        axis.text.x = element_blank(), 
        axis.title.x=element_blank(), 
        axis.text.y = element_blank(), 
        axis.title.y=element_blank(), 
        panel.grid = element_blank(), 
        panel.border = element_blank()) +
        ggtitle("Full time workers (female)") + 
  geom_path(aes(long, lat, order=order, group=group))

# Order of state plots
qplot(income, reorder(state, income), 
      data=medmalefull)


