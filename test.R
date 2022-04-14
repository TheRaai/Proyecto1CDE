library(rnaturalearth)
library(ggplot2)
library(sp)
glaciares <- ne_download(scale = 10, type = 'glaciated_areas', category = 'physical', returnclass = 'sf')

ggplot(data=glaciares) + geom_sf() + coord_sf(xlim = c(-80, -60), ylim = c(-60,-5), expand = FALSE)

