library(rnaturalearth)
library(rnaturalearthdata)
library(ggplot2)
library(sp)
library(plotly)
library(ggmap)
library(ggridges)
pacman::p_load(tmap, sf, tidyverse, mapview, RColorBrewer, viridis,
               leafpop, leaflet, leaflet.extras, mapdeck, plotly,
               ggiraph, widgetframe, st)

#descarga informacion de los glaciares mundiales
glaciares <- ne_download(scale = 10, type = 'glaciated_areas', category = 'physical', returnclass = 'sf')
pop<- ne_download(scale = 10, type = 'populated_places', category = 'cultural', returnclass='sf')
df <- ne_countries(country = 'chile',returnclass = c("sf"))
filtered_glaciares = st_filter(glaciares, df, .pred = st_intersects)
filtered_ciudades = st_filter(pop, df, .pred = st_intersects)
filtered_glaciares$name <-NULL
filtered_glaciares <- mutate(filtered_glaciares, area = st_area(filtered_glaciares))


latitudes = c(-56, -15)#y
longitudes <- c(-78, -65) #x

cent <- st_point_on_surface(filtered_glaciares)
cent_temp <- unlist(cent$geometry)
long <- cent_temp[seq(1, length(cent_temp),2)]
lat <- cent_temp[-seq(1, length(cent_temp),2)]

filtered_glaciares['cent_long'] <- long
filtered_glaciares['cent_lat'] <- lat

filtered_glaciares['contenido'] <- paste("Área glaciar: ", filtered_glaciares$area)
# dibujamos el mapa
ggmap(mapa)

list2 <-list("ciudad1","ciudad2")
filtered_glaciares <- filtered_glaciares %>% mutate(Cercano = I(list(c(list2))))

for (n in 1:70){ #recorre los glaciares de uno en uno
  x <- list()
  i = 1
  for(m in 1:77){#recorre las ciudades de una en una
    dist = distm(c(filtered_glaciares$cent_long[n], filtered_glaciares$cent_lat[n]), c(filtered_ciudades$LONGITUDE[m], filtered_ciudades$LATITUDE[m]), fun = distHaversine)
    dist = dist/1000 #pasa la distancia en metro a KM
    #print(dist)
    if(dist <= 200){
      #print("menor a 3000")
      x[i] <- filtered_ciudades$NAMEASCII[m]
      i <- i+1
    }
  }
  filtered_glaciares$Cercano[n] <- I(list(c(x)))
}

print(x)

pal <- viridis(n=length(unique(glaciares)),direction = 1)

int_map <- filtered_glaciares %>% leaflet() %>% addProviderTiles("OpenStreetMap", group = "openstreetmap") %>%
  setView(lng = -71.5430, lat = -35.6751, zoom =4) %>% 
  addPolygons(data = filtered_glaciares$geometry, 
              fillColor  = pal,
              fillOpacity = 0.8,
              color = "#FFFF00", 
              weight = 1) %>% 
  addMarkers(lng = filtered_glaciares$cent_long,
             lat = filtered_glaciares$cent_lat, 
             popup= filtered_glaciares$contenido
  )



int_map