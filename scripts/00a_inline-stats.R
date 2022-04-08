#-------------------------------------------------------------------------------
# Working out some inline stats
#-------------------------------------------------------------------------------


# Art & Sciences calls ---------------------------------------------------------

# Prep data
df <- clean %>% separate_rows(topic, sep = ", ")
df$topic <- trimws(df$topic)
df <- df %>% filter(topic == "Art & Sciences")

# Look at Arts and Science calls by country/region of origin
per_artscience_de <- 100 / nrow(df) * 
  nrow(df %>% filter(str_detect(origin_country, "Germany")))
per_artscience_at <- 100 / nrow(df) * 
  nrow(df %>% filter(str_detect(origin_country, "Austria")))
per_artscience_eu_us <- 100 / nrow(df) * 
  nrow(df %>% filter(str_detect(origin_region, "Europe") | 
                       str_detect(origin_country, "United States of America") |
                       str_detect(origin_country, "Australia")))



# Digital calls in Japan -------------------------------------------------------

# How many digital calls from Asia originate in Japan
df <- clean
df <- df %>% filter(!is.na(mobility_type), 
                    !str_detect(mobility_type, "Travel"),
                    str_detect(origin_region, "Asia"))
per_digital_jp <- 100 / nrow(df) * nrow(df %>% filter(str_detect(origin_country, "Japan")))



# EU supported calls  ----------------------------------------------------------

# Number of distinct EU projects
df <- clean
num_euproject_calls <- nrow(df <- df %>% filter(!is.na(Project.Number)))
num_euprojects <- nrow(df %>% select(Project.Number) %>% unique())

# Overall percentage of EU calls
df <- clean
per_eucalls <- 100 / nrow(df) * 
  nrow (df %>% filter(str_detect(funding_source, "Cooperation|Networks|Erasmus+|Horizon|Other")))

# Percentage of EU calls among those organised in Europe
df <- clean %>% filter(str_detect(origin_region, "Europe"))
per_eucalls_europe <- 100 / nrow(df) * 
  nrow (df %>% filter(str_detect(funding_source, "Cooperation|Networks|Erasmus+|Horizon|Other")))

# Percentage of EU calls among those with destinations in Europe
df <- clean %>% filter(str_detect(destination_region, "Europe"))
per_eucalls_destination <- 100 / nrow(df) * 
  nrow(df %>% filter(str_detect(funding_source, "Cooperation|Networks|Erasmus+|Horizon|Other")))



# Intra regional traffic and EU cooperation projects  --------------------------

df <- clean %>% filter(str_detect(destination_region, "Europe"))

# Separate origin and destination sub-regions
df <- df %>% separate_rows(destination_subregion, sep = ", ") %>%
  separate_rows(origin_subregion, sep = ", ")
df$destination_subregion <- trimws(df$destination_subregion)
df$origin_subregion <- trimws(df$origin_subregion)

# Filter out the onlines and NAs
df <- df %>% filter(destination_subregion != "NA",
                    destination_subregion != "Online",
                    !is.na(destination_subregion),
                    origin_subregion != "NA",
                    !is.na(origin_subregion))

# Filter out the interegional
df <- df %>% filter(destination_subregion != origin_subregion)

# Filter to Europe subregions & remove duplicates
df <- df %>% filter(str_detect(destination_subregion, "Europe"),
                    str_detect(origin_subregion, "Europe"))
df <- df %>% distinct(id, .keep_all = TRUE)

# How many are cooperation projects?
per_coop_intra <- 100 / nrow(df) * nrow(df %>% filter(!is.na(Project.Number)))



# Destination countries --------------------------------------------------------

df <- clean %>% select(destination_country) %>% separate_rows(destination_country, sep=", ")
df$destination_country <- trimws(df$destination_country)
num_destination_countries <- df %>% filter(destination_country != "NA",
                    destination_country != "Africa") %>%
  distinct(destination_country)