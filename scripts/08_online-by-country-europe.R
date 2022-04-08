#-------------------------------------------------------------------------------
# Looking at which European countries have more online/remote calls
#-------------------------------------------------------------------------------


# Prep data --------------------------------------------------------------------

df <- clean

# Look at countries with more than 20 calls ------------------------------------

df2 <- df %>% separate_rows(origin_country, sep=",")
df2$origin_country <- trimws(df2$origin_country)
df2 <- df2 %>% group_by(origin_country) %>% count()
v <- df2 %>% filter(n >= 20) %>% select(origin_country) %>% 
  unlist(use.names = FALSE)

df2 <- df %>% separate_rows(origin_country, sep=",")
df2$origin_country <- trimws(df2$origin_country)
df2 <- df2 %>% group_by(origin_country, mobility_type) %>% count()
df2 <- df2 %>% filter(origin_country %in% v)

# Take out the NAs

df2 <- df2 %>% filter(!is.na(mobility_type),
                      !is.na(origin_country),
                      origin_country != "NA")

df2 %>% group_by(origin_country)

# Filter to Europe

v <- un_geo %>% filter(region == "Europe") %>% select(country) %>% unlist()
df2 <- df2 %>% filter(origin_country %in% v)

# Add percentages 

df2 <- df2 %>% group_by(origin_country) %>% 
  mutate(per = round(100/sum(n) * n, digits = 1))


# Draw the bar plot ------------------------------------------------------------

f <- c("With Travel", "Mixed", "Online or Remote")

# Messy way to get the order

o <- df2 %>% filter(mobility_type == "With Travel") 
o <- arrange(o, per) %>% select(origin_country)
o <- unlist(o, use.names = FALSE)
o <- rev(o)

plot <- ggplot(df2, aes(
  y = per,
  x = fct_relevel(origin_country, o))) +
  geom_col(aes(fill = fct_relevel(mobility_type, f))) +
  coord_flip() +
  xlab("") +
  ylab("Percentage of calls") +
  labs(title = "Type of mobility for calls from European countries with more than 20 calls in 2021",
       fill ="Type of mobility")

print(plot)

# Output a table ---------------------------------------------------------------

table <- df2 %>%
  pivot_wider(names_from = mobility_type,
              id_cols = origin_country,
              values_from = per) 
