#!/usr/bin/env Rscript
#' Fraym Spatial Skills - fraymr API Wrappers
#'
#' Helper functions for querying the Fraym API via the fraymr package.
#' Requires credentials set in .Renviron:
#'   INFRAYM_USER=your_email
#'   INFRAYM_PASSWORD=your_password
#'
#' ============================================================================
#' IMPORTANT: PACKAGE LOAD ORDER (Windows)
#' ============================================================================
#'
#'   library(terra)   # FIRST
#'   library(sf)
#'   library(fraymr)
#'   infraym_login()
#' ============================================================================
#'
#' Usage:
#'   library(fraymr)
#'   infraym_login()
#'   # then call any function below

# =============================================================================
# AUTHENTICATION
# =============================================================================

#' Authenticate with the Fraym API
#'
#' Reads credentials from INFRAYM_USER and INFRAYM_PASSWORD env vars.
#' Call once per session before using any api_* functions.
#'
#' @examples
#' fraym_login()
fraym_login <- function() {
  library(fraymr)
  infraym_login()
  invisible(NULL)
}


# =============================================================================
# PLACE GROUPS
# =============================================================================

#' List available place groups for a country
#'
#' Always returns the id column - use this id to download a specific place group.
#'
#' @param iso3_code ISO3 country code (e.g. "USA", "KEN", "NGA")
#' @param place_type Optional filter. One of: "Country", "Urban",
#'   "Administrative Division", "City"
#' @param admin_division_type Optional filter string, e.g. "State",
#'   "Congressional District", "County", "ZCTA"
#' @param active_only Return only active place groups (default TRUE)
#' @return Tibble with columns: id, description, placeType, adminDivisionType,
#'   admLevel, source, numberFeatures, isDefault, isActive
#'
#' @examples
#' # All place groups for USA
#' list_place_groups("USA")
#'
#' # Only administrative divisions
#' list_place_groups("USA", place_type = "Administrative Division")
#'
#' # Filter to states only
#' list_place_groups("USA", admin_division_type = "State")
#'
#' # Filter to congressional districts
#' list_place_groups("USA", admin_division_type = "Congressional District")
list_place_groups <- function(iso3_code,
                               place_type = NULL,
                               admin_division_type = NULL,
                               active_only = TRUE) {
  result <- api_get_place_group_versions(
    iso3_code          = iso3_code,
    place_type         = place_type,
    admin_division_type = admin_division_type,
    active_only        = active_only
  )
  # Always surface the id prominently for downstream use
  result |>
    dplyr::select(
      id, description, placeType, adminDivisionType,
      admLevel, source, numberFeatures, isDefault, isActive
    ) |>
    dplyr::arrange(admLevel, adminDivisionType)
}


#' Download a place group by its ID
#'
#' Returns an sf spatial object. Get the id from list_place_groups().
#'
#' @param id Integer place group ID (from list_place_groups()$id)
#' @return sf object with geometry and place group attributes
#'
#' @examples
#' # First list available groups to find the right id
#' groups <- list_place_groups("USA", admin_division_type = "State")
#' print(groups)  # note the id column
#'
#' # Download by id
#' states_sf <- download_place_group(id = 123)
download_place_group <- function(id) {
  api_get_place_group_by_id(id = as.integer(id))
}


#' Download the default place group for a country and type
#'
#' Convenience wrapper for the most common case - fetches the default
#' (canonical) boundary for a given place type without needing an id.
#'
#' @param iso3_code ISO3 country code (e.g. "USA")
#' @param place_type One of: "Country", "Urban", "Administrative Division", "City"
#' @param admin_division_type Optional sub-type string (e.g. "State", "County")
#' @return sf object
#'
#' @examples
#' # National boundary
#' usa_boundary <- download_default_place_group("USA", "Country")
#'
#' # Default state boundaries
#' states_sf <- download_default_place_group("USA", "Administrative Division",
#'                                            admin_division_type = "State")
#'
#' # Default county boundaries
#' counties_sf <- download_default_place_group("USA", "Administrative Division",
#'                                              admin_division_type = "County")
download_default_place_group <- function(iso3_code, place_type,
                                          admin_division_type = NULL) {
  api_get_place_group_default(
    iso3_code           = iso3_code,
    place_type          = place_type,
    admin_division_type = admin_division_type
  )
}


# =============================================================================
# WORLDPOP
# =============================================================================

#' Download WorldPop population raster(s)
#'
#' Returns a terra SpatRaster (or list of SpatRasters for multiple age bands).
#' If multiple age/gender combinations are requested, results are returned as
#' a named list. Sum them with terra::app() or Reduce("+", ...) as needed.
#'
#' @param iso3_code ISO3 country code (e.g. "USA")
#' @param year Integer year (WorldPop typically covers 2000-2020)
#' @param age_lower Optional lower bound of age range (e.g. 15)
#' @param age_upper Optional upper bound of age range (e.g. 49)
#' @param gender Optional: "m" for male, "f" for female, NULL for total
#' @param mask_to_country Clip raster to country boundary (default FALSE)
#' @param partial_age_ranges Include partial age band overlaps (default TRUE)
#' @return terra SpatRaster or list of SpatRasters
#'
#' @examples
#' # Total population, 2020
#' pop_total <- download_worldpop("USA", year = 2020)
#'
#' # Women of reproductive age (15-49), 2020
#' women_1549 <- download_worldpop("USA", year = 2020,
#'                                  age_lower = 15, age_upper = 49,
#'                                  gender = "f")
#'
#' # All adults (15+), male, masked to country
#' men_15plus <- download_worldpop("USA", year = 2020,
#'                                  age_lower = 15,
#'                                  gender = "m",
#'                                  mask_to_country = TRUE)
#'
#' # Sum multiple layers if returned as list
#' # total <- Reduce("+", pop_list)
download_worldpop <- function(iso3_code, year,
                               age_lower = NULL,
                               age_upper = NULL,
                               gender = NULL,
                               mask_to_country = FALSE,
                               partial_age_ranges = TRUE) {
  api_get_worldpop(
    iso3_code          = iso3_code,
    year               = as.integer(year),
    age_lower          = age_lower,
    age_upper          = age_upper,
    gender             = gender,
    mask_to_country    = mask_to_country,
    partial_age_ranges = partial_age_ranges
  )
}


# =============================================================================
# COUNTRY BOUNDARIES
# =============================================================================

#' Download country boundary
#'
#' Convenience wrapper for api_get_country(). Returns an sf object with
#' the national boundary polygon.
#'
#' @param iso3_code ISO3 country code (e.g. "USA")
#' @return sf object with country boundary
#'
#' @examples
#' usa <- download_country("USA")
#' plot(sf::st_geometry(usa))
download_country <- function(iso3_code) {
  api_get_country(iso3_code = iso3_code)
}


# =============================================================================
# SURVEYS
# =============================================================================

#' List available surveys for a country
#'
#' @param iso3_code ISO3 country code
#' @param start_year Starting year to search from
#' @param raw_or_processed Return "raw" or "processed" surveys (default "processed")
#' @param limit Max number of results (default 10)
#' @return Tibble of available surveys with id column for download
#'
#' @examples
#' list_surveys("USA", start_year = 2020)
#' list_surveys("KEN", start_year = 2018, raw_or_processed = "raw")
list_surveys <- function(iso3_code, start_year,
                          raw_or_processed = "processed",
                          limit = 10L) {
  api_get_surveys(
    iso3_code        = iso3_code,
    start_year       = as.integer(start_year),
    raw_or_processed = raw_or_processed,
    limit            = as.integer(limit)
  )
}


#' Get download URL for a specific survey
#'
#' @param survey_id Integer survey ID (from list_surveys()$id)
#' @param raw_or_processed "raw" or "processed" (default "processed")
#' @return Character string URL
#'
#' @examples
#' surveys <- list_surveys("USA", 2020)
#' url <- get_survey_url(surveys$id[1])
get_survey_url <- function(survey_id, raw_or_processed = "processed") {
  api_get_survey_url_by_id(
    survey_id        = as.integer(survey_id),
    raw_or_processed = raw_or_processed
  )
}


# =============================================================================
# SPATIAL UTILITIES
# =============================================================================

#' Calculate weighted zonal statistics from a raster
#'
#' Aggregate raster values within polygon zones, optionally weighted by
#' a second raster (e.g., population).
#'
#' @param rast terra SpatRaster to aggregate
#' @param zones sf or SpatVector polygon zones
#' @param weight Optional terra SpatRaster for weighted aggregation (e.g. pop)
#' @param fun Aggregation function: "sum", "mean", "min", "max" (default "sum")
#' @param output_file Path to save output CSV/shapefile
#' @param csv Return as CSV (default FALSE, returns sf)
#' @return sf object or CSV path
#'
#' @examples
#' # Sum population within states
#' state_pop <- calc_zonal_stats(
#'   rast   = pop_raster,
#'   zones  = states_sf,
#'   fun    = "sum",
#'   output_file = "work/state_population.csv"
#' )
#'
#' # Population-weighted mean of an indicator within counties
#' county_stats <- calc_zonal_stats(
#'   rast        = indicator_raster,
#'   zones       = counties_sf,
#'   weight      = pop_raster,
#'   fun         = "mean",
#'   output_file = "work/county_indicator_stats.csv"
#' )
calc_zonal_stats <- function(rast, zones, weight = NULL, fun = "sum",
                              output_file, csv = FALSE) {
  weighted_zonal_stats(
    rast        = rast,
    zones       = zones,
    weight      = weight,
    fun         = fun,
    output_file = output_file,
    csv         = csv
  )
}


# =============================================================================
# QUICK REFERENCE
# =============================================================================

#' Print spatial skills quick reference
fraym_spatial_help <- function() {
  cat("=== Fraym Spatial Skills Quick Reference ===\n\n")
  cat("AUTHENTICATION:\n")
  cat("  fraym_login()                          # authenticate (once per session)\n\n")
  cat("PLACE GROUPS:\n")
  cat("  list_place_groups(iso3, ...)            # list available groups + IDs\n")
  cat("  download_place_group(id)               # download by id -> sf\n")
  cat("  download_default_place_group(iso3, ...) # download default boundary -> sf\n")
  cat("  download_country(iso3)                 # national boundary -> sf\n\n")
  cat("WORLDPOP:\n")
  cat("  download_worldpop(iso3, year, ...)     # population raster -> SpatRaster\n\n")
  cat("SURVEYS:\n")
  cat("  list_surveys(iso3, start_year)         # list surveys + IDs\n")
  cat("  get_survey_url(survey_id)              # get download URL\n\n")
  cat("SPATIAL ANALYSIS:\n")
  cat("  calc_zonal_stats(rast, zones, ...)     # aggregate raster by polygon\n\n")
  cat("PLACE TYPE OPTIONS:\n")
  cat("  'Country' | 'Urban' | 'Administrative Division' | 'City'\n\n")
  cat("COMMON USA ADMIN DIVISION TYPES:\n")
  cat("  'State' | 'County' | 'Congressional District' | 'ZCTA' |\n")
  cat("  'Census Tract' | 'Metropolitan Statistical Area' |\n")
  cat("  'Designated Market Area' | 'Division'\n")
}
