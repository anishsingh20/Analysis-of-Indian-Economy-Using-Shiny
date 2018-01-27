require(shiny)
require(shinydashboard)
require(dplyr)
require(tidyr)
require(highcharter)
require(readr)

#reading the dataset

indiaEco<-read_csv("IndiaEcoData.csv",col_names=TRUE )
attach(indiaEco)

#using tidyr to do some data transformations and tidying

#converting data from wide to long format
#gathering years var into key-value pairs
indiaEcoNew1<-indiaEco %>% gather(4:61,key="year",value="EcoValues")
#years now in a single column

#SUMMARISING DATA
#now grouping data by year and Economic Indicator and finding median values for each
#using median as to find central tendency - because median values are not affected by outliers
#and skewness in data, mean values gets affected by them
indiaEcoNew2<-indiaEcoNew1 %>% group_by(Indicator_Name,year) %>% 
   summarise(median_val = median(EcoValues))

#removing NA values
indiaEcoNew2<-na.omit(indiaEcoNew2)

#writing to a new CSV file
write.csv(indiaEcoNew2,)


