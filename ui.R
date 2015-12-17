library(shiny)


# Define a UI structure
shinyUI(pageWithSidebar(
	
	titlePanel("Quick-calculator for scenario tree prior probability")

	# App title
	headerPanel("This calculator is intented to be used to estimate an uninformative prior probability for disease as used in scenario tree-type models. The estimated uninformative prior probability is uninformative in the sense that it is the prior that forces the scenario tree model to produce the same results as a parallel Bayesian model using a Uniform(0, 1) prior distribution for disease prevalence. \n We note that this calculation should be considered a rough calculation because it is intended to be used to equate the output of a very simple scenario tree with a single herd, in a single year, in which no diagnostic test results were positive for the disease/pathogen in question, and no additional branches in the tree beyond the sensitivity of the diagnostic test used on individuals. This rough calculation should be secondary to a sensitivity analysis of a scenario tree model to the choice of prior probability of disease."),
	
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
		div(class = "span6", plotOutput("priorprob_plot", width = "809px", height = "500px"))
		
		)
	
)) 
