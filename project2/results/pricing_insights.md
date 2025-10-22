## Pricing and Discount Strategy Analysis - Insights Report

### Objective 

The goal of this analysis is to evaluate how discountstrategirs influence pricing tiers, customer ratings, and overall sales performance. By comparing the discounted vs. non-discounted products and analyzing differences across pricing tiers, we aim to identify which strategy maximizes customer satisfaction and perceived value.

### Data Overview

The dataset includes products across five pricing tiers:

- **Budget**
- **Economy**
- **Mid-Range**
- **Premium**
- **Luxury**

Each record contains variables such as:

- **Actual Price**
- **Discount Percentage**
- **Discounted Price**
- **Customer Ratings**
- **Product Category**

Data was exported from the master product table and prepared for both **Correlariona and Statistical analysis** and **VIsual exploration**.

### Key Findings 

#### 1. Oveall Market Overview 

- **Total Revenue:** $828M
- **Products Analyzed:** 1351
- **Average Customer Rating:** 4.09
- **Average Discount:** 46.7%

This shows a highly promotional market where nearly half of all sales rely on discount-based pricing. 

#### 2. Revenue by Price Tier 

| Price Tier                 | % of Products | % of Total Revenue | Insight                                                                |
| -------------------------- | ------------- | ------------------ | ---------------------------------------------------------------------- |
| **Premium**          | 7%            | 46%                | The Premium segment dominates revenue despite a smaller product count. |
| **Mid-Range**        | ~20%          | 30%                | Balanced performance with strong ratings and stable discounts.         |
| **Budget & Economy** | 60%+          | 15–20%            | High volume, low-margin products contributing less to total revenue.   |
| **Luxury**           | <5%           | <5%                | Niche market with limited impact.                                      |

**Insights:** Focusing on **Premium and Mid-Range**products yeids the hights ROI, suggesting customers value quality and are willing to pay more within reasonable discount levels.

#### Discount Effectivness 

| Discount Range    | Avg. Rating | Key Observation                                                      |
| ----------------- | ----------- | -------------------------------------------------------------------- |
| **0–25%**  | 4.15        | Best performance — optimal balance of value and quality perception. |
| **25–40%** | 4.12        | Slight drop but still strong performance.                            |
| **40–60%** | 4.08        | Declining satisfaction beyond 40%.                                   |
| **60%+**    | 4.04        | Over-discounting may reduce perceived quality.                       |

**Insights:** Moderate discounts (0-40%) perform best in both sales and customer rating. Excessive discounting reduces trust in product qualityand pereived brand value.

#### 4. Statistical Test Summary

A **two-sample t-test** was conduced between discounted and non-discounted products to test if discounting significantly impacts ratings. 

- **t-statistics:** `≈ -3.3`
- **p-value:** `≈ 0.001`

**Insights:** The difference in ratings between discounted and a non-discounted products is **statisticaly signigicant** as p < 0.05. This indicates that discounted products tend to have higher customer ratings suggesting that discounts positively influence percevied vlaue and satisfaction
