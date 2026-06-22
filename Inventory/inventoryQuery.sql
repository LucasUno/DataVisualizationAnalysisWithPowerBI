USE AdventureWorksDW2025;
GO

SELECT
--1.日期信息
	i.DateKey AS [日期键],
	i.MovementDate AS [库存盘点时间],

--2.产品基础信息
	p.ProductKey AS [产品键],
	p.EnglishProductName AS [产品名],
	ISNULL(ps.EnglishProductSubcategoryName,N'其他/基础配件') AS [产品子类],
	ISNULL(pc.EnglishProductCategoryName,N'其他/未分类')AS [产品大类],

--3.核心库存指标
	i.UnitCost AS [单位库存成本],
	i.UnitsIn AS [当日入库数量],
	i.UnitsOut AS [当日出库数量],
	i.UnitsBalance AS [当日库存数量],

--4.财务库存价值
	(i.UnitsBalance*i.UnitCost) AS [期末库存价值]

FROM	FactProductInventory i
LEFT JOIN DimProduct p ON i.ProductKey = p.ProductKey  
LEFT JOIN DimProductSubcategory ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
LEFT JOIN DimProductCategory pc ON ps.ProductCategoryKey = pc.ProductCategoryKey