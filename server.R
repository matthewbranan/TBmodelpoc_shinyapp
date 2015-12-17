library(shiny)

# Define a server structure
shinyServer(function(input, output){

	# Calculate the estimated prior probability for use in the plot (so, for all integers between the min and max x-axis plot limits)		
	priorprob_calc = reactive({
		calc = (1 - (1 - (1 - input$dp)^c(input$minplot:input$maxplot))) / (1 - (1 - (1 - input$dp)^c(input$minplot:input$maxplot))^2)
		})
		
	# Calculate the estimated prior probability for text output
	priorprob_out = reactive({
		out = (1 - (1 - (1 - input$dp)^input$n)) / (1 - (1 - (1 - input$dp)^input$n)^2)
		})

	# Generate the plot for the desired prior probabilities across the x-axis plotting window
	output$priorprob_plot <- renderPlot({
		plot(input$minplot:input$maxplot, priorprob_calc(), type = "l", main = "Desired prior probability of infection for \n prior prevalence distribution Uniform(0, 1)", ylab = "Desired prior probability", xlab = "Design sample size")
		grid()
		points(input$n, priorprob_out(), pch = 8, cex = 2, col = "red")
		legend("topright", legend = c("Estimated uninformative prior probability"), pch = 8, col = "red")
		})
	
	# Output for text reporting of the estimated uninformative prior probability	
	output$text = renderText({
		paste0(round(priorprob_out(), 4))
		})

})
 
 
