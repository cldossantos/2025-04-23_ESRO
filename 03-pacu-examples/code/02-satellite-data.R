# Date: 2025-04-23 
# Author: Caio dos Santos
# Purpose:
# This script was written to demonstrate some of the 
# functionalities within the pacu package. The package has
# three main large components: yield monitor data, satellite
# images, and weather data. This script, specifically, will
# focus on satellite data.


## For this exercise, we will focus on the ISU agronomy
## farm. We will download and process satellite data.

## loading necessary libraries
library(pacu)
library(sf)

## reading the georeferenced file that contains the 
## boundaries of the agronomy farm
ag.farm <- st_read('./raw-data/agronomy-farm/POLYGON.shp')

## looking for images on the dataspace catalog
available.images <- pa_browse_dataspace(aoi = ag.farm,
                                        start.date = '2024-05-01',
                                        end.date = '2024-10-15',
                                        max.cloud.cover = 1)

## how many images are available?
available.images

## what about breaking it down by month?
summary(available.images)

## let's download a few images
dw.images <- pa_download_dataspace(available.images[-2, ],
                                   dir.path = './processed-data/',
                                   aoi = ag.farm)

## we can take a look at the true color image
tc.img <- pa_get_rgb(dw.images)
pa_plot(tc.img)

## Looking specifically at fields 
ag.fields <- st_read('./raw-data/agronomy-fields/POLYGON.shp')
ag.fields$ID <- as.factor(ag.fields$ID)

plot(ag.fields, 
     reset = FALSE,
     extent = st_bbox(ag.farm))
plot(ag.farm, 
     add = TRUE,
     border = 'red')

tc.img2 <- pa_get_rgb(dw.images,
                      aoi = ag.fields)
pa_plot(tc.img2)


## What about calculating NDVI?
ndvi <- pa_compute_vi(dw.images,
                      vi = 'ndvi',
                      aoi = ag.farm)
pa_plot(ndvi)

## Do we know any other indices?
ndre <- pa_compute_vi(dw.images,
                      vi = 'ndre',
                      aoi = ag.farm)
pa_plot(ndre)


## What if I wanted to know an average per field?
ndvi.mean <- summary(ndvi, by = ag.fields, fun = mean)
pa_plot(ndvi.mean)

## What if we wanted to see a timeseries?
pa_plot(ndvi.mean,
        plot.type = 'timeseries',
        by = 'ID')

## It seems like field #7 has a different behavior...
ndvi2 <- pa_compute_vi(dw.images,
                      vi = 'ndvi',
                      aoi = ag.fields[7, ])
pa_plot(ndvi2)
