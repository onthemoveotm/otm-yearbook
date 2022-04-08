#-------------------------------------------------------------------------------
# Mapping no. calls by destination - Europe
#-------------------------------------------------------------------------------

library(sf)
library(spData)
library(sp)
library(rnaturalearth)
library(rnaturalearthdata)


# Prep data for a count of destinations in the region --------------------------

df <- clean

# Get all countries in the region
v <- un_geo %>% filter(region == "Europe") %>% select(country)
v <- unlist(v$country, use.names = FALSE)

# Separate rows and filter to region
df <- df %>% separate_rows(destination_country, sep=", ")
df$destination_country <- trimws(df$destination_country)
df <- df %>% filter(!is.na(destination_country)) 
df <- df %>% filter(destination_country %in% v)

# Rename Russia & North Macedonia
df <- df %>% mutate_all(funs(str_replace_all(., "Russia", "Russian Federation"))) %>% 
  mutate_all(funs(str_replace_all(., "North Macedonia", "Macedonia")))

# Remove duplicates
df <- df %>% distinct(id, .keep_all = TRUE)

# Count the number of calls by country
df <- df %>% group_by(destination_country) %>% count() %>% ungroup()


# Prepare data for the map -----------------------------------------------------

world_map <- ne_countries(scale = "medium", returnclass = "sf") 

# Get country centroids for symbol positions
# !! centres on largest polygon - screwy for Norway etc. 
sf::sf_use_s2(FALSE) # Turn off s2 to prevent spherical polygon errors
symbol_pos <- st_centroid(world_map, of_largest_polygon = TRUE)

# Recentre a few manually
symbol_pos$geometry[163] <- st_point(c(9, 61.5)) # Norway
symbol_pos$geometry[184] <- st_point(c(42, 57)) # Russia

# Merge in the centroids & filter out the NAs
df <- merge(symbol_pos, df, by.x="name_long", 
            by.y="destination_country", 
            all.x = TRUE)
df <- df %>% filter(!is.na(n))

# Get another layer for countries with calls
map2 <- st_crop(world_map %>% filter(name_long %in% v), xmin = -30, xmax = 50, ymin = 30, ymax = 75)

# Set bounding box for the map and data
map <- st_crop(world_map, xmin = -30, xmax = 50, ymin = 30, ymax = 75)


# Draw the map -----------------------------------------------------------------

map <- ggplot(map)+
  geom_sf()+
  geom_sf(data = map2, fill="#FFFFC0")+
  geom_sf(data = df,
          pch = 21,
          aes(size = n, fill = "red"),
          col = "grey20") +
  scale_size(
    range = c(1, 10),
    guide = guide_legend(
      direction = "horizontal",
      nrow = 1,
      label.position = "bottom")) +
  guides(fill = guide_legend(title = "")) +
  labs(title = "Number of calls by destination",
       sub = "European Union",
       size = "") +
  theme(legend.position = "bottom")


print(map)
