#!/usr/bin/env Rscript
#' Fraym Color Palettes
#'
#' Centralized color constants for easy reference and consistency
#' across all Fraym visualizations.
#'
#' These palettes are loaded automatically when you run:
#'   source("utils/source_all.R")
#'
#' See docs/VISUAL_STANDARDS.md for complete specifications.

# ==============================================================================
# PRIMARY PALETTE
# ==============================================================================

FRAYM_PRIMARY <- list(
  dark_blue = "#00162b",
  electric_blue = "#202da5",
  teal = "#196160",
  aqua = "#1dd8b0",
  bright_green = "#94d931"
)

# ==============================================================================
# NEUTRAL PALETTE
# ==============================================================================

FRAYM_NEUTRAL <- list(
  charcoal = "#393e50",
  dark_gray = "#696b78",
  gray = "#d6d9dd",
  pale_gray = "#f2f2f2",
  dark_sand = "#8f9092",
  sand = "#d8d5ca",
  pale_sand = "#efeee8"
)

# ==============================================================================
# EXTENDED PALETTE
# ==============================================================================

FRAYM_EXTENDED <- list(
  purple = "#7152e2",
  dark_red = "#5b2036",
  red = "#d44244",
  orange = "#e8b934",
  yellow = "#efeb6a",
  dark_green = "#237d07"
)

# ==============================================================================
# SEQUENTIAL COLOR RAMPS (for maps and continuous data)
# ==============================================================================

FRAYM_SEQUENTIAL <- list(
  # General purpose - light to dark teal
  hello_darkness = c("#f2f2f2", "#1dd3b0", "#196160"),

  # High contrast - dark to light with multiple hues
  magma = c("#0b162b", "#7152e2", "#d44244", "#e8b934", "#efe6ba"),

  # Positive indicators - light to dark green
  go_green = c("#f2f2f2", "#94d931", "#257d07"),

  # Complex gradient - warm to cool
  off_grid = c("#efe6ba", "#94d931", "#1dd3b0", "#2024a5", "#196160", "#0b162b"),

  # Simple blue gradient
  candy_floss = c("#f2f2f2", "#2024a5"),

  # Grayscale (ONLY for B&W printing)
  grayscale = c("#ffffff", "#000000"),

  # Red gradient for intensity
  candy_apple = c("#efeee8", "#d44244", "#3b2036"),

  # Population data - blue tones
  population_blues = c("#f2f2f2", "#1dd3b0", "#196160", "#2024a5")
)

# ==============================================================================
# DIVERGENT COLOR RAMPS (for data with meaningful midpoint)
# ==============================================================================

FRAYM_DIVERGENT <- list(
  # Teal to beige
  sunshine = c("#196160", "#f2f2f2", "#efe6ba"),

  # Aqua to purple
  polar = c("#1dd3b0", "#f2f2f2", "#7152e2"),

  # Warm gradient
  peach_rings = c("#efeee8", "#efe6ba", "#e8b934", "#d44244"),

  # Red to aqua
  hot_and_cold = c("#d44244", "#393e80", "#1dd3b0"),

  # Purple gradient
  concord = c("#f2f2f2", "#7152e2", "#3b2036"),

  # Colorblind-friendly (PREFERRED for accessibility)
  colorblind_friendly = c("#2024a5", "#f2f2f2", "#d44244")
)

# ==============================================================================
# CHART-SPECIFIC PALETTES
# ==============================================================================

FRAYM_CHARTS <- list(
  # Single color for simple bar charts
  single_bar = "#196160",  # Teal

  # Two-color comparisons
  comparison_teal = c("#196160", "#1dd3b0"),
  comparison_gray = c("#393e50", "#d6d9dd"),

  # Opinion scales (5 levels: positive to negative)
  opinion_5 = c("#196160", "#1dd8b0", "#d6d9dd", "#e8b934", "#d44244"),

  # Intensity scales (5 levels: low to high)
  intensity_5 = c("#efe6ba", "#e8b934", "#e8763a", "#d44244", "#5b2036"),

  # Ranking scales (5 levels)
  rank_5 = c("#c8e6e5", "#7fcbc8", "#1dd3b0", "#196160", "#0b3938"),

  # Line charts (2 series)
  line_2 = c("#1dd8b0", "#d44244"),

  # Scatter plots
  scatter_primary = "#196160",
  scatter_neutral = "#d6d9dd"
)

# ==============================================================================
# COMBINED PALETTES OBJECT (for compatibility with visualization.R)
# ==============================================================================

# This structure matches what visualization.R expects
FRAYM_PALETTES <- list(
  sequential = FRAYM_SEQUENTIAL,
  divergent = FRAYM_DIVERGENT
)

# ==============================================================================
# UTILITY FUNCTIONS
# ==============================================================================

#' Display Available Color Ramps
#'
#' Print a summary of all available Fraym color schemes
#' @export
list_fraym_palettes <- function() {
  cat("=== FRAYM COLOR PALETTES ===\n\n")

  cat("PRIMARY COLORS:\n")
  for (name in names(FRAYM_PRIMARY)) {
    cat(sprintf("  %s: %s\n", name, FRAYM_PRIMARY[[name]]))
  }

  cat("\nSEQUENTIAL RAMPS (for maps):\n")
  for (name in names(FRAYM_SEQUENTIAL)) {
    colors <- FRAYM_SEQUENTIAL[[name]]
    cat(sprintf("  %s (%d colors)\n", name, length(colors)))
  }

  cat("\nDIVERGENT RAMPS (for maps with midpoint):\n")
  for (name in names(FRAYM_DIVERGENT)) {
    colors <- FRAYM_DIVERGENT[[name]]
    cat(sprintf("  %s (%d colors)\n", name, length(colors)))
  }

  cat("\nCHART PALETTES:\n")
  for (name in names(FRAYM_CHARTS)) {
    item <- FRAYM_CHARTS[[name]]
    n_colors <- if (is.list(item)) length(item) else length(item)
    cat(sprintf("  %s (%d color%s)\n", name, n_colors,
                if(n_colors > 1) "s" else ""))
  }

  cat("\nFor detailed specifications, see: docs/VISUAL_STANDARDS.md\n")
}


#' Preview a Color Palette
#'
#' Display colors in a palette (requires crayon package)
#' @param palette_name Name of palette to preview
#' @export
preview_palette <- function(palette_name) {
  # Find the palette
  palette <- NULL

  if (palette_name %in% names(FRAYM_SEQUENTIAL)) {
    palette <- FRAYM_SEQUENTIAL[[palette_name]]
    type <- "Sequential"
  } else if (palette_name %in% names(FRAYM_DIVERGENT)) {
    palette <- FRAYM_DIVERGENT[[palette_name]]
    type <- "Divergent"
  } else if (palette_name %in% names(FRAYM_CHARTS)) {
    palette <- FRAYM_CHARTS[[palette_name]]
    type <- "Chart"
  } else {
    stop(paste("Palette", palette_name, "not found"))
  }

  cat(sprintf("=== %s Palette: %s ===\n", type, palette_name))
  cat(sprintf("Colors: %s\n\n", paste(palette, collapse = " → ")))

  # Simple text preview
  for (i in seq_along(palette)) {
    cat(sprintf("  [%d] %s\n", i, palette[i]))
  }
}


#' Get a Fraym Color by Name
#'
#' Retrieve a specific color hex code
#' @param color_name Name of the color (e.g., "teal", "electric_blue")
#' @return Hex color code
#' @export
#'
#' @examples
#' get_fraym_color("teal")  # Returns "#196160"
get_fraym_color <- function(color_name) {
  # Search in all palettes
  if (color_name %in% names(FRAYM_PRIMARY)) {
    return(FRAYM_PRIMARY[[color_name]])
  } else if (color_name %in% names(FRAYM_NEUTRAL)) {
    return(FRAYM_NEUTRAL[[color_name]])
  } else if (color_name %in% names(FRAYM_EXTENDED)) {
    return(FRAYM_EXTENDED[[color_name]])
  } else {
    stop(paste("Color", color_name, "not found in Fraym palettes"))
  }
}


#' Get a Fraym Palette by Name
#'
#' Retrieve a vector of colors from a named palette
#' @param palette_name Name of the palette
#' @return Vector of hex color codes
#' @export
#'
#' @examples
#' get_fraym_palette("hello_darkness")
#' get_fraym_palette("colorblind_friendly")
get_fraym_palette <- function(palette_name) {
  if (palette_name %in% names(FRAYM_SEQUENTIAL)) {
    return(FRAYM_SEQUENTIAL[[palette_name]])
  } else if (palette_name %in% names(FRAYM_DIVERGENT)) {
    return(FRAYM_DIVERGENT[[palette_name]])
  } else if (palette_name %in% names(FRAYM_CHARTS)) {
    return(FRAYM_CHARTS[[palette_name]])
  } else {
    stop(paste("Palette", palette_name, "not found"))
  }
}

# ==============================================================================
# DOCUMENTATION
# ==============================================================================

# For detailed usage and examples, see:
# - docs/VISUAL_STANDARDS.md
# - docs/UTILITY_FUNCTIONS.md
# - examples/mapping_example.R
