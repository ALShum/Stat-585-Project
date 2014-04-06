

http://api.census.gov/data/2012/acs5/variables.json
B19326 - Median Income by Sex by Work Experience for the Population 15+ Years
B23001 - Sex by Age by Employment Status for the Population 16 Years and over
B01001 -
B22005(A-H) - Receipt of Food Stamps/SNAP in the Past 12 Months by Race of Householder
C23002(A-H) - Sex by Age by Employment Status for the Population 16 Years and Over
B14007(A-H) - School Enrollment by Level of School for the Population 3 Years and Over
B17001(A-H) - POVERTY STATUS IN THE PAST 12 MONTHS BY SEX BY AGE


library(acs)
library(ggplot2)
library(maps)
api.key.install('609eebac690b6ae9b3c957ce623a3a7affafc8ea')
states = geo.make(state = "*")



search_terms = acs.lookup(endyear = 2012, span = 5, dataset = "acs", table.name="median income", case.sensitive = F)
search_terms@results[33:39,]
median = acs.fetch(endyear = 2012, span = 5, geography = states, table.number = "B19326", col.names="pretty")

median.df = data.frame(median@estimate)
names(median.df) = gsub("Median.Income.by.Sex.by.Work.Experience.for.the.Population.15..Years..Median.income.in.the.past.12.months..in.2012.inflation.adjusted.dollars.....", "", names(median.df))
names(median.df) = c('total','male_total','male_full','male_other',
                     'female_total','female_full','female_other')
median.df$state = factor(rownames(median.df))
rownames(median.df) = NULL
qplot(total, reorder(state, total), data=median.df)
qplot(male_full, reorder(state, male_full), data=median.df)
qplot(female_full, reorder(state, female_full), data=median.df)

search_terms = acs.lookup(endyear = 2012, span = 5, dataset = "acs", table.name="age", case.sensitive = F)
search_terms = acs.lookup(endyear = 2012, span = 5, dataset = "acs", table.name="college", case.sensitive = F)

#B23001 - Sex by Age by Employment Status for the Population 16 Years and over
employ = acs.fetch(endyear = 2012, span = 5, geography = states, table.number = "B23001", col.names="pretty")
employ.df = data.frame(employ@estimate)
names(employ.df) = gsub("Sex.by.Age.by.Employment.Status.for.the.Population.16.Years.and.over..", "", names(employ.df))

#age
age = acs.fetch(endyear = 2012, span = 5, geography = states, table.number = "B01001", col.names="pretty")
age.df = data.frame(age@estimate)
names(age.df) = gsub("Sex.by.Age..", "", names(age.df))
age.df = age.df[,-c(1,2,26)]
age.df$state = rownames(age.df)
rownames(age.df) = NULL
age.melt = melt(age.df, id='state')


cols = ldply(strsplit(as.character(age.melt$variable), "\\.\\."))
names(cols) = c("gender", "age")
age.df2 = data.frame(state = age.melt$state, gender = cols$gender, age = cols$age, freq = age.melt$value)
age.df2$age = factor(age.df2$age, levels(age.df2$age)[c(23, 12, 1:11, 13:22)])


qplot(age, freq, data=subset(age.df2, state=="Alaska")) + coord_flip()






