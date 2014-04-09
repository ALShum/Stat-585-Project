Project Progress
========================================================

There were 8 main datasets that we are using to visualize in shiny.  Each of the datasets has to be pulled from the census bureau API using the acs package and cleaned.  Given the different ways the data was displayed after grabbing each of the individual tables using the acs package we broke each of the cleaning of the different datasets into individual R scripts.  Overall we are looking at economic, education, age and other demographic variables.

Our Demographic variables:
* Age and sex for each state.
* College attendence broken down by age, gender and state.
* Health insurance enrollment by age and gender.

Our Economic variables:
* Employment status by gender, age and state.
* Povery level by education level, family status and state.
* SNAP/food stamp by race and state.
* Median income by gender, work experience and state.
* Median monthly rent by state.

We have all of the tables pulled from the ACS online API and have largely cleaned these tables into a usuable format.  We are in the stage of choosing plots to display this data.  For most of the variables we will use choropleths and ranking plots.  For our plot of age and gender we have constructed a population pyramid for states.  Below is a population pyramid for the state of Washington.

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1.png) 


Here is an example of a ranking plot for median income for males who work full time.

![plot of chunk 2](figure/2.png) 

