# 第 8 章公式（Planning and Learning with Tabular Methods，PDF 181–218）

全部公式对照 `work/pages/pNNNN.png` 页面渲染图逐条重建，未参考文字层的数学片段。

代码即 Typst 数学代码。块级公式写成 `$ ... $`（两侧留空格），行内公式写成 `$...$`；章文件里直接照抄即可。原书带编号的公式在代码之后给出标签，编号由模板生成；本章只有 (8.1)、(8.2) 两条带编号公式，没有不编号的独立展示式，也没有跨页展示式。伪代码框内的公式与正文行内公式各自单列一节。

本章特有的写法约定：

- 下标是单独一个标识符或符号、后面紧跟 `(` 或 `[` 时，中间必须留一个空格：写 `q_* (s, a)`、`v_* (s)`、`q_pi (s, a)`、`tau (S_t, a)`。不留空格时 Typst 把括号吞进下标。下标是括号组（`max_(a')`、`sum_(s', r)`、`Q_(pi_k)`）时不受影响。
- `max_a`、`sum_(s', r)` 直接用裸写法：Typst 在块级公式里把上下限排在符号下方，与原书 (8.1)、(8.2) 以及三个伪代码框的排版一致；在行内公式里排在符号右侧，与原书正文一致。本章没有 `argmax`。
- 集合记号 S、A 在原书里是花体，写成 `cal(S)`、`cal(A)(S)`。四参数动力学写 `p(s', r | s, a)`（普通斜体 p）；估计的动力学写 `hat(p)(s', r | s, a)`（带帽）。数字用花体时是 `cal(S)`，集合的元素个数写成 `|cal(S)|`。
- 上划线写成 `overline(...)`：优先队列算法里表示先驱状态、先驱动作与先驱奖励，`overline(S)`、`overline(A)`、`overline(R)`；不要用 `bar(...)`。
- 波浪号策略 π̃ 写成 `tilde(pi)`（波浪号加在 π 上，不是排在 π 前面的 `tilde.op`），带下标时写成 `v_(tilde(pi)) (s_0)`。样本状态的撇号直接写 `'`：`S'`、`s'`、`a'`。
- 赋值箭头写成 `arrow.l`；正文里表示一次转移的右箭头写成 `arrow.r`。绝对值写成 `|...|`。
- 伪代码框里的斜体词写成 `italic("Model")`、`italic("policy")`、`italic("first")`、`italic("PQueue")`；阈值写成 `theta`。

## (8.1)   PDF p.195

期望更新：等号右边是求和号，上下限 `s', r` 排在符号下方；`hat(p)` 是带帽的 p；方括号是随内容放大的大方括号；行末句号。

```typst
$ Q(s, a) <- sum_(s', r) hat(p)(s', r | s, a) [r + gamma max_(a') Q(s', a')]. $ <eq-8-1>
```

## (8.2)   PDF p.195

样本更新：Q-learning 形式的更新，方括号随内容放大；行末逗号。

```typst
$ Q(s, a) <- Q(s, a) + alpha [R + gamma max_(a') Q(S', a') - Q(s, a)], $ <eq-8-2>
```

## 伪代码框内公式

框内的公式都是行内公式（上限排在符号右侧），因此写成 `$...$` 而不是 `$ ... $`，这与原书框内的排版一致；它们不带编号，`source.md` 的框里也没有占位符。

### PDF p.183 「Random-sample one-step tabular Q-planning」框

- 随机选取的状态与动作：`$S in cal(S)$`、`$A in cal(A)(S)$`
- 更新（第 3 步）：`$Q(S, A) arrow.l Q(S, A) + alpha [R + gamma max_a Q(S', a) - Q(S, A)]$`

### PDF p.186 「Tabular Dyna-Q」框

- 初始化：`$Q(s, a)$`、`$italic("Model")(s, a)$`、`$s in cal(S)$`、`$a in cal(A)(s)$`
- (b) 行为选择：`$A arrow.l epsilon"-greedy"(S, Q)$`（ε 是数学斜体，-greedy 是直立体文字；两者之间不加空格，否则渲染出缝隙）
- (d) 直接 RL 更新与 (f) 规划更新是同一式，两处都写：

```typst
$ Q(S, A) arrow.l Q(S, A) + alpha [R + gamma max_a Q(S', a) - Q(S, A)] $
```

- (e) 模型记录：`$italic("Model")(S, A) arrow.l R, S'$`（原书注：assuming deterministic environment）
- (f) 内部的模型查询：`$R, S' arrow.l italic("Model")(S, A)$`

### PDF p.192 「Prioritized sweeping for a deterministic environment」框

- 初始化：`$Q(s, a)$`、`$italic("Model")(s, a)$`、`$italic("PQueue")$`
- (a) 当前状态：`$S arrow.l "current (nonterminal) state"$`
- (b) 行为选择：`$A arrow.l italic("policy")(S, Q)$`
- (e) 优先级：`$P arrow.l |R + gamma max_a Q(S', a) - Q(S, A)|$`（行末句点照原书保留）
- (f) 入队条件：`$P > theta$`
- (g) 取出队首：`$S, A arrow.l italic("first") (italic("PQueue"))$`
- (g) 模型查询：`$R, S' arrow.l italic("Model")(S, A)$`
- (g) 更新：`$Q(S, A) arrow.l Q(S, A) + alpha [R + gamma max_a Q(S', a) - Q(S, A)]$`
- (g) 内层循环遍历先驱：`$overline(S), overline(A)$` predicted to lead to `$S$`
- (g) 先驱奖励：`$overline(R) arrow.l "predicted reward for" overline(S), overline(A), S$`
- (g) 先驱优先级：`$P arrow.l |overline(R) + gamma max_a Q(S, a) - Q(overline(S), overline(A))|$`（行末句点照原书保留）
- (g) 先驱入队条件：`$P > theta$`

## 行内公式

只收录有结构或者容易写错的行内式。单字母变量（*S*、*R*、*γ*、*α*、*ε*、*θ*、*b*、*t*、*κ*、*τ*、*n*、*k*）与 `q_* (s, a)`、`v_pi (s)`、`Q(s, a)` 这类贯穿全章的符号，写法见 `glossary/notation.typ`，不逐处重复。

### PDF p.182

- `$p(s', r | s, a)$`：动态规划所假设的模型，MDP 动力学的四参数表示（普通斜体 `p`，不带帽）。正文行内写成 *p*(*s′*, *r*|*s*, *a*)。

### PDF p.183

- `$alpha$`：步长参数，正文只提到它必须随时间适当减小。

### PDF p.184

- `$S_t, A_t arrow.r R_(t + 1), S_(t + 1)$`：一次转移的记号，箭头用 `arrow.r`。

### PDF p.186

- `$italic("Model")(s, a)$`：模型表项，表示状态–动作对 (s, a) 的预测；正文行内写成 *Model*(*s*, *a*)。

### PDF p.187

- `$gamma = 0.95$`：Dyna 迷宫（例题 8.1）的折扣率。
- `$+1$`：进入目标状态那一步的奖励。
- `$alpha = 0.1$`、`$epsilon = 0.1$`：步长与探索参数。
- `$n = 0$`、`$n = 5$`、`$n = 50$`：每步规划次数。

### PDF p.190

- `$r$`、`$tau$`：建模奖励与自该转移上次尝试以来经过的时间步数。
- `$r + kappa sqrt(tau)$`：用于规划更新的探索奖励，κ 是一个小常数。
- `$kappa sqrt(tau)$`：练习 8.2 提到的探索奖励本身。
- `$Q(S_t, a) + kappa sqrt(tau (S_t, a))$`：练习 8.4 中把奖励只用在选择上的做法；`tau (S_t, a)` 的下标后留了空格。

### PDF p.193

- `$1 slash 20$`：杆的每次平移距离约为工作空间的二十分之一。
- `$20 times 20$`：平移量化到的位置数。乘号写成 `times`。
- `$10$`：旋转增量 10 度。

### PDF p.194

- `$q_*$`、`$v_*$`、`$q_pi$`、`$v_pi$`：四类单步更新对应的值函数。

### PDF p.195

- `$q_*$`：8.5 节针对的目标值函数。
- `$Q$`：表格型近似值函数。
- `$hat(p)(s', r | s, a)$`：估计的动力学（带帽 p）。
- `$alpha = 1$`：只有一个后继状态时，样本更新与期望更新相同。
- `$Q(s, a)$`、`$Q(s', a')$`：被更新的状态–动作对与后继对。
- `$hat(p)(s' | s, a) > 0$`：分支因子讨论中的条件。
- `$b$`：分支因子（可能后继状态的个数）。

### PDF p.196

- `$sqrt(frac(b - 1, b t))$`：样本更新的误差下降速度，根号里是堆叠分式，写成 `sqrt(frac(...))`。
- `$alpha = 1 slash t$`：样本平均（步长取 1/t）。

### PDF p.198

- `$epsilon = 0.1$`：on-policy 实验里 ε-greedy 策略的探索参数。
- `$|cal(S)|$`：状态个数。
- `$b$`：所有状态–动作对共同的分支因子。
- `$0.1$`：每条转移以 0.1 的概率转到终止状态。
- 高斯分布的均值 `$0$`、方差 `$1$`。
- `$v_(tilde(pi)) (s_0)$`、`$tilde(pi)$`：贪心策略 π̃ 下起始状态的真实值，以及贪心策略本身的记号。

### PDF p.201

- `$10^7$`：估计相关状态数时执行的贪心剧集数；`source.md` 里保留 Unicode 上标 10⁷。
- `$10^(-4)$`：DP 收敛判据（一次扫描中状态值的最大变化）；`source.md` 里保留 Unicode 上标 10⁻⁴。
- `$-1$`：赛车任务每一步的奖励。表格里的 252,784、127,600、31.9、98.45、80.51、3.18 按原样转写即可。

### PDF p.202–203

- `$S_t$`、`$A_t$`、`$S_(t + 1)$`、`$A_(t + 1)$`：8.8 节区分背景规划与决策时规划时用的状态与动作记号。

### PDF p.204

- `$gamma^k$`：搜索深度 k 对应的折扣幂；`γ^k` 很小时动作近似最优。

### PDF p.207

- `$q_pi (s, a) >= v_pi (s)$`：策略改进定理的前提条件。
- `$pi' (s) = a != pi (s)$`：两个策略仅在状态 s 上不同。
- `$a' in cal(A)(s)$`：模拟轨迹回报平均后得到的每个动作的估计值。
- `$q_*$`、`$q_pi$`：rollout 算法并不去估计的完整动作值函数。
