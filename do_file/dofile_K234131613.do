*Visualization:
gen Date_corrected = Date + td(30dec1899)
format Date_corrected %td
drop Date
rename Date_corrected Date
twoway line Sales Date, title("Sales Trend Over Time") xtitle("Date") ytitle("Sales") xlabel(#10, angle(45))

* Overview
summarize

* Handle Missing values
describe
tabulate Sales, missing
misstable summarize _all
duplicates report Sales

* Handling Outliers
graph box Sales

*Moving Average
tssmooth ma Sales13MA = Sales , window(13)
replace Sales13MA = . in 2
replace Sales13MA = . in 3
replace Sales13MA = . in 4
replace Sales13MA = . in 5
replace Sales13MA = . in 6
replace Sales13MA = . in 7
replace Sales13MA = . in 8
replace Sales13MA = . in 9
replace Sales13MA = . in 10
replace Sales13MA = . in 11
replace Sales13MA = . in 12
replace Sales13MA = . in 12
replace Sales13MA = . in 13
gen error13MA = Sales - Sales13MA
gen error13MA2 = error13MA^2
mean error13MA2
gen abserror13MA = abs(error13MA)
mean abserror13MA
gen APE13MA = abserror13MA/Sales
mean APE13MA

*Weighted Moving Average
tssmooth ma Sales5WMA = Sales , weights(0.2, 0.1, 0.2, 0.1, 0.4 <0>)
gen error5WMA = Sales - Sales5WMA
gen error5WMA2 = error5WMA^2
mean error5WMA2
gen abserror5WMA = abs(error5WMA)
mean abserror5WMA
gen APE5WMA = abserror5WMA/Sales
mean APE5WMA

* Single Exponential Smoothing
tsset Date

gen Month = tm(2004m1) + _n - 1
format %tm Month
tsset Month
tssmooth exponential SalesSEM = Sales, s0(5629)
replace SalesSEM = . in 1
gen errorSEM = Sales - SalesSEM
gen errorSEM2 = errorSEM^2
mean errorSEM2
gen abserrorSEM = abs(errorSEM)
mean abserrorSEM
gen APESEM = abserrorSEM/Sales

*Holt-Winter Linear Trend
tssmooth hwinters SalesHolt = Sales, s0(5360 269)
replace SalesHolt = . in 1
gen errorHolt = Sales - SalesHolt
gen errorHolt2 = errorHolt^2
mean errorHolt2
gen abserrorHolt = abs(errorHolt)
mean abserrorHolt
gen APEHolt = abserrorHolt / Sales
mean APEHolt

*Trend Projection
reg Sales t
predict errortp, residuals
gen errortp2 = errortp^2
mean errortp2
gen abserrortp = abs(errortp)
mean abserrortp
gen APEtp = abserrortp/Sales
mean APEtp

*Seasonal Without Trend
reg Sales i.Month_num
predict errorswt, residuals
gen errorswt2 = errorswt^2
mean errorswt2
gen abserrorswt = abs(errorswt)
mean abserrorswt
gen APEswt = abserrorswt/Sales
mean APEswt

* Additive
reg Sales i.Month_num t
predict erroradd, residuals
gen erroradd2 = erroradd^2
mean erroradd2
gen abserroradd = abs(erroradd)
mean abserroradd
gen APEadd = abserroradd/Sales
mean APEadd

history