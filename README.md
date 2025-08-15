# Tele-Therapy Signup Analysis

**Analyzed anonymized visitor data** from **MD (online tele-therapy affiliate)** to uncover which user attributes most influence tele-therapy signups — turning raw PostgreSQL exports into actionable marketing insights.  

**Key highlights:**  
- 🛠 **Built an end-to-end data pipeline** from extraction → transformation → analysis.  
- 🗄 **Google Cloud Platform + BigQuery + dbt Cloud** for scalable storage and SQL transformations.  
- 🧮 **Multivariate logistic regression** to quantify attribute–signup relationships.  
- 📈 **Interactive Tableau dashboard** to visualize findings.  

[View the Dashboard](https://public.tableau.com/views/MindDiagnostics-OnlineTeletherapySignups/viz_md?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link) <!-- Replace # with actual Tableau dashboard link -->

---

## Table of Contents
- [Overview](#overview)
- [Data Sources](#data-sources)
- [Key Visitor Attributes](#key-visitor-attributes)
- [Methodology](#methodology)
- [Usage](#usage)
- [Results](#results)
- [Installation](#installation)

---

## Overview
The goal:  
- Identify **which visitor attributes** — browser, operating system, and state — are statistically linked to tele-therapy signup probability.  
- Deliver insights through a reproducible data pipeline and an interactive visualization.  
- Enable MD’s marketing team to **target high-impact audiences** more effectively.  

---

## Data Sources
- **PostgreSQL** exports:  
  - `log_visitor` – browser, OS, location  
  - `log_tests` – test-taking activity  
  - `goals` – signup completion events

---

## Key Visitor Attributes
- **Browser** (e.g., Chrome, Safari, Firefox)  
- **Operating System** (e.g., Windows, MacOS, iOS, Android)  
- **State** (U.S. state from IP geolocation)

---

## Methodology

### 1. Data Pipeline
- **Extract**: Pulled PostgreSQL tables (`log_visitor`, `log_tests`, `goals`) via CSV exports.  
- **Load**: Uploaded to **Google Cloud Storage**, loaded into **BigQuery**.  
- **Transform**:  
  - Built SQL queries for cleaning and joining datasets.  
  - Refactored transformations in **dbt Cloud** with staging, intermediate, and marts layers.

### 2. Analysis
- **EDA**: Contingency tables + statistical significance testing for browser, OS, and state.  
- **Modeling**:  
  - Multivariate logistic regression in **Google Colab**.  
  - Estimated **odds ratios** with 95% confidence intervals.  
  - Visualized results with forest plots.

### 3. Visualization
- Designed **Tableau dashboard** to explore signup probability across visitor attributes.  
- Packaged workbook (`.twbx`) included in repo; also available via Tableau Public.

---

## Usage
- Open the Jupyter Notebook in `/notebooks` to run EDA and regression analysis.  
- Open the Tableau workbook in `/tableau` for interactive results.  
- Or view the **[published dashboard](https://public.tableau.com/views/MindDiagnostics-OnlineTeletherapySignups/viz_md?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)** online.

---

## Results
- Identified **specific browsers, OS types, and states** with significantly higher signup rates.  
- Pipeline allows repeatable analysis with new data exports.  
- Insights currently driving **live Google Ads campaigns** targeting high-probability audiences.

---

## Installation
```bash
# Clone the repository
git clone https://github.com/dgazeyreyn/online_teletherapy_signups.git

# Navigate into the repo
cd online_teletherapy_signups
