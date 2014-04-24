#B14004
# Sex by College or Graduate School Enrollment 
#by Type of School by Age for the Population 15+ Yrs
library(acs)
library(reshape2)
library(plyr)
library(ggplot2)
states = geo.make(state = "*")

dat = data.frame(acs.fetch(endyear = 2012, span = 5, geography = states, table.number = "B14004", col.names="pretty")@estimate)
names(dat) = gsub("Sex.by.College.or.Graduate.School.Enrollment.by.Type.of.School.by.Age.for.the.Population.15..Yrs..", "", names(dat))
dat$state = rownames(dat)
rownames(dat) = NULL
dat = dat[,-c(1,2,3,8,13,18,19,24,29)]
dat.melt = melt(dat, id = 'state')
dat.split = ldply(strsplit(as.character(dat.melt$variable), "\\.\\."))


univ = data.frame(state = dat$state, 
                  gender = dat.split$V1,
                  school = dat.split$V2,
                  age = dat.split$V3,
                  freq = dat.melt$value)
levels(univ$school) = c("private", "public", "not enrolled")
univ$age = gsub(".years", "", univ$age)
univ$age = as.factor(univ$age)
univtable = univ