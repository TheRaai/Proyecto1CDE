library(rnaturalearth)
library(ggplot2)
library(sp)
library(sf)
library(plotly)
library(ggmap)
library(ggridges)
library(pacman)
library(rgdal)
library(sf)
pacman::p_load(tmap, sf, tidyverse, mapview, RColorBrewer, viridis,
               leafpop, leaflet, leaflet.extras, mapdeck, plotly,
               ggiraph, widgetframe, maps)
sf_use_s2(FALSE)
glaciares <- ne_download(scale = 10, type = 'glaciated_areas', category = 'physical', returnclass = 'sf')
pop<- ne_download(scale = 10, type = 'populated_places', category = 'cultural', returnclass='sf')
df <- ne_countries(country = 'chile',returnclass = c("sf"))
filtered_glaciares = st_filter(glaciares, df, .pred = st_intersects)
filtered_ciudades = st_filter(pop, df, .pred = st_intersects)
filtered_glaciares$name <-NULL
filtered_glaciares <- mutate(filtered_glaciares, area = st_area(filtered_glaciares))

latitudes = c(-56, -15)#y
longitudes <- c(-78, -65) #x

pal <- viridis(n=length(unique(filtered_glaciares)),direction = 1)

leaflet() %>%
  addProviderTiles("OpenStreetMap",
                   group = "OpenStreetMap"
  )%>%
  addProviderTiles("Stamen.Terrain",
                   group = "Stamen.Terrain"
  ) %>% 
  addPolygons(data = filtered_glaciares$geometry, 
              fillColor  = pal,
              fillOpacity = 0.8,
              popup = filtered_glaciares$area,
              color = "#FFFF00", 
              weight = 1
  ) %>% 
  addLayersControl(
    baseGroups = c(
      "OpenStreetMap",
      "Stamen.Terrain"),
    position = "topleft"
  )

filtered_glaciares$area
