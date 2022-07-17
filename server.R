# load libraries
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(tidyverse)
library(plotly)
library(zoo)

# load and wrangle data
tsla <- read.csv("data/TSLA.csv")
tsla <- tsla %>%
  mutate(Date=as.Date(Date, format="%Y-%m-%d")) %>%
  mutate(mvavg30 = rollmean(x=Close, k=30, aligh="right", fill=NA))

# define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$stockplot <- renderPlotly({
    
    if (input$type == "Candlestick"){
      fig <- tsla %>%
        filter(Date >= input$daterange[1] & Date <= input$daterange[2]) %>%
        plot_ly(type="candlestick", x=~Date, name="TSLA",
                open=~Open, close=~Close, high=~High, low=~Low) %>%
        layout(xaxis=list(rangeslider=list(visible=FALSE)))
    }
    if (input$type == "OHLC"){
      fig <- tsla %>%
        filter(Date >= input$daterange[1] & Date <= input$daterange[2]) %>%
        plot_ly(type="ohlc", x=~Date, name="TSLA",
                open=~Open, close=~Close, high=~High, low=~Low,
                increasing=list(line=list(color=toRGB("darkorange"))),
                decreasing=list(line=list(color=toRGB("dodgerblue2")))) %>%
        layout(xaxis=list(rangeslider=list(visible=FALSE)))
    }
    if (input$type == "Line"){
      fig <- tsla %>%
        filter(Date >= input$daterange[1] & Date <= input$daterange[2]) %>%
        plot_ly(type="scatter", mode="lines",  name="TSLA",
                line=list(color=toRGB("chocolate4"))) %>%
        add_trace(x=~Date, y=~Close, name="TSLA")
    }
    if (input$type == "Area"){
      fig <- tsla %>%
        filter(Date >= input$daterange[1] & Date <= input$daterange[2]) %>%
        plot_ly(type="scatter", mode="lines", fill="tozeroy", name="TSLA", 
                line=list(color=toRGB("darkgoldenrod1")), fillcolor=toRGB("darkgoldenrod1", 0.5)) %>%
        add_trace(x=~Date, y=~Close, name="TSLA")
    }
    fig %>%
      add_lines(x=~Date, y=~mvavg30, name="30-Day Moving Average",
                line=list(color=toRGB("black"), width=0.5)) %>%
      layout(title=paste("TSLA Stocks", input$daterange[1], "to", input$daterange[2]), 
             xaxis=list(type="date"), 
             yaxis=list(title="", autorange=TRUE),
             legend=list(orientation="h", x=0.5, y=1, xanchor="center", bgcolor="transparent"),
             height=600, hovermode="x") %>%
      config(modeBarButtonsToRemove=c("zoom2d", "select2d", "lasso2d"))
  })
  
})
