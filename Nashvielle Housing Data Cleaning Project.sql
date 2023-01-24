--Standardize Date Format
Select SaleDateConverted
From [Nashvielle Housing]


Alter Table [Nashvielle Housing]
Add SaleDateConverted Date

Update [Nashvielle Housing]
Set SaleDateConverted = CONVERT( Date, SaleDate)

Select *
From [Nashvielle Housing]

--Populate Property Address Data
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, Isnull(a.PropertyAddress, b.PropertyAddress)
From [Nashvielle Housing] a
Join [Nashvielle Housing] b
On a.ParcelID =b.ParcelID and a. [UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress= Isnull(a.PropertyAddress, b.PropertyAddress)
From [Nashvielle Housing] a
Join [Nashvielle Housing] b
On a.ParcelID =b.ParcelID and a. [UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--Breaking out Property Address into Individual Columns (Address, City, State)
Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress)) as Address
From [Nashvielle Housing]

Alter Table [Nashvielle Housing]
Add PropertySplitAddress nvarchar(255)

Update [Nashvielle Housing]
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 

Alter Table [Nashvielle Housing]
Add PropertySplitCity nvarchar(255)

Update [Nashvielle Housing]
Set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress)) 

--Breaking out Owner Address into Individual Columns (Address, City, State)
Select PARSENAME(Replace(OwnerAddress, ',', '.'), 3) ,
PARSENAME(Replace (OwnerAddress, ',', '.'), 2),
PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
From [Nashvielle Housing]

Alter Table [Nashvielle Housing]
Add OwnerSplitAddress nvarchar(255)

Update [Nashvielle Housing]
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)

Alter Table [Nashvielle Housing]
Add OwnerSplitCity nvarchar(255)

Update [Nashvielle Housing]
Set OwnerSplitCity = PARSENAME(Replace (OwnerAddress, ',', '.'), 2)

Alter Table [Nashvielle Housing]
Add OwnerSplitState nvarchar(255)

Update [Nashvielle Housing]
Set OwnerSplitState = PARSENAME(Replace (OwnerAddress, ',', '.'), 1)

--Updating SoldAsvacant from Y to Yes and N to No respectively
Select SoldAsVacant,
	case when SoldAsVacant = 'Y' then 'Yes'
	     when SoldAsVacant = 'N' then 'No'
		 Else SoldAsVacant
		 End
From [Nashvielle Housing]

Update [Nashvielle Housing]
Set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	     when SoldAsVacant = 'N' then 'No'
		 Else SoldAsVacant
		 End

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Nashvielle Housing]
Group By SoldAsVacant

--Remove Duplicates
With RowNumCTE AS (
Select *,
	ROW_NUMBER() Over (Partition By ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference Order By UniqueID) row_num
From [Nashvielle Housing])
Delete 
From RowNumCTE
Where row_num >1
--Order By PropertyAddress

--Delete Unused Columns
Alter table [Nashvielle Housing]
Drop Column PropertyAddress, SaleDate, OwnerAddress
`