#-------------------------------------------------------------------------------
# Time series - calls by date of posting
#-------------------------------------------------------------------------------


# Prep data and vars -----------------------------------------------------------

df <- clean 

# Make sure authored is in date format & floor to months
df$authored <- as.Date(df$authored, "%Y-%m-%d")
df$authored <- floor_date(df$authored, unit="month")

# Get counts by mobility type and month
df2 <- df %>% group_by(authored) %>% count(name="total")
df <- df %>% group_by(authored, mobility_type) %>% count(name="n")  
df <- merge(df, df2, by = "authored")  


# Draw the plot ----------------------------------------------------------------

plot <- ggplot(df, aes(x=authored, y=n)) + 
    geom_col(aes(fill=mobility_type)) + 
    scale_x_date(date_labels = "%b %Y",
                              limits = as.Date(c('2020-12-01','2022-01-01'))) +
    labs(title = "Number of calls by month",
         fill = "Mobility type") +
    scale_y_continuous(breaks = pretty_breaks(), 
                       limits=c(0,80)) +
    ylab("") + 
    xlab("") +
    theme(text=element_text(family="Peclet")) +
    # Use the OTM palette
    scale_fill_manual(values = otm_palettes$main) +
    scale_fill_manual(values = otm_palettes$main)
  
print(plot)