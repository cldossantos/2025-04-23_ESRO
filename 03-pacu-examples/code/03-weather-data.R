# Date: 2025-04-23 
# Author: Caio dos Santos
# Purpose:
# This script was written to demonstrate some of the 
# functionalities within the pacu package. The package has
# three main large components: yield monitor data, satellite
# images, and weather data. This script, specifically, will
# focus on weather data.

## loading the necessary libraries
library(sf)
library(pacu)


## Let us take a look at weather data for the agronomy farm
ag.farm <- st_read('./raw-data/agronomy-farm/POLYGON.shp')

## Downloading weather data
weather <- pa_get_weather_sf(ag.farm,
                             source = 'iem',
                             start.date = '1990-01-01',
                             end.date = '2024-12-31')

## Alright... how far from the agronomy farm is that station?
attr(weather, 'comment')

## Can we make pretty graphs?
pa_plot(weather, 
        plot.type = 'climate')


## What if we're only interested in the growing season?
pa_plot(weather, 
        plot.type = 'climate',
        start = 121,
        end = 300)


## What we want to focus on a different year?
pa_plot(weather, 
        plot.type = 'climate',
        tgt.year = 2015,
        start = 121,
        end = 300)


## We can also check the distribution of these weather 
## variables on a monthly basis
pa_plot(weather, 
        plot.type = 'month')

## Focusing on less variables and months
pa_plot(weather,
        plot.type = 'month',
        vars = 'crain',
        months = 5:10)

## Different unit system
pa_plot(weather,
        plot.type = 'month',
        vars = 'maxt',
        months = 5:10)






