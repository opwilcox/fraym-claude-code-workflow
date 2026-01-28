# Fraym Claude Code Starter Pack

A comprehensive workflow for Fraym data analysts to use Claude Code with R for automating data analysis tasks.

## Overview

This repository provides a standardized workflow for using Claude Code to automate common data analysis tasks at Fraym using R. The system includes:

- **CLAUDE.md**: Context file that teaches Claude about Fraym's data structure and R analysis patterns
- **Utility scripts (utils)**: Reusable R functions for common operations
- **Example workflows (examples)**: Documented patterns for common tasks (coming soon)
- **Structured workspace (work*)*: Organized folders for efficient collaboration
- **Data Package (data)**: A folder for adding a structured Fraym data packaged


## Quick Start

### 1. Install R and Required Packages

```bash
# Install R (if not already installed)
# https://www.r-project.org/

# Clone this repository
git clone <your-repo-url>
cd fraym-claude-code-workflow

# Run setup script to install R packages
Rscript setup.R
```

### 2. Add Your Data Package

You can provide claude with any structured data package, such as a data license from product a customer-specific package. 
The package should include at a minimum:
    1. **Codebook** Lists indicators with human-readable meaning (e.g. indicator category, definition, short name) and meta-data (RMSE, collection dates etc). The Master Indicator Catalog is a good start but we recommend trimming unnecessary columns.
    2. **Zonal Statistics** Aggregated data at key administrative levels. Include ADM0 for referencing national statistics. We recommend including both in .csv and .gpkg formats.
    3. **Training Data** In-processed, weighted Fraym survey data. If the training data includes many columns for raw indicators it may be helpful to trim down to only those indicators included in the codebook. This way the codebook can server as the reference for both the zonal statistics and the training data.
    4. **Rasters** Fully post-processed rasters (e.g. masked, normalized etc). .tif file names should match the indicators in the codebook exactly. 

You can add the package with the following:

```bash
# Copy data package
cp -r /path/to/your/data-package data/

# Or create symlink
ln -s /path/to/your/data-package data/data-package
```

### 3. Complete Project section of CLAUDE.md

In this section you can add details about your project for Claude to reference. Most importantly, you must complete Data Package Structure section. Use relative paths (from the work directory). See the commented example.

### 4. Start Claude Code

There are two ways to run Claude Code.

For the CLI run:

```bash
# Navigate to work directory
cd work

# Start Claude Code session
claude
```

Or if you are using the VS code plugin, simply click the Claude logo in the top right and begin the chat.

### 4. Begin Your Analysis

```r
# In Claude Code session:
"Describe the data package"
"Do we have any indicator related to..."

# For analysis with Fraym functions:
"Calculate weighted national literacy rates from the survey data in"
"Create a choropleth map of poverty rates by region"
```

## Repository Structure

```
fraym-claude-code-workflow-r/
├── README.md                  # This file
├── GETTING_STARTED.md         # Detailed setup guide
├── QUICK_REFERENCE.md         # R function cheat sheet
├── claude.md                  # Core context for Claude Code
├── requirements.txt           # R package list
├── setup.R                    # Package installation script
│
├── utils/                     # Utility function library
│   ├── source_all.R          # Load all utilities
│   ├── survey_stats.R        # Survey statistics (weighted)
│   └── visualization.R       # Charts and maps
│
├── examples/                  # Example workflows
│   ├── survey_analysis_example.R
│   └── mapping_example.R
│
├── data/                      # Your data packages (gitignored)
│   └── .gitkeep
│
└── work/                      # Working directory
    └── .gitkeep
```
## Contributing
This repository is meant to serve as a starter pack for analysis. If you believe we should make 
an adjustment for all projects, submit a Pull Request and Analytics leadership (Marissa or Orion) will review.  

## License

Internal Fraym use. Customize as needed for your project.

