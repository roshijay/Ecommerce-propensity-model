# Ecommerce-propensity-model
E-commerce repeat purchase propensity model using SQL and Tableau

Built to mirror retention analytics problem Amazon and e-commerce platforms solve internally - using a real Brazilian marketplace dataset of 100k transactions. 

## Business Question
97% of customers in this marketplace never returned after their first purchase. What behavioral signals predict the 3% who will — and can we score every customer by their likelihood to return?

## Dataset
Olist Brazilian E-Commerce (Kaggle) — 99,441 customers, 100k delivered orders, 2016–2018. 6-table relational schema: customers, orders, order_items, products, order_payments, order_reviews.

## Tools
SQL (SQLite via DBeaver), Tableau 

## Key Findings
- Delivery speed does not differentiate repeat buyers — both groups received orders ~11 days ahead of estimated date
- Review scores are similar (4.15 one-time vs 4.20 repeat) — minimal predictive signal alone
- Voucher users return at 22.4% vs 3.2% for credit card — likely reflects reverse causality as vouchers are issued to existing customers
- Home/lifestyle categories (cama_mesa_banho(bed/bath), moveis_decoracao(home decor), ferramentas_jardim(garden tools) drive 15–25% repeat rates vs 3–6% for electronics
- Propensity model identified 4,109 high-likelihood repeat buyers (score 4-5) out of 97,442 customers

## Data Quality Notes
- 1,386 orders had null product category — flagged and excluded from category analysis
- Voucher repeat rate finding requires causal interpretation care.

## SQL Concepts Demonstrated
Window functions, multi-level subqueries, self-joins, CASE WHEN scoring, JULIANDAY date arithmetic, HAVING filters, aggregate functions.

## Dashboard
https://public.tableau.com/views/ecommerce_propensity/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link

## Repo Structure
/sql
  01_purchase_frequency.sql
  02_delivery_performance.sql
  03_review_scores.sql
  04_category_analysis.sql
  05_payment_analysis.sql
  06_propensity_scoring.sql
findings.md
README.md
