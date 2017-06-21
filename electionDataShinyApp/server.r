#Load the package
library(shiny)

#Load our dataset
Elec <- read.csv("FairfaxCountyElectionData2016.csv", header=TRUE)

#This subset cuts off ABSENTEE & PROVISIONAL rows. Only includes number of
#votes for every party. 
newElec <- Elec[1:243, c(18, 22, 26, 30, 34)]

#Rename NUMVOTES1, 2, 3, etc, to the party. 
colnames(newElec)[1:5] <- c("Democrat","Republican","Libertarian","Green","Independent")

# Define a server for the Shiny app
shinyServer(function(input, output) {
  newdata=reactive({newElec[sample(nrow(newElec),input$size),]})
  # Fill in the spot we created for a plot
  output$percentagesPlot <- renderPlot({
    
    # Render a barplot
    barplot(c(Elec$PERCVOTE1[Elec$NAME==input$prec], Elec$PERCVOTE2[Elec$NAME==input$prec], 
              Elec$PERCVOTE3[Elec$NAME==input$prec], Elec$PERCVOTE4[Elec$NAME==input$prec], 
              Elec$PERCVOTE5[Elec$NAME==input$prec]), col=c("blue", "red", "yellow", "green", "purple"), 
            names.arg=c("Democrat","Republican", "Libertarian", "Green Party", "Independent"),
            ylab="Percentage of Votes", xlab="Political Party", 
            main=paste("Breakdown of percentages of votes for each party in ", input$prec))
    
  })
  
  output$scatter= renderPlot({
    
    ggplot(data=newdata(),aes_string(input$x,input$y),environment=environment())+geom_point()+
      geom_smooth(method=lm)},width=reactive({input$width}),
    height=reactive({input$height}))
  
})