library(shiny)
library(shinydashboard)
library(tidyverse)
library(readxl)
library(csvread)
library(ggplot2)
library(dplyr)
library(leaflet)
library(shinyjs)
library(gganimate)
library(sf)
library(rsconnect)
getwd()

datos <- read.csv("data/Tabla.csv", fileEncoding = "Latin1")

paises <- unique(datos$Pais)
variables_x <- setdiff(names(datos), c("Pais", "Año", "Brecha"))

coordenadas_paises <- data.frame(
  paises = c("Argentina", "Brasil", "Chile", "Colombia", "Ecuador", "Paraguay", "Perú", "Uruguay"),
  lat = c(-34.61, -14.23, -33.45, 4.61, -0.18, -25.30, -9.19, -34.90),
  lng = c(-58.38, -51.92, -70.65, -74.08, -78.47, -57.63, -77.03, -56.19))

poligonos <- st_read("mapa")

normalizar_nombre_pais <- function(pais) {
  pais %>%
    str_to_lower() %>%  
    str_trim() %>%  
    str_replace_all("[áéíóú]", function(x) {  
      switch(x,
             "á" = "a",
             "é" = "e",
             "í" = "i",
             "ó" = "o",
             "ú" = "u")
    })
}

