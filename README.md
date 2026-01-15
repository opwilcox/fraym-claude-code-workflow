# Fraym Claude Code Workflow (R Version)

A comprehensive workflow system for Fraym data analysts to use Claude Code with R for automating data analysis tasks.

## Overview

This repository provides a standardized workflow for using Claude Code to automate common data analysis tasks at Fraym using R. The system includes:

- **claude.md**: Context file that teaches Claude about Fraym's data structure and R analysis patterns
- **Utility scripts**: Reusable R functions for common operations
- **Example workflows**: Documented patterns for common tasks (coming soon)
- **Structured workspace**: Organized folders for efficient collaboration

## Quick Start

### 1. Install R and Required Packages

```bash
# Install R (if not already installed)
# https://www.r-project.org/

# Clone this repository
git clone <your-repo-url>
cd fraym-claude-code-workflow-r

# Run setup script to install R packages
Rscript setup.R
```

### 2. Add Your Data Package

```bash
# Copy data package
cp -r /path/to/your/data-package data/

# Or create symlink
ln -s /path/to/your/data-package data/data-package
```

- Add the Master Indicator Catalog (https://docs.google.com/spreadsheets/d/1JQOLlbTORSf0O2ydmblfw9lw9LY2ZYZupVoLzT7go_E/edit?gid=981375855#gid=981375855)for your data license. This is crucial for providing claude with context for the meaning of indicators.

- If you plan to create choropleth maps, you will need to download the place-group ADM boundaries used in the data license from Fraymr since Product currently only stores zonal stats in CSV format.

### 3. Start Claude Code

```bash
# Navigate to work directory
cd work

# Start Claude Code session
claude
```

Or if you are using the VS code plugin simply open VS code in the cloned repo and open the chat box in the top right (Claud logo)

### 4. Begin Your Analysis

```r
# In Claude Code session:

# Load utility functions
source("../utils/source_all.R")

# Then describe what you want to analyze:
"Calculate weighted national literacy rates from the survey data in ../data/"
"Create a choropleth map of poverty rates by region"
```

## Repository Structure

```
fraym-claude-code-workflow-r/
├── README.md                  # This file
├── GETTING_STARTED.md         # Detailed setup guide
├── QUICK_REFERENCE.md         # R function cheat sheet
├── claude.md                  # Core context for Claude Code
├── requirements.txt           # R package list
├── setup.R                    # Package installation script
│
├── utils/                     # Utility function library
│   ├── source_all.R          # Load all utilities
│   ├── survey_stats.R        # Survey statistics (weighted)
│   └── visualization.R       # Charts and maps
│
├── examples/                  # Example workflows
│   ├── survey_analysis_example.R
│   └── mapping_example.R
│
├── data/                      # Your data packages (gitignored)
│   └── .gitkeep
│
└── work/                      # Working directory
    └── .gitkeep
```

## Key Features

### Survey Statistics (utils/survey_stats.R)

```r
# National-level weighted statistics
stats <- national_weighted_stats(
  df, 
  indicator_cols = c("literacy_rate", "numeracy_rate"),
  weight_col = "weight"
)

# Sub-national statistics by region
regional <- subnational_weighted_stats(
  df,
  indicator_col = "literacy_rate",
  groupby_cols = "adm1_name",
  weight_col = "weight"
)

# Weighted crosstabulation
ct <- weighted_crosstab(
  df,
  row_col = "education_level",
  col_col = "gender",
  value_col = "employed",
  normalize = "row"
)

# Time series
ts <- time_series_stats(
  df,
  indicator_col = "unemployment_rate",
  time_col = "survey_year"
)
```

### Visualization (utils/visualization.R)

The visualization module provides Fraym-branded charts and maps following the official Fraym Visualization Guide (February 2025).

#### Color Ramps

**Sequential Ramps** (for continuous data):
- `hello_darkness` (default) - Light gray to teal to dark teal
- `population_blues` - Gray to aqua to teal to blue
- `magma` - Dark blue to purple to red to orange to cream
- `go_green` - Gray to bright green to dark green
- `candy_apple` - Pale sand to red to dark red
- `candy_floss` - Gray to electric blue
- `off_grid` - Cream to green to aqua to blue to teal to dark blue

**Divergent Ramps** (for data with meaningful center):
- `colorblind_friendly` - Blue to gray to red
- `sunshine` - Teal to gray to cream
- `polar` - Aqua to gray to purple
- `hot_and_cold` - Red to dark blue to aqua
- `peach_rings` - Pale sand to cream to orange to red
- `concord` - Gray to purple to dark red

#### Maps

```r
# Choropleth map with custom color ramp
map <- create_choropleth(
  admin_sf,
  value_col = "literacy_rate",
  title = "Literacy Rate by Region",
  subtitle = "Adult population aged 15+",
  legend_title = "Literacy Rate (%)",
  ramp_name = "hello_darkness",  # or any ramp from above
  boundary_color = "white",
  boundary_size = 0.3
)
save_fraym_plot(map, "output/literacy_map.png")

# Raster map with boundaries overlay
raster_map <- create_raster_map(
  "data/deprivation.tif",
  title = "Deprivation Index",
  legend_title = "Index (0-100)",
  ramp_name = "magma",
  boundaries_sf = admin_boundaries,
  boundary_color = "black",
  boundary_size = 0.5
)

# Custom color ramp
map <- create_choropleth(
  admin_sf,
  value_col = "poverty_rate",
  legend_title = "Poverty Rate (%)",
  custom_ramp = c("#ffffff", "#ff0000", "#000000")
)
```

#### Bar Charts

```r
# Standard vertical bars
chart <- create_bar_standard(
  regional_stats,
  x_col = "region_name",
  y_col = "literacy_rate",
  title = "Regional Literacy Rates",
  ylabel = "Literacy Rate (%)",
  sort_values = TRUE,
  show_values = TRUE,
  value_format = "%.1f%%"
)

# Horizontal bars (for long category names)
chart <- create_bar_horizontal(
  district_stats,
  x_col = "literacy_rate",
  y_col = "district_name",
  title = "District Literacy Rates",
  xlabel = "Literacy Rate (%)"
)

# Comparison bars (grouped)
comparison <- create_bar_comparison(
  data_long,
  x_col = "district",
  y_col = "rate",
  group_col = "indicator",
  title = "Urban vs Rural Comparison",
  colors = "teal"  # or "gray" or custom vector
)

# Stacked bars (opinion/likert scales)
stacked <- create_bar_stacked(
  opinion_data,
  x_col = "month",
  y_col = "percentage",
  fill_col = "response",
  title = "Opinion Over Time",
  palette = "opinion_5",  # or "intensity_5", "rank_5"
  horizontal = FALSE,
  show_values = TRUE
)
```

#### Line Charts

```r
# Single series
trend <- create_line_chart(
  time_series_df,
  x_col = "year",
  y_cols = "unemployment_rate",
  title = "Unemployment Rate Over Time",
  xlabel = "Year",
  ylabel = "Rate (%)"
)

# Multiple series
multi_trend <- create_line_chart(
  time_series_df,
  x_col = "year",
  y_cols = c("indicator1", "indicator2", "indicator3"),
  title = "Multiple Indicators",
  legend_labels = c("Urban", "Rural", "National"),
  colors = NULL,  # uses Fraym palette
  show_points = TRUE
)
```

#### Scatter Plots

```r
# Basic scatter
scatter <- create_scatter_plot(
  data,
  x_col = "gdp_per_capita",
  y_col = "literacy_rate",
  title = "GDP vs Literacy",
  xlabel = "GDP per Capita",
  ylabel = "Literacy Rate (%)",
  size = 3,
  alpha = 0.7
)

# With trendline
scatter_trend <- create_scatter_plot(
  data,
  x_col = "education_spending",
  y_col = "test_scores",
  title = "Education Spending vs Test Scores",
  add_trendline = TRUE,
  trendline_color = "#d44244"
)
```

#### Utility Functions

```r
# List all available color ramps
list_color_ramps()

# Save with custom dimensions
save_fraym_plot(
  plot,
  "output/chart.png",
  width = 12,
  height = 8,
  dpi = 300
)
```

## Supported Workflows

### Current Capabilities

✅ **Survey Statistics**
- National-level weighted statistics with confidence intervals
- Sub-national statistics by admin level or demographics
- Weighted crosstabulation
- Time series analysis
- Design effect calculation

✅ **Geospatial Analysis**
- Choropleth maps with customizable breaks and colors
- Raster visualization with boundary overlays
- Zonal statistics (using terra and exactextractr)

✅ **Visualization**
- Publication-ready charts following Fraym standards
- Customizable color schemes
- Automatic formatting and styling

## Usage Examples

### Example 1: Basic Survey Analysis

```r
library(tidyverse)
library(srvyr)
source("utils/source_all.R")

# Load data
df <- read_csv("../data/survey.csv")

# Calculate national statistics
national_stats <- national_weighted_stats(
  df,
  indicator_cols = c("literacy_rate", "school_enrollment"),
  weight_col = "weight",
  ci = TRUE
)

print(national_stats)
```

### Example 2: Regional Comparison with Map

```r
library(sf)
source("utils/source_all.R")

# Calculate regional statistics
regional <- subnational_weighted_stats(
  df,
  indicator_col = "literacy_rate",
  groupby_cols = "adm1_name"
)

# Load boundaries
boundaries <- st_read("../data/boundaries/admin1.shp")

# Join statistics to boundaries
map_data <- boundaries %>%
  left_join(regional, by = c("NAME" = "adm1_name"))

# Create map
literacy_map <- create_choropleth(
  map_data,
  value_col = "weighted_mean",
  title = "Adult Literacy Rate by Region"
)

# Save
save_fraym_plot(literacy_map, "output/literacy_map.png", width = 10, height = 8)
```

### Example 3: Time Series Visualization

```r
source("utils/source_all.R")

# Calculate time series
ts <- time_series_stats(
  df,
  indicator_col = "unemployment_rate",
  time_col = "year"
)

# Create line chart
trend_chart <- create_line_chart(
  ts,
  x_col = "year",
  y_cols = "weighted_mean",
  title = "Unemployment Rate Over Time",
  xlabel = "Year",
  ylabel = "Unemployment Rate (%)"
)

save_fraym_plot(trend_chart, "output/unemployment_trend.png")
```

## Working with Claude Code

### Typical Session

```bash
cd work
claude
```

In Claude Code:
```
# Load utilities
> "Source the utility functions from ../utils/source_all.R"

# Describe dataset
> "Read and describe the survey data in ../data/education-survey.csv"

# Analysis
> "Calculate weighted literacy rates by region and create a map"

# Visualization
> "Create a bar chart comparing urban vs rural literacy rates"
```

### Example Prompts for Visualizations

**Maps:**
```
"Create a choropleth map of poverty rates using the hello_darkness color ramp"

"Make a raster map of the deprivation index with ADM1 boundaries overlaid, using the magma color ramp"

"Create a choropleth showing literacy rates by district with the population_blues ramp and gray boundaries"

"Generate a map of vaccination coverage using the colorblind_friendly divergent ramp centered at 50%"
```

**Bar Charts:**
```
"Create a horizontal bar chart of the top 10 districts by literacy rate, sorted descending"

"Make a comparison bar chart showing urban vs rural rates for each region, using the teal color scheme"

"Create a stacked bar chart of opinion responses over time using the opinion_5 palette"

"Generate a standard vertical bar chart of regional unemployment rates with value labels"
```

**Line Charts:**
```
"Create a line chart showing unemployment trends from 2020-2025"

"Make a multi-line chart comparing three indicators over time with custom legend labels"

"Generate a time series chart of poverty rates with points marked at each year"
```

**Scatter Plots:**
```
"Create a scatter plot of GDP per capita vs literacy rate with a trendline"

"Make a scatter plot showing the relationship between education spending and test scores"
```

**Customization Examples:**
```
"Create a choropleth map but use a custom color ramp from white to dark red"

"Make a horizontal bar chart without value labels"

"Generate a line chart with thicker lines (size 2) and no point markers"

"Create a map with thicker boundaries (0.8) in dark gray color"
```

### Customizable Parameters Reference

#### Choropleth Maps (`create_choropleth`)
| Parameter | Default | Options | Description |
|-----------|---------|---------|-------------|
| `ramp_name` | `"hello_darkness"` | See color ramps above | Named color scheme |
| `custom_ramp` | `NULL` | Vector of hex colors | Override with custom colors |
| `boundary_color` | `"white"` | Any color | Boundary line color |
| `boundary_size` | `0.3` | Numeric | Boundary line thickness |
| `title` | `NULL` | String | Map title |
| `subtitle` | `NULL` | String | Map subtitle |
| `legend_title` | Column name | String | Legend label |

#### Raster Maps (`create_raster_map`)
| Parameter | Default | Options | Description |
|-----------|---------|---------|-------------|
| `ramp_name` | `"hello_darkness"` | See color ramps above | Named color scheme |
| `boundaries_sf` | `NULL` | sf object | Optional boundary overlay |
| `boundary_color` | `"black"` | Any color | Boundary line color |
| `boundary_size` | `0.5` | Numeric | Boundary line thickness |

#### Bar Charts (all types)
| Parameter | Default | Options | Description |
|-----------|---------|---------|-------------|
| `sort_values` | `TRUE` | TRUE/FALSE | Sort bars by value |
| `show_values` | `TRUE` | TRUE/FALSE | Display value labels |
| `value_format` | `"%.0f%%"` | sprintf format | Number format |
| `colors` | `"teal"` | "teal", "gray", vector | Color scheme |
| `palette` | `"opinion_5"` | See palettes | Stacked bar colors |

#### Line Charts (`create_line_chart`)
| Parameter | Default | Options | Description |
|-----------|---------|---------|-------------|
| `line_size` | `1.5` | Numeric | Line thickness |
| `show_points` | `TRUE` | TRUE/FALSE | Show point markers |
| `point_size` | `3` | Numeric | Point marker size |
| `colors` | Auto | Vector of colors | Custom line colors |
| `legend_labels` | Column names | Vector of strings | Custom legend |

#### Scatter Plots (`create_scatter_plot`)
| Parameter | Default | Options | Description |
|-----------|---------|---------|-------------|
| `size` | `3` | Numeric | Point size |
| `alpha` | `0.7` | 0-1 | Transparency |
| `add_trendline` | `FALSE` | TRUE/FALSE | Add linear fit |
| `trendline_color` | Fraym red | Hex color | Trendline color |

### Best Practices

1. **Always use sampling weights**: All survey statistics functions require weight column
2. **Source utilities first**: Run `source("../utils/source_all.R")` at start of session
3. **Use relative paths**: Reference data as `../data/` from work directory
4. **Review outputs**: Check that maps and charts follow Fraym standards
5. **Save work**: Save scripts and outputs to organized subdirectories in work/

## Requirements

**Software:**
- R 4.0+ 
- Claude Code CLI
- RStudio (optional, recommended)

**R Packages:**
- tidyverse (dplyr, ggplot2, tidyr, readr)
- srvyr (survey analysis)
- sf (vector spatial data)
- terra (raster data)
- scales, patchwork (visualization)
- readxl, writexl (Excel files)

Install all packages: `Rscript setup.R`

## Configuration

```

### Customizing claude.md

Edit `claude.md` to add:
- Project-specific data conventions
- Custom analysis workflows
- Client requirements
- Additional data dictionaries

## Troubleshooting

**Issue: Package installation fails**
```r
# Try installing individually
install.packages("tidyverse")
install.packages("srvyr")
install.packages("sf")
install.packages("terra")
```

**Issue: Cannot find utility functions**
```r
# Make sure you're in work/ directory
getwd()  # Should end in .../work

# Source utilities
source("../utils/source_all.R")
```

**Issue: Weights not being applied**
```r
# All survey functions require weight_col parameter
national_weighted_stats(df, "indicator", weight_col = "weight")
```

## Contributing

See CONTRIBUTING.md for guidelines on:
- Adding new utility functions
- Improving claude.md
- Creating example workflows
- Team collaboration

## Support

- **Documentation**: See GETTING_STARTED.md and QUICK_REFERENCE.md
- **Function help**: `?function_name` or read function docstrings
- **Examples**: Check `examples/` directory

## License

Internal Fraym use. Customize as needed for your organization.

---

**Ready to start?** → See GETTING_STARTED.md

**Need quick reference?** → See QUICK_REFERENCE.md
