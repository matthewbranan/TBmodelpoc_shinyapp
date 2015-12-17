library(shiny)

# Define a server structure
shinyServer(function(input, output){

	output$priorprob_plot <- renderPlot({
		plot(input$n, input$dp)
		})

})
 
