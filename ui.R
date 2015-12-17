library(shiny)


# Define a UI structure
shinyUI(pageWithSidebar(

	# App title
	headerPanel("Quick-calculator for scenario tree prior probability"),
	
	sidebarPanel(
		# Include input for the (design) sample size
		numericInput("n", "Sample size:", value = 30),
		
		# Include input for the desing prevalence
		numericInput("dp", "Design prevalence:", value = 0.02),
		
		# Would like to give user some contorl over the (x-axis) plotting window
		numericInput("minplot", "Minimum sample size in plot:", value = 1),
		
		numericInput("maxplot", "Maximum sample size in plot:", value = 100)
		
		),
		
	mainPanel(
		# Output the estimated uninformed prior probability
		verbatimTextOutput("text"),
		
		# Plot the results just like in the paper, keeping the plotting window at a standard size
		div(class = "span6", plotOutput("priorprob_plot", width = "500px", height = "809px"))
		
		)
	
)) 
