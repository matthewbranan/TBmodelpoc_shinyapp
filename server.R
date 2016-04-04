library(shiny)
library(rjags)
library(coda)
library(ggplot2)
library(epiR)
library(DT)

# Define a server structure
shinyServer(function(input, output){

	# Handle conditional choice of method to specify prior distirbutions for sensitivity and specificity
	alphabeta_etatheta_out = reactive({
		
		if(input$select_eta == input$straightbeta){
			matrix(c(
				input$alpha_eta, input$beta_eta,
				input$alpha_theta, input$beta_theta),
				2, 2, byrow = TRUE)
			} else{
				eta_bb = epi.betabuster(input$etamode, 0.95, TRUE, input$eta_5thperc)
				theta_bb = epi.betabuster(input$thetamode, 0.95, TRUE, input$theta_5thperc)
				matrix(c(
					eta_bb$shape1, eta_bb$shape2,
					theta_bb$shape1, theta_bb$shape2),
					2, 2, byrow = TRUE)
				}
		})
	
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
			phi <- pi * eta + (1 - pi) * (1 - theta)
			
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
	output$summary_hpdout = renderDataTable({
		round(HPDinterval(jagsamp_out(), 0.95)[[1]], input$digits)
		})  # , digits = 16
	
	# Summary statistics output
	output$summary_sumstatout = renderTable({
		temp_sumstatout = summary(jagsamp_out())
		round(cbind(temp_sumstatout[[1]][, c(1, 2, 4)], temp_sumstatout[[2]]), input$digits)
		}, digits = 16)
		
	# Diagnostic plots
	
	for (i in 1:3){
		local({
			my_i = i
			plotname = c("eta", "theta", "pi")[my_i]
			output[[paste0("traceplot_", plotname)]] = renderPlot({
				ggplot(data = jagsamp_df(), aes(x = 1:1000, y = get(plotname))) + geom_line(alpha = 0.5) + labs(x = "Last 1,000 iterations", y = plotname, title = paste0("Trace plot for ", plotname))
				})
				
			output[[paste0("densplot_", plotname)]] = renderPlot({
				ggplot(data = jagsamp_df(), aes(get(plotname))) + geom_histogram(aes(y = ..density..), col = "white", alpha = 0.5) + geom_density(aes(y = ..density..)) + labs(x = plotname, title = paste0("Posterior density estimate for ", plotname))
				})
			})
		
		}

	

})
 
 
