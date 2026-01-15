#!/usr/bin/env Rscript
#' Survey Statistics Utilities
#' 
#' Functions for calculating weighted survey statistics using srvyr
#' following Fraym standards.

library(tidyverse)
library(srvyr)

#' Calculate National-Level Weighted Statistics
#'
#' @param df Data frame with survey data
#' @param indicator_cols Character vector of indicator column names
#' @param weight_col Name of weight column (default: "weight")
#' @param strata_col Optional stratification column
#' @param cluster_col Optional cluster column
#' @param ci Logical, whether to calculate confidence intervals (default: FALSE)
#' @param ci_level Confidence level (default: 0.95)
#' @return Data frame with statistics
#' @export
#'
#' @examples
#' stats <- national_weighted_stats(df, c("literacy_rate", "numeracy_rate"))
#' stats_ci <- national_weighted_stats(df, "literacy_rate", ci = TRUE)
national_weighted_stats <- function(df, 
                                   indicator_cols,
                                   weight_col = "weight",
                                   strata_col = NULL,
                                   cluster_col = NULL,
                                   ci = FALSE,
                                   ci_level = 0.95) {
  
  # Create survey design object
  if (!is.null(strata_col) && !is.null(cluster_col)) {
    svy_design <- df %>%
      as_survey_design(
        ids = !!sym(cluster_col),
        strata = !!sym(strata_col),
        weights = !!sym(weight_col)
      )
  } else if (!is.null(cluster_col)) {
    svy_design <- df %>%
      as_survey_design(
        ids = !!sym(cluster_col),
        weights = !!sym(weight_col)
      )
  } else {
    svy_design <- df %>%
      as_survey_design(weights = !!sym(weight_col))
  }
  
  # Calculate statistics for each indicator
  results <- map_dfr(indicator_cols, function(col) {
    
    # Remove missing values for this indicator
    svy_subset <- svy_design %>%
      filter(!is.na(!!sym(col)))
    
    # Calculate weighted mean and SE
    stats <- svy_subset %>%
      summarise(
        weighted_mean = survey_mean(!!sym(col), na.rm = TRUE, vartype = "se"),
        weighted_median = survey_median(!!sym(col), na.rm = TRUE),
        n = unweighted(n()),
        total_weight = sum(!!sym(weight_col), na.rm = TRUE)
      )
    
    result <- tibble(
      indicator = col,
      weighted_mean = stats$weighted_mean,
      se = stats$weighted_mean_se,
      weighted_median = stats$weighted_median,
      n = stats$n,
      total_weight = stats$total_weight
    )
    
    # Add confidence intervals if requested
    if (ci) {
      z_score <- qnorm(0.5 + ci_level/2)
      result <- result %>%
        mutate(
          ci_lower = weighted_mean - z_score * se,
          ci_upper = weighted_mean + z_score * se
        )
    }
    
    return(result)
  })
  
  return(results)
}


#' Calculate Sub-National Weighted Statistics
#'
#' @param df Data frame with survey data
#' @param indicator_col Name of indicator column
#' @param groupby_cols Character vector of grouping column names
#' @param weight_col Name of weight column (default: "weight")
#' @param strata_col Optional stratification column
#' @param cluster_col Optional cluster column
#' @param min_n Minimum sample size (groups below flagged, default: 30)
#' @return Data frame with statistics by group
#' @export
#'
#' @examples
#' regional <- subnational_weighted_stats(df, "literacy_rate", "adm1_name")
#' urban_rural <- subnational_weighted_stats(df, "income", c("adm1_name", "urban_rural"))
subnational_weighted_stats <- function(df,
                                      indicator_col,
                                      groupby_cols,
                                      weight_col = "weight",
                                      strata_col = NULL,
                                      cluster_col = NULL,
                                      min_n = 30) {
  
  # Create survey design
  if (!is.null(strata_col) && !is.null(cluster_col)) {
    svy_design <- df %>%
      as_survey_design(
        ids = !!sym(cluster_col),
        strata = !!sym(strata_col),
        weights = !!sym(weight_col)
      )
  } else if (!is.null(cluster_col)) {
    svy_design <- df %>%
      as_survey_design(
        ids = !!sym(cluster_col),
        weights = !!sym(weight_col)
      )
  } else {
    svy_design <- df %>%
      as_survey_design(weights = !!sym(weight_col))
  }
  
  # Remove missing values
  svy_design <- svy_design %>%
    filter(!is.na(!!sym(indicator_col)))
  
  # Calculate statistics by group
  results <- svy_design %>%
    group_by(across(all_of(groupby_cols))) %>%
    summarise(
      weighted_mean = survey_mean(!!sym(indicator_col), na.rm = TRUE, vartype = "se"),
      n = unweighted(n()),
      total_weight = sum(!!sym(weight_col), na.rm = TRUE),
      .groups = "drop"
    ) %>%
    mutate(
      small_sample = n < min_n
    )
  
  return(as_tibble(results))
}


#' Calculate Weighted Crosstabulation
#'
#' @param df Data frame with survey data
#' @param row_col Column for rows
#' @param col_col Column for columns
#' @param value_col Column with values to aggregate
#' @param weight_col Name of weight column (default: "weight")
#' @param normalize Optional normalization: NULL, "all", "row", or "col"
#' @return Data frame with crosstabulation (in long format)
#' @export
#'
#' @examples
#' ct <- weighted_crosstab(df, "education_level", "gender", "employed")
#' ct_norm <- weighted_crosstab(df, "education", "gender", "employed", normalize = "row")
weighted_crosstab <- function(df,
                             row_col,
                             col_col,
                             value_col,
                             weight_col = "weight",
                             normalize = NULL) {
  
  # Create survey design
  svy_design <- df %>%
    as_survey_design(weights = !!sym(weight_col))
  
  # Remove missing values
  svy_design <- svy_design %>%
    filter(
      !is.na(!!sym(row_col)),
      !is.na(!!sym(col_col)),
      !is.na(!!sym(value_col))
    )
  
  # Calculate weighted means by row and column
  results <- svy_design %>%
    group_by(!!sym(row_col), !!sym(col_col)) %>%
    summarise(
      weighted_value = survey_mean(!!sym(value_col), na.rm = TRUE),
      .groups = "drop"
    )
  
  # Apply normalization if requested
  if (!is.null(normalize)) {
    if (normalize == "all") {
      total_sum <- sum(results$weighted_value, na.rm = TRUE)
      results <- results %>%
        mutate(weighted_value = weighted_value / total_sum)
    } else if (normalize == "row") {
      results <- results %>%
        group_by(!!sym(row_col)) %>%
        mutate(weighted_value = weighted_value / sum(weighted_value, na.rm = TRUE)) %>%
        ungroup()
    } else if (normalize == "col") {
      results <- results %>%
        group_by(!!sym(col_col)) %>%
        mutate(weighted_value = weighted_value / sum(weighted_value, na.rm = TRUE)) %>%
        ungroup()
    }
  }
  
  return(results)
}


#' Calculate Time Series Statistics
#'
#' @param df Data frame with survey data
#' @param indicator_col Name of indicator column
#' @param time_col Name of time column
#' @param weight_col Name of weight column (default: "weight")
#' @param groupby_col Optional additional grouping column
#' @return Data frame with time series statistics
#' @export
#'
#' @examples
#' ts <- time_series_stats(df, "unemployment_rate", "survey_year")
#' ts_regional <- time_series_stats(df, "income", "survey_date", groupby_col = "adm1_name")
time_series_stats <- function(df,
                             indicator_col,
                             time_col,
                             weight_col = "weight",
                             groupby_col = NULL) {
  
  # Create survey design
  svy_design <- df %>%
    as_survey_design(weights = !!sym(weight_col))
  
  # Remove missing values
  svy_design <- svy_design %>%
    filter(!is.na(!!sym(indicator_col)))
  
  # Set up grouping
  if (!is.null(groupby_col)) {
    group_vars <- c(time_col, groupby_col)
  } else {
    group_vars <- time_col
  }
  
  # Calculate statistics by time period
  results <- svy_design %>%
    group_by(across(all_of(group_vars))) %>%
    summarise(
      weighted_mean = survey_mean(!!sym(indicator_col), na.rm = TRUE, vartype = "se"),
      n = unweighted(n()),
      total_weight = sum(!!sym(weight_col), na.rm = TRUE),
      .groups = "drop"
    )
  
  return(as_tibble(results))
}


#' Calculate Design Effect
#'
#' @param df Data frame with survey data
#' @param indicator_col Name of indicator column
#' @param weight_col Name of weight column (default: "weight")
#' @return Numeric design effect value
#' @export
#'
#' @examples
#' deff <- calculate_design_effect(df, "literacy_rate")
calculate_design_effect <- function(df,
                                   indicator_col,
                                   weight_col = "weight") {
  
  # Remove missing values
  valid_data <- df %>%
    filter(
      !is.na(!!sym(indicator_col)),
      !is.na(!!sym(weight_col))
    )
  
  weights <- valid_data[[weight_col]]
  
  # Calculate effective sample size
  n <- length(weights)
  sum_weights <- sum(weights)
  sum_weights_sq <- sum(weights^2)
  
  n_eff <- (sum_weights^2) / sum_weights_sq
  deff <- n / n_eff
  
  return(deff)
}


# Example usage (commented out)
# df <- read_csv("data/survey.csv")
# 
# # National statistics
# national_stats <- national_weighted_stats(df, c("literacy_rate", "numeracy_rate"))
# print(national_stats)
# 
# # Sub-national statistics
# regional_stats <- subnational_weighted_stats(df, "literacy_rate", "adm1_name")
# print(regional_stats)
# 
# # Crosstab
# ct <- weighted_crosstab(df, "education_level", "gender", "employed", normalize = "row")
# print(ct)
