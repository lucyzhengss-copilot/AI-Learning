#!/bin/bash

# AI学习计划脚本 - 修复版
# 使用方法: ./ai-study.sh 或 ai-study (如果设置了别名)

set -e

# 学习目录
LEARNING_DIR="$HOME/AI_Learning"
TODAY_DIR="$LEARNING_DIR/$(date +%Y-%m-%d)"
LOG_FILE="$LEARNING_DIR/logs/$(date +%Y-%m).log"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 获取星期几和主题
get_weekday() {
    case $(date +%u) in
        1) echo "周一-基础理论" ;;
        2) echo "周二-框架工具" ;;
        3) echo "周三-论文研读" ;;
        4) echo "周四-实践项目" ;;
        5) echo "周五-社区互动" ;;
        6) echo "周六-综合复习" ;;
        7) echo "周日-规划展望" ;;
        *) echo "自由学习" ;;
    esac
}

# 创建目录
mkdir -p "$TODAY_DIR"
cd "$TODAY_DIR"

# 开始
echo ""
echo "🎯 AI学习计划"
echo "============="
log "开始学习: $(get_weekday)"

# 创建学习日志
cat > learning_log.md << 'EOF'
## 日期：YYYY-MM-DD 学习日志
### 今日主题：[主题]

### 学习目标
- [ ] 目标1
- [ ] 目标2
- [ ] 目标3

### 学习内容
1. **模块一**
   > [笔记]

2. **模块二**
   > [笔记]

### 实践项目
- [ ] 完成功能
- [ ] 代码实现

### 学习心得
> [收获和感悟]

### 明日计划
> [明天安排]

---
EOF

# 获取论文推荐
echo ""
echo "📖 最新论文推荐："
if command -v curl &> /dev/null; then
    curl -s "https://arxiv.org/list/cs.AI.recent" 2>/dev/null | \
    grep -o 'title="[^"]*"' | head -3 | \
    sed 's/title="//g' | sed 's/"//g' || \
    echo "1. Attention Is All You Need (2017)" \
    echo "2. BERT: Pre-training of Deep Bidirectional Transformers" \
    echo "3. GPT-3: Language Models are Few-Shot Learners"
else
    echo "1. Attention Is All You Need (2017)" \
    echo "2. BERT: Pre-training of Deep Bidirectional Transformers" \
    echo "3. GPT-3: Language Models are Few-Shot Learners"
fi

# 生成今日报告
cat > today_report.md << EOF
# 今日学习报告
- 日期：$(date)
- 主题：$(get_weekday)
- 进度：进行中

## 任务清单
- [ ] 完成论文阅读
- [ ] 记录学习笔记
- [ ] 实践相关代码

## 心得总结
> [记录你的思考]

---
EOF

# Git提交和推送
if [ -d "$LEARNING_DIR/.git" ]; then
    cd "$LEARNING_DIR"
    git add "$TODAY_DIR" 2>/dev/null || true
    git commit -m "$(date +%Y-%m-%d) $(get_weekday)" 2>/dev/null || true
    log "已提交到本地Git"

    # 尝试推送到GitHub（可能会需要密码）
    if git push origin main 2>/dev/null; then
        log "✅ 已同步到GitHub"
    else
        log "⚠️  GitHub推送失败（可能需要配置SSH或输入密码）"
        log "可以手动执行：git push origin main"
    fi
fi

# 完成提示
echo ""
echo "✅ 学习日志已创建：$TODAY_DIR/learning_log.md"
echo "📊 学习报告已生成：$TODAY_DIR/today_report.md"
echo ""
echo "💡 开始你的学习之旅吧！"
echo ""