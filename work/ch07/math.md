# 第 7 章公式（n-step Bootstrapping，PDF 163–180）

全部公式对照 `work/pages/pNNNN.png` 页面渲染图逐条重建，未参考文字层的数学片段。

代码即 Typst 数学代码。块级公式写成 `$ ... $`（两侧留空格），行内公式写成 `$...$`；章文件里直接照抄即可。原书带编号的公式在代码之后给出标签，编号由模板生成。原书中不编号的展示公式按其在页面上的先后记为 `(unnumbered pNNN-k)`，与 `source.md` 的占位符一一对应；伪代码框内的公式单列一节。

写法约定沿用第 5 章：下标是单独一个标识符或符号、后面紧跟 `(` 或 `[` 时中间必须留空格（`V_t (S_(t+1))`、`Q_t (s, a)`、`pi (a|s)`、`rho_t (R_(t+1) + dots.c)`）；下标是括号组（`G_(t:t+n)`、`rho_(t:t+n-1)`、`V_(t+n-1)`、`Q_(h-1)`）时不受影响。集合记号写 `cal(S)`、`cal(A)`，期望写 `bb(E)`，定义为写 `≐`，上划线写 `overline(...)`（本章的期望近似价值是 `overline(V)_t`、`overline(V)_(h-1)`），分式写 `frac(...)`，赋值箭头写 `arrow.l`。本章特有：重要性采样比写 `rho_(t:h)`，连乘写 `product_(k=t)^(min(h,T-1))`；不带下标的 σ、ρ 是原书排版（如 (7.17) 的正文说明），照写。

## (unnumbered p165-1)   PDF p.165

完全回报，链中省略号是横向居中省略号。原文上下文为 “the complete return:”。

```typst
$ G_t ≐ R_(t+1) + gamma R_(t+2) + gamma^2 R_(t+3) + dots.c + gamma^(T-t-1) R_T, $
```

## (unnumbered p165-2)   PDF p.165

单步回报，原文上下文为 “we call the *one-step return*:”。

```typst
$ G_(t:t+1) ≐ R_(t+1) + gamma V_t (S_(t+1)), $
```

## (unnumbered p165-3)   PDF p.165

双步回报，原文上下文为 “The target for a two-step update is the *two-step return*:”。

```typst
$ G_(t:t+2) ≐ R_(t+1) + gamma R_(t+2) + gamma^2 V_(t+1) (S_(t+2)), $
```

## (7.1)   PDF p.165

```typst
$ G_(t:t+n) ≐ R_(t+1) + gamma R_(t+2) + dots.c + gamma^(n-1) R_(t+n) + gamma^n V_(t+n-1) (S_(t+n)), $ <eq-7-1>
```

## (7.2)   PDF p.165

条件 `0 <= t < T` 与编号同一行排在公式右侧。

```typst
$ V_(t+n) (S_t) ≐ V_(t+n-1) (S_t) + alpha [G_(t:t+n) - V_(t+n-1) (S_t)], quad 0 <= t < T, $ <eq-7-2>
```

## (7.3)   PDF p.166

误差缩减性质。期望下标 π、条件竖线后是 `S_t = s`，两侧是绝对值记号。

```typst
$ max_s abs(bb(E)_pi [G_(t:t+n) | S_t = s] - v_pi (s)) <= gamma^n max_s abs(V_(t+n-1) (s) - v_pi (s)), $ <eq-7-3>
```

## (7.4)   PDF p.168

行末限定条件 `n >= 1, 0 <= t < T-n`；公式过宽，原书把编号 (7.4) 单独排在下一行右端。

```typst
$ G_(t:t+n) ≐ R_(t+1) + gamma R_(t+2) + dots.c + gamma^(n-1) R_(t+n) + gamma^n Q_(t+n-1) (S_(t+n), A_(t+n)), quad n >= 1, quad 0 <= t < T-n, $ <eq-7-4>
```

## (7.5)   PDF p.168

```typst
$ Q_(t+n) (S_t, A_t) ≐ Q_(t+n-1) (S_t, A_t) + alpha [G_(t:t+n) - Q_(t+n-1) (S_t, A_t)], quad 0 <= t < T, $ <eq-7-5>
```

## (7.6)   PDF p.170

练习 7.4 中的 TD 误差形式。求和上下限是 `min(t+n,T)-1`，编号 (7.6) 单独排在公式下方右端。

```typst
$ G_(t:t+n) = Q_(t-1) (S_t, A_t) + sum_(k=t)^(min(t+n,T)-1) gamma^(k-t) [R_(k+1) + gamma Q_k (S_(k+1), A_(k+1)) - Q_(k-1) (S_k, A_k)]. $ <eq-7-6>
```

## (7.7)   PDF p.170

Expected Sarsa 的 n 步回报。

```typst
$ G_(t:t+n) ≐ R_(t+1) + dots.c + gamma^(n-1) R_(t+n) + gamma^n overline(V)_(t+n-1) (S_(t+n)), quad t + n < T, $ <eq-7-7>
```

## (7.8)   PDF p.170

期望近似价值的定义，行末是 `for all s in cal(S)`，右端编号 (7.8)。

```typst
$ overline(V)_t (s) ≐ sum_a pi (a|s) Q_t (s, a), quad "for all" s in cal(S). $ <eq-7-8>
```

## (7.9)   PDF p.170

```typst
$ V_(t+n) (S_t) ≐ V_(t+n-1) (S_t) + alpha rho_(t:t+n-1) [G_(t:t+n) - V_(t+n-1) (S_t)], quad 0 <= t < T, $ <eq-7-9>
```

## (7.10)   PDF p.170

重要性采样比的定义，连乘上限是 `min(h,T-1)`。

```typst
$ rho_(t:h) ≐ product_(k=t)^(min(h,T-1)) frac(pi (A_k|S_k), b(A_k|S_k)). $ <eq-7-10>
```

## (7.11)   PDF p.171

```typst
$ Q_(t+n) (S_t, A_t) ≐ Q_(t+n-1) (S_t, A_t) + alpha rho_(t+1:t+n) [G_(t:t+n) - Q_(t+n-1) (S_t, A_t)], $ <eq-7-11>
```

## (7.12)   PDF p.172

n 步回报的递归写法，行末 `t < h < T`。

```typst
$ G_(t:h) = R_(t+1) + gamma G_(t+1:h), quad t < h < T, $ <eq-7-12>
```

## (7.13)   PDF p.172

带控制变量的离策略 n 步回报定义。

```typst
$ G_(t:h) ≐ rho_t (R_(t+1) + gamma G_(t+1:h)) + (1 - rho_t) V_(h-1) (S_t), quad t < h < T, $ <eq-7-13>
```

## (7.14)   PDF p.173

两行展示，第一行以定义记号 `≐` 开头，第二行以 `=` 接续，行末限定 `t < h <= T`；编号 (7.14) 单独排在公式下方右端。

```typst
$ G_(t:h) &≐ R_(t+1) + gamma (rho_(t+1) G_(t+1:h) + overline(V)_(h-1) (S_(t+1)) - rho_(t+1) Q_(h-1) (S_(t+1), A_(t+1))), \
         &= R_(t+1) + gamma rho_(t+1) (G_(t+1:h) - Q_(h-1) (S_(t+1), A_(t+1))) + gamma overline(V)_(h-1) (S_(t+1)), quad t < h <= T. $ <eq-7-14>
```

## (7.15)   PDF p.175

树备份的单步回报（与 Expected Sarsa 相同）。

```typst
$ G_(t:t+1) ≐ R_(t+1) + gamma sum_a pi (a|S_(t+1)) Q_t (S_(t+1), a), $ <eq-7-15>
```

## (unnumbered p175-1)   PDF p.175

双步树备份回报，三行；第一行以定义记号 `≐` 开头，第二行以 `+` 号缩进续接，第三行以 `=` 接续归并。求和下标是不等于式 `a != A_(t+1)`。

```typst
$ G_(t:t+2) &≐ R_(t+1) + gamma sum_(a != A_(t+1)) pi (a|S_(t+1)) Q_(t+1) (S_(t+1), a) \
            &quad + gamma pi (A_(t+1)|S_(t+1)) (R_(t+2) + gamma sum_a pi (a|S_(t+2)) Q_(t+1) (S_(t+2), a)) \
            &= R_(t+1) + gamma sum_(a != A_(t+1)) pi (a|S_(t+1)) Q_(t+1) (S_(t+1), a) + gamma pi (A_(t+1)|S_(t+1)) G_(t+1:t+2), $
```

## (7.16)   PDF p.175

树备份 n 步回报的递归定义。

```typst
$ G_(t:t+n) ≐ R_(t+1) + gamma sum_(a != A_(t+1)) pi (a|S_(t+1)) Q_(t+n-1) (S_(t+1), a) + gamma pi (A_(t+1)|S_(t+1)) G_(t+1:t+n), $ <eq-7-16>
```

## (unnumbered p175-2)   PDF p.175

树备份的动作价值更新式（n 步 Sarsa 的更新规则）。

```typst
$ Q_(t+n) (S_t, A_t) ≐ Q_(t+n-1) (S_t, A_t) + alpha [G_(t:t+n) - Q_(t+n-1) (S_t, A_t)], $
```

## (unnumbered p175-3)   PDF p.175

练习 7.11 的基于期望的 TD 误差求和式。连乘因子是 `gamma pi (A_i|S_i)`，连乘上限为 `k`。

```typst
$ G_(t:t+n) = Q(S_t, A_t) + sum_(k=t)^(min(t+n-1,T-1)) delta_k product_(i=t+1)^k gamma pi (A_i|S_i), $
```

## (unnumbered p177-1)   PDF p.177

把树备份 n 步回报先写成 horizon 形式、再写成期望近似价值的形式，三行对齐。

```typst
$ G_(t:h) &= R_(t+1) + gamma sum_(a != A_(t+1)) pi (a|S_(t+1)) Q_(h-1) (S_(t+1), a) + gamma pi (A_(t+1)|S_(t+1)) G_(t+1:h) \
         &= R_(t+1) + gamma overline(V)_(h-1) (S_(t+1)) - gamma pi (A_(t+1)|S_(t+1)) Q_(h-1) (S_(t+1), A_(t+1)) + gamma pi (A_(t+1)|S_(t+1)) G_(t+1:h) \
         &= R_(t+1) + gamma pi (A_(t+1)|S_(t+1)) (G_(t+1:h) - Q_(h-1) (S_(t+1), A_(t+1))) + gamma overline(V)_(h-1) (S_(t+1)), $
```

## (7.17)   PDF p.177

n 步 Q(σ) 的回报定义，两行；第一行以定义记号 `≐` 开头，第二行以 `+` 号缩进续接，编号排在第二行右端。

```typst
$ G_(t:h) ≐ R_(t+1) + gamma (sigma_(t+1) rho_(t+1) + (1 - sigma_(t+1)) pi (A_(t+1)|S_(t+1))) (G_(t+1:h) - Q_(h-1) (S_(t+1), A_(t+1))) \
        + gamma overline(V)_(h-1) (S_(t+1)), $ <eq-7-17>
```

## 伪代码框内公式

框内的公式是行内公式（求和号与上下限排在符号右侧，与原书一致），因此统一写成 `$...$`；两侧若留空格，Typst 会把公式排成独立成行的展示公式。它们不带编号，`source.md` 的框里也没有占位符。框里的赋值箭头统一写成 `arrow.l`，采样记号写成 `tilde`，例如 `$A_0 tilde pi (dot.op | S_0)$`；`glossary/notation.typ` 的总记号是 `$X tilde p$`。

### PDF p.166 「n-step TD」框

- 初始化与参数：`$V(s)$`、`$s in cal(S)$`、`$alpha in (0, 1]$`、`$n$`
- 存储与访问：`$S_t$`、`$R_t$`、`$n + 1$`
- 幕初始化：`$S_0 != "terminal"$`、`$T arrow.l infinity$`
- 循环与判断：`$t = 0, 1, 2, dots.c$`、`$t < T$`、`$pi (dot.op | S_t)$`、`$R_(t+1)$`、`$S_(t+1)$`、`$T arrow.l t + 1$`
- 更新时刻：`$tau arrow.l t - n + 1$`、`$tau >= 0$`
- 回报累加：`$G arrow.l sum_(i=tau+1)^(min(tau+n,T)) gamma^(i-tau-1) R_i$`、`$G arrow.l G + gamma^n V(S_(tau+n))$`、`$(G_(tau:tau+n))$`
- 更新：`$V(S_tau) arrow.l V(S_tau) + alpha [G - V(S_tau)]$`、`$tau = T - 1$`

### PDF p.169 「n-step Sarsa」框

- 初始化与参数：`$Q(s, a)$`、`$s in cal(S), a in cal(A)$`、`$alpha in (0, 1]$`、`$epsilon > 0$`、`$n$`
- 存储与访问：`$S_t$`、`$A_t$`、`$R_t$`、`$n + 1$`
- 幕初始化：`$S_0 != "terminal"$`、`$A_0 tilde pi (dot.op | S_0)$`、`$T arrow.l infinity$`
- 循环与判断：`$t < T$`、`$R_(t+1)$`、`$S_(t+1)$`、`$T arrow.l t + 1$`、`$A_(t+1) tilde pi (dot.op | S_(t+1))$`
- 更新时刻与回报：`$tau arrow.l t - n + 1$`、`$G arrow.l sum_(i=tau+1)^(min(tau+n,T)) gamma^(i-tau-1) R_i$`、`$G arrow.l G + gamma^n Q(S_(tau+n), A_(tau+n))$`、`$(G_(tau:tau+n))$`
- 更新与策略：`$Q(S_tau, A_tau) arrow.l Q(S_tau, A_tau) + alpha [G - Q(S_tau, A_tau)]$`、`$pi (dot.op | S_tau)$`、`$epsilon$`-greedy

### PDF p.171 「Off-policy n-step Sarsa」框

- 输入与初始化：`$b(a|s) > 0$`、`$s in cal(S), a in cal(A)$`、`$alpha in (0, 1]$`、`$n$`
- 幕初始化：`$S_0 != "terminal"$`、`$A_0 tilde b(dot.op | S_0)$`
- 分支：`$T arrow.l t + 1$`、`$A_(t+1) tilde b(dot.op | S_(t+1))$`
- 重要性采样比：`$rho arrow.l product_(i=tau+1)^(min(tau+n,T-1)) frac(pi (A_i|S_i), b(A_i|S_i))$`、`$(rho_(tau+1:tau+n))$`
- 回报与更新：`$G arrow.l G + gamma^n Q(S_(tau+n), A_(tau+n))$`、`$Q(S_tau, A_tau) arrow.l Q(S_tau, A_tau) + alpha rho [G - Q(S_tau, A_tau)]$`

### PDF p.176 「n-step Tree Backup」框

- 初始化：`$Q(s, a)$`、`$A_0$`、`$S_0 != "terminal"$`、`$T arrow.l infinity$`
- 分支：`$t < T$`、`$R_(t+1), S_(t+1)$`、`$T arrow.l t + 1$`、`$A_(t+1)$`
- 更新时刻：`$tau arrow.l t + 1 - n$`
- 回报初值：`$t + 1 >= T$`、`$G arrow.l R_T$`、`$G arrow.l R_(t+1) + gamma sum_a pi (a|S_(t+1)) Q(S_(t+1), a)$`
- 回退循环：`$k = min(t, T - 1)$`、`$G arrow.l R_k + gamma sum_(a != A_k) pi (a|S_k) Q(S_k, a) + gamma pi (A_k|S_k) G$`
- 更新：`$Q(S_tau, A_tau) arrow.l Q(S_tau, A_tau) + alpha [G - Q(S_tau, A_tau)]$`

### PDF p.178 「Off-policy n-step Q(σ)」框

- 输入与初始化：`$b(a|s) > 0$`、`$Q(s, a)$`、`$alpha in (0, 1]$`、`$n$`
- 幕初始化：`$S_0 != "terminal"$`、`$A_0 tilde b(dot.op | S_0)$`
- 分支：`$A_(t+1) tilde b(dot.op | S_(t+1))$`、`$sigma_(t+1)$`、`$frac(pi (A_(t+1)|S_(t+1)), b(A_(t+1)|S_(t+1)))$`、`$rho_(t+1)$`
- 更新时刻与回报初值：`$tau arrow.l t - n + 1$`、`$t + 1 < T$`、`$G arrow.l Q(S_(t+1), A_(t+1))$`
- 回退循环：`$k = min(t + 1, T)$`、`$k = T$`、`$G arrow.l R_T$`、`$overline(V) arrow.l sum_a pi (a|S_k) Q(S_k, a)$`、`$G arrow.l R_k + gamma (sigma_k rho_k + (1 - sigma_k) pi (A_k|S_k)) (G - Q(S_k, A_k)) + gamma overline(V)$`
- 更新：`$Q(S_tau, A_tau) arrow.l Q(S_tau, A_tau) + alpha [G - Q(S_tau, A_tau)]$`

## 行内公式

只收录有结构或者容易写错的行内式。单字母变量与 `v_pi (s)`、`q_pi (s, a)`、`Q_t (s, a)` 这类贯穿全章的符号，写法见 `glossary/notation.typ`，不逐处重复。

### PDF p.163

- `$v_pi$`：本章开头“in estimating $v_pi$”。

### PDF p.164

- `$pi$`：生成样本幕所用策略。
- `$S_t, R_(t+1), S_(t+1), R_(t+2), dots.c, R_T, S_T$`：状态–奖励序列，省略动作。

### PDF p.165

- `$V_t : cal(S) -> bb(R)$`：时刻 *t* 的状态价值估计，定义域写法与第 3、4 章一致。
- `$gamma R_(t+2) + gamma^2 R_(t+3) + dots.c + gamma^(T-t-1) R_T$`：被 γ*V*_t(*S*_{t+1}) 取代的其余各项。
- `$gamma^2 R_(t+3) + gamma^3 R_(t+4) + dots.c + gamma^(T-t-1) R_T$`：被 γ²*V*_{t+1}(*S*_{t+2}) 取代的其余各项。
- `$n >= 1$`、`$0 <= t < T - n$`：(7.1) 的成立条件。
- `$t + n >= T$`：n 步回报延伸到终止或更远。
- `$G_(t:t+n) ≐ G_t$`：此时 n 步回报等于完全回报。
- `$s != S_t$`：其余状态的价值不变。

### PDF p.166

- `$gamma^n$`：最坏误差的缩减倍数。
- `$n >= 1$`：误差缩减性质的成立条件。
- `$V(s) = 0.5$`：五状态随机游走中各状态价值的初值。

### PDF p.167

- `$n > 2$`：三步骤以上的更新都会改动三个被访问状态。
- `$gamma$` 外的 `$-1$`：较大随机游走左端的结局收益。
- `$alpha$`：性能曲线横轴的步长参数。
- `$n$`：曲线族参数。

### PDF p.170

- `$s in cal(S)$`：(7.8) 的适用范围。
- `$s$` 为终止状态时期望近似价值定义为 0。
- `$rho_(t:t+n-1)$`：n 步 TD 更新所用的重要性采样比。
- `$A_t$` 到 `$A_(t+n-1)$`：被计权的 *n* 个动作区间。

### PDF p.171

- `$pi (A_k|S_k) = 0$`：目标策略永不选取某动作的情形。
- `$0 <= t < T$`：(7.11) 的成立条件。
- `$rho_(t+1:t+n)$`、`$rho_(t+1:t+n-1)$`：离策略 n 步 Sarsa 与离策略 n 步 Expected Sarsa 所用比值。

### PDF p.172

- `$h$`：horizon，即 *t* + *n*。
- `$G_(h:h) ≐ V_(h-1) (S_h)$`：递归的终止项。
- `$rho_t = frac(pi (A_t|S_t), b(A_t|S_t))$`：时刻 *t* 的重要性采样比。
- `$rho_t$`：控制变量项中出现的同一比值。
- `$1 - rho_t$`：(7.13) 中控制变量前的系数。

### PDF p.173

- `$G_(h:h) ≐ overline(V)_(h-1) (S_h)$`：动作价值递归在期望形式下的终止项。
- `$h < T$` 与 `$h >= T$`：两种终止条件。
- `$G_(T-1:h) ≐ R_T$`：超出终止时刻时的终止项。

### PDF p.174

- `$pi (a|S_(t+1))$`：第一层动作的权重。
- `$A_(t+1)$`：实际被选取的动作，不参与加权。
- `$pi (A_(t+1)|S_(t+1))$`：第二层动作值的权重。
- `$pi (A_(t+1)|S_(t+1)) pi (a'|S_(t+2))$`：未被选取的第二层动作的权重。
- `$pi (A_(t+1)|S_(t+1)) pi (A_(t+2)|S_(t+2)) pi (a''|S_(t+3))$`：第三层动作的权重。

### PDF p.175

- `$t < T - 1$`：(7.15) 的成立条件。
- `$t < T - 2$`：双步树备份回报的成立条件。
- `$t < T - 1, n >= 2$`：(7.16) 的成立条件。
- `$G_(T-1:t+n) ≐ R_T$`：*n* = 1 时的例外终止项。
- `$delta_t ≐ R_(t+1) + gamma overline(V)_t (S_(t+1)) - Q(S_t, A_t)$`：基于期望的 TD 误差。

### PDF p.177

- `$sigma_t in [0, 1]$`：采样程度的取值范围。
- `$sigma = 1$`、`$sigma = 0$`：全采样与纯期望两个端点。
- `$h = t + n$`：horizon 写法。
- `$rho_(t+1)$`：被动作概率替代的重要性采样比。

### PDF p.178

- `$t < h <= T$`：(7.17) 的成立条件。
- `$h < T$`、`$h = T$`：两种终止条件。

### PDF p.179

- `$n$`：回溯图标题中的步数与正文中的前瞻步数。

### PDF p.180

- `$Q(sigma)$`：文献评注中反复出现的算法名。
