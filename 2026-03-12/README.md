# AI实践项目指南 - 2026年3月12日

## 🎯 今日目标：开发数据分析Skill

这是一个完整的实践项目，包含三个核心技能的实现，帮助你从数据分析背景过渡到AI技能开发。

## 📁 项目文件结构

```
2026-03-12/
├── practice_tasks.md      # 核心代码实现（包含3个完整Skill）
├── test_data_generator.py # 测试数据生成器
├── run_practice.py        # 快速实践脚本
├── test_data/             # 生成的测试数据
│   ├── sales_data.csv     # 365条销售数据
│   ├── customer_data.csv  # 1000条客户数据
│   ├── employee_data.csv # 500条员工数据
│   └── missing_data.csv   # 带缺失值的数据
├── learning_log.md        # 学习任务清单
└── README.md             # 本文件
```

## 🚀 快速开始（3分钟上手）

### 1. 运行快速实践
```bash
# 在终端运行
python3 run_practice.py

# 会提示你选择要分析的数据文件
# 然后自动执行分析和可视化
```

### 2. 运行数据分析Skill
```python
# 启动Python解释器
python3

# 导入并运行
from practice_tasks import DataAnalysisSkill
skill = DataAnalysisSkill()
result = skill.execute('test_data/sales_data.csv')
print(result['data']['basic_info'])
```

## 🛠️ 技能详情

### Skill 1: DataAnalysisSkill
**功能**：智能数据分析
- 描述性统计
- 数据质量检查
- 相关性分析
- 智能建议生成

```python
# 使用示例
skill = DataAnalysisSkill()
result = skill.execute('test_data/sales_data.csv')

# 查看结果
print(result['data']['basic_info'])      # 基本信息
print(result['data']['statistics'])     # 统计分析
print(result['data']['recommendations']) # 智能建议
```

### Skill 2: VisualizationSkill
**功能**：自动数据可视化
- 智能图表推荐
- 多维度可视化
- 美学设计
- 自动保存

```python
# 使用示例
skill = VisualizationSkill()
result = skill.execute(
    'test_data/sales_data.csv',
    chart_type='auto',  # 自动推荐
    save_path='charts.png'
)
```

### Skill 3: DataAnalysisAgent
**功能**：智能对话分析
- 自然语言理解
- 任务自动规划
- 多技能协作
- 友好响应

```python
# 使用示例
agent = DataAnalysisAgent()
result = agent.process_request(
    "请分析销售数据并生成可视化图表",
    'test_data/sales_data.csv'
)
print(result['response'])
```

## 📊 数据集说明

### 销售数据 (`test_data/sales_data.csv`)
- 365条记录，时间跨度：2023年全年
- 字段：日期、销售额、营销支出、产品类别、地区、客户满意度
- 适合：时间序列分析、销售趋势、地区对比

### 客户数据 (`test_data/customer_data.csv`)
- 1000条客户记录
- 字段：年龄、收入、购买频率、总购买额、偏好类别
- 适合：客户分群、购买行为分析

### 员工数据 (`test_data/employee_data.csv`)
- 500条员工记录
- 字段：部门、职位、薪资、绩效评分、工作年限
- 适合：人力资源分析、薪酬结构

## 💡 学习路径

### 阶段1：快速体验（15分钟）
```bash
# 1. 运行快速实践
python3 run_practice.py

# 2. 查看生成的图表
open analysis_charts.png
```

### 阶段2：深入理解（30分钟）
```python
# 1. 仔细阅读代码
cat practice_tasks.md

# 2. 修改参数测试
from practice_tasks import DataAnalysisSkill
skill = DataAnalysisSkill()
result = skill.execute('test_data/customer_data.csv')
```

### 阶段3：扩展开发（60分钟）
```python
# 1. 添加新功能
class CustomSkill:
    def execute(self, data_path):
        # 你的自定义分析
        pass

# 2. 扩展Agent
agent.skills['custom'] = CustomSkill()
```

## 🔧 核心概念

### Skill架构设计
```
Skill Interface
├── __init__()           - 初始化配置
├── execute()            - 主执行接口
├── _load_data()         - 数据加载
├── _analyze_data()      - 核心分析
└── _format_result()     - 结果格式化
```

### Agent工作流程
```
用户输入 → 意图识别 → 任务规划 → 执行技能 → 生成响应
```

### 错误处理模式
- 输入验证
- 异常捕获
- 优雅降级
- 详细日志

## 🎓 学习收获

通过今天的实践，你将掌握：

1. **Skill开发模式**
   - 标准化接口设计
   - 参数传递机制
   - 结果格式化

2. **数据分析技术**
   - 描述性统计
   - 数据质量检查
   - 相关性分析

3. **可视化技术**
   - 自动图表推荐
   - 多图布局
   - 图表美化

4. **Agent架构**
   - 意图识别
   - 任务规划
   - 响应生成

## 🚀 进阶挑战

### 挑战1：创建预测分析Skill
```python
class PredictiveSkill:
    def execute(self, data_path):
        # 实现时间序列预测
        # 使用简单的线性回归
        pass
```

### 挑战2：增强Agent对话能力
```python
def understand_natural_language(self, text):
    # 更复杂的NLU
    # 支持模糊查询
    # 上下文理解
    pass
```

### 挑战3：集成机器学习模型
```python
class MLAnalysisSkill:
    def execute(self, data_path):
        # 集成sklearn模型
        # 分类/回归/聚类
        pass
```

## 📋 完成检查清单

- [ ] 运行快速实践脚本
- [ ] 理解三个Skill的实现
- [ ] 修改代码并测试
- [ ] 扩展新功能
- [ ] 记录学习心得
- [ ] 推送到GitHub

## 🎉 成果展示

完成今天的项目，你将拥有：

1. 3个完整的可复用Skill
2. 实际的项目代码
3. 测试数据集
4. 生成的分析报告和图表
5. GitHub代码仓库

---

开始你的实践之旅吧！🚀💪