source('../Data Sets/income.R')


medincome$region = tolower(med$state)
medmalefull = subset(medincome,part.full == 'full' & gender == 'male')
medmalefull$incomeind = '52,000 or more'
medmalefull$incomeind[medmalefull$income < 52000] = '48,0000 - 52,000'
medmalefull$incomeind[medmalefull$income < 48000] = '46,000 - 48,000'
medmalefull$incomeind[medmalefull$income < 46000] = '46,000 or less'

states <- map_data("state")
medplot = merge(medmalefull,states,by='region')

# Plot median income
qplot(long, lat, data=medplot, geom="polygon", order=order, 
      group=group, fill = incomeind)
# Order of state plots
qplot(income, reorder(state, income), 
      data=medmalefull)


