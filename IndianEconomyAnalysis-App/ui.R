require(shiny)
require(shinydashboard)

require(dplyr)
require(tidyr)
require(highcharter)

#UI of the application

indiaEco<-read_csv("../IndiaEcoData.csv",col_names=TRUE )
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



#creating a dashboard

indicators<-unique( indiaEcoNew2[1:100,1] )


dashboardPage(
  
  skin="blue",
  
  
  #dashboard header
  dashboardHeader(title="Indian Economy"),
  
  #dashboard sidebar
  dashboardSidebar(
    menuItem("Menu", tabName = "Menu", icon = icon("globe"))
  ) ,
  
  #dashboard body
  dashboardBody(
    
    tabItem(tabName = "Menu",
            
            fluidRow(
              
              column(12, 
                     
                     box(
                       selectInput("indicator",label="Select Economic indicator",
                         choices=indicators,size=10,selectize = F), 
                     width=12
                     )  #end box1
                     
              ), #end  col1
              
              column(12,
                     
                     #box for plotting the time series plot
                     box(highchartOutput("hchart"),width="12")
                     
             )#end column 2
            )#end row
           )# end tab
                       
                        
    ) #end dashboard body
  
  
)#end dashboard page