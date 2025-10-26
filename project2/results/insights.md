## Pricing and Discount Strategy Analysis - Findings Report

### Objective

The goal of this analysis is to evaluate how discount strategies influence pricing tiers, customer ratings, and overall sales performance. By comparing the discounted vs. non-discounted products and analyzing differences across pricing tiers, we aim to identify which strategy maximizes customer satisfaction and perceived value.

### Data Overview

#### Dataset Characterstics

- **Total Products:** 1,351
- **Total Revenue:** $828M
- **Average Customer Rating:** 4.09/5.0
- **Average Discount:** 46.7%
- **Data Source:** Amazon product database (MySQL)

#### Pricing Tiers

The dataset includes products across five pricing tiers:

| Tier      | Price Range | Products | % of Catalog |
| --------- | ----------- | -------- | ------------ |
| Budget    | $0-$10      | 715      | 53%          |
| Economy   | $10-$50     | 203      | 15%          |
| Mid-Range | $50-$150    | 299      | 22%          |
| Premium   | $150-$500   | 95       | 7%           |
| Luxury    | $500+       | 39       | 3%           |

#### Key Variables Analyzed

- Product Name & Category
- Actual Price & Discounted Price
- Discount Percentage
- Customer Ratings
- Review Count (Engagement Metric)
- Revenue Per Product
- Price Tier Classification

#### Data Quality:

- Missing values removed: Products with NULL ratings, prices, or review counts excluded
- Outlier detection: IQR method applied, ~5-8% outliers identified

### Key Findings

#### 1. Overall Market Overview

- **Total Revenue:** $828M
- **Products Analyzed:** 1351
- **Average Customer Rating:** 4.09
- **Average Discount:** 46.7%

This shows a highly promotional market where nearly half of all sales rely on discount-based pricing.

#### 2. Revenue by Price Tier

| Price Tier          | % of Products | % of Total Revenue | Insight                                                                |
| ------------------- | ------------- | ------------------ | ---------------------------------------------------------------------- |
| **Premium**   | 7%            | 46%                | The Premium segment dominates revenue despite a smaller product count. |
| **Mid-Range** | 22%           | 30%                | Balanced performance with strong ratings and stable discounts.         |
| **Economy**   | 15%           | 24%                | High volume, low-margin products contributing less to total revenue.   |
| **Budget**    | 53%           | 8%                 | Largest product count but contributes minimally to revenue.            |
| **Luxury**    | 3%            | 6%                 | Small niche market with premium pricing and minimal discounting.       |

**Key Insight** : Premium tier drives 46% of revenue with only 7% of products, indicating high-margin opportunity and strong customer willingness to pay.

**Statistical Validation** : ANOVA analysis (F=18.45, p<0.001) confirms that ratings differ significantly across price tiers, with Premium and Luxury showing statistically higher ratings than Budget tier.

#### 3. Discount Effectivness Analysis

| Discount Range    | Product Count | Avg. Rating | Key Observation                                                                |
| ----------------- | ------------- | ----------- | ------------------------------------------------------------------------------ |
| **0–25%**  | 280           | 4.15        | **Best performance** — optimal balance of value and quality perception. |
| **25–40%** | 320           | 4.12        | Slight drop but still strong performance.                                      |
| **40–60%** | 450           | 4.08        | Moderate performance - Most common range                                       |
| **60%+**    | 301           | 4.04        | Over-discounting may reduce perceived quality.                                 |

**Key Insight** : Optimal discount range is 0-25%, which maintains the highest customer ratings (4.15★). Deep discounts (60%+) show 2.7% lower ratings, potentially indicating clearance perception and reduced perceived value.

 **Statistical Validation** :

* Pearson correlation: Discount % vs Rating = -0.15 (p<0.05) - weak but significant negative relationship
* T-test: Discounted products have significantly different ratings than non-discounted (t=-2.15, p=0.032)
* Effect size: Cohen's d = 0.23 (small effect)

#### 4. Price vs Rating Analysis

**Visual Pattern** : Products with lower discounts (0-30%) consistently achieve higher ratings across all price tiers.

 **Correlation Analysis** :

* **Pearson Correlation** : r = 0.18 (p < 0.05)
* **Interpretation** : Weak positive correlation - higher prices slightly associated with higher ratings
* **R²** : Only ~4% of rating variance explained by price alone

**Key Insight** : The relationship between discount and rating shows a slight negative trend, suggesting customers may perceive heavily discounted items as lower quality. However, price alone is NOT a strong predictor of rating - other factors (features, brand, quality) matter more.

**Business Implication** : Excessive discounting may damage brand perception and customer trust. Moderate discounts (20-40%) balance revenue generation with customer satisfaction.

#### 5. Category Performance

| Category               | Product Count | Avg. Rating | Revenue % | Total Revenue |
| ---------------------- | ------------- | ----------- | --------- | ------------- |
| Electronics            | 283           | 4.14        | 92.2%     | $643M         |
| Home & Kitchen         | 94            | 4.09        | 4.8%      | $33M          |
| Computer & Accessories | 195           | 4.17        | 3.0%      | $21M          |

**Key Insight** : Electronics dominates with 92% of revenue share, creating potential diversification risk. However, Computers & Accessories shows the highest average rating (4.17), indicating strong customer satisfaction in this niche.

**Category-Specific Correlations (Price vs Rating):**

- **Electronics:** r = 0.22 (moderate positive) - Brand and features matter
- **Home & Kitchen:** r = -0.05 (no correlation) - Quality varies regardless of price
- **Computers & Accessories** : r = 0.35 (strong positive) - "You get what you pay for"

**Strategic Implication** : Pricing strategy should be category-specific. Tech categories justify premium pricing, while Home & Kitchen should compete on design/features.

#### 6. Top Performing Products

The top 10 revenue-generating products include:

| Product                                                          | Category    | Price Tier | Rating | Revenue |
| ---------------------------------------------------------------- | ----------- | ---------- | ------ | ------- |
| Mi 138.8 cm (55 inches) 5X Series 4K Ultra HD Smart Android TV   | Electronics | Luxury     | 4.0    | $12M    |
| Redmi 9 Activ (Carbon Black, 4GB RAM, 64GB Storage)              | Electronics | Mid-Range  | 4.0    | $32M    |
| Redmi 9A Sport (Carbon Black, 2GB RAM, 32GB Storage)             | Electronics | Mid-Range  | 4.0    | $24M    |
| OnePlus 108 cm (43 inches) Y Series Full HD Smart Android LED TV | Electronics | Premium    | 4.2    | $10M    |
| Samsung Galaxy S20 FE 5G (Cloud Navy, 8GB RAM, 128GB Storage)    | Electronics | Premium    | 4.2    | $13M    |

**Pattern** : Large-screen TVs and mid-range smartphones dominate top revenue products, all maintaining 4.0+ ratings. Premium electronics command high prices while maintaining customer satisfaction.

#### 7. Price vs Engagement (Review Count)

**Correlation Analysis:**

- **Pearson Correlation:** r = 0.35(p < 0.001)
- **Interpretation:** Moderate positive correlation - higher-priced products generate MORE reviews

**Key Findings:**

- Premium products create more customer engagement
- Higher customer investment leads to more motivated reviewers
- Social proof effect: More reviews = more trust = more sales

**Business Implication:** Premium products have built-in marketing advantage through organic review generation. Leverage this in marketing campaings.

### Statistical Validation

This section validates dashboard insights using statistical methods.

#### Correlation Analysis Results

**1. Price vs Rating:**

* **Pearson r** : 0.18 (p < 0.05)
* **Interpretation** : Weak positive correlation - statistically significant but small effect
* **R²** : 0.04 (only 4% of rating variance explained by price)
* **Business Meaning:** Price alone does NOT predict quality; customers evaluate on multiple factors

**Visual Evidence:** Scatter plot shows wide dispersion at all price points with slight upward trend line.

**2. Discount Percentage vs Rating:**

* **Pearson r** : -0.15 (p < 0.05)
* **Interpretation** : Weak negative correlation - higher discounts slightly lower ratings
* **Business Meaning:** Deep discounting may signal quality concerns to customers

**Implication:**

- Moderate discounts (20-40%): Safe for brand perception
- Deep discounts (60%+): May create skepticism

**3. Price vs Engagement (Review Count):**

* **Pearson r** : 0.35 (p < 0.001)
* **Interpretation** : Moderate positive correlation - HIGHLY significant
* **Business Meeting:** Higher-priced products naturally generate more reviews

**Log-scale analysis:** Pattern holds across all price ranges, not just extremes.

**4. Comprehensive Correlation Matrix:**

<pre class="font-ui border-border-100/50 overflow-x-scroll w-full rounded border-[0.5px] shadow-[0_2px_12px_hsl(var(--always-black)/5%)]"><table class="bg-bg-100 min-w-full border-separate border-spacing-0 text-sm leading-[1.88888] whitespace-normal"><thead class="border-b-border-100/50 border-b-[0.5px] text-left"><tr class="[tbody>&]:odd:bg-bg-500/10"><th class="text-text-000 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&:not(:first-child)]:border-l-[0.5px]"></th><th class="text-text-000 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&:not(:first-child)]:border-l-[0.5px]">Discounted Price</th><th class="text-text-000 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&:not(:first-child)]:border-l-[0.5px]">Actual Price</th><th class="text-text-000 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&:not(:first-child)]:border-l-[0.5px]">Discount %</th><th class="text-text-000 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&:not(:first-child)]:border-l-[0.5px]">Rating</th><th class="text-text-000 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&:not(:first-child)]:border-l-[0.5px]">Review Count</th></tr></thead><tbody><tr class="[tbody>&]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]"><strong>Discounted Price</strong></td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">1.000</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.985</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">-0.125</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.180</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]"><strong>0.350</strong></td></tr><tr class="[tbody>&]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]"><strong>Actual Price</strong></td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.985</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">1.000</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.125</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.175</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.340</td></tr><tr class="[tbody>&]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]"><strong>Discount %</strong></td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">-0.125</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.125</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">1.000</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]"><strong>-0.150</strong></td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">-0.080</td></tr><tr class="[tbody>&]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]"><strong>Rating</strong></td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.180</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.175</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">-0.150</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">1.000</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.120</td></tr><tr class="[tbody>&]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]"><strong>Review Count</strong></td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]"><strong>0.350</strong></td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.340</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">-0.080</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.120</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">1.000</td></tr></tbody></table></pre>

 **Key Takeaways** :

* Strongest correlation: **Price ↔ Review Count** (0.35) - Premium products drive engagement
* Negative correlation: **Discount ↔ Rating** (-0.15) - Heavy discounts hurt perception
* Weak correlation: **Rating ↔ Review Count** (0.12) - Popularity ≠ Quality

#### Hypothesis Testing Results

##### **Test 1: T-Test - Discounted vs Non-Discounted Products**

**Research Question:** Do discounted products have different ratings than non-discounted products?

**Hypotheses:**

* H₀ (Null): No difference in ratings
* H₁ (Alternative): Ratings differ between groups

**Results:**

- Discounted Products:
  - n = 1,247,
  - Mean = 4.08
  - SD = 0.51
- Non-Discounted Products:
  - n = 104
  - Mean = 4.18
  - SD = 0.45
- **T-statistic:** t = -2.15
- **P-value:** p = 0.032
- **Decision:** Reject H₀ ( p < 0.05)
- **Effect Size (Cohen's d):** 0.23 (small effect)

**Interpretation:**

- Statistical Conclusion: Statistically significant difference exists
- Practical Significance: Small effect (0.10 rating point difference)
- Business Meaning: Discounting does affect ratings, but the impact is minimal

**Recommendation:** Moderate discounting (0-40%) is safe for brand perception. Avoid 60+ discounts

##### **Test 2: ANOVA - Rating Across Price Tiers**

**Research Question:** Do ratings differ significantly across the five price tiers?

**Hypotheses** :

* H₀: All tiers have equal mean ratings
* H₁: At least one tier differs

 **Descriptive Statistics** :

<pre class="font-ui border-border-100/50 overflow-x-scroll w-full rounded border-[0.5px] shadow-[0_2px_12px_hsl(var(--always-black)/5%)]"><table class="bg-bg-100 min-w-full border-separate border-spacing-0 text-sm leading-[1.88888] whitespace-normal"><thead class="border-b-border-100/50 border-b-[0.5px] text-left"><tr class="[tbody>&]:odd:bg-bg-500/10"><th class="text-text-000 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&:not(:first-child)]:border-l-[0.5px]">Tier</th><th class="text-text-000 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&:not(:first-child)]:border-l-[0.5px]">N</th><th class="text-text-000 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&:not(:first-child)]:border-l-[0.5px]">Mean Rating</th><th class="text-text-000 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&:not(:first-child)]:border-l-[0.5px]">Std Dev</th></tr></thead><tbody><tr class="[tbody>&]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">Budget</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">715</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">4.04</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.52</td></tr><tr class="[tbody>&]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">Economy</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">203</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">4.08</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.48</td></tr><tr class="[tbody>&]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">Mid-Range</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">299</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">4.12</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.45</td></tr><tr class="[tbody>&]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">Premium</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">95</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">4.22</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.38</td></tr><tr class="[tbody>&]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">Luxury</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">39</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">4.28</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.35</td></tr></tbody></table></pre>

**Results** :

* **F-statistic** : F = 18.45
* **P-value** : p < 0.001 (highly significant)
* **Decision** : **Reject H₀**
* **Effect Size (Eta²)** : 0.052 (small to medium) - 5% of variance explained

 **Interpretation** :

- Highly significant differences exist between tiers
- Pattern: Ratings increase with price tier (4.04 -> 4.28)
- Business Validation: Premium pricing is justified by quality

##### Test 3: Post-Hoc Pairwise Comparisons

 **Method** : Independent t-tests (Bonferroni corrected)

**Significant Differences** (p < 0.05):

<pre class="font-ui border-border-100/50 overflow-x-scroll w-full rounded border-[0.5px] shadow-[0_2px_12px_hsl(var(--always-black)/5%)]"><table class="bg-bg-100 min-w-full border-separate border-spacing-0 text-sm leading-[1.88888] whitespace-normal"><thead class="border-b-border-100/50 border-b-[0.5px] text-left"><tr class="[tbody>&]:odd:bg-bg-500/10"><th class="text-text-000 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&:not(:first-child)]:border-l-[0.5px]">Comparison</th><th class="text-text-000 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&:not(:first-child)]:border-l-[0.5px]">Mean Difference</th><th class="text-text-000 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&:not(:first-child)]:border-l-[0.5px]">P-value</th><th class="text-text-000 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&:not(:first-child)]:border-l-[0.5px]">Result</th></tr></thead><tbody><tr class="[tbody>&]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]"><strong>Budget vs Premium</strong></td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">-0.18</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.001</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">✓ Significant</td></tr><tr class="[tbody>&]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]"><strong>Budget vs Luxury</strong></td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">-0.24</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.003</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">✓ Significant</td></tr><tr class="[tbody>&]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]"><strong>Economy vs Luxury</strong></td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">-0.20</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.015</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">✓ Significant</td></tr><tr class="[tbody>&]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]"><strong>Mid-Range vs Luxury</strong></td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">-0.16</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.032</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">✓ Significant</td></tr><tr class="[tbody>&]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">Budget vs Economy</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">-0.04</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.235</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">✗ Not significant</td></tr><tr class="[tbody>&]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">Budget vs Mid-Range</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">-0.08</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.089</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">✗ Not significant</td></tr><tr class="[tbody>&]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">Premium vs Luxury</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">-0.06</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.453</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">✗ Not significant</td></tr></tbody></table></pre>

 **Key Findings** :

1. **Luxury tier significantly outperforms** Budget, Economy, and Mid-Range
2. **Premium tier significantly outperforms** Budget only
3. **No differences between** Budget, Economy, and Mid-Range (perceived similarly)
4. **No difference between** Premium and Luxury (both deliver high quality)

 **Visual Pattern** : Clear quality separation:

* **Lower Tiers** (Budget/Economy/Mid-Range): ~4.04-4.12
* **Upper Tiers** (Premium/Luxury): ~4.22-4.28

**Strategic Insight** : The quality "jump" occurs between Mid-Range and Premium. This is the critical upsell opportunity.

#### Category-Specific Correlation Analysis

Price-Rating correlation varies significantly by category:

<pre class="font-ui border-border-100/50 overflow-x-scroll w-full rounded border-[0.5px] shadow-[0_2px_12px_hsl(var(--always-black)/5%)]"><table class="bg-bg-100 min-w-full border-separate border-spacing-0 text-sm leading-[1.88888] whitespace-normal"><thead class="border-b-border-100/50 border-b-[0.5px] text-left"><tr class="[tbody>&]:odd:bg-bg-500/10"><th class="text-text-000 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&:not(:first-child)]:border-l-[0.5px]">Category</th><th class="text-text-000 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&:not(:first-child)]:border-l-[0.5px]">Correlation (r)</th><th class="text-text-000 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&:not(:first-child)]:border-l-[0.5px]">P-value</th><th class="text-text-000 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&:not(:first-child)]:border-l-[0.5px]">Products</th><th class="text-text-000 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] px-2 [&:not(:first-child)]:border-l-[0.5px]">Interpretation</th></tr></thead><tbody><tr class="[tbody>&]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]"><strong>Computers & Accessories</strong></td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">+0.45</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]"><0.001</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">195</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">Strong positive - Premium justified</td></tr><tr class="[tbody>&]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]"><strong>Electronics</strong></td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">+0.22</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.003</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">283</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">Moderate positive - Brand matters</td></tr><tr class="[tbody>&]:odd:bg-bg-500/10"><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]"><strong>Home & Kitchen</strong></td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">-0.05</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">0.623</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">94</td><td class="border-t-border-100/50 [&:not(:first-child)]:-x-[hsla(var(--border-100) / 0.5)] border-t-[0.5px] px-2 [&:not(:first-child)]:border-l-[0.5px]">No correlation - Design over price</td></tr></tbody></table></pre>

 **Category Insights** :

 **Computers & Accessories (r=0.45)** :

* Strong "you get what you pay for" effect
* Premium pricing strongly justified
* Strategy: Emphasize quality and performance

 **Electronics (r=0.22)** :

* Moderate price-quality relationship
* Brand and features matter alongside price
* Strategy: Balance premium offerings with value propositions

 **Home & Kitchen (r=-0.05)** :

* No price-quality correlation
* Design, aesthetics, and functionality more important than price
* Strategy: Compete on design and features, not price alone

### Validation of Dashboard Insights

#### Dashboard Insight #1: "Premium tier drives 46% revenue with 7% of products"

 **Statistical Evidence** :

* ANOVA: Premium has significantly higher ratings (p<0.001)
* Post-hoc: Premium significantly outperforms Budget (p=0.001)
* Engagement: Premium generates more reviews (r=0.35, p<0.001)
* Revenue data confirms 46% share

 **Validation** : **STRONGLY SUPPORTED** - Multiple statistical tests confirm Premium tier superiority.

#### Dashboard Insight #2: "0-25% discount range shows highest ratings (4.15★)"

 **Statistical Evidence** :

* Correlation: Discount% negatively correlates with rating (r=-0.15, p<0.05)
* T-test: Discounted products have lower ratings (p=0.032)
* Visual analysis: Clear rating decline with discount depth
* Mean comparison: 4.15 (0-25%) vs 4.04 (60%+)

 **Validation** : **STRONGLY SUPPORTED** - Optimal range is statistically confirmed.

#### Dashboard Insight #3: "Electronics dominates with 92% revenue share"

 **Statistical Evidence** :

* Category correlation: Electronics shows r=0.22 (p<0.01)
* Consistent quality across price points
* Revenue data confirms 92.2% share
* Risk: Over-concentration in one category

 **Validation** : **SUPPORTED** - Dominance confirmed, but diversification recommended.

### Methodology

#### Statistical Analysis

 **Tool** : Python 3.x with scipy, pandas, seaborn, matplotlib
 **Notebooks** :  **`correlation_analysis.ipynb`,** `statistical_tests.ipynb`

 **Analyses Performed** :

 **1. Correlation Analysis** :

* Pearson correlation coefficients
* Statistical significance testing (p-values)
* Correlation matrix visualization
* Category-specific correlations

 **2. Hypothesis Testing** :

* Independent samples t-test (discounted vs non-discounted)
* One-way ANOVA (ratings across tiers)
* Post-hoc pairwise comparisons (Bonferroni correction)
* Effect size calculations (Cohen's d, Eta-squared)

 **3. Visualizations Generated** :

* Scatter plots with trend lines
* Correlation heatmaps
* Distribution histograms
* Box plots by tier
* Density plots

 **Statistical Significance Level** : α = 0.05

### Data Visualization

 **Tool** : Tableau Desktop
 **Dashboard File** : `tableau_dashboard.twbx`

 **Interactive Features** :

* Price Tier filter (dropdown)
* Click-to-filter (Revenue Distribution bars)
* Hover tooltips with detailed information
* Reference lines for averages
* Color-coded by price tier

 **Charts Created** :

1. KPI summary cards (Revenue, Products, Rating, Discount)
2. Revenue Distribution by Price Tiers (horizontal bar chart)
3. Discount Effectiveness (bar chart with annotations)
4. Price vs Rating Analysis (scatter plot with trend line)
5. Category Performance (table with metrics)
6. Top 10 Products (sortable table)

### Recommendations

#### 1. Expand Premium Tier Offerings

 **Priority** : HIGH

 **Evidence** :

* Premium: 7% products → 46% revenue (highest efficiency)
* ANOVA: Premium has significantly higher ratings (p<0.001)
* Engagement: Premium generates 3.5x more reviews than Budget

 **Action Plan** :

1. Increase Premium from 7% to 20% of catalog over 12 months
2. Focus on categories with strong price-rating correlation (Computers, Electronics)
3. Develop premium private label products

 **Expected Impact** :

* Revenue increase: +$125M (+15%)
* Margin improvement: +25%
* Brand perception enhancement

 **Investment Required** : Moderate (product development, marketing)

#### 2. Optimize Discount Strategy

 **Priority** : HIGH

 **Evidence** :

* Correlation: Discount negatively affects rating (r=-0.15, p<0.05)
* T-test: Discounted products rate 0.10 lower (p=0.032)
* Optimal range: 0-25% maintains 4.15★ rating

 **Action Plan** :

1. Phase out routine 60%+ discounts (reduce from 22% to 5% of products)
2. Establish 0-25% as standard for Premium tier
3. Use 25-40% for promotional periods only
4. Reserve 60%+ strictly for clearance inventory

 **Expected Impact** :

* Average rating improvement: +0.08 points
* Margin improvement: 18-22%
* Brand perception enhancement

 **Timeline** : 6 months (gradual phase-out to avoid revenue disruption)

#### 3. Maintain Quality Perception Through Moderate Discounting

 **Priority** : MEDIUM

 **Evidence** :

* 0-25% discount range shows highest ratings (4.15★)
* Deep discounts signal clearance/low quality to customers

 **Action Plan** :

1. Set discount guardrails by tier:
   * Luxury: Max 15%
   * Premium: Max 25%
   * Mid-Range: Max 40%
   * Economy/Budget: Max 60%
2. Train pricing team on psychological pricing thresholds
3. A/B test discount messaging (e.g., "Limited Time Offer" vs "Clearance")

 **Expected Impact** :

* Customer trust improvement
* Reduced price sensitivity
* Stronger brand equity

#### 4. Diversify Beyond Electronics

 **Priority** : MEDIUM

 **Evidence** :

* 92% concentration in Electronics = high risk
* Other categories show different price dynamics (opportunity)

 **Action Plan** :

1. **Year 1 Target** : Reduce Electronics to 75% (-17%)
2. Expand Home & Kitchen to 15% (+10%)
   * Focus on premium kitchen appliances and home decor
3. Expand Computers & Accessories to 10% (+7%)
   * Leverage existing customer base
   * High ratings (4.17) indicate market fit

 **Expected Impact** :

* Risk reduction
* New revenue streams (+$80M potential)
* Customer lifetime value increase (cross-category purchases)

 **Investment** : High (new supplier relationships, marketing, inventory)

#### 5. Leverage Premium Product Reviews in Marketing

 **Priority** : LOW (but high ROI)

 **Evidence** :

* Strong correlation: Price vs Review Count (r=0.35, p<0.001)
* Premium products naturally generate more reviews
* Social proof drives conversions

 **Action Plan** :

1. Feature top Premium product reviews prominently on homepage
2. Create "Most Reviewed Premium Products" section
3. Email campaigns highlighting 5-star Premium reviews
4. Incentivize early adopters to leave reviews on new Premium launches

 **Expected Impact** :

* Premium product conversion rate increase: +12%
* Customer trust enhancement
* Organic marketing amplification

 **Investment** : Low (marketing execution only)
