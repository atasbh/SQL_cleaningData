-- IN this project, we want to do the process of cleaning data by SQL

select *
From Portfolio1..NashvilleHousing


------------------------------------------------------------------------------

-- Standardize Date format.

select SaleDate, convert(Date, SaleDate)
from Portfolio1..NashvilleHousing

Alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = convert(Date, SaleDate)

select SaleDateConverted
From Portfolio1..NashvilleHousing

-------------------------------------------------------------------------------

-- Populated Property Addresses Data

select PropertyAddress from Portfolio1..NashvilleHousing

select a.ParcelID, b.ParcelID, a.PropertyAddress, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from Portfolio1..NashvilleHousing a
join Portfolio1..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from Portfolio1..NashvilleHousing a
join Portfolio1..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL

-------------------------------------------------------------------

-- Breaking a address in the indivisual columns (Address, city, State)

select PropertyAddress from Portfolio1..NashvilleHousing

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
From Portfolio1..NashvilleHousing


Alter table NashvilleHousing
add PropertySplitAddress Nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter table NashvilleHousing
add PropertySplitCity Nvarchar(255);

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

select PropertySplitAddress, PropertySplitCity
From Portfolio1..NashvilleHousing



select 
Parsename(replace(owneraddress, ',', '.'), 3)
From Portfolio1..NashvilleHousing

select 
Parsename(replace(owneraddress, ',', '.'), 2)
From Portfolio1..NashvilleHousing

select 
Parsename(replace(owneraddress, ',', '.'), 1)
From Portfolio1..NashvilleHousing

Alter table NashvilleHousing
add ownerSplitaddress Nvarchar(255);

update NashvilleHousing
set ownerSplitaddress = Parsename(replace(owneraddress, ',', '.'), 3)

Alter table NashvilleHousing
add ownerSplitCity Nvarchar(255);

update NashvilleHousing
set ownerSplitCity = Parsename(replace(owneraddress, ',', '.'), 2)

Alter table NashvilleHousing
add ownerSplitState Nvarchar(255);

update NashvilleHousing
set ownerSplitState = Parsename(replace(owneraddress, ',', '.'), 1)

select *
from Portfolio1..NashvilleHousing

------------------------------------------------------------------------------------------

-- change Y and N to Yes and NO in sold as vacant

select distinct(SoldAsVacant)
from Portfolio1..NashvilleHousing

select SoldAsVacant
,  case when SoldAsVacant = 'YESes' Then 'Yes'
		when SoldAsVacant = 'Noo' Then 'No'
		else SoldAsVacant
		End
from Portfolio1..NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'YESes' Then 'Yes'
		when SoldAsVacant = 'Noo' Then 'No'
		else SoldAsVacant
		End

select distinct(SoldAsVacant)
from Portfolio1..NashvilleHousing

----------------------------------------------------------------------------------------

-- Remove duplicates

WITH RowNumCTE AS(
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

From Portfolio1..NashvilleHousing
)

Delete
From RowNumCTE
Where row_num > 1

select *
from Portfolio1..NashvilleHousing

----------------------------------------------------------------------------------------

--Delete unused columns

select *
from Portfolio1..NashvilleHousing

Alter table NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate 


--------------------------------------------------------------------------------------