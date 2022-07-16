# load libraries
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(tidyverse)
library(plotly)

# load and wrangle data
tsla <- read.csv("./data/TSLA.csv")
tsla <- tsla %>%
  mutate(Date=as.Date(Date, format="%Y-%m-%d"))

# define UI
shinyUI(fluidPage(
  theme=shinytheme("flatly"),
  
  navbarPage(
    "Tesla Stocks (TSLA) 2010-2020",
    
    tabPanel(
      "Stock Plots",
      
      # sidebar with plot type and date range inputs
      sidebarLayout(
        sidebarPanel(
          pickerInput(
            "type", "Select the type of plot to view:",
            choices=c("Candlestick", "OHLC", "Line", "Area"),
            selected=c("Candlestick")
          ),
          sliderInput(
            "daterange", "Select the date range:",
            min=min(tsla$Date), max=max(tsla$Date),
            value=c(min(tsla$Date), max(tsla$Date))
          )
        ),
    
        # main panel of chosen plot
        mainPanel(
          plotlyOutput("stockplot")
        )
      )
    ),
    
    tabPanel(
      "About this app",
      
      tags$div(
        tags$h4("How to use this app"),
        "You can select two different inputs on the 'Stock Plots' tab of this app: 
        a plot type and a date range. The plot type can be selected using the dropdown 
        menu, while the beginning and end dates can be chosen using the slider right 
        below. Changing either of the inputs will automatically be reflected in the
        plot on the right side of the page.",
        tags$br(), tags$br(),
        
        tags$h4("Data description"),
        "The data used in this app was obtained from the 'Tesla stock data from 2010 to 2020'
        dataset on Kaggle by Timo Bozsolik. It can be found at the following",
        tags$a(href="https://www.kaggle.com/datasets/timoboz/tesla-stock-data-from-2010-to-2020",
               "link."),
        tags$br(), tags$br(),
        
        tags$h4("Code"),
        "Code used to generate this Shiny site can be found on",
        tags$a(href="http://www.github.com/katiejchai/teslastocks_app", "Github.")
      )
    )
  )
))
