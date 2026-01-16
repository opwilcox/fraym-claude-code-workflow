# Fraym Data Analysis Context

This file provides Claude Code with essential context about Fraym's data structure, analysis patterns, and quality standards.

## About Fraym

Fraym provides high-resolution geospatial data and analytics focused on population characteristics, behaviors, and attitudes globally. Fraym data scientists combine survey data, satellite imagery, large-scale geospatial datasets, and machine learning to generate insights at fine geographic resolutions.

### Fraym Methods

#### What is Fraym data?

Fraym has built an artificial intelligence / machine learning (AI/ML) technology that weaves together high-quality household survey data with satellite imagery and other demographic and socioeconomic data covariates to create localized population information. Fraym's surveys include questions on:

- Demographics
- Socioeconomics
- Norms
- Behaviors
- Motivation and ability
- Media Use
- Influencers
- And other indicators

Fraym's AI/ML technology uses geotagged survey responses, along with satellite imagery layers, to predict the percentage of respondents who exhibit the given characteristic within each one km² grid cell (e.g., the percentage of the population who completed high school; the percentage of the population who use contraceptives). Fraym has provided a Codebook detailing specific definitions and the related survey question for each indicator provided.

#### What data do Fraym's AI/ML models use?

The first data input is primary data from scientifically sampled, geo-tagged household surveys. Fraym has collected or accessed, cleansed, and harmonized more than 1,000 surveys from around the world. Key indications of a high-quality household survey include implementing organization(s), sample design, sample size, and response rates. After data collection, post-hoc sampling weights are created to account for any oversampling and ensure representativeness.

The second major data input is satellite imagery and related derived data products, including earth observation (EO) data, gridded population information (e.g., human settlement mapping), proximity to physical locations (e.g., health clinics, ports, roads, etc.), proximity to significant events (e.g., political protests, labor strikes, extremist attacks), and biophysical surfaces like soil characteristics, and demographic and socioeconomic covariates derived from national population and housing censuses or other large official household surveys. As with the survey data, Fraym data scientists ensure that the software only uses high-quality imagery and derivative inputs.

#### How does Fraym collect survey data?

Fraym applies industry best practices to ensure that all geotagged survey training data for our AI/ML models is of the highest standard. Key indications of a high-quality household survey include implementing organization(s), sample design, sample size, and response rates. Fraym regularly works with vendors to carry out large-scale household surveys. This quality assurance and quality control (QA/QC) process entails five key steps: (1) survey vendor selection; (2) survey panel composition review; (3) questionnaire design; (4) survey implementation protocols and controls; and (5) response quality assurance.

1. **Survey Vendor Selection**: Fraym conducts extensive and ongoing reviews of major survey vendors globally. Our selection criteria include a range of factors, such as ESOMAR certification, QA/QC protocols and controls, size and scale, geographic coverage (global, regional, country-specific), and other considerations. We will only work with the highest quality and most reputable survey vendors.

2. **Survey Panel Composition and Sample Representativeness**: Fraym carefully considers sample representativeness measures in conjunction with the survey vendor selection process. For existing respondent panels, we will closely examine recruitment and retention methods. This includes a well diversified set of online and offline recruitment activities to ensure appropriate representation of difficult to reach demographic groups. Moreover, we stress test the vendors' ability to meet Fraym's demanding sampling quotas across demographic, socioeconomic and geographic dimensions. Outside of existing respondent panels, Fraym will only work with vendors who meet best practice standards for probabilistic sampling such as random digit dialing (RDD) for computer-assisted telephone interviews (CATI) and customizing interview times to maximize access in difficult-to-reach demographic groups.

3. **Questionnaire Design**: Fraym typically designs questionnaires as a consumer lifestyle and/or brand preference survey. Consumer companies frequently gather information about lifestyles, media consumption, health and wellness, and attitudes about a range of topics to establish psychographic profiles and segment the broader population into target consumer groups. Given this, the Fraym questionnaire appears almost indistinct from thousands of other ongoing consumer surveys commissioned by or on behalf of retail companies, fast moving consumer goods (FMCG) companies, or other consumer-facing businesses. As a general practice, Fraym draws heavily from research survey questions that have been successfully fielded over time. Fraym consults with regional subject matter experts (SMEs) to validate both the underlying reference survey and specific survey questions as reliable for collecting accurate and truthful responses. Moreover, Fraym consults with regional SMEs about survey module sequencing/placement and question framing considerations while constructing the questionnaire.

4. **Survey Implementation Protocols and Controls**: Fraym carefully designs the survey introduction language to accurately communicate the general focus, explicitly mention that limited respondent location data will be requested, and proactively provide privacy and anonymity assurances. These components are very important for setting respondents' expectations and building confidence in the survey itself. During survey fielding, Fraym ensures that its preferred survey vendors adhere to industry best practices. These include: (i) regularly testing/validating on a rolling basis to ensure participants and their responses are real and accurate; (ii) comparing answers from respondents to pre-collected information on the same respondents for consistency, such as same age, gender, socio-economic status, and geography; (iii) using automated natural language processing (NLP) on open-ended responses to detect nonsensical language etc.; (iv) check for straight lining (e.g. answering "C" for all questions); (v) checking the speed of completion rates, (e.g. flagging anyone who spends 1/3 or less of the median time to complete the questionnaire); (vi) investigating interview recordings and transcripts for completeness and accuracy; and (vii) recontacting a randomly selected subset of respondents for further accuracy checks. Responses that fail any of these tests are automatically removed from the survey dataset and the survey vendor may decide to remove that respondent from their panel as well.

5. **Response Quality Assurance**: Once receiving the raw survey dataset, Fraym then applies an additional set of QA/QC measures. The following represents a subset of these data response quality assurance practices:
   - First, Fraym uses algorithms to assess whether respondents' answers to the location-based questions (province, prefecture, county/district, postal code) are internally consistent. Next, we will convert the responses into latitude and longitude coordinates and visualize all observations in GIS software for a further human-in-the-loop assessment. Any flagged observations during these steps are excluded from the training dataset.
   - Second, Fraym examines respondent behaviors on specific survey questions that may be particularly important or sensitive and benchmark these related metrics to other survey results as appropriate/possible.
   - Third, Fraym explores the distribution of the surveyed data to identify any observation outliers or variables with anomalous results. Fraym data scientists then closely examine any associated observations or variables and determine whether they should be excluded from the dataset.

#### How does Fraym cleanse and harmonize data inputs?

Fraym data scientists apply a rigorous set of measures to clean, harmonize, and validate microdata inputs. The following represents a subset of these practices applied to the geo-referenced microdata. First, Fraym uses algorithms to assess whether respondent's answers to the location-based questions (i.e., county, sub-county, ward, postal code, etc.) are internally consistent. This ensures that our survey recruitment methods consistently target the selected enumeration areas. Next, Fraym examines respondent behaviors on specific, particularly important or sensitive survey questions and benchmark these related metrics to other survey results as appropriate/possible. This includes respondent drop-off rates for these specific survey questions and the amount of time taken to complete each survey question when available. Third, we explore the distribution of the surveyed data to identify any observation outliers or variables with anomalous results. Fraym data scientists closely examine any associated observations or variables and determine whether they should be excluded from the dataset. Fourth, we pay special attention to non-response bias by question to ensure that each question has an adequate sample size and any non-response can be considered random. Missing values are treated in appropriate, industry-standard ways.

After data collection, post-hoc sampling weights are created to account for any over/under sampling and ensure representativeness. Additional quality assurance is spent on the sample weights. At times, Fraym data scientists make modest adjustments to design weights (e.g., post-hoc weight adjustments), to account for any oversampling/undersampling and to ensure survey representativeness. Population parameters are drawn from population censuses, other official survey datasets (pending examination and verification), and third-party sources like the United Nations (UN), thereby ensuring comparability across countries.

For every data input, a final manual quality assurance occurs after the use of automated tools. Overall, the harmonization and cleansing process ensures that FUSEfraym™ only ingests highest quality inputs to enable robust and reliable spatial data outputs and derivative zonal statistics.

#### How does the software produce a spatial layer of population characteristics?

To create spatial layers from survey training data, Fraym uses a model-stacking machine learning approach to predict a continuous surface of the indicator of interest at a 1 km² resolution. This methodology builds upon existing, tested methodologies for interpolation of spatial data. The FUSEfraym™ technology creates a model that identifies correlations between the scientifically sampled survey data at enumeration clusters and typically several hundred spatial covariates from the exact location. The resulting model predicts the survey data for all non-enumerated areas. A similar approach was pioneered by USAID's Demographic and Health Surveys program in 2015 and has since been significantly improved upon by Fraym and others.

FUSEfraym's machine learning process involves generating predictions from a set of base-learner models and using those predictions to train a super-learner model. By leveraging multiple base models, the technology can improve final predictions across large geographies. Models are tuned and evaluated using industry-standard cross-validation techniques, and the predictive power of smaller data sets is increased through systems of boosting, bagging, and k-fold cross validation.

Populated grid cells with no survey data are predicted by applying a model using the parameters generated in the train and tune process. For every data layer, Fraym data scientists examine the standard model metrics such as R-squared and Root Mean Square Error (RMSE) to relay quality. Generally, data layers have very robust quality metrics. For example, a RMSE value of 0.025 for a proportional question from the survey (e.g., proportion of adults with secondary education) means that roughly the average error between the prediction and the held-out enumeration area data was 2.5 percentage points. For proportional variables, if RMSE is greater than 0.1, then data layers are not used in production. Similar thresholds are applied to non-proportional variables. In addition, Fraym data scientists compare the spatial surface to the lowest representative administrative level (e.g., regions) of the survey. At this level, the survey mean is compared against the implied mean of the surface when all grids are appropriately aggregated through population weighted zonal statistics. Fraym data scientists assesses whether the survey results are statistically consistent with the model-predicted mean using a binomial test. If the observed survey responses would be improbable under the model's predicted proportion, the data layer does not pass validation and is noted in the data package's documentation.

For each layer, Fraym also generates a pixel-level prediction interval. Prediction intervals are an estimated range of individual values that could be observed in future samples. They are used to evaluate certainty about the predictions created from a model. Fraym has adjusted existing spatial methodology to generate intervals using a combination of bootstrapping and k-fold cross validation. Our multi-step method combines a distribution of sample error terms with standard deviation to capture error and instability from multiple model types. The outputs from this approach are upper and lower bound estimates at the 1 km² level.

#### How do I interpret Fraym data?

Fraym model outputs are aggregated to different geographic levels (e.g., neighborhoods, cities, counties, provinces, etc.,) as needed. In Kenya, this includes counties, sub-counties, and wards. In Nigeria, this includes states, local government areas, and wards. In addition, these layers can be combined with other information, such as population densities, city boundaries, and points of interest to provide additional insights to inform decision making.

Proportions can be interpreted as the proportion of the population displaying a given characteristic. For example, if in our data extract one witnesses a 20 percent use of contraceptives among adolescents and young adults in a given ward, that should be interpreted as indicating that 20 percent of adolescents and young adults (ages 15-24) living in that ward use contraceptives.

#### Can Fraym data be compared over time?

Fraym provides information on a variety of sociodemographic indicators. Some of these indicators, such as media usage and attitudes, can be tracked over time. Fraym has taken steps to ensure that data layers on these indicators can be compared over time. Starting with the inputs, survey data are balance tested using statistical measures to ensure comparability between quota and survey and between survey periods. This ensures that changes in the input data are due to factors exogenous to population differences.

Our spatial covariates are aggregated to capture time specific correlations based on spatiotemporal patterns in the model covariates. Models are then tuned and tested on comparable input data and covariates across time periods. Fraym also adjusts the modeling process by reducing the number of run super learners in order to maintain model stability and performance across time.

By stabilizing the inputs data and processes, data layers produced with the same indicator of interest can be compared over time.

#### How has Fraym validated the data produced by its technology?

Fraym has performed a quasi-ground truth validation exercise in a number of countries. Fraym first identified potential test countries for census validation. Ideally, this country would have an accessible census conducted within one to two years of a high-quality household survey. Two census candidates were selected: Tanzania 2012 and Rwanda 2012.

Because the number of individuals with some characteristic (e.g. number of people with secondary education) is often of importance to users, Fraym converted the modeled proportion surface to population totals by multiplying with a standard population raster - in this case LandScan 2012. One inconsistency addressed was the difference between LandScan and Census population totals. For example, the Tanzania 2012 Census has a total population of approximately 44 million and the 2012 LandScan raster has a total population of about 46 million (for Tanzania). To compare the modeled surfaces and Census equitably, Fraym used a rate difference metric.

The rate difference is calculated for each administrative division by dividing the population identified by the indicator by the total population of that administrative division (i.e., the number of people who have completed secondary education or higher, divided by the total number of people in that administrative division). For the modeled surface, the denominator (total population) is summed from LandScan. The Census denominator (total population) is calculated from the Census survey data. The rate difference, as calculated by Fraym, is the absolute difference between these two outputs.

The most granular geographic unit in the Tanzania Census is the district, or the second administrative boundary level. Consequently, Fraym's modeled raster data was compared to the census data by calculating the mean rate difference at the district level. For the Census, the district variable was used to calculate rate differences and for the Fraym modeled raster the rate difference was calculated using Fraym's internal weighted zonal statistics methodology. In Rwanda, the most granular administrative unit in the census was the sector, or the third administrative division. The same process noted above was used for Rwanda.

Fraym identified a set of variables for which data was available in both the high-quality household survey and the census. Absolute differences at the lowest level available in the census are presented for these variables averaged at the national level. For example, in Jenda district for secondary education the absolute rate difference is 0.0001277. The census mean for secondary education is 2.863 percent and the aggregated predictions from the Fraym model calculate the mean to be 2.851 percent, less than a 1 percentage point difference. The average of these percentage point differences in the benchmark indicator values for all districts or sectors is presented below.

**ABSOLUTE RATE DIFFERENCE FOR BENCHMARK INDICATORS, TANZANIA AND RWANDA:**

Tanzania District Average:
- Upper- and Middle-Class Consumers: 1.0%
- Secondary Education: 2.9%

Rwanda Sector Average:
- Piped Water: 2.9%
- Upper- and Middle-Class Consumers: 1.6%
- Asset Ownership: 1.5%
- Secondary Education: 1.3%

#### Appendix 1: Fraym Standard Geospatially Derived Model Covariates

1. Distance to electrical grid
2. Accessibility to cities
3. Built up surface area
4. GDP economic activity
5. Global impervious surface
6. Distance to primary road
7. Global poverty estimate
8. Distance to primary roads
9. GPW population density (2015)
10. GPW population density estimates (2020)
11. Political boundaries (i.e., states or provinces)

MODIS Products (Summary Statistics):
12. Fpar
13. Leaf area index
14. Surface reflectance bands 1-7
15. Land surface temperature
16. EVI
17. NDVI

Soil Grids:
18. Soil Ph Levels
19. Sand content
20. Carbon content

Nighttime Lights:
21. Nighttime Lights

Precipitation:
22. Annual precipitation
23. Precipitation – wettest month
24. Precipitation – driest month
25. Annual mean temperature
26. Max Temperature – warmest month
27. Min Temperature – coldest month

Population:
28. WorldPop – population count

Additional Fraym Created Features:
- Elevation derivatives
- Transformations of above features
- Demographic and socioeconomic covariates derived from national population and housing censuses, or other large official household survey results

### Project Info

**Survey Info:**
- Target sample size: 4,000
- Actual sample size: 4,070
- Clustered sample / # clusters: 3,949 / 212
- Median LOI: 13 minutes
- Survey mode: CATI
- Data collection period(s): 18 August 2025 - 5 October 2025
- Survey instrument languages: Arabic, Kurdish
- Survey Representativeness: Nationally representative of the general population of Adults 18 - 70

## Working Directory Standards

### Default Work Folder

**ALWAYS use the `work/` folder for all analysis outputs:**
- All R scripts and R Markdown files
- All generated reports (HTML, PDF, etc.)
- All intermediate outputs and temporary files
- All visualizations saved as standalone files

The `work/` folder is version controlled and serves as the project's working directory for analysis outputs.

**Folder Structure:**
```
fraym-claude-code-workflow/
├── work/               # ALL analysis work goes here (DEFAULT)
│   ├── *.R            # R scripts
│   ├── *.Rmd          # R Markdown reports
│   ├── *.html         # Rendered reports
│   ├── *.pdf          # PDF outputs
│   └── figures/       # Visualization outputs
├── data/              # Source data (READ ONLY)
├── utils/             # Utility functions (REFERENCE ONLY)
└── CLAUDE.md          # This file
```

### File Organization

**Reports and Scripts:**
- Save all analysis files to `work/`
- Use descriptive filenames with dates when relevant
- Example: `work/tiktok_analysis_2025-01-16.Rmd`

**Figures:**
- Save standalone figures to `work/figures/`
- Use consistent naming: `{analysis}_{figure_type}_{date}.png`
- Example: `work/figures/tiktok_usage_by_state_2025-01-16.png`

## Data Structure

### Typical Data Package Contents

Fraym data packages typically contain:

#### Assets Typically Used in Analysis

1. **Master Indicator Catalog** (CSV)
   - Full list of indicators
   - Module (from survey)
   - Raw Code (code for question in survey used to collect training data for indicator)
   - Indicator ID (unique identifier of indicator, this code (with an iso3 prefix) will also be the name of the GeoTIFF file for that indicator)
   - Indicator Name (human readable name for the indicator to be used in reports, graphics, tables etc)
   - Indicator Description (longer descriptive explanation of the indicator meaning)
   - Category (thematic category for the indicator)
   - Raw Question (from survey)
   - Extraction Type (how indicator was processed into a dummy variable for machine learning)
      - BINARY (yes = 1, no = 0)
      - CATEGORICAL (each selected option gets a 1 if selected and 0 if not selected)
      - LIKERT POSITIVE (1 if options in the column Likert positive answer choices are selected)
      - LIKERT NEGATIVE (1 if options in the column Likert negative answer choices are selected)
   - Sort (logical ordering of indicators)
   - National Proportion (the weighted mean for that indicator nationally)

2. **labeled_training_data** (folder)
   - codebook (list of questions and responses e.g. syr_sagittarrius_2025_codebook)
   - processed and weighted survey data (syr_sagittarisu_2025_weighted)
      - lowercase snake-case columns are the in-processed dummified indicators that have been modelled and should be used for analysis in most cases
      - other key columns:
         - pop_wgt - Raking Weight used in calculations
         - lat_clustered - clustered latitude point used for producing training data
         - lon_clustered - clusted longitude point used for producing training data

3. **final_rasters** (folder)
   - modelled surfaces produced by the ML. Each raster is 1sq. km. resolution. Each pixel contains a propotion (0-1) which represents the proportion of the population that has the characteristic that has been modelled (e.g. speaks Arabic, voted in the last election, owns a mobile phone, is vaccinated)
   - may contain subfolders
      - masked - rasters that have been masked to only show populated locations within a country (default for analysis)
      - raw_tifs - unmasked
      - prediction intervals (noise modelling - rarely used in analysis unless prompted)

4. **zonal_statistics** (folder)
   - aggregated data from rasters to specific geographic units (typically CSV)
   - each CSV includes an id and place_group_id column
   - admin boundaries (Geopackage format) - contain spatial boundaries used for zonal stats. Join these to the zonal stats on the id column to create choropleth maps.

5. **questionnaires**
   - Actual questionnaire in tabular format (only used as reference)

#### Assets that may be relevant for background information but are typically not used in analysis

6. **raw_data** (raw survey data)
7. **survey_metrics** (survey metrics such as completes, refusals, LOI)
8. **quota_performance** (completion of key demographic target quotas)
9. **geocoding** (map of clustered locations used in modelling)

## Analysis Patterns

### 1. Exploratory Data Analysis

Many high-level questions (national stats, indicator availability, national-level time series, pre-calculated sub-national stats) can be answered simply by reading and parsing the following assets:

1. Read project info for general information about survey fielding
2. Read and parse the Master Indicator Catalog
   - Identify indicator categories (demographics, health, education, etc.)
   - Identify Indicators
   - Indicator Indicator Name
   - Indicator Description
   - National Level statistics
   - Time periods for which data are available (if multiple)
3. Read and parse zonal stats for subnational data at key geographic units
4. Read and parse the questionnaire if question-specific information is required

**Output**: Report responses directly in the chat unless prompted otherwise

### 2. Survey Stats

**Always use sampling weights** when calculating survey statistics.

When providing sub-national statistics or crosstabulations, always provide the national stat for reference.

Use the utility functions in `utils/survey_stats.R` for these calculations.

### 3. Data Visualization

**Fraym Color Scheme:**

#### PRIMARY PALETTE

- **Dark Blue**: #00162b
- **Electric Blue**: #202da5
- **Teal**: #196160
- **Aqua**: #1dd8b0
- **Bright Green**: #94d931

#### NEUTRAL PALETTE

- **Charcoal**: #393e50
- **Dark Gray**: #696b78
- **Gray**: #d6d9dd
- **Pale Gray**: #f2f2f2
- **Dark Sand**: #8f9092
- **Sand**: #d8d5ca
- **Pale Sand**: #efeee8

#### EXTENDED PALETTE

Colors:
- **Purple**: #7152e2
- **Dark Red**: #5b2036
- **Red**: #d44244
- **Orange**: #e8b934
- **Yellow**: #efeb6a
- **Dark Green**: #237d07

#### Color Ramps

Maps generated by Fraym should be styled with one of the color ramps noted on this page. Color ramps (also called gradients) have been designed to provide flexibility when visualizing the map data while still matching the overall color palette of the Fraym brand. The Colorblind-Friendly ramp is designed to maintain legible contrast for readers with deuteranopia and protanopia colorblindness.

**NOTE:** Grayscale should only be used in scenarios where color is not available to display a map. For example, in black and white documents that will be printed and/or faxed. Do not use the Grayscale ramp in any scenario that color is otherwise available.

**Sequential Ramps:**

Hello Darkness: `#f2f2f2` → `#1dd3b0` → `#196160`

Magma: `#0b162b` → `#7152e2` → `#d44244` → `#e8b934` → `#efe6ba`

Go Green: `#f2f2f2` → `#94d931` → `#257d07`

Off-Grid: `#efe6ba` → `#94d931` → `#1dd3b0` → `#2024a5` → `#196160` → `#0b162b`

Candy Floss: `#f2f2f2` → `#2024a5`

Grayscale (SEE NOTE): `#ffffff` → `#000000`

Candy Apple: `#efeee8` → `#d44244` → `#3b2036`

Population Blues: `#f2f2f2` → `#1dd3b0` → `#196160` → `#2024a5`

**Divergent Ramps:**

Sunshine: `#196160` → `#f2f2f2` → `#efe6ba`

Polar: `#1dd3b0` → `#f2f2f2` → `#7152e2`

Peach Rings: `#efeee8` → `#efe6ba` → `#e8b934` → `#d44244`

Hot and Cold: `#d44244` → `#393e80` → `#1dd3b0`

Concord: `#f2f2f2` → `#7152e2` → `#3b2036`

Colorblind-Friendly: `#2024a5` → `#f2f2f2` → `#d44244`

#### Chart Types

**Choropleth Maps:**
- Show geographic variation in a single indicator across geographic units
- Use diverging color schemes for indicators with meaningful center point
- Use sequential schemes for count or rate data
- Always include legends with clear labels
- Include scale bar and north arrow for formal publications

**Raster Maps:**
- Show geographic variation in a single indicator at 1 square kilometer level
- Use diverging color schemes for indicators with meaningful center point
- Use sequential schemes for count or rate data
- Always include legends with clear labels
- Include scale bar and north arrow for formal publications
- Often requires a zoom in to show meaning (but not always)

**Bar Charts:**
- Compare values across categories
- Sort by value (descending) unless natural order exists
- Use horizontal bars for long category names
- Include data labels for key values
- **NO error bars** unless explicitly requested
- **Narrow bars with gaps** between them (width = 0.7 or less)
- **NO vertical text** - use subtitle instead of rotated y-axis titles
- **NO coord_flip() y-axis titles** - include context in subtitle

**Line Charts:**
- Show trends over time
- Use distinct colors for multiple series
- Include markers for data points
- Add reference lines for targets or thresholds

**Tables:**
- Round to appropriate precision (usually 1-2 decimal places)
- Include sample sizes or confidence intervals where relevant
- Use clear column headers
- Apply conditional formatting for emphasis

Use the utility functions in `utils/visualization.R` for these outputs.

## Utility Functions Reference

Quick reference for available utility functions (load with `source("utils/source_all.R")`):

**Survey Statistics (utils/survey_stats.R):**
- `national_weighted_stats()`: National-level weighted statistics
- `subnational_weighted_stats()`: Stats by admin level or demographics
- `weighted_crosstab()`: Weighted crosstabulation
- `time_series_stats()`: Time series analysis
- `calculate_design_effect()`: Design effect calculation

**Visualization (utils/visualization.R):**
- `create_choropleth()`: Choropleth map
- `create_raster_map()`: Raster map with optional boundaries
- `create_bar_chart()`: Bar chart
- `create_line_chart()`: Line chart
- `save_fraym_plot()`: Save plot with Fraym standards
- `FRAYM_COLORS`: Color palette list
- `FRAYM_PALETTES`: Color scheme lists

See individual utility files for detailed documentation and examples.


## Quality Standards

### Data Validation
- Always check for missing weights before calculating survey statistics
- Verify geographic joins (ensure no unmatched records)
- Check sample sizes (flag if n < 30 for subgroups)
- Validate indicator ranges (flag impossible values)

### Statistical Reporting
- Report weighted statistics (unless explicitly asked for unweighted)
- Include confidence intervals for survey estimates when possible
- Flag results with small sample sizes
- Note any data quality limitations

### Visualization Quality
- Clear, descriptive titles
- Properly labeled axes with units
- Legends positioned appropriately
- Color schemes appropriate for data type
- Consistent styling across related charts

### Documentation
- Document data sources and versions
- Note any data transformations or exclusions
- Explain methodological choices
- Provide reproducible code

## Coding Style Guide

Always Use R.

# Modern R Development Guide

*This document captures current best practices for R development, emphasizing modern tidyverse patterns, performance, and style. Last updated: August 2025*

## Core Principles

1. **Use modern tidyverse patterns** - Prioritize dplyr 1.1+ features, native pipe, and current APIs
2. **Profile before optimizing** - Use profvis and bench to identify real bottlenecks
3. **Write readable code first** - Optimize only when necessary and after profiling
4. **Follow tidyverse style guide** - Consistent naming, spacing, and structure

## Modern Tidyverse Patterns

### Pipe Usage (`|>` not `%>%`)
- **Always use native pipe `|>` instead of magrittr `%>%`**
- R 4.3+ provides all needed features

```r
# Good - Modern native pipe
data |>
  filter(year >= 2020) |>
  summarise(mean_value = mean(value))

# Avoid - Legacy magrittr pipe
data %>%
  filter(year >= 2020) %>%
  summarise(mean_value = mean(value))
```

### Join Syntax (dplyr 1.1+)
- **Use `join_by()` instead of character vectors for joins**
- **Support for inequality, rolling, and overlap joins**

```r
# Good - Modern join syntax
transactions |>
  inner_join(companies, by = join_by(company == id))

# Good - Inequality joins
transactions |>
  inner_join(companies, join_by(company == id, year >= since))

# Good - Rolling joins (closest match)
transactions |>
  inner_join(companies, join_by(company == id, closest(year >= since)))

# Avoid - Old character vector syntax
transactions |>
  inner_join(companies, by = c("company" = "id"))
```

### Multiple Match Handling
- **Use `multiple` and `unmatched` arguments for quality control**

```r
# Expect 1:1 matches, error on multiple
inner_join(x, y, by = join_by(id), multiple = "error")

# Allow multiple matches explicitly
inner_join(x, y, by = join_by(id), multiple = "all")

# Ensure all rows match
inner_join(x, y, by = join_by(id), unmatched = "error")
```

### Data Masking and Tidy Selection
- **Understand the difference between data masking and tidy selection**
- **Use `{{}}` (embrace) for function arguments**
- **Use `.data[[]]` for character vectors**

```r
# Data masking functions: arrange(), filter(), mutate(), summarise()
# Tidy selection functions: select(), relocate(), across()

# Function arguments - embrace with {{}}
my_summary <- function(data, group_var, summary_var) {
  data |>
    group_by({{ group_var }}) |>
    summarise(mean_val = mean({{ summary_var }}))
}

# Character vectors - use .data[[]]
for (var in names(mtcars)) {
  mtcars |> count(.data[[var]]) |> print()
}

# Multiple columns - use across()
data |>
  summarise(across({{ summary_vars }}, ~ mean(.x, na.rm = TRUE)))
```

### Modern Grouping and Column Operations
- **Use `.by` for per-operation grouping (dplyr 1.1+)**
- **Use `pick()` for column selection inside data-masking functions**
- **Use `across()` for applying functions to multiple columns**
- **Use `reframe()` for multi-row summaries**

```r
# Good - Per-operation grouping (always returns ungrouped)
data |>
  summarise(mean_value = mean(value), .by = category)

# Good - Multiple grouping variables
data |>
  summarise(total = sum(revenue), .by = c(company, year))

# Good - pick() for column selection
data |>
  summarise(
    n_x_cols = ncol(pick(starts_with("x"))),
    n_y_cols = ncol(pick(starts_with("y")))
  )

# Good - across() for applying functions
data |>
  summarise(across(where(is.numeric), mean, .names = "mean_{.col}"), .by = group)

# Good - reframe() for multi-row results
data |>
  reframe(quantiles = quantile(x, c(0.25, 0.5, 0.75)), .by = group)

# Avoid - Old persistent grouping pattern
data |>
  group_by(category) |>
  summarise(mean_value = mean(value)) |>
  ungroup()
```

## Modern rlang Patterns for Data-Masking

### Core Concepts

**Data-masking** allows R expressions to refer to data frame columns as if they were variables in the environment. rlang provides the metaprogramming framework that powers tidyverse data-masking.

#### Key rlang Tools
- **Embracing `{{}}`** - Forward function arguments to data-masking functions
- **Injection `!!`** - Inject single expressions or values
- **Splicing `!!!`** - Inject multiple arguments from a list
- **Dynamic dots** - Programmable `...` with injection support
- **Pronouns `.data`/`.env`** - Explicit disambiguation between data and environment variables

### Function Argument Patterns

#### Forwarding with `{{}}`
**Use `{{}}` to forward function arguments to data-masking functions:**

```r
# Single argument forwarding
my_summarise <- function(data, var) {
  data |> dplyr::summarise(mean = mean({{ var }}))
}

# Works with any data-masking expression
mtcars |> my_summarise(cyl)
mtcars |> my_summarise(cyl * am)
mtcars |> my_summarise(.data$cyl)  # pronoun syntax supported
```

#### Forwarding `...` (No Special Syntax Needed)
```r
# Simple dots forwarding
my_group_by <- function(.data, ...) {
  .data |> dplyr::group_by(...)
}

# Works with tidy selections too
my_select <- function(.data, ...) {
  .data |> dplyr::select(...)
}

# For single-argument tidy selections, wrap in c()
my_pivot_longer <- function(.data, ...) {
  .data |> tidyr::pivot_longer(c(...))
}
```

#### Names Patterns with `.data`
**Use `.data` pronoun for programmatic column access:**

```r
# Single column by name
my_mean <- function(data, var) {
  data |> dplyr::summarise(mean = mean(.data[[var]]))
}

# Usage - completely insulated from data-masking
mtcars |> my_mean("cyl")  # No ambiguity, works like regular function

# Multiple columns with all_of()
my_select_vars <- function(data, vars) {
  data |> dplyr::select(all_of(vars))
}

mtcars |> my_select_vars(c("cyl", "am"))
```

### Injection Operators

#### When to Use Each Operator

| Operator | Use Case | Example |
|----------|----------|---------|
| `{{ }}` | Forward function arguments | `summarise(mean = mean({{ var }}))` |
| `!!` | Inject single expression/value | `summarise(mean = mean(!!sym(var)))` |
| `!!!` | Inject multiple arguments | `group_by(!!!syms(vars))` |
| `.data[[]]` | Access columns by name | `mean(.data[[var]])` |

#### Advanced Injection with `!!`
```r
# Create symbols from strings
var <- "cyl"
mtcars |> dplyr::summarise(mean = mean(!!sym(var)))

# Inject values to avoid name collisions
df <- data.frame(x = 1:3)
x <- 100
df |> dplyr::mutate(scaled = x / !!x)  # Uses both data and env x

# Use data_sym() for tidyeval contexts (more robust)
mtcars |> dplyr::summarise(mean = mean(!!data_sym(var)))
```

#### Splicing with `!!!`
```r
# Multiple symbols from character vector
vars <- c("cyl", "am")
mtcars |> dplyr::group_by(!!!syms(vars))

# Or use data_syms() for tidy contexts
mtcars |> dplyr::group_by(!!!data_syms(vars))

# Splice lists of arguments
args <- list(na.rm = TRUE, trim = 0.1)
mtcars |> dplyr::summarise(mean = mean(cyl, !!!args))
```

### Dynamic Dots Patterns

#### Using `list2()` for Dynamic Dots Support
```r
my_function <- function(...) {
  # Collect with list2() instead of list() for dynamic features
  dots <- list2(...)
  # Process dots...
}

# Enables these features:
my_function(a = 1, b = 2)           # Normal usage
my_function(!!!list(a = 1, b = 2))  # Splice a list
my_function("{name}" := value)      # Name injection
my_function(a = 1, )               # Trailing commas OK
```

#### Name Injection with Glue Syntax
```r
# Basic name injection
name <- "result"
list2("{name}" := 1)  # Creates list(result = 1)

# In function arguments with {{
my_mean <- function(data, var) {
  data |> dplyr::summarise("mean_{{ var }}" := mean({{ var }}))
}

mtcars |> my_mean(cyl)        # Creates column "mean_cyl"
mtcars |> my_mean(cyl * am)   # Creates column "mean_cyl * am"

# Allow custom names with englue()
my_mean <- function(data, var, name = englue("mean_{{ var }}")) {
  data |> dplyr::summarise("{name}" := mean({{ var }}))
}

# User can override default
mtcars |> my_mean(cyl, name = "cylinder_mean")
```

### Pronouns for Disambiguation

#### `.data` and `.env` Best Practices
```r
# Explicit disambiguation prevents masking issues
cyl <- 1000  # Environment variable

mtcars |> dplyr::summarise(
  data_cyl = mean(.data$cyl),    # Data frame column
  env_cyl = mean(.env$cyl),      # Environment variable
  ambiguous = mean(cyl)          # Could be either (usually data wins)
)

# Use in loops and programmatic contexts
vars <- c("cyl", "am")
for (var in vars) {
  result <- mtcars |> dplyr::summarise(mean = mean(.data[[var]]))
  print(result)
}
```

### Programming Patterns

#### Bridge Patterns
**Converting between data-masking and tidy selection behaviors:**

```r
# across() as selection-to-data-mask bridge
my_group_by <- function(data, vars) {
  data |> dplyr::group_by(across({{ vars }}))
}

# Works with tidy selection
mtcars |> my_group_by(starts_with("c"))

# across(all_of()) as names-to-data-mask bridge
my_group_by <- function(data, vars) {
  data |> dplyr::group_by(across(all_of(vars)))
}

mtcars |> my_group_by(c("cyl", "am"))
```

#### Transformation Patterns
```r
# Transform single arguments by wrapping
my_mean <- function(data, var) {
  data |> dplyr::summarise(mean = mean({{ var }}, na.rm = TRUE))
}

# Transform dots with across()
my_means <- function(data, ...) {
  data |> dplyr::summarise(across(c(...), ~ mean(.x, na.rm = TRUE)))
}

# Manual transformation (advanced)
my_means_manual <- function(.data, ...) {
  vars <- enquos(..., .named = TRUE)
  vars <- purrr::map(vars, ~ expr(mean(!!.x, na.rm = TRUE)))
  .data |> dplyr::summarise(!!!vars)
}
```

### Error-Prone Patterns to Avoid

#### Don't Use These Deprecated/Dangerous Patterns
```r
# Avoid - String parsing and eval (security risk)
var <- "cyl"
code <- paste("mean(", var, ")")
eval(parse(text = code))  # Dangerous!

# Good - Symbol creation and injection
!!sym(var)  # Safe symbol injection

# Avoid - get() in data mask (name collisions)
with(mtcars, mean(get(var)))  # Collision-prone

# Good - Explicit injection or .data
with(mtcars, mean(!!sym(var)))  # Safe
# or
mtcars |> summarise(mean(.data[[var]]))  # Even safer
```

#### Common Mistakes
```r
# Don't use {{ }} on non-arguments
my_func <- function(x) {
  x <- force(x)  # x is now a value, not an argument
  quo(mean({{ x }}))  # Wrong! Captures value, not expression
}

# Don't mix injection styles unnecessarily
# Pick one approach and stick with it:
# Either: embrace pattern
my_func <- function(data, var) data |> summarise(mean = mean({{ var }}))
# Or: defuse-and-inject pattern
my_func <- function(data, var) {
  var <- enquo(var)
  data |> summarise(mean = mean(!!var))
}
```

### Package Development with rlang

#### Import Strategy
```r
# In DESCRIPTION:
Imports: rlang

# In NAMESPACE, import specific functions:
importFrom(rlang, enquo, enquos, expr, !!!, :=)

# Or import key functions:
#' @importFrom rlang := enquo enquos
```

#### Documentation Tags
```r
#' @param var <[`data-masked`][dplyr::dplyr_data_masking]> Column to summarize
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Additional grouping variables
#' @param cols <[`tidy-select`][dplyr::dplyr_tidy_select]> Columns to select
```

#### Testing rlang Functions
```r
# Test data-masking behavior
test_that("function supports data masking", {
  result <- my_function(mtcars, cyl)
  expect_equal(names(result), "mean_cyl")

  # Test with expressions
  result2 <- my_function(mtcars, cyl * 2)
  expect_true("mean_cyl * 2" %in% names(result2))
})

# Test injection behavior
test_that("function supports injection", {
  var <- "cyl"
  result <- my_function(mtcars, !!sym(var))
  expect_true(nrow(result) > 0)
})
```

This modern rlang approach enables clean, safe metaprogramming while maintaining the intuitive data-masking experience users expect from tidyverse functions.

## Performance Best Practices

### When to Use Each Performance Tool

#### Profiling Tools Decision Matrix

| Tool | Use When | Don't Use When | What It Shows |
|------|----------|----------------|---------------|
| **`profvis`** | Complex code, unknown bottlenecks | Simple functions, known issues | Time per line, call stack |
| **`bench::mark()`** | Comparing alternatives | Single approach | Relative performance, memory |
| **`system.time()`** | Quick checks | Detailed analysis | Total runtime only |
| **`Rprof()`** | Base R only environments | When profvis available | Raw profiling data |

#### Step-by-Step Performance Workflow

```r
# 1. Profile first - find the actual bottlenecks
library(profvis)
profvis({
  # Your slow code here
})

# 2. Focus on the slowest parts (80/20 rule)
# Don't optimize until you know where time is spent

# 3. Benchmark alternatives for hot spots
library(bench)
bench::mark(
  current = current_approach(data),
  vectorized = vectorized_approach(data),
  parallel = map(data, in_parallel(func))
)

# 4. Consider tool trade-offs based on bottleneck type
```

#### When Each Tool Helps vs Hurts

**Parallel Processing (`in_parallel()`):**
```r
# Helps when:
✓ CPU-intensive computations
✓ Embarassingly parallel problems
✓ Large datasets with independent operations
✓ I/O bound operations (file reading, API calls)

# Hurts when:
✗ Simple, fast operations (overhead > benefit)
✗ Memory-intensive operations (may cause thrashing)
✗ Operations requiring shared state
✗ Small datasets

# Example decision point:
expensive_func <- function(x) Sys.sleep(0.1) # 100ms per call
fast_func <- function(x) x^2                 # microseconds per call

# Good for parallel
map(1:100, in_parallel(expensive_func))  # ~10s -> ~2.5s on 4 cores

# Bad for parallel (overhead > benefit)
map(1:100, in_parallel(fast_func))       # 100μs -> 50ms (500x slower!)
```

**vctrs Backend Tools:**
```r
# Use vctrs when:
✓ Type safety matters more than raw speed
✓ Building reusable package functions
✓ Complex coercion/combination logic
✓ Consistent behavior across edge cases

# Avoid vctrs when:
✗ One-off scripts where speed matters most
✗ Simple operations where base R is sufficient
✗ Memory is extremely constrained

# Decision point:
simple_combine <- function(x, y) c(x, y)           # Fast, simple
robust_combine <- function(x, y) vec_c(x, y)      # Safer, slight overhead

# Use simple for hot loops, robust for package APIs
```

**Data Backend Selection:**
```r
# Use data.table when:
✓ Very large datasets (>1GB)
✓ Complex grouping operations
✓ Reference semantics desired
✓ Maximum performance critical

# Use dplyr when:
✓ Readability and maintainability priority
✓ Complex joins and window functions
✓ Team familiarity with tidyverse
✓ Moderate sized data (<100MB)

# Use base R when:
✓ No dependencies allowed
✓ Simple operations
✓ Teaching/learning contexts
```

### Profiling Best Practices

```r
# 1. Profile realistic data sizes
profvis({
  # Use actual data size, not toy examples
  real_data |> your_analysis()
})

# 2. Profile multiple runs for stability
bench::mark(
  your_function(data),
  min_iterations = 10,  # Multiple runs
  max_iterations = 100
)

# 3. Check memory usage too
bench::mark(
  approach1 = method1(data),
  approach2 = method2(data),
  check = FALSE,  # If outputs differ slightly
  filter_gc = FALSE  # Include GC time
)

# 4. Profile with realistic usage patterns
# Not just isolated function calls
```

### Performance Anti-Patterns to Avoid

```r
# Don't optimize without measuring
# ✗ "This looks slow" -> immediately rewrite
# ✓ Profile first, optimize bottlenecks

# Don't over-engineer for performance
# ✗ Complex optimizations for 1% gains
# ✓ Focus on algorithmic improvements

# Don't assume - measure
# ✗ "for loops are always slow in R"
# ✓ Benchmark your specific use case

# Don't ignore readability costs
# ✗ Unreadable code for minor speedups
# ✓ Readable code with targeted optimizations
```

### Backend Tools for Performance
- **Consider lower-level tools when speed is critical**
- **Use vctrs, rlang backends when appropriate**
- **Profile to identify true bottlenecks**

```r
# For packages - consider backend tools
# vctrs for type-stable vector operations
# rlang for metaprogramming
# data.table for large data operations
```

## When to Use vctrs

### Core Benefits
- **Type stability** - Predictable output types regardless of input values
- **Size stability** - Predictable output sizes from input sizes
- **Consistent coercion rules** - Single set of rules applied everywhere
- **Robust class design** - Proper S3 vector infrastructure

### Use vctrs when:

#### Building Custom Vector Classes
```r
# Good - vctrs-based vector class
new_percent <- function(x = double()) {
  vec_assert(x, double())
  new_vctr(x, class = "pkg_percent")
}

# Automatic data frame compatibility, subsetting, etc.
```

#### Type-Stable Functions in Packages
```r
# Good - Guaranteed output type
my_function <- function(x, y) {
  # Always returns double, regardless of input values
  vec_cast(result, double())
}

# Avoid - Type depends on data
sapply(x, function(i) if(condition) 1L else 1.0)
```

#### Consistent Coercion/Casting
```r
# Good - Explicit casting with clear rules
vec_cast(x, double())  # Clear intent, predictable behavior

# Good - Common type finding
vec_ptype_common(x, y, z)  # Finds richest compatible type

# Avoid - Base R inconsistencies
c(factor("a"), "b")  # Unpredictable behavior
```

#### Size/Length Stability
```r
# Good - Predictable sizing
vec_c(x, y)  # size = vec_size(x) + vec_size(y)
vec_rbind(df1, df2)  # size = sum of input sizes

# Avoid - Unpredictable sizing
c(env_object, function_object)  # Unpredictable length
```

### vctrs vs Base R Decision Matrix

| Use Case | Base R | vctrs | When to Choose vctrs |
|----------|--------|-------|---------------------|
| Simple combining | `c()` | `vec_c()` | Need type stability, consistent rules |
| Custom classes | S3 manually | `new_vctr()` | Want data frame compatibility, subsetting |
| Type conversion | `as.*()` | `vec_cast()` | Need explicit, safe casting |
| Finding common type | Not available | `vec_ptype_common()` | Combining heterogeneous inputs |
| Size operations | `length()` | `vec_size()` | Working with non-vector objects |

### Implementation Patterns

#### Basic Vector Class
```r
# Constructor (low-level)
new_percent <- function(x = double()) {
  vec_assert(x, double())
  new_vctr(x, class = "pkg_percent")
}

# Helper (user-facing)
percent <- function(x = double()) {
  x <- vec_cast(x, double())
  new_percent(x)
}

# Format method
format.pkg_percent <- function(x, ...) {
  paste0(vec_data(x) * 100, "%")
}
```

#### Coercion Methods
```r
# Self-coercion
vec_ptype2.pkg_percent.pkg_percent <- function(x, y, ...) {
  new_percent()
}

# With double
vec_ptype2.pkg_percent.double <- function(x, y, ...) double()
vec_ptype2.double.pkg_percent <- function(x, y, ...) double()

# Casting
vec_cast.pkg_percent.double <- function(x, to, ...) {
  new_percent(x)
}
vec_cast.double.pkg_percent <- function(x, to, ...) {
  vec_data(x)
}
```

### Performance Considerations

#### When vctrs Adds Overhead
- **Simple operations** - `vec_c(1, 2)` vs `c(1, 2)` for basic atomic vectors
- **One-off scripts** - Type safety less critical than speed
- **Small vectors** - Overhead may outweigh benefits

#### When vctrs Improves Performance
- **Package functions** - Type stability prevents expensive re-computation
- **Complex classes** - Consistent behavior reduces debugging
- **Data frame operations** - Robust column type handling
- **Repeated operations** - Predictable types enable optimization

### Package Development Guidelines

#### Exports and Dependencies
```r
# DESCRIPTION - Import specific functions
Imports: vctrs

# NAMESPACE - Import what you need
importFrom(vctrs, vec_assert, new_vctr, vec_cast, vec_ptype_common)

# Or if using extensively
import(vctrs)
```

#### Testing vctrs Classes
```r
# Test type stability
test_that("my_function is type stable", {
  expect_equal(vec_ptype(my_function(1:3)), vec_ptype(double()))
  expect_equal(vec_ptype(my_function(integer())), vec_ptype(double()))
})

# Test coercion
test_that("coercion works", {
  expect_equal(vec_ptype_common(new_percent(), 1.0), double())
  expect_error(vec_ptype_common(new_percent(), "a"))
})
```

### Don't Use vctrs When:
- **Simple one-off analyses** - Base R is sufficient
- **No custom classes needed** - Standard types work fine
- **Performance critical + simple operations** - Base R may be faster
- **External API constraints** - Must return base R types

The key insight: **vctrs is most valuable in package development where type safety, consistency, and extensibility matter more than raw speed for simple operations.**

### Modern purrr Patterns
- **Use `map() |> list_rbind()`** instead of superseded `map_dfr()`
- **Use `walk()` for side effects** (file writing, plotting)
- **Use `in_parallel()` for scaling** across cores

```r
# Modern data frame row binding (purrr 1.0+)
models <- data_splits |>
  map(\(split) train_model(split)) |>
  list_rbind()  # Replaces map_dfr()

# Column binding
summaries <- data_list |>
  map(\(df) get_summary_stats(df)) |>
  list_cbind()  # Replaces map_dfc()

# Side effects with walk()
plots <- walk2(data_list, plot_names, \(df, name) {
  p <- ggplot(df, aes(x, y)) + geom_point()
  ggsave(name, p)
})

# Parallel processing (purrr 1.1.0+)
library(mirai)
daemons(4)
results <- large_datasets |>
  map(in_parallel(expensive_computation))
daemons(0)
```

### String Manipulation with stringr
- **Use stringr over base R string functions**
- **Consistent `str_` prefix and string-first argument order**
- **Pipe-friendly and vectorized by design**

```r
# Good - stringr (consistent, pipe-friendly)
text |>
  str_to_lower() |>
  str_trim() |>
  str_replace_all("pattern", "replacement") |>
  str_extract("\\d+")

# Common patterns
str_detect(text, "pattern")     # vs grepl("pattern", text)
str_extract(text, "pattern")    # vs complex regmatches()
str_replace_all(text, "a", "b") # vs gsub("a", "b", text)
str_split(text, ",")            # vs strsplit(text, ",")
str_length(text)                # vs nchar(text)
str_sub(text, 1, 5)             # vs substr(text, 1, 5)

# String combination and formatting
str_c("a", "b", "c")            # vs paste0()
str_glue("Hello {name}!")       # templating
str_pad(text, 10, "left")       # padding
str_wrap(text, width = 80)      # text wrapping

# Case conversion
str_to_lower(text)              # vs tolower()
str_to_upper(text)              # vs toupper()
str_to_title(text)              # vs tools::toTitleCase()

# Pattern helpers for clarity
str_detect(text, fixed("$"))    # literal match
str_detect(text, regex("\\d+")) # explicit regex
str_detect(text, coll("é", locale = "fr")) # collation

# Avoid - inconsistent base R functions
grepl("pattern", text)          # argument order varies
regmatches(text, regexpr(...))  # complex extraction
gsub("a", "b", text)           # different arg order
```

### Vectorization and Performance
```r
# Good - vectorized operations
result <- x + y

# Good - Type-stable purrr functions
map_dbl(data, mean)    # always returns double
map_chr(data, class)   # always returns character

# Avoid - Type-unstable base functions
sapply(data, mean)     # might return list or vector

# Avoid - explicit loops for simple operations
result <- numeric(length(x))
for(i in seq_along(x)) {
  result[i] <- x[i] + y[i]
}
```

## Function Writing Best Practices

### Structure and Style
```r
# Good function structure
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

# Use type-stable outputs
map_dbl()   # returns numeric vector
map_chr()   # returns character vector
map_lgl()   # returns logical vector
```

### Naming and Arguments
```r
# Good naming: snake_case for variables/functions
calculate_mean_score <- function(data, score_col) {
  # Function body
}

# Prefix non-standard arguments with .
my_function <- function(.data, ...) {
  # Reduces argument conflicts
}
```

## Style Guide Essentials

### Object Names
- **Use snake_case for all names**
- **Variable names = nouns, function names = verbs**
- **Avoid dots except for S3 methods**

```r
# Good
day_one
calculate_mean
user_data

# Avoid
DayOne
calculate.mean
userData
```

### Spacing and Layout
```r
# Good spacing
x[, 1]
mean(x, na.rm = TRUE)
if (condition) {
  action()
}

# Pipe formatting
data |>
  filter(year >= 2020) |>
  group_by(category) |>
  summarise(
    mean_value = mean(value),
    count = n()
  )
```

## Common Anti-Patterns to Avoid

### Legacy Patterns
```r
# Avoid - Old pipe
data %>% function()

# Avoid - Old join syntax
inner_join(x, y, by = c("a" = "b"))

# Avoid - Implicit type conversion
sapply()  # Use map_*() instead

# Avoid - String manipulation in data masking
mutate(data, !!paste0("new_", var) := value)
# Use across() or other approaches instead
```

### Performance Anti-Patterns
```r
# Avoid - Growing objects in loops
result <- c()
for(i in 1:n) {
  result <- c(result, compute(i))  # Slow!
}

# Good - Pre-allocate
result <- vector("list", n)
for(i in 1:n) {
  result[[i]] <- compute(i)
}

# Better - Use purrr
result <- map(1:n, compute)
```

## Object-Oriented Programming

### S7: Modern OOP for New Projects
- **S7 combines S3 simplicity with S4 structure**
- **Formal class definitions with automatic validation**
- **Compatible with existing S3 code**

```r
# S7 class definition
Range <- new_class("Range",
  properties = list(
    start = class_double,
    end = class_double
  ),
  validator = function(self) {
    if (self@end < self@start) {
      "@end must be >= @start"
    }
  }
)

# Usage - constructor and property access
x <- Range(start = 1, end = 10)
x@start  # 1
x@end <- 20  # automatic validation

# Methods
inside <- new_generic("inside", "x")
method(inside, Range) <- function(x, y) {
  y >= x@start & y <= x@end
}
```

## OOP System Decision Matrix

### S7 vs vctrs vs S3/S4 Decision Tree

**Start here:** What are you building?

#### 1. Vector-like objects (things that behave like atomic vectors)
```
Use vctrs when:
✓ Need data frame integration (columns/rows)
✓ Want type-stable vector operations
✓ Building factor-like, date-like, or numeric-like classes
✓ Need consistent coercion/casting behavior
✓ Working with existing tidyverse infrastructure

Examples: custom date classes, units, categorical data
```

#### 2. General objects (complex data structures, not vector-like)
```
Use S7 when:
✓ NEW projects that need formal classes
✓ Want property validation and safe property access (@)
✓ Need multiple dispatch (beyond S3's double dispatch)
✓ Converting from S3 and want better structure
✓ Building class hierarchies with inheritance
✓ Want better error messages and discoverability

Use S3 when:
✓ Simple classes with minimal structure needs
✓ Maximum compatibility and minimal dependencies
✓ Quick prototyping or internal classes
✓ Contributing to existing S3-based ecosystems
✓ Performance is absolutely critical (minimal overhead)

Use S4 when:
✓ Working in Bioconductor ecosystem
✓ Need complex multiple inheritance (S7 doesn't support this)
✓ Existing S4 codebase that works well
```

### Detailed S7 vs S3 Comparison

| Feature | S3 | S7 | When S7 wins |
|---------|----|----|---------------|
| **Class definition** | Informal (convention) | Formal (`new_class()`) | Need guaranteed structure |
| **Property access** | `$` or `attr()` (unsafe) | `@` (safe, validated) | Property validation matters |
| **Validation** | Manual, inconsistent | Built-in validators | Data integrity important |
| **Method discovery** | Hard to find methods | Clear method printing | Developer experience matters |
| **Multiple dispatch** | Limited (base generics) | Full multiple dispatch | Complex method dispatch needed |
| **Inheritance** | Informal, `NextMethod()` | Explicit `super()` | Predictable inheritance needed |
| **Migration cost** | - | Low (1-2 hours) | Want better structure |
| **Performance** | Fastest | ~Same as S3 | Performance difference negligible |
| **Compatibility** | Full S3 | Full S3 + S7 | Need both old and new patterns |

### Practical Guidelines

#### Choose S7 when you have:
```r
# Complex validation needs
Range <- new_class("Range",
  properties = list(start = class_double, end = class_double),
  validator = function(self) {
    if (self@end < self@start) "@end must be >= @start"
  }
)

# Multiple dispatch needs
method(generic, list(ClassA, ClassB)) <- function(x, y) ...

# Class hierarchies with clear inheritance
Child <- new_class("Child", parent = Parent)
```

#### Choose vctrs when you need:
```r
# Vector-like behavior in data frames
percent <- new_vctr(0.5, class = "percentage")
data.frame(x = 1:3, pct = percent(c(0.1, 0.2, 0.3)))  # works seamlessly

# Type-stable operations
vec_c(percent(0.1), percent(0.2))  # predictable behavior
vec_cast(0.5, percent())          # explicit, safe casting
```

#### Choose S3 when you have:
```r
# Simple classes without complex needs
new_simple <- function(x) structure(x, class = "simple")
print.simple <- function(x, ...) cat("Simple:", x)

# Maximum performance needs (rare)
# Existing S3 ecosystem contributions
```

### Migration Strategy
1. **S3 → S7**: Usually 1-2 hours work, keeps full compatibility
2. **S4 → S7**: More complex, evaluate if S4 features are actually needed
3. **Base R → vctrs**: For vector-like classes, significant benefits
4. **Combining approaches**: S7 classes can use vctrs principles internally

## Package Development Decision Guide

### Dependency Strategy

#### When to Add Dependencies vs Base R
```r
# Add dependency when:
✓ Significant functionality gain
✓ Maintenance burden reduction
✓ User experience improvement
✓ Complex implementation (regex, dates, web)

# Use base R when:
✓ Simple utility functions
✓ Package will be widely used (minimize deps)
✓ Dependency is large for small benefit
✓ Base R solution is straightforward

# Example decisions:
str_detect(x, "pattern")    # Worth stringr dependency
length(x) > 0              # Don't need purrr for this
parse_dates(x)             # Worth lubridate dependency
x + 1                      # Don't need dplyr for this
```

#### Tidyverse Dependency Guidelines
```r
# Core tidyverse (usually worth it):
dplyr     # Complex data manipulation
purrr     # Functional programming, parallel
stringr   # String manipulation
tidyr     # Data reshaping

# Specialized tidyverse (evaluate carefully):
lubridate # If heavy date manipulation
forcats   # If many categorical operations
readr     # If specific file reading needs
ggplot2   # If package creates visualizations

# Heavy dependencies (use sparingly):
tidyverse # Meta-package, very heavy
shiny     # Only for interactive apps
```

### API Design Patterns

#### Function Design Strategy
```r
# Modern tidyverse API patterns

# 1. Use .by for per-operation grouping
my_summarise <- function(.data, ..., .by = NULL) {
  # Support modern grouped operations
}

# 2. Use {{ }} for user-provided columns
my_select <- function(.data, cols) {
  .data |> select({{ cols }})
}

# 3. Use ... for flexible arguments
my_mutate <- function(.data, ..., .by = NULL) {
  .data |> mutate(..., .by = {{ .by }})
}

# 4. Return consistent types (tibbles, not data.frames)
my_function <- function(.data) {
  result |> tibble::as_tibble()
}
```

#### Input Validation Strategy
```r
# Validation level by function type:

# User-facing functions - comprehensive validation
user_function <- function(x, threshold = 0.5) {
  # Check all inputs thoroughly
  if (!is.numeric(x)) stop("x must be numeric")
  if (!is.numeric(threshold) || length(threshold) != 1) {
    stop("threshold must be a single number")
  }
  # ... function body
}

# Internal functions - minimal validation
.internal_function <- function(x, threshold) {
  # Assume inputs are valid (document assumptions)
  # Only check critical invariants
  # ... function body
}

# Package functions with vctrs - type-stable validation
safe_function <- function(x, y) {
  x <- vec_cast(x, double())
  y <- vec_cast(y, double())
  # Automatic type checking and coercion
}
```

### Error Handling Patterns

```r
# Good error messages - specific and actionable
if (length(x) == 0) {
  cli::cli_abort(
    "Input {.arg x} cannot be empty.",
    "i" = "Provide a non-empty vector."
  )
}

# Include function name in errors
validate_input <- function(x, call = caller_env()) {
  if (!is.numeric(x)) {
    cli::cli_abort("Input must be numeric", call = call)
  }
}

# Use consistent error styling
# cli package for user-friendly messages
# rlang for developer tools
```

### When to Create Internal vs Exported Functions

#### Export Function When:
```r
✓ Users will call it directly
✓ Other packages might want to extend it
✓ Part of the core package functionality
✓ Stable API that won't change often

# Example: main data processing functions
export_these <- function(.data, ...) {
  # Comprehensive input validation
  # Full documentation required
  # Stable API contract
}
```

#### Keep Function Internal When:
```r
✓ Implementation detail that may change
✓ Only used within package
✓ Complex implementation helpers
✓ Would clutter user-facing API

# Example: helper functions
.internal_helper <- function(x, y) {
  # Minimal documentation
  # Can change without breaking users
  # Assume inputs are pre-validated
}
```

### Testing and Documentation Strategy

#### Testing Levels
```r
# Unit tests - individual functions
test_that("function handles edge cases", {
  expect_equal(my_func(c()), expected_empty_result)
  expect_error(my_func(NULL), class = "my_error_class")
})

# Integration tests - workflow combinations
test_that("pipeline works end-to-end", {
  result <- data |>
    step1() |>
    step2() |>
    step3()
  expect_s3_class(result, "expected_class")
})

# Property-based tests for package functions
test_that("function properties hold", {
  # Test invariants across many inputs
})
```

#### Documentation Priorities
```r
# Must document:
✓ All exported functions
✓ Complex algorithms or formulas
✓ Non-obvious parameter interactions
✓ Examples of typical usage

# Can skip documentation:
✗ Simple internal helpers
✗ Obvious parameter meanings
✗ Functions that just call other functions
```

## Migration Notes

### From Base R to Modern Tidyverse
```r
# Data manipulation
subset(data, condition)          -> filter(data, condition)
data[order(data$x), ]           -> arrange(data, x)
aggregate(x ~ y, data, mean)    -> summarise(data, mean(x), .by = y)

# Functional programming
sapply(x, f)                    -> map(x, f)  # type-stable
lapply(x, f)                    -> map(x, f)

# String manipulation
grepl("pattern", text)          -> str_detect(text, "pattern")
gsub("old", "new", text)        -> str_replace_all(text, "old", "new")
substr(text, 1, 5)              -> str_sub(text, 1, 5)
nchar(text)                     -> str_length(text)
strsplit(text, ",")             -> str_split(text, ",")
paste0(a, b)                    -> str_c(a, b)
tolower(text)                   -> str_to_lower(text)
```

### From Old to New Tidyverse Patterns
```r
# Pipes
data %>% function()             -> data |> function()

# Grouping (dplyr 1.1+)
group_by(data, x) |>
  summarise(mean(y)) |>
  ungroup()                     -> summarise(data, mean(y), .by = x)

# Column selection
across(starts_with("x"))        -> pick(starts_with("x"))  # for selection only

# Joins
by = c("a" = "b")              -> by = join_by(a == b)

# Multi-row summaries
summarise(data, x, .groups = "drop") -> reframe(data, x)

# Data reshaping
gather()/spread()               -> pivot_longer()/pivot_wider()

# String separation (tidyr 1.3+)
separate(col, into = c("a", "b")) -> separate_wider_delim(col, delim = "_", names = c("a", "b"))
extract(col, into = "x", regex)   -> separate_wider_regex(col, patterns = c(x = regex))
```

### Performance Migrations
```r
# Old -> New performance patterns
for loops for parallelizable work -> map(data, in_parallel(f))
Manual type checking             -> vec_assert() / vec_cast()
Inconsistent coercion           -> vec_ptype_common() / vec_c()

# Superseded purrr functions (purrr 1.0+)
map_dfr(x, f)                   -> map(x, f) |> list_rbind()
map_dfc(x, f)                   -> map(x, f) |> list_cbind()
map2_dfr(x, y, f)               -> map2(x, y, f) |> list_rbind()
pmap_dfr(list, f)               -> pmap(list, f) |> list_rbind()
imap_dfr(x, f)                  -> imap(x, f) |> list_rbind()

# For side effects
walk(x, write_file)             # instead of for loops
walk2(data, paths, write_csv)   # multiple arguments
```

This document should be referenced for all R development to ensure modern, performant, and maintainable code.


## Limitations and Assumptions

**When to search for additional context:**
- Indicator definitions are unclear
- Methodology questions arise
- External data sources are referenced
- Client-specific requirements are mentioned

**Key assumptions:**
- Data packages follow Fraym's standard structure
- Weights are properly calibrated (use as provided)
- Geographic identifiers are consistent with standard naming
- Indicators are measured consistently across geographies

**When to ask for clarification:**
- Multiple possible interpretations of an indicator
- Unclear geographic level for analysis
- Ambiguous time period handling
- Conflicting instructions in data documentation

## Tips for Effective Collaboration

1. **Start simple:** Begin with basic descriptive statistics before complex analyses
2. **Validate first:** Check data structure and quality before generating outputs
3. **Iterate:** Generate draft visualizations quickly, then refine based on feedback
4. **Document:** Keep clear notes on methods and decisions
5. **Ask questions:** Request clarification when analysis requirements are ambiguous

