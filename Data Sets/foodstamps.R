library(acs)
library(ggplot2)
library(plyr)
library(reshape2)
states = geo.make(state = "*")
#B22005(A-H) - Receipt of Food Stamps/SNAP in the Past 12 Months by Race of Householder
#A = white
#B = black
#C = native american
#D = Asian
#E = Islander
#F = Other(single)
#G = Other(multiple)
#H = white(not latino)

get_clean = function(id) {
  dat = data.frame(acs.fetch(endyear = 2012, span = 5, geography = states, table.number = id, col.names="pretty")@estimate)
  
  names(dat) = gsub(".*\\.\\.", "", names(dat))
  dat$states = rownames(dat)
  rownames(dat) = NULL
  
  return(dat)
}

get_pct = function(df, race) {
  toReturn = data.frame(state = df$state,
                        snap = df$SNAP/df$total)
  names(toReturn) = c("state", race)
  return(toReturn)
}

combine_tables = function(df1, df2, operation) {
  toReturn = data.frame(total = operation(df1$total, df2$total), 
                        SNAP = operation(df1$SNAP, df2$SNAP),
                        no = operation(df1$no, df2$no),
                        state = df1$state)
  return(toReturn)
}

#get and clean the tables
a = get_clean("B22005A")
b = get_clean("B22005B")
c = get_clean("B22005C")
d = get_clean("B22005D")
e = get_clean("B22005E")
f = get_clean("B22005F")
g = get_clean("B22005G")
h = get_clean("B22005H") #white
names(a) = c("total", "SNAP", "no", "state")
names(b) = c("total", "SNAP", "no", "state")
names(c) = c("total", "SNAP", "no", "state")
names(d) = c("total", "SNAP", "no", "state")
names(e) = c("total", "SNAP", "no", "state")
names(f) = c("total", "SNAP", "no", "state")
names(g) = c("total", "SNAP", "no", "state")
names(h) = c("total", "SNAP", "no", "state")

#combine tables to make more useful
white = h
white$race = "white"
latino = combine_tables(a, h, `-`)
latino$race = "latino"
black = b
black$race = "black"
indian_pacific = combine_tables(c, e, `+`)
indian_pacific$race = "indian/pacific"
asian = d
asian$race = "asian"
other = combine_tables(f, g, `+`)
other$race = "other"

total = combine_tables(white, black, `+`)
total = combine_tables(total, latino, `+`)
total = combine_tables(total, indian_pacific, `+`)
total = combine_tables(total, asian, `+`)
total = combine_tables(total, other, `+`)

total_pct = get_pct(total, 'total')

food = rbind(white, latino, black, indian_pacific, asian, other)
food.melt = melt(food[,-1], id = c("state", "race"))
names(food.melt)[c(3,4)] = c("foodstamps", "freq")
levels(food.melt) = c("yes", "no")

foodtable = food.melt
