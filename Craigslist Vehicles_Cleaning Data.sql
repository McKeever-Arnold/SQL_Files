------------------------------------------------------------------------------------------------------------------------
-- Standardize the Date format


ALTER TABLE PortfolioProject.dbo.vehicles$
ADD post_date_formatted nvarchar(255);

UPDATE PortfolioProject.dbo.vehicles$
SET post_date_formatted = SUBSTRING(posting_date, 1, CHARINDEX('T',posting_date) -1);

ALTER TABLE PortfolioProject.dbo.vehicles$
ALTER COLUMN post_date_formatted date;


------------------------------------------------------------------------------------------------------------------------
-- Remove Duplicate Posts/Reposts


WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY price, year, manufacturer, model, condition, cylinders, fuel, odometer, title_status,
				transmission, title_status, VIN, drive, size, type, paint_color, image_url, state
				ORDER BY id
				) row_num
FROM PortfolioProject.dbo.vehicles$
)
DELETE
FROM RowNumCTE
Where row_num > 1


------------------------------------------------------------------------------------------------------------------------
-- Remove Separate Ads for the Same Exact Vehicle


WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY VIN
				ORDER BY id
				) row_num
FROM PortfolioProject.dbo.vehicles$
)
DELETE
FROM RowNumCTE
Where VIN is not null AND row_num > 1