library(shiny)

# Define a server structure
shinyServer(function(input, output){

	priorprob_sse = reactive({
		sse = 1 - (1 - input$dp)^input$n
		})
		
	priorprob_calc = reactive({
		calc = (1 - priorprob_sse()) / (1 - priorprob_sse()^2)
		})

	output$priorprob_plot <- renderPlot({
		plot(input$n, input$dp)
		})

})
 
