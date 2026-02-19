# Fraym Data Analysis Context

This file provides Claude Code with essential context about Fraym's data structure, analysis patterns, and quality standards for this analysis project.

## Project

<!-- ============================================================================
     ANALYSTS: Update this section at the start of each new project. The current info is illustrative.

     Most important: Update "Data Package Location" to match your data folder!
     ============================================================================ -->

### Current Project Information

**Project Name:** American Views of Foreign Assistance 

**Client:** Gates Foundation

**Data Package Location:** `../data`
*Update this path to match your data package folder name*

**Geographic Focus:** United States [national, state, and congressional districts]

**Key Indicators:** Proportion of adults who think U.S. foreign aid spending should increase or stay the same

**Time Period:** September - December 2025 (ongoing tracker)

**Survey Info:**
September 2025

- Sample size: 17,000
- Survey mode: Online
- Data collection period: September 2025

October - December 2025

- Sample size: 17,000
- Survey mode: Online
- Data collection period: October - December 2025


### Data Package Structure

**Document your specific data package structure below:**

**Codebook:**
- Location: `/data/usa_data/codebook.csv`
- Format: .csv
- Key columns: Contains list of indicators and key metadata

**Training Data:**
- Training data exist for each wave and are stored in the wave folder (e.g. "data_package_09_2025")
- Location: `/data/usa_data/[wave]/training_data/`
- Weight column name: pop_wgt_unclustered (use as weight for survey analysis), age_group, gender, race, income, education (use as grouping variables for crosstabs)
- use lower_case dummy columns near the end of the training dataset for survey analysis. These column names will match the indicators in the codebook.

**Zonal Statistics:**
- Location: `/data/usa_data/[wave]/zonal_statistics/`
- Available in both CSV and Geopackage format
- Use CSV for data lookup, tabular analysis
- Use Geopackage for maps

**Spatial Boundaries:**
- Location: `/data/usa_data/[wave]/boundaries/`
- Format: Geopackage

**Rasters:**
- Location: `/data/usa_data/[wave]/rasters/`
- Format: Geotiff
- File naming pattern: usa-[INDICATOR ID]-uuid (e.g. usa-aid_awr_pos-e1af8ca45a00462ba8ff2391180d1fa7)
- INDICATOR ID (middle portion) can be matched to the IDs in the codebook


<!-- ============================================================================
     END PROJECT SECTION
     ============================================================================ -->

## About Fraym

Fraym provides high-resolution geospatial data and analytics focused on population characteristics, behaviors, and attitudes globally. Fraym data scientists combine survey data, satellite imagery, large-scale geospatial datasets, and machine learning to generate insights at fine geographic resolutions (1km² resolution).

**Key Points:**
- **Survey Data**: Scientifically sampled, geo-tagged household surveys
- **Machine Learning**: Model-stacking approach to predict indicators at 1km² resolution
- **Validation**: Rigorous QA/QC processes and ground-truth validation
- **Outputs**: Rasters (1km²), zonal statistics (admin levels), and training data

For detailed methodology, see [docs/FRAYM_METHODS.md](docs/FRAYM_METHODS.md)

## Working Directory Standards

### Default Working Directory

**ALWAYS use the `work/` folder for all analysis outputs:**
- All R scripts and R Markdown files
- All generated reports (HTML, PDF, etc.)
- All intermediate outputs and temporary files
- All visualizations saved as standalone files

**File Path Patterns (from work/ directory):**
```
work/                           # Current working directory (default)
├── *.R                        # Analysis scripts
├── *.Rmd                      # R Markdown reports
├── *.html / *.pdf             # Rendered reports
└── figures/                   # Saved visualizations
    └── *.png

../data/{package}/             # Data location (relative from work/)
../utils/                      # Utility functions (relative from work/)
../docs/                       # Reference documentation
../examples/                   # Example workflows
```

**Session Initialization Pattern:**
```r
# 1. Verify working directory
getwd()  # Should be .../work

# 2. Load utility functions (ONLY if using Fraym-specific functions)
source("../utils/source_all.R")  # Skip if using standard R/tidyverse only

# 3. Set paths from "Data Package Structure" in Project section
pkg_path <- "../data/your_package_name"
codebook_path <- "path_from_project_section"
training_path <- "path_from_project_section"
weight_col <- "pop_wgt"  # From Project section

# 4. Verify files exist
file.exists(codebook_path)
file.exists(training_path)

# 5. Begin analysis
```

## Data Structure

### Understanding Fraym Data Packages

**See the "Data Package Structure" section in the Project area above for your specific package details.**

Fraym data packages typically contain these asset types:

**1. Indicator Catalog**
- Lists all available indicators with definitions and metadata
- Use this first to understand what data is available
- Usually CSV format with indicator IDs, names, descriptions, and national-level statistics

**2. Zonal Statistics**
- Pre-aggregated data at administrative levels (e.g., ADM0, ADM1, ADM2)
- Faster for analysis than raw training data
- Usually includes both CSV (data) and GPKG/SHP (boundaries)

**3. Training Data**
- Raw weighted survey responses
- Required for custom analyses and crosstabulations
- **Always use the weight column** specified in your Project section

**4. Rasters (Optional)**
- High-resolution (1km²) modeled surfaces
- Used for detailed spatial analysis and mapping
- Usually TIF format, often in a `masked/` subfolder

### Data Discovery Protocol


**Step 1: Verify Package Location**
```r
# Set package path from Project section
pkg_path <- "../data/your_package_name"  # Update from Project section

# List package contents
list.files(pkg_path)

# Explore structure
list.files(pkg_path, recursive = TRUE) |> head(20)
```

**Step 2: Read Indicator Catalog**
```r
# Use the exact path from "Data Package Structure" in Project section
codebook <- read_csv("path_from_project_section")

# Explore available indicators
codebook |>
  select(indicator_id, indicator_name, category) |>
  print(n = 50)
```

**Step 3: Load Data for Analysis**

Use the specific paths documented in your **Data Package Structure** section:

```r
# Example - adjust paths based on your Project section:

# Training data (path from Project section)
training <- read_csv("path_from_project_section")

# Weight column (name from Project section)
weight_col <- "pop_wgt"  # Or whatever is specified

# Zonal statistics (path from Project section)
zonal_adm1 <- read_csv("path_from_project_section")

# Boundaries (path from Project section)
boundaries <- st_read("path_from_project_section")

# Rasters (path from Project section)
library(terra)
raster <- rast("path_from_project_section")
```

**The key:** Always reference the **Data Package Structure** in the Project section for exact file paths and naming conventions.

## Analysis Patterns

### 1. Exploratory Data Analysis

**For high-level questions**, start with these assets:
1. Read project info from this file (survey dates, sample size, etc.)
2. Parse codebook (available indicators, national stats)
3. Read zonal statistics (pre-calculated subnational summaries)
4. Review questionnaire if needed (for question-specific context)

**Output:** Respond directly unless visualization/report requested

### 2. Survey Statistics

**ALWAYS use sampling weights** when calculating survey statistics.

**Quick Reference:**
```r
# National statistics
national_weighted_stats(data, indicators, weight_col = "pop_wgt")

# By geography/demographics
subnational_weighted_stats(data, indicator, groupby_cols, weight_col = "pop_wgt")

# Crosstabulations
weighted_crosstab(data, row_var, col_var, value_col, weight_col = "pop_wgt")

# Time series
time_series_stats(data, indicator, time_col, weight_col = "pop_wgt")
```

See [docs/UTILITY_FUNCTIONS.md](docs/UTILITY_FUNCTIONS.md) for detailed documentation.

### 3. Data Visualization

**Always use Fraym color schemes and styling standards.**

**Quick Reference:**
```r
# Choropleth maps
create_choropleth(sf_data, value_col, ramp_name = "hello_darkness")

# Raster maps
create_raster_map(raster_file, boundaries_sf = boundaries)

# Bar charts
create_bar_standard(data, x_col, y_col)
create_bar_horizontal(data, x_col, y_col)  # For long labels
create_bar_comparison(data, x_col, y_col, group_col)

# Line charts (time series)
create_line_chart(data, x_col, y_cols)

# Scatter plots
create_scatter_plot(data, x_col, y_col, add_trendline = TRUE)

# Save with standards
save_fraym_plot(plot, "work/figures/{name}.png")
```

**Color Palettes:**
- Sequential: `hello_darkness`, `magma`, `population_blues`, `go_green`
- Divergent: `colorblind_friendly` (preferred), `sunshine`, `polar`

See [docs/VISUAL_STANDARDS.md](docs/VISUAL_STANDARDS.md) for complete specifications.

## Utility Functions

**When to load utilities:**

Load utilities if using Fraym-specific functions:
```r
source("../utils/source_all.R")
```

Skip loading if you're:
- Just exploring data (reading files, checking structure)
- Using standard R/tidyverse functions only
- Doing basic data manipulation without Fraym functions

**Available Functions (require utilities to be loaded):**

**Survey Statistics:**
- `national_weighted_stats()` - National weighted means
- `subnational_weighted_stats()` - By geography/demographics
- `weighted_crosstab()` - Weighted crosstabulation
- `time_series_stats()` - Statistics over time
- `calculate_design_effect()` - Survey design effect

**Visualization:**
- `create_choropleth()` - Choropleth maps
- `create_raster_map()` - Raster maps
- `create_bar_standard()` - Vertical bar charts
- `create_bar_horizontal()` - Horizontal bar charts
- `create_bar_comparison()` - Grouped bar charts
- `create_bar_stacked()` - Stacked bar charts
- `create_line_chart()` - Line charts
- `create_scatter_plot()` - Scatter plots
- `save_fraym_plot()` - Save with Fraym standards

**Color Access:**
- `FRAYM_COLORS` - Primary palette
- `FRAYM_RAMPS` - Map color ramps
- `FRAYM_CHART_PALETTES` - Chart color schemes

See [docs/UTILITY_FUNCTIONS.md](docs/UTILITY_FUNCTIONS.md) for detailed documentation and examples.

## fraymr API (Spatial Data)

The `fraymr` package provides direct access to the Fraym API for downloading spatial boundaries, WorldPop rasters, and survey data. Wrapper functions live in `utils/spatial_skills.R` and are loaded automatically via `source_all.R`.

### Authentication

Credentials must be in `~/.Renviron` (at `C:\Users\<username>\.Renviron` on Windows):
```
INFRAYM_USER=your_email@fraym.io
INFRAYM_PASSWORD=your_password
```

Call once per session before any API function:
```r
library(fraymr)
infraym_login()
```

### Place Groups

**Always check available place groups and note the `id` column before downloading.**

```r
# List all place groups for a country (always returns id column)
list_place_groups("USA")

# Filter by type
list_place_groups("USA", place_type = "Administrative Division")
list_place_groups("USA", admin_division_type = "State")
list_place_groups("USA", admin_division_type = "Congressional District")
list_place_groups("USA", admin_division_type = "County")

# Download by id (from list_place_groups()$id)
states_sf <- download_place_group(id = 123)

# Download default boundary for a type (no id needed)
usa_boundary  <- download_default_place_group("USA", "Country")
states_sf     <- download_default_place_group("USA", "Administrative Division",
                                               admin_division_type = "State")
counties_sf   <- download_default_place_group("USA", "Administrative Division",
                                               admin_division_type = "County")

# National boundary only
usa_sf <- download_country("USA")
```
### WorldPop Population Rasters

Returns a `terra` SpatRaster. Age ranges are defined by WorldPop 5-year bands (e.g. 0, 5, 10, ... 80).

```r
# Total population, 2020
pop <- download_worldpop("USA", year = 2020)

# Women of reproductive age 15-49
women_1549 <- download_worldpop("USA", year = 2020,
                                 age_lower = 15, age_upper = 49,
                                 gender = "f")

# All males 15+, clipped to country boundary
men_15plus <- download_worldpop("USA", year = 2020,
                                 age_lower = 15,
                                 gender = "m",
                                 mask_to_country = TRUE)

# gender options: "m" | "f" | NULL (total)
```

### Surveys

```r
# List available surveys (returns id for download)
list_surveys("USA", start_year = 2020)
list_surveys("USA", start_year = 2018, raw_or_processed = "raw")

# Get download URL for a specific survey
url <- get_survey_url(survey_id = 42)
```

### Zonal Statistics (Raster → Polygon Aggregation)

```r
# Sum population raster within state polygons
state_pop <- calc_zonal_stats(
  rast        = pop_raster,
  zones       = states_sf,
  fun         = "sum",
  output_file = "work/state_population.csv"
)

# Population-weighted mean of indicator within counties
county_stats <- calc_zonal_stats(
  rast        = indicator_raster,
  zones       = counties_sf,
  weight      = pop_raster,
  fun         = "mean",
  output_file = "work/county_stats.csv"
)
```

### Typical Spatial Workflow

**R requirements**
1. Always write multi-line scripts to `.R` files and run with `Rscript script.R` — multiline `Rscript -e` strings crash on Windows

```r
# Correct load order
library(terra)
library(sf)
library(fraymr)
library(tidyverse)
source("../utils/spatial_skills.R")

infraym_login()

# Find and download boundaries
groups    <- list_place_groups("USA", admin_division_type = "State")
states_sf <- download_place_group(id = groups$id[groups$isDefault])

# Download WorldPop raster
pop <- download_worldpop("USA", year = 2020)

# Load indicator and run population-weighted zonal stats
indicator <- terra::rast("path/to/indicator.tif")
pop_rs    <- terra::resample(pop, indicator, method = "bilinear")

result <- weighted_zonal_stats(
  rast        = indicator,
  zones       = states_sf,
  weight      = pop_rs,
  fun         = "weighted_mean",
  output_file = "work/zonal_stats/my_indicator_states",
  csv         = TRUE
)
```

See [utils/spatial_skills.R](utils/spatial_skills.R) for full function documentation.

## Claude Code Workflow

### Multi-Step Analysis Pattern

When conducting multi-step analysis:
1. **Use TodoWrite** to plan steps
2. **Validate data** before processing
3. **Save intermediate outputs** to work/
4. **Generate final report/visualization**

### R Execution Standard

**Always write R code to `.R` files and run with `Rscript script.R`.**

Never use multiline `Rscript -e "..."` strings. They crash on Windows and are harder to debug and reproduce.

```bash
# CORRECT
Rscript work/my_analysis_2026-02-19.R

# WRONG — crashes on Windows
Rscript -e "
library(tidyverse)
data <- read_csv(...)
...
"
```

Single-line `-e` calls are fine for quick checks (e.g., `Rscript -e "packageVersion('terra')"`).

### File Output Standards

**Naming Conventions:**
- Scripts: `work/{analysis_name}_{date}.R`
- Reports: `work/{analysis_name}_{date}.Rmd`
- Figures: `work/figures/{analysis}_{type}_{date}.png`
- Always use ISO date format: YYYY-MM-DD

**Example:**
```
work/tiktok_analysis_2025-01-28.R
work/literacy_analysis_2025-01-28.Rmd
work/figures/literacy_by_region_2025-01-28.png
```

### Error Recovery

If a script fails, check:
1. **Data paths** - Most common issue (verify from work/ directory)
2. **Utilities loaded** - Run `source("../utils/source_all.R")`
3. **Required packages** - Check if packages are installed
4. **Data structure** - Verify column names and data types

## Quality Standards

### Data Validation Checklist
- [ ] Sampling weights are present and used
- [ ] Geographic joins match correctly (no orphaned records)
- [ ] Sample sizes are adequate (n ≥ 30 for subgroups)
- [ ] Indicator values are within valid ranges
- [ ] Missing data is handled appropriately

### Statistical Reporting Standards
- Report **weighted statistics** (unless explicitly asked for unweighted)
- Include **confidence intervals** for key estimates when possible
- **Flag small sample sizes** (n < 30) in results
- Note **data quality limitations** when relevant
- Always provide **national statistic for reference** when showing subnational

### Visualization Quality Standards
- Use **Fraym color schemes** exclusively
- Provide **clear, descriptive titles** and subtitles
- **No vertical text** - use horizontal orientation
- **No error bars** unless explicitly requested
- **Narrow bars with gaps** for bar charts (width ≤ 0.7)
- Include **data sources** and sample sizes
- Save at **300 DPI** with white background

### Documentation Standards
- Document **data sources** and versions used
- Note **data transformations** or exclusions
- Explain **methodological choices**
- Provide **reproducible code**

## Modern R Coding Standards

**Always Use:**
- Native pipe `|>` (not `%>%`)
- Per-operation grouping `.by` (not `group_by() |> ungroup()`)
- Modern join syntax `join_by()`
- Type-stable functions `map_dbl()`, `map_chr()` (not `sapply()`)
- stringr functions (not base R string functions)

**Quick Examples:**
```r
# Good - Modern patterns
data |>
  filter(year >= 2020) |>
  summarise(mean_value = mean(value), .by = category)

# Joins
left_join(x, y, by = join_by(id))

# String operations
text |> str_to_lower() |> str_trim()

# Type-stable mapping
map_dbl(data, mean)
```

See [docs/R_STYLE_GUIDE.md](docs/R_STYLE_GUIDE.md) for comprehensive coding standards.

## Reference Documentation

For detailed information, see:

- **[docs/FRAYM_METHODS.md](docs/FRAYM_METHODS.md)** - Detailed Fraym methodology, survey process, ML models, validation
- **[docs/UTILITY_FUNCTIONS.md](docs/UTILITY_FUNCTIONS.md)** - Complete function documentation with examples
- **[docs/VISUAL_STANDARDS.md](docs/VISUAL_STANDARDS.md)** - Color palettes, chart specifications, accessibility
- **[docs/R_STYLE_GUIDE.md](docs/R_STYLE_GUIDE.md)** - Modern R coding patterns, performance, best practices
- **[examples/](examples/)** - Example workflows and analysis patterns

## When to Ask for Clarification

Ask when:
- Multiple interpretations of an indicator are possible
- Geographic level for analysis is unclear
- Time period handling is ambiguous
- Special client requirements conflict with standards
- Data quality issues affect analysis approach

## Limitations and Assumptions

**Assumptions:**
- Data packages follow Fraym's standard structure
- Weights are properly calibrated (use as provided)
- Geographic identifiers use standard naming
- Indicators measured consistently across geographies

**When to search for additional context:**
- Indicator definitions are unclear (check codebook first)
- Methodology questions arise (see docs/FRAYM_METHODS.md)
- External data sources are referenced
- Client-specific requirements are mentioned in Project section
