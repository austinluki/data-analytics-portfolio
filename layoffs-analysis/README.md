# Layoffs Data Cleaning and Exploration

I cleaned a company layoffs dataset in MySQL, then wrote queries to explore it. The raw data had duplicates, inconsistent names, dates stored as text and blank values, so I went through each problem step by step before doing any analysis.

## Dataset

The raw table has 2,361 rows and 9 columns: company, location, industry, total laid off, percentage laid off, date, stage, country and funds raised (in millions). Each row is one layoff event. The dates run from 11 March 2020 to 6 March 2023.

## Tools

MySQL and DBeaver.

## Data cleaning

I kept the raw table as it was and worked on copies (`layoffs_staging` and `layoffs_staging2`), so I could always go back to the original.

1. **Removed duplicates.** I used `ROW_NUMBER() OVER (PARTITION BY ...)` in a CTE to find rows that repeat on company, industry, total laid off, percentage laid off, date, stage, country and funds raised. That found 5 duplicates. MySQL can't delete straight from a CTE, so I made a second staging table with a `row_num` column and deleted from that.
2. **Standardized the data.**
   - Trimmed the extra spaces in company names.
   - The same industry was written 3 different ways (`Crypto`, `Crypto Currency` and `CryptoCurrency`), so I changed them all to `Crypto`.
   - Some countries were written as `United States.` with a full stop at the end, so I fixed them with `TRIM(TRAILING '.' FROM country)`.
   - The date column was text, so I converted it with `STR_TO_DATE` and changed the column type to `DATE`.
3. **Handled null and blank values.** I turned blank industries into nulls, then filled them in by self joining the table on company, since the same company usually appears in other rows with the industry filled in. 3 of the 4 missing industries could be filled this way. 1 company (Bally's Interactive) has no other row, so it stays null.
4. **Removed rows and columns I don't need.** 361 rows had nothing in both `total_laid_off` and `percentage_laid_off`, so they can't be used for the analysis, and I deleted them. Then I dropped the `row_num` column. The cleaned table has 1,995 rows.

## Exploratory analysis

- Max laid off in one go and highest percentage
- Companies that laid off 100% of their staff, sorted by how much funding they raised
- Total laid off by company, country, year and funding stage
- A rolling total of layoffs by month, using a CTE and `SUM() OVER`
- The top 5 companies with the most layoffs for each year, using two CTEs and `DENSE_RANK()`

## What I found

- Between March 2020 and March 2023, the cleaned data shows 383,659 people laid off.
- The biggest layoffs by company were Amazon (18,150), Google (12,000), Meta (11,000), Salesforce (10,090) and Microsoft (10,000).
- The United States is far ahead at 256,559 people, followed by India (35,993), the Netherlands (17,220), Sweden (11,264) and Brazil (10,391).
- By year: 80,998 in 2020, 15,823 in 2021, 160,661 in 2022, and 125,677 in 2023 (which only covers January to early March).
- Post-IPO companies had the most layoffs by funding stage, at 204,132 people.
- 116 companies laid off 100% of their staff. Britishvolt (about $2.4 billion raised) and Katerra (about $1.6 billion raised) are among the biggest.

## Files

- `data_cleaning.sql`: all my cleaning queries
- `exploratory_data_analysis.sql`: all my exploration queries
- `layoffs.csv`: the raw data

## Notes

Total laid off is blank for a lot of rows, so the totals above only count the layoffs that were actually reported. The 2023 numbers only cover the first few months of the year, so they can't be compared directly with the full years before it. The cleaning script makes changes to the staging tables, so the raw `layoffs` table stays untouched.
