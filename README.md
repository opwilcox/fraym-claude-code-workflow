# Fraym Claude Code Workflow

A standardized workflow for Fraym analysts to run AI-assisted data analysis using Claude Code and R.

---

## What's in this repo

| Path | Purpose |
|---|---|
| `CLAUDE.md` | Project context file — Claude reads this automatically |
| `utils/` | Reusable R functions (survey stats, visualization, fraymr API) |
| `docs/` | Reference documentation for functions and standards |
| `data/` | Your data package goes here (gitignored) |
| `work/` | All analysis outputs go here (scripts, reports, figures) |

---

## Setup (do this once after cloning)

### 1. Install Claude Code
Contact Danielle Palmer to be added to Fraym's corporate Claude Account.
Follow the official installation guide: https://docs.anthropic.com/en/docs/claude-code

### 2. Install R packages

Run from the repo root:

```r
# In R or RStudio
source("utils/source_all.R")  # will show errors for any missing packages
```

Install any missing packages with `install.packages("package_name")`.

The `fraymr` package is an internal Fraym package. Install it from the internal source if not already installed. Install here: https://github.com/fraymio/fraymr

```r
library(fraymr)  # verify it loads
```


### 3. Set up your API credentials

The `fraymr` API requires credentials stored in your user-level `.Renviron` file.

**Create or open the file:**

```r
# Run this in RStudio to create/open ~/.Renviron
usethis::edit_r_environ(scope = "user")
```

**Add these two lines** (use your actual credentials):

```
INFRAYM_USER=your_email@fraym.io
INFRAYM_PASSWORD=your_password
```

Save the file, then restart R (Session > Restart R in RStudio). Credentials load automatically on every R startup — you never need to enter them again.

> **Windows note:** The file should be saved at `C:\Users\<your_username>\.Renviron`. If `usethis` is not installed, run `install.packages("usethis")` first.


### 4. Add your data package

Copy your Fraym data package into the `data/` folder:

```bash
cp -r /path/to/your/data-package data/
```

The expected structure inside `data/` is:

```
data/
└── data_package/                        # or your package folder name (e.g. usa_q1_2025)
    ├── codebook.csv
    └── [wave]/                      # e.g. data_package_09_2025
        ├── training_data/
        ├── zonal_statistics/
        ├── boundaries/
        └── rasters/
    └── [wave]/                      # e.g. data_package_09_2025
        ├── training_data/
        ├── zonal_statistics/
        ├── boundaries/
        └── rasters/
```

 If you include data packages for multiple waves, we recommend moving the codebook.csv to the /data/ folder and including all indicators for all time periods with a column indicating whether the indicator exists for that time period. 


### 5. Fill in the Project section of CLAUDE.md

Open `CLAUDE.md` and complete the **Current Project Information** and **Data Package Structure** sections at the top. This is how Claude knows what your project is about and where your files are.

At minimum, update:
- Project name and client
- `Data Package Location` path
- The paths under `Data Package Structure`

---

## Starting a Claude Code session

Always launch Claude from the `work/` directory — this is the working directory all scripts and file paths are written relative to.

**CLI:**
```bash
cd work
claude
```

**VS Code:** Open the repo in VS Code, install the Claude extension, click the Claude icon in the top-right sidebar, and start chatting.


---

## First things to try

Once Claude is running, first run this prompt to orient Claude (this may be unnecessary at this poin):

```
Review the CLAUDE.md
```
Then begin asking questions to orient yourself (and claude)

```
Describe the data package — what indicators are available?
What geographic levels are in the zonal statistics?
What place group IDs are available for the USA?
```

Then move to analysis:

```
Calculate weighted national statistics for [indicator] using the September 2025 training data
Create a choropleth map of [indicator] by state
Show me how foreign aid support varies by congressional district
```

---

## How the workflow fits together

```
CLAUDE.md          ← Claude reads this for project context (update per project)
utils/             ← Claude loads these for R functions
  source_all.R     ← loads all utils including spatial_skills.R
  survey_stats.R   ← weighted survey statistics
  visualization.R  ← charts and maps (Fraym styling)
  spatial_skills.R ← fraymr API wrappers (boundaries, WorldPop, surveys)
data/              ← your data package (never committed to git)
work/              ← launch Claude from here; all outputs saved here
  figures/         ← saved charts and maps
docs/              ← reference docs for functions and standards
```

Claude is configured to:
- Use `work/` as its working directory
- Reference `../data/` for data files
- Use `../utils/` for utility functions
- Follow Fraym naming conventions and visual standards automatically

---

## Contributing

This repo is a shared starter pack. If you find an improvement that would benefit all projects, open a Pull Request — Analytics leadership (Marissa or Orion) will review.
