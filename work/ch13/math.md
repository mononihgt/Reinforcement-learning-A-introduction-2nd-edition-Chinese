# 第 13 章公式（Policy Gradient Methods，PDF 343–362）

全部公式对照 `work/pages/pNNNN.png` 页面渲染图逐条重建，未参考文字层的数学片段。

代码即 Typst 数学代码。块级公式写成 `$ ... $`（两侧留空格），行内公式写成 `$...$`；章文件里直接照抄即可。原书带编号的公式在代码之后给出标签，编号由模板生成。原书中不编号的展示公式按其在页面上的先后记为 `(unnumbered pNNN-k)`，与 `source.md` 的占位符一一对应；伪代码框内的公式单列一节。

写法约定沿用第 5、9 章：下标是单独一个标识符或符号、后面紧跟 `(` 或 `[` 时中间必须留空格（`v_pi (s)`、`hat(v)(s, bold(w))`、`pi (a|s)`、`q_pi (s, a)`、`hat(q)(S_t, a, bold(w))`、`r(pi)`）。下标是括号组或标记组合（`bold(theta)_(t+1)`、`G_(t:t+n)`、`bold(theta)_mu`、`bold(x)_sigma`）时不受影响。集合记号写 `cal(S)`、`cal(A)(s)`，实数集写 `bb(R)`，`d` 维实空间写 `bb(R)^d`，策略参数空间的维数写 `bb(R)^(d')`；期望写 `bb(E)`，对策略 π 求期望写成 `bb(E)_pi [ ... ]`；定义为的符号直接写 `≐`；分式写 `frac(...)`；转置写 `^top`；正比写 `prop`；无穷写 `oo`；居中三点省略号写 `dots.c`；斜线除号写 `slash`。

本章特有：

- 策略参数与权重向量都是粗体：`bold(theta)`、`bold(w)`、`bold(x)`、`bold(z)`；状态值估计带帽：`hat(v)`；动作值估计带帽：`hat(q)`；随机梯度写 `hat(nabla J(bold(theta)_t))`，帽覆盖整个符号。
- 步长与迹衰减率按作用对象区分上标：策略参数的上标记成斜体（`alpha^theta`、`lambda^theta`），值函数权重的上标记成粗体（`alpha^bold(w)`、`lambda^bold(w)`）；连续型问题里平均奖励的步长上标记成上划线（`alpha^(overline(R))`），平均奖励的估计写 `overline(R)`；两个资格迹向量写 `bold(z)^bold(theta)` 与 `bold(z)^bold(w)`。
- 概率写 `Pr { ... }`，花括号里是事件；把对取值求和替换为对策略采样时用 `tilde` 引出分布，例如 `$A_t tilde pi$`、`$A_(0:t) tilde pi$`。
- 平均奖励写 `r(pi)`；差分回报按 (13.17) 的记号；高斯策略里的均值与标准差写 `mu(s, bold(theta))` 与 `sigma(s, bold(theta))`，两个特征向量写 `bold(x)_mu (s)` 与 `bold(x)_sigma (s)`；正态密度里的 3.14159 也写 `pi`，与策略符号同形，靠上下文区分。
- 直立体词写引号字符串：`"for all" s in cal(S)`、`quad "and" quad`、`"because"`、`"e.g., to"`、`"unrolling"`、`"Q.E.D."`。
- 原书把推导行右端的括注（"Exercise 3.18"、"product rule of calculus"、"box page 199"、"Eq. 9.3" 等）排在页面右边缘，与式子同一基线。这里用第三个列（`&& ("...")`）紧随式子之后，多条括注排在同一列、左端从同一位置开始；书上贴右边缘的效果留给排版环节处理。

## (13.1)   PDF p.343

策略梯度更新的一般形式：参数向着随机估计的梯度上升，末尾逗号。

```typst
$ bold(theta)_(t+1) = bold(theta)_t + alpha hat(nabla J(bold(theta)_t)), $ <eq-13-1>
```

## (13.2)   PDF p.344

soft-max 策略参数化：偏好取指数后按动作归一化，末尾逗号。

```typst
$ pi (a|s, bold(theta)) ≐ frac(e^(h(s, a, bold(theta))), sum_b e^(h(s, b, bold(theta)))), $ <eq-13-2>
```

## (13.3)   PDF p.344

线性偏好：偏好等于参数与状态动作特征的内积，等号是普通的 `=`，末尾逗号。

```typst
$ h(s, a, bold(theta)) = bold(theta)^top bold(x)(s, a), $ <eq-13-3>
```

## (13.4)   PDF p.346

剧集型问题的性能度量：参数化策略下起始状态的价值，末尾逗号。

```typst
$ J(bold(theta)) ≐ v_(pi_bold(theta)) (s_0), $ <eq-13-4>
```

## (unnumbered p347-1)   PDF p.347

策略梯度定理证明（剧集型）的前半段，共六行：从状态价值的梯度出发，展开动作价值的梯度，代入 (3.2) 后整理出转移概率，再反复展开到 k 步转移的求和形式。第一行末尾用 `quad "for all" s in cal(S)` 给出成立范围，前五行的右端各有一处括注说明依据，第六行只有末尾逗号。

```typst
$ ∇v_pi (s) &= ∇ [ sum_a pi (a|s) q_pi (s, a) ], quad "for all" s in cal(S) && ("Exercise 3.18") \
  &= sum_a [ ∇pi (a|s) q_pi (s, a) + pi (a|s) nabla q_pi (s, a) ] && ("product rule of calculus") \
  &= sum_a [ ∇pi (a|s) q_pi (s, a) + pi (a|s) nabla sum_(s', r) p(s', r|s, a) (r + v_pi (s')) ] && ("Exercise 3.19 and Equation 3.2") \
  &= sum_a [ ∇pi (a|s) q_pi (s, a) + pi (a|s) sum_(s') p(s'|s, a) nabla v_pi (s') ] && ("Eq. 3.4") \
  &= sum_a [ ∇pi (a|s) q_pi (s, a) + pi (a|s) sum_(s') p(s'|s, a) sum_(a') [ ∇pi (a'|s') q_pi (s', a') + pi (a'|s') sum_(s'') p(s''|s', a') nabla v_pi (s'') ] ] && ("unrolling") \
  &= sum_(x in cal(S)) sum_(k=0)^oo Pr (s -> x, k, pi) sum_a ∇pi (a|x) q_pi (x, a), $
```

## (unnumbered p347-2)   PDF p.347

续推：把起始状态价值的梯度写成对状态的求和，用 (9.3) 引入 on-policy 分布后得到正比形式。右端括注依次是 "box page 199"、"Eq. 9.3" 与 "Q.E.D."，最后一行没有句点。

```typst
$ ∇J(bold(theta)) &= ∇v_pi (s_0) \
  &= sum_s ( sum_(k=0)^oo Pr (s_0 -> s, k, pi) ) sum_a ∇pi (a|s) q_pi (s, a) \
  &= sum_s eta(s) sum_a ∇pi (a|s) q_pi (s, a) && ("box page 199") \
  &= sum_(s') eta(s') sum_s frac(eta(s), sum_(s') eta(s')) sum_a ∇pi (a|s) q_pi (s, a) \
  &= sum_(s') eta(s') sum_s mu(s) sum_a nabla pi (a|s) q_pi (s, a) && ("Eq. 9.3") \
  &prop sum_s mu(s) sum_a ∇pi (a|s) q_pi (s, a) && ("Q.E.D.") $
```

## (13.5)   PDF p.348

策略梯度定理（剧集型）：右端不含状态分布的导数，末尾逗号。

```typst
$ nabla J(bold(theta)) prop sum_s mu(s) sum_a q_pi (s, a) nabla pi (a|s, bold(theta)), $ <eq-13-5>
```

## (13.6)   PDF p.348

同一编号覆盖两行：第一行与 (13.5) 相同，第二行把对状态的求和写成对策略 π 的期望，末尾句点。

```typst
$ ∇J(bold(theta)) &prop sum_s mu(s) sum_a q_pi (s, a) nabla pi (a|s, bold(theta)) \
                  &= bb(E)_pi [ sum_a q_pi (S_t, a) nabla pi (a|S_t, bold(theta)) ] . $ <eq-13-6>
```

## (13.7)   PDF p.348

全动作（all-actions）随机梯度更新：用学到的 `hat(q)` 代替真值 `q_pi`，更新时用到全部动作，末尾逗号。

```typst
$ bold(theta)_(t+1) ≐ bold(theta)_t + alpha sum_a hat(q)(S_t, a, bold(w)) nabla pi (a|S_t, bold(theta)), $ <eq-13-7>
```

## (unnumbered p349-1)   PDF p.349

REINFORCE 推导：把对动作的求和换成对策略的期望，再用样本动作 `A_t` 与回报 `G_t` 逐次替换。中间一行右端括注 `("replacing" a "by the sample" A_t tilde pi)`，末行右端括注 `("because" bb(E)_pi [G_t | S_t, A_t] = q_pi (S_t, A_t))`。

```typst
$ nabla J(bold(theta)) &prop bb(E)_pi [ sum_a pi (a|S_t, bold(theta)) q_pi (S_t, a) frac(nabla pi (a|S_t, bold(theta)), pi (a|S_t, bold(theta))) ] \
  &= bb(E)_pi [ q_pi (S_t, A_t) frac(nabla pi (A_t|S_t, bold(theta)), pi (A_t|S_t, bold(theta))) ] quad ("replacing" a "by the sample" A_t tilde pi) \
  &= bb(E)_pi [ G_t frac(nabla pi (A_t|S_t, bold(theta)), pi (A_t|S_t, bold(theta))) ], quad ("because" bb(E)_pi [G_t | S_t, A_t] = q_pi (S_t, A_t)) $
```

## (13.8)   PDF p.349

REINFORCE 更新：整段回报乘资格向量，末尾句点。

```typst
$ bold(theta)_(t+1) ≐ bold(theta)_t + alpha G_t frac(nabla pi (A_t|S_t, bold(theta)_t), pi (A_t|S_t, bold(theta)_t)) . $ <eq-13-8>
```

## (13.9)   PDF p.351

练习 13.3 待证的资格向量：soft-max 线性偏好下，对数策略的梯度等于状态动作特征减去按策略加权的特征平均，末尾逗号。

```typst
$ nabla ln pi (a|s, bold(theta)) = bold(x)(s, a) - sum_b pi (b|s, bold(theta)) bold(x)(s, b), $ <eq-13-9>
```

## (13.10)   PDF p.351

带基线的策略梯度定理：括号是放大尺寸的圆括号，末尾逗号。

```typst
$ nabla J(bold(theta)) prop sum_s mu(s) sum_a lr(size: #125%, ( q_pi (s, a) - b(s) )) nabla pi (a|s, bold(theta)), $ <eq-13-10>
```

## (unnumbered p351-1)   PDF p.351

基线的合法依据：基线乘以资格向量后对全部动作求和恒为零，末尾句点。

```typst
$ sum_a b(s) nabla pi (a|s, bold(theta)) = b(s) nabla sum_a pi (a|s, bold(theta)) = b(s) nabla 1 = 0. $
```

## (13.11)   PDF p.351

带基线的一般 REINFORCE 更新：整段回报减去基线，末尾句点。

```typst
$ bold(theta)_(t+1) ≐ bold(theta)_t + alpha lr(size: #130%, ( G_t - b(S_t) )) frac(nabla pi (A_t|S_t, bold(theta)_t), pi (A_t|S_t, bold(theta)_t)) . $ <eq-13-11>
```

## (13.12)   PDF p.353

一步回报版更新。(13.12)–(13.14) 是连等的三行，只有最后一行的末尾有句点。

```typst
$ bold(theta)_(t+1) ≐ bold(theta)_t + alpha lr(size: #130%, ( G_(t:t+1) - hat(v)(S_t, bold(w)) )) frac(nabla pi (A_t|S_t, bold(theta)_t), pi (A_t|S_t, bold(theta)_t)) $ <eq-13-12>
```

## (13.13)   PDF p.353

把一步回报展开成即时奖励加下一步的折扣估值。

```typst
$ = bold(theta)_t + alpha lr(size: #130%, ( R_(t+1) + gamma hat(v)(S_(t+1), bold(w)) - hat(v)(S_t, bold(w)) )) frac(nabla pi (A_t|S_t, bold(theta)_t), pi (A_t|S_t, bold(theta)_t)) $ <eq-13-13>
```

## (13.14)   PDF p.353

用 TD 误差 `delta_t` 缩写后的一步更新，末尾句点。

```typst
$ = bold(theta)_t + alpha delta_t frac(nabla pi (A_t|S_t, bold(theta)_t), pi (A_t|S_t, bold(theta)_t)) . $ <eq-13-14>
```

## (13.15)   PDF p.355

连续型问题的性能度量：平均奖励的三行写法，第一行同时给出 `r(pi)` 与 `lim` 形式的定义，末尾逗号。

```typst
$ J(bold(theta)) &≐ r(pi) ≐ lim_(h -> oo) frac(1, h) sum_(t=1)^h bb(E) [R_t | S_0, A_(0:t-1) tilde pi] \
  &= lim_(t -> oo) bb(E) [R_t | S_0, A_(0:t-1) tilde pi] \
  &= sum_s mu(s) sum_a pi (a|s) sum_(s', r) p(s', r | s, a) r, $ <eq-13-15>
```

## (13.16)   PDF p.355

稳态分布满足的不动点方程，末尾句点与成立范围。

```typst
$ sum_s mu(s) sum_a pi (a|s, bold(theta)) p(s'|s, a) = mu(s'), quad "for all" s' in cal(S). $ <eq-13-16>
```

## (13.17)   PDF p.356

差分回报：每步奖励都减去平均奖励，末尾是居中三点省略号加句点。

```typst
$ G_t ≐ R_(t+1) - r(pi) + R_(t+2) - r(pi) + R_(t+3) - r(pi) + dots.c . $ <eq-13-17>
```

## (unnumbered p356-1)   PDF p.356

连续型证明的前四行：前两行与剧集型证明完全相同，带同样的两处括注；后两行把奖励换成差分形式 `r - r(bold(theta))` 并移项整理，右端没有括注。

```typst
$ ∇v_pi (s) &= ∇ [ sum_a pi (a|s) q_pi (s, a) ], quad "for all" s in cal(S) && ("Exercise 3.18") \
  &= sum_a [ ∇pi (a|s) q_pi (s, a) + pi (a|s) nabla q_pi (s, a) ] && ("product rule of calculus") \
  &= sum_a [ ∇pi (a|s) q_pi (s, a) + pi (a|s) nabla sum_(s', r) p(s', r|s, a) (r - r(bold(theta)) + v_pi (s')) ] \
  &= sum_a [ ∇pi (a|s) q_pi (s, a) + pi (a|s) [ -nabla r(bold(theta)) + sum_(s') p(s'|s, a) nabla v_pi (s') ] ] . $
```

## (unnumbered p356-2)   PDF p.356

把上一式移项，得到平均奖励的梯度表达式，末尾句点。

```typst
$ nabla r(bold(theta)) = sum_a [ nabla pi (a|s) q_pi (s, a) + pi (a|s) sum_(s') p(s'|s, a) nabla v_pi (s') ] - nabla v_pi (s). $
```

## (unnumbered p356-3)   PDF p.356–357

证明收尾，五行等式跨 p356 与 p357 排版。等式 1 与等式 2（折成两行）印在 p356；等式 3（折成两行，续行把求和次序改成 `s'` 在外层，并把中间的量用花括号标注成 `mu(s') quad (13.16)`）、等式 4 与等式 5 印在 p357。等式 2 与等式 3 都以 `= sum_s mu(s) sum_a ∇pi (a|s) q_pi (s, a)` 开头，书中就是重复出现的；花括号只覆盖 `sum_s mu(s) sum_a pi (a|s) p(s'|s, a)`，外层的 `sum_(s')` 与 `nabla v_pi (s')` 在括号之外。末行末尾句点之后标 "Q.E.D."。

```typst
$ ∇J(bold(theta)) &= sum_s mu(s) ( sum_a [ ∇pi (a|s) q_pi (s, a) + pi (a|s) sum_(s') p(s'|s, a) nabla v_pi (s') ] - ∇v_pi (s) ) \
  &= sum_s mu(s) sum_a ∇pi (a|s) q_pi (s, a) \
  &quad + sum_s mu(s) sum_a pi (a|s) sum_(s') p(s'|s, a) nabla v_pi (s') - sum_s mu(s) ∇v_pi (s) \
  &= sum_s mu(s) sum_a ∇pi (a|s) q_pi (s, a) \
  &quad + sum_(s') underbrace( sum_s mu(s) sum_a pi (a|s) p(s'|s, a), mu(s') quad (13.16) ) nabla v_pi (s') - sum_s mu(s) ∇v_pi (s) \
  &= sum_s mu(s) sum_a ∇pi (a|s) q_pi (s, a) + sum_(s') mu(s') ∇v_pi (s') - sum_s mu(s) ∇v_pi (s) \
  &= sum_s mu(s) sum_a ∇pi (a|s) q_pi (s, a). quad "Q.E.D." $
```

## (13.18)   PDF p.357

正态分布的概率密度函数，末尾逗号。

```typst
$ p(x) ≐ frac(1, sigma sqrt(2 pi)) exp( - frac((x - mu)^2, 2 sigma^2) ), $ <eq-13-18>
```

## (13.19)   PDF p.357

高斯策略：把正态密度的均值与标准差换成依赖状态的参数化函数，末尾逗号。

```typst
$ pi (a|s, bold(theta)) ≐ frac(1, sigma(s, bold(theta)) sqrt(2 pi)) exp( - frac((a - mu(s, bold(theta)))^2, 2 sigma(s, bold(theta))^2) ), $ <eq-13-19>
```

## (13.20)   PDF p.358

均值的参数化与标准差的参数化排在同一行：均值取参数的线性形式，标准差取线性形式的指数，末尾逗号。

```typst
$ mu(s, bold(theta)) ≐ bold(theta)_mu^top bold(x)_mu (s) quad "and" quad sigma(s, bold(theta)) ≐ exp( bold(theta)_sigma^top bold(x)_sigma (s) ), $ <eq-13-20>
```

## (unnumbered p358-1)   PDF p.358

练习 13.4 的第一部分：均值方向的资格向量。第二个等号的分式中，分子下标写 `bold(theta)_mu`，分母写 `bold(theta)`，末尾逗号。

```typst
$ nabla ln pi (a|s, bold(theta)_mu) = frac(nabla pi (a|s, bold(theta)_mu), pi (a|s, bold(theta))) = frac(1, sigma(s, bold(theta))^2) (a - mu(s, bold(theta))) bold(x)_mu (s), $
```

## (unnumbered p358-2)   PDF p.358

练习 13.4 的第二部分：标准差方向的资格向量，末尾句点。

```typst
$ nabla ln pi (a|s, bold(theta)_sigma) = frac(nabla pi (a|s, bold(theta)_sigma), pi (a|s, bold(theta))) = ( frac((a - mu(s, bold(theta)))^2, sigma(s, bold(theta))^2) - 1 ) bold(x)_sigma (s). $
```

## 伪代码框内公式

框内的公式是行内公式（求和号与上下限排在符号右侧，与原书一致），因此写成 `$...$`；它们不带编号，`source.md` 的框里也没有占位符。赋值箭头一律写 `arrow.l`（原书为 ←）；采样写 `$A tilde pi (dot.op | S, bold(theta))$` 或 `$pi (dot.op | dot.op, bold(theta))$` 或 `$A tilde pi (dot.op | S)$`；无穷大写 `oo`；`≐` 直接写。

### PDF p.350 「REINFORCE: Monte-Carlo Policy-Gradient Control (episodic) for π_*」框

- 可微策略参数化：`$pi (a|s, bold(theta))$`
- 算法参数：`$alpha > 0$`
- 初始化：`$bold(theta) in bb(R)^(d')$`，"e.g., to" 后跟 `$bold(0)$`（粗体零向量）
- 生成剧集：`$S_0, A_0, R_1, ..., S_(T-1), A_(T-1), R_T$`，按 `$pi (dot.op | dot.op, bold(theta))$` 采样
- 步号：`$t = 0, 1, ..., T - 1$`
- 回报累加：`$G arrow.l sum_(k=t+1)^T gamma^(k-t-1) R_k$`（右侧括注 `$(G_t)$`）
- 更新：`$bold(theta) arrow.l bold(theta) + alpha gamma^t G nabla ln pi (A_t|S_t, bold(theta))$`

### PDF p.352 「REINFORCE with Baseline (episodic), for estimating π_θ ≈ π_*」框

- 可微策略参数化：`$pi (a|s, bold(theta))$`；可微状态值参数化：`$hat(v)(s, bold(w))$`
- 算法参数：`$alpha^theta > 0$`、`$alpha^bold(w) > 0$`
- 初始化：`$bold(theta) in bb(R)^(d')$` 与 `$bold(w) in bb(R)^d$`（"e.g., to" 0）
- 生成剧集：`$S_0, A_0, R_1, ..., S_(T-1), A_(T-1), R_T$`，按 π 采样
- 步号：`$t = 0, 1, ..., T - 1$`
- 回报累加：`$G arrow.l sum_(k=t+1)^T gamma^(k-t-1) R_k$`（右侧括注 `$(G_t)$`）
- 误差：`$delta arrow.l G - hat(v)(S_t, bold(w))$`
- 值函数更新：`$bold(w) arrow.l bold(w) + alpha^bold(w) delta nabla hat(v)(S_t, bold(w))$`
- 策略更新：`$bold(theta) arrow.l bold(theta) + alpha^theta gamma^t delta nabla ln pi (A_t|S_t, bold(theta))$`

### PDF p.354 「One-step Actor–Critic (episodic), for estimating π_θ ≈ π_*」框

- 可微策略参数化：`$pi (a|s, bold(theta))$`；可微状态值参数化：`$hat(v)(s, bold(w))$`
- 参数：`$alpha^theta > 0$`、`$alpha^bold(w) > 0$`
- 初始化：`$bold(theta) in bb(R)^(d')$` 与 `$bold(w) in bb(R)^d$`（"e.g., to" 0）
- 剧集起始：`$S$`（first state of episode）
- 步长因子：`$I arrow.l 1$`
- 采样动作：`$A tilde pi (dot.op | S, bold(theta))$`
- 观察：动作 `$A$`、`$S'$`、`$R$`
- 误差：`$delta arrow.l R + gamma hat(v)(S', bold(w)) - hat(v)(S, bold(w))$`（右侧括注 `$("if" S' "is terminal, then" hat(v)(S', bold(w)) ≐ 0)$`）
- 值函数更新：`$bold(w) arrow.l bold(w) + alpha^bold(w) delta nabla hat(v)(S, bold(w))$`
- 策略更新：`$bold(theta) arrow.l bold(theta) + alpha^theta I delta nabla ln pi (A|S, bold(theta))$`
- 步长因子递推：`$I arrow.l gamma I$`
- 状态推进：`$S arrow.l S'$`

### PDF p.354 「Actor–Critic with Eligibility Traces (episodic), for estimating π_θ ≈ π_*」框

- 可微策略参数化：`$pi (a|s, bold(theta))$`；可微状态值参数化：`$hat(v)(s, bold(w))$`
- 参数：`$lambda^theta in [0, 1]$`、`$lambda^bold(w) in [0, 1]$`、`$alpha^theta > 0$`、`$alpha^bold(w) > 0$`
- 初始化：`$bold(theta) in bb(R)^(d')$` 与 `$bold(w) in bb(R)^d$`（"e.g., to" 0）
- 剧集起始：`$S$`（first state of episode）
- 资格迹初始化：`$bold(z)^theta arrow.l bold(0)$`（d′ 分量）、`$bold(z)^bold(w) arrow.l bold(0)$`（d 分量）
- 步长因子：`$I arrow.l 1$`
- 采样动作：`$A tilde pi (dot.op | S, bold(theta))$`
- 观察：动作 `$A$`、`$S'$`、`$R$`
- 误差：`$delta arrow.l R + gamma hat(v)(S', bold(w)) - hat(v)(S, bold(w))$`（右侧括注同上一框）
- 值函数迹：`$bold(z)^bold(w) arrow.l gamma lambda^bold(w) bold(z)^bold(w) + nabla hat(v)(S, bold(w))$`
- 策略迹：`$bold(z)^theta arrow.l gamma lambda^theta bold(z)^theta + I nabla ln pi (A|S, bold(theta))$`
- 值函数更新：`$bold(w) arrow.l bold(w) + alpha^bold(w) delta bold(z)^bold(w)$`
- 策略更新：`$bold(theta) arrow.l bold(theta) + alpha^theta delta bold(z)^theta$`
- 步长因子递推：`$I arrow.l gamma I$`
- 状态推进：`$S arrow.l S'$`

### PDF p.355 「Actor–Critic with Eligibility Traces (continuing), for estimating π_θ ≈ π_*」框

- 可微策略参数化：`$pi (a|s, bold(theta))$`；可微状态值参数化：`$hat(v)(s, bold(w))$`
- 算法参数：`$lambda^bold(w) in [0, 1]$`、`$lambda^theta in [0, 1]$`、`$alpha^bold(w) > 0$`、`$alpha^theta > 0$`、`$alpha^(overline(R)) > 0$`
- 平均奖励初始化：`$overline(R) in bb(R)$`（"e.g., to" 0）
- 权重与策略初始化：`$bold(w) in bb(R)^d$` 与 `$bold(theta) in bb(R)^(d')$`（"e.g., to" 0）
- 状态初始化：`$S in cal(S)$`（"e.g., to" `$s_0$`）
- 资格迹初始化：`$bold(z)^bold(w) arrow.l bold(0)$`（d 分量）、`$bold(z)^theta arrow.l bold(0)$`（d′ 分量）
- 采样动作：`$A tilde pi (dot.op | S, bold(theta))$`
- 观察：动作 `$A$`、`$S'$`、`$R$`
- 误差：`$delta arrow.l R - overline(R) + hat(v)(S', bold(w)) - hat(v)(S, bold(w))$`
- 平均奖励更新：`$overline(R) arrow.l overline(R) + alpha^(overline(R)) delta$`
- 值函数迹：`$bold(z)^bold(w) arrow.l lambda^bold(w) bold(z)^bold(w) + nabla hat(v)(S, bold(w))$`（不带 `gamma`）
- 策略迹：`$bold(z)^theta arrow.l lambda^theta bold(z)^theta + nabla ln pi (A|S, bold(theta))$`（不带 `I`，也没有 `gamma`）
- 值函数更新：`$bold(w) arrow.l bold(w) + alpha^bold(w) delta bold(z)^bold(w)$`
- 策略更新：`$bold(theta) arrow.l bold(theta) + alpha^theta delta bold(z)^theta$`
- 状态推进：`$S arrow.l S'$`（没有步长因子 `$I$` 的更新行）

## 行内公式

只收录有结构或者容易写错的行内式。单字母变量（*s*、*a*、*r*、*γ*、*α*、*θ*、*w*、*d*、*t*、*T*）与 `v_pi (s)`、`q_pi (s, a)`、`hat(v)(s, bold(w))`、`bold(theta)^top bold(x)(s)`、`nabla pi (a|s, bold(theta))` 这类贯穿全章的符号，写法见 `glossary/notation.typ`，不逐处重复。

### PDF p.343

- `$bold(theta) in bb(R)^(d')$`、`$bold(w) in bb(R)^d$`：策略参数与值函数权重的所属空间。
- `$pi (a|s, bold(theta)) = Pr {A_t = a | S_t = s, bold(theta)_t = bold(theta)}$`：参数化策略的定义，原书这里用等号。
- `$hat(nabla J(bold(theta)_t)) in bb(R)^(d')$`：随机梯度估计的所属空间，帽覆盖整个记号。

### PDF p.344

- `$nabla pi (a|s, bold(theta))$`：策略对参数的梯度，正文用括号说明它是偏导数组成的列向量。
- `$h(s, a, bold(theta)) in bb(R)$`：偏好的取值。
- `$bold(x)(s, a) in bb(R)^(d')$`：状态动作特征的所属空间。
- `$e ≈ 2.71828$`：自然对数的底。

### PDF p.345

- `$bold(x)(s, "right") = [1, 0]^top$`、`$bold(x)(s, "left") = [0, 1]^top$`：例题 13.1 的特征定义。
- `$1 - epsilon slash 2$`：ε-greedy 选中高概率动作的概率。
- `$epsilon = 0.1$`：例题所用的探索率。

### PDF p.346

- `$gamma = 1$`：剧集型问题的讨论假设不打折扣。

### PDF p.347

- `$Pr (s -> x, k, pi)$`：k 步转移概率的记号（`->` 渲染 →）。

### PDF p.349

- `$nabla ln pi (A_t|S_t, bold(theta)_t)$`：资格向量的对数形式。
- `$nabla pi (A_t|S_t, bold(theta)_t) slash pi (A_t|S_t, bold(theta)_t)$`：资格向量的分式形式，与原书一致用斜线除号。
- `$nabla ln x = frac(nabla x, x)$`：两种形式等价所依据的恒等式，书中排成上下叠放的分式。

### PDF p.350

- `$gamma^t$`：伪代码更新比 (13.8) 多出的因子（正文提到的一般折扣情形）。

### PDF p.352

- `$alpha^bold(w) = 0.1 slash bb(E) [ norm(nabla hat(v)(S_t, bold(w)))_mu^2 ]$`：值函数步长的经验取值（见 9.6 节），范数上标 2、下标 μ。

### PDF p.353

- `$hat(v)(s, bold(w)) = w$`：基线的线性形式，`bold(w)` 是单分量。
- `$G_(t:t+1)$`：一步回报的记号。

### PDF p.354

- `$G_(t:t+n)$`、`$G_t^lambda$`：n 步回报与 λ 回报。
- `$lambda^theta in [0, 1]$`、`$lambda^bold(w) in [0, 1]$`：两个迹衰减率的取值范围。

### PDF p.355

- `$mu(s) ≐ lim_(t -> oo) Pr {S_t = s | A_(0:t) tilde pi}$`：稳态分布的定义（`tilde` 表示按 π 采样）。

### PDF p.356

- `$v_pi (s) ≐ bb(E)_pi [G_t | S_t = s]$`、`$q_pi (s, a) ≐ bb(E)_pi [G_t | S_t = s, A_t = a]$`：差分回报下的两个值函数。
- `$J(bold(theta)) = r(pi)$`：连续型问题的性能度量，正文把它与 (13.15) 联系起来。
- `$sum_s mu(s) = 1$`：证明框里用到的归一化关系。

### PDF p.357

- `$mu : cal(S) × bb(R)^(d') -> bb(R)$`、`$sigma : cal(S) × bb(R)^(d') -> bb(R)^+$`：两个函数逼近器的类型，乘号写 `×`。
- `$pi ≈ 3.14159$`：正态密度里的圆周率，与策略符号同形。

### PDF p.358

- `$bold(theta) = [bold(theta)_mu, bold(theta)_sigma]^top$`：参数向量按均值与标准差分成两段。
- `$bold(x)_mu (s)$`、`$bold(x)_sigma (s)$`：两段的特征向量。
- `$Pr {A_t = 1} = P_t$`、`$Pr {A_t = 0} = 1 - P_t$`：伯努利单元的输出分布。
- `$h(s, 1, bold(theta)) - h(s, 0, bold(theta)) = bold(theta)^top bold(x)(s)$`：两个动作的偏好之差等于加权的特征和。
- `$P_t = pi (1|S_t, bold(theta)_t) = 1 slash (1 + exp( - bold(theta)_t^top bold(x)(S_t) ))$`：logistic 函数形式。
- `$f(x) = 1 slash (1 + e^(-x))$`：logistic 函数；`$f(x)(1 - f(x))$` 是它的导数。
