library(rnaturalearth)
library(rnaturalearthdata)
library(ggplot2)
library(sp)
library(plotly)
library(ggmap)
library(ggridges)
pacman::p_load(tmap, sf, tidyverse, mapview, RColorBrewer, viridis,
               leafpop, leaflet, leaflet.extras, mapdeck, plotly,
               ggiraph, widgetframe, maps)

glaciares <- ne_download(scale = 10, type = 'glaciated_areas', category = 'physical', returnclass = 'sf')
#ciudades <- data(world.cities)

latitudes = c(-56, -15)#y
longitudes <- c(-78, -65) #x

c <-ggplot(data = ciudades,geom_sf() + coord_sf(xlim = longitudes, ylim = latitudes, expand = FALSE)
p <- ggplot(data=glaciares) + geom_sf() + coord_sf(xlim = longitudes, ylim = latitudes, expand = FALSE)
ggplotly(p)
p

spatial_ramon <- SpatialPoints(coords=cbind(longitudes, latitudes), proj4string=CRS("+proj=longlat +datum=WGS84"))

# exploramos los limites
spatial_ramon@bbox[4]

# extraemos un mapa
mapa <- get_map(location = spatial_ramon@bbox, maptype = "terrain", zoom = 7)

# dibujamos el mapa
ggmap(mapa)

pal <- viridis(n=length(unique(glaciares)),direction = 1)

leaflet() %>%
  addProviderTiles("OpenStreetMap",
                   group = "OpenStreetMap"
  )  %>%
  addProviderTiles("Stamen.Terrain",
                   group = "Stamen.Terrain"
  ) %>% 
  addPolygons(data = glaciares$geometry, 
              fillColor  = pal,
              fillOpacity = 0.8,
              #popup = glaciares$featurecla
              color = "#FFFF00", 
              weight = 1) %>% 
  addLayersControl(
    baseGroups = c(
      "OpenStreetMap",
      "Stamen.Terrain"),
    position = "topleft"
  )

