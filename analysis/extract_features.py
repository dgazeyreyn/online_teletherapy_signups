from google.cloud import bigquery
import pandas as pd
from pathlib import Path
from sklearn.preprocessing import OneHotEncoder

# ----------------------------
# Config
# ----------------------------
PROJECT_ID = "mind-diagnostics-414622"
DATASET = "dbt_dreynolds"
TABLE = "mart_visitor_type2_us_modeling"

OUTPUT_DIR = Path("data")
OUTPUT_DIR.mkdir(exist_ok=True)

# ----------------------------
# Load data from BigQuery
# ----------------------------
def load_features():
    client = bigquery.Client(project=PROJECT_ID)

    query = f"""
    SELECT
        visitor_key,
        
        -- descriptive attributes
        browser,
        os_name,
        region,

        -- outcomes
        has_signup,

        -- test behavior
        test_engagement_state,
        tests_taken_count_bucket,
        tests_completed_count_bucket,
        test_latency_bucket,
        first_test_taken,
        first_completed_test_taken

    FROM `{PROJECT_ID}.{DATASET}.{TABLE}`
    """

    return client.query(query).to_dataframe()

# ----------------------------
# Main
# ----------------------------
if __name__ == "__main__":
    df = load_features()

    # Basic sanity checks
    assert df["visitor_key"].is_unique
    assert set(df["has_signup"].dropna().unique()).issubset({True, False})

    # Persist locally
    output_path = OUTPUT_DIR / "visitor_features.parquet"
    df.to_parquet(output_path, index=False)

    print(f"✅ Extracted {len(df):,} rows")
    print(f"📦 Saved to {output_path}")

# ----------------------------
# Encode features
# ----------------------------

# Create a new column for the bucketed categories

# Compute counts
os_counts = df['os_name'].value_counts()

# Threshold for "Other"
threshold = 100

# Bucket rare categories into 'Other'
df['os_name_bucketed'] = df['os_name'].apply(
    lambda x: x if os_counts[x] >= threshold else 'Other'
)






categorical_cols = [
    "browser",
    "os_name",
    "region",
    "test_engagement_state",
    "tests_taken_count_bucket",
    "tests_completed_count_bucket",
    "test_latency_bucket",
    "first_test_taken",
    "first_completed_test_taken",
]

X = df[categorical_cols]
y = df["has_signup"]

encoder = OneHotEncoder(
    drop="first",          # reference category
    sparse=False,
    handle_unknown="ignore"
)

X_encoded = encoder.fit_transform(X)

feature_names = encoder.get_feature_names_out(categorical_cols)
X_encoded = pd.DataFrame(X_encoded, columns=feature_names)
