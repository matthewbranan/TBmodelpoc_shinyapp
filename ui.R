library(shiny)
library(rjags)
library(coda)


# Define a UI structure
shinyUI(fluidPage(

	# App title
	headerPanel("TB model proof of concept"),
	
	fluidRow(
		column(4,
			# Panel label
			helpText("Testing data inputs"),
	
			# Input for the sample size
			numericInput("n", "Sample size:", value = 100),
		
			# Input for the number of positive subjects observed
			numericInput("x", "Number of positive subjects:", value = 10)
			),
		
		column(4, 
	
			# Panel label
			helpText("Hyperparameter inputs"),
	
			# Input for hyperparameters for sensitivity
			numericInput("alpha_eta", "alpha_eta:", value = 10),  # expression(alpha[eta])
			numericInput("beta_eta", "beta_eta:", value = 1),  # expression(beta[eta])
		
			# Input for hyperparameters for specificity
			numericInput("alpha_theta", "alpha_theta:", value = 10),
			numericInput("beta_theta", "beta_theta:", value = 1),
		
			# Input for hyperparameters for prevalence
			numericInput("alpha_pi", "alpha_pi:", value = 1),
			numericInput("beta_pi", "beta_pi:", value = 1)
			),
			
		column(4,
			# Panel label
			helpText("Technical and MCMC inputs"),
		
			# Input for the numebr of burnin iterations and number of iterations to keep
			numericInput("burnin", "Burnin iterations:", value = 100),
			numericInput("MCMCreps", "MCMC iterations:", value = 1000),
			numericInput("thinterval", "Thinning interval:", value = 1),
			numericInput("digits", "Number of display digits:", value = 4),
			# sliderInput("digits", "Number of display digits:", min = 1, max = 16, value = 4),
			actionButton("fitModel", "Fit model")
		
			)
			
		),
		
	mainPanel(
		# Set up panels for various types of output
		tabsetPanel(
			# Create table for HPD intervals
			tabPanel("95% HPD intervals", tableOutput("summary_hpdout")),
			# Create table for summary statistics
			tabPanel("Summary statistics", tableOutput("summary_sumstat"))
			)
			
		)
		
	
)) 
