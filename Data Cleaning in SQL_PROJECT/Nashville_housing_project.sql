SELECT 
    *
FROM
    nashville_housing;

-- CLEANING THE DATA 

-- MODIFY THE TYPE OF THE SALEDATE COLUMN 
describe nashville_housing;
ALTER TABLE nashville_housing
MODIFY COLUMN SaleDate date ;

-- POPULATE PROPERTY ADDRESS DATA 

SELECT 
    *
FROM
    nashville_housing;
SELECT 
    *
FROM
    nashville_housing
WHERE
    PropertyAddress IS NOT NULL
ORDER BY ParcelID;
-- WE DONT HAVE NULL DATA 
SELECT 
    a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM
    nashville_housing a
        JOIN
    nashville_housing b ON a.ParcelID = b.ParcelID
        AND a.UniqueID != b.UniqueID;

-- BREAKING THE PROPERTYADRESS IN DIFERENT COLUMN

SELECT 
    PROPERTYADDRESS
FROM
    nashville_housing;
ALTER TABLE nashville_housing
ADD COLUMN PROPERTY_STREET varchar(255) ,
ADD COLUMN PROPERTY_CITY varchar (100);
SELECT 
    *
FROM
    nashville_housing;
UPDATE nashville_housing 
SET 
    PROPERTY_STREET = TRIM(SUBSTRING(propertyaddress,
            1,
            LOCATE(',', propertyaddress) - 1)),
    PROPERTY_CITY = TRIM(SUBSTRING(propertyaddress,
            LOCATE(',', propertyaddress) + 1,
            CHAR_LENGTH(propertyaddress)));

-- BREAKING THE OWNERADRESS IN DIFERRENT COLUMN

ALTER TABLE nashville_housing
ADD COLUMN OWNER_STREET varchar(255) ,
ADD COLUMN OWNER_CITY varchar (100);
SELECT 
    *
FROM
    nashville_housing;
ALTER TABLE nashville_housing
DROP COLUMN OWNER_STATE;
UPDATE nashville_housing 
SET 
    OWNER_STREET = SUBSTRING(OWNERADDRESS,
        1,
        INSTR(OWNERADDRESS, ',') - 1),
    OWNER_CITY = TRIM(SUBSTRING(OWNERADDRESS,
            LOCATE(',', OWNERADDRESS) + 1,
            LOCATE(',',
                    OWNERADDRESS,
                    LOCATE(',', OWNERADDRESS) + 1) - LOCATE(',', OWNERADDRESS) - 1));
                    
                    
-- Change Y and N to Yes and No in "Sold as Vacant" field
SELECT DISTINCT
    (SOLDASVACANT), COUNT(SOLDASVACANT)
FROM
    nashville_housing
GROUP BY SoldAsVacant
ORDER BY 2;

UPDATE nashville_housing 
SET 
    SOLDASVACANT = 'YES'
WHERE
    SOLDASVACANT = 'Y';
UPDATE nashville_housing 
SET 
    SOLDASVACANT = 'NO'
WHERE
    SOLDASVACANT = 'N';
 -- ANOTHER WAY TO DO IT WITH CASE STATEMENT 
UPDATE nashville_housing 
SET 
    SOLDASVACANT = CASE
        WHEN SOLDASVACANT = 'Y' THEN SOLDASVACANT = 'YES'
        WHEN SOLDASVACANT = 'N' THEN SOLDASVACANT = 'NO'
        ELSE SOLDASVACANT
    END;


-- REMOVE DUPLICATE
WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From nashville_housing )
DELETE 
From RowNumCTE
WHERE ROW_NUM >1 ;

-- DELETE IN USEABLE COLUMS 

ALTER TABLE nashville_housing 
DROP COLUMN TaxDistrict,
DROP COLUMN OWNERADDRESS,
DROP COLUMN PropertyAddress,
DROP COLUMN SaleDate ;

SELECT 
    *
FROM
    nashville_housing;

