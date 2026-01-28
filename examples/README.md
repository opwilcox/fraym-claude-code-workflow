# Fraym Analysis Examples

This directory contains example workflows demonstrating common analysis patterns with Fraym data using Claude Code.

## Available Examples

### 1. Survey Analysis Example

**File:** [survey_analysis_example.R](survey_analysis_example.R)

**What it demonstrates:**
- Loading weighted survey data
- Calculating national-level weighted statistics
- Calculating subnational statistics by geography
- Creating weighted crosstabulations
- Handling small sample sizes

**When to reference:**
- Starting a new survey statistics analysis
- Need to calculate weighted means or proportions
- Working with survey training data
- Creating demographic or geographic breakdowns

**Key functions used:**
- `national_weighted_stats()`
- `subnational_weighted_stats()`
- `weighted_crosstab()`

---

### 2. Mapping Example

**File:** [mapping_example.R](mapping_example.R)

**What it demonstrates:**
- Reading spatial data (shapefiles, geopackages)
- Joining zonal statistics to boundaries
- Creating choropleth maps
- Working with raster data
- Customizing map styling with Fraym colors

**When to reference:**
- Creating choropleth maps of admin-level data
- Visualizing high-resolution raster indicators
- Overlaying boundaries on raster maps
- Applying Fraym color schemes to maps

**Key functions used:**
- `create_choropleth()`
- `create_raster_map()`
- `save_fraym_plot()`

---

## How to Use These Examples

### Method 1: Direct Execution

```r
# Navigate to examples directory
setwd("examples/")

# Run the example script
source("survey_analysis_example.R")
```

### Method 2: Copy and Adapt

```r
# Copy example to work directory
file.copy("examples/survey_analysis_example.R", "work/my_analysis.R")

# Edit and customize for your project
file.edit("work/my_analysis.R")
```

### Method 3: Reference Pattern

Open the example file and copy specific code patterns you need:

```r
# From survey_analysis_example.R
national_stats <- national_weighted_stats(
  training_data,
  c("literacy_rate", "numeracy_rate"),
  weight_col = "pop_wgt",
  ci = TRUE
)
```

## Example Data Requirements

These examples assume a standard Fraym data package structure:

```
data/{package_name}/
├── master_indicator_catalog.csv
├── labeled_training_data/
│   └── {country}_weighted.csv
├── zonal_statistics/
│   ├── adm1_zonal_stats.csv
│   ├── admin_boundaries.gpkg
└── final_rasters/
    └── masked/
        └── {indicator_id}.tif
```

## Adapting Examples for Your Data

1. **Update file paths** to match your data package location
2. **Verify column names** in your data (especially weight column)
3. **Adjust indicator names** to match your codebook
4. **Modify admin level** (adm1, adm2, etc.) as needed
5. **Customize visualizations** with appropriate titles and labels

## Common Patterns Covered

### Working Directory Setup
```r
# All examples assume you're working from work/ directory
setwd("work/")
source("../utils/source_all.R")
```

### Loading Data
```r
# Training data
training <- read_csv("../data/{package}/labeled_training_data/{name}_weighted.csv")

# Zonal statistics
zonal <- read_csv("../data/{package}/zonal_statistics/adm1_zonal_stats.csv")

# Boundaries
boundaries <- st_read("../data/{package}/zonal_statistics/admin_boundaries.gpkg")
```

### Weighted Statistics
```r
# National level
national_weighted_stats(data, indicators, weight_col = "pop_wgt")

# Subnational by geography
subnational_weighted_stats(data, indicator, "adm1_name", weight_col = "pop_wgt")

# Crosstabs
weighted_crosstab(data, "education", "gender", "employed", weight_col = "pop_wgt")
```

### Visualization
```r
# Choropleth map
map <- create_choropleth(
  boundaries_with_data,
  value_col = "literacy_rate",
  ramp_name = "population_blues"
)

# Bar chart
chart <- create_bar_standard(
  summary_data,
  x_col = "region",
  y_col = "percentage",
  sort_values = TRUE
)

# Save outputs
save_fraym_plot(map, "work/figures/map.png")
save_fraym_plot(chart, "work/figures/chart.png")
```

## Tips for Working with Examples

1. **Start simple**: Begin with the survey analysis example if you're new to Fraym data
2. **Run line by line**: Execute examples interactively to understand each step
3. **Check your data**: Verify your data structure matches the example expectations
4. **Customize gradually**: Start with the example as-is, then modify incrementally
5. **Use Claude Code**: Ask Claude to help adapt examples to your specific use case

## Common Issues and Solutions

### Issue: "File not found"
**Solution:** Verify you're in the correct working directory and data paths are correct
```r
getwd()  # Check current directory
list.files("../data")  # Check data location
```

### Issue: "Column not found"
**Solution:** Check your data column names match the example
```r
names(training_data)  # List all column names
```

### Issue: "Weight column missing"
**Solution:** Verify the weight column name in your data
```r
# Common weight column names:
# pop_wgt, weight, sample_weight
```

### Issue: "Empty or NA results"
**Solution:** Check for missing data and filter appropriately
```r
# Check for missing values
summary(training_data$indicator)

# Filter out missing before calculation
training_data |> filter(!is.na(indicator))
```

## Additional Resources

- **[docs/UTILITY_FUNCTIONS.md](../docs/UTILITY_FUNCTIONS.md)** - Detailed function documentation
- **[docs/VISUAL_STANDARDS.md](../docs/VISUAL_STANDARDS.md)** - Fraym visualization standards
- **[CLAUDE.md](../CLAUDE.md)** - Main context file for Claude Code

## Contributing New Examples

If you develop a useful analysis pattern, consider adding it as an example:

1. Create a well-commented R script in `examples/`
2. Use a descriptive filename (e.g., `time_series_comparison_example.R`)
3. Include comments explaining each step
4. Test with standard Fraym data package structure
5. Update this README with a description of the new example

## Getting Help

When asking Claude Code for help with examples:

```
"Show me how to adapt the survey analysis example for calculating
literacy rates by urban/rural area"

"Help me modify the mapping example to use a divergent color scheme"

"Create a new example showing time series analysis of employment rates"
```

Claude Code has access to all examples and can help you understand and adapt them for your specific analysis needs.
