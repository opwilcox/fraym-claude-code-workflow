---
name: survey
description: Use when the user asks for weighted statistics, survey analysis, crosstabulations, national statistics, subnational breakdown, design effect, or any analysis that requires sampling weights applied to training data.
---

# Fraym Survey Statistics

Use `utils/survey.R` functions for all weighted survey analysis. **Always use sampling weights.**

Weight column name is in the CLAUDE.md Project section.

## Core Functions

| Function | Purpose | Key Parameters |
|---|---|---|
| `national_weighted_stats()` | Weighted national means, optionally with CIs | `data`, `indicator_cols`, `weight_col`, `ci=FALSE`, `ci_level=0.95` |
| `subnational_weighted_stats()` | Stats by geography or demographics | `data`, `indicator_col`, `groupby_cols`, `weight_col`, `min_n=30` |
| `weighted_crosstab()` | Crosstabulation of two variables | `data`, `row_col`, `col_col`, `value_col`, `weight_col`, `normalize="row"` |
| `time_series_stats()` | Stats across waves or time periods | `data`, `indicator_col`, `time_col`, `weight_col`, `groupby_col=NULL` |
| `calculate_design_effect()` | Survey DEFF for sample size assessment | `data`, `indicator_col`, `weight_col` |

## Typical Workflow

```r
library(tidyverse)
library(srvyr)
source("../utils/source_all.R")

# Load data (paths from CLAUDE.md Project section)
training <- read_csv("[TRAINING PATH]")
weight_col <- "[WEIGHT_COL]"

# National statistics
nat_stats <- national_weighted_stats(training, c("indicator1", "indicator2"), weight_col)

# By admin unit
adm1_stats <- subnational_weighted_stats(
  training, "indicator1",
  groupby_cols = "admin1",
  weight_col   = weight_col
)

# Crosstab: indicator by gender
crosstab <- weighted_crosstab(
  training, row_col = "gender", col_col = "admin1",
  value_col = "indicator1", weight_col = weight_col
)
```

## Reporting Rules

- **Always report weighted statistics** unless explicitly asked for unweighted
- **Flag small samples**: `subnational_weighted_stats()` auto-flags n < `min_n` (default 30)
- **Include national reference** alongside subnational results
- **Confidence intervals**: include when precision matters (`ci = TRUE`)
- Report sample sizes (n) alongside percentages in tables

## Notes

- Training data has lowercase dummy columns for indicators near the end of the data frame
- Demographic columns (`age_group`, `gender`, `income`, `education`) are the `groupby_cols`
- For multi-wave comparisons use `time_series_stats()` with the wave identifier column
- See `docs/UTILITY_FUNCTIONS.md` for full parameter documentation and examples
