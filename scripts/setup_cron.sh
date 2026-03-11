#!/bin/bash

# AI学习计划定时任务设置脚本
# 使用方法: ./setup_cron.sh

echo "⏰ 设置AI学习计划定时任务..."

# 检查crontab命令
if ! command -v crontab &> /dev/null; then
    echo "❌ 错误: 系统中没有crontab命令"
    echo "请先安装crontab或使用手动执行方式"
    exit 1
fi

# 检查是否已有定时任务
if crontab -l 2>/dev/null | grep -q "daily_learning.sh"; then
    echo "⚠️  检测到已存在AI学习定时任务"
    echo "是否要覆盖？(y/n)"
    read -r response
    if [[ "$response" != "y" && "$response" != "Y" ]]; then
        echo "取消设置"
        exit 0
    fi
fi

# 创建临时crontab文件
TEMP_CRON=$(mktemp)

# 备份当前crontab
crontab -l > "$TEMP_CRON" 2>/dev/null || touch "$TEMP_CRON"

# 添加AI学习定时任务
echo "# AI学习计划 - 每天早上8点执行" >> "$TEMP_CRON"
echo "0 8 * * * $HOME/AI_Learning/scripts/daily_learning.sh >> $HOME/AI_Learning/logs/cron.log 2>&1" >> "$TEMP_CRON"

# 添加可选的周末提醒（周六上午9点）
echo "# 周末提醒 - 每周六上午9点" >> "$TEMP_CRON"
echo "0 9 * * 6 echo '今天是周六，记得完成AI学习计划哦！' | terminal-notifier -title 'AI学习提醒' -message '周六学习时间到！'" >> "$TEMP_CRON"

# 安装新的crontab
crontab "$TEMP_CRON"
rm "$TEMP_CRON"

echo "✅ 定时任务设置成功！"
echo ""
echo "已添加的定时任务："
echo "1. 每天早上8:00 - 执行AI学习计划"
echo "2. 每周六早上9:00 - 学习提醒（如果系统支持）"
echo ""
echo "查看定时任务：crontab -l"
echo "查看执行日志：tail -f ~/AI_Learning/logs/cron.log"
echo ""
echo "注意事项："
echo "- macOS用户需要在系统偏好设置 > 安全性与隐私 > 完整磁盘访问权限中"
echo "  添加Terminal的权限（勾选'自动化'）"
echo "- 如果使用M1/M2 Mac，可能需要在'访达'中允许脚本执行"