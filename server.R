library(shiny)

# Define a server structure
shinyServer(function(input, output){
		
	priorprob_calc = reactive({
		calc = (1 - (1 - (1 - input$dp)^c(input$minplot:input$maxplot))) / (1 - (1 - (1 - input$dp^c(input$minplot:input$maxplot))^2))
		})
		
	priorprob_out = reactive({
		out = (1 - (1 - (1 - input$dp)^input$n)) / (1 - (1 - (1 - input$dp)^input$n)^2)
		})

	output$priorprob_plot <- renderPlot({
		plot(input$minplot, input$maxplot, priorprob_calc(), type = "l", main = "Desired prior probability of infection for prior prevalence distribution Uniform(0, 1)", ylab = "Desired prior probability", xlab = "Design sample size")
		points(input$n, priorprob_out(), pch = 8, cex = 2, col = "red")
		legend("topright", legend = c("Estimated uninformative prior probability"), pch = 8, col = "red")
		})
		
	output$text = renderText({
		paste0("The estimated uninformative \n prior probability is:  ", round(priorprob_out(), 4))
		})

})
 
 
