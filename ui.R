library(shiny)
library(ggbiplot)
library(shinythemes)
library(shinydashboard)
library(tibble)
library(dplyr)
library(highcharter)
library(DT)
library(lubridate)
library(tidyr)
library(shinyWidgets)
#library(tychobratools)  
library(openxlsx)

dashboardPage(

  #-----------------------------dashboardHeader----------------------
  dashboardHeader(title = "Fb Comments Volume Analysis "),
  #-----------------------------dashboardSidebar-------------------------------------
dashboardSidebar(
    sidebarMenu(
      menuItem("Data view", tabName = "dataview", icon = icon("eye")),
      menuItem("Page Information", tabName = "datamodel", icon = icon("info"), 
               badgeLabel = "new", badgeColor = "olive"),
      menuItem("Week", tabName = "dataweek" , icon = icon("calendar-alt"), 
               badgeLabel = "hot", badgeColor = "red"),
      menuItem("Correlation", tabName = "dataarticle", icon = icon("folder")),
      menuItem("Github", icon = icon("file-code-o"), 
               href = "https://github.com/1072-datascience/finalproject-1072ds_group5") 
     
      )
  ),

#--------------------------------dashboardBody----------------------------------
dashboardBody(
  tabItems(
#------------------------------------
tabItem(
  tabName = "dataview",
# infoBoxes with fill=FALSE
fluidRow(
  # A static infoBox
  infoBox("Instances", 40949, icon = icon("credit-card")),
  # Dynamic infoBoxes
  infoBoxOutput("progressBox"),
  infoBoxOutput("approvalBox")
),

navbarPage(
  title = 'Fb Data Options',
  tabPanel(DT::dataTableOutput('ex1')) )
    ),
    #------------------model------------------    
    tabItem(
      tabName = "datamodel",
      # Boxes need to be put in a row (or column)
      pageWithSidebar(
        
        # Application title
        headerPanel("Data Summary 粉專資訊"),
        
        # Sidebar with controls to select the random distribution type
        # and number of observations to generate. Note the use of the br()
        # element to introduce extra vertical spacing
    
        box( title = "粉專資訊", width = NULL, solidHeader = TRUE, status = "primary",
          radioButtons("variable", "Variable:",
                       list("讚數" = 'likes',
                            "打卡次數" = "Checkins",
                            "按讚留言＋分享" = 'talking_about',
                            "粉專類型" = "Category"))
        ),
        # Show a tabset that includes a plot, summary, and table view
        # of the generated distribution
        
        fluidRow(
          tabBox( title = tagList(shiny::icon("gear"), "Plot"),side = "left", height = "100px",width = NULL,
                  selected = "Histogram",
            tabPanel("Histogram",  width = NULL, plotOutput("histogram")), 
            tabPanel("Summary", verbatimTextOutput("summary")),
            tabPanel("Boxplot", plotOutput("boxplot")),
            tabPanel("Bar graph", plotOutput("bar"))
          )
        )
      )
      
    ),
  #------------------week------------------      
    tabItem(
      tabName = "dataweek",
      
      # Boxes need to be put in a row (or column)
      fluidPage(
        # Application title
        titlePanel("First 24hours comments"),
        
        # Sidebar with a slider input for number of bins 
        sidebarLayout(
          box( title = "no_of_comments_first_24", width = NULL, status = "primary",plotOutput("histgram", height = "500px")),
          fluidRow(
            shiny::column(4, offset = 4,
                          sliderInput("num", "Weekday",
                                      min = 1, max = 7,
                                      value = 1 , animate = TRUE)))
        )
      )
    ),
  
  #----------------------
  tabItem(
    tabName = "dataarticle",
    
    fluidPage(
      
      # Application title
      titlePanel("Publish Weekday as Category Correlation of FB Dataset"),
      
      # Sidebar with a slider input for number of bins 
      sidebarLayout(
        box( title = "Correlation", width = NULL, status = "primary",plotOutput("corr", height = "600px")),
        fluidRow(
          shiny::column(4, offset = 4,
                        sliderInput("num", "Weekday",
                                    min = 1, max = 7,
                                    value = 1 , animate = TRUE)))
        )
      )
    )
  )
  

    
    ),

#------------------------------------------------------------------
skin = "blue"
)
