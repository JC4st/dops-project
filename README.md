
# DOPS Project: Clinical Skills Observation and Analysis

This repository contains two complementary components designed to support the implementation and analysis of Direct Observation of Procedural Skills (DOPS) in a postgraduate clinical education setting.

---

## 1. `DOPS/` – Data Collection App

A Shiny app used to collect DOPS evaluations at the point of care. The app supports:

- Standardized evaluation using 11 performance criteria
- Real-time data submission to a Supabase PostgreSQL database
- Feedback confirmation and stable performance
- Automatic time and assessor tracking

**Main file:** `app.R`

---

## 2. `DOPSanalysis/` – Student-Level Analysis and Reporting

Scripts and templates to process and summarize DOPS data collected via the app. This section includes:

- `leer_dops.R`: Retrieves and loads DOPS data from Supabase
- `resumen_por_residente.R`: Summarizes DOPS frequency and scoring patterns per trainee
- `radar_item_scores.R`: Generates radar charts of average item scores
- `reporte_estudiante_radar.qmd`: Quarto report template for generating HTML reports per student

---

## Setup Requirements

- R (version ≥ 4.2)
- R packages: `shiny`, `httr`, `jsonlite`, `dplyr`, `fmsb`, `readr`, `janitor`, `ggplot2`, `gt`, `quarto`

---

## Use Case

This project is part of a master's program in Clinical Education and aims to provide a real-world model of workplace-based assessment and personalized reporting.

---

## License

MIT License. This repository is open for adaptation and reuse with appropriate credit.

---

## 👤 Author

Juan Castellanos de la Hoz  
Nephrologist & Clinical Educator
laCardio
University of Edinburgh (MSc in Clinical Education)
