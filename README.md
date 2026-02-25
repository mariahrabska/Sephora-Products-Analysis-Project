# Sephora-Products-Analysis-Project
Sephora Product Analytics

End to End BI Project

Overview

This project demonstrates a complete data analytics workflow based on the Sephora Products and Skincare Reviews dataset.

The analysis covers data cleaning in Python, business querying in PostgreSQL, and executive level dashboard development in Power BI. The objective was to evaluate pricing strategy, product quality perception, and customer engagement patterns across the Sephora product portfolio.

The project simulates a real world BI process from raw data to decision oriented insights.

Project Workflow

-Data Cleaning and Feature Engineering in Python
-Relational Modeling and Business Queries in PostgreSQL
-Interactive Executive Dashboard in Power BI

Data Source

Dataset used in this project is publicly available on Kaggle:

Sephora Products and Skincare Reviews
https://www.kaggle.com/datasets/nadyinky/sephora-products-and-skincare-reviews


Data Preparation in Python

Raw product and review files were cleaned and transformed using Pandas and NumPy.

Key steps included:
  -Merging multiple review files
  -Removing duplicates
  -Handling missing values
  -Mapping brand and pricing data using product_id
  -Creating derived metrics such as:
    discount_percentage
    discount_bucket
    price_range
    on_sale flag
    popularity segmentation based on loves_count
    rating_category segmentation
    has_reviews indicator
    engagement related metrics

Cleaned data was exported to PostgreSQL and CSV files.


Database and SQL Analysis
Two core tables were created:
  dim_products
  fact_reviews

SQL was used to answer business driven questions related to:
  -Pricing and promotion strategy
  -Discount distribution and depth
  -Rating differences between regular and discounted products
  -Low rated product analysis by category
  -Popularity and brand level engagement
  -Review trends over time
  -Correlation analysis between helpfulness and review length

This stage ensured metric validation before visualization.

Power BI Dashboard Structure

The final dashboard consists of three analytical sections.

1. Pricing and Promotion
Focus on promotional selectivity and discount depth.

Key metrics:
  Percent on sale
  Average discount depth
  Average price
  Total products

Insights include discount strategy by category, price range, and popularity segment.

2. Quality Assurance and Customer Sentiment
Focus on product quality perception across the full catalog.

Key metrics:
  Average rating
  Percent of rated products
  Percent of low rated products
  Average rating gap between regular and discounted products

Analysis includes rating structure and category level quality variation.

3. Brand Engagement and Market Trends Skincare Only
This section is filtered to Skincare only due to review data availability.

Key metrics:
  Total loves
  Average loves per product
  Average reviews per product
  Engagement ratio

Analysis includes brand ranking, review trends over time, and price versus engagement relationship.

Technologies Used:
-Python
-Pandas
-NumPy
-PostgreSQL
-SQL
-SQLAlchemy
-Power BI
-DAX

Key Strengths Demonstrated

-End to end analytical workflow
-Feature engineering and segmentation logic
-Relational modeling and structured SQL analysis
-Clear separation of pricing, quality, and engagement perspectives
-Handling dataset constraints without misleading aggregation
-Business oriented KPI designng aggregation
-Business driven SQL queries
-Consistent metric definition across tools



