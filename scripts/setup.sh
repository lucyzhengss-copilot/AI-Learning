#!/bin/bash

# AI学习计划系统设置脚本
# 使用方法: ./setup.sh

set -e

echo "🚀 正在设置AI学习计划系统..."

# 创建必要的目录结构
echo "📁 创建目录结构..."
mkdir -p ~/AI_Learning/{logs,resources,projects,scripts,templates,notebooks}

# 设置脚本执行权限
echo "🔧 设置脚本权限..."
chmod +x ~/AI_Learning/scripts/*.sh

# 创建模板文件
echo "📝 创建学习日志模板..."
cat > ~/AI_Learning/templates/daily_template.md << 'EOF'
## YYYY-MM-DD 学习日志
### 今日主题：[填写]

### 学习目标
- [ ]
- [ ]
- [ ]

### 学习内容
#### 1. [模块名称]
> [记录学习内容]

#### 2. [模块名称]
> [记录学习内容]

### 实践项目
- 完成功能：[记录]
- 代码提交：[链接]

### 学习心得
> [今日收获和感悟]

### 明日计划
> [下一天的学习计划]
EOF

# 创建Git配置（如果需要）
if command -v git &> /dev/null; then
    echo "📦 初始化Git仓库..."
    cd ~/AI_Learning
    git init
    git config user.name "AI Learner"
    git config user.email "ai-learner@example.com"

    # 创建.gitignore
    cat > .gitignore << 'EOF'
logs/
*.log
__pycache__/
*.pyc
.venv/
.DS_Store
EOF

    git add .
    git commit -m "初始化AI学习系统" 2>/dev/null || true
    echo "✅ Git仓库已初始化"
fi

# 创建别名（可选）
echo "🔗 创建命令别名..."
if [ -f ~/.zshrc ]; then
    # 检查是否已添加别名
    if ! grep -q "ai-study" ~/.zshrc; then
        echo 'alias ai-study="~/AI_Learning/scripts/daily_learning.sh"' >> ~/.zshrc
        echo "✅ 已添加ai-study命令到 ~/.zshrc"
        echo "请执行 'source ~/.zshrc' 或重启终端使别名生效"
    fi
elif [ -f ~/.bashrc ]; then
    if ! grep -q "ai-study" ~/.bashrc; then
        echo 'alias ai-study="~/AI_Learning/scripts/daily_learning.sh"' >> ~/.bashrc
        echo "✅ 已添加ai-study命令到 ~/.bashrc"
        echo "请执行 'source ~/.bashrc' 或重启终端使别名生效"
    fi
fi

# 创建快捷方式脚本
cat > ~/AI_Learning/quick_start.sh << 'EOF'
#!/bin/bash
echo "🎯 AI学习计划系统"
echo "=================="
echo "1. 开始今日学习: ./scripts/daily_learning.sh"
echo "2. 查看学习日志: cat learning_log.md"
echo "3. 查看所有日志: find ~/AI_Learning -name "learning_log.md" -type f"
echo "4. Git提交: cd ~/AI_Learning && git add . && git commit -m \"学习记录\""
echo ""
echo "💡 提示：使用 'ai-study' 命令可快速启动学习"
echo ""
echo "正在启动今日学习..."
./scripts/daily_learning.sh
EOF

chmod +x ~/AI_Learning/quick_start.sh

# 设置定时任务（可选）
echo "⏰ 设置定时任务..."
echo "请在终端执行以下命令来设置每天早上8点自动执行："
echo ""
echo "1. 编辑crontab: crontab -e"
echo "2. 添加以下行："
echo "   0 8 * * * ~/AI_Learning/scripts/daily_learning.sh"
echo "3. 保存并退出"
echo ""
echo "注意：macOS可能需要在系统偏好设置 > 安全性与隐私 > 完整磁盘访问权限"
echo "中添加Terminal的权限才能执行定时任务。"

# 显示完成信息
echo ""
echo "🎉 AI学习计划系统设置完成！"
echo "================================"
echo ""
echo "使用方法："
echo "1. 手动执行: ~/AI_Learning/scripts/daily_learning.sh"
echo "2. 快速启动: ~/AI_Learning/quick_start.sh"
echo "3. 如果设置了别名: ai-study"
echo ""
echo "系统结构："
echo "📁 ~/AI_Learning/"
echo "  ├── 📂 logs/          # 学习日志"
echo "  ├── 📂 resources/     # 学习资源"
echo "  ├── 📂 projects/      # 实践项目"
echo "  ├── 📂 scripts/        # 脚本文件"
echo "  ├── 📂 templates/     # 模板文件"
echo "  ├── 📂 notebooks/     # Jupyter笔记本"
echo "  └── 📄 quick_start.sh  # 快速启动脚本"
echo ""
echo "祝你学习愉快！📚✨"