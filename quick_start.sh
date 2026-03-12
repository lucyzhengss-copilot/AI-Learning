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
