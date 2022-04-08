#-------------------------------------------------------------------------------
# Sankey graph of regional and sub-regional call flows - origin to destination
#-------------------------------------------------------------------------------

library(networkD3)

# Look at flow by region -------------------------------------------------------

df <- clean

# Reseparate region and subregion rows

df <- df %>% separate_rows(origin_region)
df$origin_region <- trimws(df$origin_region)

df <- df %>% separate_rows(destination_region)
df$destination_region <- trimws(df$destination_region)

# Remove NAs, count and reorder

df <- df %>% filter(destination_region != "NA")
df <- df %>% filter(origin_region != "NA")

counts <- df %>% group_by(origin_region, destination_region) %>% count()
counts <- counts %>% arrange(desc(n))

# Create the sankey nodes

# !! Got to be a neater / reusable way of doing nodes and links here

nodes <- c("Africa", "Asia", "Americas","Europe","Oceania", "Africa", "Asia", "Americas","Europe","Oceania", "Online")
nodes <- as.data.frame(nodes) %>% rename("regions" = nodes)

# Create the links and add the IDs

links <- counts
links$IDsource = NA
links$IDsource = ifelse(grepl("Africa",links$origin_region),"0",links$IDsource)
links$IDsource = ifelse(grepl("Asia",links$origin_region),"1",links$IDsource)
links$IDsource = ifelse(grepl("Americas",links$origin_region),"2",links$IDsource)
links$IDsource = ifelse(grepl("Europe",links$origin_region),"3",links$IDsource)
links$IDsource = ifelse(grepl("Oceania",links$origin_region),"4",links$IDsource)
links <- add_column(links, IDtarget = NA)
links$IDtarget = ifelse(grepl("Africa",links$destination_region),"5",links$IDtarget)
links$IDtarget = ifelse(grepl("Asia",links$destination_region),"6",links$IDtarget)
links$IDtarget = ifelse(grepl("Americas",links$destination_region),"7",links$IDtarget)
links$IDtarget = ifelse(grepl("Europe",links$destination_region),"8",links$IDtarget)
links$IDtarget = ifelse(grepl("Oceania",links$destination_region),"9",links$IDtarget)
links$IDtarget = ifelse(grepl("Online",links$destination_region),"10",links$IDtarget)
links$IDsource <- as.numeric(links$IDsource)
links$IDtarget <- as.numeric(links$IDtarget)
links <- as.data.frame(links)

# Draw an ugly sankey

plot1 <-  sankeyNetwork(Links = links, Nodes = nodes,
                    Source = "IDsource", Target = "IDtarget",
                    Value = "n", NodeID = "regions",
                    sinksRight=FALSE, nodeWidth=20, fontSize=13,
                    margin = 0
)

plot1


# Save the widget

library(htmlwidgets)
saveWidget(plot1, file=paste0("output/region-sankey1.html"))


# Create a matrix

matrix1 <- pivot_wider(counts, names_from = destination_region,
                      id_cols = origin_region, 
                      values_from = n)

matrix1 <- matrix1 %>% arrange(origin_region) %>% 
  select(order(colnames(.))) %>% 
  column_to_rownames("origin_region")



# Look at flow by sub-region - Africa ------------------------------------------

df <- clean

# Reseparate region and subregion rows

df <- df %>% separate_rows(origin_subregion, sep = ", ")
df$origin_subregion <- trimws(df$origin_subregion)

df <- df %>% separate_rows(destination_subregion, sep = ", ")
df$destination_subregion <- trimws(df$destination_subregion)

# Remove NAs, relabel non Africa subregions, count and reorder

df <- df %>% filter(destination_subregion != "NA")
df <- df %>% filter(origin_subregion != "NA")
df$destination_subregion = ifelse(!grepl("Africa|Online",df$destination_subregion),
                                  "Other Regions",df$destination_subregion)
df$origin_subregion = ifelse(!grepl("Africa|Online",df$origin_subregion),
                             "Other Regions",df$origin_subregion)

counts <- df %>% group_by(origin_subregion, destination_subregion) %>% count()
counts <- counts %>% arrange(desc(n))

# Filter to Africa origin 

# remove Other Regions to Other Regions and online flow
counts <- counts %>% filter(origin_subregion != "Other Regions" | destination_subregion != "Other Regions")
counts <- counts %>% filter(origin_subregion != "Other Regions" | destination_subregion != "Online")


# Create the sankey nodes

nodes <- c("Northern Africa", "Sub-Saharan Africa", "Other Regions",
           "Northern Africa", "Sub-Saharan Africa", "Online", 
           "Other Regions")
nodes <- as.data.frame(nodes) %>% rename("regions" = nodes)

# Create the links and add the IDs

links <- counts
links$IDsource = NA
links$IDsource = ifelse(grepl("Northern Africa",links$origin_subregion),"0",links$IDsource)
links$IDsource = ifelse(grepl("Sub-Saharan Africa",links$origin_subregion),"1",links$IDsource)
links$IDsource = ifelse(grepl("Other Regions",links$origin_subregion),"2",links$IDsource)
links <- add_column(links, IDtarget = NA)
links$IDtarget = ifelse(grepl("Northern Africa",links$destination_subregion),"3",links$IDtarget)
links$IDtarget = ifelse(grepl("Sub-Saharan Africa",links$destination_subregion),"4",links$IDtarget)
links$IDtarget = ifelse(grepl("Online",links$destination_subregion),"5",links$IDtarget)
links$IDtarget = ifelse(grepl("Other Regions",links$destination_subregion),"6",links$IDtarget)
links$IDsource <- as.numeric(links$IDsource)
links$IDtarget <- as.numeric(links$IDtarget)
links <- as.data.frame(links)

# Draw an ugly sankey

plot2 <-  sankeyNetwork(Links = links, Nodes = nodes,
                        Source = "IDsource", Target = "IDtarget",
                        Value = "n", NodeID = "regions",
                        sinksRight=FALSE, nodeWidth=20, fontSize=13,
                        margin = 0
)

plot2


# Save the widget

library(htmlwidgets)
saveWidget(plot2, file=paste0( "output/region-sankey2.html"))

# Create a matrix

matrix2 <- pivot_wider(counts, names_from = destination_subregion,
                       id_cols = origin_subregion,
                       values_from = n)

matrix2 <- matrix2 %>% arrange(origin_subregion) %>% 
  select(order(colnames(.))) %>% 
  column_to_rownames("origin_subregion")



# Look at flow by sub-region - Asia ------------------------------------------

df <- clean

# Reseparate region and subregion rows

df <- df %>% separate_rows(origin_subregion, sep = ", ")
df$origin_subregion <- trimws(df$origin_subregion)

df <- df %>% separate_rows(destination_subregion, sep = ", ")
df$destination_subregion <- trimws(df$destination_subregion)

# Remove NAs, relabel non Asia subregions, count and reorder

df <- df %>% filter(destination_subregion != "NA")
df <- df %>% filter(origin_subregion != "NA")
df$destination_subregion = ifelse(!grepl("Asia|Online",df$destination_subregion),
                                  "Other Regions",df$destination_subregion)
df$origin_subregion = ifelse(!grepl("Asia|Online",df$origin_subregion),"Other Regions",df$origin_subregion)

counts <- df %>% group_by(origin_subregion, destination_subregion) %>% count()
counts <- counts %>% arrange(desc(n))

# Filter to Asia origin 

# remove Other Regions to Other Regions and online flow
counts <- counts %>% filter(origin_subregion != "Other Regions" | destination_subregion != "Other Regions")
counts <- counts %>% filter(origin_subregion != "Other Regions" | destination_subregion != "Online")


# Create the sankey nodes

nodes <- c("Eastern Asia", "South-eastern Asia", "Southern Asia", "Western Asia",
           "Other Regions",
           "Eastern Asia", "South-eastern Asia", "Southern Asia", "Western Asia",
           "Online", "Other Regions")
nodes <- as.data.frame(nodes) %>% rename("regions" = nodes)

# Create the links and add the IDs

links <- counts
links$IDsource = NA
links$IDsource = ifelse(grepl("Eastern Asia",links$origin_subregion),"0",links$IDsource)
links$IDsource = ifelse(grepl("South-eastern Asia",links$origin_subregion),"1",links$IDsource)
links$IDsource = ifelse(grepl("Southern Asia",links$origin_subregion),"2",links$IDsource)
links$IDsource = ifelse(grepl("Western Asia",links$origin_subregion),"3",links$IDsource)
links$IDsource = ifelse(grepl("Other Regions",links$origin_subregion),"4",links$IDsource)
links <- add_column(links, IDtarget = NA)
links$IDtarget = ifelse(grepl("Eastern Asia",links$destination_subregion),"5",links$IDtarget)
links$IDtarget = ifelse(grepl("South-eastern Asia",links$destination_subregion),"6",links$IDtarget)
links$IDtarget = ifelse(grepl("Southern Asia",links$destination_subregion),"7",links$IDtarget)
links$IDtarget = ifelse(grepl("Western Asia",links$destination_subregion),"8",links$IDtarget)
links$IDtarget = ifelse(grepl("Online",links$destination_subregion),"9",links$IDtarget)
links$IDtarget = ifelse(grepl("Other Regions",links$destination_subregion),"10",links$IDtarget)
links$IDsource <- as.numeric(links$IDsource)
links$IDtarget <- as.numeric(links$IDtarget)
links <- as.data.frame(links)

# Draw an ugly sankey

plot3 <-  sankeyNetwork(Links = links, Nodes = nodes,
                        Source = "IDsource", Target = "IDtarget",
                        Value = "n", NodeID = "regions",
                        sinksRight=FALSE, nodeWidth=20, fontSize=13,
                        margin = 0
)

plot3


# Save the widget

library(htmlwidgets)
saveWidget(plot3, file=paste0( "output/region-sankey3.html"))


# Create a matrix

matrix3 <- pivot_wider(counts, names_from = destination_subregion,
                       id_cols = origin_subregion, 
                       values_from = n)

matrix3 <- matrix3 %>% arrange(origin_subregion) %>% 
  select(order(colnames(.))) %>% 
  column_to_rownames("origin_subregion")



# Look at flow by sub-region - Americas ----------------------------------------

df <- clean

# Reseparate region and subregion rows

df <- df %>% separate_rows(origin_subregion, sep = ", ")
df$origin_subregion <- trimws(df$origin_subregion)

df <- df %>% separate_rows(destination_subregion, sep = ", ")
df$destination_subregion <- trimws(df$destination_subregion)

# Remove NAs, relabel non Americas subregions, count and reorder

df <- df %>% filter(destination_subregion != "NA")
df <- df %>% filter(origin_subregion != "NA")
df$destination_subregion = ifelse(!grepl("America|Online", df$destination_subregion),
                                  "Other Regions", df$destination_subregion)
df$origin_subregion = ifelse(!grepl("America|Online", df$origin_subregion),
                             "Other Regions", df$origin_subregion)

counts <- df %>% group_by(origin_subregion, destination_subregion) %>% count()
counts <- counts %>% arrange(desc(n))

# Filter to Americas origin 

# remove Other Regions to Other Regions and online flow
counts <- counts %>% filter(origin_subregion != "Other Regions" | destination_subregion != "Other Regions")
counts <- counts %>% filter(origin_subregion != "Other Regions" | destination_subregion != "Online")


# Create the sankey nodes

nodes <- c("Northern America", "Latin America and the Caribbean", "Other Regions",
           "Northern America", "Latin America and the Caribbean", "Online", 
           "Other Regions")
nodes <- as.data.frame(nodes) %>% rename("regions" = nodes)

# Create the links and add the IDs

links <- counts
links$IDsource = NA
links$IDsource = ifelse(grepl("Northern America",links$origin_subregion),"0",links$IDsource)
links$IDsource = ifelse(grepl("Latin America and the Caribbean",links$origin_subregion),"1",links$IDsource)
links$IDsource = ifelse(grepl("Other Regions",links$origin_subregion),"2",links$IDsource)
links <- add_column(links, IDtarget = NA)
links$IDtarget = ifelse(grepl("Northern America",links$destination_subregion),"3",links$IDtarget)
links$IDtarget = ifelse(grepl("Latin America and the Caribbean",links$destination_subregion),"4",links$IDtarget)
links$IDtarget = ifelse(grepl("Online",links$destination_subregion),"5",links$IDtarget)
links$IDtarget = ifelse(grepl("Other Regions",links$destination_subregion),"6",links$IDtarget)
links$IDsource <- as.numeric(links$IDsource)
links$IDtarget <- as.numeric(links$IDtarget)
links <- as.data.frame(links)

# Draw an ugly sankey

plot4 <-  sankeyNetwork(Links = links, Nodes = nodes,
                        Source = "IDsource", Target = "IDtarget",
                        Value = "n", NodeID = "regions",
                        sinksRight=FALSE, nodeWidth=20, fontSize=13,
                        margin = 0
)

plot4


# Save the widget

library(htmlwidgets)
saveWidget(plot4, file=paste0( "output/region-sankey4.html"))


# Create a matrix

matrix4 <- pivot_wider(counts, names_from = destination_subregion,
                       id_cols = origin_subregion, 
                       values_from = n)

matrix4 <- matrix4 %>% arrange(origin_subregion) %>% 
  select(order(colnames(.))) %>% 
  column_to_rownames("origin_subregion")



# Look at flow by sub-region - Europe ------------------------------------------

df <- clean

# Reseparate region and subregion rows

df <- df %>% separate_rows(origin_subregion, sep = ", ")
df$origin_subregion <- trimws(df$origin_subregion)

df <- df %>% separate_rows(destination_subregion, sep = ", ")
df$destination_subregion <- trimws(df$destination_subregion)

# Remove NAs, relabel non euro subregions, count and reorder

df <- df %>% filter(destination_subregion != "NA")
df <- df %>% filter(origin_subregion != "NA")
df$destination_subregion = ifelse(!grepl("Europe|Online",df$destination_subregion),"Other Regions",df$destination_subregion)
df$origin_subregion = ifelse(!grepl("Europe|Online",df$origin_subregion),"Other Regions",df$origin_subregion)

counts <- df %>% group_by(origin_subregion, destination_subregion) %>% count()
counts <- counts %>% arrange(desc(n))

# remove Other Regions to Other Regions and online flow

counts <- counts %>% filter(origin_subregion != "Other Regions" | destination_subregion != "Other Regions")
counts <- counts %>% filter(origin_subregion != "Other Regions" | destination_subregion != "Online")

# Create the sankey nodes

nodes <- c("Northern Europe", "Eastern Europe", "Southern Europe", "Western Europe",
           "Other Regions",
           "Northern Europe", "Eastern Europe", "Southern Europe", "Western Europe",
           "Online", "Other Regions")
nodes <- as.data.frame(nodes) %>% rename("regions" = nodes)

# Create the links and add the IDs

links <- counts
links$IDsource = NA
links$IDsource = ifelse(grepl("Northern Europe",links$origin_subregion),"0",links$IDsource)
links$IDsource = ifelse(grepl("Eastern Europe",links$origin_subregion),"1",links$IDsource)
links$IDsource = ifelse(grepl("Southern Europe",links$origin_subregion),"2",links$IDsource)
links$IDsource = ifelse(grepl("Western Europe",links$origin_subregion),"3",links$IDsource)
links$IDsource = ifelse(grepl("Other Regions",links$origin_subregion),"4",links$IDsource)
links <- add_column(links, IDtarget = NA)
links$IDtarget = ifelse(grepl("Northern Europe",links$destination_subregion),"5",links$IDtarget)
links$IDtarget = ifelse(grepl("Eastern Europe",links$destination_subregion),"6",links$IDtarget)
links$IDtarget = ifelse(grepl("Southern Europe",links$destination_subregion),"7",links$IDtarget)
links$IDtarget = ifelse(grepl("Western Europe",links$destination_subregion),"8",links$IDtarget)
links$IDtarget = ifelse(grepl("Online",links$destination_subregion),"9",links$IDtarget)
links$IDtarget = ifelse(grepl("Other Regions",links$destination_subregion),"10",links$IDtarget)
links$IDsource <- as.numeric(links$IDsource)
links$IDtarget <- as.numeric(links$IDtarget)
links <- as.data.frame(links)

# Draw an ugly sankey

plot5 <-  sankeyNetwork(Links = links, Nodes = nodes,
                        Source = "IDsource", Target = "IDtarget",
                        Value = "n", NodeID = "regions",
                        sinksRight=FALSE, nodeWidth=20, fontSize=13,
                        margin = 0
)

plot5


# Save the widget

library(htmlwidgets)
saveWidget(plot5, file=paste0( "output/region-sankey5.html"))


# Create a matrix

matrix5 <- pivot_wider(counts, names_from = destination_subregion,
                       id_cols = origin_subregion, 
                       values_from = n)

matrix5 <- matrix5 %>% arrange(origin_subregion) %>% 
  select(order(colnames(.))) %>% 
  column_to_rownames("origin_subregion")