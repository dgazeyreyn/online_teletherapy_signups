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
# State → Sub-Region Mapping
# ----------------------------

STATE_SUBREGION_MAP = {
    # New England
    'Connecticut' : 'New England',
    'Maine' : 'New England',
    'Massachusetts' : 'New England',
    'New Hampshire' : 'New England',
    'Rhode Island' : 'New England',
    'Vermont' : 'New England',
    
    # Middle Atlantic
    'New Jersey' : 'Middle Atlantic',
    'New York' : 'Middle Atlantic',
    'Pennsylvania' : 'Middle Atlantic',
    
    # East North Central
    'Indiana' : 'East North Central',
    'Illinois' : 'East North Central',
    'Michigan' : 'East North Central',
    'Ohio' : 'East North Central',
    'Wisconsin' : 'East North Central',
    
    # West North Central
    'Iowa' : 'West North Central',
    'Kansas' : 'West North Central',
    'Minnesota' : 'West North Central',
    'Missouri' : 'West North Central',
    'Nebraska' : 'West North Central',
    'North Dakota' : 'West North Central',
    'South Dakota' : 'West North Central',
    
    # South Atlantic
    'Delaware' : 'South Atlantic',
    'District of Columbia' : 'South Atlantic',
    'Florida' : 'South Atlantic',
    'Georgia' : 'South Atlantic',
    'Maryland' : 'South Atlantic',
    'North Carolina' : 'South Atlantic',
    'South Carolina' : 'South Atlantic',
    'Virginia' : 'South Atlantic',
    'West Virginia' : 'South Atlantic',
    
    # East South Central
    'Alabama' : 'East South Central',
    'Kentucky' : 'East South Central',
    'Mississippi' : 'East South Central',
    'Tennessee' : 'East South Central',
    
    # West South Central
    'Arkansas' : 'West South Central',
    'Louisiana' : 'West South Central',
    'Oklahoma' : 'West South Central',
    'Texas' : 'West South Central',
    
    # Mountain
    'Arizona' : 'Mountain',
    'Colorado' : 'Mountain',
    'Idaho' : 'Mountain',
    'New Mexico' : 'Mountain',
    'Montana' : 'Mountain',
    'Utah' : 'Mountain',
    'Nevada' : 'Mountain',
    'Wyoming' : 'Mountain',
    
    # Pacific
    'Alaska' : 'Pacific',
    'California' : 'Pacific',
    'Hawaii' : 'Pacific',
    'Oregon' : 'Pacific',
    'Washington' : 'Pacific'
}

# ----------------------------
# State → Region Mapping
# ----------------------------

STATE_REGION_MAP = {
    # East
    'Connecticut' : 'East',
    'Delaware' : 'East',
    'District of Columbia' : 'East',
    'Maine' : 'East',
    'Maryland' : 'East',
    'Massachusetts' : 'East',
    'New Hampshire' : 'East',
    'New Jersey' : 'East',
    'New York' : 'East',
    'Ohio' : 'East',
    'Pennsylvania' : 'East',
    'Rhode Island' : 'East',
    'Vermont' : 'East',
    'West Virginia' : 'East',
    
    # Central
    'Indiana' : 'Central',
    'Illinois' : 'Central',
    'Iowa' : 'Central',
    'Kansas' : 'Central',
    'Minnesota' : 'Central',
    'Michigan' : 'Central',
    'Missouri' : 'Central',
    'Nebraska' : 'Central',
    'North Dakota' : 'Central',
    'Oklahoma' : 'Central',
    'South Dakota' : 'Central',
    'Texas' : 'Central',
    'Wisconsin' : 'Central',
    
    # South
    'Alabama' : 'South',
    'Arkansas' : 'South',
    'Florida' : 'South',
    'Georgia' : 'South',
    'Kentucky' : 'South',
    'Louisiana' : 'South',
    'Mississippi' : 'South',
    'North Carolina' : 'South',
    'South Carolina' : 'South',
    'Tennessee' : 'South',
    'Virginia' : 'South',
    
    # West
    'Arizona' : 'West',
    'California' : 'West',
    'Colorado' : 'West',
    'Idaho' : 'West',
    'New Mexico' : 'West',
    'Montana' : 'West',
    'Nevada' : 'West',
    'Oregon' : 'West',
    'Utah' : 'West',
    'Washington' : 'West',
    'Wyoming' : 'West',
    
    # Non-Contiguous
    'Alaska' : 'Pacific',
    'Hawaii' : 'Pacific'
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
    # State → Sub-Region Mapping
    # ----------------------------
    df["sub_region"] = df["region"].map(STATE_SUBREGION_MAP)

    # Defensive fallbacks
    df["sub_region"] = df["sub_region"].fillna("Unassigned")
    
    # ----------------------------
    # State → Region Mapping
    # ----------------------------
    df["regional"] = df["sub_region"].map(STATE_REGION_MAP)

    # Defensive fallbacks
    df["regional"] = df["regional"].fillna("Unassigned")

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
    
    print("\n State to Sub-Region distribution:")
    print(df["sub_region"].value_counts())
    
    print("\n State to Region distribution:")
    print(df["regional"].value_counts())


if __name__ == "__main__":
    main()