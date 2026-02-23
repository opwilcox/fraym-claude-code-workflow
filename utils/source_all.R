#!/usr/bin/env Rscript
#' Source All Utility Scripts
#'
#' Helper script to load all utility functions into your R session.
#'
#' Usage:
#'   source("../utils/source_all.R")  # from work/
#'   source("utils/source_all.R")     # from repo root

# Get the directory of this script
script_dir <- getSrcDirectory(function() {})
if (script_dir == "") {
  script_dir <- "utils"  # Default if run interactively
}

# Source all utility scripts
cat("Loading Fraym utility functions...\n")

utils_scripts <- c(
  "fraym_palettes.R",
  "explore.R",
  "survey.R",
  "visualization.R",
  "spatial.R"
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

cat("\nColor Palettes (fraym_palettes.R):\n")
cat("  FRAYM_PRIMARY, FRAYM_NEUTRAL, FRAYM_EXTENDED (lists)\n")
cat("  FRAYM_SEQUENTIAL, FRAYM_DIVERGENT, FRAYM_CHARTS (lists)\n")
cat("  list_fraym_palettes()  get_fraym_color()  get_fraym_palette()\n")

cat("\nData Exploration (explore.R):\n")
cat("  fraym_explore_package()   - list and summarize data package contents\n")
cat("  fraym_read_codebook()     - read codebook, print indicators by category\n")
cat("  fraym_summarize_training()- verify training data and weight column\n")
cat("  fraym_check_paths()       - file.exists() check on all configured paths\n")

cat("\nSurvey Statistics (survey.R):\n")
cat("  national_weighted_stats()     subnational_weighted_stats()\n")
cat("  weighted_crosstab()           time_series_stats()\n")
cat("  calculate_design_effect()\n")

cat("\nVisualization (visualization.R):\n")
cat("  create_choropleth()    create_raster_map()    create_bar_standard()\n")
cat("  create_bar_horizontal() create_bar_comparison() create_bar_stacked()\n")
cat("  create_line_chart()    create_scatter_plot()   save_fraym_plot()\n")

cat("\nfraymr API (spatial.R) — requires infraym_login():\n")
cat("  fraym_login()                  list_place_groups()\n")
cat("  download_place_group()         download_default_place_group()\n")
cat("  download_country()             download_worldpop()\n")
cat("  list_surveys()                 get_survey_url()\n")
cat("  calc_zonal_stats()             fraym_spatial_help()\n")

cat("\nReady to analyze!\n")
