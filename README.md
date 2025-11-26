# ❄️ End-to-End Machine Learning on Snowflake

This repository demonstrates a complete, production-grade MLOps workflow entirely within Snowflake. It covers the full lifecycle from feature engineering to model monitoring, leveraging Snowpark and Snowflake ML.

## 🚀 Workflow Overview

1. **Feature Store:** Create and manage consistent feature definitions for reproducibility.

2. **Model Training:** Train XGBoost models (Baseline vs. Optimized) using distributed Hyperparameter Optimization (HPO) on Snowflake compute.

3. **Model Registry:** Version control, tag, and manage model artifacts with built-in governance.

4. **Model Monitoring:** Track performance metrics (MAE, RMSE), detect model drift, and compare models side-by-side.

5. **Lineage:** Visualize the end-to-end flow from raw data to model versions.

## ⚡️ Getting Started

### 1. Snowflake Environment Setup

**Do this first.**

1. Log in to your Snowflake account.

2. Open a new SQL Worksheet.

3. Copy the contents of `setup.sql` from this repository.

4. Run all queries in `setup.sql` to create the necessary Database, Schema, Warehouses, and Stages.

5. This will setup the database, data, and notebook. Next is to follow along the notebook and training materials.