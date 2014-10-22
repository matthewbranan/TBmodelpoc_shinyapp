library(shiny)
library(VGAM)

#Define a server structure to plot the distribution of the user's choice in histogram and QQ plot form
shinyServer(function(input,output){
	
	distrSpecs=reactive({
		input$goButton #Make the distribution randomize upon the go button
		chosendata=switch(input$distrshape, #Choose from a variety of distributions with n observations from user input
			normal=rnorm(input$n),
			skewedleft=rbeta(input$n,5,2),
			skewedright=rbeta(input$n,2,5),
			heavytailed=rt(input$n,1),
			shorttailed=rbeta(input$n,2,2),
			bimodal=rep(c(0,1),c(input$n/2,input$n/2))*rchisq(input$n,4)+rep(c(1,0),c(input$n/2,input$n/2))*rnorm(input$n,15,3),
			multimodal=rnorm(input$n,c(1:input$modes)^2+10,rep(1,input$modes))
			)
	})
	
	#Plot chosen distribution
	output$histogram=renderPlot({
		input$goButton #Re-render the plot with the go button
		hist(distrSpecs(),col="cyan",main="Histogram",xlab="Sample Data");box("plot") #Histogram of random observations
	})
	
	output$QQplot=renderPlot({
		input$goButton #Re-render this plot as well with go button
		qqnorm(distrSpecs()) #Normal QQ plot of random observations
	})
	
})