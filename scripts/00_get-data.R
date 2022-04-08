#-------------------------------------------------------------------------------
# Load libraries & functions, get and clean OTM data
#-------------------------------------------------------------------------------

# Libraries
library(openxlsx)
library(tidyverse)
library(extrafont)
library(grid)
library(gridExtra)
library(devtools)
library(scales)
library(lubridate)
library(forcats)
library(kableExtra)


# Prepare OTM data -------------------------------------------------------------

# Get the OTM style function & colours
source_url("https://raw.githubusercontent.com/onthemoveotm/otmplottools/main/R/styles/otm-theme.R")
source_url("https://raw.githubusercontent.com/onthemoveotm/otmplottools/main/R/styles/otm-colors.R")

# Load in the OTM website data
clean <- readWorkbook("data/OTM_website-data.xlsx", detectDates = TRUE)

# OTM sometimes posts exceptional calls that don't match editorial policy
# Get IDs for these (marked as NA) and filter out of the data
# df <- clean %>% filter(str_detect(notes, "\\[NA\\]")) 
# df <- unlist(df$id, use.names = FALSE)
# clean <- clean %>% filter(!id %in% df)

# Do some relabelling for clearer category names
clean$mobility_type <- gsub("With Travel, Online or Remote", "Mixed", 
                            clean$mobility_type)
clean$mobility_type <- gsub("Online or Remote, With Travel", "Mixed", 
                            clean$mobility_type)
clean$target_scope <- gsub("Organisations & Collectives, Individuals", "Both", 
                           clean$target_scope)
clean$target_scope <- gsub("Individuals, Organisations & Collectives", "Both", 
                           clean$target_scope)

# Roll a couple of categories together 
clean$artform <- gsub("Film", "Visual Arts & Design", clean$artform)
clean$target_type <- gsub("Policymakers|Researchers & Critics", 
                          "Policymakers & Researchers & Critics", 
                           clean$target_type)

# Concatenate country of origin and remove duplicate rows
clean <- clean %>% group_by(id) %>%
  mutate(origin_country = paste(origin_country, collapse=", ")) %>% 
  distinct() %>% ungroup()

# Concatenate news type and remove duplicate rows
clean <- clean %>% group_by(id) %>%
  mutate(opportunity_type = paste(opportunity_type, collapse=", ")) %>% 
  distinct() %>% ungroup()

# Narrow on our desired date range - 2021
startdate <- as.Date("2021-01-01")
enddate <- as.Date("2021-12-31")
clean <- clean %>% filter(authored >= startdate & authored <= enddate)


# Get Creative Europe data -----------------------------------------------------

# Get the data on Creative Europe projects
creative_europe_projects <- read.xlsx("data/CREATIVE-EUROPE_project-funding_2021-12-28.xlsx",
                                      detectDates = TRUE)

# Add EU Project Numbers to relevant calls in the OTM data
df <- readWorkbook("data/EU-OTM_project-ids.xlsx") 
df <- df %>% select(organisation, Project.Number)
clean <- merge(clean, df, by="organisation", all.x = TRUE)


# Get UN geo data --------------------------------------------------------------

un_geo <- read_csv("data/UN_geoscheme.csv")

# Rename some useful columns, then select these
un_geo <- un_geo %>% rename(region = "Region Name", 
                            sub_region = "Sub-region Name",
                            intermediate_region = "Intermediate Region Name",
                            iso2 = "ISO-alpha2 Code",
                            country= "Country or Area") %>%
  select(region, sub_region, intermediate_region, iso2, country) 

# Rename some of the countries
un_geo$country <- gsub("Czechia", "Czech Republic", 
                       un_geo$country)
un_geo$country <- gsub("United Kingdom of Great Britain and Northern Ireland", "United Kingdom", 
                       un_geo$country)
un_geo$country <- gsub("Republic of Korea", "South Korea", 
                       un_geo$country)
un_geo$country <- gsub("Russian Federation", "Russia", 
                       un_geo$country)
un_geo$country <- gsub("State of Palestine", "Palestine", 
                       un_geo$country)

# Add Kosovo, Taiwan and Hong Kong
un_geo <- un_geo %>% add_row(region = "Europe", sub_region = "Southern Europe", 
                  intermediate_region = "",
                  iso2 = "XK", country = "Kosovo") %>%
  add_row(region = "Asia", sub_region = "Eastern Asia", 
          intermediate_region = "",
          iso2 = "TW", country = "Taiwan") %>%
  add_row(region = "Asia", sub_region = "Eastern Asia", 
          intermediate_region = "",
          iso2 = "HK", country = "Hong Kong")

# Get list of countries with Creeative Europe status and merge that in
df <- read.xlsx("data/EU_creative-europe-countries.xlsx")

un_geo <- merge(un_geo, df, by.x="country", 
                by.y="country",
                all.x = TRUE)


# Merge UN geo & OTM data to get regions and sub regions for calls -------------

# Add for origin countries
clean <- clean %>% separate_rows(origin_country, sep =", ")
clean$origin_country <- trimws(clean$origin_country)

clean <- merge(clean, un_geo %>% select(country, region, sub_region),
               by.x="origin_country", by.y="country",
               all.x = TRUE) %>% rename(origin_region = region,
                                        origin_subregion = sub_region)

# Reconcatenate and remove duplicates
clean <- clean %>% group_by(id) %>%
  distinct(id, origin_country, .keep_all = TRUE) %>%
  mutate(origin_country = paste(origin_country, collapse=", ")) %>% 
  distinct(id, origin_subregion, .keep_all = TRUE) %>%
  mutate(origin_subregion = paste(origin_subregion, collapse=", ")) %>%
  distinct(id, origin_region, .keep_all = TRUE) %>%
  mutate(origin_region = paste(origin_region, collapse=", "))

# Add for destination countries
clean <- clean %>% separate_rows(destination_country, sep =", ")
clean$destination_country <- trimws(clean$destination_country)

clean <- merge(clean, un_geo %>% select(country, region, sub_region),
               by.x="destination_country", by.y="country",
               all.x = TRUE) %>% rename(destination_region = region,
                                        destination_subregion = sub_region)

# Add an online destination for online / mixed calls
clean$online_destination = NA
clean$online_destination = ifelse(grepl("Mixed|Online or Remote", clean$mobility_type), 
                                  "Online", clean$online_destination)

clean <- clean %>% group_by(id) %>%
  distinct(id, destination_country, .keep_all = TRUE) %>%
  mutate(destination_country = paste(destination_country, collapse=", ")) %>% 
  distinct(id, destination_subregion, .keep_all = TRUE) %>%
  mutate(destination_subregion = paste0(destination_subregion, ", ", 
                                        online_destination, collapse=", ")) %>%
  distinct(id, destination_region, .keep_all = TRUE) %>%
  mutate(destination_region =  paste0(destination_region, ", ", 
                                      online_destination, collapse=", ")) %>%
  distinct(id, .keep_all = TRUE) %>%
  ungroup()