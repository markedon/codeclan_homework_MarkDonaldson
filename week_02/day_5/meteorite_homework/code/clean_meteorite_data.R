library(tidyverse)
library(assertr)

meteorites <- read_csv("data/raw_data/meteorite_landings.csv")

# Verify the data is as we expect

stopifnot(
  names(meteorites) == c("id", "name", "mass (g)", "fall", "year", "GeoLocation")
)

# Cleaning data

meteorites <-
  meteorites %>% 
  rename(
    mass = "mass (g)",
    lat_lng = "GeoLocation"
  ) %>% 
  mutate(
    lat_lng = str_remove(lat_lng, fixed("(")),
    lat_lng = str_remove(lat_lng, fixed(")"))
  ) %>% 
  separate(lat_lng, c("lat", "lng"), sep = ", ") %>% 
  mutate(
    lat = as.numeric(lat),
    lng = as.numeric(lng),
    lat = coalesce(lat, 0),
    lng = coalesce(lng, 0)
  ) %>% 
  filter(
    mass >= 1000
  ) %>% 
  arrange(year)

# Verify that we have valid latitudes and longitudes

meteorites %>% 
  verify(lat >= -90 & lat <= 90) %>% 
  verify(lng >= -180 & lng <= 180)

write_csv(meteorites, "data/clean_data/meteorites.csv")
