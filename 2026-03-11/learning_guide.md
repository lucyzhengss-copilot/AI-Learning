# AI论文研读详细指南

## 🎯 今日学习目标

### 1. 理解Transformer架构
- 掌握自注意力机制
- 理解多头注意力
- 学习位置编码
- 了解编码器-解码器结构

### 2. 学习预训练范式
- 理解BERT的预训练任务
- 掌握掩码语言建模
- 了解上下文表示

### 3. 实践代码
- 实现简单的注意力机制
- 构建Transformer编码器
- 训练小型语言模型

## 📚 深入学习内容

### 一、Transformer核心概念

#### 1.1 注意力机制
```python
# 简单的注意力实现示例
import torch
import torch.nn as nn
import math

class SimpleAttention(nn.Module):
    def __init__(self, d_model):
        super().__init__()
        self.d_model = d_model

    def forward(self, query, key, value):
        # 计算注意力分数
        scores = torch.matmul(query, key.transpose(-2, -1)) / math.sqrt(self.d_model)

        # Softmax归一化
        attention_weights = torch.softmax(scores, dim=-1)

        # 加权求和
        output = torch.matmul(attention_weights, value)

        return output, attention_weights
```

#### 1.2 多头注意力
```python
class MultiHeadAttention(nn.Module):
    def __init__(self, d_model, num_heads):
        super().__init__()
        self.d_model = d_model
        self.num_heads = num_heads
        self.head_dim = d_model // num_heads

        self.query_proj = nn.Linear(d_model, d_model)
        self.key_proj = nn.Linear(d_model, d_model)
        self.value_proj = nn.Linear(d_model, d_model)
        self.out_proj = nn.Linear(d_model, d_model)

    def forward(self, x):
        batch_size, seq_len, _ = x.shape

        # 投影到query、key、value
        Q = self.query_proj(x)
        K = self.key_proj(x)
        V = self.value_proj(x)

        # 分割多头
        Q = Q.view(batch_size, seq_len, self.num_heads, self.head_dim).transpose(1, 2)
        K = K.view(batch_size, seq_len, self.num_heads, self.head_dim).transpose(1, 2)
        V = V.view(batch_size, seq_len, self.num_heads, self.head_dim).transpose(1, 2)

        # 计算注意力
        attn_output = self.scaled_dot_product_attention(Q, K, V)

        # 合并多头
        attn_output = attn_output.transpose(1, 2).contiguous()
        attn_output = attn_output.view(batch_size, seq_len, self.d_model)

        # 最终输出
        output = self.out_proj(attn_output)

        return output
```

### 二、位置编码
```python
class PositionalEncoding(nn.Module):
    def __init__(self, d_model, max_seq_len=5000):
        super().__init__()

        pe = torch.zeros(max_seq_len, d_model)
        position = torch.arange(0, max_seq_len, dtype=torch.float).unsqueeze(1)
        div_term = torch.exp(torch.arange(0, d_model, 2).float() *
                           (-math.log(10000.0) / d_model))

        pe[:, 0::2] = torch.sin(position * div_term)
        pe[:, 1::2] = torch.cos(position * div_term)
        pe = pe.unsqueeze(0).transpose(0, 1)

        self.register_buffer('pe', pe)

    def forward(self, x):
        return x + self.pe[:x.size(0), :]

# 使用示例
d_model = 512
pos_encoder = PositionalEncoding(d_model)
encoded = pos_encoder(x)  # x是输入序列
```

### 三、完整的Transformer编码器
```python
class TransformerEncoderLayer(nn.Module):
    def __init__(self, d_model, num_heads, d_ff, dropout=0.1):
        super().__init__()
        self.self_attn = MultiHeadAttention(d_model, num_heads)
        self.feed_forward = nn.Sequential(
            nn.Linear(d_model, d_ff),
            nn.ReLU(),
            nn.Linear(d_ff, d_model)
        )
        self.norm1 = nn.LayerNorm(d_model)
        self.norm2 = nn.LayerNorm(d_model)
        self.dropout = nn.Dropout(dropout)

    def forward(self, x, mask=None):
        # 自注意力层
        attn_output, _ = self.self_attn(x, x, x)
        x = self.norm1(x + self.dropout(attn_output))

        # 前馈网络层
        ff_output = self.feed_forward(x)
        x = self.norm2(x + self.dropout(ff_output))

        return x

class TransformerEncoder(nn.Module):
    def __init__(self, num_layers, d_model, num_heads, d_ff, dropout=0.1):
        super().__init__()
        self.layers = nn.ModuleList([
            TransformerEncoderLayer(d_model, num_heads, d_ff, dropout)
            for _ in range(num_layers)
        ])
        self.norm = nn.LayerNorm(d_model)

    def forward(self, x, mask=None):
        for layer in self.layers:
            x = layer(x, mask)
        return self.norm(x)
```

### 四、BERT预训练任务示例

#### 1. 掩码语言建模 (MLM)
```python
class MaskedLanguageModeling:
    def __init__(self, tokenizer, mask_prob=0.15):
        self.tokenizer = tokenizer
        self.mask_prob = mask_prob

    def create_mlm_batch(self, sentences):
        batch = {
            'input_ids': [],
            'attention_mask': [],
            'labels': []
        }

        for sentence in sentences:
            # 分词
            tokens = self.tokenizer.tokenize(sentence)
            input_ids = self.tokenizer.convert_tokens_to_ids(tokens)

            # 随机掩码
            labels = input_ids.copy()
            for i in range(len(input_ids)):
                if random.random() < self.mask_prob:
                    input_ids[i] = self.tokenizer.mask_token_id

            batch['input_ids'].append(input_ids)
            batch['attention_mask'].append([1] * len(input_ids))
            batch['labels'].append(labels)

        return batch
```

#### 2. 下一句预测 (NSP)
```python
class NextSentencePrediction:
    def __init__(self, tokenizer):
        self.tokenizer = tokenizer
        self.sep_token = '[SEP]'
        self.cls_token = '[CLS]'

    def create_nsp_example(self, sentence_A, sentence_B, is_next):
        # 格式: [CLS] A [SEP] B [SEP]
        input_text = f"{self.cls_token} {sentence_A} {self.sep_token} {sentence_B} {self.sep_token}"
        input_ids = self.tokenizer.convert_tokens_to_ids(
            self.tokenizer.tokenize(input_text)
        )

        # NSP标签: 0-是连续句, 1-不是连续句
        nsp_label = 0 if is_next else 1

        return {
            'input_ids': input_ids,
            'nsp_label': nsp_label
        }
```

### 五、实践项目：小型语言模型

#### 1. 数据准备
```python
import torch
from torch.utils.data import Dataset, DataLoader

class TextDataset(Dataset):
    def __init__(self, texts, tokenizer, max_length=512):
        self.texts = texts
        self.tokenizer = tokenizer
        self.max_length = max_length

    def __len__(self):
        return len(self.texts)

    def __getitem__(self, idx):
        text = self.texts[idx]

        # 分词和编码
        encoding = self.tokenizer(
            text,
            truncation=True,
            padding='max_length',
            max_length=self.max_length,
            return_tensors='pt'
        )

        return {
            'input_ids': encoding['input_ids'].flatten(),
            'attention_mask': encoding['attention_mask'].flatten()
        }
```

#### 2. 模型训练
```python
def train_model(model, train_loader, optimizer, device, epochs=10):
    model.train()

    for epoch in range(epochs):
        total_loss = 0

        for batch in train_loader:
            input_ids = batch['input_ids'].to(device)
            attention_mask = batch['attention_mask'].to(device)

            # 清零梯度
            optimizer.zero_grad()

            # 前向传播
            outputs = model(input_ids, attention_mask=attention_mask)
            loss = outputs.loss

            # 反向传播
            loss.backward()
            optimizer.step()

            total_loss += loss.item()

        avg_loss = total_loss / len(train_loader)
        print(f'Epoch {epoch+1}/{epochs}, Loss: {avg_loss:.4f}')
```

### 六、学习建议

#### 1. 重点关注
- **数学基础**：理解注意力分数计算、Softmax机制
- **工程实现**：掌握PyTorch实现技巧
- **性能优化**：了解注意力计算的优化方法

#### 2. 实践建议
- 从简单开始，逐步构建完整模型
- 使用小数据集验证代码正确性
- 使用预训练模型进行对比实验

#### 3. 扩展学习
- 研究不同变体的Transformer（如Reformer、Performer）
- 了解模型并行训练技术
- 探索稀疏注意力机制

## 📋 学习进度跟踪

### ✅ 已掌握
- [ ] 注意力机制原理
- [ ] 多头注意力实现
- [ ] 位置编码作用
- [ ] Transformer架构

### 🎯 正在学习
- [ ] BERT预训练任务
- [ ] 代码实现细节
- [ ] 实际应用案例

### 🚀 下一步计划
- [ ] 完成小型语言模型训练
- [ ] 实现论文中的关键算法
- [ ] 写学习总结报告

---

*记得在学习过程中记录你的心得和疑问！*