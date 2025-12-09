# E-commerce Analytics Platform: Project Plan

## 1. High-Level Vision

**Project Title:** E-commerce Analytics Platform

**Purpose:** To create a scalable data analytics solution for a B2B SaaS company, aimed at helping e-commerce brands across different industries make data-driven decisions. This project demonstrates end-to-end capabilities in data pipeline development, industry-specific analysis, and delivering actionable insights through dashboards.

**Dataset:** [Brazilian E-commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

**Two Focus Areas (Deep Dives):**
1.  **Apparel Industry - "Fit-Driven Demand Optimization":** Helps apparel brands optimize inventory and reduce returns by analyzing demand trends and customer feedback on fit issues.
2.  **Electronics Industry - "Product Reliability and Warranty Analytics":** Supports electronics brands in identifying unreliable products and optimizing warranty policies by analyzing review scores and failure timelines.

---

## 2. End-to-End Architecture

This project follows a modern data engineering workflow, moving data from raw sources to actionable insights.

### Architecture Diagram (Text Representation)

```
[Raw Data: CSVs] -> [Ingestion: Python Scripts] -> [Storage & Staging: PostgreSQL Database] -> [Transformation: dbt + SQL] -> [Analysis-Ready Data Models] -> [Presentation: Power BI / Metabase Dashboards]
                                                                                                    ^
                                                                                                    |
                                                                                            [Orchestration: Apache Airflow]
```

### Data Flow Explained:

1.  **Data Acquisition:** Raw data (CSV files) is downloaded from Kaggle. In a real-world scenario, this would be data from a client's API or database.
2.  **Ingestion & Staging:** Python scripts using `pandas` and `sqlalchemy` read the raw CSVs and load them into a staging area within a PostgreSQL database. This centralizes the data and prepares it for transformation.
3.  **Transformation (The Core Engine):** This is where the heavy lifting happens. We use **dbt (Data Build Tool)** to manage a series of SQL queries that transform the raw, staged data into clean, reliable, and analysis-ready data models. This includes cleaning data, joining tables, and creating aggregated views.
4.  **Orchestration:** Apache Airflow is used to schedule and automate the entire pipeline, from ingestion to transformation, ensuring the data is always up-to-date.
5.  **Presentation:** The final, clean data models in the PostgreSQL database are connected to visualization tools (Power BI for Apparel, Metabase for Electronics). These tools query the database to populate interactive dashboards for the end-user (the client brand).

---

## 3. Tech Stack

| Component | Tool | Role & Justification |
| :--- | :--- | :--- |
| **Programming** | Python | Used for initial data ingestion, complex logic (NLP for review analysis), and orchestrator scripting. The glue of the pipeline. |
| **Database** | PostgreSQL | A powerful, open-source relational database used as our data warehouse for storing staged data and the final analytical models. |
| **Transformation** | dbt (Data Build Tool) | The core of our transformation layer. It allows us to build, test, and document our SQL transformations in a modular and maintainable way. |
| **Orchestration** | Apache Airflow | Automates and schedules our entire data pipeline, ensuring reliability and timeliness. (Note: For this project, we will describe its role, but may not fully implement it to save time). |
| **Visualization** | Power BI & Metabase | Used to build client-facing, interactive dashboards. Using two tools demonstrates versatility. |
| **Libraries** | pandas, sqlalchemy, nltk | Key Python libraries for data manipulation, database interaction, and Natural Language Processing. |

---

## 4. Detailed Execution Plan

### Phase 1: Setup and Ingestion

1.  **Environment Setup:**
    *   Initialize Git repository and virtual environment (`venv`).
    *   Install core Python packages: `pandas`, `sqlalchemy`, `psycopg2-binary`, `nltk`.
2.  **Data Acquisition:**
    *   Download the Olist dataset CSVs into a `data/` directory.
3.  **Database Setup:**
    *   Install PostgreSQL locally.
    *   Create a new database (e.g., `ecommerce_db`).
4.  **Initial Ingestion:**
    *   Write a Python script (`scripts/ingest_data.py`) to:
        *   Connect to the PostgreSQL database.
        *   Iterate through all CSV files in the `data/` directory.
        *   Load each CSV into a corresponding table in the database (e.g., `olist_products_dataset.csv` -> `products` table).

### Phase 2: Data Transformation with dbt

1.  **dbt Project Setup:**
    *   Install dbt and initialize a new dbt project (`dbt/`).
    *   Configure dbt to connect to our PostgreSQL database.
2.  **Staging Models:**
    *   Create a "staging" model for each raw table (e.g., `stg_orders`, `stg_products`).
    *   In these models, perform basic cleaning: rename columns, cast data types, and select only necessary fields.
3.  **Intermediate Models:**
    *   Create intermediate models by joining staging models. A key model will be `int_orders_joined`, which joins orders, items, products, reviews, and customers to create a single, wide view of each order line.
4.  **Final (Mart) Models:**
    *   Create final "data mart" models that are aggregated and ready for analysis.
    *   `mart_monthly_sales`: Aggregates sales data by month and product category.
    *   `mart_product_reviews`: A table focused on product reviews and associated metadata.

### Phase 3: Deep Dive 1 - Apparel Analytics

1.  **Filtering:**
    *   In dbt, create a model `mart_apparel_orders` that filters the `int_orders_joined` model for apparel-related product categories.
2.  **NLP Analysis (Python):**
    *   Write a Python script (`scripts/analyze_apparel_reviews.py`) that:
        *   Pulls review comments from the `mart_apparel_orders` table.
        *   Applies a function using `nltk` to classify each comment for fit issues (e.g., 'Too Small', 'Too Large', 'Other').
        *   Loads these results into a new table in the database, `apparel_fit_analysis`.
3.  **Final Apparel Model:**
    *   Join the `apparel_fit_analysis` back to `mart_apparel_orders` in dbt to create a final `mart_apparel_deepdive` model. This model will contain sales data alongside fit feedback.
4.  **Dashboard (Power BI):**
    *   Connect Power BI to the PostgreSQL database.
    *   Create a dashboard with visuals for:
        *   Monthly demand trends for different apparel categories.
        *   A table of products with the highest "Fit Dissatisfaction Rate".
        *   A map showing regional demand.

### Phase 4: Deep Dive 2 - Electronics Analytics

1.  **Filtering:**
    *   In dbt, create a model `mart_electronics_orders` that filters for electronics categories.
2.  **Reliability Analysis (Python & SQL):**
    *   **Time-to-Failure (SQL):** In a dbt model, calculate the average time between `order_purchase_timestamp` and `review_creation_date` for products with low review scores (<=2).
    *   **Reliability Score (Python):** Write a script (`scripts/analyze_electronics_reviews.py`) to calculate a "Reliability Score" based on review scores and keywords (e.g., "defective," "broken"). Load these scores into a new table, `electronics_reliability_analysis`.
3.  **Final Electronics Model:**
    *   Join the reliability scores and time-to-failure analysis into a final `mart_electronics_deepdive` model in dbt.
4.  **Dashboard (Metabase):**
    *   Connect Metabase to the PostgreSQL database.
    *   Create a dashboard showing:
        *   A list of the most unreliable products.
        *   Average "time-to-failure" by product category.
        *   Seller performance based on the reliability of products they sell.

### Phase 5: Automation & Presentation

1.  **Orchestration (Conceptual):**
    *   Map out an Airflow DAG that would run the pipeline in sequence: `ingest_data.py` -> `dbt run` -> `analyze_apparel_reviews.py` -> `analyze_electronics_reviews.py`.
2.  **Final Presentation:**
    *   Prepare a walkthrough of the project, using this `PROJECT_PLAN.md` as a guide.
    *   Showcase the final dashboards and explain the actionable insights they provide to clients.
    *   Be ready to dive into the code for the dbt models and Python scripts.
