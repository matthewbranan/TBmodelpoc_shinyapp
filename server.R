library(shiny)

# Define a server structure
shinyServer(function(input, output){
	
	output$priorprob_calc = reactive({
		# input$goButton #Make the distribution randomize upon the go button
		priorprob = (1 - (1 - (1 - input$dp)^input$n)) / (1 - (1 - (1 - input$dp)^input$n)^2)
	})
	
	
	output$priorprob_plot = renderPlot({
		# input$goButton #Re-render this plot as well with go button
		plot(1:100, (1 - (1 - (1 - input$dp)^1:100)) / (1 - (1 - (1 - input$dp)^1:100)^2), type = "l")
		points(input$n, output$priorprob_calc, pch = 8, col = "red")
	})
	
})
 
