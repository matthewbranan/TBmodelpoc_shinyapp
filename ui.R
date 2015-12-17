library(shiny)


# Define a UI structure
shinyUI(pageWithSidebar(

	# App title
	headerPanel("Quick-Calculator for Scenario Tree Prior Probability"),
	
	sidebarPanel(
		# Choose sample size
		numericInput("n", "Sample Size:", 30), # Have the user select the sample size. Be careful, no error checking for, possibly infinite or at least, very large sample s	

		# Choose design prevalence
		numericInput("dp", "Design Prevalence:", 0.05),

		# Go Button
		# actionButton("goButton", "Calculate") # Have a button that will re-run the calculations upon request
		
		# Return the estimated prior probablity
		numericOutput(output$priorprob_calc)
		
		),
		
	
	#Display the plot and caption as input by user
	mainPanel(	#Plot the recommended prior as functions of sample size and design prevalence
		div(class="span6",plotOutput("priorprob_plot",width="400px",height="400px")),
	)
	
))
