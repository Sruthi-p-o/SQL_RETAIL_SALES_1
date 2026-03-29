# 🛒 Retail Sales Data Analysis (PostgreSQL Project)

## 📌 Project Overview

This project focuses on **Retail Sales Data Analysis** using **PostgreSQL (pgAdmin)**.
It covers the complete workflow from **data cleaning → data exploration → business insights generation** using SQL queries.

The goal of this project is to extract meaningful insights from retail transaction data and solve real-world business problems.

---

## 🛠️ Tools & Technologies Used

* PostgreSQL
* pgAdmin
* SQL (Structured Query Language)

---

## 📂 Dataset Description

The dataset contains retail transaction details with the following columns:

* `transactions_id` – Unique transaction ID
* `sale_date` – Date of sale
* `sale_time` – Time of sale
* `customer_id` – Unique customer ID
* `gender` – Customer gender
* `age` – Customer age
* `category` – Product category
* `quantiy` – Quantity purchased
* `price_per_unit` – Price per item
* `cogs` – Cost of goods sold
* `total_sale` – Total transaction value

---

## 🧹 Data Cleaning

Performed the following steps:

* Checked for NULL values in all columns
* Removed records with missing values
* Ensured data consistency

```sql
DELETE FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;
```

---

## 🔍 Data Exploration

Basic exploration queries:

* Total number of sales
* Total number of customers
* Unique product categories

```sql
SELECT COUNT(*) AS total_sales FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;
```

---

## 📊 Business Problems & Insights

### 1. Sales on a Specific Date

```sql
SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05';
```

---

### 2. Clothing Transactions (Nov 2022, High Quantity)

```sql
SELECT * FROM retail_sales
WHERE category = 'Clothing'
AND quantiy >= 4
AND TO_CHAR(sale_date,'YYYY-MM') = '2022-11';
```

---

### 3. Total Sales by Category

```sql
SELECT category,
SUM(total_sale) AS net_sales,
COUNT(*) AS orders
FROM retail_sales
GROUP BY category;
```

---

### 4. Average Age (Beauty Category)

```sql
SELECT AVG(age) AS avg_age 
FROM retail_sales 
WHERE category = 'Beauty';
```

---

### 5. High Value Transactions (>1000)

```sql
SELECT * FROM retail_sales 
WHERE total_sale > 1000;
```

---

### 6. Transactions by Gender & Category

```sql
SELECT gender, category, COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender;
```

---

### 7. Best Selling Month (Each Year)

```sql
SELECT *
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY 1,2
) AS t1
WHERE rank = 1;
```

---

### 8. Top 5 Customers (Highest Sales)

```sql
SELECT customer_id,
SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

---

### 9. Unique Customers per Category

```sql
SELECT category,
COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

---

### 10. Sales by Time Shift

```sql
WITH hourly_sales AS (
    SELECT *,
    CASE 
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
    FROM retail_sales
)
SELECT shift,
COUNT(transactions_id) AS total_orders
FROM hourly_sales
GROUP BY shift;
```

---

## 📈 Key Insights

* Identified **top-performing product categories**
* Analyzed **customer purchasing behavior**
* Found **peak sales periods (monthly & daily shifts)**
* Discovered **high-value customers**
* Segmented sales based on **time of day**

---

## 🚀 Conclusion

This project demonstrates how SQL can be used to:

* Clean raw data
* Perform exploratory analysis
* Solve real-world business problems
* Generate actionable insights

