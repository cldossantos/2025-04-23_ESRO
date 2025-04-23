# Date: 2025-04-23 
# Author: Caio dos Santos
# Purpose:
# This script was written to demonstrate some of the 
# functionalities within the pacu package. The package has
# three main large components: yield monitor data, satellite
# images, and weather data. This script, specifically, will
# focus on yield monitor data.
# The data used here comes from MN and was included in the 
# agridat package. Please see their help page for more information:
# https://kwstat.github.io/agridat/reference/gartner.corn.html

library(sf)
library(pacu)

## loading the yield data 
raw.yield <- st_read('./raw-data/yield-monitor/ym-data.shp')


## let's explore the data a little bit
plot(raw.yield)

## in which columns are we interested?
head(raw.yield, 2)

## let's just check the yield
plot(raw.yield['yield'],
     pch = 16)

## using pacu, we can process these yield data
yld1 <- pa_yield(raw.yield,
                 algorithm = 'simple',
                 unit.system = 'standard',
                 lbs.per.bushel = 56)
pa_plot(yld1)


## what if we wanted to aggregate the data in a grid
## of 15x15m ??
prediction.grid <- st_make_grid(raw.yield,
                                cellsize = 10)
yld2 <- pa_yield(raw.yield,
                 grid = prediction.grid,
                 algorithm = 'simple',
                 unit.system = 'standard',
                 lbs.per.bushel = 56,
                 verbose = 2,
                 cores = 5)
pa_plot(yld2)


## Can we interpolate these data?
yld3 <- pa_yield(raw.yield,
                 grid = prediction.grid,
                 algorithm = 'simple',
                 unit.system = 'standard',
                 smooth.method = 'idw',
                 lbs.per.bushel = 56,
                 verbose = 2,
                 cores = 5)
pa_plot(yld3)


## A better option could be kriging
yld4 <- pa_yield(raw.yield,
                 grid = prediction.grid,
                 algorithm = 'simple',
                 unit.system = 'standard',
                 smooth.method = 'krige',
                 lbs.per.bushel = 56,
                 verbose = 2,
                 cores = 5)
pa_plot(yld4)
pa_plot(yld4, plot.type = 'variogram')

## These yield maps were all produced using the "simple" 
## algorithm. However, pacu has a different algorithm that
## is aimed towards tracking and accounting for irregular
## combine passes. These can happen when the combine makes 
## abrupt turns. 
yld5 <- pa_yield(raw.yield,
                 grid = prediction.grid,
                 algorithm = 'ritas',
                 unit.system = 'standard',
                 smooth.method = 'krige',
                 steps = TRUE,
                 lbs.per.bushel = 56,
                 verbose = 2,
                 cores = 5)
pa_plot(yld5)
pa_plot(yld5, plot.type = 'variogram')
pa_plot(yld5, plot.type = 'steps', ask = FALSE)


## Comparing the methods
plot(yld4$yield$yield, yld5$yield$yield,
     xlab = 'Yield using simple (bu/ac)',
     ylab = 'Yield using ritas (bu/ac)')
abline(0, 1, col = 'red')


