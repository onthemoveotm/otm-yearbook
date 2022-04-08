#-------------------------------------------------------------------------------
# Bar plot looking at online and offline calls
#-------------------------------------------------------------------------------


# Prep data --------------------------------------------------------------------

# Get data and filter out the NAs
df <- clean %>% filter(str_detect(destination_region, region_param) |
                          str_detect(origin_region, region_param))
df <- df %>% filter(!is.na(mobility_type))


# Draw the plot ----------------------------------------------------------------

print(
  ggplot(df, aes(forcats::fct_rev(forcats::fct_infreq(mobility_type)))) + 
  geom_bar(aes(y = (..count..)/sum(..count..))) +
    coord_flip() +

# Add counts
geom_text(aes(y = ((..count..)/sum(..count..)), 
  label = scales::percent((..count..)/sum(..count..))), 
  stat = "count", hjust = -0.25) +

# Add labels
labs(title="Mobility type for opportunities",
     fill="Type of mobility") +

xlab("") +
ylab("") +

# Remove x axis bottom space, and pad the top
scale_y_continuous(labels = percent,
  limits = c(0,1),
  expand = expansion(mult = c(0, .12))) +
  
# Use the OTM theme with some variables
theme_otm(subtitle = FALSE) +
  
# Use the OTM palette
scale_fill_manual(values = otm_palettes$main) +

# Pad the plot on the right
theme(plot.margin = margin(.5, 2, .5, .5, "cm"),
  panel.grid.major.y = element_blank())
)