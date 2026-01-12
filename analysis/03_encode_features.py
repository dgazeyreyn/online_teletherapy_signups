"""
03_encode_features.py

Purpose:
- Encode engineered features for statistical modeling
- Produce a modeling-ready matrix (X) and outcome vector (y)
- Preserve interpretability via explicit reference categories

Input:
- data/visitor_features_engineered.parquet

Output:
- data/model_matrix.parquet
- data/model_metadata.json
"""

import pandas as pd
import json
from pathlib import Path
from sklearn.preprocessing import OneHotEncoder

# ----------------------------
# Config
# ----------------------------
INPUT_PATH = Path("data/visitor_features_engineered.parquet")
OUTPUT_DIR = Path("data")
OUTPUT_DIR.mkdir(exist_ok=True)

MODEL_MATRIX_PATH = OUTPUT_DIR / "model_matrix.parquet"
METADATA_PATH = OUTPUT_DIR / "model_metadata.json"

# ----------------------------
# Feature Definitions
# ----------------------------
TARGET = "has_signup"

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

# Reference categories (baseline)
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
# Main
# ----------------------------
def main():
    print(" Loading engineered features...")
    df = pd.read_parquet(INPUT_PATH)

    # ----------------------------
    # Target Vector
    # ----------------------------
    y = df[TARGET].astype(int)

    # ----------------------------
    # Categorical Encoding
    # ----------------------------
    X_cat = df[CATEGORICAL_FEATURES].copy()

    # Ensure reference categories exist
    for col, ref in REFERENCE_CATEGORIES.items():
        if ref not in X_cat[col].astype(str).unique():
            raise ValueError(f"Reference category '{ref}' not found in column '{col}'")

    encoder = OneHotEncoder(
        drop="first",
        sparse_output=False,
        handle_unknown="ignore"
    )

    # Set category order explicitly so references are dropped correctly
    encoder.set_output(transform="pandas")

    for col in CATEGORICAL_FEATURES:
        categories = (
            [REFERENCE_CATEGORIES[col]] +
            sorted(
                set(X_cat[col].astype(str)) - {REFERENCE_CATEGORIES[col]}
            )
        )
        X_cat[col] = pd.Categorical(X_cat[col], categories=categories)

    X_encoded = encoder.fit_transform(X_cat)

    # ----------------------------
    # Final Model Matrix
    # ----------------------------
    X_encoded["has_signup"] = y.values
    X_encoded["visitor_key"] = df["visitor_key"].values

    # ----------------------------
    # Persist Outputs
    # ----------------------------
    X_encoded.to_parquet(MODEL_MATRIX_PATH, index=False)

    metadata = {
        "target": TARGET,
        "categorical_features": CATEGORICAL_FEATURES,
        "reference_categories": REFERENCE_CATEGORIES,
        "encoded_feature_names": X_encoded.columns.tolist(),
        "n_rows": len(X_encoded),
    }

    with open(METADATA_PATH, "w") as f:
        json.dump(metadata, f, indent=2)

    print(f" Encoded {len(X_encoded):,} rows")
    print(f" Saved model matrix → {MODEL_MATRIX_PATH}")
    print(f" Saved metadata → {METADATA_PATH}")

    # Diagnostics
    print("\n Model matrix shape:")
    print(X_encoded.shape)

    print("\n Sample encoded columns:")
    print(X_encoded.filter(like="first_test_domain").columns[:10])


if __name__ == "__main__":
    main()
