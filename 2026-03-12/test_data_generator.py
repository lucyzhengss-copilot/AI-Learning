#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
测试数据生成器
用于实践项目的测试数据
"""

import pandas as pd
import numpy as np
import os

def create_sales_data():
    """创建销售数据集"""
    np.random.seed(42)

    # 生成时间序列数据
    dates = pd.date_range('2023-01-01', periods=365, freq='D')

    # 生成销售数据
    sales = np.random.normal(1000, 200, 365).clip(0, 2000)
    marketing_spend = np.random.normal(500, 100, 365).clip(0, 1000)

    # 生成产品类别数据
    products = ['Electronics', 'Clothing', 'Books', 'Home', 'Sports']
    product_category = np.random.choice(products, 365, p=[0.3, 0.25, 0.2, 0.15, 0.1])

    # 生成地区数据
    regions = ['North', 'South', 'East', 'West']
    region = np.random.choice(regions, 365)

    # 生成客户满意度评分
    satisfaction = np.random.normal(4.0, 0.5, 365).clip(1, 5)

    # 创建DataFrame
    df = pd.DataFrame({
        'Date': dates,
        'Sales': sales.round(2),
        'Marketing_Spend': marketing_spend.round(2),
        'Product_Category': product_category,
        'Region': region,
        'Customer_Satisfaction': satisfaction.round(1),
        'Day_of_Week': dates.day_name(),
        'Month': dates.month_name()
    })

    return df

def create_customer_data():
    """创建客户数据集"""
    np.random.seed(123)

    # 生成客户ID
    customer_ids = [f'CUST_{i:04d}' for i in range(1, 1001)]

    # 生成客户特征
    age = np.random.randint(18, 70, 1000)
    income = np.random.normal(50000, 15000, 1000).clip(20000, 100000)

    # 生成购买历史
    purchase_frequency = np.random.poisson(5, 1000)
    total_purchases = np.random.gamma(100, 2, 1000)

    # 生成偏好数据
    favorite_categories = ['Electronics', 'Clothing', 'Food', 'Books', 'Home']
    favorite = np.random.choice(favorite_categories, 1000, p=[0.3, 0.25, 0.2, 0.15, 0.1])

    # 创建DataFrame
    df = pd.DataFrame({
        'Customer_ID': customer_ids,
        'Age': age,
        'Annual_Income': income.round(0),
        'Purchase_Frequency': purchase_frequency,
        'Total_Purchases': total_purchases.round(2),
        'Favorite_Category': favorite,
        'Customer_Since': pd.date_range('2020-01-01', periods=1000, freq='D')
    })

    return df

def create_employee_data():
    """创建员工数据集"""
    np.random.seed(456)

    # 部门列表
    departments = ['Engineering', 'Marketing', 'Sales', 'HR', 'Finance', 'Operations']

    # 职位列表
    positions = ['Manager', 'Senior', 'Junior', 'Lead', 'Director', 'Analyst']

    # 生成员工数据
    num_employees = 500
    df = pd.DataFrame({
        'Employee_ID': [f'EMP_{i:04d}' for i in range(1, num_employees + 1)],
        'Age': np.random.randint(22, 65, num_employees),
        'Gender': np.random.choice(['Male', 'Female'], num_employees),
        'Department': np.random.choice(departments, num_employees),
        'Position': np.random.choice(positions, num_employees),
        'Salary': np.random.normal(75000, 20000, num_employees).clip(30000, 150000).round(0),
        'Years_Experience': np.random.randint(0, 30, num_employees),
        'Performance_Score': np.random.choice([1, 2, 3, 4, 5], num_employees, p=[0.05, 0.15, 0.3, 0.4, 0.1]),
        'Work_From_Home': np.random.choice(['Yes', 'No'], num_employees, p=[0.7, 0.3])
    })

    return df

def main():
    """生成所有测试数据"""
    print("🔄 正在生成测试数据...")

    # 创建数据目录
    os.makedirs('test_data', exist_ok=True)

    # 生成销售数据
    sales_df = create_sales_data()
    sales_df.to_csv('test_data/sales_data.csv', index=False)
    print(f"✅ 销售数据已生成: test_data/sales_data.csv ({len(sales_df)} 条记录)")

    # 生成客户数据
    customer_df = create_customer_data()
    customer_df.to_csv('test_data/customer_data.csv', index=False)
    print(f"✅ 客户数据已生成: test_data/customer_data.csv ({len(customer_df)} 条记录)")

    # 生成员工数据
    employee_df = create_employee_data()
    employee_df.to_csv('test_data/employee_data.csv', index=False)
    print(f"✅ 员工数据已生成: test_data/employee_data.csv ({len(employee_df)} 条记录)")

    # 生成一个有缺失值的数据集（用于测试数据处理）
    missing_df = sales_df.copy()
    # 随机设置一些缺失值
    missing_indices = np.random.choice(len(missing_df), size=int(0.1 * len(missing_df)), replace=False)
    missing_df.loc[missing_indices, 'Marketing_Spend'] = np.nan
    missing_df.loc[missing_indices[:50], 'Customer_Satisfaction'] = np.nan
    missing_df.to_csv('test_data/missing_data.csv', index=False)
    print(f"✅ 缺失值数据已生成: test_data/missing_data.csv")

    print("\n📊 数据摘要:")
    print("-" * 50)
    print(f"销售数据形状: {sales_df.shape}")
    print(f"客户数据形状: {customer_df.shape}")
    print(f"员工数据形状: {employee_df.shape}")
    print("-" * 50)

    print("\n🎉 测试数据生成完成！")
    print("\n📝 使用方法:")
    print("1. 启动Python环境")
    print("2. 导入Skill模块")
    print("3. 对测试数据执行分析")

if __name__ == "__main__":
    main()