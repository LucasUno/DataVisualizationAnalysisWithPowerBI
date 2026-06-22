USE AdventureWorksDW2025;
GO

SELECT
--1.订单号、订单日期
	f.OrderDate AS [订单日期],
	f.SalesOrderNumber AS [订单号],

--2.客户信息：名字、性别
	c.CustomerKey AS [客户键],
	ISNULL(c.FirstName,'') + ' ' + ISNULL(c.LastName,'') AS [客户姓名],
	CASE c.Gender WHEN 'M' THEN N'男'
		  WHEN 'F' THEN N'女'
		  ELSE '未知' END AS [客户性别],

--3.产品信息：产品名、大类目、子类目
	p.ProductKey AS [产品键],
	p.EnglishProductName AS [产品名],
	pc.EnglishProductCategoryName AS [产品大类],
	ps.EnglishProductSubcategoryName AS [产品子类],

--4.地理信息：国家、地区
	st.SalesTerritoryCountry AS [销售国家],
	st.SalesTerritoryGroup AS [销售区域],

--5.基础度量值：销售数量、销售额、销售成本
	f.OrderQuantity AS [销售数量],
	f.SalesAmount AS [销售额],
	f.TotalProductCost AS [产品总成本]

FROM FactInternetSales f
LEFT JOIN DimCustomer c ON f.CustomerKey = c.CustomerKey
LEFT JOIN DimProduct p ON f.ProductKey = p.ProductKey
LEFT JOIN DimProductSubcategory ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
LEFT JOIN DimProductCategory pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
LEFT JOIN DimSalesTerritory st ON f.SalesTerritoryKey = st.SalesTerritoryKey
