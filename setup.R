#!/usr/bin/env Rscript
#' Setup Script for Fraym Claude Code Workflow (R)
#' 
#' This script installs all required R packages for the workflow.
#' Run once during initial setup.

cat("=== Fraym Claude Code Workflow - R Setup ===\n\n")

# Function to install packages if not already installed
install_if_missing <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(new_packages) > 0) {
    cat("Installing packages:", paste(new_packages, collapse = ", "), "\n")
    install.packages(new_packages, repos = "https://cloud.r-project.org/")
  } else {
    cat("All packages already installed.\n")
  }
}

# Core packages
cat("\n1. Installing core packages...\n")
install_if_missing(c("tidyverse", "devtools"))

# Survey analysis
cat("\n2. Installing survey analysis packages...\n")
install_if_missing(c("survey", "srvyr"))

# Geospatial
cat("\n3. Installing geospatial packages...\n")
install_if_missing(c("sf", "terra", "exactextractr"))

# Visualization
cat("\n4. Installing visualization packages...\n")
install_if_missing(c("scales", "patchwork", "ggspatial"))

# File handling
cat("\n5. Installing file handling packages...\n")
install_if_missing(c("readxl", "writexl", "haven"))

# Optional utilities
cat("\n6. Installing optional utility packages...\n")
install_if_missing(c("janitor", "lubridate", "glue"))

# Verify installation
cat("\n=== Verifying Installation ===\n")
required_packages <- c(
  "tidyverse", "srvyr", "sf", "terra", 
  "scales", "readxl"
)

all_installed <- TRUE
for (pkg in required_packages) {
  if (require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat("✓", pkg, "\n")
  } else {
    cat("✗", pkg, "- FAILED\n")
    all_installed <- FALSE
  }
}

if (all_installed) {
  cat("\n✓ All required packages installed successfully!\n")
  cat("\nYou can now use the Fraym Claude Code workflow.\n")
  cat("Start by reading GETTING_STARTED.md\n")
} else {
  cat("\n✗ Some packages failed to install.\n")
  cat("Please install them manually:\n")
  cat("install.packages(c('package1', 'package2'))\n")
}
