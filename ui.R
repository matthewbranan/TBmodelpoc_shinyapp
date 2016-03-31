library(shiny)
library(rjags)
library(coda)
library(ggplot2)
library(epiR)

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
			helpText("Hyperparameter inputs for prior parameters"),
	
			# Input for hyperparameters for sensitivity
			selectInput("select_etatheta", "Method for eliciting prior distributions for sensitivity and specificity:", 
				list("Specify alpha and beta hyperparameters manually" = "straightbeta",
					"Specify prior distirbutions using mode and 5th percentile (using BetaBuster)" = "betabuster")
				),
			
			conditionalPanel(condition = "input.select_etatheta == 'straightbeta'",
				numericInput("alpha_eta", "alpha_eta:", value = 10),  # expression(alpha[eta])
				numericInput("beta_eta", "beta_eta:", value = 1)  # expression(beta[eta])
				),
				
			conditionalPanel(condition = "input.select_etatheta == 'betabuster'",
				numericInput("eta_mode", "Mode (most likely value):", value = 0.5),
				numericInput("eta_5thperc", "5th percentile (value above which sensitivity occurs 95% of the time):", value = 0.25)
				),
				
			# Input for hyperparameters for specificity
			conditionalPanel(condition = "input.select_etatheta == 'straightbeta'",
				numericInput("alpha_theta", "alpha_theta:", value = 10),
				numericInput("beta_theta", "beta_theta:", value = 1)
				),
			
			conditionalPanel(condition = "input.select_etatheta == 'betabuster'",
				numericInput("theta_mode", "Mode (most likely value):", value = 0.5),
				numericInput("theta_5thperc", "5th percentile (value above which specificity occurs 95% of the time):", value = 0.265)
				),
		
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
			sliderInput("digits", "Number of display digits:", min = 1, max = 16, value = 4),
			# sliderInput("digits", "Number of display digits:", min = 1, max = 16, value = 4),
			actionButton("fitModel", "Fit model")
		
			)
			
		),
		
	mainPanel(
		# Set up panels for various types of output
		tabsetPanel(
			# HPD intervals
			tabPanel("95% HPD intervals", tableOutput("summary_hpdout")),
			# Summary statistics
			tabPanel("Summary statistics", tableOutput("summary_sumstatout")),
			# Diagnostic plots
			tabPanel("Trace plots", 
				plotOutput("traceplot_eta"), br(), 
				plotOutput("traceplot_theta"), br(), 
				plotOutput("traceplot_pi")),
			tabPanel("Density plots",
				plotOutput("densplot_eta"), br(),
				plotOutput("densplot_theta"), br(),
				plotOutput("densplot_pi"))
			)
			
		)
		
	
)) 
