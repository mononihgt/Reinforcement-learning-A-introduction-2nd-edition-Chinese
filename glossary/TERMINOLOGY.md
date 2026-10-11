# 术语与行文规范

全书唯一的译名标准。每一章的提取、翻译、校对都以本文件为准。

## 一、总体约定

沿用既有的中文译本（`a-pdf/chinese-translation.pdf` 的翻译说明）确立的约定：

1. **强化学习领域的方法名与理论词汇保留英文。** agent、actor–critic、option、Sarsa、Q-learning、Dyna、REINFORCE、eligibility trace 的词干部分等，直接写英文原词或用中文词加英文原词。
2. **通用词译为中文。** 策略、动作、状态、奖励、回报、价值、环境、探索、利用、规划、学习等。
3. **西文人名保留英文。** Bellman、Watkins、Thompson、Turing、Shannon 等一律写英文原名，不加中文音译。东亚人名的处理见第三节。
4. **首次出现时给出中英对照。** 中文译名首次出现处附英文原词，写作 `中文译名（English）`，之后只用中文。保留英文的词汇不受此限制，全篇直接用英文。

保留英文的写法在中文句子里直接插入英文单词，中英文之间留一个半角空格，例如「agent 必须平衡探索与利用」。

## 二、术语对照表

表格中「处理」一列写明该词在译文中的写法。「首现附英文」表示第一次出现时写作 `动作（action）`，之后只写「动作」。

### 核心概念

| 英文原词 | 处理 | 备注 |
|---|---|---|
| action | 动作 | 首现附英文。不译作「行动」 |
| bandit | 赌博机 | 首现附英文。k-armed bandit 译作「$k$ 臂赌博机」 |
| agent | agent | 保留英文。不译作「代理」「智能体」「主体」 |
| environment | 环境 | 首现附英文 |
| state | 状态 | 首现附英文 |
| reward | 奖励 | 首现附英文。不译作「收益」「报酬」 |
| return | 回报 | 首现附英文。与「奖励」严格区分 |
| value | 值 | 首现附英文 |
| policy | 策略 | 首现附英文 |
| episode | 回合 | 首现附英文。不译作「幕」「轮次」 |
| time step | 时间步 | 首现附英文 |
| trial | 试验 | 多臂赌博机语境下指一次拉杆 |
| play | 一局 | 多臂赌博机语境下指一次选择。名词不能漏译，但具体用词随语境，可作「一局」「一次」 |
| goal | 目标 | |
| experience | 经验 | |
| model | 模型 | |
| planning | 规划 | |
| learning | 学习 | |
| control | 控制 | |
| prediction | 预测 | |
| estimate | 估计 | 名词。动词用「估计」 |
| target | 目标 | 与 goal 同译，按语境区分 |
| update | 更新 | |
| sample | 样本 | |

### 强化学习专有概念

| 英文原词 | 处理 | 备注 |
|---|---|---|
| exploration | 探索 | 首现附英文 |
| exploitation | 利用 | 首现附英文 |
| exploring starts | 探索起始 | |
| active exploration | 主动探索 | |
| greedy | 贪婪 | |
| ε-greedy | ε-greedy | 保留英文写法 |
| soft-max | soft-max | 保留英文写法 |
| value function | 值函数 | 首现附英文。不译作「价值函数」 |
| state-value function | 状态值函数 | |
| action-value | 动作值 | 首现附英文 |
| action-value function | 动作值函数 | |
| optimal | 最优 | |
| optimal policy | 最优策略 | |
| optimal control | 最优控制 | |
| policy evaluation | 策略评估 | |
| policy improvement | 策略改进 | |
| policy iteration | 策略迭代 | |
| value iteration | 值迭代 | |
| generalized policy iteration | 广义策略迭代 | |
| iterative policy evaluation | 迭代策略评估 | |
| dynamic programming | 动态规划 | 首现附英文 |
| Monte Carlo | 蒙特卡洛 | 只用一个译名，不用「蒙特卡罗」 |
| Monte Carlo methods | 蒙特卡洛方法 | |
| Monte Carlo Tree Search | 蒙特卡洛树搜索 | 缩写 MCTS |
| temporal-difference | 时序差分 | 缩写 TD。首现附英文 |
| TD error | TD 误差 | |
| n-step | n 步 | 写作 `$n$ 步`，$n$ 用数学模式 |
| bootstrapping | 自举 | 首现附英文 |
| eligibility trace | 资格迹 | 首现附英文 |
| λ-return | λ 回报 | λ 用数学模式 |
| backup | 回溯 | 概念名，译中文。首现附英文。不译作「备份」 |
| backup diagram | 回溯图 | 概念名，译中文 |
| Tree Backup | Tree Backup | **算法名，保留英文**。不写作「树回溯」「树备份」 |
| Sarsa | Sarsa | 保留英文 |
| Q-learning | Q-learning | 保留英文 |
| Double Q-learning | Double Q-learning | 保留英文 |
| Double learning | Double learning | 保留英文，与 Double Q-learning 一致 |
| Expected Sarsa | Expected Sarsa | 保留英文 |
| Dyna | Dyna | 保留英文 |
| REINFORCE | REINFORCE | 保留英文 |
| actor–critic | actor–critic | 保留英文。不译作「演员-评论家」 |
| critic | 评论家 | 单独出现时译中文 |
| option | option | 保留英文。不译作「选项」 |
| afterstate | 后续状态 | 不译作「后期状态」 |
| importance sampling | 重要性采样 | |
| importance-sampling ratio | 重要性采样率 | |
| off-policy | off-policy | 保留英文 |
| on-policy | on-policy | 保留英文 |
| behavior policy | 行为策略 | |
| target policy | 目标策略 | |
| control variate | 控制变量 | |
| certainty-equivalence | 确定性等价 | |
| consistency condition | 一致性条件 | |
| distribution model | 分布模型 | |
| sample model | 样本模型 | |
| decision-time planning | 决策时规划 | |
| background planning | 背景规划 | |
| heuristic search | 启发式搜索 | |
| prioritized sweeping | 优先级扫描 | |
| real-time dynamic programming | 实时动态规划 | 缩写 RTDP |
| rollout algorithm | rollout 算法 | 保留英文 |
| sweep | 扫描 | |
| horizon | 视界 | |
| continuing task | 持续性任务 | 不译作「连续任务」 |
| episodic task | 回合任务 | |
| absorbing state | 吸收状态 | |
| terminal state | 终止状态 | |
| nonterminal state | 非终止状态 | |
| discount | 折扣 | |
| discount rate | 折扣率 | |
| average reward | 平均奖励 | |
| reward rate | 奖励率 | |
| credit | 信用 | 如 credit assignment 信用分配 |
| curiosity | 好奇心 | |
| uncertainty | 不确定性 | |

### 近似方法

| 英文原词 | 处理 | 备注 |
|---|---|---|
| function approximation | 函数近似 | 不译作「函数逼近」。首现附英文 |
| approximation | 近似 | |
| generalize / generalization | 泛化 | |
| stochastic gradient | 随机梯度 | |
| semi-gradient | 半梯度 | |
| gradient descent | 梯度下降 | |
| gradient ascent | 梯度上升 | |
| step-size parameter | 步长参数 | |
| linear method | 线性方法 | |
| artificial neural network | 人工神经网络 | |
| backpropagation | 反向传播 | |
| state aggregation | 状态聚合 | |
| coarse coding | 粗编码 | |
| tile coding | 瓦片编码 | |
| radial basis function | 径向基函数 | |
| feature | 特征 | |
| feature vector | 特征向量 | |
| weight vector | 权重向量 | |
| least-squares | 最小二乘 | |
| Least-Mean-Square | 最小均方 | 缩写 LMS |
| memory-based | 基于记忆 | |
| kernel | 核 | |
| interest and emphasis | 兴趣与强调 | |
| emphasis | 强调 | interest and emphasis 的 emphasis 与单独出现的 emphasis 同译 |
| deadly triad | 致命三元组 | |
| Bellman error | 贝尔曼误差 | 缩写 BE |
| projected Bellman error | 投影贝尔曼误差 | 缩写 PBE |
| mean square value error | 均方值误差 | 缩写 VE |
| Bellman operator | 贝尔曼算子 | |
| projection operator | 投影算子 | |
| gradient-TD | gradient-TD | 保留英文 |
| emphatic-TD | emphatic-TD | 保留英文 |
| true online TD(λ) | true online TD(λ) | 保留英文 |
| Dutch trace | 荷兰迹 | |
| divergence | 发散 | |
| fixed point | 不动点 | |
| norm | 范数 | |
| policy gradient | 策略梯度 | 首现附英文 |
| policy gradient theorem | 策略梯度定理 | |
| baseline | 基线 | |
| advantage | 优势 | |
| parameterization | 参数化 | |
| parameter vector | 参数向量 | |
| continuous action | 连续动作 | |
| differential return | 微分回报 | |

### 其他领域

| 英文原词 | 处理 | 备注 |
|---|---|---|
| psychology | 心理学 | |
| neuroscience | 神经科学 | |
| classical conditioning | 经典条件作用 | |
| instrumental conditioning | 工具性条件作用 | |
| operant conditioning | 操作式条件作用 | |
| Pavlovian conditioning | 巴甫洛夫式条件作用 | 首现附英文；人名 Pavlov 本身保留英文 |
| Pavlovian control | 巴甫洛夫式控制 | 首现附英文；人名 Pavlov 本身保留英文 |
| conditioned reflex | 条件反射 | |
| Law of Effect | 效果定律 | |
| delayed reinforcement | 延迟强化 | |
| cognitive map | 认知地图 | |
| habitual behavior | 习惯性行为 | |
| goal-directed behavior | 目标导向行为 | |
| dopamine | 多巴胺 | |
| reward prediction error | 奖励预测误差 | |
| neuron | 神经元 | |
| synapse | 突触 | |
| basal ganglia | 基底神经节 | |
| striatum | 纹状体 | |
| neurotransmitter | 神经递质 | |
| addiction | 成瘾 | |
| organism | 有机体 | |
| supervised learning | 监督学习 | |
| unsupervised learning | 无监督学习 | 不译作「非监督学习」 |
| reinforcement learning | 强化学习 | |
| machine learning | 机器学习 | |
| artificial intelligence | 人工智能 | |
| game theory | 博弈论 | |
| genetic algorithm | 遗传算法 | |
| genetic programming | 遗传规划 | |
| hierarchical | 层级 | |
| temporal abstraction | 时间抽象 | |
| general value function | 一般值函数 | |
| auxiliary task | 辅助任务 | |
| self-play | 自我对弈 | |
| human-level | 人类水平 | |
| partially observable | 部分可观测 | |
| observation | 观测 | |
| representation | 表示 | |
| dimension | 维度 | |
| curse of dimensionality | 维数灾难 | |
| cross-entropy | 交叉熵 | |
| quantize | 量化 | 状态空间或动作空间的量化。不译作「离散化」，discretize 另有其词 |
| Fourier basis | 傅里叶基 | 统一用「傅里叶」，不用「傅立叶」 |
| logistic function | logistic 函数 | 保留英文 |
| sigmoid | sigmoid 函数 | 保留英文 |
| Boltzmann distribution | 玻尔兹曼分布 | |
| Gibbs distribution | 吉布斯分布 | |
| backgammon | 双陆棋 | |
| blackjack | 21 点 | |
| tic-tac-toe | 井字棋 | |
| checkers | 西洋跳棋 | |
| Go | 围棋 | |

## 三、人名与专名

西文人名一律用英文原名，不加中文音译，不用「（人名）」标注。

Bellman、Watkins、Thompson、Turing、Shannon、Sutton、Barto、Tesauro、Samuel、Klopf、Werbos、Bertsekas、Tsitsiklis、Dayan、Singh、Mahadevan、Kaelbling、Russell、Mitchell、Nilsson、Jordan、Moore、Anderson、Williams、Baird、Bradtke、Crites、Jaakkola、Van Roy、Littman、Parr、Precup、Rummery、Narendra、Schweitzer、Seijen。

东亚人名（中、日、韩等本有汉字姓名者）写其汉字姓名，不用拉丁转写，也不加「（人名）」标注：樊麾不写作 Fan Hui，李世石不写作 Lee Sedol。西文人名不适用此条，保留英文原名：Bellman 不写作「贝尔曼」。

专名：MIT Press 保留英文；算法名一律保留英文原拼写与大小写，例如 Dyna-Q、Dyna-Q+、R-learning、TD-Gammon、Watson、AlphaGo、Atari。

## 四、行文规范

### 标点

- 中文一律用全角标点：，。、；：？！（）《》〈〉「」
- 中文句中引用英文单词、公式、代码时，两侧各留一个半角空格
- 数字与中文之间留一个半角空格，例如「第 3 章」「共 10 个动作」
- 圆括号分两种情形，不要混用：
  - **术语的中英对照**用全角，括号紧贴中文、中间不留空格：`动作（action）`、`回报（return）`
  - **纯英文的限定语或补充说明**用半角，前面留一个半角空格：`练习 2.5 (programming)`、`数据 (2000 runs)`
- 不使用 em dash；中文破折号用「——」
- 书名、期刊名用《》
- 引号用「」，不使用英文引号

### 数学

变量与符号一律使用 Typst 数学模式，不要写成普通文字。常用写法：

| 含义 | Typst 写法 |
|---|---|
| 定义为 | `≐`（直接写这个字符） |
| 期望 | `bb(E)[X]` |
| 实数集 | `bb(R)` |
| 集合（花体） | `cal(S)`、`cal(A)`、`cal(R)`、`cal(X)`、`cal(Y)` |
| 指示函数 | `bb(1)_"predicate"` |
| 上划线 | `overline(R)`，不要写 `bar(R)` |
| 粗体向量与矩阵 | `bold(w)`、`bold(theta)`、`bold(A)` |
| 范数 | `norm(v)_mu^2` |
| 求和 | `sum_(i=1)^n`、`sum_x` |
| 求积 | `prod_t` |
| 偏导 | `partial`（Typst 没有 `diff`） |
| 希腊字母 | `alpha` `beta` `gamma` `delta` `epsilon` `lambda` `pi` `theta` `mu` `rho` `eta` `sigma` |
| 正比于 | `prop` |
| 近似等于 | `approx` |
| 属于、子集 | `in`、`subset` |
| 箭头 | `arrow.r`、`arrow.l` |
| 下标、上标 | `Q_t(a)`、`R_(t+1)`、`q_*(a)`、`e^x` |

行内公式用 `$...$`，展示公式单独成段并在末尾加标签：

```typst
$ Q_(n+1) ≐ Q_n + 1/n (R_n - Q_n) $ <eq-2-3>
```

公式编号由模板自动生成为 `(2.3)`，不需要手写编号。

### 下标后必须留空格（重要）

Typst 会把紧跟在裸下标后面的圆括号或方括号吞进下标里，渲染成完全错误的公式。这是本项目最容易犯且最不易察觉的错误。

| 写法 | 渲染结果 | 判定 |
|---|---|---|
| `$Q_t(s, a)$` | $Q$ 的下标变成 `t(s,a)` | **错** |
| `$Q_t (s, a)$` | $Q_t(s,a)$，括号正常大小 | 对 |
| `$v_pi(s)$` | $v$ 的下标变成 `pi(s)` | **错** |
| `$v_pi (s)$` | 正确 | 对 |
| `$q_*(a)$` | 下标变成 `*(a)` | **错** |
| `$q_* (a)$` | 正确 | 对 |
| `$bb(E)_b[X]$` | 下标变成 `b[X]` | **错** |
| `$bb(E)_b [X]$` | 正确 | 对 |
| `$v_bold(w)(s)$` | 正确，下标是函数形式的 `bold(w)` 时不受影响 | 对 |
| `$hat(v)(s, bold(w))$` | 正确，没有下标 | 对 |
| `$cal(A)(s)$` | 正确，没有下标 | 对 |
| `$Q_t \| s \|$` | 正确，竖线不受影响 | 对 |
| `$G_(t:t+n)$` | 正确，括号组形式的下标不受影响 | 对 |
| `$v_(t+1)(s)$` | 正确，同上 | 对 |

**规则：下标是一个单独的标识符或符号（`t`、`*`、`pi`、`b`、`d` 之类），而它后面紧跟 `(` 或 `[` 时，中间必须留一个空格。** 拿不准就一律加空格，加了不会有副作用。

这条规则影响面很大，`q_*(a)`、`v_pi(s)`、`Q_t(s, a)`、`N_t(a)`、`hat(v)(s, bold(w))`、`overline(V)_t(s)`、`bb(E)_b[rho_t delta_t^2]` 这类写法在原书里成千上万次出现。

### 强调

原书用斜体表示强调。中文字体没有斜体字形，按传统改用楷体，视觉上明确可辨。

| 强调的内容 | 写法 |
|---|---|
| 中文 | `#ezh[梯度上升]` |
| 英文或算法名 | `#emph[gradient ascent]` |
| 数学模式里的函数名 | `$italic("bandit")(a)$` |

第三行是个绕法，值得记下来：**`#emph[bandit](a)` 会编译失败**，报 `expected function, found content`。原因是内容块后面紧跟圆括号，Typst 把它解析成函数调用。数学模式里表示函数名用 `italic()` 包裹即可，与公式里 `italic("NewEstimate")` 的写法一致。

同理，`#emph[...]` 或任何内容块后面要紧跟圆括号时，都要留空格或改用别的写法。

不要对中文用 `#emph`，渲染出来和正文没有区别；也不要改用加粗，加粗在这个版式里太弱。

### 引用

标签命名规则：`<fig-{章号}-{图号}>`、`<tbl-{章号}-{表号}>`、`<eq-{章号}-{公式号}>`、`<sec-{章号}-{节号}>`。

| 对象 | 标签示例 | 正文写法 | 渲染结果 |
|---|---|---|---|
| 图 2.5 | `<fig-2-5>` | `@fig-2-5` | 图 2.5 |
| 表 3.1 | `<tbl-3-1>` | `@tbl-3-1` | 表 3.1 |
| 公式 (2.11) | `<eq-2-11>` | `@eq-2-11` | (2.11) |
| 小节 2.3 | `<sec-2-3>` | `第 2.3 节`（纯文本） | 第 2.3 节 |

**`@fig-` 与 `@tbl-` 自带「图」「表」二字，前面不能再写一遍。** 写 `图 @fig-2-5` 渲染成「图 图 2.5」，正确写法是 `@fig-2-5`。这类错误很隐蔽：源码读起来通顺，编译不报错，只有看渲染结果才发现重复，`check-terms` 会扫描并报出来。

`@eq-` 的补充字在 `template.typ` 里设成了 `none`，引用只渲染编号 `(2.11)`，与原书写法一致。这样写 `@eq-2-11` 得到「(2.11)」，写 `式 @eq-2-11` 得到「式 (2.11)」，两种都对，按句子需要选用。之所以不保留 Typst 默认的中文补充字「式」，是因为它会让「我们的算法 @eq-2-12 的更新」渲染成「我们的算法 式 (2.12) 的更新」，两个中文词之间多出一个空格。

**公式引用一律用 `@eq-`，不要在正文里裸写编号。** 裸编号与公式下方的自动编号各自独立，公式编号一旦平移就会静默不一致。`check-terms` 会扫描含中文的行并报出裸编号。

**引用后面要紧跟中文字符时，中间必须留空格或标点。** Typst 的标签字符集包含汉字，`@eq-9-1的步长序列` 会把「的步长序列」整段吞进标签名，编译直接报标签不存在。写成 `@eq-9-1 的步长序列` 或 `@eq-9-1，其余不变` 即可。这也符合「公式两侧各留一个半角空格」的行文规范。

**跨章引用用纯文本，不用 `@`。** 章内引用走标签（编译能保证闭合），跨章引用写「图 3.4」「第 5.5 节」这样的纯文本，因为单章预览文件里只有本章，跨章标签解析不了会直接编译失败。单章预览能独立编译是校对阶段比对的基础，这个优先级高于跨章引用的自动闭合。

**公式后面的出处注解**（如 `(by (3.9))`、`(from (4.6))`）排在公式块的下一行左端，不强求与英文原书一样右对齐。实测 Typst 里展示公式内部的 `#h(1fr)` 不生效，没有干净的右对齐手段，固定宽度占位会随内容漂移，不如保持左端。

节引用一律写纯文本「第 2.4 节」，不用 `@sec-`。节号由原书决定且不会变动，纯文本更自然。小节标题仍然要打 `<sec-2-N>` 标签，便于将来检索。

小节号沿用原书，所以「见第 5.5 节」指的是本书第 5.5 节，直接写即可。

页码不能用本书页码，因为版式与原书不同。需要指向原书某页时一律写明「原书第 N 页」，例如「（原书第 199 页）」。指向本书内部时用标签或「见前面的符号表」这类说法。

### 首现附英文的落点

以**章**为单位。每个词在**本章**第一次出现处附英文对照，此后本章内不再重复。章与章之间互不承接，读者跳读任何一章都不缺对照。前置部分（两版前言、符号表）各自作为一个独立单位。

### 原书笔误

原书个别句子有笔误（例如 `Depending of the students' background`、`thank DeepMind their support`、`over many many years`）。译文按**本意**翻译，不把笔误照搬成中文语病，也不加译注。

### 章末小节标题

原书各章末尾的小节统一译作：

| 原书标题 | 译文 |
|---|---|
| Summary | 小结 |
| Bibliographical and Historical Remarks | 文献与历史评注 |
| Bibliographical Remarks | 文献评注 |
| Summary of Part I: Dimensions | 第一部分小结：维度 |

**注意原书自己就有两种写法**：第 2 章起的各章末用 `Bibliographical and Historical Remarks`，第 1 章用 `Bibliographical Remarks`（少了 Historical）。两种译文都要保留，不要为了「统一」把第 1 章改成「文献与历史评注」，那是篡改原书。

### 脚注

用 `#footnote[内容]`。原书的脚注按原位置保留。

## 五、版式约定

### 章节文件组织

每章一个目录 `chapters/chNN/`，内含若干小节文件，章索引文件 `chapters/chNN.typ` 按顺序 include 它们。章文件自身不设置页面样式。

### 章标题

```typst
#chapter("多臂赌博机", en: "Multi-armed Bandits", number: 2)
```

`number` 是必须给的，它决定图号、表号、公式号的章前缀。单章预览时文档里只有这一章，不给 `number` 的话章号会从 1 开始，图 2.1 会渲染成图 1.1，与英文原书对不上。

前置部分（前言、符号表）与后置部分（参考文献）用：

```typst
#plain-chapter("符号表", en: "Summary of Notation")
```

### 分部标题页

原书三大部各有一张独立的分隔页：页顶一条与栏宽等宽的粗横线，线下是部名，导语从页面偏下的位置起排。写 `parts/part-N.typ`，正文用：

```typst
#part-page("第一部分　表格型解法", en: "Part I: Tabular Solution Methods")[
  导语正文。
]
```

部名同时给出中文与英文原名，英文排在下一行，与章标题的排法一致。分隔页不编号，但进目录，页眉显示部名。三个文件由 `assemble.py make-book` 分别插到第 1、9、14 章之前；单页编译入口是 `preview/parts-part-N.typ`。

### 例题

```typst
#example("标题")[
  正文内容。
]
```

编号由模板自动生成为「例 2.1」。无标题时传空内容 `#example([])[...]`。末尾的实心方块 ■ 由宏自动添加，不要手写。

### 练习

```typst
#exercise("2.9", star: true)[
  练习正文。
]
```

编号沿用原书编号，便于与英文版对照。原书中带星号标记为较难的练习，用 `star: true`，星号自动排在末尾。末尾的空心方框 □ 由宏自动添加，不要手写。

**两种结束符的区别要记住**：例题末尾是实心方块 ■，练习末尾是空心方框 □，两者由各自的宏自动生成。原书用它们在与正文混排时划出条目边界，实心与空心分别对应两类条目，不是同一个符号的两种写法。

### 方框

原书有两类方框，版式不同，宏也不同。

数学内容框，浅灰标题栏，用于原书把数学性较强的推导单独装框的地方：

```typst
#mathbox("梯度赌博机算法即随机梯度上升")[
  框内正文。
]
```

伪代码框，深底白字标题栏，用于算法伪代码：

```typst
#algbox("一个简单的赌博机算法")[
  初始化，对 $a = 1$ 到 $k$：...
]
```

两类方框都不编号、不进目录，与原书一致。伪代码框内的展示公式自动取消编号并左对齐，直接写 `$ ... $` 即可，不用手工绕开编号。缩进用 `#h(1.5em)`，同一段内的换行用 `\`。

### 插图

```typst
#figure(
  image("../assets/figures/ch02/fig-2-5.png", width: 78%),
  caption: [梯度赌博机算法在 10 臂测试平台上的平均表现。],
)<fig-2-5>
```

图片宽度用 `uv run tools/assemble.py figure-widths --chapter N` 查，它按原书里插图占正文栏宽的比例算出百分比，与英文版版面比例一致，直接照填即可。图注译为中文，图内文字保留英文原样。

### 表格

```typst
#figure(
  table(
    columns: 3,
    [动作], [真实值], [估计值],
    ...
  ),
  caption: [表格标题。],
  kind: table,
)<tbl-2-1>
```

### 小节标题

用 Typst 标准标题语法，层级对应原书：

```typst
== k 臂赌博机问题 <sec-2-1>
=== 增量式实现 <sec-2-3-2>
```

原书中标星号的选做小节，标题前加 `*`，例如 `== *折扣感知的重要性采样`。

**编号与否以原书书签为准。** 原书书签里列出的每一个小节都是编号小节，用 `==`。书签里没有的章末小节（各章最后的「文献与历史评注」）不编号，用：

```typst
#heading(level: 2, numbering: none)[文献与历史评注]
```

`assemble.py check-coverage` 正是按 `==` 的条数与原书书签比对，所以这个区分直接影响检查结果。注意第 1 章是例外：它的小节「早期强化学习史」在原书里编号为 1.7，书签里也有，用 `==`。
