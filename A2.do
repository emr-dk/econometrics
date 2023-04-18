clear all
cd <folder>

// Question 1
use groupdata1.dta

summarize *
describe *

// Histos
histogram prmres, fraction blcolor(black) fcolor(none)
histogram konk, fraction blcolor(black) fcolor(none)
histogram nypr, fraction blcolor(black) fcolor(none)
histogram oms, fraction blcolor(black) fcolor(none)

compress *

// Question 2
gen nyprxoms = nypr * oms
regress prmres oms konk nypr nyprxoms

// Vars
predict uhat, residuals
predict yhat

// Plots
twoway scatter uhat oms
twoway scatter uhat yhat

// BP
estat hettest, rhs iid

// Robust standard errors
regress prmres oms konk nypr nyprxoms, robust

// Calculate WLS by 1/h (Unrestricted)
regress prmres oms konk nypr nyprxoms, robust

gen loguhatsq = log(uhat * uhat)

regress loguhatsq oms konk nypr nyprxoms

predict yhat

gen ghat = exp(yhat)

regress prmres oms konk nypr nyprxoms [aw = 1/ghat]

// Calculate WLS by 1/h (Restricted)
regress prmres oms konk

predict uhat_r, residuals

gen loguhatsq_r = log(uhat_r * uhat_r)

regress loguhatsq_r oms konk

predict yhat_r

gen ghat_r = exp(yhat_r)

regress prmres oms konk [aw = 1/ghat_r]

// Question 3

gen nyprxkonk = nypr*konk

regress prmres nypr oms nyprxoms konk nyprxkonk

test nypr nyprxoms nyprxkonk

// Question 4

gen konkm = (konk==-1)
gen konkn = (konk==0)
gen konkc = (konk==1)
gen konkvc = (konk==2)

regress prmres oms konkv konkn konkc konkvc

regress prmres oms konk

// Question 5

regress prmres oms konkm konkn konkc konkvc nypr nyprxoms
regress prmres oms konkm konkn konkc konkvc nypr nyprxoms, robust
