Bringing the Census Bureau Data to you
========================================================

Authors: Jim Curro and Alex Shum

Introduction
--------------------
The American Community Survey (ACS) is a yearly demographic survey given to a subset of US households.  There are a few different methods the public can use to access data from the ACS.  One method is using Easystats http://www.census.gov/easystats/ which displays data tables for a few selected categories of variables.  The variables available from http://www.census.gov/easystats/ are a small subset of all available variables from the American Community Survey and the main goal of Easystats is to give a small example of the type of data available using from the American Community Survey that is easy to access.  The main problem with Easystats is that the data is not presented in a tidy format and we feel there are more interesting examples of the type of data available from the ACS.

The Census Bureau also has an online API that allows access to a larger portion of ACS.  Using the 2012 5-year summaries we collected demographic variables we feel were more interesting and formatted them into a tidy format.  We present the data in a shiny app and give some simple graphic summaries of the data and allow the data to be downloaded by the user.  The different demographic variables available include age, sex, median income, food stamps status, healthcare, employment, poverty status, and university enrollment for each state.

Our Shiny app has some simple graphical summaries of our demographic variables using ggplot and rCharts.  The main purpose is simply to show some examples of the type of demographic data available and what can be done with the data as presented.  If the user wants to use the data for analytic purposes then the data is available to download in a tidied format. 

Cleaning
--------------------
Data is accessed from the Census Bureau's online API using the acs package in R.  The ACS dataset from the online API can be accessed for state, county, census tract or other geographic regions.  Our shiny app accesses demographic variables from the ACS by state.  The data from its original form from the ACS is not in a tidy format.   In a tidy format the rows of the dataset are observations and the columns are variables.  The data from the ACS has columns that store categorical information.  The following is a subset of one of the variables available from our shiny app:


```r
library(acs)
```

```
## 
## Attaching package: 'acs'
## 
## The following object is masked from 'package:base':
## 
##     apply
```

```r
states = geo.make(state = "*")
age = acs.fetch(endyear = 2012, span = 5, geography = states, table.number = "B01001", 
    col.names = "pretty")
age.df = data.frame(age@estimate)
head(age.df[, 1:5])
```

```
##            Sex.by.Age..Total. Sex.by.Age..Male.
## Alabama               4777326           2317520
## Alaska                 711139            370127
## Arizona               6410979           3187926
## Arkansas              2916372           1431252
## California           37325068          18561020
## Colorado              5042853           2529614
##            Sex.by.Age..Male..Under.5.years Sex.by.Age..Male..5.to.9.years
## Alabama                             155901                         157239
## Alaska                               27900                          25610
## Arizona                             232450                         226788
## Arkansas                            100520                         101399
## California                         1300557                        1278085
## Colorado                            175053                         177899
##            Sex.by.Age..Male..10.to.14.years
## Alabama                              163024
## Alaska                                26565
## Arizona                              232415
## Arkansas                             100461
## California                          1319653
## Colorado                             169678
```


This dataset is gender by age for each state.  Each state is an observation but gender, a categorical variable, is encoded into the different columns.  In fact, each column stores information about two different categorical variables: age group and gender.  Using the reshape2 and plyr packages, regular expressions and string splits it is possible to bring this dataset into a tidy format:


```r
library(reshape2)
library(plyr)
names(age.df) = gsub("Sex.by.Age..", "", names(age.df))

age.df = age.df[, -c(1, 2, 26)]
age.df$state = rownames(age.df)
rownames(age.df) = NULL

age.df$Male..15.to.19.years = age.df[, 4] + age.df[, 5]
age.df$Female..15.to.19.years = age.df[, 27] + age.df[, 28]

age.df$Male..20.to.24.years = age.df[, 6] + age.df[, 7] + age.df[, 8]
age.df$Female..20.to.24.years = age.df[, 29] + age.df[, 30] + age.df[, 31]

age.df$Male..60.to.64.years = age.df[, 16] + age.df[, 17]
age.df$Female..60.to.64.years = age.df[, 39] + age.df[, 40]

age.df$Male..65.to.69.years = age.df[, 18] + age.df[, 19]
age.df$Female..65.to.69.years = age.df[, 41] + age.df[, 42]

age.df = age.df[, -c(4:8, 16:19, 27:31, 39:42)]

age.melt = melt(age.df, id = "state")
agecols = ldply(strsplit(as.character(age.melt$variable), "\\.\\."))
names(agecols) = c("gender", "age")
agesex = data.frame(state = age.melt$state, gender = agecols$gender, age = agecols$age, 
    freq = age.melt$value)
agesex$age = factor(agesex$age, levels(agesex$age)[c(18, 9, 1:8, 10:17)])
levels(agesex$age) = gsub(".years", "", levels(agesex$age))

head(agesex)
```

```
##        state gender     age    freq
## 1    Alabama   Male Under.5  155901
## 2     Alaska   Male Under.5   27900
## 3    Arizona   Male Under.5  232450
## 4   Arkansas   Male Under.5  100520
## 5 California   Male Under.5 1300557
## 6   Colorado   Male Under.5  175053
```


For this particular dataset we also cleaned up how the age groups are organized.  A similar reshape and cleaning operation was performed on each of the available datasets from our shiny app.  Due to the organizational structure of the datasets it was difficult to completely automate the cleaning process.  Different tables had differing number of variables and were organized slightly differently.  Due to the inconsistent nature of the dataset, it was difficult to completely automate the cleaning and reshaping process and this was done manually.  

The biggest challenge in cleaning and reshaping the datasets were how the column names were formatted.  Recall that categorical variables were often encoded in the column headers.  For example, one of our variables had the following as a column header: "Sex.by.Age.by.Employment.Status.for.the.Population.16.Years.and.over..Female..75.years.and.over..Not.in.labor.force".  This column header has categorical information on gender, age group, and labor force status.  The useful categorical data is separated by ".." and in this example this column header is for women over 75 not in the labor force.  We were able to use a string split on ".." to separate these column headers and parse the useful information.  Due to the fact that each dataset had a differing number of categorical variables and differing number of "..", we had to clean many datasets by hand.

Another difficulty in automating the cleaning process was that occassionally related information would be located in different tables.  For example, one of the variables available from our shiny app looks at food stamp status by race and state.  In fact each race had it's own data table that had to be accessed separately from the online API.

The Census Bureau's online API also gives access to margin of errors but this was not used in our datasets.  It is possible to produce confidence intervals and statistical tests using these margin of errors but our focus was to display the types of data available from the ACS and not to draw any conclusions about demographics. 

The dataset in the final tidy format is what was released to the users who use our shiny application.  We wanted users to be able to look at a few selected interesting variables in a tidy format without deep knowledge of the ACS, programming skills and knowledge of the Census Bureau's online API.

Shiny
--------------------
Our shiny application consists of two main parts: data explorer and graphical summaries.  The data explorer displays the dataset with options to filter by variable and the option to download the dataset as a CSV.  The graphical summaries are examples of what can be done with the tidied dataset. 

The Data Explorer allows users to see the data set in a tidy format and gives them the ability to select the number of rows to display and sort the data using any of the variables.  It also allows users to filter what rows they are looking at based on different categorical variables shown at the bottom of the table.  From this view the user can also download the entire table as a .csv or .tsv allowing them to perform their own analytics on the data set.

The Visualization Summaries view also allows users to view a sample of a few visualizations based on the dataset that they have selected.  The visuals that are displayed are generated using ggplot2 and rCharts.  We used ggplot2 to generate choropleths and rCharts to generate stacked bar charts.  rCharts allows limited user interaction by displaying information when the user hovers their mouse over different segments of the bar chart.  

Shiny allows graphics from many different libraries.  It is possible to use graphics from ggplot2, rCharts, ggvis and animint in Shiny.  We chose to use ggplot2 and rCharts due to the available types of plots and the level of difficulty in implementing the graphics into shiny.  ggvis graphics have interactivity but not as many graphical options as ggplot2 and animint has interactivity and more plotting options but does not have built-in functions to display easily in shiny.

Part of the challenge for building the shiny application was integrating both ggplot2 and rCharts.  It was a bit difficult to integrate the two since they used different functions in shiny to display the plots.  Additionally, we used conditionalPanels to display different plots for different datasets and we discovered that conditionalPanels were buggy.  One strange bug we discovered was that the ordering of conditionalPanels mattered.  We had conditionalPanels that displayed rCharts and conditionalPanels that displayed ggplots.  If our conditionalPanels for rCharts came after the conditionalPanels for ggplots then we had a bug where the conditionalPanels were not evaluating the conditions properly.  However, if we put the conditionalPanels for rCharts before the conditionalPanels for ggplot then the conditions were properly triggered.

Future work
--------------------
There are many different aspects of this project that we wish to expand upon and continue doing work and perhaps present at the data expo.  It would be nice if we keep looking at different tables with acs.lookup to try and eventually come up with a function that can work for any table and produce a tidy dataset.  Most likely that dataset will have certain columns that are not useful and extra rows that correspond to totals.  However, it would be much easier to simply filter those out instead of starting from scratch every time you want to look at a new table.

A lot of the different work that we want to keep developing has to do with shiny.  For example having a better way for users to examine the table of data and get a better feel for what is going on.  Also we want to have more interactive graphics within a particular dataset allowing users to subset on state, gender, age, etc.  and producing plots for each of those.  This will allow users to more easily see differences between certain categorical variables which as of now we can not display from our shiny application.

Work breakdown
--------------------

Jim - Did most of the cleaning in terms of the "easier" datasets to tidy up.  By doing this we mean a few more datasets making tidy, but none of the datasets that had to be merged together by race which took more in depth work.  Also more of the work that went into plots in terms of data manipulation and examining what would be the best visually for shiny.  

Alex - Cleaned up the more in depth datasets that were used writing functions that helped merge tables of similar interest.  Did a lot of implementing the shiny server dealing with a lot of issues in terms of dealing with animint and rcharts in shiny.  Also helped in the graphical displays making sure that the format of graphs were correct and useful for what we wanted to show.

Both - When working on project were typically together in stages figuring out what the next step would be and breaking down what the aim of our project was.  For example what datasets we wanted to use from the ACS, the specific ui of shiny, and what graphics we should display to the user from everything that was made.

