---
name: visualize
description: Use when the user asks to make a chart, create a map, plot data, bar chart, choropleth, visualize indicators, line chart, scatter plot, or any request to produce a data visualization using Fraym standards.
---

# Fraym Data Visualization

Use `utils/visualization.R` functions with Fraym color palettes exclusively.

## Chart Selection Guide

| Situation | Function |
|---|---|
| Geographic variation across admin units | `create_choropleth()` |
| High-resolution 1km spatial data | `create_raster_map()` |
| Comparing categories (short labels) | `create_bar_standard()` |
| Comparing categories (long labels) | `create_bar_horizontal()` |
| Side-by-side group comparison (urban/rural, gender) | `create_bar_comparison()` |
| Composition or opinion scale (agree/disagree) | `create_bar_stacked()` |
| Trends over time / multiple waves | `create_line_chart()` |
| Bivariate relationship | `create_scatter_plot()` |

Always save with: `save_fraym_plot(plot, "work/figures/{name}_{type}_{YYYY-MM-DD}.png")`

## Color Palettes

**Sequential ramps** (maps, intensity): `hello_darkness` (default), `magma`, `population_blues`, `go_green`, `off_grid`, `candy_floss`, `candy_apple`

**Divergent ramps** (above/below average, positive/negative): `colorblind_friendly` (preferred), `sunshine`, `polar`, `hot_and_cold`, `concord`, `peach_rings`

**Chart palettes**: `single_bar`, `comparison_teal`, `comparison_gray`, `opinion_5`, `intensity_5`, `rank_5`, `line_2`

Pass ramp names as strings: `create_choropleth(sf_data, "value", ramp_name = "hello_darkness")`

## Typical Workflow

```r
library(tidyverse)
library(sf)
source("../utils/source_all.R")

# Choropleth map
p_map <- create_choropleth(
  sf_data   = adm1_sf,
  value_col = "indicator_value",
  ramp_name = "hello_darkness",
  title     = "Indicator Name by Governorate",
  subtitle  = "% of population, Iraq 2025"
)
save_fraym_plot(p_map, "work/figures/indicator_map_2026-02-20.png")

# Horizontal bar chart
p_bar <- create_bar_horizontal(
  data  = adm1_stats,
  x_col = "mean_value",
  y_col = "admin1_name",
  title = "Indicator by Governorate"
)
save_fraym_plot(p_bar, "work/figures/indicator_bar_2026-02-20.png")
```

## Visual Rules (Non-Negotiable)

- **No vertical text** — use horizontal bar orientation for long labels
- **No error bars** unless explicitly requested
- **Bar width ≤ 0.7** (narrow bars with gaps)
- **Clear title and subtitle** — subtitle carries units and context
- **300 DPI, white background** — enforced by `save_fraym_plot()`
- **Fraym colors only** — no custom hex codes or ggplot defaults
- Save all figures to `work/figures/`

## Notes

- See `docs/VISUAL_STANDARDS.md` for full hex codes and accessibility specs
- `list_color_ramps()` prints all available ramp names in the console
- For raster maps, pass `boundaries_sf` to overlay admin boundaries: `create_raster_map(raster_file, boundaries_sf = adm1_sf)`
