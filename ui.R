library(shiny)
library(rjags)
library(coda)
library(ggplot2)
library(epiR)

# Define a UI structure
shinyUI(fluidPage(

	# App title
	headerPanel("TB model proof of concept"),
	
		# Some explanation and a note about prior elicitation
		p("This is a proof of concept for the TB model under construction. This particular application implements a simple beta-binomial Bayesian model that takes the number of subjects sampled and tested, the number that tested positive, the prior (beta) distributions for the sensitivity and specificity of the diagnostic test used and the prevalence, along with some more technical inputs such as the number of MCMC iterations and burnin."),

		br(),
		
		em("Notice, the user can choose to input the hyperparameters for the prior distributions for sensitivity and specificity by simply supplying the two shape parameters (alpha and beta) directly or they can choose to input the mode and 5th percentil of the sensitivity and specificity and let BetaBuster choose the appropriate parameters from that information."),
	
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
				numericInput("alpha_eta", "Sensitivity alpha parameter:", value = 10),  # expression(alpha[eta])
				numericInput("beta_eta", "Sensitivity beta parameter:", value = 1)  # expression(beta[eta])
				),
				
			conditionalPanel(condition = "input.select_etatheta == 'betabuster'",
				numericInput("eta_mode", "Sensitivity Mode (most likely value):", value = 0.5),
				numericInput("eta_5thperc", "Sensitivity 5th percentile (value above which sensitivity occurs 95% of the time):", value = 0.25)
				),
				
			# Input for hyperparameters for specificity
			conditionalPanel(condition = "input.select_etatheta == 'straightbeta'",
				numericInput("alpha_theta", "Specificity alpha arameter:", value = 10),
				numericInput("beta_theta", "Specificity beta parameter:", value = 1)
				),
			
			conditionalPanel(condition = "input.select_etatheta == 'betabuster'",
				numericInput("theta_mode", "Specificity Mode (most likely value):", value = 0.5),
				numericInput("theta_5thperc", "Specificity 5th percentile (value above which specificity occurs 95% of the time):", value = 0.265)
				),
		
			# Input for hyperparameters for prevalence
			numericInput("alpha_pi", "Prevalence alpha parameter:", value = 1),
			numericInput("beta_pi", "Prevalence beta parameter:", value = 1)
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
			tabPanel("95% HPD intervals", dataTableOutput("summary_hpdout")),
			# Summary statistics
			tabPanel("Summary statistics", dataTableOutput("summary_sumstatout")),
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
