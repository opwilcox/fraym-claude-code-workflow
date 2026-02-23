#!/usr/bin/env Rscript
#' Data Package Exploration Helpers
#'
#' Utility functions for discovering and validating Fraym data packages.
#' Source via source_all.R or individually: source("../utils/explore.R")

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
})

#' Explore a Fraym data package folder
#'
#' Lists the contents of a data package, summarizing top-level folders
#' and file types found recursively.
#'
#' @param pkg_path Path to the data package root directory
#' @return Invisible character vector of all file paths
#' @examples
#' fraym_explore_package("../data/Iraq 2025")
fraym_explore_package <- function(pkg_path) {
  if (!dir.exists(pkg_path)) {
    stop("Package path not found: ", pkg_path)
  }

  cat("=== Data Package:", pkg_path, "===\n\n")

  # Top-level contents
  top <- list.files(pkg_path, full.names = FALSE)
  cat("Top-level items:\n")
  for (item in top) {
    full <- file.path(pkg_path, item)
    type <- if (dir.exists(full)) "[dir]" else "[file]"
    cat("  ", type, item, "\n")
  }

  # Recursive file listing
  all_files <- list.files(pkg_path, recursive = TRUE, full.names = FALSE)
  exts <- tools::file_ext(all_files) |> toupper()
  ext_counts <- sort(table(exts[exts != ""]), decreasing = TRUE)

  cat("\nFile types found:\n")
  for (i in seq_along(ext_counts)) {
    cat("  ", names(ext_counts)[i], ":", ext_counts[i], "file(s)\n")
  }
  cat("\nTotal files:", length(all_files), "\n")

  invisible(all_files)
}

#' Read and summarize a Fraym codebook
#'
#' Reads codebook.csv and prints available indicators grouped by category.
#'
#' @param codebook_path Path to codebook.csv
#' @return Invisible tibble of the full codebook
#' @examples
#' codebook <- fraym_read_codebook("../data/Iraq 2025/codebook.csv")
fraym_read_codebook <- function(codebook_path) {
  if (!file.exists(codebook_path)) {
    stop("Codebook not found: ", codebook_path)
  }

  codebook <- suppressMessages(read_csv(codebook_path))
  cat("=== Codebook:", codebook_path, "===\n\n")
  cat("Total indicators:", nrow(codebook), "\n")
  cat("Columns:", paste(names(codebook), collapse = ", "), "\n\n")

  # Print by category if category column exists
  cat_col <- intersect(c("category", "Category", "CATEGORY"), names(codebook))[1]
  id_col  <- intersect(c("indicator_id", "id", "ID", "indicator"), names(codebook))[1]
  nm_col  <- intersect(c("indicator_name", "name", "Name", "label"), names(codebook))[1]

  if (!is.na(cat_col) && !is.na(id_col)) {
    cats <- sort(unique(codebook[[cat_col]]))
    for (cat_val in cats) {
      rows <- codebook[codebook[[cat_col]] == cat_val, ]
      cat(cat_val, "(", nrow(rows), "indicators )\n")
      if (!is.na(nm_col)) {
        for (i in seq_len(min(5, nrow(rows)))) {
          cat("  -", rows[[id_col]][i], ":", rows[[nm_col]][i], "\n")
        }
        if (nrow(rows) > 5) cat("  ... and", nrow(rows) - 5, "more\n")
      }
      cat("\n")
    }
  } else {
    print(codebook, n = 20)
  }

  invisible(codebook)
}

#' Summarize a Fraym training dataset
#'
#' Reads training data, confirms key columns, and prints a summary of
#' dimensions, the weight column, and demographic grouping variables.
#'
#' @param training_path Path to training CSV file
#' @param weight_col Name of the weight column (from CLAUDE.md Project section)
#' @return Invisible tibble of the training data
#' @examples
#' training <- fraym_summarize_training(
#'   "../data/Iraq 2025/Training Data/data_package_09_2025.csv",
#'   weight_col = "pop_wgt_unclustered"
#' )
fraym_summarize_training <- function(training_path, weight_col = "pop_wgt") {
  if (!file.exists(training_path)) {
    stop("Training data not found: ", training_path)
  }

  training <- suppressMessages(read_csv(training_path))
  cat("=== Training Data:", training_path, "===\n\n")
  cat("Rows:", format(nrow(training), big.mark = ","), "\n")
  cat("Columns:", ncol(training), "\n\n")

  # Weight column check
  if (weight_col %in% names(training)) {
    wt_summary <- summary(training[[weight_col]])
    cat("Weight column (", weight_col, "): OK\n")
    cat("  Min:", round(wt_summary["Min."], 4),
        " Mean:", round(wt_summary["Mean"], 4),
        " Max:", round(wt_summary["Max."], 4), "\n\n")
  } else {
    cat("WARNING: Weight column '", weight_col, "' NOT FOUND\n")
    wt_cols <- grep("wgt|weight|Weight", names(training), value = TRUE)
    if (length(wt_cols) > 0) cat("  Possible weight columns:", paste(wt_cols, collapse = ", "), "\n")
    cat("\n")
  }

  # Demographic grouping columns
  demo_candidates <- c("age_group", "gender", "race", "income", "education",
                       "urban_rural", "region", "governorate", "admin1")
  demo_found <- intersect(demo_candidates, names(training))
  if (length(demo_found) > 0) {
    cat("Demographic grouping columns found:\n")
    for (col in demo_found) {
      n_levels <- length(unique(training[[col]]))
      cat("  -", col, "(", n_levels, "levels )\n")
    }
    cat("\n")
  }

  # Indicator columns (lowercase dummies at end)
  all_cols <- names(training)
  lower_cols <- all_cols[all_cols == tolower(all_cols)]
  non_meta <- setdiff(lower_cols, c(demo_candidates, weight_col, "id", "uuid",
                                     "latitude", "longitude", "lat", "lon",
                                     "admin1", "admin2", "admin3"))
  cat("Potential indicator columns (lowercase dummies):", length(non_meta), "\n")
  if (length(non_meta) > 0) {
    cat("  First 10:", paste(head(non_meta, 10), collapse = ", "), "\n")
  }

  invisible(training)
}

#' Check that all configured data paths exist
#'
#' Accepts a named list of paths, runs file.exists() on each, and
#' prints a pass/fail report.
#'
#' @param paths Named list or vector of paths to check
#' @return Invisible logical vector (TRUE = found, FALSE = missing)
#' @examples
#' fraym_check_paths(list(
#'   codebook  = "../data/Iraq 2025/codebook.csv",
#'   training  = "../data/Iraq 2025/Training Data/data_package_09_2025.csv",
#'   zonal_csv = "../data/Iraq 2025/Zonal Statistics/adm1_stats.csv",
#'   zonal_gpkg = "../data/Iraq 2025/Zonal Statistics/adm1_stats.gpkg"
#' ))
fraym_check_paths <- function(paths) {
  results <- vapply(paths, file.exists, logical(1))
  cat("=== Path Check ===\n\n")
  for (i in seq_along(results)) {
    status <- if (results[i]) "\u2713 FOUND  " else "\u2717 MISSING"
    cat(" ", status, names(results)[i], "\n   ", paths[[i]], "\n\n")
  }
  n_ok      <- sum(results)
  n_missing <- sum(!results)
  cat("Result:", n_ok, "found,", n_missing, "missing\n")
  if (n_missing > 0) cat("Fix missing paths in your script before proceeding.\n")
  invisible(results)
}
