use "statavisualmidterm.dta"
drop resadd resswt restp errorresadd errorresswt errortp abserrorresadd abserrorresswt abserrortp errorresadd2 errorresswt2 errortp2 APEresadd APEresswt APEtp

* 1. Trend Projection
reg Sales t
predict fitted_tp, xb
predict errortp, residuals
gen errortp2 = errortp^2
mean errortp2
gen abserrortp = abs(errortp)
mean abserrortp
gen APEtp = abserrortp/Sales
mean APEtp

twoway (scatter Sales t, mcolor(blue) msymbol(O)) (line fitted_tp t, lcolor(red) lwidth(medium)), title("Trend Projection: Actual Sales vs. Fitted Trend") legend(order(1 "Actual Sales" 2 "Fitted Trend"))
tsline errortp, title("Trend Projection: Residuals over Time")
histogram errortp, title("Histogram of Trend Projection Residuals") normal

* 2. Seasonal Without Trend
reg Sales i.Month_num
predict fitted_swt, xb
predict errorswt, residuals
gen errorswt2 = errorswt^2
mean errorswt2
gen abserrorswt = abs(errorswt)
mean abserrorswt
gen APEswt = abserrorswt/Sales
mean APEswt

* Visualizations for Seasonal Without Trend:
twoway (scatter Sales Month_num, mcolor(blue) msymbol(O)) (line fitted_swt Month_num, lcolor(red) lwidth(medium)), title("Seasonal Without Trend: Sales vs. Month") legend(order(1 "Actual Sales" 2 "Fitted Seasonal"))
tsline errorswt, title("Seasonal Without Trend: Residuals over Time")
graph box errorswt, title("Boxplot of Seasonal Residuals")

* 3. Additive Model
reg Sales i.Month_num t
predict fitted_add, xb
predict erroradd, residuals
gen erroradd2 = erroradd^2
mean erroradd2
gen abserroradd = abs(erroradd)
mean abserroradd
gen APEadd = abserroradd/Sales
mean APEadd

* Visualizations for Additive Model:
twoway (scatter Sales t, mcolor(blue) msymbol(O)) (line fitted_add t, lcolor(red) lwidth(medium)), title("Additive Model: Actual Sales vs. Fitted Additive") legend(order(1 "Actual Sales" 2 "Fitted Additive"))
tsline erroradd, title("Additive Model: Residuals over Time")
histogram erroradd, title("Histogram of Additive Model Residuals") normal


* 4. Moving Average (13MA)
tssmooth ma Sales13MA = Sales, window(13)
replace Sales13MA = . in 2/13
gen error13MA = Sales - Sales13MA
gen error13MA2 = error13MA^2
mean error13MA2
gen abserror13MA = abs(error13MA)
mean abserror13MA
gen APE13MA = abserror13MA/Sales
mean APE13MA

* Visualizations for Moving Average:
tsline Sales Sales13MA, title("Moving Average (13MA) vs. Sales") legend(order(1 "Actual Sales" 2 "13MA"))
tsline error13MA, title("Moving Average: Residuals over Time")
graph box error13MA, title("Boxplot of Moving Average Residuals")


* 5. Weighted Moving Average (WMA)
tssmooth ma Sales5WMA = Sales, weights(0.2, 0.1, 0.2, 0.1, 0.4 <0>)
gen error5WMA = Sales - Sales5WMA
gen error5WMA2 = error5WMA^2
mean error5WMA2
gen abserror5WMA = abs(error5WMA)
mean abserror5WMA
gen APE5WMA = abserror5WMA/Sales
mean APE5WMA

* Visualizations for Weighted Moving Average:
tsline Sales Sales5WMA, title("Weighted Moving Average vs. Sales") legend(order(1 "Actual Sales" 2 "Weighted MA"))
tsline error5WMA, title("Weighted Moving Average: Residuals over Time")
histogram error5WMA, title("Histogram of Weighted MA Residuals") normal
