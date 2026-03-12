#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
快速实践脚本
立即开始使用今天开发的Skill
"""

import sys
import json
from pathlib import Path

# 添加当前目录到Python路径
sys.path.append(str(Path(__file__).parent))

def create_skill_classes():
    """创建Skill类（简化版，避免导入问题）"""

    # 1. 数据分析Skill
    class DataAnalysisSkill:
        def __init__(self):
            self.name = "data_analysis"
            self.description = "执行数据描述性统计分析"

        def execute(self, data_path, **kwargs):
            import pandas as pd
            import numpy as np

            try:
                # 加载数据
                if data_path.endswith('.csv'):
                    data = pd.read_csv(data_path)
                else:
                    return {"success": False, "error": "不支持的数据格式"}

                # 基本信息分析
                result = {
                    "basic_info": {
                        "shape": list(data.shape),
                        "columns": data.columns.tolist(),
                        "dtypes": data.dtypes.astype(str).to_dict(),
                        "memory_usage": f"{data.memory_usage(deep=True).sum() / 1024:.2f} KB"
                    },
                    "numeric_stats": {},
                    "missing_values": data.isnull().sum().to_dict()
                }

                # 数值列统计
                numeric_cols = data.select_dtypes(include=[np.number]).columns
                for col in numeric_cols:
                    result["numeric_stats"][col] = {
                        "mean": float(data[col].mean()),
                        "std": float(data[col].std()),
                        "min": float(data[col].min()),
                        "max": float(data[col].max()),
                        "missing": int(data[col].isnull().sum())
                    }

                return {
                    "success": True,
                    "data": result,
                    "message": "数据分析完成"
                }

            except Exception as e:
                return {
                    "success": False,
                    "error": str(e),
                    "message": f"分析失败: {str(e)}"
                }

    # 2. 可视化Skill
    class VisualizationSkill:
        def __init__(self):
            self.name = "visualization"
            self.description = "生成基础数据可视化"

        def execute(self, data_path, **kwargs):
            try:
                import pandas as pd
                import matplotlib.pyplot as plt

                # 设置中文字体
                plt.rcParams['font.sans-serif'] = ['Arial Unicode MS', 'SimHei']
                plt.rcParams['axes.unicode_minus'] = False

                # 加载数据
                data = pd.read_csv(data_path)

                # 创建图表
                fig, axes = plt.subplots(2, 2, figsize=(12, 10))
                fig.suptitle('数据概览', fontsize=16, fontweight='bold')

                # 1. 数据分布直方图
                numeric_cols = data.select_dtypes(include=['number']).columns
                if len(numeric_cols) > 0:
                    data[numeric_cols[0]].hist(ax=axes[0,0], bins=20, alpha=0.7)
                    axes[0,0].set_title(f'{numeric_cols[0]} 分布')
                    axes[0,0].set_xlabel('数值')
                    axes[0,0].set_ylabel('频数')

                # 2. 缺失值条形图
                missing = data.isnull().sum()
                if missing.sum() > 0:
                    missing.plot(kind='bar', ax=axes[0,1], color='coral')
                    axes[0,1].set_title('缺失值统计')
                    axes[0,1].set_ylabel('数量')
                else:
                    axes[0,1].text(0.5, 0.5, '无缺失值', ha='center', va='center')
                    axes[0,1].set_title('缺失值统计')

                # 3. 数值列箱线图
                if len(numeric_cols) > 0:
                    data[numeric_cols].boxplot(ax=axes[1,0])
                    axes[1,0].set_title('数值分布')
                    axes[1,0].set_ylabel('数值')

                # 4. 分类列条形图
                categorical_cols = data.select_dtypes(include=['object']).columns
                if len(categorical_cols) > 0 and data[categorical_cols[0]].nunique() < 20:
                    data[categorical_cols[0]].value_counts().plot(kind='bar', ax=axes[1,1])
                    axes[1,1].set_title(categorical_cols[0] + ' 分布')
                    axes[1,1].set_ylabel('数量')

                plt.tight_layout()

                # 保存图表
                chart_path = 'analysis_charts.png'
                plt.savefig(chart_path, dpi=300, bbox_inches='tight')
                plt.close()

                return {
                    "success": True,
                    "chart_path": chart_path,
                    "message": "图表已生成并保存"
                }

            except Exception as e:
                return {
                    "success": False,
                    "error": str(e),
                    "message": f"可视化失败: {str(e)}"
                }

    return DataAnalysisSkill, VisualizationSkill

def main():
    """主函数 - 快速实践"""
    print("🚀 AI实践项目 - 快速开始")
    print("=" * 50)

    # 获取可用的数据文件
    data_files = list(Path("test_data").glob("*.csv"))
    if not data_files:
        print("❌ 没有找到测试数据文件，请先运行 test_data_generator.py")
        return

    print("📊 可用的数据文件:")
    for i, file in enumerate(data_files, 1):
        print(f"{i}. {file.name}")

    # 让用户选择
    choice = input(f"\n请选择要分析的数据文件 (1-{len(data_files)}): ").strip()

    try:
        idx = int(choice) - 1
        if 0 <= idx < len(data_files):
            selected_file = data_files[idx]
        else:
            print("❌ 无效选择")
            return
    except ValueError:
        print("❌ 请输入数字")
        return

    print(f"\n📁 已选择: {selected_file.name}")

    # 创建Skill
    DataAnalysisSkill, VisualizationSkill = create_skill_classes()
    analysis_skill = DataAnalysisSkill()
    viz_skill = VisualizationSkill()

    print("\n🔍 开始数据分析...")
    analysis_result = analysis_skill.execute(str(selected_file))

    if analysis_result["success"]:
        print("\n✅ 分析结果:")
        print(json.dumps(analysis_result["data"], indent=2, ensure_ascii=False))

        # 可视化
        print("\n📈 生成可视化图表...")
        viz_result = viz_skill.execute(str(selected_file))

        if viz_result["success"]:
            print(f"✅ 图表已保存: {viz_result['chart_path']}")
            print(f"   可以用 'open {viz_result['chart_path']}' 查看图表")
        else:
            print(f"❌ 可视化失败: {viz_result['message']}")
    else:
        print(f"❌ 分析失败: {analysis_result['message']}")

    # 生成代码模板
    print("\n💡 代码模板:")
    print("-" * 30)
    print("""
# 使用示例代码
from pathlib import Path

# 创建Skill实例
analysis_skill = DataAnalysisSkill()
viz_skill = VisualizationSkill()

# 分析数据
result = analysis_skill.execute('your_data.csv')

# 生成可视化
viz_result = viz_skill.execute('your_data.csv')
    """)

if __name__ == "__main__":
    main()