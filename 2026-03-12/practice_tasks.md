# AI实践项目 - 完整代码实现

## 🎯 今日实践目标：开发数据分析Skill

基于你的数据分析背景，今天我们实现3个实用的Skill，可以直接集成到AI Agent中！

---

## 📊 Skill 1: 数据统计分析Skill

### 功能描述
自动进行数据的描述性统计分析，包括基本统计量、数据类型分析、缺失值检测等。

### 完整代码

```python
import pandas as pd
import numpy as np
from typing import Dict, Any, Optional
import json

class DataAnalysisSkill:
    """
    数据统计分析Skill
    功能：自动进行描述性统计分析
    """

    def __init__(self):
        self.name = "data_analysis"
        self.description = "执行数据描述性统计分析"
        self.version = "1.0"

    def execute(self, data_path: str, **kwargs) -> Dict[str, Any]:
        """
        执行数据分析

        Args:
            data_path: 数据文件路径（支持CSV, Excel, JSON）
            kwargs: 其他参数

        Returns:
            分析结果字典
        """
        try:
            # 1. 加载数据
            data = self._load_data(data_path)

            # 2. 执行分析
            result = {
                "basic_info": self._get_basic_info(data),
                "statistics": self._get_statistics(data),
                "data_quality": self._check_data_quality(data),
                "correlations": self._get_correlations(data),
                "recommendations": self._get_recommendations(data)
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
                "message": f"数据分析失败: {str(e)}"
            }

    def _load_data(self, data_path: str) -> pd.DataFrame:
        """智能加载数据"""
        if data_path.endswith('.csv'):
            return pd.read_csv(data_path)
        elif data_path.endswith('.xlsx') or data_path.endswith('.xls'):
            return pd.read_excel(data_path)
        elif data_path.endswith('.json'):
            return pd.read_json(data_path)
        else:
            raise ValueError(f"不支持的数据格式: {data_path}")

    def _get_basic_info(self, data: pd.DataFrame) -> Dict:
        """获取基本信息"""
        return {
            "shape": list(data.shape),
            "columns": data.columns.tolist(),
            "dtypes": data.dtypes.astype(str).to_dict(),
            "memory_usage": f"{data.memory_usage(deep=True).sum() / 1024:.2f} KB"
        }

    def _get_statistics(self, data: pd.DataFrame) -> Dict:
        """获取统计信息"""
        numeric_cols = data.select_dtypes(include=[np.number]).columns

        if len(numeric_cols) == 0:
            return {"message": "没有数值型列"}

        stats = data[numeric_cols].describe().to_dict()

        # 添加额外的统计量
        for col in numeric_cols:
            stats[col]['skewness'] = data[col].skew()
            stats[col]['kurtosis'] = data[col].kurtosis()
            stats[col]['missing_ratio'] = data[col].isnull().mean()

        return stats

    def _check_data_quality(self, data: pd.DataFrame) -> Dict:
        """检查数据质量"""
        return {
            "missing_values": data.isnull().sum().to_dict(),
            "duplicate_rows": data.duplicated().sum(),
            "null_ratio": (data.isnull().sum() / len(data)).to_dict(),
            "unique_values": {col: data[col].nunique() for col in data.columns}
        }

    def _get_correlations(self, data: pd.DataFrame) -> Dict:
        """获取相关性分析"""
        numeric_cols = data.select_dtypes(include=[np.number]).columns

        if len(numeric_cols) < 2:
            return {"message": "数值列不足，无法计算相关性"}

        corr_matrix = data[numeric_cols].corr()

        # 找出强相关关系
        strong_correlations = []
        for i in range(len(corr_matrix.columns)):
            for j in range(i+1, len(corr_matrix.columns)):
                corr_val = corr_matrix.iloc[i, j]
                if abs(corr_val) > 0.7:  # 强相关阈值
                    strong_correlations.append({
                        "col1": corr_matrix.columns[i],
                        "col2": corr_matrix.columns[j],
                        "correlation": round(corr_val, 4)
                    })

        return {
            "correlation_matrix": corr_matrix.to_dict(),
            "strong_correlations": strong_correlations
        }

    def _get_recommendations(self, data: pd.DataFrame) -> list:
        """生成分析建议"""
        recommendations = []

        # 缺失值建议
        missing_ratio = data.isnull().sum() / len(data)
        high_missing = missing_ratio[missing_ratio > 0.3]
        if len(high_missing) > 0:
            recommendations.append(f"注意：以下列缺失值超过30%: {high_missing.index.tolist()}")

        # 重复值建议
        duplicates = data.duplicated().sum()
        if duplicates > 0:
            recommendations.append(f"发现{duplicates}条重复记录，建议处理")

        # 相关性建议
        numeric_cols = data.select_dtypes(include=[np.number]).columns
        if len(numeric_cols) > 1:
            corr_matrix = data[numeric_cols].corr()
            high_corr_pairs = []
            for i in range(len(corr_matrix.columns)):
                for j in range(i+1, len(corr_matrix.columns)):
                    if abs(corr_matrix.iloc[i, j]) > 0.9:
                        high_corr_pairs.append((corr_matrix.columns[i], corr_matrix.columns[j]))

            if high_corr_pairs:
                recommendations.append(f"发现高度相关的列对: {high_corr_pairs}，考虑特征选择")

        return recommendations


# 使用示例
if __name__ == "__main__":
    # 创建测试数据
    test_data = {
        'A': [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        'B': [2, 4, 6, 8, 10, 12, 14, 16, 18, 20],
        'C': [1, 3, 5, 7, 9, 11, 13, 15, 17, 19],
        'D': [10, 20, 30, 40, 50, 60, 70, 80, 90, 100],
        'E': ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j']
    }
    df = pd.DataFrame(test_data)
    df.to_csv('/Users/zhengss/AI_Learning/2026-03-12/test_data.csv', index=False)

    # 执行分析
    skill = DataAnalysisSkill()
    result = skill.execute('/Users/zhengss/AI_Learning/2026-03-12/test_data.csv')

    print(json.dumps(result, indent=2, ensure_ascii=False))
```

---

## 📈 Skill 2: 数据可视化Skill

### 功能描述
自动生成数据可视化图表，支持多种图表类型和自动推荐。

### 完整代码

```python
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
from typing import Dict, Any, Optional, List
import json

class VisualizationSkill:
    """
    数据可视化Skill
    功能：智能生成数据可视化图表
    """

    def __init__(self):
        self.name = "visualization"
        self.description = "自动生成数据可视化图表"
        self.version = "1.0"

        # 设置中文字体
        plt.rcParams['font.sans-serif'] = ['Arial Unicode MS', 'SimHei']
        plt.rcParams['axes.unicode_minus'] = False

        # 设置图表样式
        sns.set_style("whitegrid")
        sns.set_palette("husl")

    def execute(self, data_path: str, chart_type: str = "auto", **kwargs) -> Dict[str, Any]:
        """
        执行可视化

        Args:
            data_path: 数据文件路径
            chart_type: 图表类型 ('auto', 'histogram', 'scatter', 'box', 'bar', 'line', 'heatmap')
            kwargs: 其他参数（如x_column, y_column, title, save_path）

        Returns:
            可视化结果
        """
        try:
            # 加载数据
            data = self._load_data(data_path)

            # 智能推荐图表类型
            if chart_type == "auto":
                chart_type = self._recommend_chart_type(data)

            # 生成图表
            result = self._create_chart(data, chart_type, **kwargs)

            return {
                "success": True,
                "data": result,
                "message": f"已生成{chart_type}图表"
            }

        except Exception as e:
            return {
                "success": False,
                "error": str(e),
                "message": f"可视化失败: {str(e)}"
            }

    def _load_data(self, data_path: str) -> pd.DataFrame:
        """加载数据"""
        if data_path.endswith('.csv'):
            return pd.read_csv(data_path)
        elif data_path.endswith('.xlsx') or data_path.endswith('.xls'):
            return pd.read_excel(data_path)
        else:
            raise ValueError(f"不支持的数据格式: {data_path}")

    def _recommend_chart_type(self, data: pd.DataFrame) -> str:
        """智能推荐图表类型"""
        numeric_cols = data.select_dtypes(include=[np.number]).columns
        categorical_cols = data.select_dtypes(include=['object']).columns

        # 根据数据特征推荐
        if len(numeric_cols) >= 2:
            return "scatter"  # 散点图
        elif len(categorical_cols) >= 1 and len(numeric_cols) >= 1:
            return "box"  # 箱线图
        elif len(categorical_cols) >= 1:
            return "bar"  # 柱状图
        else:
            return "histogram"  # 直方图

    def _create_chart(self, data: pd.DataFrame, chart_type: str, **kwargs) -> Dict:
        """创建图表"""
        x_col = kwargs.get('x_column')
        y_col = kwargs.get('y_column')
        title = kwargs.get('title', f'{chart_type.capitalize()} Chart')
        save_path = kwargs.get('save_path')

        fig, axes = plt.subplots(2, 2, figsize=(16, 12))
        axes = axes.flatten()

        # 1. 数据分布（直方图）
        numeric_cols = data.select_dtypes(include=[np.number]).columns
        if len(numeric_cols) > 0:
            self._create_distribution_plot(axes[0], data, numeric_cols)

        # 2. 主要图表
        if chart_type == "scatter":
            self._create_scatter_plot(axes[1], data, x_col, y_col, numeric_cols)
        elif chart_type == "histogram":
            self._create_histogram(axes[1], data, numeric_cols)
        elif chart_type == "box":
            self._create_box_plot(axes[1], data, x_col, y_col, numeric_cols, categorical_cols)
        elif chart_type == "bar":
            self._create_bar_plot(axes[1], data, x_col, y_col, categorical_cols)
        elif chart_type == "line":
            self._create_line_plot(axes[1], data, x_col, y_col, numeric_cols)
        elif chart_type == "heatmap":
            self._create_heatmap(axes[1], data, numeric_cols)

        # 3. 相关性热力图
        if len(numeric_cols) >= 2:
            self._create_correlation_heatmap(axes[2], data, numeric_cols)

        # 4. 缺失值可视化
        self._create_missing_plot(axes[3], data)

        plt.suptitle(title, fontsize=16, fontweight='bold', y=0.995)
        plt.tight_layout()

        # 保存图表
        if save_path:
            plt.savefig(save_path, dpi=300, bbox_inches='tight')
            return {"chart_path": save_path, "chart_type": chart_type}
        else:
            return {"chart_type": chart_type, "message": "图表已生成（未保存）"}

    def _create_distribution_plot(self, ax, data: pd.DataFrame, cols):
        """创建分布图"""
        if len(cols) > 0:
            data[cols].hist(ax=ax, bins=20, edgecolor='black', alpha=0.7)
            ax.set_title('数据分布', fontsize=12, fontweight='bold')
            ax.set_xlabel('数值')
            ax.set_ylabel('频数')

    def _create_scatter_plot(self, ax, data: pd.DataFrame, x_col, y_col, numeric_cols):
        """创建散点图"""
        if x_col and y_col:
            ax.scatter(data[x_col], data[y_col], alpha=0.6, s=50)
            ax.set_xlabel(x_col, fontsize=10)
            ax.set_ylabel(y_col, fontsize=10)
        elif len(numeric_cols) >= 2:
            ax.scatter(data[numeric_cols[0]], data[numeric_cols[1]], alpha=0.6, s=50)
            ax.set_xlabel(numeric_cols[0], fontsize=10)
            ax.set_ylabel(numeric_cols[1], fontsize=10)

        ax.set_title('散点图', fontsize=12, fontweight='bold')

    def _create_box_plot(self, ax, data: pd.DataFrame, x_col, y_col, numeric_cols, categorical_cols):
        """创建箱线图"""
        if y_col and len(categorical_cols) > 0:
            x_col = x_col if x_col else categorical_cols[0]
            sns.boxplot(data=data, x=x_col, y=y_col, ax=ax)
            ax.set_xlabel(x_col, fontsize=10)
            ax.set_ylabel(y_col, fontsize=10)
        elif len(numeric_cols) > 0:
            data[numeric_cols].boxplot(ax=ax)
            ax.set_xlabel('变量', fontsize=10)

        ax.set_title('箱线图', fontsize=12, fontweight='bold')

    def _create_correlation_heatmap(self, ax, data: pd.DataFrame, numeric_cols):
        """创建相关性热力图"""
        corr = data[numeric_cols].corr()
        sns.heatmap(corr, annot=True, fmt='.2f', cmap='coolwarm',
                   center=0, square=True, linewidths=1, ax=ax)
        ax.set_title('相关性热力图', fontsize=12, fontweight='bold')

    def _create_missing_plot(self, ax, data: pd.DataFrame):
        """创建缺失值可视化"""
        missing = data.isnull().sum()
        if missing.sum() > 0:
            missing.plot(kind='bar', color='coral', ax=ax)
            ax.set_title('缺失值统计', fontsize=12, fontweight='bold')
            ax.set_xlabel('列名', fontsize=10)
            ax.set_ylabel('缺失数量', fontsize=10)
        else:
            ax.text(0.5, 0.5, '无缺失值', ha='center', va='center',
                    fontsize=16, transform=ax.transAxes)
            ax.set_title('缺失值统计', fontsize=12, fontweight='bold')


# 使用示例
if __name__ == "__main__":
    # 创建测试数据
    np.random.seed(42)
    test_data = {
        'Sales': np.random.normal(1000, 200, 100),
        'Marketing': np.random.normal(500, 100, 100),
        'Product': np.random.choice(['A', 'B', 'C'], 100),
        'Region': np.random.choice(['North', 'South', 'East', 'West'], 100)
    }
    df = pd.DataFrame(test_data)
    df.to_csv('/Users/zhengss/AI_Learning/2026-03-12/test_viz_data.csv', index=False)

    # 执行可视化
    skill = VisualizationSkill()
    result = skill.execute(
        '/Users/zhengss/AI_Learning/2026-03-12/test_viz_data.csv',
        chart_type='auto',
        title='销售数据分析',
        save_path='/Users/zhengss/AI_Learning/2026-03-12/visualization.png'
    )

    print(json.dumps(result, indent=2, ensure_ascii=False))
```

---

## 🤖 Skill 3: Agent集成Skill

### 功能描述
将上述Skill集成到AI Agent系统中，实现智能数据分析Agent。

### 完整代码

```python
import pandas as pd
from typing import Dict, Any, List, Optional
import json

# 导入之前实现的Skill
from data_analysis_skill import DataAnalysisSkill
from visualization_skill import VisualizationSkill

class DataAnalysisAgent:
    """
    数据分析智能体
    功能：自动执行数据分析任务
    """

    def __init__(self):
        self.name = "数据分析Agent"
        self.version = "1.0"

        # 注册Skill
        self.skills = {
            "data_analysis": DataAnalysisSkill(),
            "visualization": VisualizationSkill()
        }

        # 任务规划器
        self.task_planner = TaskPlanner()

        # 记忆系统
        self.memory = ConversationMemory()

    def process_request(self, user_request: str, data_path: str) -> Dict[str, Any]:
        """
        处理用户请求

        Args:
            user_request: 用户的自然语言请求
            data_path: 数据文件路径

        Returns:
            处理结果
        """
        try:
            # 1. 理解请求
            intent = self._understand_request(user_request)

            # 2. 规划任务
            tasks = self.task_planner.plan(intent, data_path)

            # 3. 执行任务
            results = []
            for task in tasks:
                result = self._execute_task(task)
                results.append(result)

            # 4. 生成响应
            response = self._generate_response(intent, results)

            return {
                "success": True,
                "intent": intent,
                "results": results,
                "response": response
            }

        except Exception as e:
            return {
                "success": False,
                "error": str(e),
                "message": f"处理失败: {str(e)}"
            }

    def _understand_request(self, request: str) -> Dict[str, Any]:
        """理解用户请求"""
        request = request.lower()

        intent = {
            "request": request,
            "skills_needed": [],
            "parameters": {}
        }

        # 检测需要的Skill
        if any(keyword in request for keyword in ['分析', '统计', '描述', '摘要']):
            intent["skills_needed"].append("data_analysis")

        if any(keyword in request for keyword in ['可视化', '图表', '画图', '展示']):
            intent["skills_needed"].append("visualization")

        # 提取参数
        if '直方图' in request:
            intent["parameters"]["chart_type"] = "histogram"
        elif '散点图' in request:
            intent["parameters"]["chart_type"] = "scatter"
        elif '箱线图' in request:
            intent["parameters"]["chart_type"] = "box"

        return intent

    def _execute_task(self, task: Dict[str, Any]) -> Dict[str, Any]:
        """执行单个任务"""
        skill_name = task["skill"]
        skill = self.skills.get(skill_name)

        if not skill:
            return {
                "success": False,
                "error": f"找不到Skill: {skill_name}"
            }

        return skill.execute(**task["parameters"])

    def _generate_response(self, intent: Dict, results: List[Dict]) -> str:
        """生成响应"""
        response_parts = []

        # 添加总结
        response_parts.append("## 分析完成")
        response_parts.append(f"你的请求: {intent['request']}")
        response_parts.append(f"执行的Skill: {', '.join(intent['skills_needed'])}")
        response_parts.append("")

        # 添加结果摘要
        for i, result in enumerate(results, 1):
            if result["success"]:
                response_parts.append(f"### Skill {i}: {result.get('message', '完成')}")
                # 添加关键发现
                if "data" in result and "recommendations" in result["data"]:
                    recommendations = result["data"]["recommendations"]
                    if recommendations:
                        response_parts.append("**关键发现:**")
                        for rec in recommendations:
                            response_parts.append(f"- {rec}")
            else:
                response_parts.append(f"### Skill {i}: 失败")
                response_parts.append(f"错误: {result.get('error', '未知错误')}")

        return "\n".join(response_parts)


class TaskPlanner:
    """任务规划器"""

    def plan(self, intent: Dict, data_path: str) -> List[Dict]:
        """规划任务序列"""
        tasks = []

        for skill_name in intent["skills_needed"]:
            task = {
                "skill": skill_name,
                "parameters": {
                    "data_path": data_path,
                    **intent.get("parameters", {})
                }
            }
            tasks.append(task)

        return tasks


class ConversationMemory:
    """对话记忆系统"""

    def __init__(self):
        self.history = []

    def add(self, request: str, response: str):
        """添加对话"""
        self.history.append({
            "timestamp": pd.Timestamp.now(),
            "request": request,
            "response": response
        })

    def get_recent(self, n: int = 3) -> List[Dict]:
        """获取最近的对话"""
        return self.history[-n:] if len(self.history) >= n else self.history


# 使用示例
if __name__ == "__main__":
    # 创建Agent
    agent = DataAnalysisAgent()

    # 测试数据
    import numpy as np
    np.random.seed(42)
    test_data = {
        'Sales': np.random.normal(1000, 200, 100),
        'Marketing': np.random.normal(500, 100, 100),
        'Product': np.random.choice(['A', 'B', 'C'], 100),
        'Region': np.random.choice(['North', 'South', 'East', 'West'], 100)
    }
    df = pd.DataFrame(test_data)
    df.to_csv('/Users/zhengss/AI_Learning/2026-03-12/agent_test_data.csv', index=False)

    # 测试请求
    requests = [
        "请分析这个数据文件",
        "给我做数据分析和可视化",
        "生成数据统计和散点图"
    ]

    for req in requests:
        print(f"\n{'='*50}")
        print(f"用户请求: {req}")
        print('='*50)

        result = agent.process_request(req, '/Users/zhengss/AI_Learning/2026-03-12/agent_test_data.csv')

        if result["success"]:
            print(result["response"])
        else:
            print(f"处理失败: {result.get('error')}")
```

---

## 🚀 实践步骤

### 步骤1: 运行数据分析Skill
```bash
cd /Users/zhengss/AI_Learning/2026-03-12
python3 -c "
import pandas as pd
import numpy as np

# 创建测试数据
np.random.seed(42)
data = {
    'A': np.random.normal(100, 15, 100),
    'B': np.random.normal(200, 30, 100),
    'C': np.random.normal(300, 50, 100),
    'D': np.random.choice(['X', 'Y', 'Z'], 100)
}
df = pd.DataFrame(data)
df.to_csv('test_data.csv', index=False)
print('测试数据已创建')
"
```

### 步骤2: 执行分析
```python
# 在Python中运行
from practice_tasks import DataAnalysisSkill

skill = DataAnalysisSkill()
result = skill.execute('test_data.csv')
print(result)
```

### 步骤3: 生成可视化
```python
# 在Python中运行
from practice_tasks import VisualizationSkill

skill = VisualizationSkill()
result = skill.execute(
    'test_data.csv',
    chart_type='auto',
    title='数据分析可视化',
    save_path='analysis_charts.png'
)
print(result)
```

### 步骤4: 测试Agent集成
```python
# 在Python中运行
from practice_tasks import DataAnalysisAgent

agent = DataAnalysisAgent()
result = agent.process_request(
    '请分析这个数据并生成可视化',
    'test_data.csv'
)
print(result['response'])
```

---

## 📝 学习检查清单

完成以下任务来验证你的学习：

- [ ] **Skill 1**: 运行数据分析Skill，查看统计结果
- [ ] **Skill 2**: 生成数据可视化图表
- [ ] **Skill 3**: 测试Agent集成，处理自然语言请求
- [ ] **修改代码**: 尝试修改某个Skill的功能
- [ ] **添加新Skill**: 创建一个简单的自定义Skill
- [ ] **记录笔记**: 记录每个Skill的核心功能和实现细节

---

## 🎓 核心知识点

通过今天的实践，你应该掌握：

1. **Skill架构设计**
   - 标准化接口
   - 错误处理
   - 结果格式化

2. **数据分析技术**
   - 描述性统计
   - 数据质量检查
   - 相关性分析

3. **可视化技术**
   - 自动图表推荐
   - 多维度可视化
   - 美学设计

4. **Agent集成**
   - 意图识别
   - 任务规划
   - 响应生成

---

*今日实践内容已完成！继续加油！* 💪🚀