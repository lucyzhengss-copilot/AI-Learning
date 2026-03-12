#!/bin/bash

# 简化的每日学习脚本
# 修复了原脚本的语法错误

set -e

# 学习目录
LEARNING_DIR="$HOME/AI_Learning"
TODAY_DIR="$LEARNING_DIR/$(date +%Y-%m-%d)"
LOG_FILE="$LEARNING_DIR/logs/$(date +%Y-%m).log"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 获取星期几
get_weekday_cn() {
    case $(date +%u) in
        1) echo "周一" ;;
        2) echo "周二" ;;
        3) echo "周三" ;;
        4) echo "周四" ;;
        5) echo "周五" ;;
        6) echo "周六" ;;
        7) echo "周日" ;;
        *) echo "未知" ;;
    esac
}

# 获取今日主题
get_learning_topic() {
    weekday=$(date +%u)
    case $weekday in
        1) echo "基础理论" ;;
        2) echo "框架与工具" ;;
        3) echo "论文研读" ;;
        4) echo "实践项目" ;;
        5) echo "社区互动" ;;
        6) echo "综合复习" ;;
        7) echo "规划与展望" ;;
        *) echo "自由学习" ;;
    esac
}

# 创建目录
mkdir -p "$TODAY_DIR"
cd "$TODAY_DIR"

# 开始学习
log "===== 开始今日学习 ====="
log "今天是：$(date +%Y年%m月%d日) $(get_weekday_cn)"
log "学习主题：$(get_learning_topic)"

# 创建学习日志
cat > learning_log.md << EOF
## $(date +%Y-%m-%d) 学习日志
### 今日主题：$(get_learning_topic)

### 学习目标
- [ ] 精读一篇最新论文
- [ ] 学习论文核心方法
- [ ] 记录学习笔记

### 1. 论文选择与阅读（25分钟）
#### 选中论文
- 标题：
- 作者：
- 链接：

#### 核心贡献
> [记录论文主要贡献]

#### 方法摘要
> [记录核心方法]

### 2. 夞现代码（20分钟）
#### 实现代码
> [在此实现论文核心方法]

### 3. 学习总结
> [记录今日学习心得]

#### 收获
- [ ]
- [ ]

#### 疑问
- [ ]
- [ ]

### 学习进度
- 开始时间：$(date)
EOF

# 获取最新论文示例
log "获取最新AI论文..."
if command -v curl &> /dev/null; then
    echo ""
    echo "📖 最新AI论文推荐："
    curl -s "https://arxiv.org/list/cs.AI.recent" | grep -o 'title="[^"]*"' | head -5 | sed 's/title="//g' | sed 's/"//g'
    echo ""
fi

# 生成学习报告
cat > learning_report.md << EOF
# $(date +%Y-%m-%d) 学习报告

- 日期：$(date)
- 星期：$(get_weekday_cn)
- 主题：$(get_learning_topic)

## 今日任务
- [ ] 精读论文
- [ ] 学习方法
- [ ] 记录笔记

## 学习心得
> [记录你的收获和感悟]

## 后续行动
- [ ] 复习论文内容
- [ ] 查看相关文献
- [ ] 尝试实现方法

---
*AI学习计划自动生成*
EOF

# Git提交（可选）
if [ -d "$LEARNING_DIR/.git" ]; then
    cd "$LEARNING_DIR"
    git add "$TODAY_DIR" 2>/dev/null || true
    git commit -m "$(date +%Y-%m-%d) AI学习记录: $(get_learning_topic)" 2>/dev/null || true
    log "学习记录已提交到Git"
fi

# 完成提示
echo ""
echo "🎉 今日学习任务完成！"
echo "学习日志已保存到: $TODAY_DIR/learning_log.md"
echo "请继续完成学习任务..."
echo ""

log "===== 学习任务完成 ====="