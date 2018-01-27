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
indiaEcoNew<-indiaEco %>% gather(key="year",value="EcoValues",4:61)

#years now in a single column