USE AdventureWorksDW2025;
GO

SELECT 
    -- 查询表名、行数、数据大小
    t.NAME AS [表名],
    p.rows AS [总行数],
    CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.0), 2) AS NUMERIC(36, 2)) AS [占用空间(MB)],
   -- 按照事实表Fact 和 维度表Dim来分类
   CASE 
        WHEN t.NAME LIKE 'Fact%' THEN N'核心事实表（业务流水/指标）'
        WHEN t.NAME LIKE 'Dim%' THEN N'维度表（属性/切片标签）'
        ELSE N'其他系统表'
    END AS [表类型]
FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.is_ms_shipped = 0 AND i.index_id <= 1 --过滤系统表，且防止id重复计算
GROUP BY t.NAME, p.rows
ORDER BY p.rows DESC; -- 按数据量从大到小排序