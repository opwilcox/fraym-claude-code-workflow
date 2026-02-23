---
name: explore
description: Use when the user asks to explore the data, discover what indicators are available, read the codebook, check the data package, or understand the contents of a Fraym data package before starting analysis.
---

# Explore a Fraym Data Package

Explore data directly using file-reading tools — no R scripts needed.

## Workflow 1: General Exploration

When the user asks to explore the data without a specific topic.

**Steps:**

1. Get `pkg_path` from the CLAUDE.md Project section (e.g., `data/Iraq 2025`). Paths are relative to the project root.

2. Use Glob with `pattern: "**/*.csv"` and `path: {pkg_path}` to discover files. Look for `codebook.csv` at the root and zonal stats CSVs (typically under `Zonal Statistics/csv/`). Pass `path` as a parameter rather than embedding it in the pattern to handle folder names with spaces.
3. Read the codebook. Extract:
   - Indicator categories and count of indicators per category
   - Data production date or time period if present
4. Read the zonal statistics CSV. Extract:
   - Admin levels available (e.g., adm0 = national, adm1 = province, adm2 = district)
   - Geographic identifier columns (e.g., `adm1_name`, `adm2_pcode`)

**Report back:**
- Indicator categories with counts (e.g., "Health: 14 indicators, Food Security: 9 indicators")
- Data time period / production date
- Admin levels available for analysis

---

## Workflow 2: Topic-Specific Exploration

When the user asks about data availability for a specific topic (e.g., "what do we have on foreign influence?").

**Steps:**

1–4. Same as Workflow 1.

5. Filter codebook to indicators matching the topic. Use `indicator_name`, `category`, and any description columns to find relevant indicators.

6. Read adm0 (national) rows from the zonal stats CSV for those indicators. Surface national-level values.

7. Read adm1 rows to identify subnational variation — flag geographic concentrations or outliers (highest/lowest regions).

**Report back:**
- Relevant indicators found (IDs, names, category)
- National-level values for key indicators
- Notable subnational patterns (e.g., "Indicator X is highest in [region] at Y%, compared to national average of Z%")

