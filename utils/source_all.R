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
  "fraym_palettes.R",
  "survey_stats.R",
  "visualization.R",
  "spatial_skills.R"
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
cat("\nColor Palettes:\n")
cat("  - list_fraym_palettes() - Show all available palettes\n")
cat("  - get_fraym_color() - Get specific color by name\n")
cat("  - get_fraym_palette() - Get palette by name\n")
cat("  - FRAYM_PRIMARY, FRAYM_NEUTRAL, FRAYM_EXTENDED (lists)\n")
cat("  - FRAYM_SEQUENTIAL, FRAYM_DIVERGENT, FRAYM_CHARTS (lists)\n")
cat("\nSurvey Statistics:\n")
cat("  - national_weighted_stats()\n")
cat("  - subnational_weighted_stats()\n")
cat("  - weighted_crosstab()\n")
cat("  - time_series_stats()\n")
cat("  - calculate_design_effect()\n")
cat("\nVisualization:\n")
cat("  - create_choropleth()\n")
cat("  - create_raster_map()\n")
cat("  - create_bar_standard()\n")
cat("  - create_bar_horizontal()\n")
cat("  - create_bar_comparison()\n")
cat("  - create_bar_stacked()\n")
cat("  - create_line_chart()\n")
cat("  - create_scatter_plot()\n")
cat("  - save_fraym_plot()\n")
cat("\nfraymr API (requires infraym_login()):\n")
cat("  - fraym_login()               # authenticate\n")
cat("  - list_place_groups()         # list boundaries + IDs\n")
cat("  - download_place_group()      # download boundary by id -> sf\n")
cat("  - download_default_place_group() # download default boundary -> sf\n")
cat("  - download_country()          # national boundary -> sf\n")
cat("  - download_worldpop()         # population raster -> SpatRaster\n")
cat("  - list_surveys()              # list available surveys\n")
cat("  - get_survey_url()            # get survey download URL\n")
cat("  - calc_zonal_stats()          # aggregate raster by polygon\n")
cat("  - fraym_spatial_help()        # print this reference\n")
cat("\nReady to analyze!\n")
cat("Type list_fraym_palettes() to see available color schemes.\n")
