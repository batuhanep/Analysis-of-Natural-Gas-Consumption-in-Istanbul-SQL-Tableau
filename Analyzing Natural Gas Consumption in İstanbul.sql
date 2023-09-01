--This project aims to obtain information about natural gas consumption in Ýstanbul using datasets of natural gas price per cubic meter and natural gas consumption per cubic meter.

--Some topics expected to be covered in this project:
--Average, highest and total natural gas consumption(m3) by district,month and year,
--Relationship between natural gas consumption(m3) and natural gas price(m3),
--Ranking of natural gas consumption among Ýstanbul districts


--About the datasets:
-- Source of Natural Gas Consumption(m3) dataset: Istanbul Metropolitan Municipality Open Data Portal : https://data.ibb.gov.tr/
-- Source of Natural Gas Unit Prices dataset: Istanbul Metropolitan Municipality IGDAS. I collected the data of this dataset from https://www.igdas.istanbul/retail-satis/ and prepared, organized the data and created the 'NaturalGasUnitPrice' dataset.

--Let's take an overview of both datasets.

Select *
From PortfolioProject.dbo.NaturalGasConsumption

--

Select *
From PortfolioProject.dbo.NaturalGasUnitPrice

--In this step, let's take a look at both datasets in descending order of years using JOIN. In this way, we can create a roadmap for the analyzes to be made by looking at the data in a general framework.

Select ngc.District, ngc.Year, ngc.Month_No, ngc.Naturalgas_Consumption_Amount_m3, ngup.Year, ngup.PriceTL_m3
From PortfolioProject.dbo.NaturalGasConsumption ngc
Join PortfolioProject.dbo.NaturalGasUnitPrice ngup
On ngc.Year = ngup.Year
and ngc.Month_No = ngup.Month_No
Order by 4 desc
--SELECT TOP 10

--Average and total consumption per year:

Select Year, AVG(Naturalgas_Consumption_Amount_m3) as AverageNaturalGasConsumptionPerYear, SUM(Naturalgas_Consumption_Amount_m3) as TotalNaturalGasConsumptionPerYear
From PortfolioProject.dbo.NaturalGasConsumption
Where Year <> 2023
Group by Year
Order By 2 desc

--Average consumption per month:

Select AVG(Naturalgas_Consumption_Amount_m3) as AverageNaturalGasConsumptionPerMonth, Month_No
From PortfolioProject.dbo.NaturalGasConsumption
Where Year <> 2023
--I did not include 2023 because data is only available up to the fourth month.
Group by Month_No
Order By 1 desc

--After adding the average natural gas unit price per month, examining the consumption amount per years:

Select AVG(ngc.Naturalgas_Consumption_Amount_m3) as AverageNaturalGasConsumptionByYear , AVG(ngup.PriceTL_m3) as AverageNaturalGasPriceByYear, ngc.Year
From PortfolioProject.dbo.NaturalGasConsumption ngc
Join PortfolioProject.dbo.NaturalGasUnitPrice ngup
On ngc.Year = ngup.Year
Where ngc.Year <> 2023
--I didn't include the year 2023 to get a healthy result because data is only available up to the fourth month.
Group by ngc.Year, ngup.Year
Order By 1 desc


--Ranking of average and total natural gas consumption by districts from largest to smallest:

Select District, AVG(Naturalgas_Consumption_Amount_m3) as AverageConsumptionPerDistrict, SUM(Naturalgas_Consumption_Amount_m3) as TotalConsumptionPerDistrict
From PortfolioProject.dbo.NaturalGasConsumption
--I did not include 2023 because data is only available up to the fourth month.
Where Year Between 2015 and 2022
Group by District
Order By 2 desc
-- We can also add 'TOP 10' after SELECT to see first 10 highest districts.
 

--Let's look at the top 10, the average and total consumption, by adding years to each year separately. In both queries, Esenyurt is the district with the highest natural gas consumption.:

Select TOP 10
Year, District, SUM(Naturalgas_Consumption_Amount_m3) as TotalConsumptionPerDistrict ,AVG(Naturalgas_Consumption_Amount_m3) as AverageConsumptionByDistrict
From PortfolioProject.dbo.NaturalGasConsumption
Where Year Between 2015 and 2022
--I did not include 2023 because data is only available up to the fourth month.
Group by District, Year
Order By 3 desc


--Highest numbers of natural gas consumption and price by years

Select TOP 15
MAX(ngc.Naturalgas_Consumption_Amount_m3) as HighestNaturalGasConsumptionByYear , Max(ngup.PriceTL_m3) as HighestNaturalGasPriceByYear, ngup.Year, ngup.Month_No
From PortfolioProject.dbo.NaturalGasConsumption ngc
Join PortfolioProject.dbo.NaturalGasUnitPrice ngup
On ngc.Year = ngup.Year
and ngc.Month_No = ngup.Month_No
Group by ngc.Year, ngup.Year, ngc.Month_No, ngup.Month_No
Order By 1 desc


--Let's compare the maximum natural gas consumption by years with the average natural gas prices of those years:

Select MAX(ngc.Naturalgas_Consumption_Amount_m3) as HighestNaturalGasConsumptionByYear, MAX(ngup.PriceTL_m3) as HighestNaturalGasPriceByYear, ngup.Year
From PortfolioProject.dbo.NaturalGasConsumption ngc
Join PortfolioProject.dbo.NaturalGasUnitPrice ngup
On ngc.Year = ngup.Year
Where ngc.Year <> 2023
--I did not include 2023 because data is only available up to the fourth month.
Group by ngc.Year, ngup.Year
Order By 1 desc


--Finally, let's compare the total natural gas consumption by years with the average natural gas prices of those years.

Select SUM(ngc.Naturalgas_Consumption_Amount_m3) as TotalNaturalGasConsumptionByYear , AVG(ngup.PriceTL_m3) as AverageNaturalGasPriceByYear, ngup.Year
From PortfolioProject.dbo.NaturalGasConsumption ngc
Join PortfolioProject.dbo.NaturalGasUnitPrice ngup
On ngc.Year = ngup.Year
Where ngc.Year <> 2023
--I did not include 2023 because data is only available up to the fourth month.
Group by ngc.Year, ngup.Year
Order By 1 desc

-- Let's create a sample View

USE PortfolioProject
GO
Create View NaturalGasConsumptionByDistrict as
Select TOP 10
District, AVG(Naturalgas_Consumption_Amount_m3) as AverageConsumptionPerDistrict, SUM(Naturalgas_Consumption_Amount_m3) as TotalConsumptionPerDistrict
From PortfolioProject.dbo.NaturalGasConsumption
--I did not include 2023 because data is only available up to the fourth month.
Where Year Between 2015 and 2022
Group by District
Order By 2 desc

Select *
FROM NaturalGasConsumptionByDistrict

--Full article: https://medium.com/@ozdemirbatu.80/natural-gas-consumption-in-i%CC%87stanbul-analyzing-ms-sql-and-visualizing-tableau-natural-gas-426299163229
--Data vizualization: https://public.tableau.com/app/profile/batuhan.zdemir/viz/NaturalGasConsumptioninstanbul/Dashboard1

