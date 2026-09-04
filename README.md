# 🚚 Supply Chain Performance & Delivery Delay Analysis

## 📌 Introduction

This project analyzes the DataCo Supply Chain dataset to understand sales, profitability, order volume, delivery performance and delivery delays across global markets with a deeper operational analysis of India.

### The project focuses on analyzing important supply chain factors such as:

### • 💰 Sales & Profitability

### • 📦 Order Volume

### • 🚚 Delivery Performance & Late Delivery Risk

### • 🌍 Market & Country-Level Trends

### • 📦 Product & Category Performance

### • 👥 Customer Segment Performance

### • 🏙️ India City & State-Level Delivery Hotspots

### • 🚛 Shipping Mode Reliability

### The analysis includes:

### • 🧹 Data Cleaning and Corruption Recovery using Python

### • 📊 Business and Delivery Analysis using PostgreSQL

### • 🔍 Operational Investigation and Root-Cause Analysis

### • 📊 Interactive Power BI Dashboard Development

The project aims to identify where delivery performance breaks down, which markets and shipping modes require attention and how product mix and order volume influence revenue patterns.

---

## 🎯 Project Objective

The main objective of this project is to analyze global supply chain performance using the DataCo dataset and identify important business and operational patterns.

This project aims to:

- 📊 Analyze sales, profitability, order volume and delivery performance
- 🧠 Identify delivery-risk patterns across countries, categories and shipping modes
- 🌍 Identify high-impact markets and customer segments
- 🔍 Analyze India at state, city, category and shipping-mode levels
- 📉 Investigate unusual revenue patterns alongside order volume and product mix
- 📊 Develop a two-page Power BI dashboard for executive and operational analysis

The overall goal is to generate actionable insights that help prioritize supply chain issues and support better business and operational decision-making.

---

## 🏦 Business Problem

A global supply chain business needs to understand not only whether delivery performance is poor, but also where operational attention should be prioritized across markets, cities, product categories and shipping modes.

Revenue performance also needs to be evaluated alongside order volume and product mix because an increase in orders does not always result in an increase in revenue.

This project addresses both problems by identifying where delivery performance breaks down and investigating unusual revenue patterns rather than simply reporting them.

---

## 📂 Dataset Description

The dataset used is the publicly available DataCo Supply Chain dataset, containing 180,519 rows and 51 columns of order-level transaction data from 2015 to 2018.

## 📌 Key Columns

| Category | Important Columns |
|------------|------------|
| Order & Delivery | `order_id`, `order_date`, `delivery_status`, `late_delivery_risk`, `shipping_mode`, `days_for_shipping_real`, `days_for_shipment_scheduled` |
| Sales & Profitability | `sales`, `benefit_per_order`, `order_item_total`, `order_item_quantity` |
| Product | `product_name`, `category_name`, `product_price` |
| Customer | `customer_id`, `customer_segment` |
| Location & Market | `market`, `order_country`, `order_state`, `order_city`, `order_region` |

**Note on 2018 data coverage:** The dataset spans 2015 to 2018, but 2015 to 2017 provide usable monthly coverage while 2018 is extremely sparse with records across only a few months. Therefore, 2018 is not treated as a reliable year-over-year business trend. The main sales trend analysis focuses on 2015 to 2017, while January 2018 was investigated separately because it had enough activity for comparison with December 2017.

---

## 🛠 Tools and Libraries Used

### 💻 Programming & Query Languages

- Python
- PostgreSQL

### 📊 Data Analysis

- Pandas
- NumPy
- Matplotlib

### 📊 Dashboard & Reporting

- Power BI

### 🧪 Development Environment

- Jupyter Notebook

---

## 🔄 Project Workflow

### 1. Data Loading & Initial Inspection

- Loaded the DataCo dataset using Pandas
- Explored dataset structure, data types and initial data-quality issues

### 2. Data Cleaning & Corruption Recovery

- Investigated missing values and column-shift corruption
- Recovered reliable product, order and shipping information
- Validated numeric, categorical, date and location fields
- Exported the cleaned dataset for further analysis

### 3. SQL Business Analysis

- Analyzed sales and profitability
- Evaluated product categories and customer segments
- Compared markets and countries
- Examined order volume and overall business performance

### 4. Global Delivery Analysis

- Analyzed late-delivery patterns across countries
- Compared delivery performance across shipping modes
- Evaluated actual shipping time against scheduled shipping time
- Identified high-impact delivery areas for further investigation

### 5. India Operational Deep Dive

- Analyzed sales and order performance by state
- Identified city-level delivery hotspots
- Compared delivery performance across product categories
- Investigated city and shipping-mode combinations

### 6. Operational Investigation

Vadodara and Bhavnagar showed a noticeable difference in delivery performance despite being cities in the same state. The investigation compared customer segments, shipping modes, product categories, order and delivery status and actual vs scheduled shipping time. The investigation was stopped after inconsistencies were identified in the raw `Shipping Date` data, so no definitive root cause was claimed.

### 7. Revenue Anomaly Investigation

Investigated the January 2018 revenue decline by comparing December 2017 and January 2018 sales, order volume and product-level performance to understand whether the change was related to demand or product mix.

### 8. Power BI Dashboard

- Created a two-page Power BI dashboard
- Built a Global Executive Overview for high-level business monitoring
- Built an India Operational Deep Dive for detailed operational analysis
- Added KPIs, business performance analysis and delivery insights

---

## 🔍 Key Insights

### 🌍 Global Insights

- Europe is the strongest market by revenue at **$10.87M**, followed by LATAM at **$10.17M**, while Africa is the smallest market at **$2.29M**.
- Sales were broadly stable during 2015 to 2017. The sparse 2018 data is not treated as a genuine business decline.
- Delivery delays are widespread across countries rather than being limited to a small number of markets.
- **Fishing** is the strongest category by revenue and profit at **$6.74M sales and $737K profit**, while **Cleats** has the highest unit volume at **70,429 units**, showing the difference between revenue performance and volume performance.
- **Consumer** is the strongest customer segment with **$19.03M sales and $2.07M profit**.
- **First Class** has the highest late-delivery rate at **95.29%** despite the shortest average shipping time of **2.00 days**, showing that faster service does not automatically mean better reliability.
- **Standard Class** carries the highest order volume while having a lower late-delivery rate than First Class and Second Class.

### 🇮🇳 India Insights

- **Maharashtra** leads India in sales with **$188,849** from **393 orders**.
- Delivery performance varies significantly across Indian cities, creating identifiable operational hotspots.
- High-delay categories with meaningful order volume deserve greater attention than categories with very small volumes.
- City x shipping-mode analysis provides a more actionable operational view than analyzing city or shipping mode alone. **Mumbai Second Class** is a notable hotspot.
- **Second Class** has the largest gap between scheduled and actual shipping time at **+2.05 days**, indicating a significant service-level mismatch.

---

## 📉 January 2018 Revenue Anomaly

January 2018 sales decreased by **3.8%** compared with December 2017, while orders increased by **28%**. Sales per order also decreased by **24.8%**.

A product-level investigation showed a shift in product mix. Several high-value December products such as **Porcelain Crafts, Dell Laptop, Industrial Consumer Electronics and Children's Heaters** had no January sales, while January activity included higher-volume lower-value products such as **Fighting Video Games and Toys**.

**Business conclusion:** The revenue decline was driven by a shift in product mix rather than lower order demand.

---

## 💼 Business Impact

- Prioritize high-impact delivery hotspots across countries, cities and categories
- Investigate First Class and Second Class reliability
- Focus operational attention on high-delay categories with meaningful order volume
- Use city x shipping-mode combinations for more precise operational investigation
- Monitor product mix alongside order volume when evaluating revenue trends
- Protect strong-performing categories and identify opportunities in underdeveloped markets and customer segments

---

## 📊 Power BI Dashboard

- Created an interactive two-page Power BI dashboard for supply chain performance analysis
- **Page 1** provides a Global Executive Overview of sales, orders, profitability, markets, customer segments, delivery risk and shipping modes
- **Page 2** provides an India Operational Deep Dive covering states, cities, categories and city x shipping-mode delivery performance
- Included KPI cards and business-focused visualizations for executive and operational decision-making

### 📌 KPI Cards

**Total Sales:** $36.66M | **Total Orders:** 63,663 | **Total Profit:** $3.97M | **Profit Margin:** 10.82% | **Late Delivery Rate:** 54.83% | **Average Shipping Days:** 3.50 days

Reporting thresholds were applied to reduce the risk of overinterpreting small samples:

- Global country-level delivery analysis: **1,000+ orders**
- India city-level and city x shipping-mode analysis: **20+ orders**

📌 Dashboard Screenshots: (added in repository)

📌 File: `Supply_Chain_Dashboard.pbix`

### Page 1 - Global Supply Chain Performance

![Dashboard](Dashboard_Page1.png)

### Page 2 - India Supply Chain Deep Dive

![Dashboard](Dashboard_Page2.png)

---

## 📌 Key Takeaways

- Delivery delays are widespread across markets and cities rather than isolated cases.
- Faster shipping does not automatically mean more reliable delivery.
- India city x shipping-mode analysis provides more actionable operational prioritization.
- Revenue should be evaluated alongside order volume and product mix.
- Combining Python data cleaning, PostgreSQL business analysis and Power BI reporting creates an end-to-end Data Analyst workflow.

---

## 👤 Author

**Avinash Reddy**

This project is part of my Data Analyst learning journey focused on Python-based data cleaning, PostgreSQL business analysis and Power BI dashboard development to generate business insights and support stakeholder-driven decision-making.
