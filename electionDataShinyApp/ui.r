#Load our package for the shiny app.
library(shiny)

#Load the dataset.
Elec <- read.csv("FairfaxCountyElectionData2016.csv", header=TRUE)

#Getting all the precincts in alphabetical order, cutting off ABSENTEE & PROVISIONAL.
precincts <- sort(Elec$NAME[1:243])

#Getting our subset ready for the scatterplot matrix.
Elec2 <- data.frame(Elec)

#Chopping off ABSENTEE & PROVISIONAL rows because their numbers are distorting.
#Concatenating NUMVOTES1, NUMVOTES2, etc, for all 5 parties.
newElec <- Elec2[1:243, c(18, 22, 26, 30, 34)]

#Renaming some stuff
colnames(newElec)[1:5] <- c("Democrat","Republican","Libertarian","Green","Independent")

#Making an object to be used in the scatterplot matrix later.
Variables <- names(newElec)

# Define the overall UI
shinyUI(
  
  # Use a fluid Bootstrap layout
  fluidPage(    
    
    # Give the page a title
    titlePanel("Voting data for precincts in Fairfax County, Virginia."),
    
    sidebarLayout(      
      
      sidebarPanel(
        helpText("You can choose which precinct's results to view by selecting it 
                 from the drop down menu. Names have been alphabetized."),
        inputPanel(
          
          selectInput("prec", label="Percentage of votes for each party by precinct", 
                      choices=precincts)

        ),
        
        #Adding some breaks so it looks nicer.
        br(), 
        br(), 
        br(), 
        br(), 
        br(), 
        br(), 
        br(), 
        br(), 
        br(), 
        br(),
        
        helpText("For the following, you can observe samples of total numbers of votes for
                 a party by precinct to see how they compare. There are 243 precincts
                 excluding Absentee and Provisional ballots. Select a sample size and
                 the parties."),
        
        inputPanel(
          
          sliderInput("size","Sample Size", min=1,max=nrow(newElec),step=1,value=100),
          
          sliderInput("width", "Graph Width", min=500, max=1000, step=50, value=750),
          
          sliderInput("height", "Graph Height", min=500, max=1000, step=50, value=750),
          
          selectInput("x", Variables, label = h3("Select a party for the X axis.")),
          
          selectInput("y", Variables, label = h3("Select a party for the Y axis."))
          
        ),
        hr()
      ),
      
      # Create a spot for the barplot
      mainPanel(
        plotOutput("percentagesPlot"),  
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        plotOutput("scatter")
      )
    )
  )
)
