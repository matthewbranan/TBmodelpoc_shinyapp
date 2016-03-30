library(shiny)
library(rjags)
library(coda)


# Define a UI structure
shinyUI(pageWithSidebar(

	# App title
	headerPanel("Quick-calculator for scenario tree prior probability"),
	
	sidebarPanel(
	
		# Include input for the sample size
		numericInput("n", "Sample size:", value = 100),
		
		# Include input for the number of positive subjects observed
		numericInput("x", "Number of positive subjects:", value = 10),
		
		# Include input for hyperparameters for sensitivity
		numericInput("alpha_eta", "alpha_eta", value = 10)  # expression(alpha[eta])
		numericInput("beta_eta", "beta_eta", value = 1)  # expression(beta[eta])
		
		# Include input for hyperparameters for specificity
		numericInput("alpha_theta", "alpha_theta", value = 10)
		numericInput("beta_theta", "beta_theta", value = 1)
		
		),
		
	mainPanel(
	
	# Give an explanation of the application and some caveats
	p("Explanation"),
	
	em("Notes"),
	
	br(),
	
	h2("95% HPD intervals: "),
		
		# Create table for HPD intervals
		tableOutput("summary_hpdout")

		)
	
)) 
