require(shinydashboard)
require(dplyr)
require(tidyr)
require(highcharter)
require(readr)

#reading the dataset

indiaEco<-read_csv("IndiaEcoData.csv",col_names=TRUE )

#metadata file
Metadata<-read_csv("Metadata_Indicator_API_IND_DS2_en_csv_v2.csv")

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


server<-function(input,output) 
{
  output$chart <- renderHighchart ({
      
    #creating a data frame of the selected user input indicator
    df<-indiaEcoNew2 %>% filter(Indicator_Name==input$indicator)  
    #querying the selected input from the database
     
    
    #making a time series chart
    hchart(df, "line",color="#6800b3",hcaes(x=year,y=median_val),name="Median Value:") %>% 
      hc_exporting(enabled = TRUE) %>% 
      hc_tooltip(crosshairs = TRUE, backgroundColor = "#FCFFC5",
                 shared = TRUE, borderWidth = 2) %>%
      hc_title(text="Time series plot",align="center") %>%
      hc_subtitle(text="Data Source: World Bank",align="center") %>%
      hc_add_theme(hc_theme_elementary()) 
    
    
    
    
    })
  
  
  #to print the description of each eco indicato
  output$about<-renderText({
    
    #making a df of descriptions of selected input box
    text<-filter(Metadata,INDICATOR_NAME==input$indicator)
    
    print(text$SOURCE_NOTE)
    
  })
    
  
  output$source<-renderText({
    
    source<-filter(Metadata,INDICATOR_NAME==input$indicator)
    
    print(source$SOURCE_ORGANIZATION)
    
  })
    
    
    
    
  
  
  
}

