
# Nashville Housing Data Cleaning

I cleaned a Nashville housing sales dataset in SQL Server. The raw data had dates with a time attached, missing addresses, several values packed into one column and labels that didn't match, so I went through each problem one by one to get the data ready for analysis.

## Dataset

56,477 rows and 19 columns of property sales from 2 January 2013 to 13 December 2019. Each row is one sale, with the parcel ID, address, sale date and price, legal reference, land use, owner details, and property info like acreage, year built, bedrooms and bathrooms.

## Tools

Microsoft SQL Server and Excel.

## Cleaning steps

1. **Fixed the sale date.** The sale date had a time attached to it. I converted it to a plain date in a new column with `CONVERT`.
2. **Filled in missing property addresses.** 29 rows had no address. The same parcel ID shows up in several sales, so I joined the table to itself on `ParcelID` (with a different `UniqueID`) and used `ISNULL` to copy the address across. All 29 got filled this way.
3. **Split the property address.** The street and city were in one column. I separated them with `SUBSTRING` and `CHARINDEX`.
4. **Split the owner address.** The street, city and state were all in one column. I split them into three columns with `PARSENAME` and `REPLACE`.
5. **Fixed "Sold as Vacant".** The column had `Y`, `N`, `Yes` and `No` mixed together. A `CASE` statement changed 52 `Y` and 399 `N` values to `Yes` and `No`, so now there are only two values.
6. **Found duplicate rows.** I used a CTE with `ROW_NUMBER() OVER (PARTITION BY ...)` on parcel ID, address, sale price, sale date and legal reference. It found 104 duplicate sales.
7. **Dropped columns I don't need.** I removed the old owner address, tax district, property address and sale date columns, since the cleaned columns replace them.

## SQL I used

`CONVERT`, `ALTER TABLE`, `UPDATE`, self joins, `ISNULL`, `SUBSTRING`, `CHARINDEX`, `PARSENAME`, `REPLACE`, `CASE`, CTEs and window functions (`ROW_NUMBER`).

## What I found

- The data has 56,477 rows before cleaning, with sales from 2013 to 2019.
- All 29 missing property addresses could be recovered from other sales of the same parcel.
- 104 sales were exact duplicates on those five fields.
- Owner details are missing for about 54% of the rows (30,462 of 56,477). The owner address, acreage, tax district and land and building values are all missing for the same rows, so I couldn't fill them in from other columns.

## Files

- `nashville_housing_data_cleaning.sql`: all my SQL queries
- `Nashville_Housing_Data_for_Data_Cleaning.xlsx`: the raw data

## Notes

My script finds the duplicate rows but doesn't delete them. If I was going to analyze this data, the next step would be to remove them. I also changed the original table directly, which is fine for practice, but on a real database I would work on a copy.
