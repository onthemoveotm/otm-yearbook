#-------------------------------------------------------------------------------
# Opportunity type breakdowns for artforms
#-------------------------------------------------------------------------------


# Prep data --------------------------------------------------------------------

df <- clean

# Sep multiple categories to new rows & filter out NAs
df <- separate_rows(df, opportunity_type, sep=",")
df$opportunity_type <- trimws(df$opportunity_type)
df <- df %>% filter(!opportunity_type == "NA")

df <- separate_rows(df, artform, sep=",")
df$artform <- trimws(df$artform)
df <- df %>% filter(!artform == "NA")


# Small multiples by artform ---------------------------------------------------

# Prep the variables to loop through
v1 <- c("Music & Sound", "Visual Arts & Design", "Literature", 
        "Cultural Heritage", "Performing Arts", "Digital / New Media",
        "Cross-disciplinary")
v2 <- c(paste0("plot", 1:7))


# Loop through and draw a plot for each filter
for (i in 1:length(v1)) {
  df2 <- df %>% filter(artform == v1[i])
  
  title <- df2$artform[1]
  subtitle <- "Type of calls by artform"

  plot <- ggplot(df2, aes(fct_rev(opportunity_type))) + 
    geom_bar(aes(fill = mobility_type, 
                 y = (..count..)/sum(..count..))) +
    coord_flip() +
  
  # Add counts
  geom_text(aes(y = ((..count..)/sum(..count..)), 
    label = scales::percent((..count..)/sum(..count..))), 
    stat = "count", hjust = -0.25) +
  
  # Add labels
    labs(title = v1[i],
         fill = "Mobility type") +  
  
  xlab("x axis") +
  ylab("y axis") +
  
  # Remove x axis bottom space, and pad the top
  scale_y_continuous(labels = percent,
    limits = c(0,1),
    expand = expansion(mult = c(0, .12))) +
    
  # Use the OTM theme with some variables
  theme_otm(subtitle = TRUE) +
  
  # Padding the plot on the right
  theme(plot.margin = margin(.5, 2, .5, .5, "cm"),
    panel.grid.major.y = element_blank())
  
  # Reverse order of legend values
  guides(fill = guide_legend(reverse = TRUE))

  assign(v2[i], plot)
}


# Display the plots in a grid --------------------------------------------------

# grid.arrange(plot1, plot2, plot3, plot4, ncol=2)
# grid.arrange(plot5, plot6, plot7, ncol=2)