require(shinydashboard)

require(dplyr)
require(tidyr)
require(highcharter)
require(readr)

#UI of the application

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



#creating a dashboard

#choosing only unique values
indicators<-unique( indiaEcoNew2[,1] )


#macro-economic indicators data frame

macroEcodf<-indiaEcoNew2 %>% filter(str_detect(Indicator_Name, 'Inflation|gross domestic| savings | investment | income |employment |supply|
                                    demand| payments | inport && exports ')) 

#unqiue indicators name data frame for select input
macroEcodfUnique<-unique(macroEcodf[,1])


dashboardPage(
  
  skin="purple",
  
  
  #dashboard header
  dashboardHeader(title="Indian Economy"),
  
  #dashboard sidebar
  dashboardSidebar(
    sidebarMenu(
    menuItem("Main Menu", tabName = "dashboard",icon=icon("dashboard")) ,
    menuItem("Macroeconomic Aggregates", tabName = "macro")
    )
  ) ,
  
  #dashboard body
  dashboardBody(
    
    #adding custom-css
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    
  tabItems(  
    
    tabItem(tabName = "dashboard",
            
            h2("Time Series Analysis of Indian Economy",align="center",style="margin-top:-5px;"),

            br(),
            
            
            fluidRow(
              
              column(12, 
                     
                     box(
                       
                       selectInput("indicator",label="Select Economic Indicator",
                         choices=indicators[,1]), 
                     width=12
                     )  #end box1
                     
              ), #end  col1
              
              column(12,
                     
                     #box for plotting the time series plot
                     box(highchartOutput("chart"),width="12")
                     
             ),#end column 2
             
             br(),
             
             hr(),
             
             h2("About the Economic Indicator",align="center") ,
             
             br(),
             
             
             column(12,
                    box(
                    textOutput("about")  ,
                    br(),
                    
                    h4("Source Organization"),
                    textOutput("source"),
                    
                    width=12
                    )#end box3
                    
                  )# end col3
             
            )#end row
            
            
           ) ,# end tab
    
    
    #tab-2 Major macroeconomic aggregates
    tabItem(tabName = "macro",
            
            h2("Major macroeconomic aggragates of India",align="center"),
            br(),
            p("Macroeconomics is a branch of the economics that mainly studies how the aggregate economy behaves. 
                In macroeconomics, a variety of economy-wide phenomena is thoroughly examined such as, inflation, price levels, rate of growth, national income, 
                gross domestic product and changes in unemployment,supply and demands, National Savings and Investements etc."),
            br(),
            
            box(
            selectInput("macro",label="Select macro-economic indicator",
                        choices=macroEcodfUnique) , width=12
            
            ) #end select box
            
            
            
            
          )#end tabItem 2
                       
        ) #end tab-items
  
  
    ) #end dashboard body
  
  
)#end dashboard page