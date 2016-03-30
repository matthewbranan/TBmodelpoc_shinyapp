library(shiny)
library(rjags)
library(coda)

# Define a server structure
shinyServer(function(input, output){

	# Construct the matrix of hyperparameters 
	

	# JAGS model data
	jagsmod_dat = reactive({
		list(
			"x" = input$x,
			"n" = input$n,
			"hyperparmmat" = hyperparmmat,
			)
		})

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
	jagsmod = reactive({
		jags.model(jagsmod_txtconnect,
			data = jagsmod_dat(),
			n.adapt = 100,
			n.chains = 1)
		})
	
	# Burnin interval
	jagsmod_update = reactive({
		update(jagsmod(), input$burnin)
		})
	
	# Sample from the conditionals
	jagsamp = reactive({
		coda.samples(jagsmod(),
			variable.names = c("pi", "eta", "theta"),
			n.iter = input$MCMCreps,
			thin = input$thinterval)
		})
			
	# Store table of HPD intervals
	summary_hpdout = reactive({
		hpdout = HPDinterval(jagsamp(), 0.95)[[1]]
		})
	
	# Make HPD intervals output
	output$summary_hpdout = renderTable({
		summary_hpdout()
		})
	

})
 
 
