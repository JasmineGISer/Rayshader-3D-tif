library(raster)
library(tidyverse)
library(lubridate)
library(insol)
library(av)
library(rayshader)

#input data is a digital surface model (DSM) generated with airborne lidar
dsm1 <- raster("downscale_highlogcases.tif")

#convert to martix (required by rayshader)
dsm_mat = raster_to_matrix(dsm1)
#textured shadow map based on sun position 
dsm_viz <- dsm_mat %>%
  sphere_shade(texture=create_texture("springgreen","darkgreen", "turquoise","steelblue3","white")) %>%
  add_shadow(ray_shade(dsm_mat)) %>% 
  #add_shadow(ray_shade(dsm_mat, zscale = 0.7), 0.1) %>%
  add_shadow(ambient_shade(dsm_mat), 0) 


dsm_viz %>%  
  plot_3d(dsm_mat, zscale = 0.2, fov = 0, theta = 135, zoom = 0.75, phi = 45, windowsize = c(1000, 800))
render_label(dsm_mat, x = 220, y = 100, z = 500, zscale = 50,
             text = "China", textcolor = "darkred", linecolor = "darkred",
             textsize = 2, linewidth = 2)
angles= seq(0,360,length.out = 1441)[-1]
for(i in 1:36991) {
  render_camera(theta=-45+angles[i])
}
rgl::rgl.close()
