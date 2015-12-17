library(shiny)


# Define a UI structure
shinyUI(pageWithSidebar(

	# App title
	headerPanel("Temptitle"),
	
	sidebarPanel(
		numericInput("obs", 
			"Number of Observations:",
			value = 500)
		),
		
	mainPanel(
		plotOutput("distPlot")
		)
	
	 
))
