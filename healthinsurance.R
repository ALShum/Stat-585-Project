#B27001 Health Insurance Coverage Status by Sex by Age
#B27015 Health Insurance Coverage Status and Type by Household Income in the Past 12 Months
#C27001A-H Health Insurance Coverage Status by Age (RACE)

library(acs)
states = geo.make(state = "*")
health = acs.fetch(endyear = 2012, span = 5, geography = states, table.number = "B27001", col.names="pretty")