source('../Data Sets/income.R')


# Make new datasets
emp = ddply(emp, .(state), transform,
            state_total = sum(freq))
empage = ddply(emp, .(state, age, type), summarise, 
               freq = sum(freq),
               state_total = state_total)
empgender = ddply(emp, .(state, gender, type), summarise, 
                  freq = sum(freq),
                  state_total = state_total)

# Filter by type ignore gender
qplot(freq/state_total, reorder(state, state_total), 
      data=subset(empgender, type == 'Employed'), colour = age)

# Filter by type ignore age
qplot(freq/state_total, reorder(state, state_total), 
      data=subset(empage, type == 'Employed'), colour = gender)

# Filter by type facet by gender
qplot(freq/state_total, reorder(state, state_total), 
      data=subset(emp, type == 'Employed'), 
      colour = age, facets = ~gender)

# Filter by type facet by age
qplot(freq/state_total, reorder(state, state_total), 
      data=subset(emp, type == 'Employed'), 
      colour = gender, facets = ~age)

#write.csv(emp,'emptotal.csv')

