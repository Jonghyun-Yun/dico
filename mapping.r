  library(maps)
  library(mapdata)
  library(ggplot2)
  states <- map_data("state")
  counties <- map_data("county")

pred <- 1 * (pimp_rf$predictions[, 2] > 0.5)
df$mis <- 1 * (pred != y)
## df %>% filter(y > min(y))

fl_df <- subset(states, region == "florida")
fl_county <- subset(counties, region == "florida")

ditch_the_axes <- theme(
  axis.text = element_blank(),
  axis.line = element_blank(),
  axis.ticks = element_blank(),
  panel.border = element_blank(),
  panel.grid = element_blank(),
  axis.title = element_blank()
)

gg_base <- ggplot(data = fl_df, mapping = aes(x = long, y = lat, group = group)) +
  coord_fixed(1.3) +
  ## geom_polygon(color = "black", fill = "gray")
  geom_polygon(color = "black", fill = "white")

gg_base <- gg_base +
  geom_polygon(data = fl_county, fill = NA, color = "gray") +
  geom_polygon(color = "black", fill = NA)

load("col.pal.RData")
temp <- col.pal(10)
col_pal <- c(temp[1:2])

ov_map <- function(df, vname, colkey = cbPalette) {
  gg <- gg_base +
    geom_point(data = df, mapping = aes(x = x, y = y, group = var, colour = var), size = 4, alpha = 0.7) +
    scale_colour_manual(values = colkey) +
    labs(color = vname) +
    ## scale_fill_gradient2() +
    theme_bw() +
    ditch_the_axes +
    theme(
      text = element_text(size = 15),
      ## axis.title = element_text(size = 15),
      panel.grid.minor = element_blank(),
      panel.background = element_blank()
      ## panel.border = element_blank()
      ## panel.grid.major = element_blank()
    ) +
      theme(legend.key.size = unit(1, 'cm'), #change legend key size
        legend.key.height = unit(1, 'cm'), #change legend key height
        legend.key.width = unit(1, 'cm'), #change legend key width
        legend.title = element_text(size=30), #change legend title font size
        legend.text = element_text(size=20), #change legend text font size
      ## legend.position = "bottom")
      legend.position = c(0.3,0.5))
  print(gg)
  return(gg)
}

ov_cts_map <- function(df, vname, colkey = cbPalette,  autopick = TRUE, viridis = FALSE) {
  if (autopick) colkey = colkey[c(1, 2, 3, 4, 6)]
  gg <- gg_base +
    geom_point(data = df, mapping = aes(x = x, y = y, group = factor(var), color = var), size = 4, alpha = 0.7) +
    ## scale_colour_manual(values=cbPalette) +
    labs(color = vname) +
    #scale_color_continuous(type = "viridis")+
    #scale_color_gradientn(colors = colkey) +
    ## scale_fill_gradient2()+
    theme_bw() +
    ditch_the_axes +
    theme(
      text = element_text(size = 15),
      ## axis.title = element_text(size = 15),
      panel.grid.minor = element_blank(),
      panel.background = element_blank()
      ## panel.border = element_blank()
      ## panel.grid.major = element_blank()
    ) +
      theme(legend.key.size = unit(1, 'cm'), #change legend key size
        legend.key.height = unit(1, 'cm'), #change legend key height
        legend.key.width = unit(1, 'cm'), #change legend key width
        legend.title = element_text(size=30), #change legend title font size
        legend.text = element_text(size=20), #change legend text font size
        legend.position = c(0.3,0.5))
  if (viridis) gg = gg + scale_color_continuous(type = "viridis")
  else gg = gg + scale_color_gradientn(colors = colkey)
  print(gg)
  return(gg)
}

# The palette with grey:
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# The palette with black:
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# To use for fills, add
## scale_fill_manual(values=cbPalette)

# To use for line and point colors, add
## scale_colour_manual(values=cbPalette)
