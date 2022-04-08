#-------------------------------------------------------------------------------
# Looking at affordances of digital/hybrid calls
#-------------------------------------------------------------------------------


# Prep data --------------------------------------------------------------------

digital_labels <- read.xlsx("data/OTM_website-digital-hybrid-calls.xlsx")
digital_labels <- digital_labels %>% 
  unite('affordances', 2:23, sep="; ", remove = TRUE, na.rm = TRUE)


# Merge with main dataset
df <- merge(digital_labels, clean, 
            by = "id")

# Filter out the blank values
df <- df %>% filter(affordances != "")

# Get number of rows
v <- nrow(df)

# Separate rows
df <- df %>% separate_rows(affordances, sep = "; ")
df$affordances <- trimws(df$affordances)


# Draw a percentage bar plot ---------------------------------------------------

plot1 <- ggplot(df, aes(affordances))+geom_bar(aes(y = (..count..)/v))+
coord_flip()+

# Add counts
geom_text(aes(y = ((..count..)/v), 
  label = scales::percent((..count..)/v)), 
  stat = "count", hjust = -0.25)+

# Add labels
labs(title="Early polls are good indicators of how primaries will go",
  fill="Type of mobility",
  subtitle = "Candidates", 
  caption ="Source:")+

xlab("x axis")+
ylab("y axis")+

# Remove x axis bottom space, and pad the top
scale_y_continuous(labels = percent,
  expand = expansion(mult = c(0, .12)))+
  
# Use the OTM theme with some variables
theme_otm(subtitle = TRUE, legend_show = TRUE)+

# Padding the plot on the right
theme(plot.margin = margin(.5, 2, .5, .5, "cm"),
  panel.grid.major.y = element_blank())

plot1


# Draw a regular bar plot ------------------------------------------------------

plot2 <- ggplot(df, aes(affordances))+geom_bar(aes(fill=mobility_type))+
coord_flip()+

# Add counts
geom_text(aes(label=..count..),stat='count', hjust=-.5,size=3.3)+

# Add labels
labs(title="Affordances of online/remote and hybrid calls",
  fill="Type of mobility")+

xlab("")+
ylab("")+

 # Remove x axis bottom space, and pad the top
scale_y_continuous(expand = expansion(mult = c(0, .12)))+ 

# Use the OTM theme with some variables
theme_otm(subtitle = TRUE, legend_show = TRUE)+
  
# Use the OTM palette
scale_fill_manual(values = otm_palettes$main) +

# Padding the plot on the right
theme(plot.margin = margin(.5, 2, .5, .5, "cm"),
      panel.grid.major.x = element_line())

plot2

print(plot2)
