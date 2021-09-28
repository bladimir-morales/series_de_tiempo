#Using R for Time Series Analysis
#basado en
#https://a-little-book-of-r-for-time-series.readthedocs.io/en/latest/src/timeseries.html


#Reading Time Series Data
#The first thing that you will want to do to analyse your time series data will be to read it into R,
#and to plot the time series. 
 
#In this case the age of death of 42 successive kings of England has been read into the variable 'kings'.
kings <- scan("http://robjhyndman.com/tsdldata/misc/kings.dat",skip=3)
kings

#para pasarlas a series de tiempo
kingstimeseries <- ts(kings, frequency = 12, start = c(1970,1))
kingstimeseries

#otro ejemplo
#An example is a data set of the number of births per month
#in New York city, from January 1946 to December 1959 (originally collected by Newton). This data is available in the file http://robjhyndman.com/tsdldata/data/nybirths.dat We can read the data into R, 
#and store it as a time series object, by typing:

births <- scan("http://robjhyndman.com/tsdldata/data/nybirths.dat")
birthstimeseries <- ts(births, frequency=12, start=c(1946,1))
birthstimeseries
plot(birthstimeseries)


#otro ejemplo mas

#Similarly, the file
#http://robjhyndman.com/tsdldata/data/fancy.dat 
#contains monthly sales for a souvenir shop at a
#beach resort town in Queensland, Australia, for January 1987-December 1993 (original data from Wheelwright and Hyndman, 1998).
#We can read the data into R by typing:

souvenir <- scan("http://robjhyndman.com/tsdldata/data/fancy.dat")
souvenirtimeseries <- ts(souvenir, frequency=12, start=c(1987,1))
souvenirtimeseries
plot(souvenirtimeseries)


#Plotting Time Series
plot.ts(kingstimeseries)

plot.ts(birthstimeseries)

#Similarly, to plot the time series of the monthly sales for the souvenir shop at a beach resort town in Queensland, Australia, we type:
plot.ts(souvenirtimeseries)

#In this case, it appears that an additive model is not appropriate for describing this time series, 
#since the size of the seasonal fluctuations and random fluctuations seem to increase with the level 
#of the time series. Thus, we may need to transform the time series in
#order to get a transformed time series that can be described using an additive model.
#For example, we can transform the time series by calculating the natural log of the original data:
  
logsouvenirtimeseries <- log(souvenirtimeseries)
plot.ts(logsouvenirtimeseries)


#Forecasts using Exponential Smoothing


rain <- scan("http://robjhyndman.com/tsdldata/hurst/precip1.dat",skip=1)
rainseries <- ts(rain,start=c(1813))
plot.ts(rainseries)

#For example, to use simple exponential smoothing to make forecasts for the time series of annual rainfall in London, we type:
  rainseriesforecasts <- HoltWinters(rainseries, beta=FALSE, gamma=FALSE)
rainseriesforecasts


rainseriesforecasts$fitted
#We can plot the original time series against the forecasts by typing:
  
 plot(rainseriesforecasts)

 #As a measure of the accuracy of the forecasts, we can calculate the sum of squared errors for the 
 #in-sample forecast errors, that is, the forecast errors for the time period covered by our original time series.
 #The sum-of-squared-errors is stored in a named element of the list variable "rainseriesforecasts" called "SSE", 
 #so we can get its value by typing:
   
rainseriesforecasts$SSE 


#It is common in simple exponential smoothing to use the first value in the time series as the initial value for the level.
#For example, in the time series for rainfall in London, the first value is 23.56 (inches) for rainfall in 1813.
#You can specify the initial value for the level in the HoltWinters() function by using the "l.start"
#parameter. For example, to make forecasts with the initial value of the level set to 23.56, we type:
  
  HoltWinters(rainseries, beta=FALSE, gamma=FALSE, l.start=23.56) 
#  As explained above, by default HoltWinters() just makes forecasts for the time period covered by the original data,
  #which is 1813-1912 for the rainfall time series. We can make forecasts for further time points by using the
  #"forecast.HoltWinters()" function in the R "forecast" package. To use the forecast.HoltWinters() function, 
  #we first need to install the "forecast" R package (for instructions on how to install an R package, 
  #see How to install an R package).
  
 # Once you have installed the "forecast" R package, you can load the "forecast" R package by typing:
    
library("forecast")

  #  When using the forecast.HoltWinters() function, as its first argument (input), 
  #you pass it the predictive model that you have already fitted using the HoltWinters() function. For example,
  #in the case of the rainfall time series, we stored the predictive model made using HoltWinters() 
  #in the variable "rainseriesforecasts". You specify how many further time points you want to make forecasts 
  #for by using the "h" parameter in forecast.HoltWinters().
  #For example, to make a forecast of rainfall for the years 1814-1820 (8 more years) 
  #using forecast.HoltWinters(), we type:
    
rainseriesforecasts2 <- forecast(rainseriesforecasts, h=8)
rainseriesforecasts2 
plot(rainseriesforecasts2) 
 
 
#Holt's Exponential Smoothing

#An example of a time series that can probably be described using an additive model with a trend and no seasonality
#is the time series of the annual diameter of women's skirts at the hem, from 1866 to 1911. 
#The data is available in the file http://robjhyndman.com/tsdldata/roberts/skirts.dat (original #
#data from Hipel and McLeod, 1994).

#We can read in and plot the data in R by typing:
  
skirts <- scan("http://robjhyndman.com/tsdldata/roberts/skirts.dat",skip=5)
skirtsseries <- ts(skirts,start=c(1866))
plot.ts(skirtsseries)


#For example, to use Holt's exponential smoothing to fit a predictive model for skirt hem diameter, we type:

  skirtsseriesforecasts <- HoltWinters(skirtsseries, gamma=FALSE)
  skirtsseriesforecasts
 
  skirtsseriesforecasts$SSE
  
  plot(skirtsseriesforecasts)
 # If you wish, you can specify the initial values of the level and the slope b of the trend component by using 
  #the "l.start" and "b.start" arguments for the HoltWinters() function.
  #It is common to set the initial value of the level to the first value in the time series (608 for the skirts data), 
  #and the initial value of the slope to the second value minus the first value (9 for the skirts data). For example, 
  #to fit a predictive model to the skirt hem data using Holt's exponential smoothing, with initial values of
  #608 for the level and 9 for the slope b of the trend component, we type:
    
     HoltWinters(skirtsseries, gamma=FALSE, l.start=608, b.start=9)
 # As for simple exponential smoothing, we can make forecasts for future times not covered by the original time series by using the forecast.HoltWinters() function in the "forecast" package. For example, our time series data for skirt hems was for 1866 to 1911, so we can make predictions for 1912 to 1930 (19 more data points), and plot them, by typing:
    
  skirtsseriesforecasts2 <- forecast(skirtsseriesforecasts, h=19)
 plot(skirtsseriesforecasts2)  
 
 
 
 #Holt-Winters Exponential Smoothing
 
 
 
 #To make forecasts, we can fit a predictive model using the HoltWinters() function. 
 #For example, to fit a predictive model for the log of the monthly sales in the souvenir shop, we type:
   
 logsouvenirtimeseries <- log(souvenirtimeseries)
 souvenirtimeseriesforecasts <- HoltWinters(logsouvenirtimeseries)
 souvenirtimeseriesforecasts

# As for simple exponential smoothing and Holt's exponential smoothing, 
 #we can plot the original time series as a black line, with the forecasted values as a red line on top of that:
   
 plot(souvenirtimeseriesforecasts)
 #To make forecasts for future times not included in the original time series, we use the 
 #"forecast.HoltWinters()" function in the "forecast" package. 
 #For example, the original data for the souvenir sales is from January 1987 to December 1993. 
 #If we wanted to make forecasts for January 1994 to December 1998 (48 more months), and plot the forecasts, we would type:
   
  souvenirtimeseriesforecasts2 <- forecast(souvenirtimeseriesforecasts, h=48)
  plot(souvenirtimeseriesforecasts2) 
  
  