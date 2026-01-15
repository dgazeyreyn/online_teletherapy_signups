from pathlib import Path
import pandas as pd
from sklearn.preprocessing import OneHotEncoder

# ----------------------------
# Config
# ----------------------------
INPUT_PATH = Path("data/visitor_features_engineered.parquet")
OUTPUT_PATH = Path("data/model_matrix.parquet")

TARGET_COL = "has_signup"
ID_COL = "visitor_key"

CATEGORICAL_FEATURES = [
    "browser",
    "os_name_clean",
    "sub_region",
    "test_engagement_state",
    "tests_taken_count_bucket",
    "tests_completed_count_bucket",
    "first_test_domain",
    "first_completed_test_domain",
]

REFERENCE_CATEGORIES = {
    "browser": "mobile_web",
    "os_name_clean": "iOS",
    "sub_region": "South Atlantic",
    "test_engagement_state": "No Test",
    "tests_taken_count_bucket": "0",
    "tests_completed_count_bucket": "0",
    "first_test_domain": "No Test",
    "first_completed_test_domain": "No Completed Test",
}

# ----------------------------
# Load engineered features
# ----------------------------
df = pd.read_parquet(INPUT_PATH)

# ----------------------------
# Basic validation
# ----------------------------
assert df[ID_COL].is_unique, "visitor_key must be unique"
assert set(df[TARGET_COL].dropna().unique()).issubset({True, False})

for col, ref in REFERENCE_CATEGORIES.items():
    if ref not in df[col].astype(str).unique():
        raise ValueError(
            f"Reference category '{ref}' not found in column '{col}'"
        )

# ----------------------------
# Prepare categorical data
# ----------------------------
X_cat = df[CATEGORICAL_FEATURES].astype(str)

# Explicit category ordering (reference first)
for col in CATEGORICAL_FEATURES:
    categories = (
        [REFERENCE_CATEGORIES[col]]
        + sorted(set(X_cat[col]) - {REFERENCE_CATEGORIES[col]})
    )
    X_cat[col] = pd.Categorical(X_cat[col], categories=categories)

# ----------------------------
# One-hot encode (NO dropping)
# ----------------------------
encoder = OneHotEncoder(
    drop=None,
    sparse_output=False,
    handle_unknown="ignore"
)

encoder.set_output(transform="pandas")
X_encoded = encoder.fit_transform(X_cat)

# ----------------------------
# Drop explicit reference columns
# ----------------------------
for col, ref in REFERENCE_CATEGORIES.items():
    ref_col = f"{col}_{ref}"
    if ref_col in X_encoded.columns:
        X_encoded = X_encoded.drop(columns=ref_col)
    else:
        raise ValueError(
            f"Expected reference column '{ref_col}' not found in encoded output"
        )

# ----------------------------
# Final model matrix
# ----------------------------
model_df = pd.concat(
    [
        X_encoded,
        df[[TARGET_COL, ID_COL]]
    ],
    axis=1
)

# ----------------------------
# Final sanity checks
# ----------------------------
assert ID_COL in model_df.columns
assert TARGET_COL in model_df.columns
assert model_df.isnull().sum().sum() == 0, "Unexpected nulls in model matrix"

# ----------------------------
# Persist
# ----------------------------
model_df.to_parquet(OUTPUT_PATH, index=False)

print("✅ Feature encoding complete")
print(f"📐 Model matrix shape: {model_df.shape}")
print(f"📦 Saved to: {OUTPUT_PATH}")
