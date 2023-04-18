// Problem 1
clear all
cd </data_folder>
use kommune.dta
describe
summarize

// Problem 2

// Even though log = ln in stata (and econometrics) I like to keep the
//  ln notation as a reminder
gen logtaxrev = ln(taxrev)
regress logtaxrev taxrate
gen logpop = ln(pop)
regress logtaxrev taxrate logpop

// Problem 3

regress taxrate logpop
predict res1, residuals
regress logtaxrev res1
 
