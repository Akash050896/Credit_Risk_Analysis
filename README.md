
# 🏦 Credit Risk Analysis and Loan Default Insights

![MS SQL Server](https://img.shields.io/badge/MS%20SQL%20Server-Analysis-blue?logo=microsoft&logoColor=white)
![Domain](https://img.shields.io/badge/Domain-Finance%20Analytics-green)
---

## 📌 Project Overview

The **Credit Risk Analysis and Loan Default Insights Project** analyzes borrower demographics and loan attributes to identify patterns associated with **loan default risk**.

Using SQL-based analysis on **32,000+ loan records**, the project explores how factors such as income, employment stability, loan burden, and credit history influence the likelihood of default.

The insights generated from this analysis help lenders identify **high-risk borrower segments** and support more informed lending decisions.

---
# 📑 Table of Contents

## 📌 Project Overview
- [Project Overview](#-project-overview)

## 🎯 Business Understanding
- [Business Problem](#-business-problem)
- [Project Objectives](#-project-objectives)
- [Project Highlights](#-project-highlights)

## 📊 Data Preparation & Analysis
- [Dataset Information](#-dataset-information)
- [Data Preparation](#-data-preparation)
- [Analysis Performed](#-analysis-performed)

## 📊 Query Results & Insights
- [Query Output, Insights & Recommended Actions](#-query-output-insights--recommended-actions)
- [Key Insights](#-key-insights)

## 🧾 Conclusion
- [Conclusion](#-conclusion)

## 🛠 Technical Details
- [Tools & Technologies](#️-tools--technologies)
- [How to Load the Dataset](#-how-to-load-the-dataset)
- [Project Repository Structure](#-project-repository-structure)

## 👤 Author
- [Author](#-author)
---


## 🎯 Business Problem

Financial institutions must answer an important question:

**How can lenders identify borrowers who are more likely to default before approving loans?**

Without proper risk analysis, lenders may face:

- Increased financial losses
- Higher loan default rates
- Poor portfolio performance

---

## 🎯 Project Objectives

- Identify borrower segments with higher default risk
- Analyze borrower characteristics influencing defaults
- Understand how loan burden and interest rates affect repayment
- Generate insights that support better lending decisions

---

## ⭐ Project Highlights

- Analyzed **32,000+ loan records** to identify credit risk patterns
- Applied **SQL window functions and segmentation techniques**
- Identified **high-risk borrower segments** across multiple dimensions
- Generated **business recommendations to improve lending decisions**

---

## 📊 Dataset Information

**Database:** `CreditRiskDB`  
**Table:** `credit_risk`

| Column Name | Description |
|:------------|:-------------|
| person_age | Age of borrower |
| person_income | Annual income |
| person_home_ownership | Housing status |
| person_emp_length | Employment duration |
| loan_intent | Loan purpose |
| loan_grade | Credit risk grade |
| loan_amnt | Loan amount |
| loan_int_rate | Interest rate |
| loan_status | Loan outcome |
| loan_percent_income | Loan-to-income ratio |
| cb_person_default_on_file | Previous default history |
| cb_person_cred_hist_length | Credit history length |

**Total Records:** 32,581  
**Total Columns:** 12

---

## 🧹 Data Preparation

### Data Cleaning
- Removed unrealistic borrower ages (<18 or >100)
- Removed unrealistic employment lengths (>60 years)

### Data Type Optimization
Converted floating-point columns to **DECIMAL** for improved numeric precision.

### Missing Value Handling
Median imputation applied to:

- Employment Length
- Interest Rate

Median imputation preserves the distribution while minimizing the influence of extreme values.

---

## 🧭 Analysis Performed

1. Overall Default Rate
2. Default Risk by Home Ownership
3. Default Risk by Loan Purpose
4. Default Risk by Loan Grade
5. Default Risk by Employment Length
6. Default Risk by Income Segment
7. Default Risk by Age Group
8. Default Risk by Loan Burden
9. Default Risk by Interest Rate
10. Previous Default History Impact
11. Multi-Segment Borrower Risk Analysis

---

# 📊 Query Output, Insights & Recommended Actions

---

### 1️⃣ Overall Default Rate

📊 **Query Output**

| Metric | Value |
|:------|------:|
| Total Loans | 32,574 |
| Total Defaults | 7,107 |
| Default Rate (%) | 21.82 |

📌 **Query Insights**

About **1 in 5 borrowers default**, indicating relatively high portfolio risk.

💡 **Recommended Actions**

• Review loan approval criteria to reduce approvals for high-risk borrowers.  
• Monitor borrower segments contributing most to defaults.

---

### 2️⃣ Default Risk by Home Ownership

📊 **Query Output**

| Home Ownership | Total Loans | Total Defaults | Default Rate (%) |
|:---------------|------------:|---------------:|-----------------:|
| Rent | 16,297 | 5,148 | 31.57 |
| Other | 98 | 30 | 30.84 |
| Mortgage | 13,341 | 1,676 | 12.57 |
| Own | 2,838 | 212 | 7.47 |

📌 **Query Insights**

Renters show significantly higher default rates compared to borrowers with stable housing.

💡 **Recommended Actions**

• Include housing status as a factor when evaluating borrower risk.  
• Apply additional income checks for renter applicants.

---

### 3️⃣ Default Risk by Loan Purpose

📊 **Query Output**

| Loan Purpose | Total Loans | Total Defaults | Default Rate (%) |
|:-------------|------------:|---------------:|-----------------:|
| Debt Consolidation | 5,208 | 1,488 | 28.59 |
| Medical | 1,574 | 420 | 26.70 |
| Home Improvement | 3,309 | 864 | 26.10 |
| Personal | 5,472 | 1,360 | 24.86 |
| Venture | 3,130 | 464 | 14.82 |
| Education | 3,338 | 575 | 17.22 |

📌 **Query Insights**

Loans taken for urgent financial needs such as **debt consolidation or medical expenses** show higher default risk.

💡 **Recommended Actions**

• Conduct additional financial checks for debt consolidation loans.  
• Review approval conditions for higher-risk loan purposes.

---

### 4️⃣ Default Risk by Loan Grade

📊 **Query Output**

| Loan Grade | Total Loans | Total Defaults | Default Rate (%) |
|:-----------|------------:|---------------:|-----------------:|
| A | 9,641 | 960 | 9.96 |
| B | 8,567 | 1,394 | 16.28 |
| C | 5,611 | 1,164 | 20.74 |
| D | 3,045 | 1,797 | 59.03 |
| E | 2,437 | 1,571 | 64.42 |
| F | 2,125 | 1,498 | 70.54 |
| G | 1,148 | 1,130 | 98.44 |

📌 **Query Insights**

Default risk increases sharply as credit grade declines.

💡 **Recommended Actions**

• Prioritize lending to borrowers with higher credit grades.  
• Apply stricter approval checks for lower credit grades.

---

### 5️⃣ Default Risk by Employment Length

📊 **Query Output**

| Employment Segment | Total Loans | Total Defaults | Default Rate (%) |
|:------------------|------------:|---------------:|-----------------:|
| Very New (<2) | 5,284 | 1,470 | 27.82 |
| Early Career (2–5) | 10,321 | 2,298 | 22.28 |
| Experienced (6–10) | 9,674 | 1,747 | 18.07 |
| Highly Experienced (10+) | 7,295 | 1,184 | 16.23 |

📌 **Query Insights**

Borrowers with longer employment history tend to have lower default risk.

💡 **Recommended Actions**

• Consider employment stability when evaluating loan applications.  
• Apply additional verification for borrowers with shorter job tenure.

---

### 6️⃣ Default Risk by Income Segment

📊 **Query Output**

| Income Segment | Total Loans | Total Defaults | Default Rate (%) |
|:---------------|------------:|---------------:|-----------------:|
| Low Income | 10,860 | 3,913 | 36.05 |
| Middle Income | 10,861 | 2,016 | 18.57 |
| High Income | 10,860 | 1,178 | 10.84 |

📌 **Query Insights**

Default risk declines significantly as borrower income increases.

💡 **Recommended Actions**

• Align loan sizes with borrower income levels.  
• Apply stricter loan-to-income checks for lower income borrowers.

---

### 7️⃣ Default Risk by Age Group

📊 **Query Output**

| Age Group | Total Loans | Total Defaults | Default Rate (%) |
|:----------|------------:|---------------:|-----------------:|
| Youth (18–24) | 4,892 | 1,137 | 23.22 |
| Young Professionals (25–34) | 10,281 | 2,125 | 20.67 |
| Family Builders (35–44) | 7,822 | 1,321 | 16.89 |
| Peak Earners (45–54) | 5,914 | 1,071 | 18.11 |
| Pre-Retirement (55–60) | 2,143 | 530 | 24.72 |
| Seniors (60+) | 1,522 | 398 | 26.15 |

📌 **Query Insights**

Younger borrowers and those nearing retirement show relatively higher default risk.

💡 **Recommended Actions**

• Carefully review financial stability for younger applicants.  
• Assess repayment capacity for borrowers approaching retirement.

---

### 8️⃣ Default Risk by Loan Burden

📊 **Query Output**

| Loan Burden | Total Loans | Total Defaults | Default Rate (%) |
|:------------|------------:|---------------:|-----------------:|
| Low (<0.2) | 16,282 | 2,183 | 13.41 |
| Medium (0.2–0.4) | 11,298 | 3,847 | 34.05 |
| High (>0.4) | 4,994 | 3,707 | 74.17 |

📌 **Query Insights**

Higher loan-to-income ratios significantly increase default risk.

💡 **Recommended Actions**

• Set limits on acceptable loan-to-income ratios.  
• Reduce loan sizes when borrower debt burden is high.

---

### 9️⃣ Default Risk by Interest Rate

📊 **Query Output**

| Interest Rate Segment | Total Loans | Total Defaults | Default Rate (%) |
|:---------------------|------------:|---------------:|-----------------:|
| Low (<10%) | 10,624 | 1,148 | 10.80 |
| Medium (10–15%) | 13,089 | 2,868 | 21.94 |
| High (>15%) | 8,861 | 5,140 | 57.99 |

📌 **Query Insights**

Loans with higher interest rates are associated with higher default risk.

💡 **Recommended Actions**

• Monitor high-interest loans more closely.  
• Ensure borrower income supports loan repayment.

---

### 🔟 Previous Default History Impact

📊 **Query Output**

| Previous Default | Total Loans | Total Defaults | Default Rate (%) |
|:----------------|------------:|---------------:|-----------------:|
| Yes | 5,874 | 2,220 | 37.80 |
| No | 26,700 | 4,887 | 18.40 |

📌 **Query Insights**

Borrowers with previous defaults show nearly **double the default rate**.

💡 **Recommended Actions**

• Consider past defaults during credit evaluation.  
• Apply stricter approval checks for borrowers with negative credit history.

---

### 1️⃣1️⃣ Multi-Segment Borrower Risk Analysis

📊 **Query Output**

| Age Group | Burden Category | Interest Category | Total Loans | Total Defaults | Default Rate (%) |
|:----------|:---------------|:-----------------|------------:|---------------:|-----------------:|
| Youth | High Burden | High Interest | 58 | 54 | 93.10 |
| Young Professionals | High Burden | High Interest | 143 | 127 | 88.81 |
| Family Builders | Low Burden | Low Interest | 221 | 8 | 3.62 |

📌 **Query Insights**

Default risk increases significantly when multiple risk factors occur together.

💡 **Recommended Actions**

• Evaluate borrower risk using multiple factors together.  
• Avoid approving loans where several high-risk indicators appear simultaneously.

---

## 🔎 Key Insights

• Loan burden is the **strongest indicator of default risk**.  
• Credit grade strongly predicts borrower risk.  
• Previous default history significantly increases default probability.  
• Income stability and employment duration reduce default risk.  
• Certain loan purposes show higher default risk.

---
## 🧾 Conclusion

This analysis examined loan default patterns across borrower characteristics including **income levels, employment stability, credit grades, loan burden, and previous credit history**.

The results indicate that borrowers with **higher loan-to-income ratios, lower credit grades, prior default history, lower income levels, and shorter employment history** show significantly higher default rates. Additionally, **borrowers who rent rather than own homes tend to exhibit greater default risk**.

These findings highlight the importance of evaluating borrower financial stability and repayment burden when assessing credit risk. Incorporating these indicators into lending decisions can help financial institutions **improve risk assessment and make more informed loan approval decisions**.

---
## 🛠️ Tools & Technologies

### 🗄️ Database
- **Microsoft SQL Server** — Database system used to store and manage loan records

### 💻 Query & Analysis Environment
- **SQL Server Management Studio (SSMS)** — Writing and executing SQL queries for data analysis

### 📊 Data Analysis
- **SQL (Structured Query Language)** — Data querying, aggregation, segmentation, and risk analysis

### 🗂️ Repository Management
- **GitHub** — Project version control and repository management

---

## 📥 How to Load the Dataset

1. Create the database

```sql
CREATE DATABASE CreditRiskDB;
USE CreditRiskDB;
```

2. Import the dataset using **Import Flat File** in SQL Server.

3. Verify the data

```sql
SELECT TOP 10 *
FROM credit_risk;
```

---

## 📂 Project Repository Structure

```plaintext
Credit_Risk_Analysis
│
├── SQL
│   └── credit_risk_analysis.sql
│
├── Dataset
│   └── credit_risk_dataset.csv
│
├── Query Results
│   └── screenshots_of_query_outputs
│
└── README.md
```

---

## 👤 Author

**Akash Kindre**

Aspiring Data Analyst with hands-on experience in **Power BI, SQL, Excel & Python** specializing in **data visualization, KPI reporting, and dashboard development**. Skilled in **data cleaning, data modeling, and business performance analysis**, with a strong focus on transforming raw data into actionable insights to support data-driven decision-making.