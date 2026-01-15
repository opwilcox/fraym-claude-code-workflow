#!/usr/bin/env Rscript
#' Source All Utility Scripts
#' 
#' Helper script to load all utility functions into your R session.
#' 
#' Usage:
#'   source("utils/source_all.R")
#' 
#' Or from within utils/:
#'   source("source_all.R")

# Get the directory of this script
script_dir <- getSrcDirectory(function() {})
if (script_dir == "") {
  script_dir <- "utils"  # Default if run interactively
}

# Source all utility scripts
cat("Loading Fraym utility functions...\n")

utils_scripts <- c(
  "survey_stats.R",
  "visualization.R"
)

for (script in utils_scripts) {
  script_path <- file.path(script_dir, script)
  if (file.exists(script_path)) {
    source(script_path)
    cat("✓ Loaded:", script, "\n")
  } else {
    warning("Could not find:", script_path)
  }
}

cat("\nAvailable functions:\n")
cat("Survey Statistics:\n")
cat("  - national_weighted_stats()\n")
cat("  - subnational_weighted_stats()\n")
cat("  - weighted_crosstab()\n")
cat("  - time_series_stats()\n")
cat("  - calculate_design_effect()\n")
cat("\nVisualization:\n")
cat("  - create_choropleth()\n")
cat("  - create_raster_map()\n")
cat("  - create_bar_chart()\n")
cat("  - create_line_chart()\n")
cat("  - save_fraym_plot()\n")
cat("\nColor Schemes:\n")
cat("  - FRAYM_COLORS (list)\n")
cat("  - FRAYM_PALETTES (list)\n")
cat("\nReady to analyze!\n")
