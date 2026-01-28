# Fraym Data Analysis Context

This file provides Claude Code with essential context about Fraym's data structure, analysis patterns, and quality standards for this analysis project.

## Project

<!-- ============================================================================
     ANALYSTS: Fill in this section at the start of each new project

     Most important: Update "Data Package Location" to match your data folder!
     ============================================================================ -->

### Current Project Information

**Project Name:** [Add project name]

**Client:** [Add client name]

**Data Package Location:** `../data/[package_name]`
*Update this path to match your data package folder name*

**Geographic Focus:** [Country/region and admin levels]

**Key Indicators:** [List primary indicators of interest]

**Time Period:** [Survey collection dates and data reference period]

**Survey Info:**
- Sample size: [e.g., 4,070]
- Survey mode: [e.g., CATI]
- Data collection period: [e.g., Aug 18 - Oct 5, 2025]

**Special Requirements:**
- [Add any client-specific requirements]
- [Add any special methodological considerations]
- [Add any visualization preferences]

### Data Package Structure

**Document your specific data package structure below:**

**Indicator Catalog:**
- Location: `[path to codebook/catalog file]`
- Format: [CSV/Excel]
- Key columns: [list important column names]

**Training Data:**
- Location: `[path to weighted survey data]`
- Weight column name: `[e.g., pop_wgt, weight, sample_weight]`
- Key indicator columns: [list main indicators]

**Zonal Statistics:**
- Location: `[path to zonal stats folder]`
- Admin levels available: [e.g., ADM0, ADM1, ADM2]
- File naming pattern: [e.g., adm1_zonal_stats.csv]

**Spatial Boundaries:**
- Location: `[path to boundary files]`
- Format: [GPKG/SHP]
- Join key: `[column name for joining, e.g., "id"]`

**Rasters:**
- Location: `[path to raster folder]`
- Subfolder to use: [e.g., masked/, raw_tifs/]
- File naming pattern: [e.g., indicator_id matches catalog]

### Known Data Issues / Project Notes

- [Document any data quality issues discovered]
- [Note any indicator-specific quirks]
- [Record client feedback and preferences]
- [Track analysis decisions and rationale]

<!-- ============================================================================
     EXAMPLE - Delete this after filling in your project info:

     **Project Name:** Syria Social Media Analysis
     **Client:** ACME Corporation
     **Data Package Location:** `../data/syr_sagittarius_2025`
     **Geographic Focus:** Syria, ADM1 (14 governorates) and ADM2
     **Key Indicators:** tiktok_usage, instagram_usage, facebook_usage, twitter_usage
     **Time Period:** Survey fielded Aug 18 - Oct 5, 2025
     **Survey Info:**
       - Sample size: 4,070
       - Survey mode: CATI
       - Data collection period: Aug 18 - Oct 5, 2025
     **Special Requirements:**
       - Client wants focus on urban vs rural differences
       - Use colorblind-friendly palettes for all maps
       - Include confidence intervals for key findings

     ### Data Package Structure

     **Indicator Catalog:**
     - Location: `../data/syr_sagittarius_2025/syr_sagittarius_2025_indicator_catalog.csv`
     - Format: CSV
     - Key columns: indicator_id, indicator_name, indicator_description, category, national_proportion

     **Training Data:**
     - Location: `../data/syr_sagittarius_2025/labeled_training_data/syr_sagittarius_2025_weighted.csv`
     - Weight column name: `pop_wgt`
     - Key indicator columns: tiktok_usage, instagram_usage, facebook_usage, twitter_usage,
       urban_rural, age_group, gender, education_level

     **Zonal Statistics:**
     - Location: `../data/syr_sagittarius_2025/zonal_statistics/`
     - Admin levels available: ADM0 (national), ADM1 (14 governorates), ADM2 (districts)
     - File naming pattern: `syr_adm0_zonal_stats.csv`, `syr_adm1_zonal_stats.csv`, `syr_adm2_zonal_stats.csv`

     **Spatial Boundaries:**
     - Location: `../data/syr_sagittarius_2025/zonal_statistics/syr_admin_boundaries.gpkg`
     - Format: GPKG with layers for ADM1 and ADM2
     - Join key: `id` (matches zonal stats files)

     **Rasters:**
     - Location: `../data/syr_sagittarius_2025/final_rasters/`
     - Subfolder to use: `masked/` (population-masked)
     - File naming pattern: `syr_{indicator_id}.tif` (e.g., syr_tiktok_usage.tif)

     **Known Data Issues / Project Notes:**
       - TikTok usage higher in younger demographics (expected)
       - Rural sample slightly smaller (n=800), flag small sample sizes
       - Client prefers horizontal bar charts for readability
       - Some ADM2 districts have n<30, use ADM1 for those areas
     ============================================================================ -->

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

**Before starting:** Fill in the **Data Package Structure** section in the Project area above. This ensures Claude knows exactly where to find your files.

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
2. Parse Master Indicator Catalog (available indicators, national stats)
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

## Claude Code Workflow

### Multi-Step Analysis Pattern

When conducting multi-step analysis:
1. **Use TodoWrite** to plan steps
2. **Validate data** before processing
3. **Save intermediate outputs** to work/
4. **Generate final report/visualization**

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
