# AI技术每日学习计划

🎯 一套完整的AI技术学习系统，帮助你从数据分析背景系统性地学习大语言模型、AI助手、AI Agent等前沿技术。

## 🚀 快速开始

### 1. 首次设置（只需一次）

```bash
# 进入脚本目录
cd ~/AI_Learning/scripts

# 运行设置脚本
./setup.sh
```

### 2. 设置定时任务（可选）

```bash
# 设置每天早上8点自动执行学习计划
./setup_cron.sh
```

### 3. 开始学习

```bash
# 方法1：使用快速启动脚本
cd ~/AI_Learning
./quick_start.sh

# 方法2：直接执行学习脚本
./scripts/daily_learning.sh

# 方法3：使用命令别名（如果已设置）
ai-study
```

## 📋 系统特点

### ✅ 智能任务调度
- **周一**：基础理论巩固
- **周二**：框架与工具更新
- **周三**：最新论文研读
- **周四**：实践项目开发
- **周五**：社区互动参与
- **周六**：综合复习梳理
- **周日**：下周规划展望

### 📚 完整的学习体验
- 自动创建学习日志模板
- Git版本控制学习记录
- 定时提醒和任务管理
- 社区资源整合

### 🛠️ 技术栈
- **Shell脚本**：自动化任务执行
- **Git**：版本控制和备份
- **Crontab**：定时任务调度
- **Markdown**：学习记录格式

## 📁 目录结构

```
AI_Learning/
├── logs/              # 学习日志
├── resources/         # 学习资源
├── projects/          # 实践项目
├── scripts/           # 脚本文件
│   ├── daily_learning.sh      # 主要学习脚本
│   ├── setup.sh              # 系统设置脚本
│   └── setup_cron.sh         # 定时任务设置
├── templates/         # 模板文件
├── notebooks/         # Jupyter笔记本
├── quick_start.sh     # 快速启动脚本
└── README.md          # 说明文档
```

## 📖 每日学习内容

### 基础理论（周一）
- 深度学习基础概念
- NLP核心原理
- 数学基础回顾

### 框架与工具（周二）
- PyTorch/TensorFlow更新
- HuggingFace新特性
- 开发工具链实践

### 论文研读（周三）
- ArXiv最新论文
- 经典论文精读
- 论文复现尝试

### 实践项目（周四）
- Skill开发
- Agent系统集成
- 项目实战

### 社区互动（周五）
- GitHub贡献
- 技术论坛参与
- 开源项目协作

### 综合复习（周六）
- 知识梳理
- 习题练习
- 思维导图构建

### 规划展望（周日）
- 学习总结
- 效果评估
- 下周计划

## 💡 使用技巧

### 1. 定制化学习
编辑 `daily_learning.sh` 文件中的学习内容，根据个人需求调整。

### 2. 学习记录管理
```bash
# 查看所有学习日志
find ~/AI_Learning -name "learning_log.md" -type f

# 查看特定日期日志
cat ~/AI_Learning/2024-01-01/learning_log.md

# Git提交学习记录
cd ~/AI_Learning
git add .
git commit -m "学习记录: [主题]"
```

### 3. 环境配置
确保系统支持：
- Shell脚本执行
- Git版本控制
- 定时任务（可选）

## ⚠️ 常见问题

### 1. 权限问题
```bash
# 给脚本执行权限
chmod +x ~/AI_Learning/scripts/*.sh
```

### 2. 定时任务不执行
- 检查crontab设置：`crontab -l`
- 检查日志：`tail -f ~/AI_Learning/logs/cron.log`
- macOS用户需要在系统偏好设置中开启终端的自动化权限

### 3. Git相关问题
- 初始化Git：`cd ~/AI_Learning && git init`
- 配置用户信息：`git config user.name "Your Name"`
- 配置邮箱：`git config user.email "your@email.com"`

## 🎯 学习建议

1. **坚持规律学习**：每天固定时间学习，培养习惯
2. **动手实践**：不只是看，要多写代码
3. **输出倒逼输入**：通过分享和教学巩固知识
4. **记录思考**：记录学到了什么，更重要的是怎么学的
5. **社区参与**：积极与AI社区交流

## 🌟 进阶功能

### 1. 添加自定义学习内容
编辑 `daily_learning.sh` 中的对应函数，添加你的学习任务。

### 2. 集成其他工具
可以集成：
- Jupyter笔记本
- VS Code任务
- 其他AI工具

### 3. 学习数据分析
学习记录都是Markdown格式，可以用数据分析工具进行：
- 学习时长统计
- 知识点图谱
- 进度可视化

## 📞 支持

遇到问题？欢迎：
1. 查看日志文件：`~/AI_Learning/logs/`
2. 查看脚本注释
3. 自行修改脚本以适应需求

---

开始你的AI学习之旅吧！🚀📚