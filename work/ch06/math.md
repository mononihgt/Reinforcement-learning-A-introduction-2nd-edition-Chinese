# 第 6 章公式（Temporal-Difference Learning，PDF 141–162）

全部公式对照 `work/pages/pNNNN.png` 页面渲染图逐条重建，未参考文字层的数学片段。

代码即 Typst 数学代码。块级公式写成 `$ ... $`（两侧留空格），行内公式写成 `$...$`；章文件里直接照抄即可。原书带编号的公式在代码之后给出标签，编号由模板生成。本章除伪代码框内的行内式之外没有不带编号的展示公式；框内公式单列一节。

写 Typst 数学时的强制规则：下标是单独一个标识符或符号，后面紧跟 `(` 或 `[` 时，中间必须留一个空格。本章反复出现的写法有 `$v_pi (s)$`、`$q_pi (s, a)$`、`$Q_1 (s, a)$`、`$bb(E)_pi [G_t | S_t = s]$`、`$Q_2 (S', op("argmax", limits: #true)_a Q_1 (S', a))$`。不留空格时 Typst 把括号吞进下标，编译不报错，肉眼容易看漏。下标是括号组（`S_(t+1)`、`A_(t+1)`、`delta_(T-1)`、`rho_(t:t)`）时不受影响。

其余写法约定：

- 赋值箭头写成 `arrow.l`（←）。定义符号直接写 `≐`。
- `argmax` 不是 Typst 内置算子，写成 `op("argmax", limits: #true)`，下标才能排在单词下方，与原书一致。`max_a`、`sum_a`、`sum_(k=t)^(T-1)` 用裸写法，Typst 在块级公式里把上下限排在符号下方、在行内公式里排在符号右侧，与本章原书的排版选择恰好相同。
- 集合与期望：状态集、动作集是花体 `cal(S)`、`cal(A)`；`cal(S)^+` 是非终止状态集合；期望是空心粗体 E，写成 `bb(E)`，带策略下标时写 `bb(E)_pi [·]`。
- 斜体的状态名（随机游走例子的 A 到 E、例题 6.4 的 A 与 B）写成 `"A"`、`"B"` 等；正文里这些字母在原书是无衬线体。
- 分式一律写成 `frac(...)`；练习 6.6 的六个取值写成 `frac(1, 6)` 等。乘法点号写成 `dot.op`。
- 伪代码框里的词用引号字符串排直立体：`"until"`、`"terminal"`、`"is terminal"`；斜体词写成 `italic("Returns")` 一类。`op("TD")(lambda)`、`op("TD")(0)` 是本项目对 TD(λ)、TD(0) 的统一写法。
- 三条公式的行内与块级括号在原书里是方括号 `[ ]`，直接照写；双 Q 学习框里的括号是圆括号 `( )`，按原书写圆括号，不要改成方括号。

## (6.1)   PDF p.141

单行展示，行末逗号。

```typst
$ V(S_t) arrow.l V(S_t) + alpha [G_t - V(S_t)], $ <eq-6-1>
```

## (6.2)   PDF p.142

单行展示，行末没有标点。

```typst
$ V(S_t) arrow.l V(S_t) + alpha [R_(t+1) + gamma V(S_(t+1)) - V(S_t)] $ <eq-6-2>
```

## (6.3), (6.4)   PDF p.142

原书这一组推导排成一个三行对齐展示，第 1 行右侧排编号 (6.3)，第 2 行右侧排括注 (from (3.9))，第 3 行右侧排编号 (6.4)。Typst 的公式编号由计数器自动生成，一个展示只能带一个编号，因此 `source.md` 在这里放两个占位符，翻译阶段照下面写成两块：第一块是第 1 行，带标签 `<eq-6-3>`；第二块接第 2、3 行，带标签 `<eq-6-4>`，两块之间不留正文。

```typst
$ v_pi (s) ≐ bb(E)_pi [G_t | S_t = s] $ <eq-6-3>
```

```typst
$ &quad = bb(E)_pi [R_(t+1) + gamma G_(t+1) | S_t = s] &quad "(from (3.9))" \
  &quad = bb(E)_pi [R_(t+1) + gamma v_pi (S_(t+1)) | S_t = s]. $ <eq-6-4>
```

## (6.5)   PDF p.143

单行展示，行末句号。

```typst
$ delta_t ≐ R_(t+1) + gamma V(S_(t+1)) - V(S_t). $ <eq-6-5>
```

## (6.6)   PDF p.143

六行对齐展示。第 1 行右端排括注 `"(from (3.9))"`，第 5 行的括号里是 `0 - 0`（终止状态的值与回报都取零），最后一行是紧凑的求和形式，编号 (6.6) 排在这一行右侧。

```typst
$ G_t - V(S_t) &= R_(t+1) + gamma G_(t+1) - V(S_t) + gamma V(S_(t+1)) - gamma V(S_(t+1)) &quad "(from (3.9))" \
               &= delta_t + gamma (G_(t+1) - V(S_(t+1))) \
               &= delta_t + gamma delta_(t+1) + gamma^2 (G_(t+2) - V(S_(t+2))) \
               &= delta_t + gamma delta_(t+1) + gamma^2 delta_(t+2) + dots.c + gamma^(T-t-1) delta_(T-1) + gamma^(T-t) (G_T - V(S_T)) \
               &= delta_t + gamma delta_(t+1) + gamma^2 delta_(t+2) + dots.c + gamma^(T-t-1) delta_(T-1) + gamma^(T-t) (0 - 0) \
               &= sum_(k=t)^(T-1) gamma^(k-t) delta_k. $ <eq-6-6>
```

## (6.7)   PDF p.151

单行展示，行末句号。

```typst
$ Q(S_t, A_t) arrow.l Q(S_t, A_t) + alpha [R_(t+1) + gamma Q(S_(t+1), A_(t+1)) - Q(S_t, A_t)]. $ <eq-6-7>
```

## (6.8)   PDF p.153

单行展示，行末句号。`max` 的下标 `a` 在原书排在 `max` 下方。

```typst
$ Q(S_t, A_t) arrow.l Q(S_t, A_t) + alpha [R_(t+1) + gamma max_a Q(S_(t+1), a) - Q(S_t, A_t)]. $ <eq-6-8>
```

## (6.9)   PDF p.155

两行对齐展示，行末逗号。第 2 行的求和号在原书里上下限排在符号正下方。

```typst
$ Q(S_t, A_t) &arrow.l Q(S_t, A_t) + alpha [R_(t+1) + gamma bb(E)_pi [Q(S_(t+1), A_(t+1)) | S_(t+1)] - Q(S_t, A_t)] \
              &= Q(S_t, A_t) + alpha [R_(t+1) + gamma sum_a pi (a|S_(t+1)) Q(S_(t+1), a) - Q(S_t, A_t)], $ <eq-6-9>
```

## (6.10)   PDF p.158

单行展示，行末句号；原书这一条很长，编号紧跟在公式末尾而不是页边。`argmax` 的下标 `a` 排在单词下方。

```typst
$ Q_1 (S_t, A_t) arrow.l Q_1 (S_t, A_t) + alpha [R_(t+1) + gamma Q_2 (S_(t+1), op("argmax", limits: #true)_a Q_1 (S_(t+1), a)) - Q_1 (S_t, A_t)]. $ <eq-6-10>
```

## 伪代码框内公式

框内的公式是行内公式（求和号与上下限排在符号右侧，与原书一致），因此写成 `$...$` 而不是 `$ ... $`；它们不带编号，`source.md` 的框里也没有占位符。

### PDF p.142 「Tabular TD(0) for estimating v_π」框

- 输入与参数：`$pi$`、`$alpha in (0, 1]$`
- 初始化：`$V(s)$`、`$s in cal(S)^+$`、`$V("terminal") = 0$`
- 逐步循环：`$S$`
- 动作与转移：`$A$`、`$R$`、`$S'$`
- 更新：`$V(S) arrow.l V(S) + alpha [R + gamma V(S') - V(S)]$`
- 推进与终止：`$S arrow.l S'$`、`$"until" S "is terminal"$`

### PDF p.152 「Sarsa (on-policy TD control) for estimating Q ≈ q_*」框

- 参数：`$alpha in (0, 1]$`、`$epsilon > 0$`
- 初始化：`$Q(s, a)$`、`$s in cal(S)^+$`、`$a in cal(A)(s)$`、`$Q("terminal", dot.op) = 0$`
- 逐步循环：`$S$`
- 选择动作：`$A$`、`$Q$`、`$epsilon$`（“$\epsilon$-greedy”）
- 转移与下一动作：`$A$`、`$R$`、`$S'$`、`$A'$`
- 更新：`$Q(S, A) arrow.l Q(S, A) + alpha [R + gamma Q(S', A') - Q(S, A)]$`
- 推进与终止：`$S arrow.l S'$`、`$A arrow.l A'$`、`$"until" S "is terminal"$`

### PDF p.153 「Q-learning (off-policy TD control) for estimating π ≈ π_*」框

- 参数与初始化：同 Sarsa 框
- 选择动作：`$A$`、`$Q$`、`$epsilon$`（“$\epsilon$-greedy”）
- 更新：`$Q(S, A) arrow.l Q(S, A) + alpha [R + gamma max_a Q(S', a) - Q(S, A)]$`
- 推进与终止：`$S arrow.l S'$`、`$"until" S "is terminal"$`

### PDF p.158 「Double Q-learning, for estimating Q_1 ≈ Q_2 ≈ q_*」框

- 参数：`$alpha in (0, 1]$`、`$epsilon > 0$`
- 初始化：`$Q_1 (s, a)$`、`$Q_2 (s, a)$`、`$s in cal(S)^+$`、`$a in cal(A)(s)$`、`$Q("terminal", dot.op) = 0$`
- 选择动作：`$A$`、`$Q_1 + Q_2$`、`$epsilon$`（“$\epsilon$-greedy in $Q_1 + Q_2$”）
- 转移：`$A$`、`$R$`、`$S'$`
- 掷币分支：`$0.5$`（原文 “With 0.5 probability:”）
- 两个更新（原书用圆括号，不要改成方括号）：

```typst
$ Q_1 (S, A) arrow.l Q_1 (S, A) + alpha (R + gamma Q_2 (S', op("argmax", limits: #true)_a Q_1 (S', a)) - Q_1 (S, A)) $
$ Q_2 (S, A) arrow.l Q_2 (S, A) + alpha (R + gamma Q_1 (S', op("argmax", limits: #true)_a Q_2 (S', a)) - Q_2 (S, A)) $
```

- 推进与终止：`$S arrow.l S'$`、`$"until" S "is terminal"$`

## 行内公式

只收录有结构或者容易写错的行内式。单字母变量与 `$v_pi (s)$`、`$q_pi (s, a)$`、`$v_* (s)$`、`$q_* (s, a)$` 这类贯穿全章的符号，写法见 `glossary/notation.typ`。

### PDF p.141

- `$op("TD")(lambda)$`：第 12 章引入的 TD(λ) 算法（正文里写作 TD(λ)）。

### PDF p.142

- `$op("TD")(0)$`：一步 TD 方法。
- `$G_t$`：蒙特卡洛更新的目标。
- `$R_(t+1) + gamma V(S_(t+1))$`：TD(0) 更新的目标。
- `$lambda$`：TD(λ) 中的参数。

### PDF p.143

- `$delta_t$`：TD 误差。`$V(S_t)$` 的估计与更好估计之差的度量。
- `$R_(t+1) + gamma V(S_(t+1))$`：括号里的量，即 TD 目标。
- `$t + 1$`：δ_t 可用的时刻。

### PDF p.144

- `$gamma = 1$`：该例题不折扣。
- `$G_t - V(S_t)$`：退出高速公路时的误差，为 8 分钟。
- `$frac(1, 2)$`：步长参数 α 取 1/2 时，估计值上调的四分钟。
- `$G_t$`、`$S_t$`：回报与状态。

### PDF p.145

- `$alpha = 1$`：图 6.1 右图按 α = 1 的 TD 规则给出。

### PDF p.146

- `$op("TD")(0)$`、`$v_pi$`：对任意固定策略，TD(0) 收敛到 v_π。

### PDF p.147

- `$"C"$`：随机游走的中心状态。
- `$v_pi ("C") = 0.5$`：中心状态的真实值。
- `$"C", 0, "B", 0, "C", 0, "D", 0, "E", 1$`：一个典型剧集的状态与奖励交替序列（状态名是无衬线体）。
- `$alpha = 0.1$`：左图的步长参数。
- `$V(s) = 0.5$`：全部状态的值函数初值。

### PDF p.148

- `$V("A")$`：练习 6.3 中第一个剧集唯一改变的状态值。
- `$alpha$`：练习 6.4、6.5 讨论的步长参数。
- `$frac(1, 6), frac(2, 6), frac(3, 6), frac(4, 6), frac(5, 6)$`：练习 6.6 中状态 A 到 E 的真实值。

### PDF p.149

- `$V("A")$`、`$V("B")$`：例题 6.4 待估的两个价值。
- `$frac(3, 4)$`：V(B) 的最优取值（8 个剧集中有 6 个回报为 1）。
- `$V("A") = frac(3, 4)$`：批式 TD(0) 给出的答案。

### PDF p.150

- `$V("A") = 0$`：批式蒙特卡洛给出的答案。
- `$n = |cal(S)|$`、`$n^2$`、`$n^3$`：状态数，以及最大似然建模与常规求解值函数所需的内存与计算量阶数。

### PDF p.151

- `$q_pi (s, a)$`：on-policy 方法要估计的动作值函数。
- `$(S_t, A_t, R_(t+1), S_(t+1), A_(t+1))$`：一步转移的五元组，Sarsa 的名字来源。
- `$Q(S_(t+1), A_(t+1)) = 0$`：S_{t+1} 终止时该动作值定义为零。
- `$epsilon$`、`$epsilon = 1 slash t$`：ε-贪心策略与 ε = 1/t 的取值方式。

### PDF p.152

- `$epsilon = 0.1$`、`$alpha = 0.5$`、`$Q(s, a) = 0$`：风之网格世界的参数与初值。

### PDF p.153

- `$q_*$`：Q 直接逼近的最优动作值函数。

### PDF p.155

- `$S_(t+1)$`、`$A_(t+1)$`：给定后继状态与在该状态上取期望时消去方差的下一个动作。
- `$pi (a|S_(t+1))$`：当前策略下各动作的概率。
- `$alpha = 1$`：在悬崖行走上 Expected Sarsa 取 α = 1 不掉性能。

### PDF p.156

- `$q(s, a)$`、`$Q(s, a)$`：真实值与不确定的估计值。
- `$-0.1$`、`$1.0$`：例题 6.7 中奖励的正态分布均值与方差。

### PDF p.157

- `$Q_1 (a)$`、`$Q_2 (a)$`、`$q(a)$`、`$a in cal(A)$`：两个独立估计与真实值。
- `$A^* = op("argmax", limits: #true)_a Q_1 (a)$`：由 Q_1 确定最大化的动作。
- `$Q_2 (A^*) = Q_2 (op("argmax", limits: #true)_a Q_1 (a))$`：用 Q_2 给出该动作值的估计，这一估计无偏。
- `$bb(E)[Q_2 (A^*)] = q(A^*)$`：无偏性的写法。
- `$Q_1 (op("argmax", limits: #true)_a Q_2 (a))$`：交换两个估计的角色得到的第二个无偏估计。
- `$epsilon = 0.1$`、`$alpha = 0.1$`、`$gamma = 1$`：图 6.5 的参数；`$5%$` 是 ε-贪心给每个动作的最小概率。

### PDF p.158

- `$Q_1$`、`$Q_2$`：两个近似值函数，行为策略可以基于 `$Q_1 + Q_2$`。

### PDF p.159

- `$"afterstates"$`、`$"afterstate"$`：原书正文用斜体排这两个词（写作 *afterstates*、*afterstate value functions*），不是数学变量。
