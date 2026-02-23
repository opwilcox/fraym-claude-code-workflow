---
name: spatial
description: Use when the user asks about fraymr, download boundaries, WorldPop, place groups, zonal statistics, spatial analysis, check place groups, what boundaries are available, check worldpop, find population rasters, or any task involving the Fraymr API.
---

# Fraym Spatial Analysis (fraymr API)

Use `utils/spatial.R` for all Fraymr API interactions. Always write multi-line scripts to `.R` files and run with `Rscript` — multiline `Rscript -e` strings crash on Windows.

## Authentication

Credentials must be in `~/.Renviron` (`C:\Users\<username>\.Renviron` on Windows):
```
INFRAYM_USER=your_email@fraym.io
INFRAYM_PASSWORD=your_password
```

Call once per session before any API function:
```r
library(terra)   # load terra FIRST on Windows
library(sf)
library(fraymr)
library(tidyverse)
source("../utils/spatial.R")

fraym_login()
```

---

## Checking Place Groups

Retrieve and summarize all available boundaries for a country.

**Script template** (`work/check_place_groups_YYYY-MM-DD.R`):
```r
library(fraymr)
library(dplyr)
source("../utils/spatial.R")

infraym_login()

groups <- list_place_groups("[ISO3]")  # e.g. "IRQ", "USA"

groups |>
  select(id, description, placeType, adminDivisionType, admLevel,
         source, numberFeatures, isDefault, isActive) |>
  arrange(admLevel, id) |>
  print(n = 100, width = 140)

cat("\n=== DEFAULTS ===\n")
groups |>
  filter(isDefault == TRUE) |>
  select(id, placeType, adminDivisionType, admLevel, source, numberFeatures) |>
  print(n = 20, width = 140)
```

**Summarize findings**:
- **Default place groups** — IDs used by `download_default_place_group()`, with feature counts
- **Non-default alternatives** — especially NGA-provided or project-specific boundaries
- **Flag mismatches** — e.g., default ADM1 has 18 units but data package expects 19

**Notes**:
- `list_place_groups()` returns camelCase columns: `placeType`, `adminDivisionType`, `admLevel`, `isDefault`, `isActive`, `numberFeatures`
- For NGA client projects, prefer NGA-provided boundaries — recommend the highest ID (most recent)
- Download a specific group: `download_place_group(id = <id>)`
- Download the default: `download_default_place_group("[ISO3]", "Administrative Division", admin_division_type = "Governorate")`

---

## Checking WorldPop Availability

Verify access and summarize available WorldPop rasters for a country.

**Script template** (`work/check_worldpop_YYYY-MM-DD.R`):
```r
library(terra)
library(fraymr)
source("../utils/spatial.R")

infraym_login()

cat("Standard WorldPop coverage: 2000–2020\n")
cat("Age bands: 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80\n")
cat("Genders: 'm' (male), 'f' (female), NULL (total)\n\n")

pop <- tryCatch(
  download_worldpop("[ISO3]", year = [YEAR]),
  error = function(e) { cat("Error:", conditionMessage(e), "\n"); NULL }
)

if (!is.null(pop)) {
  cat("Download successful!\n")
  cat("Resolution:", terra::res(pop), "(degrees)\n")
  cat("CRS:", terra::crs(pop, describe = TRUE)$name, "\n")
  cat("Approx total population:",
      round(terra::global(pop, "sum", na.rm = TRUE)[[1]] / 1e6, 2), "million\n")
}
```

**WorldPop download reference**:
```r
pop_total    <- download_worldpop("IRQ", year = 2020)
women_1549   <- download_worldpop("IRQ", year = 2020, age_lower = 15, age_upper = 49, gender = "f")
men_15plus   <- download_worldpop("IRQ", year = 2020, age_lower = 15, gender = "m", mask_to_country = TRUE)
```

**Notes**:
- Standard annual coverage: **2000–2020** — confirm the latest year available
- Age ranges follow **5-year WorldPop bands** (0, 5, 10 ... 80) — no exact age 18; use 15 or 20
- `mask_to_country = TRUE` clips to national boundary
- Returns a `terra` SpatRaster object

---

## Zonal Statistics

Aggregate a raster to polygon zones (population-weighted mean or sum).

```r
# Always resample population raster to match indicator raster first
pop_rs <- terra::resample(pop_raster, indicator_raster, method = "bilinear")

# Population-weighted mean
result <- calc_zonal_stats(
  rast        = indicator_raster,
  zones       = adm1_sf,
  weight      = pop_rs,
  fun         = "mean",
  output_file = "work/zonal_stats/indicator_adm1_YYYY-MM-DD",
  csv         = TRUE
)
```

---

## Full Spatial Workflow

```r
library(terra)
library(sf)
library(fraymr)
library(tidyverse)
source("../utils/spatial.R")

fraym_login()

# 1. Find and download boundaries
groups    <- list_place_groups("IRQ", admin_division_type = "Governorate")
adm1_sf   <- download_place_group(id = groups$id[groups$isDefault])

# 2. Download WorldPop
pop <- download_worldpop("IRQ", year = 2020)

# 3. Load indicator raster
indicator <- terra::rast("../data/Iraq 2025/Rasters/irq-[INDICATOR_ID].tif")

# 4. Resample pop to match indicator, run zonal stats
pop_rs <- terra::resample(pop, indicator, method = "bilinear")
result <- calc_zonal_stats(
  rast        = indicator,
  zones       = adm1_sf,
  weight      = pop_rs,
  fun         = "mean",
  output_file = "work/zonal_stats/[indicator]_adm1_YYYY-MM-DD",
  csv         = TRUE
)
```

See `utils/spatial.R` for full function documentation.
