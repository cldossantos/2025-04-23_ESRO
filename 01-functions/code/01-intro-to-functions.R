# Date: 2025-04-23 
# Author: Caio dos Santos
# Purpose:
#   This script was written as part of a talk with the
#   Ecosystems Research Organization (ESRO). The purpose is to
#   demonstrate the use of functions in R and their importance
#   when it comes to making code reproducible and efficient

## reading the data in
## this data comes from the Iowa Environmental Mesonet
## and was downloaded for the year of 2024 for a station
## in Ames, Iowa.
weather <- read.csv('./raw-data/2024-weather-ames.csv')


## we can explore the data a little bit ----

## how many columns and rows?
dim(weather)

## which columns are present?
names(weather)

## what are the values of those columns?
summary(weather)

## the first 6 rows
head(weather)

## the last 6 rows
tail(weather)

## visualizing the data
matplot(weather['day'],
        weather[c('maxt', 'mint')],
        type = 'l',
        xlab = 'Day of the year', 
        ylab = 'Temperature (Celsius)') 
legend('bottomright', 
       legend = c('maxt', 'mint'),
       lty = 1,
       col = c('black', 'pink3'))


## calculating growing-degree days ----

gdd.mat <- approx(x = c(10, 36, 45), ## values of temperature governing GDD accumulation
                  y = c(0, 26, 0), ## GDD values at the governing values
                  xout = 0:50,
                  method = 'linear',
                  rule = 2)

plot(gdd.mat, type = 'l', 
     xlab = 'Mean daily temperature (Celsius)',
     ylab = 'GDD')


## let's do it without worrying about functions first
## a simple way of calculating growing degree days is 
## by using this formula: ((maxt + mint)/2) - base temperature
w1 <- weather

## this will give us our daily gdd 
w1$gdd <- (w1$maxt + w1$mint)/2 - 10

## let's take a look at the values ....
plot(w1$day, w1$gdd)

## a negative gdd value would mean that the plant in going
## backwards in development... let's take care of these
## negative values
w1$gdd[w1$gdd < 0] <- 0

## we often want to accumulate gdd values
w1$cumulative.gdd <- cumsum(w1$gdd)
plot(w1$day,
     w1$cumulative.gdd,
     type = 'l')

## but what if we want to calculate the cumulative value
## only after a certain date? Let's say we planted on 
## day of the year 136 (May 15th).
w2 <- subset(w1, day >= 136)
w2$cumulative.gdd <- cumsum(w2$gdd)
plot(w2$day, 
     w2$cumulative.gdd,
     type = 'l')

## we can compare the growing degree days accumulated
## all year versus when you only accumulate it from May 15 on.
plot(w1$day,
     w1$cumulative.gdd, 
     type = 'l',
     xlab = 'Day of the year',
     ylab = 'Cumulative GDD')
lines(w2$day, 
      w2$cumulative.gdd, col = 'red')
legend('topleft',
       lty = 1,
       col = c('black', 'red'),
       legend = c('All year', 'May 15'))


## using a function to do this work and organize our code 
cumulative_gdd <- function(doy, maxt, mint, base.temperature){
  gdd <- (maxt + mint) /2 - base.temperature
  gdd[gdd < 0] <- 0
  cumulative <- cumsum(gdd)
  res <- list(x = doy, 
              y = cumulative)
  return(res)
}

gdd1 <- cumulative_gdd(doy = weather$day,
                       maxt = weather$maxt,
                       mint = weather$mint,
                       base.temperature = 10)
plot(gdd1, type = 'l')

## To do:
## show example with base temp = 15
## add argument for "planting date"

