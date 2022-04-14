library(rnaturalearth)
library(ggplot2)
library(sp)
library(plotly)
library(ggmap)
library(ggridges)

glaciares <- ne_download(scale = 10, type = 'glaciated_areas', category = 'physical', returnclass = 'sf')

latitudes = c(-56, -15)#y
longitudes <- c(-78, -65) #x

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
