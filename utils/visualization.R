#!/usr/bin/env Rscript
#' Visualization Utilities
#'
#' Functions for creating publication-ready charts and maps following Fraym standards.
#' Based on Fraym Visualization Guide February 2025

library(tidyverse)
library(sf)
library(scales)

# ==============================================================================
# FRAYM COLOR SCHEMES
# ==============================================================================

# Primary Palette
FRAYM_COLORS <- list(
  dark_blue = "#00162b",
  electric_blue = "#202da5",
  teal = "#196160",
  aqua = "#1dd8b0",
  bright_green = "#94d931"
)

# Neutral Palette
FRAYM_NEUTRALS <- list(
  charcoal = "#393e50",
  dark_gray = "#696b78",
  gray = "#d6d9dd",
  pale_gray = "#f2f2f2",
  dark_sand = "#8f9092",
  sand = "#d8d5ca",
  pale_sand = "#efeee8"
)

# Extended Palette
FRAYM_EXTENDED <- list(
  purple = "#7152e2",
  dark_red = "#5b2036",
  red = "#d44244",
  orange = "#e8b934",
  yellow = "#efeb6a",
  dark_green = "#237d07"
)

# Color Ramps for Maps
FRAYM_RAMPS <- list(
  # Sequential Ramps
  hello_darkness = c("#f2f2f2", "#1dd3b0", "#196160"),
  magma = c("#0b162b", "#7152e2", "#d44244", "#e8b934", "#efe6ba"),
  go_green = c("#f2f2f2", "#94d931", "#257d07"),
  off_grid = c("#efe6ba", "#94d931", "#1dd3b0", "#2024a5", "#196160", "#0b162b"),
  candy_floss = c("#f2f2f2", "#2024a5"),
  grayscale = c("#ffffff", "#000000"),
  candy_apple = c("#efeee8", "#d44244", "#3b2036"),
  population_blues = c("#f2f2f2", "#1dd3b0", "#196160", "#2024a5"),

  # Divergent Ramps
  sunshine = c("#196160", "#f2f2f2", "#efe6ba"),
  polar = c("#1dd3b0", "#f2f2f2", "#7152e2"),
  peach_rings = c("#efeee8", "#efe6ba", "#e8b934", "#d44244"),
  hot_and_cold = c("#d44244", "#393e80", "#1dd3b0"),
  concord = c("#f2f2f2", "#7152e2", "#3b2036"),
  colorblind_friendly = c("#2024a5", "#f2f2f2", "#d44244")
)

# Chart color palettes
FRAYM_CHART_PALETTES <- list(
  # For bar charts - use teal as primary
  single_bar = FRAYM_COLORS$teal,

  # For comparison bars - teal and aqua
  comparison_teal = c(FRAYM_COLORS$teal, FRAYM_COLORS$aqua),

  # For comparison bars - grays
  comparison_gray = c(FRAYM_NEUTRALS$charcoal, FRAYM_NEUTRALS$gray),

  # For stacked bars - opinion scale (5 levels)
  opinion_5 = c(FRAYM_COLORS$teal, FRAYM_COLORS$aqua, FRAYM_NEUTRALS$gray,
                FRAYM_EXTENDED$orange, FRAYM_EXTENDED$red),

  # For stacked bars - intensity scale (5 levels)
  intensity_5 = c("#efe6ba", "#e8b934", "#e8763a", "#d44244", "#5b2036"),

  # For stacked bars - rank scale (5 levels)
  rank_5 = c("#c8e6e5", "#7fcbc8", "#1dd3b0", "#196160", "#0b3938"),

  # For line charts
  line_2 = c(FRAYM_COLORS$aqua, FRAYM_EXTENDED$red),

  # For scatter plots
  scatter_primary = FRAYM_COLORS$teal,
  scatter_neutral = FRAYM_NEUTRALS$gray
)

# ==============================================================================
# MAP FUNCTIONS
# ==============================================================================

#' Create Choropleth Map
#'
#' @param sf_data sf object with geometries and values
#' @param value_col Column name containing values to map
#' @param title Map title (optional, if legend explains the map)
#' @param subtitle Map subtitle (optional)
#' @param legend_title Label for legend
#' @param ramp_name Name of color ramp from FRAYM_RAMPS (default: "hello_darkness")
#' @param custom_ramp Optional custom color vector (overrides ramp_name)
#' @param boundary_color Color for boundary lines (default: "white")
#' @param boundary_size Size of boundary lines (default: 0.3)
#' @return ggplot object
#' @export
#'
#' @examples
#' map <- create_choropleth(admin_sf, "literacy_rate",
#'                          legend_title = "Literacy Rate (%)",
#'                          ramp_name = "population_blues")
create_choropleth <- function(sf_data,
                             value_col,
                             title = NULL,
                             subtitle = NULL,
                             legend_title = NULL,
                             ramp_name = "hello_darkness",
                             custom_ramp = NULL,
                             boundary_color = "white",
                             boundary_size = 0.3) {

  if (is.null(legend_title)) {
    legend_title <- value_col
  }

  # Get color ramp
  if (!is.null(custom_ramp)) {
    colors <- custom_ramp
  } else if (ramp_name %in% names(FRAYM_RAMPS)) {
    colors <- FRAYM_RAMPS[[ramp_name]]
  } else {
    warning(paste("Ramp", ramp_name, "not found. Using hello_darkness."))
    colors <- FRAYM_RAMPS$hello_darkness
  }

  # Create map
  p <- ggplot(sf_data) +
    geom_sf(aes(fill = .data[[value_col]]),
            color = boundary_color,
            linewidth = boundary_size) +
    scale_fill_gradientn(
      colors = colors,
      name = legend_title,
      na.value = "grey90"
    ) +
    theme_void() +
    theme(
      plot.title = element_text(size = 16, face = "bold", hjust = 0,
                                margin = margin(b = 5)),
      plot.subtitle = element_text(size = 10, color = "gray40",
                                   hjust = 0, margin = margin(b = 10)),
      legend.position = "bottom",
      legend.title = element_text(size = 10, face = "bold"),
      legend.text = element_text(size = 9),
      legend.key.width = unit(2, "cm"),
      legend.key.height = unit(0.4, "cm"),
      plot.margin = margin(10, 10, 10, 10)
    )

  if (!is.null(title)) {
    p <- p + labs(title = title)
  }

  if (!is.null(subtitle)) {
    p <- p + labs(subtitle = subtitle)
  }

  return(p)
}


#' Create Raster Map with Optional Boundary Overlay
#'
#' @param raster_file Path to raster file (or terra SpatRaster object)
#' @param title Map title (optional, if legend explains the map)
#' @param subtitle Map subtitle (optional)
#' @param legend_title Label for legend
#' @param ramp_name Name of color ramp from FRAYM_RAMPS (default: "hello_darkness")
#' @param custom_ramp Optional custom color vector (overrides ramp_name)
#' @param boundaries_sf Optional sf object with boundaries to overlay
#' @param boundary_color Color for boundaries (default: "black")
#' @param boundary_size Size for boundaries (default: 0.5)
#' @return ggplot object
#' @export
#'
#' @examples
#' map <- create_raster_map("data/elevation.tif",
#'                          legend_title = "Elevation (m)",
#'                          boundaries_sf = admin_boundaries,
#'                          ramp_name = "magma")
create_raster_map <- function(raster_file,
                             title = NULL,
                             subtitle = NULL,
                             legend_title = "Value",
                             ramp_name = "hello_darkness",
                             custom_ramp = NULL,
                             boundaries_sf = NULL,
                             boundary_color = "black",
                             boundary_size = 0.5) {

  library(terra)

  # Read raster if file path provided
  if (is.character(raster_file)) {
    r <- rast(raster_file)
  } else {
    r <- raster_file
  }

  # Convert to data frame for plotting
  raster_df <- as.data.frame(r, xy = TRUE)
  colnames(raster_df) <- c("x", "y", "value")

  # Get color ramp
  if (!is.null(custom_ramp)) {
    colors <- custom_ramp
  } else if (ramp_name %in% names(FRAYM_RAMPS)) {
    colors <- FRAYM_RAMPS[[ramp_name]]
  } else {
    warning(paste("Ramp", ramp_name, "not found. Using hello_darkness."))
    colors <- FRAYM_RAMPS$hello_darkness
  }

  # Create base map
  p <- ggplot() +
    geom_raster(data = raster_df, aes(x = x, y = y, fill = value)) +
    scale_fill_gradientn(
      colors = colors,
      name = legend_title,
      na.value = "transparent"
    ) +
    coord_equal() +
    theme_void() +
    theme(
      plot.title = element_text(size = 16, face = "bold", hjust = 0,
                                margin = margin(b = 5)),
      plot.subtitle = element_text(size = 10, color = "gray40",
                                   hjust = 0, margin = margin(b = 10)),
      legend.position = "bottom",
      legend.title = element_text(size = 10, face = "bold"),
      legend.text = element_text(size = 9),
      legend.key.width = unit(2, "cm"),
      legend.key.height = unit(0.4, "cm"),
      plot.margin = margin(10, 10, 10, 10)
    )

  # Add boundaries if provided
  if (!is.null(boundaries_sf)) {
    p <- p + geom_sf(data = boundaries_sf, fill = NA,
                     color = boundary_color, linewidth = boundary_size)
  }

  if (!is.null(title)) {
    p <- p + labs(title = title)
  }

  if (!is.null(subtitle)) {
    p <- p + labs(subtitle = subtitle)
  }

  return(p)
}

# ==============================================================================
# BAR CHART FUNCTIONS
# ==============================================================================

#' Create Standard Bar Chart
#'
#' Matches "Bar Standard" template from Fraym Viz Guide
#'
#' @param data Data frame
#' @param x_col Column for x-axis (categories)
#' @param y_col Column for y-axis (values)
#' @param title Chart title (optional)
#' @param subtitle Chart subtitle (optional)
#' @param xlabel X-axis label (optional)
#' @param ylabel Y-axis label (optional)
#' @param sort_values Sort bars by value descending (default: TRUE)
#' @param show_values Show value labels on bars (default: TRUE)
#' @param value_format Format string for values (default: "%.0f%%")
#' @return ggplot object
#' @export
create_bar_standard <- function(data,
                               x_col,
                               y_col,
                               title = NULL,
                               subtitle = NULL,
                               xlabel = NULL,
                               ylabel = NULL,
                               sort_values = TRUE,
                               show_values = TRUE,
                               value_format = "%.0f%%") {

  # Sort if requested
  if (sort_values) {
    data <- data |> arrange(desc(.data[[y_col]]))
    data[[x_col]] <- factor(data[[x_col]], levels = data[[x_col]])
  }

  # Create plot
  p <- ggplot(data, aes(x = .data[[x_col]], y = .data[[y_col]])) +
    geom_col(fill = FRAYM_CHART_PALETTES$single_bar, width = 0.7) +
    theme_minimal() +
    theme(
      plot.title = element_text(size = 14, face = "bold", hjust = 0),
      plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0),
      axis.title.x = element_text(size = 11, margin = margin(t = 10)),
      axis.title.y = element_text(size = 11, margin = margin(r = 10)),
      axis.text = element_text(size = 10),
      axis.text.x = element_text(angle = 0, hjust = 0.5),
      panel.grid.major.x = element_blank(),
      panel.grid.major.y = element_line(color = "gray90", linewidth = 0.5),
      panel.grid.minor = element_blank(),
      plot.background = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "#f7f7f7", color = NA)
    ) +
    labs(x = xlabel, y = ylabel)

  # Add value labels
  if (show_values) {
    p <- p + geom_text(aes(label = sprintf(value_format, .data[[y_col]])),
                      vjust = -0.5, size = 3.5, fontface = "bold")
  }

  if (!is.null(title)) p <- p + labs(title = title)
  if (!is.null(subtitle)) p <- p + labs(subtitle = subtitle)

  return(p)
}


#' Create Horizontal Bar Chart for Long Categories
#'
#' Matches "Bar Long Categories" template from Fraym Viz Guide
#'
#' @param data Data frame
#' @param x_col Column for x-axis (values)
#' @param y_col Column for y-axis (categories)
#' @param title Chart title (optional)
#' @param subtitle Chart subtitle (optional)
#' @param xlabel X-axis label (optional)
#' @param ylabel Y-axis label (optional)
#' @param sort_values Sort bars by value descending (default: TRUE)
#' @param show_values Show value labels on bars (default: TRUE)
#' @param value_format Format string for values (default: "%.0f%%")
#' @return ggplot object
#' @export
create_bar_horizontal <- function(data,
                                 x_col,
                                 y_col,
                                 title = NULL,
                                 subtitle = NULL,
                                 xlabel = NULL,
                                 ylabel = NULL,
                                 sort_values = TRUE,
                                 show_values = TRUE,
                                 value_format = "%.0f%%") {

  # Sort if requested (ascending for horizontal so largest is on top)
  if (sort_values) {
    data <- data |> arrange(.data[[x_col]])
    data[[y_col]] <- factor(data[[y_col]], levels = data[[y_col]])
  }

  # Create plot
  p <- ggplot(data, aes(x = .data[[x_col]], y = .data[[y_col]])) +
    geom_col(fill = FRAYM_CHART_PALETTES$single_bar, width = 0.7) +
    theme_minimal() +
    theme(
      plot.title = element_text(size = 14, face = "bold", hjust = 0),
      plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0),
      axis.title.x = element_text(size = 11, margin = margin(t = 10)),
      axis.title.y = element_text(size = 11, margin = margin(r = 10)),
      axis.text = element_text(size = 10),
      panel.grid.major.x = element_line(color = "gray90", linewidth = 0.5),
      panel.grid.major.y = element_blank(),
      panel.grid.minor = element_blank(),
      plot.background = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "#f7f7f7", color = NA)
    ) +
    labs(x = xlabel, y = ylabel)

  # Add value labels
  if (show_values) {
    p <- p + geom_text(aes(label = sprintf(value_format, .data[[x_col]])),
                      hjust = -0.2, size = 3.5, fontface = "bold",
                      color = FRAYM_COLORS$teal)
  }

  if (!is.null(title)) p <- p + labs(title = title)
  if (!is.null(subtitle)) p <- p + labs(subtitle = subtitle)

  return(p)
}


#' Create Grouped Bar Chart for Comparison
#'
#' Matches "Bar Comparison" templates from Fraym Viz Guide
#'
#' @param data Data frame in long format with group column
#' @param x_col Column for x-axis (categories)
#' @param y_col Column for y-axis (values)
#' @param group_col Column for grouping (creates separate bars)
#' @param title Chart title (optional)
#' @param subtitle Chart subtitle (optional)
#' @param xlabel X-axis label (optional)
#' @param ylabel Y-axis label (optional)
#' @param colors Color scheme: "teal", "gray", or custom vector (default: "teal")
#' @param show_values Show value labels on bars (default: TRUE)
#' @param value_format Format string for values (default: "%.0f%%")
#' @return ggplot object
#' @export
create_bar_comparison <- function(data,
                                 x_col,
                                 y_col,
                                 group_col,
                                 title = NULL,
                                 subtitle = NULL,
                                 xlabel = NULL,
                                 ylabel = NULL,
                                 colors = "teal",
                                 show_values = TRUE,
                                 value_format = "%.0f%%") {

  # Get colors
  if (length(colors) == 1 && colors == "teal") {
    color_vals <- FRAYM_CHART_PALETTES$comparison_teal
  } else if (length(colors) == 1 && colors == "gray") {
    color_vals <- FRAYM_CHART_PALETTES$comparison_gray
  } else {
    color_vals <- colors
  }

  # Create plot
  p <- ggplot(data, aes(x = .data[[x_col]], y = .data[[y_col]],
                        fill = .data[[group_col]])) +
    geom_col(position = position_dodge(width = 0.8), width = 0.7) +
    scale_fill_manual(values = color_vals) +
    theme_minimal() +
    theme(
      plot.title = element_text(size = 14, face = "bold", hjust = 0),
      plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0),
      axis.title = element_text(size = 11),
      axis.text = element_text(size = 10),
      axis.text.x = element_text(angle = 0, hjust = 0.5),
      legend.position = "none",
      panel.grid.major.x = element_blank(),
      panel.grid.major.y = element_line(color = "gray90", linewidth = 0.5),
      panel.grid.minor = element_blank(),
      plot.background = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "#f7f7f7", color = NA)
    ) +
    labs(x = xlabel, y = ylabel)

  # Add value labels
  if (show_values) {
    p <- p + geom_text(aes(label = sprintf(value_format, .data[[y_col]])),
                      position = position_dodge(width = 0.8),
                      vjust = -0.5, size = 3.5, fontface = "bold")
  }

  if (!is.null(title)) p <- p + labs(title = title)
  if (!is.null(subtitle)) p <- p + labs(subtitle = subtitle)

  return(p)
}


#' Create Stacked Bar Chart
#'
#' Generic stacked bar chart function for opinion scales, intensity scales, ranks, etc.
#' Matches stacked bar templates from Fraym Viz Guide
#'
#' @param data Data frame in long format with category and group columns
#' @param x_col Column for x-axis (time periods or categories)
#' @param y_col Column for y-axis (values)
#' @param fill_col Column for fill (creates stacks)
#' @param title Chart title (optional)
#' @param subtitle Chart subtitle (optional)
#' @param xlabel X-axis label (optional)
#' @param ylabel Y-axis label (optional)
#' @param palette Palette name: "opinion_5", "intensity_5", "rank_5", or custom vector
#' @param horizontal Create horizontal stacked bars (default: FALSE)
#' @param show_values Show value labels in bars (default: TRUE)
#' @param value_threshold Minimum value to show label (default: 10)
#' @return ggplot object
#' @export
create_bar_stacked <- function(data,
                              x_col,
                              y_col,
                              fill_col,
                              title = NULL,
                              subtitle = NULL,
                              xlabel = NULL,
                              ylabel = NULL,
                              palette = "opinion_5",
                              horizontal = FALSE,
                              show_values = TRUE,
                              value_threshold = 10) {

  # Get colors
  if (length(palette) == 1 && palette %in% names(FRAYM_CHART_PALETTES)) {
    colors <- FRAYM_CHART_PALETTES[[palette]]
  } else {
    colors <- palette
  }

  # Create base plot
  if (horizontal) {
    p <- ggplot(data, aes(x = .data[[y_col]], y = .data[[x_col]],
                          fill = .data[[fill_col]])) +
      geom_col(position = "stack", width = 0.8) +
      theme(axis.text.x = element_text(angle = 0))
  } else {
    p <- ggplot(data, aes(x = .data[[x_col]], y = .data[[y_col]],
                          fill = .data[[fill_col]])) +
      geom_col(position = "stack", width = 0.8) +
      theme(axis.text.x = element_text(angle = 0, hjust = 0.5))
  }

  # Apply styling
  p <- p +
    scale_fill_manual(values = colors) +
    theme_minimal() +
    theme(
      plot.title = element_text(size = 14, face = "bold", hjust = 0),
      plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0),
      axis.title = element_text(size = 11),
      axis.text = element_text(size = 10),
      legend.position = "right",
      legend.title = element_blank(),
      legend.text = element_text(size = 9),
      panel.grid.major = element_line(color = "gray90", linewidth = 0.5),
      panel.grid.minor = element_blank(),
      plot.background = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "#f7f7f7", color = NA)
    ) +
    labs(x = xlabel, y = ylabel)

  # Add value labels
  if (show_values) {
    # Only show labels for values above threshold
    data_labels <- data |>
      filter(.data[[y_col]] >= value_threshold)

    if (horizontal) {
      p <- p + geom_text(data = data_labels,
                        aes(label = .data[[y_col]]),
                        position = position_stack(vjust = 0.5),
                        size = 3, color = "white", fontface = "bold")
    } else {
      p <- p + geom_text(data = data_labels,
                        aes(label = .data[[y_col]]),
                        position = position_stack(vjust = 0.5),
                        size = 3, color = "white", fontface = "bold")
    }
  }

  if (!is.null(title)) p <- p + labs(title = title)
  if (!is.null(subtitle)) p <- p + labs(subtitle = subtitle)

  return(p)
}

# ==============================================================================
# LINE CHART FUNCTIONS
# ==============================================================================

#' Create Line Chart for Change Over Time
#'
#' Matches "Line: Change Over Time" template from Fraym Viz Guide
#'
#' @param data Data frame with time series data
#' @param x_col Column for x-axis (time)
#' @param y_cols Column(s) for y-axis (values) - can be vector for multiple lines
#' @param title Chart title (optional)
#' @param subtitle Chart subtitle (optional)
#' @param xlabel X-axis label (optional)
#' @param ylabel Y-axis label (optional)
#' @param colors Line colors (default: Fraym line palette)
#' @param line_size Line thickness (default: 1.5)
#' @param show_points Show points at data values (default: TRUE)
#' @param point_size Size of points (default: 3)
#' @param legend_labels Custom legend labels (optional)
#' @return ggplot object
#' @export
create_line_chart <- function(data,
                             x_col,
                             y_cols,
                             title = NULL,
                             subtitle = NULL,
                             xlabel = NULL,
                             ylabel = NULL,
                             colors = NULL,
                             line_size = 1.5,
                             show_points = TRUE,
                             point_size = 3,
                             legend_labels = NULL) {

  # Default colors
  if (is.null(colors)) {
    if (length(y_cols) == 2) {
      colors <- FRAYM_CHART_PALETTES$line_2
    } else {
      colors <- c(FRAYM_COLORS$aqua, FRAYM_EXTENDED$red, FRAYM_COLORS$bright_green,
                  FRAYM_EXTENDED$purple, FRAYM_EXTENDED$orange)
    }
  }

  # Reshape data for multiple series
  if (length(y_cols) > 1) {
    plot_data <- data |>
      select(all_of(c(x_col, y_cols))) |>
      pivot_longer(
        cols = all_of(y_cols),
        names_to = "series",
        values_to = "value"
      )

    # Apply custom labels if provided
    if (!is.null(legend_labels)) {
      plot_data <- plot_data |>
        mutate(series = factor(series, levels = y_cols, labels = legend_labels))
    }

    p <- ggplot(plot_data, aes(x = .data[[x_col]], y = value,
                               color = series, group = series))
  } else {
    p <- ggplot(data, aes(x = .data[[x_col]], y = .data[[y_cols]]))
  }

  # Add lines
  if (length(y_cols) > 1) {
    p <- p + geom_line(linewidth = line_size)
    if (show_points) {
      p <- p + geom_point(size = point_size)
    }
    p <- p + scale_color_manual(values = colors)
  } else {
    p <- p +
      geom_line(color = colors[1], linewidth = line_size)
    if (show_points) {
      p <- p + geom_point(color = colors[1], size = point_size)
    }
  }

  # Apply theme
  p <- p +
    theme_minimal() +
    theme(
      plot.title = element_text(size = 14, face = "bold", hjust = 0),
      plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0),
      axis.title = element_text(size = 11),
      axis.text = element_text(size = 10),
      legend.position = "top",
      legend.title = element_blank(),
      legend.text = element_text(size = 10),
      panel.grid.major = element_line(color = "gray90", linewidth = 0.5),
      panel.grid.minor = element_blank(),
      plot.background = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "#f7f7f7", color = NA)
    ) +
    labs(x = xlabel, y = ylabel)

  if (!is.null(title)) p <- p + labs(title = title)
  if (!is.null(subtitle)) p <- p + labs(subtitle = subtitle)

  return(p)
}

# ==============================================================================
# SCATTER PLOT FUNCTIONS
# ==============================================================================

#' Create Scatter Plot
#'
#' Matches "Scatterplot" and "Scatterplot Trendline" templates from Fraym Viz Guide
#'
#' @param data Data frame
#' @param x_col Column for x-axis
#' @param y_col Column for y-axis
#' @param title Chart title (optional)
#' @param subtitle Chart subtitle (optional)
#' @param xlabel X-axis label (optional)
#' @param ylabel Y-axis label (optional)
#' @param color Point color (default: Fraym teal)
#' @param size Point size (default: 3)
#' @param alpha Point transparency (default: 0.7)
#' @param add_trendline Add linear trendline (default: FALSE)
#' @param trendline_color Trendline color (default: Fraym red)
#' @param trendline_size Trendline size (default: 1.2)
#' @return ggplot object
#' @export
create_scatter_plot <- function(data,
                               x_col,
                               y_col,
                               title = NULL,
                               subtitle = NULL,
                               xlabel = NULL,
                               ylabel = NULL,
                               color = NULL,
                               size = 3,
                               alpha = 0.7,
                               add_trendline = FALSE,
                               trendline_color = NULL,
                               trendline_size = 1.2) {

  # Default colors
  if (is.null(color)) {
    color <- if (add_trendline) {
      FRAYM_CHART_PALETTES$scatter_neutral
    } else {
      FRAYM_CHART_PALETTES$scatter_primary
    }
  }

  if (is.null(trendline_color)) {
    trendline_color <- FRAYM_EXTENDED$red
  }

  # Create base plot
  p <- ggplot(data, aes(x = .data[[x_col]], y = .data[[y_col]])) +
    geom_point(color = color, size = size, alpha = alpha) +
    theme_minimal() +
    theme(
      plot.title = element_text(size = 14, face = "bold", hjust = 0),
      plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0),
      axis.title = element_text(size = 11),
      axis.text = element_text(size = 10),
      panel.grid.major = element_line(color = "gray90", linewidth = 0.5),
      panel.grid.minor = element_blank(),
      plot.background = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "#f7f7f7", color = NA)
    ) +
    labs(x = xlabel, y = ylabel)

  # Add trendline if requested
  if (add_trendline) {
    p <- p + geom_smooth(method = "lm", se = FALSE,
                        color = trendline_color,
                        linewidth = trendline_size)
  }

  if (!is.null(title)) p <- p + labs(title = title)
  if (!is.null(subtitle)) p <- p + labs(subtitle = subtitle)

  return(p)
}

# ==============================================================================
# UTILITY FUNCTIONS
# ==============================================================================

#' Save Plot with Fraym Standards
#'
#' @param plot ggplot object
#' @param filename Output filename
#' @param width Width in inches (default: 10)
#' @param height Height in inches (default: 8)
#' @param dpi Resolution (default: 300)
#' @export
#'
#' @examples
#' save_fraym_plot(my_plot, "output/chart.png")
save_fraym_plot <- function(plot,
                           filename,
                           width = 10,
                           height = 8,
                           dpi = 300) {

  ggsave(
    filename = filename,
    plot = plot,
    width = width,
    height = height,
    dpi = dpi,
    bg = "white"
  )

  cat(paste("Saved:", filename, "\n"))
}


#' List Available Color Ramps
#'
#' Print all available Fraym color ramps
#' @export
list_color_ramps <- function() {
  cat("Sequential Ramps:\n")
  cat("  - hello_darkness, magma, go_green, off_grid\n")
  cat("  - candy_floss, candy_apple, population_blues\n")
  cat("  - grayscale (use only when color not available)\n\n")

  cat("Divergent Ramps:\n")
  cat("  - sunshine, polar, peach_rings, hot_and_cold\n")
  cat("  - concord, colorblind_friendly\n\n")

  cat("Chart Palettes:\n")
  cat("  - single_bar, comparison_teal, comparison_gray\n")
  cat("  - opinion_5, intensity_5, rank_5\n")
  cat("  - line_2, scatter_primary, scatter_neutral\n")
}
