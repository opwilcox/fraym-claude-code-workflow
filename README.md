# Fraym Claude Code Workflow (R Version)

A comprehensive workflow system for Fraym data analysts to use Claude Code with R for automating data analysis tasks.

## Overview

This repository provides a standardized workflow for using Claude Code to automate common data analysis tasks at Fraym using R. The system includes:

- **claude.md**: Context file that teaches Claude about Fraym's data structure and R analysis patterns
- **Utility scripts**: Reusable R functions for common operations
- **Example workflows**: Documented patterns for common tasks (coming soon)
- **Structured workspace**: Organized folders for efficient collaboration

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

```bash
# Copy data package
cp -r /path/to/your/data-package data/

# Or create symlink
ln -s /path/to/your/data-package data/data-package
```

- Add the Master Indicator Catalog (https://docs.google.com/spreadsheets/d/1JQOLlbTORSf0O2ydmblfw9lw9LY2ZYZupVoLzT7go_E/edit?gid=981375855#gid=981375855)for your data license. This is crucial for providing claude with context for the meaning of indicators.

- If you plan to create choropleth maps, you will need to download the place-group ADM boundaries used in the data license from Fraymr since Product currently only stores zonal stats in CSV format.

### 3. Start Claude Code

```bash
# Navigate to work directory
cd work

# Start Claude Code session
claude
```

Or if you are using the VS code plugin simply open VS code in the cloned repo and open the chat box in the top right (Claud logo)

### 4. Begin Your Analysis

```r
# In Claude Code session:

# Load utility functions
source("../utils/source_all.R")

# Then describe what you want to analyze:
"Calculate weighted national literacy rates from the survey data in ../data/"
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


## Working with Claude Code

### Typical Session

```bash
cd work
claude
```

In Claude Code:
```
# Load utilities
> "Source the utility functions from ../utils/source_all.R"

# Describe dataset
> "Read and describe the survey data in ../data/education-survey.csv"

# Analysis
> "Calculate weighted literacy rates by region and create a map"

# Visualization
> "Create a bar chart comparing urban vs rural literacy rates"
```


### Best Practices

1. **Always use sampling weights**: All survey statistics functions require weight column
2. **Source utilities first**: Run `source("../utils/source_all.R")` at start of session
3. **Use relative paths**: Reference data as `../data/` from work directory
4. **Review outputs**: Check that maps and charts follow Fraym standards
5. **Save work**: Save scripts and outputs to organized subdirectories in work/

## Requirements

**Software:**
- R 4.0+ 
- Claude Code CLI
- RStudio (optional, recommended)

**R Packages:**
- tidyverse (dplyr, ggplot2, tidyr, readr)
- srvyr (survey analysis)
- sf (vector spatial data)
- terra (raster data)
- scales, patchwork (visualization)
- readxl, writexl (Excel files)

Install all packages: `Rscript setup.R`

## Configuration

```

### Customizing claude.md

Edit `claude.md` to add:
- Project-specific data conventions
- Custom analysis workflows
- Client requirements
- Additional data dictionaries

## Troubleshooting

**Issue: Package installation fails**
```r
# Try installing individually
install.packages("tidyverse")
install.packages("srvyr")
install.packages("sf")
install.packages("terra")
```

**Issue: Cannot find utility functions**
```r
# Make sure you're in work/ directory
getwd()  # Should end in .../work

# Source utilities
source("../utils/source_all.R")
```

**Issue: Weights not being applied**
```r
# All survey functions require weight_col parameter
national_weighted_stats(df, "indicator", weight_col = "weight")
```

## Contributing

See CONTRIBUTING.md for guidelines on:
- Adding new utility functions
- Improving claude.md
- Creating example workflows
- Team collaboration

## Support

- **Documentation**: See GETTING_STARTED.md and QUICK_REFERENCE.md
- **Function help**: `?function_name` or read function docstrings
- **Examples**: Check `examples/` directory

## License

Internal Fraym use. Customize as needed for your organization.

---

**Ready to start?** → See GETTING_STARTED.md

**Need quick reference?** → See QUICK_REFERENCE.md
