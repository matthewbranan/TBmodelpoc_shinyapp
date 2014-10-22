library(shiny)


#Define a UI structure
shinyUI(pageWithSidebar(

	#App title
	headerPanel("Distribution Shapes and QQ Plots"),
	
	sidebarPanel(
		#Choose what general type of distribution to plot
		selectInput("distrshape", "Distribution Shape:", #Let the user choose from a variety of different distribution shapes
			list("Normal"="normal",
				"Skewed Left"="skewedleft",
				"Skewed Right"="skewedright",
				"Heavy Tailed"="heavytailed",
				"Short Tailed"="shorttailed",
				"Bimodal"="bimodal",
				"Multimodal"="multimodal"
		)),
		
	conditionalPanel( #Add a slider bar for user to choose the number of modes in the multimodal distribution
		condition="distershape==multimodal",
		sliderInput("modes","Modes (for Multimodal option only):",
			min=3,max=8,value=3)
		),
		
		
		#Choose sample size
		numericInput("n","Sample Size:",1000), #Have the user select the sample size. Be careful, no error checking for, possibly infinite or at least, very large sample sizes
		
		#Go Button
		actionButton("goButton","Randomize!") #Have a button that will re-select the random sample from the distribution specified
		),
		
	
	#Display the plot and caption as input by user
	mainPanel(	#Plot the two graphs side-by-side as square items in the main display space
		div(class="span6",plotOutput("histogram",width="400px",height="400px")),
		div(class="span6",plotOutput("QQplot",width="400px",height="400px"))
	)
	
))
