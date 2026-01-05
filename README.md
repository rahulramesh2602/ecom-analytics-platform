# E-commerce Analytics Platform

A comprehensive data analytics solution for e-commerce businesses, demonstrating modern data engineering best practices with dbt, PostgreSQL, and advanced analytics. This project transforms raw transactional data into actionable business insights through a scalable ELT pipeline.

##  Project Overview

**Dataset**: [Brazilian E-commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (~100k orders, 2016-2018)

**Architecture**: Modern ELT pipeline using dbt for transformations and PostgreSQL as the data warehouse

**Business Focus**: Multi-industry analytics with specialized deep-dives for Apparel and Electronics sectors

##  Architecture

```
Raw Data (CSVs) → PostgreSQL (Staging) → dbt Transformations → Analytics-Ready Models → Business Insights
```

### Tech Stack
- **Database**: PostgreSQL 
- **Transformation**: dbt (Data Build Tool)
- **Language**: Python, SQL
- **Environment**: Local development with virtual environment

## Data Models

### Data Warehouse Structure

```
ecommerce_db/
├── public/                    # Raw data tables (9 source tables)
└── analytics/                 # Transformed dbt models
    ├── staging/              # 7 staging models
    ├── intermediate/         # 1 comprehensive joined model  
    └── marts/               # 4 business-ready analytics models
```

###  Staging Layer (7 models)
Clean and standardized individual tables with proper data types:

- `stg_orders` - Order lifecycle and status tracking
- `stg_customers` - Customer demographic and location data
- `stg_products` - Product catalog with specifications
- `stg_order_items` - Order line items (price, shipping)
- `stg_sellers` - Seller information and locations
- `stg_order_payments` - Payment methods and values
- `stg_product_category_name_translation` - Portuguese to English translations

###  Intermediate Layer (1 model)
- `int_orders_joined` - Comprehensive business dataset joining all staging models with calculated fields:
  - Order lifecycle metrics
  - Customer and seller details
  - Product information with English categories
  - Financial calculations (total_item_value)
  - Delivery performance (delivery_days, is_late_delivery)

###  Marts Layer (4 models)

#### 1. Monthly Sales Summary (`mart_monthly_sales_summary`)
- **24 rows** - Monthly time series analysis
- Revenue trends and growth rates
- Order volume patterns
- Month-over-month performance tracking

#### 2. Customer Analytics (`mart_customer_analytics`) 
- **98,666 rows** - Individual customer profiles
- Customer lifetime value and behavior analysis
- Geographic distribution and ordering patterns
- Customer segmentation metrics

#### 3. Product Performance - Category Level (`mart_product_performance`)
- **71 rows** - One per product category
- Performance tiers: Top Performers, Strong Performers, Average Performers, Focus Areas
- Revenue, volume, and pricing analysis by category
- Strategic category management insights

#### 4. Product Performance - Individual Level (`mart_individual_products`)
- **32,951 rows** - One per individual product
- Detailed product-specific performance metrics
- Within-category and overall rankings
- Product attribute analysis (dimensions, weight, photos)
- Inventory optimization insights

##  Getting Started

### Prerequisites
- PostgreSQL installed and running
- Python 3.8+
- Git

### Setup

1. **Clone Repository**
   ```bash
   git clone <repository-url>
   cd ecom-analytics-platform
   ```

2. **Environment Setup**
   ```bash
   python -m venv venv
   source venv/bin/activate  # macOS/Linux
   pip install -r requirements.txt
   ```

3. **Database Setup**
   ```bash
   # Create PostgreSQL database
   createdb ecommerce_db
   
   # Run data ingestion
   python scripts/ingest_data.py
   ```

4. **dbt Setup**
   ```bash
   cd ecom_analytics
   dbt deps
   dbt run
   ```

## Key Features Implemented

###  Phase 1: Data Ingestion & Setup
- [x] Raw data ingestion to PostgreSQL
- [x] Database schema creation
- [x] Environment configuration

###  Phase 2: dbt Transformation Pipeline
- [x] 3-layer dbt architecture (staging → intermediate → marts)
- [x] 7 staging models for data cleaning and standardization
- [x] 1 comprehensive intermediate model with business logic
- [x] 4 analytics-ready mart models for different use cases
- [x] Proper dbt project structure and configuration

###  Next Phases (Planned)
- [ ] **Phase 3**: Apparel Industry Deep Dive - Fit-Driven Demand Optimization
- [ ] **Phase 4**: Electronics Industry Deep Dive - Product Reliability Analytics
- [ ] **Phase 5**: Dashboard Development & Automation

##  Sample Business Insights

### Top Performing Categories by Revenue:
1. **Health & Beauty**: $1.26M (Top Performer)
2. **Watches & Gifts**: $1.21M (Top Performer) 
3. **Bed Bath & Table**: $1.04M (Top Performer)
4. **Sports & Leisure**: $988K (Top Performer)
5. **Computer Accessories**: $912K (Top Performer)

### Key Metrics:
- **Total Products Analyzed**: 32,951 individual products across 71 categories
- **Total Customers**: 98,666 unique customers
- **Analysis Period**: 24 months of transaction data
- **Geographic Coverage**: Brazilian e-commerce market
