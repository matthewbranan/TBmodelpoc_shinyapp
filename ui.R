library(shiny)
library(rjags)
library(coda)


# Define a UI structure
shinyUI(pageWithSidebar(

	# App title
	headerPanel("TB model proof of concept"),
	
	sidebarPanel(
		# Labels for panel
		p("Testing data inputs"),
	
		# Input for the sample size
		numericInput("n", "Sample size:", value = 100),
		
		# Input for the number of positive subjects observed
		numericInput("x", "Number of positive subjects:", value = 10),
		
		# Input for hyperparameters for sensitivity
		numericInput("alpha_eta", "alpha_eta:", value = 10),  # expression(alpha[eta])
		numericInput("beta_eta", "beta_eta:", value = 1),  # expression(beta[eta])
		
		# Input for hyperparameters for specificity
		numericInput("alpha_theta", "alpha_theta:", value = 10),
		numericInput("beta_theta", "beta_theta:", value = 1),
		
		# Input for hyperparameters for prevalence
		numericInput("alpha_pi", "alpha_pi:", value = 1),
		numericInput("beta_pi", "beta_pi:", value = 1),
		
		# Input for the numebr of burnin iterations and number of iterations to keep
		numericInput("burnin", "Burnin iterations:", value = 100),
		numericInput("MCMCreps", "MCMC iterations:", value = 1000),
		numericInput("thinterval", "Thinning interval:", value = 1)
		
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
