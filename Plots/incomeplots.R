source('../Data Sets/income.R')


med$region = tolower(med$state)
states <- map_data("state")
medplot = merge(med,states,by='region')

# Plot median income
qplot(long, lat, data=medplot, geom="polygon", order=order, 
      group=group, fill = male_full)
qplot(long, lat, data=medplot, geom="polygon", order=order, 
      group=group, fill = female_full)

# Order of state plots
qplot(male_full, reorder(state, male_full), data=med)
qplot(female_full, reorder(state, female_full), data=med)


