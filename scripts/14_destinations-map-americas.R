#-------------------------------------------------------------------------------
# Mapping no. calls by destination - Americas
#-------------------------------------------------------------------------------

library(sf)
library(spData)
library(sp)
library(rnaturalearth)
library(rnaturalearthdata)


# Prep data for a count of destinations in the region --------------------------

df <- clean

# Get all countries in the region
v <- un_geo %>% filter(region == "Americas") %>% select(country)
v <- unlist(v$country, use.names = FALSE)

# Separate rows and filter to region
df <- df %>% separate_rows(destination_country, sep=", ")
df$destination_country <- trimws(df$destination_country)
df <- df %>% filter(!is.na(destination_country)) 
df <- df %>% filter(destination_country %in% v)

# Rename the US
# !! French Guiana not in the world_map dataset - add manually
df <- df %>% mutate_all(funs(str_replace_all(., "United States of America", 
                                             "United States"))) 

# Remove duplicates
df <- df %>% distinct(id, .keep_all = TRUE)

# Count the number of calls by country
df <- df %>% group_by(destination_country) %>% count() %>% ungroup()


# Prepare data for the map -----------------------------------------------------

world_map <- ne_countries(scale = "medium", returnclass = "sf") 


# Get country centroids for symbol position
sf::sf_use_s2(FALSE) # Turn off s2 to prevent spherical polygon errors
symbol_pos <- st_centroid(world_map, of_largest_polygon = TRUE)

# Merge in the centroids & filter out the NAs
df <- merge(symbol_pos, df, by.x="name_long", 
            by.y="destination_country", 
            all.x = TRUE)

df <- df %>% filter(!is.na(n))

# Get another layer for countries with calls
v2 <- unlist(df$name_long, use.names = FALSE)
map2 <- st_crop(world_map %>% filter(name_long %in% v2),
                xmin = -150, xmax = -30, ymin = -65, ymax = 85)

# Set bounding box for the map and data
map <- st_crop(world_map, xmin = -180, xmax = 25, ymin = -55, ymax = 85)


# Draw the map -----------------------------------------------------------------

map <- ggplot(map)+
  geom_sf()+
  geom_sf(data = map2, fill="#FFFFC0")+
  geom_sf(data = df,
          pch = 21,
          aes(size = n, fill = "red"),
          col = "grey20") +
  scale_size(
    range = c(2, 8),
    guide = guide_legend(
      direction = "horizontal",
      nrow = 1,
      label.position = "bottom")) +
  guides(fill = guide_legend(title = "")) +
  labs(title = "Number of calls by destination",
       size = "") +
  theme(legend.position = "bottom")

print(map)