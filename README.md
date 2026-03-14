# Behavioral Analytics & Conversion Modeling

Scalable behavioral analytics system designed to identify drivers of user signup conversion on a mental health assessment platform.

This project demonstrates how raw behavioral event data can be transformed into a structured analytical system capable of supporting:

* Behavioral funnel analysis
* Conversion driver modeling
* Identity resolution and bot filtering
* Executive analytics and reporting
* Product optimization insights

The work evolved from exploratory analysis into a **production-style analytics architecture using dbt, BigQuery, and Python**.

---

# Project Overview

Understanding how users engage with digital mental health tools is critical for improving accessibility and ensuring individuals receive appropriate support.

This project analyzes behavioral engagement patterns on a psychological assessment platform to answer several core questions:

* What behavioral signals predict user signup conversion?
* How does engagement with psychological tests influence conversion?
* Where do users drop off in the behavioral funnel?
* Which assessments represent high-impact product optimization opportunities?

To answer these questions, the project implements a full analytics pipeline that converts raw event data into reusable analytical models and statistical insights.

---

# Architecture

The analytical system follows a **Medallion Architecture**, implemented using **dbt Cloud** and a **BigQuery warehouse**.

```
Raw Event Logs (BigQuery)
        │
        ▼
Bronze Layer (staging models)
Standardization & schema normalization
        │
        ▼
Silver Layer (intermediate models)
Identity resolution & data validation
        │
        ▼
Gold Layer (analytical models)
Dimensional models, fact tables, and behavioral marts
```

### Bronze Layer — Staging

Standardizes raw source tables and enforces consistent schemas.

Examples:

```
stg_md__visitors
stg_md__tests
stg_md__goals
```

Responsibilities:

* Timestamp normalization
* Source schema alignment
* Data cleanliness checks

---

### Silver Layer — Identity Resolution

This layer resolves visitor identity and ensures analytical validity.

Key model:

```
int_visitors_resolved
```

Responsibilities:

* Validating relationships between visitor identifiers
* Removing ambiguous identity relationships
* Filtering potential bot traffic
* Ensuring reliable behavioral attribution

---

### Gold Layer — Analytical Models

The Gold layer contains reusable analytical entities with clearly defined grain.

Dimension model:

```
dim_visitors
```

Fact tables:

```
fact_tests
fact_goals
```

Analytical mart:

```
mart_visitor_type2_us_modeling
```

This mart unifies:

* Visitor identity
* Behavioral engagement
* Psychological test domains
* Conversion outcomes

The resulting dataset supports both **statistical modeling and executive analytics**.

---

# Behavioral Feature Engineering

Raw behavioral events were transformed into interpretable modeling features.

Key features include:

```
test_engagement_state
tests_taken_count_bucket
tests_completed_count_bucket
test_latency_bucket
```

These features capture:

* Whether users engaged with assessments
* Degree of behavioral engagement
* Timing of engagement events

---

# Psychological Domain Taxonomy

The source system contained **42 individual psychological tests**, which introduced high cardinality and sparse categories.

To improve statistical interpretability, tests were mapped into structured domains:

Examples:

* Mood & Depression
* Anxiety & Stress
* Personality Disorders & Traits
* Addiction & Compulsive Behavior
* Trauma & Dissociation
* Neurodevelopmental & Cognitive
* Life, Work & Physical Health

This domain taxonomy enabled meaningful behavioral segmentation and stable modeling results.

---

# Statistical Modeling

Two primary statistical approaches were used to understand behavioral drivers of conversion.

### Chi-Square Analysis

Used to identify statistically significant relationships between behavioral engagement patterns and signup conversion.

### Logistic Regression

Logistic regression models were used to estimate **odds ratios for behavioral predictors of signup conversion**.

Example modeling tools:

* scikit-learn
* statsmodels
* scipy

---

# Technical Challenge: Multicollinearity

Initial regression models produced unstable coefficients and non-interpretable results.

Root cause:

Structural multicollinearity caused by overlapping behavioral features:

```
test_engagement_state
tests_taken_count_bucket
tests_completed_count_bucket
```

Resolution:

* Redefined reference categories
* Removed redundant predictors
* Separated engagement and domain variables

This restored statistical validity and model interpretability.

---

# Behavioral Funnel Analysis

A behavioral conversion funnel was constructed:

```
Visitor → Test Started → Test Completed → Signup
```

Key insight:

**Test completion represents the strongest inflection point in conversion probability.**

Users completing psychological tests convert at dramatically higher rates than those who abandon earlier in the journey.

---

# Abandonment Analysis

Behavioral abandonment rates were measured across:

* Psychological domains
* Individual test types

Key finding:

Certain tests exhibited both:

* High engagement volume
* High abandonment rate

These represent **high-impact product optimization opportunities**.

---

# Tools & Technologies

Data Platform

* Google BigQuery
* dbt Cloud

Data Modeling

* SQL
* Dimensional modeling
* Medallion architecture

Statistical Analysis

* Python
* pandas
* scikit-learn
* statsmodels
* scipy

Visualization

* Jupyter notebooks
* matplotlib

---

# Repository Structure

```
analytics-conversion-modeling/

dbt_project/
  models/
  staging/
  intermediate/
  marts/

notebooks/
  exploratory_analysis.ipynb
  modeling.ipynb

data/
  synthetic_or_example_datasets/

scripts/
  feature_extraction.py

README.md
```

---

# Data Privacy & Responsible Use

This project analyzes behavioral engagement patterns from a mental health assessment platform.

Because this domain involves sensitive subject matter, **no personally identifiable information (PII) is included in this repository**.

Key safeguards:

* Raw warehouse data is not distributed
* IP addresses and technical identifiers are excluded
* Only derived analytical features are used
* All modeling datasets are privacy-preserving representations

The purpose of this repository is to demonstrate **analytics engineering architecture and behavioral modeling techniques**, not to expose production user data.

---

# Key Capabilities Demonstrated

This project demonstrates several core analytics engineering competencies:

* Designing scalable analytical architectures
* Building dbt transformation pipelines
* Identity resolution and data quality validation
* Behavioral feature engineering
* Statistical modeling for conversion analysis
* Funnel and abandonment analytics
* Translating behavioral insights into product optimization opportunities

---

# Future Improvements

Potential extensions to this project include:

* Survival analysis for behavioral retention modeling
* Time-to-conversion modeling
* Bayesian behavioral segmentation
* Experimentation framework integration
* Automated data quality monitoring in dbt

---

# Author

Analytics engineering and behavioral modeling project designed as part of a professional portfolio demonstrating scalable analytics system design and conversion analysis.
