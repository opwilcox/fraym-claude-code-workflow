#!/usr/bin/env Rscript
#' Example: Survey Analysis Workflow
#' 
#' This script demonstrates a complete survey analysis workflow:
#' 1. Load and prepare data
#' 2. Calculate national and sub-national statistics
#' 3. Create visualizations
#' 4. Save outputs

# Load required packages
library(tidyverse)
library(srvyr)
library(sf)

# Source utility functions
source("../utils/source_all.R")

# ============================================================================
# 1. LOAD AND PREPARE DATA
# ============================================================================

cat("Loading survey data...\n")

# Load survey microdata
# Replace with your actual data path
df <- read_csv("../data/survey-data.csv")

# Quick data check
cat("\nData dimensions:", nrow(df), "rows,", ncol(df), "columns\n")
cat("Weight column present:", "weight" %in% names(df), "\n")

# ============================================================================
# 2. CALCULATE NATIONAL STATISTICS
# ============================================================================

cat("\nCalculating national statistics...\n")

# Define indicators to analyze
indicators <- c("literacy_rate", "numeracy_rate", "school_enrollment")

# Calculate national-level statistics with confidence intervals
national_stats <- national_weighted_stats(
  df,
  indicator_cols = indicators,
  weight_col = "weight",
  ci = TRUE,
  ci_level = 0.95
)

# Display results
cat("\n=== National Statistics ===\n")
print(national_stats)

# Save to CSV
write_csv(national_stats, "output/national_statistics.csv")
cat("✓ Saved national statistics to output/national_statistics.csv\n")

# ============================================================================
# 3. CALCULATE SUB-NATIONAL STATISTICS
# ============================================================================

cat("\nCalculating regional statistics...\n")

# Calculate by admin level 1
regional_stats <- subnational_weighted_stats(
  df,
  indicator_col = "literacy_rate",
  groupby_cols = "adm1_name",
  weight_col = "weight",
  min_n = 30
)

# Flag small samples
small_samples <- regional_stats %>%
  filter(small_sample)

if (nrow(small_samples) > 0) {
  cat("\n⚠ Warning: Small samples in", nrow(small_samples), "regions:\n")
  print(small_samples$adm1_name)
}

# Display results
cat("\n=== Regional Statistics (Top 10) ===\n")
print(regional_stats %>% 
      arrange(desc(weighted_mean)) %>% 
      head(10))

# Save to CSV
write_csv(regional_stats, "output/regional_statistics.csv")
cat("✓ Saved regional statistics to output/regional_statistics.csv\n")

# ============================================================================
# 4. URBAN-RURAL COMPARISON
# ============================================================================

cat("\nCalculating urban-rural comparison...\n")

# Calculate by settlement type
urban_rural_stats <- subnational_weighted_stats(
  df,
  indicator_col = "literacy_rate",
  groupby_cols = "urban_rural",
  weight_col = "weight"
)

# Display results
cat("\n=== Urban-Rural Comparison ===\n")
print(urban_rural_stats)

# ============================================================================
# 5. CREATE VISUALIZATIONS
# ============================================================================

cat("\nCreating visualizations...\n")

# --- Bar Chart: Top 10 Regions ---
cat("  Creating bar chart...\n")

top_regions <- regional_stats %>%
  arrange(desc(weighted_mean)) %>%
  head(10)

bar_chart <- create_bar_chart(
  top_regions,
  x_col = "adm1_name",
  y_col = "weighted_mean",
  title = "Adult Literacy Rate - Top 10 Regions",
  ylabel = "Literacy Rate (%)",
  horizontal = TRUE,
  sort_values = FALSE  # Already sorted
)

save_fraym_plot(bar_chart, "output/top_regions_bar.png", width = 10, height = 8)
cat("✓ Saved bar chart to output/top_regions_bar.png\n")

# --- Map: Regional Literacy Rates ---
# Note: This requires boundary shapefile to be available

if (file.exists("../data/boundaries/admin1.shp")) {
  cat("  Creating choropleth map...\n")
  
  # Load boundaries
  boundaries <- st_read("../data/boundaries/admin1.shp", quiet = TRUE)
  
  # Join statistics to boundaries
  # Adjust join column names based on your data
  map_data <- boundaries %>%
    left_join(regional_stats, by = c("NAME" = "adm1_name"))
  
  # Create map
  literacy_map <- create_choropleth(
    map_data,
    value_col = "weighted_mean",
    title = "Adult Literacy Rate by Region",
    legend_label = "Literacy Rate (%)",
    palette = "sequential"
  )
  
  save_fraym_plot(literacy_map, "output/literacy_map.png", width = 12, height = 10)
  cat("✓ Saved map to output/literacy_map.png\n")
  
} else {
  cat("  ⚠ Skipping map (boundaries not found)\n")
}

# ============================================================================
# 6. CROSSTABULATION ANALYSIS
# ============================================================================

if ("gender" %in% names(df) && "education_level" %in% names(df)) {
  cat("\nCreating crosstabulation...\n")
  
  # Calculate crosstab
  ct <- weighted_crosstab(
    df,
    row_col = "education_level",
    col_col = "gender",
    value_col = "literacy_rate",
    weight_col = "weight",
    normalize = "row"
  )
  
  # Display results
  cat("\n=== Literacy Rate by Education and Gender ===\n")
  print(ct)
  
  # Save to CSV
  write_csv(ct, "output/crosstab_education_gender.csv")
  cat("✓ Saved crosstab to output/crosstab_education_gender.csv\n")
}

# ============================================================================
# 7. SUMMARY REPORT
# ============================================================================

cat("\n" , rep("=", 60), "\n", sep = "")
cat("ANALYSIS COMPLETE\n")
cat(rep("=", 60), "\n\n", sep = "")

cat("Outputs saved to work/output/:\n")
cat("  - national_statistics.csv\n")
cat("  - regional_statistics.csv\n")
cat("  - top_regions_bar.png\n")
if (file.exists("output/literacy_map.png")) {
  cat("  - literacy_map.png\n")
}
if (file.exists("output/crosstab_education_gender.csv")) {
  cat("  - crosstab_education_gender.csv\n")
}

cat("\nKey findings:\n")
cat("  National literacy rate:", 
    round(national_stats$weighted_mean[national_stats$indicator == "literacy_rate"], 1), "%\n")
cat("  Highest region:", 
    regional_stats$adm1_name[which.max(regional_stats$weighted_mean)], 
    "(", round(max(regional_stats$weighted_mean), 1), "%)\n")
cat("  Lowest region:", 
    regional_stats$adm1_name[which.min(regional_stats$weighted_mean)], 
    "(", round(min(regional_stats$weighted_mean), 1), "%)\n")

cat("\n✓ Analysis complete!\n")
