require(shiny)
require(shinydashboard)

require(dplyr)
require(tidyr)
require(highcharter)

#UI of the application




#creating a dashboard

dashboardPage(
  
  skin="blue",
  
  
  #dashboard header
  dashboardHeader(title="Analysis of India's Economy"),
  
  #dashboard sidebar
  dashboardSidebar(
    menuItem("Menu", tabName = "Menu", icon = icon("globe"))
  ) ,
  
  #dashboard body
  dashboardBody(
    
    tabItem(tabName = "Menu", p("hello I am Anish"))
  )
  
  
)#end dashboard page