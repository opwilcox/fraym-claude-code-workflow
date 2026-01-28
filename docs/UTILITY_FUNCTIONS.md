# Fraym Utility Functions Reference

This document provides detailed documentation for all utility functions available in the Fraym Claude Code workflow. All functions can be loaded at once with:

```r
source("utils/source_all.R")
```

## Survey Statistics Functions

Located in [utils/survey_stats.R](../utils/survey_stats.R)

### national_weighted_stats()

Calculate national-level weighted statistics for survey indicators.

**Function Signature:**
```r
national_weighted_stats(
  df,
  indicator_cols,
  weight_col = "weight",
  strata_col = NULL,
  cluster_col = NULL,
  ci = FALSE,
  ci_level = 0.95
)
```

**Parameters:**
- `df`: Data frame with survey data
- `indicator_cols`: Character vector of indicator column names to analyze
- `weight_col`: Name of weight column (default: "weight")
- `strata_col`: Optional stratification column for complex survey design
- `cluster_col`: Optional cluster column for complex survey design
- `ci`: Logical, whether to calculate confidence intervals (default: FALSE)
- `ci_level`: Confidence level for CIs (default: 0.95)

**Returns:**
Data frame with columns: indicator, weighted_mean, se, weighted_median, n, total_weight, and optionally ci_lower/ci_upper

**Example:**
```r
# Simple usage
stats <- national_weighted_stats(
  survey_data,
  c("literacy_rate", "numeracy_rate"),
  weight_col = "pop_wgt"
)

# With confidence intervals
stats_ci <- national_weighted_stats(
  survey_data,
  "literacy_rate",
  weight_col = "pop_wgt",
  ci = TRUE,
  ci_level = 0.95
)

# With complex survey design
stats_complex <- national_weighted_stats(
  survey_data,
  "income_level",
  weight_col = "pop_wgt",
  cluster_col = "cluster_id",
  strata_col = "strata_id"
)
```

---

### subnational_weighted_stats()

Calculate weighted statistics broken down by geographic or demographic groups.

**Function Signature:**
```r
subnational_weighted_stats(
  df,
  indicator_col,
  groupby_cols,
  weight_col = "weight",
  strata_col = NULL,
  cluster_col = NULL,
  min_n = 30
)
```

**Parameters:**
- `df`: Data frame with survey data
- `indicator_col`: Name of indicator column to analyze (single column)
- `groupby_cols`: Character vector of grouping column names (e.g., "adm1_name", "urban_rural")
- `weight_col`: Name of weight column (default: "weight")
- `strata_col`: Optional stratification column
- `cluster_col`: Optional cluster column
- `min_n`: Minimum sample size threshold (groups below this are flagged, default: 30)

**Returns:**
Data frame with grouping columns, weighted_mean, weighted_mean_se, n, total_weight, and small_sample flag

**Example:**
```r
# By region
regional_literacy <- subnational_weighted_stats(
  survey_data,
  indicator_col = "literacy_rate",
  groupby_cols = "adm1_name",
  weight_col = "pop_wgt"
)

# By multiple groupings
urban_rural_regional <- subnational_weighted_stats(
  survey_data,
  indicator_col = "employment_rate",
  groupby_cols = c("adm1_name", "urban_rural"),
  weight_col = "pop_wgt",
  min_n = 50
)

# Check for small samples
flagged <- urban_rural_regional |> filter(small_sample)
```

---

### weighted_crosstab()

Calculate weighted crosstabulation showing relationships between two variables.

**Function Signature:**
```r
weighted_crosstab(
  df,
  row_col,
  col_col,
  value_col,
  weight_col = "weight",
  normalize = NULL
)
```

**Parameters:**
- `df`: Data frame with survey data
- `row_col`: Column name for rows
- `col_col`: Column name for columns
- `value_col`: Column name with values to aggregate
- `weight_col`: Name of weight column (default: "weight")
- `normalize`: Optional normalization: NULL (none), "all" (% of total), "row" (% of row), or "col" (% of column)

**Returns:**
Data frame in long format with row_col, col_col, and weighted_value columns

**Example:**
```r
# Basic crosstab
ct <- weighted_crosstab(
  survey_data,
  row_col = "education_level",
  col_col = "gender",
  value_col = "employed",
  weight_col = "pop_wgt"
)

# Normalized by row (percentages within each education level)
ct_row_pct <- weighted_crosstab(
  survey_data,
  row_col = "education_level",
  col_col = "gender",
  value_col = "employed",
  weight_col = "pop_wgt",
  normalize = "row"
)

# Convert to wide format for tables
ct_wide <- ct_row_pct |>
  pivot_wider(names_from = gender, values_from = weighted_value)
```

---

### time_series_stats()

Calculate weighted statistics over time periods, optionally by subgroups.

**Function Signature:**
```r
time_series_stats(
  df,
  indicator_col,
  time_col,
  weight_col = "weight",
  groupby_col = NULL
)
```

**Parameters:**
- `df`: Data frame with survey data
- `indicator_col`: Name of indicator column to track over time
- `time_col`: Name of time column (e.g., "survey_year", "survey_date")
- `weight_col`: Name of weight column (default: "weight")
- `groupby_col`: Optional additional grouping column (e.g., "adm1_name")

**Returns:**
Data frame with time_col, weighted_mean, weighted_mean_se, n, total_weight, and optional groupby_col

**Example:**
```r
# National time series
national_ts <- time_series_stats(
  survey_data,
  indicator_col = "unemployment_rate",
  time_col = "survey_year",
  weight_col = "pop_wgt"
)

# Regional time series
regional_ts <- time_series_stats(
  survey_data,
  indicator_col = "poverty_rate",
  time_col = "survey_year",
  weight_col = "pop_wgt",
  groupby_col = "adm1_name"
)

# Plot time series
ggplot(national_ts, aes(x = survey_year, y = weighted_mean)) +
  geom_line() +
  geom_point()
```

---

### calculate_design_effect()

Calculate the design effect (DEFF) for a weighted survey indicator.

**Function Signature:**
```r
calculate_design_effect(
  df,
  indicator_col,
  weight_col = "weight"
)
```

**Parameters:**
- `df`: Data frame with survey data
- `indicator_col`: Name of indicator column
- `weight_col`: Name of weight column (default: "weight")

**Returns:**
Numeric value representing the design effect

**Example:**
```r
# Calculate design effect
deff <- calculate_design_effect(
  survey_data,
  indicator_col = "literacy_rate",
  weight_col = "pop_wgt"
)

# A DEFF of 1.0 means no design effect (simple random sample)
# Values > 1.0 indicate clustering effects
# Effective sample size = actual n / DEFF
```

---

## Visualization Functions

Located in [utils/visualization.R](../utils/visualization.R)

### Color Palettes

Access Fraym color schemes through these global variables:

```r
# Individual colors
FRAYM_COLORS$dark_blue
FRAYM_COLORS$electric_blue
FRAYM_COLORS$teal
FRAYM_COLORS$aqua
FRAYM_COLORS$bright_green

# Neutral colors
FRAYM_NEUTRALS$charcoal
FRAYM_NEUTRALS$pale_gray
FRAYM_NEUTRALS$sand

# Extended colors
FRAYM_EXTENDED$purple
FRAYM_EXTENDED$red
FRAYM_EXTENDED$orange

# Sequential color ramps
FRAYM_RAMPS$hello_darkness
FRAYM_RAMPS$magma
FRAYM_RAMPS$population_blues

# Divergent color ramps
FRAYM_RAMPS$colorblind_friendly
FRAYM_RAMPS$sunshine
FRAYM_RAMPS$polar

# Chart palettes
FRAYM_CHART_PALETTES$single_bar
FRAYM_CHART_PALETTES$comparison_teal
FRAYM_CHART_PALETTES$opinion_5
```

### create_choropleth()

Create a choropleth map from sf spatial data.

**Function Signature:**
```r
create_choropleth(
  sf_data,
  value_col,
  title = NULL,
  subtitle = NULL,
  legend_title = NULL,
  ramp_name = "hello_darkness",
  custom_ramp = NULL,
  boundary_color = "white",
  boundary_size = 0.3
)
```

**Parameters:**
- `sf_data`: sf object with geometries and data
- `value_col`: Column name containing values to map
- `title`: Map title (optional)
- `subtitle`: Map subtitle (optional)
- `legend_title`: Label for legend (defaults to value_col)
- `ramp_name`: Name of Fraym color ramp (default: "hello_darkness")
- `custom_ramp`: Optional custom color vector (overrides ramp_name)
- `boundary_color`: Color for boundary lines (default: "white")
- `boundary_size`: Size of boundary lines (default: 0.3)

**Returns:**
ggplot object

**Example:**
```r
# Read spatial data
admin_sf <- st_read("data/admin_boundaries.gpkg") |>
  left_join(zonal_stats, by = "id")

# Create map
literacy_map <- create_choropleth(
  admin_sf,
  value_col = "literacy_rate",
  title = "Literacy Rates by District",
  subtitle = "Adults aged 18+, 2025",
  legend_title = "Literacy Rate (%)",
  ramp_name = "population_blues"
)

# Save
save_fraym_plot(literacy_map, "work/figures/literacy_map.png")
```

**Available Ramps:**
- Sequential: hello_darkness, magma, go_green, population_blues, candy_floss, candy_apple, off_grid
- Divergent: colorblind_friendly, sunshine, polar, hot_and_cold, concord, peach_rings
- grayscale (use only for B&W printing)

---

### create_raster_map()

Create a map from raster data with optional boundary overlays.

**Function Signature:**
```r
create_raster_map(
  raster_file,
  title = NULL,
  subtitle = NULL,
  legend_title = "Value",
  ramp_name = "hello_darkness",
  custom_ramp = NULL,
  boundaries_sf = NULL,
  boundary_color = "black",
  boundary_size = 0.5
)
```

**Parameters:**
- `raster_file`: Path to raster file or terra SpatRaster object
- `title`: Map title (optional)
- `subtitle`: Map subtitle (optional)
- `legend_title`: Label for legend
- `ramp_name`: Name of Fraym color ramp
- `custom_ramp`: Optional custom color vector
- `boundaries_sf`: Optional sf object with boundaries to overlay
- `boundary_color`: Color for boundaries (default: "black")
- `boundary_size`: Size for boundaries (default: 0.5)

**Returns:**
ggplot object

**Example:**
```r
library(terra)
library(sf)

# Read raster
raster_data <- rast("data/final_rasters/masked/syr_literacy_rate.tif")

# Read boundaries
boundaries <- st_read("data/admin_boundaries.gpkg")

# Create map
raster_map <- create_raster_map(
  raster_data,
  title = "High-Resolution Literacy Rates",
  subtitle = "1km² resolution, Syria 2025",
  legend_title = "Literacy Rate (%)",
  ramp_name = "magma",
  boundaries_sf = boundaries,
  boundary_color = "#00162b",
  boundary_size = 0.8
)

# Save
save_fraym_plot(raster_map, "work/figures/literacy_raster.png",
                width = 12, height = 10)
```

---

### create_bar_standard()

Create a standard vertical bar chart.

**Function Signature:**
```r
create_bar_standard(
  data,
  x_col,
  y_col,
  title = NULL,
  subtitle = NULL,
  xlabel = NULL,
  ylabel = NULL,
  sort_values = TRUE,
  show_values = TRUE,
  value_format = "%.0f%%"
)
```

**Parameters:**
- `data`: Data frame
- `x_col`: Column for x-axis (categories)
- `y_col`: Column for y-axis (values)
- `title`: Chart title (optional)
- `subtitle`: Chart subtitle (optional)
- `xlabel`: X-axis label (optional, use subtitle instead for context)
- `ylabel`: Y-axis label (optional, use subtitle instead for context)
- `sort_values`: Sort bars by value descending (default: TRUE)
- `show_values`: Show value labels on bars (default: TRUE)
- `value_format`: sprintf format for values (default: "%.0f%%")

**Returns:**
ggplot object

**Example:**
```r
# Create summary data
literacy_by_region <- subnational_weighted_stats(
  survey_data,
  indicator_col = "literacy_rate",
  groupby_cols = "adm1_name",
  weight_col = "pop_wgt"
) |>
  mutate(literacy_pct = weighted_mean * 100)

# Create bar chart
bar_chart <- create_bar_standard(
  literacy_by_region,
  x_col = "adm1_name",
  y_col = "literacy_pct",
  title = "Literacy Rates by Region",
  subtitle = "Percentage of adults (18+) who can read and write, 2025",
  sort_values = TRUE,
  value_format = "%.1f%%"
)

save_fraym_plot(bar_chart, "work/figures/literacy_bars.png")
```

---

### create_bar_horizontal()

Create a horizontal bar chart for long category names.

**Function Signature:**
```r
create_bar_horizontal(
  data,
  x_col,
  y_col,
  title = NULL,
  subtitle = NULL,
  xlabel = NULL,
  ylabel = NULL,
  sort_values = TRUE,
  show_values = TRUE,
  value_format = "%.0f%%"
)
```

**Parameters:**
Same as `create_bar_standard()` but x_col contains values and y_col contains categories

**Example:**
```r
# For long category names
bar_horizontal <- create_bar_horizontal(
  data,
  x_col = "percentage",
  y_col = "long_category_name",
  title = "Agreement with Policy Statements",
  subtitle = "Percentage who agree or strongly agree, n=4,070"
)
```

---

### create_bar_comparison()

Create grouped bar chart for comparing categories.

**Function Signature:**
```r
create_bar_comparison(
  data,
  x_col,
  y_col,
  group_col,
  title = NULL,
  subtitle = NULL,
  xlabel = NULL,
  ylabel = NULL,
  colors = "teal",
  show_values = TRUE,
  value_format = "%.0f%%"
)
```

**Parameters:**
- `data`: Data frame in long format with group column
- `x_col`: Column for x-axis (categories)
- `y_col`: Column for y-axis (values)
- `group_col`: Column for grouping (creates separate bars)
- `colors`: Color scheme: "teal", "gray", or custom vector (default: "teal")
- Other parameters same as standard bar chart

**Example:**
```r
# Compare urban vs rural
comparison <- create_bar_comparison(
  data_long,
  x_col = "region",
  y_col = "literacy_pct",
  group_col = "urban_rural",
  title = "Urban-Rural Literacy Gap by Region",
  subtitle = "Percentage literate among adults 18+, 2025",
  colors = "teal"
)
```

---

### create_bar_stacked()

Create stacked bar chart for showing composition.

**Function Signature:**
```r
create_bar_stacked(
  data,
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
  value_threshold = 10
)
```

**Parameters:**
- `data`: Data frame in long format
- `x_col`: Column for x-axis (time periods or categories)
- `y_col`: Column for y-axis (values)
- `fill_col`: Column for fill (creates stacks)
- `palette`: Palette name: "opinion_5", "intensity_5", "rank_5", or custom vector
- `horizontal`: Create horizontal stacked bars (default: FALSE)
- `show_values`: Show value labels in bars (default: TRUE)
- `value_threshold`: Minimum value to show label (default: 10)

**Example:**
```r
# Opinion scale over time
stacked_opinion <- create_bar_stacked(
  opinion_data,
  x_col = "survey_year",
  y_col = "percentage",
  fill_col = "opinion_level",
  title = "Trust in Government Over Time",
  subtitle = "Distribution of responses, 2020-2025",
  palette = "opinion_5"
)
```

---

### create_line_chart()

Create line chart for time series or trends.

**Function Signature:**
```r
create_line_chart(
  data,
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
  legend_labels = NULL
)
```

**Parameters:**
- `data`: Data frame with time series data
- `x_col`: Column for x-axis (time)
- `y_cols`: Column(s) for y-axis (values) - can be vector for multiple lines
- `colors`: Line colors (default: Fraym line palette)
- `line_size`: Line thickness (default: 1.5)
- `show_points`: Show points at data values (default: TRUE)
- `point_size`: Size of points (default: 3)
- `legend_labels`: Custom legend labels (optional)

**Example:**
```r
# Single time series
line_single <- create_line_chart(
  ts_data,
  x_col = "year",
  y_cols = "unemployment_rate",
  title = "National Unemployment Rate",
  subtitle = "Annual average, 2015-2025"
)

# Multiple series
line_multi <- create_line_chart(
  ts_data,
  x_col = "year",
  y_cols = c("urban_unemployment", "rural_unemployment"),
  title = "Urban vs Rural Unemployment",
  subtitle = "Annual averages, 2015-2025",
  legend_labels = c("Urban", "Rural")
)
```

---

### create_scatter_plot()

Create scatter plot with optional trendline.

**Function Signature:**
```r
create_scatter_plot(
  data,
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
  trendline_size = 1.2
)
```

**Parameters:**
- `data`: Data frame
- `x_col`: Column for x-axis
- `y_col`: Column for y-axis
- `color`: Point color (default: Fraym teal)
- `size`: Point size (default: 3)
- `alpha`: Point transparency (default: 0.7)
- `add_trendline`: Add linear trendline (default: FALSE)
- `trendline_color`: Trendline color (default: Fraym red)
- `trendline_size`: Trendline size (default: 1.2)

**Example:**
```r
# Basic scatter
scatter <- create_scatter_plot(
  data,
  x_col = "education_years",
  y_col = "income",
  title = "Education and Income Relationship",
  subtitle = "Individual-level data, n=4,070"
)

# With trendline
scatter_trend <- create_scatter_plot(
  aggregated_data,
  x_col = "literacy_rate",
  y_col = "poverty_rate",
  title = "Literacy and Poverty by District",
  add_trendline = TRUE
)
```

---

### save_fraym_plot()

Save plot with Fraym standards (300 DPI, white background).

**Function Signature:**
```r
save_fraym_plot(
  plot,
  filename,
  width = 10,
  height = 8,
  dpi = 300
)
```

**Parameters:**
- `plot`: ggplot object
- `filename`: Output filename (supports .png, .pdf, .jpg, .svg)
- `width`: Width in inches (default: 10)
- `height`: Height in inches (default: 8)
- `dpi`: Resolution (default: 300)

**Example:**
```r
# Standard size
save_fraym_plot(my_plot, "work/figures/analysis_chart.png")

# Custom dimensions for wide chart
save_fraym_plot(my_plot, "work/figures/timeline.png",
                width = 14, height = 6)

# PDF for presentations
save_fraym_plot(my_plot, "work/figures/map.pdf",
                width = 12, height = 10)
```

---

### list_color_ramps()

Print all available Fraym color ramps to console.

**Function Signature:**
```r
list_color_ramps()
```

**Example:**
```r
# Display all available color schemes
list_color_ramps()
```

---

## Common Workflows

### Complete Analysis Workflow

```r
# 1. Load utilities
source("utils/source_all.R")

# 2. Load data
survey_data <- read_csv("data/my_package/labeled_training_data/survey_weighted.csv")
zonal_stats <- read_csv("data/my_package/zonal_statistics/adm2_zonal_stats.csv")
admin_boundaries <- st_read("data/my_package/zonal_statistics/admin_boundaries.gpkg")

# 3. Calculate national statistics
national <- national_weighted_stats(
  survey_data,
  c("literacy_rate", "numeracy_rate", "digital_literacy"),
  weight_col = "pop_wgt",
  ci = TRUE
)

# 4. Calculate subnational statistics
regional <- subnational_weighted_stats(
  survey_data,
  "literacy_rate",
  "adm1_name",
  weight_col = "pop_wgt"
) |>
  mutate(literacy_pct = weighted_mean * 100)

# 5. Create visualizations
bar_chart <- create_bar_standard(
  regional,
  "adm1_name",
  "literacy_pct",
  title = "Regional Literacy Rates",
  subtitle = "Percentage of adults (18+) who are literate, 2025"
)

# 6. Create choropleth
admin_with_data <- admin_boundaries |>
  left_join(zonal_stats, by = "id")

map <- create_choropleth(
  admin_with_data,
  "literacy_rate",
  title = "Literacy Rates by District",
  legend_title = "Literacy Rate (%)",
  ramp_name = "population_blues"
)

# 7. Save outputs
save_fraym_plot(bar_chart, "work/figures/literacy_bars.png")
save_fraym_plot(map, "work/figures/literacy_map.png", width = 12, height = 10)
```

---

## Tips

1. **Always use weights** - All survey statistics functions require a weight column
2. **Check sample sizes** - Use the `small_sample` flag from `subnational_weighted_stats()` to identify unreliable estimates
3. **Consistent naming** - Use snake_case for all column names
4. **Color accessibility** - Prefer the "colorblind_friendly" divergent palette for maximum accessibility
5. **Save consistently** - Use `save_fraym_plot()` to ensure all outputs meet Fraym standards

For more details on methodology, see [FRAYM_METHODS.md](FRAYM_METHODS.md).

For visual design standards, see [VISUAL_STANDARDS.md](VISUAL_STANDARDS.md).

For R coding patterns, see [R_STYLE_GUIDE.md](R_STYLE_GUIDE.md).
