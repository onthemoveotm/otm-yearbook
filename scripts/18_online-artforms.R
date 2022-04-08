#-------------------------------------------------------------------------------
# Looking at artforms for online calls
#-------------------------------------------------------------------------------


# Prep data --------------------------------------------------------------------

df <- clean

# Separate rows for multi-artform calls, remove NAs & filter to online/mixed

df <- df %>% separate_rows(artform, sep=", ") %>%
  filter(!is.na(artform),
         !str_detect(mobility_type, "Travel"))


# Draw a bar plot --------------------------------------------------------------

plot <- ggplot(df, aes(forcats::fct_rev(forcats::fct_infreq(artform)))) + 
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  coord_flip() +

# Add counts
geom_text(aes(y = ((..count..)/sum(..count..)), 
  label = scales::percent((..count..)/sum(..count..))), 
  stat = "count", hjust = -0.25)+

# Add labels
labs(title="Artforms for online/remote and hybrid calls",
  fill="Type of mobility")+

xlab("")+
ylab("")+

# Remove x axis bottom space, and pad the top
scale_y_continuous(labels = percent,
  limits = c(0,1),
  expand = expansion(mult = c(0, .1))) +
  
# Use the OTM theme with some variables
theme_otm(subtitle = TRUE) +

# Use the OTM palette
scale_fill_manual(values = otm_palettes$main) +
  
# Padding the plot on the right
theme(plot.margin = margin(.5, 2, .5, .5, "cm"),
  panel.grid.major.y = element_blank())

print(plot)