// Initialisation

use groupdata1.dta

// Problem 1
sum * 

des * 

foreach var of varlist czone-dIPWotmx {
	histogram `var', fraction blcolor(black) fcolor(none)
	graph export "~/Documents/Arbejde/Undervisning/Oekonometri/Afleveringer_godkendelse/3/grafer//`var'.png"
}

gen largeX = foreignborn + routine + college

// Problem 2
*** 2.1
corr dIPWotch t2 largeX


*** 2.2
ivregress 2sls dsL t2 largeX (dIPWusch = dIPWotch)

*** 2.3 OI
ivregress 2sls dsL t2 largeX (dIPWusch = dIPWotch dIPWukch)

predict uhat, residuals

regress uhat t2 largeX dIPWotch dIPWukch

*** 2.4
ivregress 2sls dsL t2 largeX dIPWusmx (dIPWusch = dIPWotch dIPWukch)

// Problem 3
*** 3.1
gen t2xdIPWusch = t2 * dIPWusch
gen t2xdIPWotch = t2 * dIPWotch

regress t2xdIPWusch t2 largeX dIPWotch t2xdIPWotch

predict firststageOne

regress dIPWusch t2 dIPWotch t2xdIPWotch largeX

predict firstageTwo

regress dsL t2 largeX firststageOne firststageTwo

*** 3.2 
ivregress 2sls dsL t2 largeX (dIPWusch t2xdIPWusch = dIPWotch t2xdIPWotch)

test 
*** 3.3 Exogeneity
regress dIPWusch dIPWotch dIPWukch largeX t2

predict ehat, residual

regress dsL t2 largeX dIPWusch ehat 
 
// Problem 5
 clear all
*DEFINE PROGRAM THAT SPECIFIES THE DGP
cd "~/Documents/Arbejde/Undervisning/Oekonometri/Afleveringer_godkendelse/3/grafer//"
program ivdata, rclass
	drop _all
	set obs 1000
	
	generate xstar = rnormal(1,4)
	generate u = rnormal()
	generate epsilon = rnormal()
	generate mu = rnormal()
	generate theta = 1
	generate rho = 1 // Run for -0.5,0,0.5 and 1
	generate eta = rho * epsilon + mu
	generate z = theta * xstar + eta
	generate x = xstar + epsilon
	generate y = 4 + 3*xstar + u
	
	* Calculate OLS estimates
	regress y x
	return scalar b1_ols=_b[x]
	
	* Calculate IV estimates
	ivregress 2sls y (x = z)
	return scalar b1_iv1=_b[x]
end
simulate ols=r(b1_ols) iv1=r(b1_iv1) , seed(1337) reps(500) :ivdata
summarize

// Export for every simulation
graph twoway histogram ols

graph export ols.png

graph twoway histogram iv1

graph export iv1.png


