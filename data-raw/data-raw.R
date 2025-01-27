
# Contruction de la table des départements --------------------------------

library(sf)
library(stringr)
library(readr)
library(readxl)
library(tidyverse)
epci_geo<-st_read(dsn="extdata/epci/",layer="EPCI")

departements_geo<-st_read(dsn="extdata/departements/",layer="DEPARTEMENT") %>% 
  mutate(AREA=st_area(geometry))

regions_geo<-st_read(dsn="extdata/regions/",layer="REGION")

prefecture_de_region_geo<-st_read(dsn="extdata/adminexpress/",layer="CHEF_LIEU") %>% 
  filter(STATUT == "Préfecture de région") %>% 
  mutate(coords=as.character(geometry) %>% 
           str_replace_all("c\\(","") %>% 
           str_replace_all("\\)","")) %>% 
  mutate(x=str_split_fixed(coords,", ",2)[,1] %>% 
           str_trim(),
         y=str_split_fixed(coords,", ",2)[,2] %>% 
           str_trim()
         ) %>% 
  select(-coords) %>% 
  st_drop_geometry()

write_csv2(prefecture_de_region_geo,"extdata/prefecture.csv")

save(epci_geo,departements_geo,regions_geo,file="data/admin_express.RData")
