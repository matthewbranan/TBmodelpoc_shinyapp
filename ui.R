library(shiny)


# Define a UI structure
shinyUI(pageWithSidebar(

	# App title
	headerPanel("Temptitle"),
	
	sidebarPanel(
		numericInput("n", "Sample size:", value = 30),
		
		numericInput("dp", "Design prevalence:", value = 0.02)
		
		),
		
	mainPanel(
		plotOutput("priorprob_plot")
		)
	
))
