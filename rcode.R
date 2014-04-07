library(acs)
library(ggplot2)
library(reshape2)
library(plyr)
states = geo.make(state = "*")
#api.key.install('f68ba33043f9a8cd289bf4e910b52e1332e8e96a')

#http://api.census.gov/data/2012/acs5/variables.json
#B19326 - Median Income by Sex by Work Experience for the Population 15+ Years
#B23001 - Sex by Age by Employment Status for the Population 16 Years and over
#B01001 - 
#B22005(A-H) - Receipt of Food Stamps/SNAP in the Past 12 Months by Race of Householder

#TODO
#B14004 Sex by College or Graduate School Enrollment by Type of School by Age for the Population 15+ Yrs
#B17001(A-H) - POVERTY STATUS IN THE PAST 12 MONTHS BY SEX BY AGE

#optional
#C23002(A-H) - Sex by Age by Employment Status for the Population 16 Years and Over (race)
search_terms = acs.lookup(endyear = 2012, span = 5, dataset = "acs", 
                          table.name="college", case.sensitive = F)
search_terms@results[,c(3)]

#B19326
median = acs.fetch(endyear = 2012, span = 5, geography = states, 
                   table.number = "B19326", col.names="pretty")
median.df = data.frame(median@estimate)
names(median.df) = gsub("Median.Income.by.Sex.by.Work.Experience.for.the.Population.15..Years..Median.income.in.the.past.12.months..in.2012.inflation.adjusted.dollars.....", "", names(median.df))
names(median.df) = c('total','male_total','male_full','male_other',
                        'female_total','female_full','female_other')
median.df$state = factor(rownames(median.df))
rownames(median.df) = NULL
qplot(total, reorder(state, total), data=median.df)
qplot(male_full, reorder(state, male_full), data=median.df)
qplot(female_full, reorder(state, female_full), data=median.df)

search_terms = acs.lookup(endyear = 2012, span = 5, dataset = "acs", 
                          table.name="age", case.sensitive = F)
search_terms = acs.lookup(endyear = 2012, span = 5, dataset = "acs", 
                          table.name="college", case.sensitive = F)


#B23001 - Sex by Age by Employment Status for the Population 16 Years and over
employ = acs.fetch(endyear = 2012, span = 5, geography = states, 
                   table.number = "B23001", col.names="pretty")
employ.df = data.frame(employ@estimate)
names(employ.df) = gsub("Sex.by.Age.by.Employment.Status.for.the.Population.16.Years.and.over..", "", names(employ.df))
employ.df = employ.df[,-c(1,2,88)]
employ.df = employ.df[,grep('employed|forces',names(employ.df),ignore.case=T)]
names(employ.df) = gsub("Civilian..", "", names(employ.df))
employ.df$state = rownames(employ.df)
rownames(employ.df) = NULL
employ.melt = melt(employ.df, id='state')
employcols = ldply(strsplit(as.character(employ.melt$variable), "\\.\\."))
employ.df2 = data.frame(state = employ.melt$state, gender = employcols$V1, 
                     age = employcols$V2, type = employcols$V4, freq = employ.melt$value)


#B01001
age = acs.fetch(endyear = 2012, span = 5, geography = states, 
                table.number = "B01001", col.names="pretty")
age.df = data.frame(age@estimate)
names(age.df) = gsub("Sex.by.Age..", "", names(age.df))
age.df = age.df[,-c(1,2,26)]
age.df$state = rownames(age.df)
rownames(age.df) = NULL
age.melt = melt(age.df, id='state')
agecols = ldply(strsplit(as.character(age.melt$variable), "\\.\\."))
names(agecols) = c("gender", "age")
age.df2 = data.frame(state = age.melt$state, gender = agecols$gender, 
                     age = agecols$age, freq = age.melt$value)
age.df2$age = factor(age.df2$age, levels(age.df2$age)[c(23, 12, 1:11, 13:22)])


qplot(age, freq, data=subset(age.df2, state=="Alaska")) + coord_flip()














