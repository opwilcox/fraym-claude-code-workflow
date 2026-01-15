#!/usr/bin/env Rscript
#' Example: Mapping Workflow
#' 
#' This script demonstrates creating publication-ready maps:
#' 1. Choropleth maps from survey data
#' 2. Raster maps with boundary overlays
#' 3. Combining multiple maps

# Load required packages
library(tidyverse)
library(sf)
library(terra)

# Source utility functions
source("../utils/source_all.R")

# ============================================================================
# 1. CHOROPLETH MAP FROM SURVEY DATA
# ============================================================================

cat("Creating choropleth map from survey data...\n")

# Load survey data
df <- read_csv("../data/survey-data.csv")

# Calculate regional statistics
regional_stats <- subnational_weighted_stats(
  df,
  indicator_col = "literacy_rate",
  groupby_cols = "adm1_name",
  weight_col = "weight"
)

# Load administrative boundaries
boundaries <- st_read("../data/boundaries/admin1.shp", quiet = TRUE)

# Join statistics to boundaries
# Note: Adjust join columns based on your data
map_data <- boundaries %>%
  left_join(regional_stats, by = c("NAME" = "adm1_name"))

# Create choropleth map
literacy_map <- create_choropleth(
  map_data,
  value_col = "weighted_mean",
  title = "Adult Literacy Rate by Region",
  legend_label = "Literacy Rate (%)",
  palette = "sequential",
  n_breaks = 5
)

# Save
save_fraym_plot(
  literacy_map, 
  "output/literacy_choropleth.png",
  width = 12,
  height = 10,
  dpi = 300
)

cat("✓ Saved: output/literacy_choropleth.png\n\n")

# ============================================================================
# 2. DIVERGING CHOROPLETH (GAP FROM NATIONAL AVERAGE)
# ============================================================================

cat("Creating diverging choropleth map...\n")

# Calculate gap from national average
national_mean <- mean(regional_stats$weighted_mean, na.rm = TRUE)

map_data_gap <- map_data %>%
  mutate(gap = weighted_mean - national_mean)

# Create diverging map
gap_map <- create_choropleth(
  map_data_gap,
  value_col = "gap",
  title = "Literacy Rate Gap from National Average",
  legend_label = "Percentage Points",
  palette = "diverging"
)

save_fraym_plot(
  gap_map,
  "output/literacy_gap_map.png",
  width = 12,
  height = 10
)

cat("✓ Saved: output/literacy_gap_map.png\n\n")

# ============================================================================
# 3. RASTER MAP WITH BOUNDARIES
# ============================================================================

if (file.exists("../data/raster/population_density.tif")) {
  cat("Creating raster map...\n")
  
  # Create raster map with boundary overlay
  raster_map <- create_raster_map(
    "../data/raster/population_density.tif",
    title = "Population Density",
    legend_label = "Persons per km²",
    palette = "sequential",
    boundaries_sf = boundaries
  )
  
  save_fraym_plot(
    raster_map,
    "output/population_density_map.png",
    width = 12,
    height = 10
  )
  
  cat("✓ Saved: output/population_density_map.png\n\n")
  
} else {
  cat("⚠ Raster file not found, skipping raster map example\n\n")
}

# ============================================================================
# 4. MULTIPLE INDICATOR MAPS (SMALL MULTIPLES)
# ============================================================================

cat("Creating small multiples map...\n")

# Calculate statistics for multiple indicators
indicators <- c("literacy_rate", "numeracy_rate", "school_enrollment")

multi_stats <- map_dfr(indicators, function(ind) {
  subnational_weighted_stats(
    df,
    indicator_col = ind,
    groupby_cols = "adm1_name",
    weight_col = "weight"
  ) %>%
    mutate(indicator = ind)
})

# Create individual maps
maps_list <- map(indicators, function(ind) {
  
  # Filter and join data
  ind_data <- multi_stats %>%
    filter(indicator == ind)
  
  map_data_ind <- boundaries %>%
    left_join(ind_data, by = c("NAME" = "adm1_name"))
  
  # Create map
  create_choropleth(
    map_data_ind,
    value_col = "weighted_mean",
    title = str_to_title(str_replace_all(ind, "_", " ")),
    legend_label = "Rate (%)",
    palette = "sequential"
  )
})

# Combine maps using patchwork
library(patchwork)

combined_map <- wrap_plots(maps_list, ncol = 2) +
  plot_annotation(
    title = "Education Indicators by Region",
    theme = theme(plot.title = element_text(size = 16, face = "bold", hjust = 0.5))
  )

save_fraym_plot(
  combined_map,
  "output/education_indicators_multiples.png",
  width = 14,
  height = 12
)

cat("✓ Saved: output/education_indicators_multiples.png\n\n")

# ============================================================================
# 5. MAP WITH CUSTOM STYLING
# ============================================================================

cat("Creating custom styled map...\n")

# Create base map
custom_map <- ggplot(map_data) +
  geom_sf(aes(fill = weighted_mean), color = "white", size = 0.5) +
  scale_fill_gradientn(
    colors = c("#FEF0D9", "#FDCC8A", "#FC8D59", "#E34A33", "#B30000"),
    name = "Literacy\nRate (%)",
    limits = c(40, 100),
    breaks = seq(40, 100, by = 20)
  ) +
  labs(
    title = "Adult Literacy Rate by Region",
    subtitle = "2024 Survey Results",
    caption = "Source: Fraym Education Survey 2024\nNote: Darker colors indicate higher literacy rates"
  ) +
  theme_void() +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5, margin = margin(b = 5)),
    plot.subtitle = element_text(size = 12, hjust = 0.5, margin = margin(b = 10)),
    plot.caption = element_text(size = 9, hjust = 0, margin = margin(t = 10)),
    legend.position = "right",
    legend.title = element_text(size = 11, face = "bold"),
    plot.margin = margin(20, 20, 20, 20)
  )

save_fraym_plot(
  custom_map,
  "output/literacy_custom_styled.png",
  width = 12,
  height = 10
)

cat("✓ Saved: output/literacy_custom_styled.png\n\n")

# ============================================================================
# SUMMARY
# ============================================================================

cat(rep("=", 60), "\n", sep = "")
cat("MAPPING WORKFLOW COMPLETE\n")
cat(rep("=", 60), "\n\n", sep = "")

cat("Maps created:\n")
cat("  1. literacy_choropleth.png - Basic choropleth\n")
cat("  2. literacy_gap_map.png - Diverging map (gap from average)\n")
if (file.exists("output/population_density_map.png")) {
  cat("  3. population_density_map.png - Raster with boundaries\n")
}
cat("  4. education_indicators_multiples.png - Small multiples\n")
cat("  5. literacy_custom_styled.png - Custom styled map\n")

cat("\nAll maps saved to work/output/\n")
cat("All maps use Fraym color schemes and styling standards\n\n")

cat("✓ Workflow complete!\n")
