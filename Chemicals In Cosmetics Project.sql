

Update ['chemicals_in_cosmetics-$']
Set BrandName = 'Entiere'
Where BrandName = 'ENTIERE'

--Removing Excess Spaces In BrandName Column
Select TRIM (BrandName) As Brand_name
From ['chemicals_in_cosmetics-$']

Update ['chemicals_in_cosmetics-$']
Set BrandName = Trim(BrandName)

Update ['chemicals_in_cosmetics-$']
Set CompanyName = Trim(CompanyName)

Select 


--Changing Datatype for ChemicalDateRemoved from nvarchar to Datetime
Alter Table ['chemicals_in_cosmetics-$']
Alter Column ChemicalDateRemoved datetime


--1 Chemicals used most in Cosmetic and Personal Care Products
Select ChemicalName,Count(ChemicalName) AS Total_ChemicalCount
From ['chemicals_in_cosmetics-$']
Where SubCategory is not null and ChemicalName is not null
Group By ChemicalName
Order By Total_ChemicalCount Desc

--2 Companies that used most reported chemicals in their cosmetic and personal care products (TOP 10)
Select CompanyName, ChemicalCount, count(ChemicalCount) AS Total_ChemicalName_Count
From ['chemicals_in_cosmetics-$']
Where ChemicalName ='Titanium dioxide' or ChemicalName = 'Silica, crystalline (airborne particles of respirable size)'
Group By CompanyName, ChemicalCount
Order By Total_ChemicalName_Count Desc
Offset 0 Rows Fetch first 10 rows only 


--3 Brands that had chemicals that were removed and discontinued

--Changing Datatype for ChemicalDateRemoved from nvarchar to Datetime
Alter Table ['chemicals_in_cosmetics-$']
Alter Column ChemicalDateRemoved datetime

--Cleaning BrandName Column (Changing 2103 to 2013)
Update ['chemicals_in_cosmetics-$']
Set ChemicalDateRemoved = '2013-12-05 00:00:00.000'
Where ChemicalDateRemoved = '2103-12-05 00:00:00.000'

--Cleaning BrandName Column (Changing 2104 to 2014)
Update ['chemicals_in_cosmetics-$']
Set ChemicalDateRemoved = '2104-02-05 00:00:00.000'
Where ChemicalDateRemoved ='2104-02-05 00:00:00.000'


Select BrandName, ChemicalName, ChemicalDateRemoved, DiscontinuedDate AS DateChemicalDiscontinued
From ['chemicals_in_cosmetics-$']
Where ChemicalDateRemoved is not Null and DiscontinuedDate  is not null 
Group By  BrandName, ChemicalName, ChemicalDateRemoved, DiscontinuedDate
Order By BrandName

--4 Identify the brands that had chemicals which were mostly reported in 2018.
select  BrandName, ChemicalName, InitialDateReported
From ['chemicals_in_cosmetics-$'] 
Where InitialDateReported between '2018-01-01 00:00:00.000' and '2018-12-31 00:00:00.000'
Group By BrandName, ChemicalName, InitialDateReported
Order BY InitialDateReported

--5 Which brands had chemicals discontinued and removed?
Select BrandName, ChemicalName
From ['chemicals_in_cosmetics-$']
Where ChemicalDateRemoved is not  Null and DiscontinuedDate is not null
Order By ChemicalName

--6 Identify the period between the creation of the removed chemicals and when they were actually removed
Select ChemicalName, ChemicalCreatedAt, ChemicalDateRemoved, DateDiff(DAY, ChemicalCreatedAt, ChemicalDateRemoved) as Period_Between_Creation_and_Removal
From ['chemicals_in_cosmetics-$']
Where ChemicalCreatedAt is not null and ChemicalDateRemoved is not null and  ChemicalCreatedAt < ChemicalDateRemoved
Group By ChemicalName, ChemicalCreatedAt, ChemicalDateRemoved
Order By  Period_Between_Creation_and_Removal Desc

--7 Can you tell if discontinued chemicals in bath products were removed 
Select ChemicalName, DiscontinuedDate,ChemicalDateRemoved
From ['chemicals_in_cosmetics-$']
Where PrimaryCategory = 'Bath Products' and  DiscontinuedDate is not null and ChemicalDateRemoved is not null 
Group By ChemicalName, DiscontinuedDate,ChemicalDateRemoved
Order By DiscontinuedDate

Select ChemicalName, DiscontinuedDate,ChemicalDateRemoved
From ['chemicals_in_cosmetics-$']
Where PrimaryCategory = 'Bath Products' and (DiscontinuedDate <= ChemicalDateRemoved)
Group By ChemicalName, DiscontinuedDate,ChemicalDateRemoved
Order By ChemicalName


--8 How long were removed chemicals in baby products used? (Tip: Use creation date to tell)
Select ChemicalName, ChemicalCreatedAt, ChemicaldateRemoved, DATEDIFF(DAY, ChemicalCreatedAt, ChemicalDateRemoved) AS time_difference
From ['chemicals_in_cosmetics-$']
Where PrimaryCategory ='Baby Products' and ChemicalDateRemoved is not null
Order By time_difference Desc

--9 Identify the relationship between chemicals that were mostly recently reported and discontinued. (Does most recently reported chemicals equal discontinuation of such chemicals?)
Select ChemicalName, MostRecentDateReported, DiscontinuedDate, DATEDIFF(YEAR, DiscontinuedDate, MostRecentDateReported) AS Time_difference
From ['chemicals_in_cosmetics-$']
Where MostRecentDateReported is not null and DiscontinuedDate is not null and (MostRecentDateReported>=DiscontinuedDate)
Order By Time_difference Desc


--10 Identify the relationship between CSF and chemicals used in the most manufactured sub categories. (Tip: Which chemicals gave a certain type of CSF in sub categories?)
Select ChemicalName, CSF, SubCategory, COUNT(Subcategory) AS TotalSubcategory
From ['chemicals_in_cosmetics-$']
Where CSF is not null
Group By ChemicalName, CSF, SubCategory
Order By TotalSubcategory DESC


---COUNTS
--Count of Brand
Select Count(Distinct BrandName)
From ['chemicals_in_cosmetics-$']
Where BrandName is not null

--Count of Chemicals
Select Count(Distinct ChemicalName)
From ['chemicals_in_cosmetics-$']

--Count of CompanyName
Select Count(Distinct CompanyName)
From ['chemicals_in_cosmetics-$']

--Count of Product
Select Count(Distinct ProductName)
From ['chemicals_in_cosmetics-$']

--Count of Subcategory
Select Count(Distinct SubCategory)
From ['chemicals_in_cosmetics-$']

--Count of PrimaryCategory
Select Count(Distinct PrimaryCategory)
From ['chemicals_in_cosmetics-$']


Select *
From ['chemicals_in_cosmetics-$']