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

# define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$stockplot <- renderPlotly({
    
    if (input$type == "Candlestick"){
      fig <- tsla %>%
        filter(Date >= input$daterange[1] & Date <= input$daterange[2]) %>%
        plot_ly(type="candlestick", x=~Date,
                open=~Open, close=~Close, high=~High, low=~Low) %>%
        layout(xaxis=list(rangeslider=list(visible=FALSE), type="date"), 
               yaxis=list(autorange=TRUE))
    }
    if (input$type == "OHLC"){
      fig <- tsla %>%
        filter(Date >= input$daterange[1] & Date <= input$daterange[2]) %>%
        plot_ly(type="ohlc", x=~Date,
                open=~Open, close=~Close, high=~High, low=~Low,
                increasing=list(line=list(color=toRGB("darkorange"))),
                decreasing=list(line=list(color=toRGB("dodgerblue2")))) %>%
        layout(xaxis=list(rangeslider=list(visible=FALSE), type="date"), 
               yaxis=list(autorange=TRUE))
    }
    if (input$type == "Line"){
      fig <- tsla %>%
        filter(Date >= input$daterange[1] & Date <= input$daterange[2]) %>%
        plot_ly(type="scatter", mode="lines", line=list(color=toRGB("chocolate4"))) %>%
        add_trace(x=~Date, y=~Close, name="TSLA") %>%
        layout(showlegend=FALSE, 
               xaxis=list(type="date"), 
               yaxis=list(title="", autorange=TRUE))
    }
    if (input$type == "Area"){
      fig <- tsla %>%
        filter(Date >= input$daterange[1] & Date <= input$daterange[2]) %>%
        plot_ly(type="scatter", mode="lines", fill="tozeroy", 
                line=list(color=toRGB("darkgoldenrod1")), fillcolor=toRGB("darkgoldenrod1", 0.5)) %>%
        add_trace(x=~Date, y=~Close, name="TSLA") %>%
        layout(showlegend=FALSE, 
               xaxis=list(type="date"), 
               yaxis=list(title="", autorange=TRUE))
    }
    fig %>%
      layout(title=paste("TSLA Stocks", input$daterange[1], "to", input$daterange[2]), 
             height=600, hovermode="x") %>%
      config(modeBarButtonsToRemove=c("zoom2d", "select2d", "lasso2d"))
  })
  
})
