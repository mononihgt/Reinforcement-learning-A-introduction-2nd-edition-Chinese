# 第 17 章公式（Frontiers，PDF 481–502）

全部公式对照 `work/pages/pNNNN.png` 页面渲染图逐条重建，未参考文字层的数学片段。本章共 13 条展示公式：11 条带编号（17.1–17.11），2 条不带编号（分别在第 485、486 页）。

代码即 Typst 数学代码。块级公式写成 `$ ... $`（两侧留空格），行内公式写成 `$...$`；章文件里直接照抄即可。原书带编号的公式在代码之后给出标签，编号由模板生成。原书中不编号的展示公式按其在页面上的先后记为 `(unnumbered pNNN-k)`，与 `source.md` 的占位符一一对应。

写法约定沿用第 5、9 章：下标是单独一个标识符或符号、后面紧跟 `(` 或 `[` 时中间必须留空格（`v_pi (s)`、`r(s, omega)`、`v_0 (s)`、`bold(s)_t [i]`）；下标是括号组（`v_(k+1)(s)`、`C_(k+1)`、`A_(0:tau-1)`、`A_(t:oo)`）时不受影响。集合记号写 `cal(S)`、`cal(A)`、`cal(O)`；定义为直接写 `≐`；期望写 `bb(E)[...]`；`Pr` 是直立体，直接写 `Pr{...}`；无穷大写 `oo`；波浪号（表示依分布采样）写 `~`；数学尖括号写 `chevron.l ... chevron.r`；居中省略号写 `dots.c`；乘号写 `times`；方括号内的条件竖线直接写 `|`。

本章特有：

- Option 记 `omega`，它的策略与终止函数都带下标：`pi_omega`、`gamma_omega`；状态 `s` 处可用的 option 集合写 `Omega(s)`。这两处下标是单个标识符，后面跟 `(` 时必须留空格（`pi_omega (s)`、`gamma_omega (S_t)`）。
- 粗体向量：信念状态 `bold(s)`、权重 `bold(w)`、特征 `bold(x)`；带帽的近似价值函数写 `hat(v)`。
- 指示函数写 `bb(1)_(S_t = s')`。
- `{cal(A) times cal(O)}^*` 是历史与测试所在的空间（`*` 为 Kleene 星号上标）。
- (17.6) 与 (17.8) 的蕴含符号写 `=>`（渲染 ⇒）。
- (17.1) 的被积式先用大括号包住连乘再乘以 `C_(k+1)`，代码里写 `(product_(i=t+1)^k gamma(S_i)) C_(k+1)`。
- (17.4) 与第 485 页无编号公式的 `max` 与 `sum` 的下标都是集合 `Omega(s)`，裸写 `max_(omega in Omega(s))`、`sum_(omega in Omega(s))` 即可，Typst 在块级公式里自动把上下限排在符号下方。

## (17.1)   PDF p.481

一般价值函数（GVF）的定义。求和对 `k` 从 `t` 到无穷；连乘的上下限是 `i = t+1` 到 `k`，括在圆括号里；条件部分含 `S_t = s` 与轨迹分布 `A_(t:oo) ~ pi`；末尾方括号外一个句点。

```typst
$ v_(pi, gamma, C)(s) ≐ bb(E)[sum_(k=t)^oo (product_(i=t+1)^k gamma(S_i)) C_(k+1) | S_t = s, A_(t:oo) ~ pi] . $ <eq-17-1>
```

## (17.2)   PDF p.484

option 模型的奖励部分。方括号内是有限项折扣和，省略号居中；条件部分三项用逗号分隔；末尾方括号外一个逗号。

```typst
$ r(s, omega) ≐ bb(E)[R_1 + gamma R_2 + gamma^2 R_3 + dots.c + gamma^(tau - 1) R_tau | S_0 = s, A_(0:tau-1) ~ pi_omega, tau ~ gamma_omega], $ <eq-17-2>
```

## (17.3)   PDF p.484

option 模型的状态转移部分。指数 `gamma^k` 在求和号内、`Pr` 之前；`Pr` 的花括号内条件同样三项；末尾句点。

```typst
$ p(s'|s, omega) ≐ sum_(k=1)^oo gamma^k Pr{S_k = s', tau = k | S_0 = s, A_(0:k-1) ~ pi_omega, tau ~ gamma_omega}. $ <eq-17-3>
```

## (17.4)   PDF p.485

分层策略的状态价值 Bellman 方程。外层求和遍历 `omega in Omega(s)`；`pi (omega|s)` 后是方括号，括号内是 `r(s, omega)` 加上对 `s'` 的求和项；末尾方括号外一个逗号。

```typst
$ v_pi (s) = sum_(omega in Omega(s)) pi (omega|s) [r(s, omega) + sum_(s') p(s'|s, omega) v_pi (s')], $ <eq-17-4>
```

## (unnumbered p485-1)   PDF p.485

带 option 的值迭代（原书不编号）。等号是定义为的 `≐`；`max` 的下标是 `omega in Omega(s)`；末尾 `for all s in cal(S).` 排在方括号之后、同行。

```typst
$ v_(k+1)(s) ≐ max_(omega in Omega(s)) [r(s, omega) + sum_(s') p(s'|s, omega) v_k (s')], quad "for all" s in cal(S). $
```

## (unnumbered p486-1)   PDF p.486

动作与观测交替序列（原书不编号，单独居中一行）。`O_4` 之后是居中省略号，末尾一个逗号。

```typst
$ A_0, O_1, A_1, O_2, A_2, O_3, A_3, O_4, dots.c , $
```

## (17.5)   PDF p.487

测试（test）的概率定义。条件竖线前三个 `O` 的等式、后四个 `A` 与 `H` 的等式；末尾句点紧贴编号。

```typst
$ p(tau|h) ≐ Pr{O_(t+1) = o_1, O_(t+2) = o_2, O_(t+3) = o_3 | H_t = h, A_t = a_1, A_(t+1) = a_2, A_(t+2) = a_3}. $ <eq-17-5>
```

## (17.6)   PDF p.487

`f` 是 Markov 的判据（测试版）。两式之间是宽间隔的蕴含箭头 `=>`；后一式末尾逗号；再空一段写 `for all h, h', tau in {cal(A) times cal(O)}^*.`，末尾句点。

```typst
$ f(h) = f(h') => p(tau|h) = p(tau|h'), quad "for all" h, h', tau in {cal(A) times cal(O)}^*. $ <eq-17-6>
```

## (17.7)   PDF p.487

状态更新函数的定义。第一个等号是 `≐`；末尾 `for all t >= 0,` 排在逗号之后。

```typst
$ S_(t+1) ≐ u(S_t, A_t, O_(t+1)), quad "for all" t >= 0, $ <eq-17-7>
```

## (17.8)   PDF p.488

`f` 是 Markov 的判据（一步预测版）。与 (17.6) 同构，两侧都是 `Pr{O_(t+1) = o|H_t = h, A_t = a}` 形式的条件概率；末尾逗号紧贴编号。

```typst
$ f(h) = f(h') => Pr{O_(t+1) = o|H_t = h, A_t = a} = Pr{O_(t+1) = o|H_t = h', A_t = a}, $ <eq-17-8>
```

## (17.9)   PDF p.489

信念状态的分量定义。左端是粗体 `bold(s)` 带下标 `t` 再加方括号下标 `[i]`（下标后留空格）；末尾 `for all possible latent states i in {1, 2, dots.c, d}.` 与公式同行。

```typst
$ bold(s)_t [i] ≐ Pr{X_t = i | H_t}, quad "for all possible latent states" i in {1, 2, dots.c, d}. $ <eq-17-9>
```

## (17.10)   PDF p.489

信念状态的分量更新（贝叶斯规则）。分式写 `frac(...)`，分子对 `x = 1..d` 求和，分母是两个求和的乘积；`bold(s)[x]` 的方括号直接跟在下标化符号之后，中间留空格；末尾 `for all a in cal(A), o in cal(O),` 与公式同行。

```typst
$ u(bold(s), a, o)[i] ≐ frac(sum_(x=1)^d bold(s)[x] p(i, o|x, a), sum_(x=1)^d sum_(x'=1)^d bold(s)[x] p(x', o|x, a)), quad "for all" a in cal(A), o in cal(O), $ <eq-17-10>
```

## (17.11)   PDF p.492

带初始猜测的线性价值函数逼近。`bold(w)` 的转置写 `^top`；`bold(x)(s)` 与 `v_0 (s)` 的下标后都留空格；末尾逗号。

```typst
$ hat(v)(s, bold(w)) ≐ bold(w)^top bold(x)(s) + v_0 (s), $ <eq-17-11>
```

## 正文行内公式

供 `source.md` 与翻译对照，全部按页面渲染图核对：

- 第 481 页：`$ gamma : cal(S) mapsto [0, 1] $`（终止函数）；`$ C_t in bb(R) $`（累积量信号）。
- 第 483 页：`$ omega = chevron.l pi_omega, gamma_omega chevron.r $`（option 的记法）；`$ A_t $` 取自 `$ pi_omega (dot.op | S_t) $`；在 `$ t + 1 $` 时刻以概率 `$ 1 - gamma_omega (S_(t+1)) $` 终止。
- 第 484 页：`$ pi_omega (s) = a $`（低层动作特例的策略，`for all s in cal(S)`）；`$ gamma_omega (s) = 0 $`（其终止函数，`for all s in cal(S)^+`）。
- 第 485 页：`$ Omega(s) $`（该状态的可用 option 集合）；`$ C_t = R_t $`；`$ pi = pi_omega $`；`$ gamma(s) = gamma dot.op gamma_omega (s) $`；`$ v_(pi, gamma, C)(s) = r(s, omega) $`；`$ C_t = (1 - gamma_omega (S_t)) bb(1)_(S_t = s') $`；`$ v_(pi, gamma, C)(s) = p(s'|s, omega) $`。
- 第 486 页：`$ A_t in cal(A) $`、`$ O_t in cal(O) $`（动作与观测的取值集合，花体）。
- 第 487 页：`$ H_t ≐ A_0, O_1, dots.c , A_(t-1), O_t $`（历史）；`$ S_t = f(H_t) $`（状态是历史的函数）；`$ tau = a_1 o_1 a_2 o_2 a_3 o_3 $`（三步测试）；`$ A_t ≐ pi (f(H_t)) $`（最优策略的选取方式）；`$ S_t = H_t $`（恒等函数的退化情形）。
- 第 489 页：`$ X_t in {1, 2, dots.c, d} $`（隐状态）；`$ S_t ≐ bold(s)_t in [0, 1]^d $`（信念状态向量，粗体 `bold(s)`）；`$ p(x', o|x, a) ≐ Pr{X_t = x', O_t = o | X_(t-1) = x, A_(t-1) = a} $`（POMDP 四参数函数）。
- 第 490 页：`$ S_t ≐ O_t $`；`$ S_t ≐ O_t, A_(t-1), O_(t-1), dots.c, A_(t-k) $`（最近 `k` 步的近似状态）；`$ k >= 1 $`。
- 第 491 页：`$ R_t $`（每次标量奖励）。
- 第 492 页：`$ v_0 : cal(S) arrow.r bb(R) $`；`$ v_* $`；`$ bold(x) : cal(S) arrow.r bb(R)^d $`；`$ bold(w) $`（权重向量，粗体）。
- 第 494 页及之后各页的正文里没有再出现新的数学记号。
