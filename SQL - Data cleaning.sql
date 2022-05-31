
--Cleaning Data in SQL 
--Skills used : UPDATE, ALTER TABLE, CTE, WINDOWS FUNCTIONS ,JOINS, OREDR BY, GROUP BY


SELECT * FROM 
Housing_Project..nashville_housing;

--------------------------------------------------------------------------------------------------------------------------

--Standardize Date Format


SELECT SaleDate, CONVERT(date, SaleDate)
FROM Housing_Project..nashville_housing; 

UPDATE nashville_housing 
SET Sale_Date2 = (SaleDate);


-- Another option if column wasnt updated properly


ALTER TABLE nashville_housing
ADD Sale_Date2 Date;

Update nashville_housing
SET Sale_Date2 = CONVERT(Date,SaleDate)


--------------------------------------------------------------------------------------------------------------------------

--Populate Property Address Data



SELECT * 
FROM Housing_Project.dbo.nashville_housing
WHERE PropertyAddress is null
ORDER BY ParcelID;


SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM Housing_Project..nashville_housing A
JOIN Housing_Project..nashville_housing B
	ON A.ParcelID = B.ParcelID
	AND A.UniqueID != B.UniqueID
WHERE A.PropertyAddress IS NULL;


  UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM Housing_Project..nashville_housing A
JOIN Housing_Project..nashville_housing B
	ON A.ParcelID = b.ParcelID
	AND A.UniqueID != B.UniqueID
WHERE A.PropertyAddress is null;


--------------------------------------------------------------------------------------------------------------------------

-- Seperating Address into Individual Columns (Address, City, State)


SELECT PropertyAddress 
FROM Housing_Project..nashville_housing
WHERE PropertyAddress IS NULL;

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN(PropertyAddress)) AS City
FROM Housing_Project..nashville_housing ;



-- Altering Property Address


ALTER TABLE nashville_housing 
ADD Property_Split_Address VARCHAR(255);

UPDATE nashville_housing 
SET Property_Split_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


-- Altering Property City


ALTER TABLE nashville_housing 
ADD Property_Split_City VARCHAR(255);

UPDATE nashville_housing 
SET Property_Split_City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN(PropertyAddress))


--------------------------------------------------------------------------------------------------------------------------


--CREATING A SPLIT STRING FUNCTION TO SPLIT THE OWNER ADDRESS


SELECT OwnerAddress
FROM Housing_Project..nashville_housing;

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) 
FROM Housing_Project..nashville_housing;



-- Altering Owner Address


ALTER TABLE nashville_housing
ADD OwnerSplitAddress VARCHAR(255);

UPDATE nashville_housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);


-- Altering Owner City


ALTER TABLE nashville_housing
ADD OwnerSplitCity VARCHAR(255);

UPDATE nashville_housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);



-- Altering Owner State


ALTER TABLE nashville_housing
ADD OwnerSplitState VARCHAR(255);

UPDATE nashville_housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);



-- Checking the results

SELECT OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
FROM Housing_Project..nashville_housing;


--------------------------------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in SoldAsVacant


SELECT DISTINCT(SoldAsVacant)
FROM Housing_Project..nashville_housing


SELECT SoldAsVacant,
CASE
   WHEN SoldAsVacant = 'Y' THEN 'Yes'
   WHEN SoldAsVacant = 'N' THEN 'No'
   ELSE SoldAsVacant
END
FROM Housing_Project..nashville_housing;


UPDATE nashville_housing
SET SoldAsVacant = CASE
   WHEN SoldAsVacant = 'Y' THEN 'Yes'
   WHEN SoldAsVacant = 'N' THEN 'No'
   ELSE SoldAsVacant
END

SELECT Distinct SoldAsVacant
FROM Housing_Project..nashville_housing;

	

------------------------------------------------------------------------------------------	
	
	
--Remove Duplicate


WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER(
  PARTITION BY ParcelID,
               SalePrice,
			   SaleDate,
			   LegalReference,
			   PropertyAddress
			   ORDER BY UniqueID
			   ) Row_Num
FROM Housing_Project..nashville_housing
)
SELECT *
FROM RowNumCTE
WHERE Row_Num > 1;


--------------------------------------------------------------------------------------------------------------------------
	
	
--Delete Unused Column


ALTER TABLE nashville_housing 
DROP COLUMN PropertyAddress, SaleDate, LegalReference, TaxDistrict;

--------------------------------------------------------------------------------------------------------------------------
