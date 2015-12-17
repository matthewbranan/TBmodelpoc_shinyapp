library(shiny)


# Define a UI structure
shinyUI(pageWithSidebar(

	# App title
	headerPanel("Temptitle"),
	
	sidebarPanel(
		sliderInput("obs", 
			"Number of Observations:",
			min = 1,
			max = 1000,
			value = 500)
		),
		
	mainPanel(
		plotOutput("distPlot")
		)
	
	 
))
