#B14004
# Sex by College or Graduate School Enrollment 
#by Type of School by Age for the Population 15+ Yrs
library(acs)
library(reshape2)
library(plyr)
library(ggplot2)
states = geo.make(state = "*")

get_pct = function(df) {
  toReturn = data.frame(state = df$state,
                        public = (df[,3] + df[,19])/
                                  (df[,3] + df[,8] + 
                                     df[,19] + df[,24]))
  names(toReturn) = c("state", "public")
  return(toReturn)
}

dat = data.frame(acs.fetch(endyear = 2012, span = 5, geography = states, table.number = "B14004", col.names="pretty")@estimate)
names(dat) = gsub("Sex.by.College.or.Graduate.School.Enrollment.by.Type.of.School.by.Age.for.the.Population.15..Yrs..", "", names(dat))
dat$state = rownames(dat)
rownames(dat) = NULL
univ.orig = dat
dat = dat[,-c(1,2,3,8,13,18,19,24,29)]
dat.melt = melt(dat, id = 'state')
dat.split = ldply(strsplit(as.character(dat.melt$variable), "\\.\\."))
#univ.orig = dataframe unmelted#

univ = data.frame(state = dat$state, 
                  gender = dat.split$V1,
                  school = dat.split$V2,
                  age = dat.split$V3,
                  freq = dat.melt$value)
levels(univ$school) = c("private", "public", "not enrolled")
univ$age = gsub(".years", "", univ$age)
univ$age = as.factor(univ$age)

# Plot percentage below by state on state map
univ = ddply(univ, .(state), transform,
            state_total = sum(freq))
univstate = ddply(univ, .(state,school), summarise,
                 total = sum(freq),
                 state_total = state_total)

# Plot percentage below by state and gender
univ = ddply(univ, .(state,gender), transform,
            state_total = sum(freq))
univgender = ddply(univ, .(state, gender, school), summarise, 
                 freq = sum(freq),
                 state_total = state_total)

# Plot percentage below by state and age
univ = ddply(univ, .(state,age), transform,
            state_total = sum(freq))
univage = ddply(univ, .(state, age, school), summarise, 
              freq = sum(freq),
              state_total = state_total)







