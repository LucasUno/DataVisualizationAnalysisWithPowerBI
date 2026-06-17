import pandas as pd
from datetime import datetime

'''
关于库存相关库龄(>90天)货物的库存成本报告
数据源：仓库成本表，库存源数据表
1、读取相关数据源
2、获取时间数据计算库龄，并筛选出大于90天库龄的数据
3、关联表格数据
4、计算仓库存储成本
5、输出报告
'''

print(">>>>自动化脚本开始运行。。。。。。\n")

#1.读取源数据
df_inventory = pd.read_excel('raw_inventory.xlsx')
df_costs = pd.read_csv('product_costs.csv')
# print("\n"+">>>>>inventoy"+"\n")
# print(df_inventory)
# print("\n"+"="*30+"\n")

# print("\n"+">>>>>>costs"+"\n")
# print(df_costs)
# print("\n"+"="*30+"\n")

#2.获取入库时间,计算库龄并筛选
df_inventory['Inbound_Date'] = pd.to_datetime(df_inventory['Inbound_Date'])
today = pd.to_datetime(datetime.now().date()) 

df_inventory['Age_Days'] = (today - df_inventory['Inbound_Date']).dt.days
dead_stock = df_inventory[df_inventory['Age_Days']>90].copy()
# print("\n"+">>>dead_stock"+"\n")
# print(dead_stock)
# print("\n"+"="*30+"\n")

#数据清洗为跨表关联作准备
df_costs['Product'] = df_costs['Product'].str.upper()
dead_stock['SKU'] = dead_stock['SKU'].str.upper()

#3.关联报表
dead_stock_with_costs = pd.merge(dead_stock,df_costs,left_on='SKU',right_on='Product',how='left')
# print("\n"+">>>计算前dead_stock_with_costs"+"\n")
# print(dead_stock_with_costs)
# print("\n"+"="*30+"\n")

#4.清理数据，并计算仓库成本
dead_stock_with_costs['CostPerUnit'] = dead_stock_with_costs['CostPerUnit'].fillna(0)
dead_stock_with_costs['Total_Funds_Tied_Up'] = dead_stock_with_costs['Quantity']*dead_stock_with_costs['CostPerUnit']

# print("\n"+">>>计算后dead_stock_with_costs"+"\n")
# print(dead_stock_with_costs)
# print("\n"+"="*30+"\n")

#5.输出报表
final_report = dead_stock_with_costs[['SKU','Quantity','Age_Days','CostPerUnit','Total_Funds_Tied_Up']]

print(">>> 业务逻辑计算完成，正在导出 Excel 报告...")

fileName = f"呆滞库存资金预警报告_{datetime.now().strftime('%Y年%m月%d日')}.xlsx"
final_report.to_excel(fileName,index=False)

print(f">>> {fileName}导出完成!")