library(shiny)

# Define a server structure
shinyServer(function(input, output){

	priorprob_sse = reactive({
		sse = 1 - (1 - input$dp)^c(1:100)
		})
		
	priorprob_calc = reactive({
		calc = (1 - priorprob_sse()) / (1 - priorprob_sse()^2)
		})
		
	priorprob_out = reactive({
		out = (1 - (1 - (1 - input$dp)^input$n)) / (1 - (1 - (1 - input$dp)^input$n)^2)
		})

	output$priorprob_plot <- renderPlot({
		plot(1:100, priorprob_calc(), type = "l")
		points(input$n, priorprob_out(), pch = 8, cex = 2, col = "red")
		})
		
	output$text = renderText({
		paste0("The estimated uninformative \n prior probability is:  ", round(priorprob_out(), 4))
		})

})
 
 
