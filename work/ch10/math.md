# 第 10 章公式（On-policy Control with Approximation，PDF 265–278）

全部公式对照 `work/pages/pNNNN.png` 页面渲染图逐条重建，未参考文字层的数学片段。

代码即 Typst 数学代码。块级公式写成 `$ ... $`（两侧留空格），行内公式写成 `$...$`；章文件里直接照抄即可。原书带编号的公式在代码之后给出标签，编号由模板生成。原书中不编号的展示公式按其在页面上的先后记为 `(unnumbered pNNN-k)`，与 `source.md` 的占位符一一对应；伪代码框内的公式单列一节。

写法约定沿用第 9 章：下标是单独一个标识符或符号、后面紧跟 `(` 或 `[` 时中间必须留空格（`v_pi (s)`、`q_pi (s, a)`、`pi (a|s)`、`mu_pi (s)`、`x_i (s, a)`、`v_pi^gamma (s)`）；下标是括号组或标记组合（`bold(w)_(t+1)`、`G_(t:t+n)`、`overline(R)_(t+n-1)`）时不受影响。集合记号写 `cal(S)`、`cal(A)`，实数集写 `bb(R)`，`d` 维实空间写 `bb(R)^d`；期望写 `bb(E)`，带策略下标时写 `bb(E)_pi`；定义为的符号直接写 `≐`；上划线写 `overline(...)`；分式写 `frac(...)`；转置写 `^top`；梯度算子写 `nabla`。

本章特有：

- 动作价值函数带帽写 `hat(q)`，参数表写 `(s, a, bold(w))`；参数向量是粗体 `bold(w)`，特征向量是粗体 `bold(x)`。差分算法里平均奖励的估计写 `overline(R)`，步号下标写进括号组（`overline(R)_t`、`overline(R)_(t+n-1)`）。
- 平均奖励与差分的记号：`r(pi)`（策略 π 的平均奖励）、`mu_pi (s)`（稳态分布）、`delta_t`（差分形式的 TD 误差）、`G_(t:t+n)`（n 步差分回报）。
- `bound` 在 (unnumbered p267-1)、(unnumbered p267-2) 里是数学斜体，写 `italic("bound")`；`and` 是正体，写 `"and"`。
- 服从分布的关系符号 `∼` 沿用第 9 章的 `tilde`（见 (10.6)、(10.7) 与正文行内稳态分布的定义）。
- 加法式中段的居中省略号写 `dots.c`（(10.4)、(10.9)、(10.14) 与 p276 的框中）；正文行内序列的省略号写 `dots.h`（如 `+1, 0, +1, 0, ...`）。
- 分式：(10.6) 的 `1/h` 是上下叠排的 `frac(1, h)`，p276 框末行的 `1/(1 - gamma)` 同样是叠排分式；正文行内的 `r(pi) slash (1 - gamma)` 与练习里的 `1 slash 3` 是斜线除号，写 `slash`。
- `argmax` 的下标排在符号正下方，写 `op("argmax", limits: #true)_a`（与第 4 章一致）。

## (10.1)   PDF p.266

动作价值的随机梯度下降更新的一般形式。方括号内是目标 `U_t` 与当前估计之差，末尾句点。

```typst
$ bold(w)_(t+1) ≐ bold(w)_t + alpha [U_t - hat(q)(S_t, A_t, bold(w)_t)] nabla hat(q)(S_t, A_t, bold(w)_t). $ <eq-10-1>
```

## (10.2)   PDF p.266

一步 Sarsa 的更新，即 (10.1) 取目标 `R_(t+1) + gamma hat(q)(S_(t+1), A_(t+1), bold(w)_t)`。

```typst
$ bold(w)_(t+1) ≐ bold(w)_t + alpha [R_(t+1) + gamma hat(q)(S_(t+1), A_(t+1), bold(w)_t) - hat(q)(S_t, A_t, bold(w)_t)] nabla hat(q)(S_t, A_t, bold(w)_t). $ <eq-10-2>
```

## (unnumbered p267-1)   PDF p.267

Mountain Car 的位置更新。`bound` 是数学斜体的算子名，方括号是普通方括号；**这一行末尾没有逗号**。

```typst
$ x_(t+1) ≐ italic("bound")[x_t + dot(x)_(t+1)] $
```

## (unnumbered p267-2)   PDF p.267

Mountain Car 的速度更新，末尾有逗号。“bound” 同样是斜体。

```typst
$ dot(x)_(t+1) ≐ italic("bound")[dot(x)_t + 0.001 A_t - 0.0025 cos(3x_t)], $
```

## (10.3)   PDF p.268

线性逼近的定义，两条等价写法。`w_i cdot x_i` 中间的乘号是居中点，写 `dot.op`。

```typst
$ hat(q)(s, a, bold(w)) ≐ bold(w)^top bold(x)(s, a) = sum_(i=1)^d w_i dot.op x_i (s, a), $ <eq-10-3>
```

## (10.4)   PDF p.269

n 步回报的函数逼近形式，条件 `t + n < T` 排在公式右侧。

```typst
$ G_(t:t+n) ≐ R_(t+1) + gamma R_(t+2) + dots.c + gamma^(n-1) R_(t+n) + gamma^n hat(q)(S_(t+n), A_(t+n), bold(w)_(t+n-1)), quad t + n < T, $ <eq-10-4>
```

## (10.5)   PDF p.269

n 步半梯度 Sarsa 的更新式，条件 `0 <= t < T` 排在公式右侧，末尾句点。

```typst
$ bold(w)_(t+n) ≐ bold(w)_(t+n-1) + alpha [G_(t:t+n) - hat(q)(S_t, A_t, bold(w)_(t+n-1))] nabla hat(q)(S_t, A_t, bold(w)_(t+n-1)), quad 0 <= t < T. $ <eq-10-5>
```

## (10.6)   PDF p.271

平均奖励的定义。一步的分式是叠排的 `frac(1, h)`，求和上限 `h` 排在求和号上方，条件里的关系符号是 `tilde`。

```typst
$ r(pi) ≐ lim_(h -> oo) frac(1, h) sum_(t=1)^h bb(E)[R_t | S_0, A_(0:t-1) tilde pi] $ <eq-10-6>
```

## (10.7)   PDF p.271

(10.6) 的第二个等号行，等号与上一行左端对齐。原书 `source.md` 里它是紧接 (10.6) 的一行。

```typst
$ = lim_(t -> oo) bb(E)[R_t | S_0, A_(0:t-1) tilde pi], $ <eq-10-7>
```

## (unnumbered p271-1)   PDF p.271

(10.7) 的第三个等号行，**原书这一行没有编号**，末尾逗号。对 `s'` 与 `r` 的求和是同一个求和号下的并列下标 `(s', r)`。

```typst
$ = sum_s mu_pi (s) sum_a pi (a|s) sum_(s', r) p(s', r | s, a) r, $
```

## (10.8)   PDF p.271

稳态分布在策略下的自洽条件，末尾句点。

```typst
$ sum_s mu_pi (s) sum_a pi (a|s) p(s' | s, a) = mu_pi (s'). $ <eq-10-8>
```

## (10.9)   PDF p.272

差分回报的定义。省略号是居中点 `dots.c`，其后紧跟句点。

```typst
$ G_t ≐ R_(t+1) - r(pi) + R_(t+2) - r(pi) + R_(t+3) - r(pi) + dots.c . $ <eq-10-9>
```

## (unnumbered p272-1)   PDF p.272

差分形式的 `v_pi` 贝尔曼方程，末尾逗号。

```typst
$ v_pi (s) = sum_a pi (a|s) sum_(r, s') p(s', r | s, a) [r - r(pi) + v_pi (s')], $
```

## (unnumbered p272-2)   PDF p.272

差分形式的 `q_pi` 贝尔曼方程，末尾逗号。方括号内的末项是对 `a'` 的求和。

```typst
$ q_pi (s, a) = sum_(r, s') p(s', r | s, a) [r - r(pi) + sum_(a') pi (a'|s') q_pi (s', a')], $
```

## (unnumbered p272-3)   PDF p.272

差分形式的 `v_*` 贝尔曼最优方程。原书把 `and` 接在这一行的逗号之后，同一行。

```typst
$ v_*(s) = max_a sum_(r, s') p(s', r | s, a) [r - max_pi r(pi) + v_*(s')], quad "and" $
```

## (unnumbered p272-4)   PDF p.272

差分形式的 `q_*` 贝尔曼最优方程，末尾没有标点。

```typst
$ q_*(s, a) = sum_(r, s') p(s', r | s, a) [r - max_pi r(pi) + max_(a') q_*(s', a')] $
```

## (10.10)   PDF p.272

状态值的差分 TD 误差。`overline(R)_t` 是平均奖励在时刻 `t` 的估计。

```typst
$ delta_t ≐ R_(t+1) - overline(R)_t + hat(v)(S_(t+1), bold(w)_t) - hat(v)(S_t, bold(w)_t), $ <eq-10-10>
```

## (10.11)   PDF p.272

动作值的差分 TD 误差，把 (10.10) 的 `hat(v)` 换成 `hat(q)` 并带上动作。

```typst
$ delta_t ≐ R_(t+1) - overline(R)_t + hat(q)(S_(t+1), A_(t+1), bold(w)_t) - hat(q)(S_t, A_t, bold(w)_t), $ <eq-10-11>
```

## (10.12)   PDF p.272

平均奖励版的半梯度 Sarsa 更新，`delta_t` 取 (10.11)。

```typst
$ bold(w)_(t+1) ≐ bold(w)_t + alpha delta_t nabla hat(q)(S_t, A_t, bold(w)_t), $ <eq-10-12>
```

## (10.13)   PDF p.273

练习 10.6 中给出的差分价值函数的替代定义，重排自 (10.9) 的极限。两个 `lim` 并列，外层对 `gamma`、内层对 `h`；圆括号内是期望与平均奖励之差，末尾句点。

```typst
$ v_pi (s) ≐ lim_(gamma -> 1) lim_(h -> oo) sum_(t=0)^h gamma^t ( bb(E)_pi [R_(t+1) | S_0 = s] - r(pi) ). $ <eq-10-13>
```

## (unnumbered p276-1)   PDF p.276

「The Futility of Discounting in Continuing Problems」框中的九行对齐推导，前五行右侧有括注，末行是叠排分式。各行以第二个 `&` 对齐右侧的注文。

```typst
$ J(pi) &= sum_s mu_pi (s) v_pi^gamma (s) &quad "(where" v_pi^gamma "is the discounted value function)" \
        &= sum_s mu_pi (s) sum_a pi (a|s) sum_(s') sum_r p(s', r | s, a) [r + gamma v_pi^gamma (s')] &quad "(Bellman Eq.)" \
        &= r(pi) + sum_s mu_pi (s) sum_a pi (a|s) sum_(s') sum_r p(s', r | s, a) gamma v_pi^gamma (s') &quad "(from (10.7))" \
        &= r(pi) + gamma sum_(s') v_pi^gamma (s') sum_s mu_pi (s) sum_a pi (a|s) p(s' | s, a) &quad "(from (3.4))" \
        &= r(pi) + gamma sum_(s') v_pi^gamma (s') mu_pi (s') &quad "(from (10.8))" \
        &= r(pi) + gamma J(pi) \
        &= r(pi) + gamma r(pi) + gamma^2 J(pi) \
        &= r(pi) + gamma r(pi) + gamma^2 r(pi) + gamma^3 r(pi) + dots.c \
        &= frac(1, 1 - gamma) r(pi). $
```

## (10.14)   PDF p.277

n 步差分回报。**原书在第一个奖励项与自举项里两次都印作 `overline(R)_(t+n-1)`**，照原样重建；末尾逗号。

```typst
$ G_(t:t+n) ≐ R_(t+1) - overline(R)_(t+n-1) + dots.c + R_(t+n) - overline(R)_(t+n-1) + hat(q)(S_(t+n), A_(t+n), bold(w)_(t+n-1)), $ <eq-10-14>
```

## (10.15)   PDF p.277

n 步差分 TD 误差。这里的 `hat(q)` 没有步号下标，末尾逗号。

```typst
$ delta_t ≐ G_(t:t+n) - hat(q)(S_t, A_t, bold(w)), $ <eq-10-15>
```

## 伪代码框内公式

框内的公式是行内公式（求和号与上下限排在符号右侧，与原书一致），因此写成 `$...$` 而不是 `$ ... $`；它们不带编号，`source.md` 的框里也没有占位符。赋值箭头一律写 `arrow.l`（原书为 `←`）；采样写 `$A tilde pi (dot.op | S)$`；无穷大写 `oo`；`≥`、`≠`、`→` 分别写 `>=`、`!=`、`->`；斜线除号写 `slash`。

### PDF p.266 「Episodic Semi-gradient Sarsa for Estimating q̂ ≈ q_*」框

- 函数与参数：`$hat(q) : cal(S) × cal(A) × bb(R)^d -> bb(R)$`、`$alpha > 0$`、`$epsilon > 0$`
- 初始化：`$bold(w) in bb(R)^d$`，"e.g.," 后跟 `$bold(w) = bold(0)$`
- 剧集初始化：`$S, A arrow.l$` 剧集的初始状态与动作（如 ε-greedy）
- 观测：`$R$`、`$S'$`
- 终止分支的更新：`$bold(w) arrow.l bold(w) + alpha [R - hat(q)(S, A, bold(w))] nabla hat(q)(S, A, bold(w))$`
- 动作选择：`$A'$` 作为 `$hat(q)(S', dot.op, bold(w))$` 的函数（如 ε-greedy）
- 更新：`$bold(w) arrow.l bold(w) + alpha [R + gamma hat(q)(S', A', bold(w)) - hat(q)(S, A, bold(w))] nabla hat(q)(S, A, bold(w))$`
- 状态与动作推进：`$S arrow.l S'$`、`$A arrow.l A'$`

### PDF p.269 「Episodic semi-gradient n-step Sarsa for estimating q̂ ≈ q_* or q_π」框

- 函数规格与参数：`$hat(q) : cal(S) × cal(A) × bb(R)^d -> bb(R)$`、`$pi$`（估计 `$q_pi$` 时给出）、`$alpha > 0$`、`$epsilon > 0$`、`$n$`（正整数）
- 存储说明：`$S_t$`、`$A_t$`、`$R_t$` 的索引取模 `$n + 1$`
- 剧集初始化：`$S_0 != "terminal"$`、`$A_0 tilde pi (dot.op | S_0)$` 或关于 `$hat(q)(S_0, dot.op, bold(w))$` 的 ε-greedy、`$T arrow.l oo$`
- 步号与行为：`$t = 0, 1, 2, ...$`、`$t < T$`、`$A_t$`（框内自 `$t < T$` 起的若干行左侧有竖线标记循环体）
- 记录下一步：`$R_(t+1)$`、`$S_(t+1)$`；`$S_(t+1)$` 终止时 `$T arrow.l t + 1$`，否则 `$A_(t+1) tilde pi (dot.op | S_(t+1))$`
- 待更新步号：`$tau arrow.l t - n + 1$`、`$tau >= 0$`
- 回报累加：`$G arrow.l sum_(i=tau+1)^(min(tau+n, T)) gamma^(i - tau - 1) R_i$`
- 自举项：`$tau + n < T$` 时 `$G arrow.l G + gamma^n hat(q)(S_(tau+n), A_(tau+n), bold(w))$`（右侧括注 `$(G_(tau:tau+n))$`）
- 更新：`$bold(w) arrow.l bold(w) + alpha [G - hat(q)(S_tau, A_tau, bold(w))] nabla hat(q)(S_tau, A_tau, bold(w))$`
- 终止判据：`$tau = T - 1$`

### PDF p.273 「Differential semi-gradient Sarsa for estimating q̂ ≈ q_*」框

- 函数与参数：`$hat(q) : cal(S) × cal(A) × bb(R)^d -> bb(R)$`、`$alpha, beta > 0$`、`$epsilon > 0$`
- 初始化：`$bold(w) in bb(R)^d$`（"e.g.," 后跟 `$bold(w) = bold(0)$`）、`$overline(R) in bb(R)$`（"e.g.," 后跟 `$overline(R) = 0$`）
- 状态与动作初始化：`$S$`、`$A$`
- 观测：`$R$`、`$S'$`
- 动作选择：`$A'$` 作为 `$hat(q)(S', dot.op, bold(w))$` 的函数（如 ε-greedy）
- 差分误差：`$delta arrow.l R - overline(R) + hat(q)(S', A', bold(w)) - hat(q)(S, A, bold(w))$`
- 平均奖励更新：`$overline(R) arrow.l overline(R) + beta delta$`
- 权重更新：`$bold(w) arrow.l bold(w) + alpha delta nabla hat(q)(S, A, bold(w))$`
- 状态与动作推进：`$S arrow.l S'$`、`$A arrow.l A'$`

### PDF p.277 「Differential semi-gradient n-step Sarsa for estimating q̂ ≈ q_π or q_*」框

- 函数规格与参数：`$hat(q) : cal(S) × cal(A) × bb(R)^d -> bb(R)$`、`$pi$`、`$alpha, beta > 0$`、`$epsilon > 0$`、`$n$`（正整数）
- 存储说明：`$S_t$`、`$A_t$`、`$R_t$` 的索引取模 `$n + 1$`
- 初始化：`$bold(w) in bb(R)^d$`（"e.g.," 后跟 `$bold(w) = bold(0)$`）、`$overline(R) in bb(R)$`（"e.g.," 后跟 `$overline(R) = 0$`）、`$S_0$`、`$A_0$`
- 步号：`$t = 0, 1, 2, ...$`
- 行为与观测：`$A_t$`、`$R_(t+1)$`、`$S_(t+1)$`
- 动作选择：`$A_(t+1) tilde pi (dot.op | S_(t+1))$`，或关于 `$hat(q)(S_(t+1), dot.op, bold(w))$` 的 ε-greedy
- 待更新步号：`$tau arrow.l t - n + 1$`、`$tau >= 0$`
- 差分误差：`$delta arrow.l sum_(i=tau+1)^(tau+n) (R_i - overline(R)) + hat(q)(S_(tau+n), A_(tau+n), bold(w)) - hat(q)(S_tau, A_tau, bold(w))$`
- 平均奖励更新：`$overline(R) arrow.l overline(R) + beta delta$`
- 权重更新：`$bold(w) arrow.l bold(w) + alpha delta nabla hat(q)(S_tau, A_tau, bold(w))$`

## 行内公式

只收录有结构或者容易写错的行内式。单字母变量（*s*、*a*、*r*、*w*、*α*、*β*、*γ*、*ε*、*τ*、*n*、*d*、*t*、*T*）与 `hat(q)(s, a, bold(w))`、`pi (a|s)`、`p(s', r | s, a)` 这类贯穿全章的符号，写法见 `glossary/notation.typ`，不逐处重复。

### PDF p.265

- `$hat(q)(s, a, bold(w)) approx q_*(s, a)$`：动作价值函数的参数化近似（`approx` 渲染 ≈）。
- `$bold(w) in bb(R)^d$`：权重向量是有限维实向量。
- `$hat(q) approx q_pi$`：10.1 节首句里被逼近的动作价值函数。
- `$S_t mapsto U_t$`、`$S_t, A_t mapsto U_t$`：预测与控制各自的训练样例形式（`mapsto` 渲染 ↦）。
- `$U_t$` 的取值形式：`$G_t$`、`$n$` 步 Sarsa 回报 (7.4)。

### PDF p.266

- `$hat(q)(S_(t+1), a, bold(w)_t)$`：对下一状态各动作的价值估计。
- `$A^*_(t+1) = op("argmax", limits: #true)_a hat(q)(S_(t+1), a, bold(w)_t)$`：贪心动作（`argmax` 的下标在符号下方）。
- 误差界引用 (9.14)；`$epsilon$`-greedy 策略。

### PDF p.267

- `$x_t$`、`$dot(x)_t$`：小车的位置与速度（点号写成 `dot(x)`）。
- `$-1.2 <= x_(t+1) <= 0.5$`、`$-0.07 <= dot(x)_(t+1) <= 0.07$`：`bound` 操作施加的范围。
- `$x_t in [-0.6, -0.4)$`：剧集初始位置所在的区间（右端开区间）。
- 三个动作：全速前进 `$+1$`、全速后退 `$-1$`、零油门 `$0$`。
- `$1 slash 8$`：每个 tile 覆盖的受界距离比例。

### PDF p.268

- `$bold(x)(s, a)$`：tile coding 生成的特征向量，与参数向量线性组合。
- 脚注 1 里的类型是打字机字体（等宽）：网址与 `iht=IHT(4096)`、`tiles(iht,8,[8*x/(0.5+1.2),8*xdot/(0.07+0.07)],[A])` 以及状态 `(x, xdot)` 与动作 `A`，`source.md` 已按等宽字体记入脚注，翻译阶段用 `raw` 呈现。
- `$epsilon = 0$`：该实验所用的探索参数。

### PDF p.269

- `$G_(t:t+n) ≐ G_t$`：当 `$t + n >= T$` 时的约定（正文行内，与 (10.4) 呼应）。
- `$n = 8$` 与 `$n = 1$`、`$n = 4$`、`$n = 16$`：图 10.3、图 10.4 涉及的步数。

### PDF p.270

- `$alpha = 0.5 slash 8$`、`$n = 1$`、`$alpha = 0.3 slash 8$`、`$n = 8$`：图 10.3 图注里的步长与步数（斜线除号）。

### PDF p.271

- `$r(pi)$`：策略 π 的平均奖励（平均每步奖励的速率）。
- `$mu_pi (s) ≐ lim_(t -> oo) "Pr"{S_t = s | A_(0:t-1) tilde pi}$`：稳态分布的定义，出现在正文行内。
- `$A_0, A_1, ..., A_(t-1)$`：期望所条件的后续动作序列。

### PDF p.272

- `$v_pi (s) ≐ bb(E)_pi [G_t | S_t = s]$`、`$q_pi (s, a) ≐ bb(E)_pi [G_t | S_t = s, A_t = a]$`：差分价值函数沿用与折扣情形相同的记号（`$v_*$`、`$q_*$` 同理）。
- `$overline(R)_t$`：时刻 `$t$` 的平均奖励估计。
- `(cf. (3.14), Exercise 3.17, (3.19), and (3.20))` 的引用。
- 两条 TD 误差之间用 `and`（正体）连接。

### PDF p.274

- `$p = 0.06$`：每个忙服务器在每步变为空闲的概率。
- `$alpha = 0.01$`、`$beta = 0.01$`、`$epsilon = 0.1$`：该实验的参数。
- `$overline(R)$`：平均奖励估计，初值为零。

### PDF p.275

- `$r(pi) slash (1 - gamma)$`：平均折扣回报恒等于此值（正文行内斜线除号）。
- `$1 + gamma + gamma^2 + gamma^3 + dots.c = 1 slash (1 - gamma)$`：每个奖励在平均折扣回报中的权重（省略号是居中点，末项是斜线除号）。
- `$t - 1$`、`$t - 2$`、`$t - 1000$`：对称性论证里奖励出现的各个时刻。

### PDF p.276

- 框内末行的 `1/(1 - gamma)` 是叠排分式，见 (unnumbered p276-1)。
- 正文行内 `$epsilon$`-greedification 与 `$gamma$`。

### PDF p.277

- `$overline(R)$`：`r(pi)` 的估计。
- `$n >= 1$`、`$t + n < T$`、`$t + n >= T$`：n 步回报的条件（正文行内）。
- `$G_(t:t+n) ≐ G_t$`：`$t + n >= T$` 时的约定。
- 框内：`$t = 0, 1, 2, ...$`、`$tau$`、`$tau >= 0$`、`$R_i - overline(R)$`。

### PDF p.278

- `$r(pi)$`：作为排序政策的标量平均奖励。
- `$overline(R)_t$`、`$delta_t$`、`$R_(t+1) - overline(R)_t$`：练习 10.8 中两组误差序列（该题见 PDF p.273 的下半页）。

## 练习里引用的公式

- 练习 10.5 说 “beyond 10.10”，即 (10.10) 之外还需要哪些式子来规定差分版 TD(0)。
- 练习 10.6 引用 (10.7)、(10.6)、(10.9)，并在题中给出 (10.13)。
- 练习 10.7 引用 (10.13)。
- 练习 10.8 引用 (10.10)（正文作 “using Equation 10.10”）与 (10.9)。
- 练习 10.9 引用练习 2.7 的常数步长技巧。
