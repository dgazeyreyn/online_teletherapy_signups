"""
02_engineer_features.py

Purpose:
- Apply feature engineering to extracted visitor-level features
- Bucket sparse categories
- Map mental health tests to clinically meaningful domains
- Persist an engineered dataset for downstream encoding & modeling

Input:
- data/visitor_features.parquet

Output:
- data/visitor_features_engineered.parquet
"""

import pandas as pd
from pathlib import Path

# ----------------------------
# Config
# ----------------------------
INPUT_PATH = Path("data/visitor_features.parquet")
OUTPUT_PATH = Path("data/visitor_features_engineered.parquet")

# ----------------------------
# Test → Domain Mapping
# ----------------------------
TEST_DOMAIN_MAP = {
    # Mood & Depression
    "Depression": "Mood & Depression",
    "Postpartum Depression": "Mood & Depression",
    "Bipolar Disorder": "Mood & Depression",
    "Mania": "Mood & Depression",
    "Complicated Grief": "Mood & Depression",

    # Anxiety & Stress
    "Anxiety": "Anxiety & Stress",
    "Social Anxiety Disorder": "Anxiety & Stress",
    "Separation Anxiety": "Anxiety & Stress",
    "Panic Disorder": "Anxiety & Stress",
    "Agoraphobia": "Anxiety & Stress",
    "Obsessive-Compulsive Disorder": "Anxiety & Stress",
    "Repetitive Thoughts and Behaviors": "Anxiety & Stress",
    "Stress": "Anxiety & Stress",

    # Trauma & Dissociation
    "PTSD": "Trauma & Dissociation",
    "Dissociative Identity Disorder": "Trauma & Dissociation",
    "Psychosis": "Trauma & Dissociation",
    "Schizophrenia": "Trauma & Dissociation",
    "Somatic Symptom Disorder": "Trauma & Dissociation",

    # Personality Disorders & Traits
    "Borderline Personality Disorder": "Personality Disorders & Traits",
    "Narcissistic Personality Disorder": "Personality Disorders & Traits",
    "Sociopath": "Personality Disorders & Traits",
    "Empathy Deficit Disorder": "Personality Disorders & Traits",

    # Neurodevelopmental & Cognitive
    "Adult ADHD": "Neurodevelopmental & Cognitive",
    "Autism": "Neurodevelopmental & Cognitive",
    "Hoarding Disorder": "Neurodevelopmental & Cognitive",

    # Addiction & Compulsive Behavior
    "Sex Addiction": "Addiction & Compulsive Behavior",
    "Video Game Addiction": "Addiction & Compulsive Behavior",
    "Gambling Addiction": "Addiction & Compulsive Behavior",
    "Internet Addiction": "Addiction & Compulsive Behavior",
    "Alcohol/Drug Addiction": "Addiction & Compulsive Behavior",
    "Binge Eating Disorder": "Addiction & Compulsive Behavior",
    "Eating Disorder": "Addiction & Compulsive Behavior",

    # Sexual & Gender Health
    "Gender Dysphoria": "Sexual & Gender Health",
    "Female Sexual Dysfunction": "Sexual & Gender Health",
    "Male Sexual Dysfunction": "Sexual & Gender Health",

    # Life, Work & Physical Health
    "Relationship Health": "Life, Work & Physical Health",
    "Toxic Workplace": "Life, Work & Physical Health",
    "Job Burnout": "Life, Work & Physical Health",
    "Long COVID": "Life, Work & Physical Health",
    "Sleep Disorder": "Life, Work & Physical Health",
    "Female Aggression": "Life, Work & Physical Health",
    "Male Aggression": "Life, Work & Physical Health",

    # No Test
    "None": "No Test"
}

# ----------------------------
# Main
# ----------------------------
def main():
    print("Loading extracted features...")
    df = pd.read_parquet(INPUT_PATH)

    # ----------------------------
    # OS Name Bucketing
    # ----------------------------
    major_os = {
        "iOS",
        "Android",
        "Windows",
        "macOS",
        "Chrome OS",
    }

    df["os_name_clean"] = df["os_name"].where(
        df["os_name"].isin(major_os),
        "Other"
    )

    # ----------------------------
    # Test Domain Mapping
    # ----------------------------
    df["first_test_domain"] = df["first_test_taken"].map(TEST_DOMAIN_MAP)
    df["first_completed_test_domain"] = df["first_completed_test_taken"].map(TEST_DOMAIN_MAP)

    # Defensive fallbacks
    df["first_test_domain"] = df["first_test_domain"].fillna("No Test")
    df["first_completed_test_domain"] = df["first_completed_test_domain"].fillna("No Completed Test")

    # ----------------------------
    # Optional: Drop raw high-cardinality fields
    # ----------------------------
    df = df.drop(
        columns=[
            "first_test_taken",
            "first_completed_test_taken"
        ]
    )

    # ----------------------------
    # Sanity Checks
    # ----------------------------
    assert df["visitor_key"].is_unique, "visitor_key is not unique!"
    assert set(df["has_signup"].dropna().unique()).issubset({True, False})

    # ----------------------------
    # Persist
    # ----------------------------
    df.to_parquet(OUTPUT_PATH, index=False)

    print(f"Engineered {len(df):,} rows")
    print(f"Saved to {OUTPUT_PATH}")

    # Helpful diagnostics
    print("\n OS distribution (cleaned):")
    print(df["os_name_clean"].value_counts())

    print("\n First test domain distribution:")
    print(df["first_test_domain"].value_counts())

    print("\n First completed test domain distribution:")
    print(df["first_completed_test_domain"].value_counts())


if __name__ == "__main__":
    main()
