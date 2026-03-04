--====================================================================================================================
-- 🏦 Credit Risk Analysis and Loan Default Insights
--
-- Business Problem:
-- Lenders need to identify borrower segments with higher probabilities of loan default
-- to reduce credit risk and improve lending decisions.
--
-- Objective:
-- Analyze borrower demographics and loan attributes to identify patterns associated with loan defaults.
--
-- Database: CreditRiskDB
-- Dataset: credit_risk
-- Total No. of Records: 32581
-- Total No. of columns: 12
--====================================================================================================================



--====================================================================================================================
-- Database Setup
--====================================================================================================================

-- Switch to the working database
USE CreditRiskDB;



--====================================================================================================================
-- Initial Data Validation
--====================================================================================================================

-- Preview dataset to verify successful import
SELECT * FROM credit_risk;

-- Confirm total number of records
SELECT COUNT(*) AS total_records FROM credit_risk;



--====================================================================================================================
-- Data Preparation
--====================================================================================================================

-- Convert FLOAT columns to DECIMAL for improved numeric precision
ALTER TABLE credit_risk
ALTER COLUMN loan_int_rate DECIMAL(5,2);

ALTER TABLE credit_risk
ALTER COLUMN loan_percent_income DECIMAL(5,2);



--====================================================================================================================
-- Data Quality Checks
--====================================================================================================================

-- Remove unrealistic borrower ages
DELETE FROM credit_risk
WHERE person_age < 18 OR person_age > 100;

-- Remove unrealistic employment lengths
DELETE FROM credit_risk
WHERE person_emp_length > 60;



--====================================================================================================================
-- Missing Value Analysis
--====================================================================================================================

SELECT
    SUM(CASE WHEN loan_amnt IS NULL THEN 1 ELSE 0 END) AS missing_loan_amount,
    SUM(CASE WHEN person_emp_length IS NULL THEN 1 ELSE 0 END) AS missing_employment_length,
    SUM(CASE WHEN loan_int_rate IS NULL THEN 1 ELSE 0 END) AS missing_interest_rate,
    SUM(CASE WHEN loan_percent_income IS NULL THEN 1 ELSE 0 END) AS missing_income_ratio
FROM credit_risk;



--====================================================================================================================
-- Missing Value Imputation
--====================================================================================================================

-- Median imputation for employment length
UPDATE credit_risk
SET person_emp_length = t.median_value
FROM (
    SELECT DISTINCT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY person_emp_length) OVER () AS median_value
    FROM credit_risk
    WHERE person_emp_length IS NOT NULL
) t
WHERE person_emp_length IS NULL;


-- Median imputation for interest rate
UPDATE credit_risk
SET loan_int_rate = t.median_value
FROM (
    SELECT DISTINCT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY loan_int_rate) OVER () AS median_value
    FROM credit_risk
    WHERE loan_int_rate IS NOT NULL
) t
WHERE loan_int_rate IS NULL;


-- Note:
-- Approximately 2.7% of employment length values and 9.6% of interest
-- rate values were missing. Median imputation preserves the distribution
-- and reduces the influence of extreme values.



--====================================================================================================================
-- Missing Data Imputation Verification
--====================================================================================================================

SELECT
    SUM(CASE WHEN person_emp_length IS NULL THEN 1 ELSE 0 END) AS remaining_missing_employment,
    SUM(CASE WHEN loan_int_rate IS NULL THEN 1 ELSE 0 END) AS remaining_missing_interest_rate
FROM credit_risk;



--====================================================================================================================
-- 1. Overall Default Rate
--====================================================================================================================

SELECT
    COUNT(*) AS total_loans,
    SUM(CAST(loan_status AS INT)) AS total_defaults,
    CAST(ROUND(SUM(CAST(loan_status AS INT)) * 100.0 / COUNT(*), 2)AS DECIMAL(5,2)) AS default_rate_percent
FROM credit_risk;



--====================================================================================================================
-- 2. Default Risk by Home Ownership
--====================================================================================================================

SELECT
    person_home_ownership,
    COUNT(*) AS total_loans,
    SUM(CAST(loan_status AS INT)) AS total_defaults,
    CAST(ROUND(SUM(CAST(loan_status AS INT)) * 100.0 / COUNT(*), 2)AS DECIMAL(5,2)) AS default_rate_percent
FROM credit_risk
GROUP BY person_home_ownership
ORDER BY default_rate_percent DESC;



--====================================================================================================================
-- 3. Default Risk by Loan Purpose
--====================================================================================================================

SELECT
    loan_intent AS loan_purpose,
    COUNT(*) AS total_loans,
    SUM(CAST(loan_status AS INT)) AS total_defaults,
    CAST(ROUND(SUM(CAST(loan_status AS INT)) * 100.0 / COUNT(*), 2)AS DECIMAL(5,2)) AS default_rate_percent
FROM credit_risk
GROUP BY loan_intent
ORDER BY default_rate_percent DESC;



--====================================================================================================================
-- 4. Default Risk by Loan Grade
--====================================================================================================================

SELECT
    loan_grade,
    COUNT(*) AS total_loans,
    SUM(CAST(loan_status AS INT)) AS total_defaults,
    CAST(ROUND(SUM(CAST(loan_status AS INT)) * 100.0 / COUNT(*), 2)AS DECIMAL(5,2)) AS default_rate_percent
FROM credit_risk
GROUP BY loan_grade
ORDER BY default_rate_percent DESC;



--====================================================================================================================
-- 5. Default Risk by Employment Length
--====================================================================================================================

--------------------------------------------------------------------------------
-- Employment Length Validation (Pre-Segmentation Check)                        
-- Verifying minimum and maximum employment duration before creating segments   
--------------------------------------------------------------------------------
SELECT
    MIN(person_emp_length) AS min_employment_length,
    MAX(person_emp_length) AS max_employment_length
FROM credit_risk;
--------------------------------------------------------------------------------

SELECT
    employment_length_segment,
    COUNT(*) AS total_loans,
    SUM(CAST(loan_status AS INT)) AS total_defaults,
    CAST(ROUND(SUM(CAST(loan_status AS INT)) * 100.0 / COUNT(*), 2)AS DECIMAL(5,2)) AS default_rate_percent
FROM (
    SELECT
        loan_status,
        CASE
            WHEN person_emp_length < 2 THEN 'Very New (<2)'
            WHEN person_emp_length BETWEEN 2 AND 5 THEN 'Early Career (2–5)'
            WHEN person_emp_length BETWEEN 6 AND 10 THEN 'Experienced (6–10)'
            ELSE 'Highly Experienced (10+)'
        END AS employment_length_segment
    FROM credit_risk
) t
GROUP BY employment_length_segment
ORDER BY default_rate_percent DESC;

-- Notes:
-- Employment length is segmented into Very New (<2), Early Career (2–5),
-- Experienced (6–10), and Highly Experienced (10+) stages to reflect increasing job stability.


--====================================================================================================================
-- 6. Default Risk by Income Segment
--====================================================================================================================

---------------------------------------------------------------------------------------
--              Income Distribution Summary Statistics
---------------------------------------------------------------------------------------
SELECT DISTINCT
    MIN(person_income) OVER () AS min_income,
    MAX(person_income) OVER () AS max_income,
    AVG(person_income) OVER () AS avg_income,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY person_income) OVER () AS median_income
FROM credit_risk;
---------------------------------------------------------------------------------------


WITH income_groups AS (
    SELECT *,
    NTILE(3) OVER (ORDER BY person_income) AS income_segment
    FROM credit_risk
)
SELECT
    income_segment,
    MIN(person_income) AS min_income_in_group,
    MAX(person_income) AS max_income_in_group,
    COUNT(*) AS total_loans,
    SUM(CAST(loan_status AS INT)) AS total_defaults,
    CAST(ROUND(SUM(CAST(loan_status AS INT)) * 100.0 / COUNT(*), 2)AS DECIMAL(5,2)) AS default_rate_percent
FROM income_groups
GROUP BY income_segment
ORDER BY income_segment;

-- Note:
-- NTILE is used to create balanced income segments for risk comparison.
-- The income distribution of dataset is right-skewed due to high-income outliers (Mean > Median > Mode)


--====================================================================================================================
-- 7. Default Risk by Age Group Segment
--====================================================================================================================

-------------------------------------------------------------------------------
-- Age Range Validation (Pre-Segmentation Check)
-- Verifying minimum and maximum borrower age before creating age groups
-------------------------------------------------------------------------------
SELECT
    MIN( person_age ) AS min_age,
    MAX( person_age ) AS max_age
FROM credit_risk
-------------------------------------------------------------------------------

SELECT
    age_group,
    COUNT(*) AS total_loans,
    SUM(CAST(loan_status AS INT)) AS total_defaults,
    CAST(ROUND(SUM(CAST(loan_status AS INT)) * 100.0 / COUNT(*), 2)AS DECIMAL(5,2)) AS default_rate_percent
FROM (
    SELECT
    loan_status,
        CASE
            WHEN person_age BETWEEN 18 AND 24 THEN 'Youth (18-24)'
            WHEN person_age BETWEEN 25 AND 34 THEN 'Young Professionals (25-34)'
            WHEN person_age BETWEEN 35 AND 44 THEN 'Family Builders (35-44)'
            WHEN person_age BETWEEN 45 AND 54 THEN 'Peak Earners (45-54)'
            WHEN person_age BETWEEN 55 AND 60 THEN 'Pre-Retirement (55-60)'
            ELSE 'Seniors (above 60)'
        END AS age_group
    FROM credit_risk
) t
GROUP BY age_group
ORDER BY default_rate_percent DESC;

-- Note:
-- Age groups were defined based on typical career and income life stages
-- to analyze how default risk varies across different borrower age segments.


--====================================================================================================================
-- 8. Default Risk by Loan Burden (Loan-to-Income Ratio)
--====================================================================================================================

SELECT
    [burden_category (loan_to_income_ratio)],
    COUNT(*) AS total_loans,
    SUM(CAST(loan_status AS INT)) AS total_defaults,
    CAST(ROUND(SUM(CAST(loan_status AS INT)) * 100.0 / COUNT(*), 2)AS DECIMAL(5,2)) AS default_rate_percent
FROM (
    SELECT
    loan_status,
        CASE
            WHEN loan_percent_income < 0.2 THEN 'Low Burden (< 0.2)'
            WHEN loan_percent_income BETWEEN 0.2 AND 0.4 THEN 'Medium Burden (0.2-0.4)'
            ELSE 'High Burden (above 0.4)'
        END AS [burden_category (loan_to_income_ratio)]
    FROM credit_risk
) t
GROUP BY [burden_category (loan_to_income_ratio)]
ORDER BY default_rate_percent DESC;

-- Note:
-- The burden groups were defined based on commonly used financial risk thresholds, where higher loan-to-income ratios
-- indicate greater repayment pressure and increased default risk.



--====================================================================================================================
-- 9. Default Risk by Interest Rate Segment
--====================================================================================================================

---------------------------------------------------------------------------------------
--        Interest Rate Distribution
---------------------------------------------------------------------------------------
SELECT DISTINCT
    MIN(loan_int_rate) OVER () AS min_rate,
    MAX(loan_int_rate) OVER () AS max_rate,
    AVG(loan_int_rate) OVER () AS avg_rate,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY loan_int_rate) OVER () AS median_rate
FROM credit_risk;
---------------------------------------------------------------------------------------


SELECT
    interest_rate_segment,
    COUNT(*) AS total_loans,
    SUM(CAST(loan_status AS INT)) AS total_defaults,
    CAST(ROUND(SUM(CAST(loan_status AS INT)) * 100.0 / COUNT(*), 2)AS DECIMAL(5,2)) AS default_rate_percent
FROM (
    SELECT
    loan_status,
        CASE
            WHEN loan_int_rate < 10 THEN 'Low Interest (< 10)'
            WHEN loan_int_rate BETWEEN 10 AND 15 THEN 'Medium Interest (10-15)'
            ELSE 'High Interest (above 15)'
        END AS interest_rate_segment
    FROM credit_risk
) t
GROUP BY interest_rate_segment
ORDER BY default_rate_percent DESC;

-- Note:
-- Based on the Interest Rate Distribution, the categories were created to segment loans into lower, medium
-- and higher Interest tiers for clearer comparison.

--====================================================================================================================
-- 10. Previous Default History Impact
--====================================================================================================================

SELECT
    CASE
        WHEN cb_person_default_on_file = 1 THEN 'Yes'
        ELSE 'No'
    END AS previous_default_status,
    COUNT(*) AS total_loans,
    SUM(CAST(loan_status AS INT)) AS total_defaults,
    CAST(ROUND(SUM(CAST(loan_status AS INT)) * 100.0 / COUNT(*), 2)AS DECIMAL(5,2)) AS default_rate_percent
FROM credit_risk
GROUP BY cb_person_default_on_file
ORDER BY default_rate_percent DESC;



--====================================================================================================================
-- 11. Multi-Segment Borrower Risk Analysis
--====================================================================================================================

SELECT
    age_group,
    burden_category,
    interest_category,
    COUNT(*) AS total_loans,
    SUM(CAST(loan_status AS INT)) AS total_defaults,
   CAST(ROUND(SUM(CAST(loan_status AS INT)) * 100.0 / COUNT(*), 2)AS DECIMAL(5,2)) AS default_rate_percent
FROM (
    SELECT
    loan_status,
        CASE
            WHEN person_age BETWEEN 18 AND 24 THEN 'Youth'
            WHEN person_age BETWEEN 25 AND 34 THEN 'Young Professionals'
            WHEN person_age BETWEEN 35 AND 44 THEN 'Family Builders'
            WHEN person_age BETWEEN 45 AND 54 THEN 'Peak Earners'
            WHEN person_age BETWEEN 55 AND 60 THEN 'Pre-Retirement'
            ELSE 'Seniors'
        END AS age_group,

        CASE
            WHEN loan_percent_income < 0.2 THEN 'Low Burden'
            WHEN loan_percent_income BETWEEN 0.2 AND 0.4 THEN 'Medium Burden'
            ELSE 'High Burden'
        END AS burden_category,

        CASE
            WHEN loan_int_rate < 10 THEN 'Low Interest'
            WHEN loan_int_rate BETWEEN 10 AND 15 THEN 'Medium Interest'
            ELSE 'High Interest'
        END AS interest_category

    FROM credit_risk
) t
GROUP BY
    age_group,
    burden_category,
    interest_category
HAVING COUNT(*) >= 50
ORDER BY default_rate_percent DESC;


-- Notes:
-- HAVING COUNT(*) >= 50 removes very small borrower segments.
-- Small groups can produce unstable default rates and misleading insights.

--======================================================================================================================