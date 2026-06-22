USE AdventureWorksDW2025;
GO

SELECT 
    col.name AS [列名],
    typ.name AS [数据类型],
    col.max_length AS [最大长度],
    CASE WHEN col.is_nullable = 1 THEN N'是' ELSE N'否' END AS [是否允许为空]
FROM sys.columns col
INNER JOIN sys.types typ ON col.system_type_id = typ.system_type_id AND col.user_type_id = typ.user_type_id
WHERE col.object_id = OBJECT_ID('DimSalesTerritory')
ORDER BY col.column_id;