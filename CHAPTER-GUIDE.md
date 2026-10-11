# 单章作业指南

每一章由四个阶段接力完成。每个阶段的执行者只做自己那一阶段的事，证据各自独立取用。

工作目录：本项目根目录（即本文件所在目录）。

## 一、先读这些文件

动手之前必须读完：

1. `glossary/TERMINOLOGY.md` —— 译名标准、行文规范、Typst 数学写法、版式宏用法。这是全书的执行标准。
2. `glossary/notation.typ` —— 符号表中文版。所有符号的中文叫法与排版写法以此为准。
3. `template.typ` —— 版式宏。翻译阶段要用的 `chapter`、`example`、`exercise`、`figure` 用法都在里面。
4. `work/chapter-map.json` —— 章节与 PDF 页码的对应关系。

## 二、源文件的已知损坏与修复规则

源 PDF 由 LaTeX 生成后经 macOS Quartz 重新导出，文字层在正文与数学上的可靠性完全不同。

### 正文可以提取，但要修连字

正文文字可靠，唯一的问题是连字符号损坏：

- `↵` 是 `ff` 连字，出现在正文里一律读作 `ff`。例如 `e↵ect` 是 `effect`，`di↵erence` 是 `difference`。
- `ﬁ` `ﬂ` `ﬃ` 分别是 `fi` `fl` `ffi` 连字，替换为对应字母。
- 连字有时整体丢失，出现 `O ce` 这样的缺字（原词是 `Office`）。这类缺字必须对照页面渲染图补回，不能凭空猜测。
- `’` 是右单引号。

### 数学不能从文字层读

数学字体子集化后，希腊字母在文字层里整体丢失或错误映射：

| 原符号 | 文字层里的样子 |
|---|---|
| ∈ | 2 |
| ⊂ | ⇢ |
| → | ! |
| ≈ | ⇡ |
| π | ⇡ |
| ∼ | ⇠ |
| α | ↵ |
| β、γ、λ、δ、θ、ε | 丢失，什么都不剩 |

**所有公式必须逐条对照页面渲染图重建，不许参考文字层提取出的数学片段。** 注意 `↵` 在正文里是 `ff`，在数学里是 `α`；`⇡` 既可能是 `≈` 也可能是 `π`。工具已经给每个文本片段标注了字体类别，`⟪text:...⟫` 是正文，`⟪math:...⟫` 是数学，据此区分。

### 写 Typst 数学时的强制规则：下标后留空格

Typst 会把紧跟在下标后面的圆括号或方括号吞进下标，渲染出完全错误的公式。写 `math.md` 时就要遵守：

- `$Q_t (s, a)$` 对，`$Q_t(s, a)$` 错
- `$v_pi (s)$` 对，`$v_pi(s)$` 错
- `$q_* (a)$` 对，`$q_*(a)$` 错
- `$bb(E)_b [X]$` 对，`$bb(E)_b[X]$` 错

规则：下标是单独的标识符或符号（`t`、`*`、`pi`、`b` 之类），后面紧跟 `(` 或 `[` 时，中间必须留一个空格。拿不准就一律加空格，加了没有副作用。详见 `glossary/TERMINOLOGY.md` 的「下标后必须留空格」一节。

## 三、工具

### PDF 提取与渲染

```
uv run tools/pdfkit.py outline                         # 书签树与页码
uv run tools/pdfkit.py text --page N                   # 单页文字，标注每个片段的字体类别
uv run tools/pdfkit.py blocks --page N                 # 页面内文字块、位图块、矢量图形块的边界框
uv run tools/pdfkit.py find --page N --text "Figure 2.5"   # 定位字符串
uv run tools/pdfkit.py figure-regions --page N         # 该页候选插图区域
uv run tools/pdfkit.py crop --page N --bbox "x0,y0,x1,y1" --pad 2 --dpi 400 --out 路径.png
uv run tools/pdfkit.py page-image --page N --dpi 150 --out 路径.png
```

页面渲染图已经全部生成在 `work/pages/pNNNN.png`（四位页码），直接读即可，不用重复渲染。

`figure-regions` 给出的边界框是候选值。裁切之后必须回读图片确认：坐标轴刻度、图例、轴标签完整，正文没有被卷进来。不合适就手动调 bbox 再裁。

### 编译

```
typst compile --root . preview/chNN.typ work/out.pdf
```

`--root .` 不能省略，否则 Typst 无法访问项目根目录以外的文件。

### 进度与检查

```
uv run tools/assemble.py status              # 各章进度
uv run tools/assemble.py check-terms         # 禁用译名、损坏字符、下标吞括号、重复图字、裸写公式编号
uv run tools/assemble.py check-coverage      # 小节数与原书是否一致
uv run tools/assemble.py figure-widths --chapter N   # 插图宽度百分比建议值
uv run tools/assemble.py make-previews       # 生成单章编译入口
```

## 四、四个阶段

### 阶段一 提取

产出 `work/chNN/` 下四份材料。

**`source.md`** —— 逐页正文。格式：

```
<!-- PDF 47 | 书 25 -->
## 2.1 A k-armed Bandit Problem

Consider the following learning problem...

[[EQ: (2.1)]]

...正文继续...

[[FIG: 2.1]]
```

页标记记录 PDF 页码与原书页码。小节标题用 `##`，层级与原书一致。公式与插图用 `[[EQ: 编号]]`、`[[FIG: 编号]]` 占位，占位符放在正文里它们实际出现的位置。正文必须逐页对照 `work/pages/pNNNN.png` 校读，修复全部连字损坏与缺字。**正文里不能残留任何 `↵`、`⇡`、`⇤`、`⇢`、`⇠`。**

**`math.md`** —— 该章全部展示公式，逐条写成 Typst 数学代码。格式：

```
## (2.1)   PDF p.49

q_* (a) ≐ EE[R_t | A_t = a]
```

注意示例里的 `q_* (a)` 在 `*` 与 `(` 之间有一个空格，这是必须的，理由见上一节。

每条标注原公式编号与 PDF 页码。上下标、求和范围、分式结构、花体与粗体符号逐一对照页面渲染图核对。行内公式也一并收进来，标注它所在的页与上下文。

**`figures.json`** —— 插图清单：

```json
[
  {
    "label": "Figure 2.1",
    "pdf_page": 47,
    "bbox": [x0, y0, x1, y1],
    "path": "assets/figures/ch02/fig-2-1.png",
    "caption_en": "An example bandit problem from the 10-armed testbed..."
  }
]
```

**图片本体** —— 裁切到 `assets/figures/chNN/`，命名规则 `fig-{章号}-{图号}.png`，例如 `fig-2-1.png`。四百 DPI，加两到三点的边距。每一张都要回读确认。

原书的表格如果内容适合重排，在 `source.md` 里用 Markdown 表格记录下来；如果是统计结果表，照抄数值。

**练习星号必须在提取阶段就定下来。** 原书前言声明「有些练习也标以 `*`，表示更深入、不属于理解本章基本内容的必要部分」，所以星号是真实存在的标记，只在部分练习上。做法有两层证据：

1. 用 `pdfkit find` 定位本章每一处 `Exercise N.M` 的边界框，在 600 DPI 下裁出**编号右侧到标题左侧**这一段，逐张回读，看编号与后续文字之间有没有星号
2. 对整章做文字层提取后检索星号字符，命中数应为 0 或与第一步一致

结论写进 `source.md`，逐题标明有星或无星（例如在练习行末注 `<!-- 有星 -->`，或在小节开头的说明里列出带星题号）。**不要把这个判断留给翻译阶段去猜**，翻译阶段只照着 `source.md` 传 `star: true` 或不传。

注意别把 `source.md` 里表示斜体的 Markdown 星号（写作 `*Exercise 2.2: Bandit example*`）当成练习星号，那是行文标注。

**不要漏掉不带编号的行内小图。** 原书里除了 Figure 2.1 这类编号插图，还有大量夹在正文中间的示意图，例如紧挨着贝尔曼方程的那个回溯图，图注写作「Backup diagram for $v_pi$」，没有 Figure 编号。它们同样要裁切出来，命名用 `fig-{章号}-inline-{顺序号}.png`（例如 `fig-3-inline-1.png`），`figures.json` 里的 `label` 写成图注原文。`figure-regions` 对这类小图同样有效。

### 阶段二 翻译

输入是阶段一的四份材料，加上 `glossary/TERMINOLOGY.md` 与 `template.typ`。

产出 `chapters/chNN/` 下的小节文件与章索引 `chapters/chNN.typ`。用小节文件而不是一整章一个大文件，好处是单次写入量有界、校对与修订能定位到小节。

**Typst 的 `#include` 不继承调用方的作用域**（已实测：父文件 import 进来的宏，子文件里报 unknown variable）。因此**每一个内容文件都要自带 import**，章索引文件写 `#import "../template.typ": *`，小节文件写 `#import "../../template.typ": *`。只 import，不要写 `#show`，页面样式由最外层的 `book.typ` 或 preview 包装文件设置。

小节文件命名 `NN-slug.typ`，例如 `chapters/ch02/01-a-k-armed-bandit-problem.typ`。章索引按顺序 include：

```typst
#chapter("多臂赌博机", en: "Multi-armed Bandits", number: 2)

#include "ch02/01-a-k-armed-bandit-problem.typ"
#include "ch02/02-action-value-methods.typ"
...
```

章标题写在章索引文件 `chapters/chNN.typ` 里，各小节文件只写小节内容，不要重复章标题。

**版式宏速查**（详细用法见 `glossary/TERMINOLOGY.md` 第五节）：

| 用途 | 宏 |
|---|---|
| 章标题 | `#chapter("中文标题", en: "English Title", number: 2)`，`number` 必须给 |
| 前置章节标题 | `#plain-chapter("中文标题", en: "English Title")` |
| 例题框 | `#example("标题")[内容]` |
| 练习 | `#exercise("2.9", star: true)[内容]` |
| 数学推导框（浅灰标题栏） | `#mathbox("标题")[内容]` |
| 伪代码框（深底白字标题栏） | `#algbox("标题")[内容]` |
| 中文强调 | `#ezh[中文]` |
| 西文强调 | `#emph[english]` |

每个小节写完立即编译：

```
typst compile --root . preview/chNN.typ work/out.pdf
```

编译报错就地修掉再写下一节。公式直接采用 `math.md` 给出的 Typst 代码。插图用 `#figure`，图注译为中文，图内文字保留英文。例题用 `#example`，练习用 `#exercise`（编号沿用原书编号，便于与英文版对照）。

翻译要求：准确优先，忠实原意，中文通顺。不要漏句、漏段、漏脚注，也不要添加原书没有的内容。

**练习的星号要逐题查，不能凭印象。** 原书前言声明「有些练习也标以 `*`，表示更深入、不属于理解本章基本内容的必要部分」，所以星号是真实存在的标记，但只在部分练习上。逐题用 `pdfkit find` 定位 `Exercise N.M` 的边界框，在 600 DPI 下裁出编号右侧到标题左侧这一段回读，确认有无星号。有则传 `star: true`，没有则不传。同时在整章文字层里检索星号字符做第二重确认。

注意别把 `source.md` 里表示斜体的 Markdown 星号（写作 `*Exercise 2.2: Bandit example*`）当成练习星号，那是行文标注。

**引用三减一增**（详见 `TERMINOLOGY.md` 的「引用」一节）：`@fig-` 与 `@tbl-` 自带「图」「表」，前面不能重复写；`@eq-` 的补充字已设为 `none`，写 `@eq-2-12` 得 `(2.12)`、写 `式 @eq-2-12` 得「式 (2.12)」，两种都对；正文**不许裸写公式编号**，一律用引用，`check-terms` 会扫描。引用后面紧跟中文时必须留空格或标点，否则汉字会被吞进标签名导致编译失败。

### 阶段三 校对

独立执行，不参考阶段二的中间过程。比对三样东西：英文原文（`source.md` 与页面渲染图）、产出的 `.typ` 文件、术语规范。

逐节核对：

- **完整性** —— 有没有漏掉整段、整句、例题、练习、脚注
- **数学** —— 每条公式的符号、上下标、求和范围、编号是否与页面渲染图一致
- **数值** —— 正文与图表中的全部数字
- **插图** —— 图号、位置、图注是否正确，图片内容是否与原文一致
- **术语** —— 是否符合 `TERMINOLOGY.md`
- **引用** —— `@fig-`、`@eq-`、`@tbl-` 标签是否都能解析
- **编译** —— `typst compile --root . preview/chNN.typ work/out.pdf` 无错误

产出 `work/chNN/verification.md`，每条缺陷写明 PDF 页码、原文、译文、问题所在。没有缺陷就写「未发现缺陷」。

### 阶段四 修订

按校对报告逐条修正，重新编译，直到编译通过且报告中每条缺陷都处理完毕。已修好的条目直接从报告中删除，报告里只留未解决的问题。

修订不回写翻译阶段的其他产物。

## 五、各章标题

章标题出现在目录里，全书必须一致。翻译时照下表取用，不要自己另译。

原书三大部的分隔页各自单独成页，中文部名照下表取用，文件在 `parts/part-N.typ`，由 `assemble.py make-book` 插到第 1、9、14 章之前。排版用 `#part-page("第一部分　表格型解法", en: "Part I: Tabular Solution Methods")[导语]`，详见 `TERMINOLOGY.md` 第五节。

| 部 | 英文 | 中文 |
|---|---|---|
| 第一部分 | Tabular Solution Methods | 表格型解法 |
| 第二部分 | Approximate Solution Methods | 近似解法 |
| 第三部分 | Looking Deeper | 深入探索 |

| 章 | 英文 | 中文 |
|---|---|---|
| 1 | Introduction | 介绍 |
| 2 | Multi-armed Bandits | 多臂赌博机 |
| 3 | Finite Markov Decision Processes | 有限马尔可夫决策过程 |
| 4 | Dynamic Programming | 动态规划 |
| 5 | Monte Carlo Methods | 蒙特卡洛方法 |
| 6 | Temporal-Difference Learning | 时序差分学习 |
| 7 | n-step Bootstrapping | $n$ 步自举 |
| 8 | Planning and Learning with Tabular Methods | 表格型方法下的规划与学习 |
| 9 | On-policy Prediction with Approximation | 带近似的 on-policy 预测 |
| 10 | On-policy Control with Approximation | 带近似的 on-policy 控制 |
| 11 | Off-policy Methods with Approximation | 带近似的 off-policy 方法 |
| 12 | Eligibility Traces | 资格迹 |
| 13 | Policy Gradient Methods | 策略梯度方法 |
| 14 | Psychology | 心理学 |
| 15 | Neuroscience | 神经科学 |
| 16 | Applications and Case Studies | 应用与案例研究 |
| 17 | Frontiers | 前沿 |

## 六、完成标准

一章做完，以下全部成立：

1. `uv run tools/assemble.py check-coverage` 报告该章小节数量与原书一致
2. `uv run tools/assemble.py check-terms` 对该章无任何报告
3. `typst compile --root . preview/chNN.typ work/out.pdf` 无错误
4. `work/chNN/verification.md` 中的缺陷全部处理完毕
5. 该章全部插图已裁切到 `assets/figures/chNN/` 并逐张回读确认
6. 随机抽取若干页，与 `work/pages/` 中的原书页面逐段对照，内容一致
