library(shiny)

# Define a server structure
shinyServer(function(input, output){

	priorprob_sse = reactive({
		sse = 1 - (1 - input$dp)^1:100
		})
		
	priorprob_calc = reactive({
		calc = (1 - priorprob_sse()) / (1 - priorprob_sse()^2)
		})
		

	output$priorprob_plot <- renderPlot({
		plot(1:100, priorprob_calc(), type = "l")
		})

})
 
