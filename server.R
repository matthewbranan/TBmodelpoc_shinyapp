library(shiny)

# Define a server structure
shinyServer(function(input, output){

	output$distPlot <- renderPlot({
		plot(input$n, input$dp)
		})

})
 
