library(shiny)
library(rjags)
library(coda)
library(ggplot2)

# Define a server structure
shinyServer(function(input, output){

	
	jagsamp_out = reactive({
		# Re-fit model upon pressing the "Fit model" button
		input$fitModel
	
		# Construct the matrix of hyperparameters 
		hyperparmmat = matrix(c(
			input$alpha_eta, input$beta_eta,
			input$alpha_theta, input$beta_theta,
			input$alpha_pi, input$beta_pi),
			3, 2, byrow = TRUE)
			
		# JAGS model data	
		jagsmod_dat = list(
			"x" = input$x,
			"n" = input$n,
			"hyperparmmat" = hyperparmmat
			)
			
		# Define the JAGS function
	jagsmod_txt = "
		model{
			x ~ dbinom(phi, n)
			phi = pi * eta + (1 - pi) * (1 - theta)
			
			eta ~ dbeta(hyperparmmat[1, 1], hyperparmmat[1, 2])
			theta ~ dbeta(hyperparmmat[2, 1], hyperparmmat[2, 2])
			pi ~ dbeta(hyperparmmat[3, 1], hyperparmmat[3, 2])
			
			}
		"
		
		# Open up a text connection
		jagsmod_txtconnect = textConnection(jagsmod_txt)
		
		# Compile the JAGS model
		jagsmod = jags.model(jagsmod_txtconnect,
			data = jagsmod_dat,
			n.adapt = 100,
			n.chains = 1)
			
		# Burnin interval
		update(jagsmod, input$burnin)
		
		# Sample from the conditionals
		jagsamp = coda.samples(jagsmod,
			variable.names = c("pi", "eta", "theta"),
			n.iter = input$MCMCreps,
			thin = input$thinterval)
			
		return(jagsamp)

		})
		
## Output helper variables		
	jagsamp_df = reactive({
		data.frame(jagsamp_out()[[1]][(input$MCMCreps / input$thinterval - 1000): (input$MCMCreps / input$thinterval), ])
		})
		
## Creating outputs
	# HPD intervals output
	output$summary_hpdout = renderTable({
		round(HPDinterval(jagsamp_out(), 0.95)[[1]], input$digits)
		}, digits = 16)
	
	# Summary statistics output
	output$summary_sumstatout = renderTable({
		temp_sumstatout = summary(jagsamp_out())
		round(cbind(temp_sumstatout[[1]][, c(1, 2, 4)], temp_sumstatout[[2]]), input$digits)
		}, digits = 16)
		
	# Diagnostic plots
	output$traceplot_eta = renderPlot({
		ggplot(data = jagsamp_df(), aes(x = 1:1000, y = eta)) + geom_line() + labs(x = "Last 1,000 iterations", y = "Sensitivity (eta)", title = "Trace plot for sensitivity")
		})
	
	output$traceplot_theta = renderPlot({
		ggplot(data = jagsamp_df(), aes(x = 1:1000, y = theta)) + geom_line() + labs(x = "Last 1,000 iterations", y = "Specificity (theta)", titel = "Trace plot for specificity")
		})

})
 
 
