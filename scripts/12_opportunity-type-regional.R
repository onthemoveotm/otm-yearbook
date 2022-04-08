#-------------------------------------------------------------------------------
# Bar plot and table for opportunity types
#-------------------------------------------------------------------------------


# Prep data --------------------------------------------------------------------

df <- clean %>% filter(str_detect(destination_region, region_param) |
                         str_detect(origin_region, region_param))

# Sep multiple categories to new rows & filter out NAs

df <- separate_rows(df, opportunity_type, sep=",")
df$opportunity_type <- trimws(df$opportunity_type)
df <- df %>% filter(!opportunity_type == "NA")


# Draw the plot ----------------------------------------------------------------

print(
ggplot(df, aes(fct_rev(fct_infreq(opportunity_type)))) + 
  geom_bar(aes(fill=mobility_type)) +
  coord_flip() +

# Add counts
geom_text(aes(label=paste0(..count.., " (", round(100/nrow(df) * ..count.., digits = 1), "%)")), 
          stat='count', 
          hjust=-.1, 
          size=3.3) +

# Add labels
labs(title="Number of opportunities by type",
  fill="Type of mobility") +

xlab("") +
ylab("") +

# Remove x axis bottom space, and pad the top
scale_y_continuous(expand = expansion(mult = c(0, .25))) + 

# Use the OTM theme with some variables
theme_otm(subtitle = FALSE, legend_show = TRUE) +

# Use the OTM palette
scale_fill_manual(values = otm_palettes$main) +

# Padding the plot on the right
theme(plot.margin = margin(.5, 2, .5, .5, "cm"),
      panel.grid.major.y = element_blank(),
      panel.grid.major.x = element_blank(),
      legend.position = "bottom") +

# Reverse order of legend values
guides(fill = guide_legend(reverse = TRUE))
)


# Create a table breakdown -----------------------------------------------------

df <- clean

# Sep multiple categories to new rows & filter out NAs
df <- separate_rows(df, opportunity_type, sep=",")
df$opportunity_type <- trimws(df$opportunity_type)
df <- df %>% filter(!opportunity_type == "NA")

# Do category counts & calculate percentages
df <- df %>% group_by(opportunity_type, mobility_type) %>% count(name="n")
df <- df %>% group_by(opportunity_type) %>% mutate(per = 100 / sum(n) * n)
df$per <- round(df$per, digits = 1)
df$per <- paste0(df$per, "%")

# Rearrange the table layout 
table <- df %>% pivot_wider(names_from = mobility_type,
                            id_cols = opportunity_type,
                            values_from = per) %>%
  rename("Opportunity Type" = opportunity_type)