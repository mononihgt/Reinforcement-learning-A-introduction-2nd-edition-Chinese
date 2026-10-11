# 第 11 章公式（Off-policy Methods with Approximation，PDF 279–308）

全部公式对照 `work/pages/pNNNN.png` 页面渲染图逐条重建，未参考文字层的数学片段。

代码即 Typst 数学代码。块级公式写成 `$ ... $`（两侧留空格），行内公式写成 `$...$`；章文件里直接照抄即可。原书带编号的公式在代码之后给出标签，编号由模板生成。原书中不编号的展示公式按其在页面上的先后记为 `(unnumbered pNNN-k)`，与 `source.md` 的占位符一一对应。

写法约定沿用第 5 章、第 9 章与第 10 章：下标是单独一个标识符或符号、后面紧跟 `(` 或 `[` 时中间必须留空格（`rho_t`、`pi (A_t|S_t)`、`b(A_t|S_t)`、`bb(E)_pi [...]`、`bb(E)_b [...]`、`hat(q)(S_t, A_t, bold(w)_t)`）。下标是括号组或标记组合（`bold(w)_(t+1)`、`bold(w)_(t+n-1)`、`G_(t:t+n)`、`bold(x)_(t+1)`、`bold(w)_"TD"`、`overline(delta)_bold(w)`）时不受影响。集合记号写 `cal(S)`、`cal(A)`，实数集写 `bb(R)`，`d` 维实空间写 `bb(R)^d`；期望写 `bb(E)`，下标 π 与 b 写成 `bb(E)_pi`、`bb(E)_b`；定义为的符号直接写 `≐`；约等写 `approx`；上划线写 `overline(...)`；分式写 `frac(...)`；转置写 `^top`；范数写 `norm(...)`，加权平方范数写 `norm(...)_mu^2`；梯度算子写 `nabla`；乘积算子写 `prod`；最小化的下标写 `argmin_(...)`。

本章特有：

- 参数向量、特征向量与矩阵是粗体：`bold(w)`、`bold(w)_t`、`bold(w)_k`、`bold(w)_(t+1)`、`bold(x)(s)`、`bold(x)_t`、`bold(v)`、`bold(v)_t`、`bold(D)`、`bold(X)`；估值函数带帽：`hat(v)`、`hat(q)`。第 11.2 节的 w-to-2w 例子、例题 11.1、第 11.6 节的 VE/RE 讨论中，单分量参数在原书里印作斜体 `w`，照录；其余位置是粗体。
- 最小化写 `op("argmin", limits: #true)_(...)`，下标排在符号正下方（与第 4 章、第 10 章的 `argmax` 写法一致）。
- 目标函数是带上划线的直立体缩写：`overline("VE")(bold(w))`、`overline("BE")(bold(w))`、`overline("PBE")(bold(w))`、`overline("TDE")(bold(w))`、`overline("RE")(bold(w))`（与 `glossary/notation.typ` 一致）。正文里也直接用 `overline("BE")`、`overline("PBE")`、`overline("VE")`、`overline("TDE")` 指代这些目标。
- 贝尔曼误差在状态 s 处写 `overline(delta)_bold(w)(s)`，误差向量写 `overline(delta)_bold(w)`。
- 贝尔曼算子写 `B_pi`，投影算子写 `Pi`，平均奖励估计写 `overline(R)_t`。
- 重要性采样比写 `rho_t`、`rho_(t:t)`，连乘写 `rho_(t+1) dots.c rho_(t+n)`。
- 状态名 A、B、C、A1、A2、B′ 在原书里是直立体，用引号字符串写：`"A"`、`"B"`、`"C"`、`"A1"`、`"A2"`、`"B'"`。
- 直立体词写引号字符串：`"for all" s in cal(S)`、`"where"`、`quad "or"`、`"(episodic)"`、`"(continuing)"`、`"(the general SGD rule)"`、`"(from (11.27))"`、`"(based on (11.28))"`、`"(sampling)"`、`"(if " mu " is the distribution encountered under " b ")"`。
- 居中三点省略号写 `dots.c`（连加与连乘中间），下三点省略号写 `dots`（下标列举）。
- 正文里的分式按原书印成堆叠形式：`frac(6, 7)`、`frac(1, 3)`、`frac(2, 3)`、`frac(1, 16)`、`frac(5, 6 - 4 epsilon)`、`frac(alpha, beta)` 等，不写成斜线。
- 「The projection matrix」框内的公式（(11.13)–(11.15)）与正文同规格，不缩进处理。例题（Examples 11.1–11.4）内的展示公式同样与正文同规格。

## (11.1)   PDF p.280

每步重要性采样比的定义，分式带横线，末尾句点。

```typst
$ rho_t ≐ rho_(t:t) = frac(pi (A_t|S_t), b(A_t|S_t)). $ <eq-11-1>
```

## (11.2)   PDF p.280

半梯度 off-policy TD(0) 的更新式，末尾逗号。权重向量粗体。

```typst
$ bold(w)_(t+1) ≐ bold(w)_t + alpha rho_t delta_t nabla hat(v)(S_t, bold(w)_t), $ <eq-11-2>
```

## (11.3)   PDF p.280

回合制带折扣情形的 δ_t，末尾 “, or” 引出下一式。

```typst
$ delta_t ≐ R_(t+1) + gamma hat(v)(S_(t+1), bold(w)_t) - hat(v)(S_t, bold(w)_t), quad "or" $ <eq-11-3>
```

## (11.4)   PDF p.280

持续型无折扣（平均奖励）情形的 δ_t，末尾句点。平均奖励估计写 `overline(R)_t`。

```typst
$ delta_t ≐ R_(t+1) - overline(R)_t + hat(v)(S_(t+1), bold(w)_t) - hat(v)(S_t, bold(w)_t). $ <eq-11-4>
```

## (11.5)   PDF p.281

半梯度 Expected Sarsa 的更新式，末尾 “, with” 引出下面两式。

```typst
$ bold(w)_(t+1) ≐ bold(w)_t + alpha delta_t nabla hat(q)(S_t, A_t, bold(w)_t), quad "with" $ <eq-11-5>
```

## (unnumbered p281-1)   PDF p.281

Expected Sarsa 的回合制 δ_t。展开始终对 `a` 求和，右侧标注 `(episodic)`，末尾 “, or”。

```typst
$ delta_t ≐ R_(t+1) + gamma sum_a pi (a|S_(t+1)) hat(q)(S_(t+1), a, bold(w)_t) - hat(q)(S_t, A_t, bold(w)_t), quad "or" quad "(episodic)" $
```

## (unnumbered p281-2)   PDF p.281

Expected Sarsa 的持续型 δ_t，右侧标注 `(continuing)`，末尾句点。

```typst
$ delta_t ≐ R_(t+1) - overline(R)_t + sum_a pi (a|S_(t+1)) hat(q)(S_(t+1), a, bold(w)_t) - hat(q)(S_t, A_t, bold(w)_t). quad "(continuing)" $
```

## (11.6)   PDF p.281

n 步半梯度 Sarsa 的更新式：比率连乘 `rho_(t+1) dots.c rho_(t+n)`，方括号内外都是粗体 w。原书本式末尾无标点。

```typst
$ bold(w)_(t+n) ≐ bold(w)_(t+n-1) + alpha rho_(t+1) dots.c rho_(t+n) [G_(t:t+n) - hat(q)(S_t, A_t, bold(w)_(t+n-1))] nabla hat(q)(S_t, A_t, bold(w)_(t+n-1)) $ <eq-11-6>
```

## (unnumbered p281-3)   PDF p.281

(11.6) 的回合制回报定义，右侧标注 `(episodic)`，末尾 “, or”。**原书此式中间项写 `gamma^(n-1) R_(t+n)`，没有 `gamma R_(t+2)` 一项**，按渲染图照录。

```typst
$ G_(t:t+n) ≐ R_(t+1) + dots.c + gamma^(n-1) R_(t+n) + gamma^n hat(q)(S_(t+n), A_(t+n), bold(w)_(t+n-1)), quad "or" quad "(episodic)" $
```

## (unnumbered p281-4)   PDF p.281

(11.6) 的持续型回报定义，右侧标注 `(continuing)`，原书末尾为逗号。

```typst
$ G_(t:t+n) ≐ R_(t+1) - overline(R)_t + dots.c + R_(t+n) - overline(R)_(t+n-1) + hat(q)(S_(t+n), A_(t+n), bold(w)_(t+n-1)), quad "(continuing)" $
```

## (11.7)   PDF p.281

n 步树回溯（tree backup）的半梯度更新式，不含重要性采样比，末尾逗号。

```typst
$ bold(w)_(t+n) ≐ bold(w)_(t+n-1) + alpha [G_(t:t+n) - hat(q)(S_t, A_t, bold(w)_(t+n-1))] nabla hat(q)(S_t, A_t, bold(w)_(t+n-1)), $ <eq-11-7>
```

## (11.8)   PDF p.281

树回溯的 n 步回报 `G_(t:t+n)`：自举项加一系列带折扣乘积的 δ 之和，末尾逗号。连乘写 `product_(i=t+1)^k`（与第 5 章、第 7 章一致）。

```typst
$ G_(t:t+n) ≐ hat(q)(S_t, A_t, bold(w)_(t+n-1)) + sum_(k=t)^(t+n-1) delta_k product_(i=t+1)^k gamma pi (A_i|S_i), $ <eq-11-8>
```

## (unnumbered p282-1)   PDF p.282

w-to-2w 例子的 TD 误差展开。全部等号，参数是斜体 `w`（单分量），末尾逗号。

```typst
$ delta_t = R_(t+1) + gamma hat(v)(S_(t+1), w_t) - hat(v)(S_t, w_t) = 0 + gamma 2 w_t - w_t = (2 gamma - 1) w_t, $
```

## (unnumbered p282-2)   PDF p.282

w-to-2w 例子的更新式展开：`alpha · 1 · (2 gamma - 1) w_t · 1`，乘法点（居中点）写 `dot.op`，末尾句点。

```typst
$ w_(t+1) = w_t + alpha rho_t delta_t nabla hat(v)(S_t, w_t) = w_t + alpha dot.op 1 dot.op (2 gamma - 1) w_t dot.op 1 = (1 + alpha (2 gamma - 1)) w_t. $
```

## (11.9)   PDF p.284

Baird 反例上的同步 DP 式半梯度更新：分式 `frac(alpha, |cal(S)|)`，对状态求和，括号内是真值端期望与估计值之差，末尾句点。

```typst
$ bold(w)_(k+1) ≐ bold(w)_k + frac(alpha, |cal(S)|) sum_s ( bb(E)_pi [R_(t+1) + gamma hat(v)(S_(t+1), bold(w)_k) | S_t = s] - hat(v)(s, bold(w)_k) ) nabla hat(v)(s, bold(w)_k). $ <eq-11-9>
```

## (11.10)   PDF p.285

例题 11.1（Tsitsiklis 与 Van Roy 反例）中的最小二乘解，三行等号对齐。`op("argmin", limits: #true)` 的下标是 `w in bb(R)`，排在符号正下方；参数与原书一致用斜体 `w`、`w_k`，不带粗体。编号 (11.10) 印在第三行右侧。

```typst
$ w_(k+1) &= op("argmin", limits: #true)_(w in bb(R)) sum_(s in cal(S)) ( hat(v)(s, w) - bb(E)_pi [R_(t+1) + gamma hat(v)(S_(t+1), w_k) | S_t = s] )^2 \
          &= op("argmin", limits: #true)_(w in bb(R)) ( w - gamma 2 w_k )^2 + ( 2w - (1 - epsilon) gamma 2 w_k )^2 \
          &= frac(6 - 4 epsilon, 5) gamma w_k . $ <eq-11-10>
```

## (11.11)   PDF p.288

μ 加权的平方范数定义，末尾句点。

```typst
$ norm(v)_mu^2 ≐ sum_(s in cal(S)) mu(s) v(s)^2 . $ <eq-11-11>
```

## (11.12)   PDF p.289

投影算子的定义：`Pi v ≐ v_bold(w)`，其中 `bold(w)` 取到最近的代表性值函数；`"where"` 是直立体，`op("argmin", limits: #true)` 的下标 `bold(w) in bb(R)^d` 排在符号正下方，末尾句点。

```typst
$ Pi v ≐ v_bold(w) quad "where" quad bold(w) = op("argmin", limits: #true)_(bold(w) in bb(R)^d) norm(v - v_bold(w))_mu^2 . $ <eq-11-12>
```

## (11.16)   PDF p.289

π 的贝尔曼方程。**原书编号顺序特殊：本式印在第 11.4 节开头（p289），先于 (11.13)–(11.15) 出现**，`source.md` 的占位符顺序与此一致，标签挂在正文中本式位置（“recall that the Bellman equation for value function v_π is” 之后）。末尾 “for all” 注明全状态成立。

```typst
$ v_pi (s) = sum_a pi (a|s) sum_(s', r) p(s', r | s, a) [r + gamma v_pi (s')], quad "for all" s in cal(S). $ <eq-11-16>
```

## (11.13)   PDF p.290（「The projection matrix」框内）

投影矩阵的矩阵形式。`bold(X)` 与 `bold(D)` 粗体，第一处 `bold(X)` 与括号之间有空格，末尾逗号。

```typst
$ Pi ≐ bold(X) ( bold(X)^top bold(D) bold(X) )^(-1) bold(X)^top bold(D), $ <eq-11-13>
```

## (11.14)   PDF p.290（「The projection matrix」框内）

平方范数的矩阵写法：向量斜体 `v`，矩阵 `bold(D)` 粗体。

```typst
$ norm(v)_mu^2 = v^top bold(D) v, $ <eq-11-14>
```

## (11.15)   PDF p.290（「The projection matrix」框内）

线性近似值函数的矩阵写法：`v` 带粗体下标 `bold(w)`，末尾句点。

```typst
$ v_bold(w) = bold(X) bold(w). $ <eq-11-15>
```

## (11.17)   PDF p.290

状态 s 处的贝尔曼误差定义：圆括号按渲染图放大，包住真值端求和，再减去估计值。末尾没有标点。

```typst
$ overline(delta)_bold(w)(s) ≐ ( sum_a pi (a|s) sum_(s', r) p(s', r | s, a) [r + gamma v_bold(w)(s')] ) - v_bold(w)(s) $ <eq-11-17>
```

## (11.18)   PDF p.290

(11.17) 的期望形式，等号与上式对齐，条件是 `S_t = s, A_t tilde pi`，末尾逗号。

```typst
$ = bb(E)_pi [R_(t+1) + gamma v_bold(w)(S_(t+1)) - v_bold(w)(S_t) | S_t = s, A_t tilde pi], $ <eq-11-18>
```

## (11.19)   PDF p.290

均方贝尔曼误差的定义，末尾句点。

```typst
$ overline("BE")(bold(w)) = norm(overline(delta)_bold(w))_mu^2 . $ <eq-11-19>
```

## (11.20)   PDF p.291

贝尔曼算子的定义：`(B_pi v)(s)`，其中 `v` 是普通斜体。末尾逗号。

```typst
$ (B_pi v)(s) ≐ sum_a pi (a|s) sum_(s', r) p(s', r | s, a) [r + gamma v(s')], $ <eq-11-20>
```

## (11.21)   PDF p.291

贝尔曼方程的不动点形式，末尾逗号。

```typst
$ v_pi = B_pi v_pi, $ <eq-11-21>
```

## (11.22)   PDF p.291

均方投影贝尔曼误差的定义，末尾句点。

```typst
$ overline("PBE")(bold(w)) = norm(Pi overline(delta)_bold(w))_mu^2 . $ <eq-11-22>
```

## (unnumbered p292-1)   PDF p.292

一般函数近似下的单步带折扣 TD 误差，末尾句点。

```typst
$ delta_t = R_(t+1) + gamma hat(v)(S_(t+1), bold(w)_t) - hat(v)(S_t, bold(w)_t). $
```

## (unnumbered p292-2)   PDF p.292

均方 TD 误差的三行推导，等号对齐。第三行右侧括注 `(if μ is the distribution encountered under b)`，括注内 μ 与 b 是数学斜体。本式不编号。

```typst
$ overline("TDE")(bold(w)) &= sum_(s in cal(S)) mu(s) bb(E)[delta_t^2 | S_t = s, A_t tilde pi] \
                           &= sum_(s in cal(S)) mu(s) bb(E)[rho_t delta_t^2 | S_t = s, A_t tilde b] \
                           &= bb(E)_b [rho_t delta_t^2]. quad "(if " mu " is the distribution encountered under " b ")" $
```

## (11.23)   PDF p.292

以 TD 误差平方为目标的 SGD 更新三行推导，末尾句点。第一行的梯度作用在括号 `(rho_t delta_t^2)` 上。

```typst
$ bold(w)_(t+1) &= bold(w)_t - frac(1, 2) alpha nabla (rho_t delta_t^2) \
                &= bold(w)_t - alpha rho_t delta_t nabla delta_t \
                &= bold(w)_t + alpha rho_t delta_t ( nabla hat(v)(S_t, bold(w)_t) - gamma nabla hat(v)(S_(t+1), bold(w)_t) ), $ <eq-11-23>
```

## (unnumbered p294-1)   PDF p.294

残差梯度算法的五步推导。第一、二行括号按渲染图照录：上标平方紧跟在 `bb(E)_pi [delta_t]` 与 `bb(E)_b [rho_t delta_t]` 的方括号之后，再闭合圆括号。最后一行 `bold(w)`、`S_t` 没有时间下标。

```typst
$ bold(w)_(t+1) &= bold(w)_t - frac(1, 2) alpha nabla (bb(E)_pi [delta_t]^2) \
                &= bold(w)_t - frac(1, 2) alpha nabla (bb(E)_b [rho_t delta_t]^2) \
                &= bold(w)_t - alpha bb(E)_b [rho_t delta_t] nabla bb(E)_b [rho_t delta_t] \
                &= bold(w)_t - alpha bb(E)_b [rho_t (R_(t+1) + gamma hat(v)(S_(t+1), bold(w)) - hat(v)(S_t, bold(w)))] bb(E)_b [rho_t nabla delta_t] \
                &= bold(w)_t + alpha [bb(E)_b [rho_t (R_(t+1) + gamma hat(v)(S_(t+1), bold(w)))] - hat(v)(S_t, bold(w))] [nabla hat(v)(S_t, bold(w)) - gamma bb(E)_b [rho_t nabla hat(v)(S_(t+1), bold(w))]] . $
```

## (11.24)   PDF p.297

均方回报误差的两行式：第二行把 VE 与一个与参数无关的方差项分开，末尾句点。编号 (11.24) 印在第二行右侧。

```typst
$ overline("RE")(bold(w)) &= bb(E)[(G_t - hat(v)(S_t, bold(w)))^2] \
                          &= overline("VE")(bold(w)) + bb(E)[(G_t - v_pi (S_t))^2] . $ <eq-11-24>
```

## (11.25)   PDF p.300

把 PBE 目标 (11.22) 展开成矩阵形式的四行推导，等号对齐。第二行右侧括注 `(from (11.14))`；编号 (11.25) 印在第四行右侧。

```typst
$ overline("PBE")(bold(w)) &= norm(Pi overline(delta)_bold(w))_mu^2 \
                          &= (Pi overline(delta)_bold(w))^top bold(D) Pi overline(delta)_bold(w) quad "(from (11.14))" \
                          &= overline(delta)_bold(w)^top Pi^top bold(D) Pi overline(delta)_bold(w) \
                          &= overline(delta)_bold(w)^top bold(D) bold(X) ( bold(X)^top bold(D) bold(X) )^(-1) bold(X)^top bold(D) overline(delta)_bold(w) $ <eq-11-25>
```

## (11.26)   PDF p.300

(11.25) 的收尾一式，用 `bold(X)^top bold(D) overline(delta)_bold(w)` 这个因子的二次型表示，末尾句点。本式之前有一行正文给出所用恒等式，收在行内公式一节。

```typst
$ = ( bold(X)^top bold(D) overline(delta)_bold(w) )^top ( bold(X)^top bold(D) bold(X) )^(-1) ( bold(X)^top bold(D) overline(delta)_bold(w) ) . $ <eq-11-26>
```

## (unnumbered p300-1)   PDF p.300

PBE 对 `bold(w)` 的梯度，末尾句点。

```typst
$ nabla overline("PBE")(bold(w)) = 2 nabla [ bold(X)^top bold(D) overline(delta)_bold(w) ]^top ( bold(X)^top bold(D) bold(X) )^(-1) ( bold(X)^top bold(D) overline(delta)_bold(w) ) . $
```

## (unnumbered p300-2)   PDF p.300

三个因子中的最后一个：写成行为策略下的期望，末尾逗号。

```typst
$ bold(X)^top bold(D) overline(delta)_bold(w) = sum_s mu(s) bold(x)(s) overline(delta)_bold(w)(s) = bb(E)[rho_t delta_t bold(x)_t], $
```

## (unnumbered p300-3)   PDF p.300

第一个因子：半梯度 TD(0) 更新梯度的转置，三行推导。第二行右侧括注 `(using episodic delta_t)`，末尾句点。

```typst
$ nabla bb(E)[rho_t delta_t bold(x)_t]^top &= bb(E)[rho_t nabla delta_t^top bold(x)_t^top] \
                                           &= bb(E)[rho_t nabla (R_(t+1) + gamma bold(w)^top bold(x)_(t+1) - bold(w)^top bold(x)_t)^top bold(x)_t^top] quad "(using episodic " delta_t ")" \
                                           &= bb(E)[rho_t (gamma bold(x)_(t+1) - bold(x)_t) bold(x)_t^top] . $
```

## (unnumbered p300-4)   PDF p.300

中间因子：特征向量外积的期望矩阵，末尾句点。

```typst
$ bold(X)^top bold(D) bold(X) = sum_s mu(s) bold(x)(s) bold(x)(s)^top = bb(E)[bold(x)_t bold(x)_t^top] . $
```

## (11.27)   PDF p.301

把三个期望代回后的 PBE 梯度，末尾句点。

```typst
$ nabla overline("PBE")(bold(w)) = 2 bb(E)[rho_t (gamma bold(x)_(t+1) - bold(x)_t) bold(x)_t^top] bb(E)[bold(x)_t bold(x)_t^top]^(-1) bb(E)[rho_t delta_t bold(x)_t] . $ <eq-11-27>
```

## (11.28)   PDF p.301

次级学习向量 `bold(v)` 的定义：后两个因子乘积的近似，末尾句点。

```typst
$ bold(v) approx bb(E)[bold(x)_t bold(x)_t^top]^(-1) bb(E)[rho_t delta_t bold(x)_t] . $ <eq-11-28>
```

## (unnumbered p301-1)   PDF p.301

带重要性采样比的最小均方（LMS）规则，末尾逗号。

```typst
$ bold(v)_(t+1) ≐ bold(v)_t + beta rho_t ( delta_t - bold(v)_t^top bold(x)_t ) bold(x)_t, $
```

## (11.29)   PDF p.301

GTD2 的更新五步推导，等号与约等号对齐。各行右侧括注依次为 `(the general SGD rule)`、`(from (11.27))`、`(based on (11.28))`、`(sampling)`；**原书把编号 (11.29) 印在第三行右侧**，标签仍挂在整块公式上。

```typst
$ bold(w)_(t+1) &= bold(w)_t - frac(1, 2) alpha nabla overline("PBE")(bold(w)_t) quad "(the general SGD rule)" \
                &= bold(w)_t - frac(1, 2) alpha 2 bb(E)[rho_t (gamma bold(x)_(t+1) - bold(x)_t) bold(x)_t^top] bb(E)[bold(x)_t bold(x)_t^top]^(-1) bb(E)[rho_t delta_t bold(x)_t] quad "(from (11.27))" \
                &= bold(w)_t + alpha bb(E)[rho_t (bold(x)_t - gamma bold(x)_(t+1)) bold(x)_t^top] bb(E)[bold(x)_t bold(x)_t^top]^(-1) bb(E)[rho_t delta_t bold(x)_t] \
                &approx bold(w)_t + alpha bb(E)[rho_t (bold(x)_t - gamma bold(x)_(t+1)) bold(x)_t^top] bold(v)_t quad "(based on (11.28))" \
                &approx bold(w)_t + alpha rho_t ( bold(x)_t - gamma bold(x)_(t+1) ) bold(x)_t^top bold(v)_t . quad "(sampling)" $ <eq-11-29>
```

## (unnumbered p302-1)   PDF p.302

TDC（GTD(0)）的六步推导，末尾逗号。第五、六行右侧括注 `(based on (11.28))` 与 `(sampling)`。

```typst
$ bold(w)_(t+1) &= bold(w)_t + alpha bb(E)[rho_t (bold(x)_t - gamma bold(x)_(t+1)) bold(x)_t^top] bb(E)[bold(x)_t bold(x)_t^top]^(-1) bb(E)[rho_t delta_t bold(x)_t] \
                &= bold(w)_t + alpha ( bb(E)[rho_t bold(x)_t bold(x)_t^top] - gamma bb(E)[rho_t bold(x)_(t+1) bold(x)_t^top] ) bb(E)[bold(x)_t bold(x)_t^top]^(-1) bb(E)[rho_t delta_t bold(x)_t] \
                &= bold(w)_t + alpha ( bb(E)[bold(x)_t bold(x)_t^top] - gamma bb(E)[rho_t bold(x)_(t+1) bold(x)_t^top] ) bb(E)[bold(x)_t bold(x)_t^top]^(-1) bb(E)[rho_t delta_t bold(x)_t] \
                &= bold(w)_t + alpha ( bb(E)[rho_t delta_t bold(x)_t] - gamma bb(E)[rho_t bold(x)_(t+1) bold(x)_t^top] bb(E)[bold(x)_t bold(x)_t^top]^(-1) bb(E)[rho_t delta_t bold(x)_t] ) \
                &approx bold(w)_t + alpha ( bb(E)[rho_t delta_t bold(x)_t] - gamma bb(E)[rho_t bold(x)_(t+1) bold(x)_t^top] bold(v)_t ) quad "(based on (11.28))" \
                &approx bold(w)_t + alpha rho_t ( delta_t bold(x)_t - gamma bold(x)_(t+1) bold(x)_t^top bold(v)_t ), quad "(sampling)" $
```

## (unnumbered p304-1)   PDF p.304

一步 Emphatic-TD 的 TD 误差，末尾逗号。

```typst
$ delta_t = R_(t+1) + gamma hat(v)(S_(t+1), bold(w)_t) - hat(v)(S_t, bold(w)_t), $
```

## (unnumbered p304-2)   PDF p.304

一步 Emphatic-TD 的更新式，含强调 `M_t` 与重要性采样比，末尾逗号。

```typst
$ bold(w)_(t+1) = bold(w)_t + alpha M_t rho_t delta_t nabla hat(v)(S_t, bold(w)_t), $
```

## (unnumbered p304-3)   PDF p.304

强调的递推式，末尾逗号。

```typst
$ M_t = gamma rho_(t-1) M_(t-1) + I_t, $
```

## 行内公式

只收录有结构或者容易写错的行内式。单字母变量与贯穿全章的符号（`$S_t$`、`$A_t$`、`$R_(t+1)$`、`$gamma$`、`$alpha$`、`$delta_t$`、`$epsilon$`、`$rho_t$`、`$pi (a|s)$`、`$b(a|s)$`、`$hat(v)(s, bold(w))$`、`$hat(q)(s, a, bold(w))$` 等）写法见 `glossary/notation.typ`，不逐处重复。

### PDF p.279

- `$hat(v) approx v_pi$`、`$hat(q) approx q_pi$`：off-policy 预测要学的目标策略状态值与动作值。

### PDF p.280

- `$bold(w)$`：把表格更新换成权重向量的更新对象（粗体）。
- `$hat(v)$`、`$hat(q)$`：近似值函数及其梯度。

### PDF p.281

- `$k >= T$`、`$t + n >= T$`：回合末端处理条件，`$T$` 是回合最后时刻。`$rho_k$` 取 1，`$G_(t:t+n)$` 取 `$G_t$`。
- `$Q(sigma)$`：第 7 章的统一动作值算法（其半梯度形式留作练习 11.2）。

### PDF p.282

- `$w$`、`$2w$`（斜体）：两个状态的估值形式，参数向量只有单分量 `$w$`。
- `$w = 10$`：初始参数（斜体）。
- `$1 + alpha (2 gamma - 1)$`：每步更新相乘的常数，大于 1 即发散。
- `$gamma > 0.5$`、`$alpha > 0$`：发散条件与步长条件。

### PDF p.283

- `$frac(6, 7)$`、`$frac(1, 7)$`：行为策略选择虚线动作与实线动作的概率（正文堆叠分式）。
- `$gamma = 0.99$`：折扣率。
- `$rho_t$`：off-policy 下可为 0，on-policy 下恒为 1。
- `$w$`、`$2w$`（斜体）：on-policy 讨论中的两个状态。

### PDF p.284

- `$bold(w) in bb(R)^8$`：八分量的权重向量（粗体）。
- `$bold(x)(1) = (2, 0, 0, 0, 0, 0, 0, 1)^top$`：第一个状态的特征向量。
- `$v_pi (s) = 0$`：全零的真值函数。
- `$bold(w) = bold(0)$`：精确近似对应的权重（粗体零向量）。
- `$bold(w)_k$`：同步 DP 式更新的权重向量。
- 图 11.2 图注：`$alpha = 0.01$`、`$bold(w) = (1, 1, 1, 1, 1, 1, 10, 1)^top$`。

### PDF p.285

- `$w$`、`$2w$`、`$w = 0$`、`$w_(k+1)$`（斜体）：例题 11.1 的单分量参数。
- `$overline("VE")$`：最小化的目标（正文带上划线直立体）。
- `$gamma > frac(5, 6 - 4 epsilon)$`：序列发散的条件（正文堆叠分式）。
- `$w_0 != 0$`：初始值非零的发散条件。

### PDF p.288

- `$v : cal(S) -> bb(R)$`：全体状态值函数的空间。
- `$cal(S) = {s_1, s_2, dots, s_|cal(S)|}$`：状态枚举。
- `$[v(s_1), v(s_2), dots, v(s_|cal(S)|)]^top$`：值函数的向量表示（下标列举写下三点）。
- `$cal(S) = {s_1, s_2, s_3}$`、`$bold(w) = (w_1, w_2)^top$`：三状态两参数的例子。
- `$v = v_1 - v_2$`：两个值函数的差向量。
- `$mu : cal(S) -> [0, 1]$`：状态分布。
- `$overline("VE")(bold(w)) = norm(v_bold(w) - v_pi)_mu^2$`：VE 用范数写作。
- `$v_bold(w)$`：权重对应的代表性值函数。

### PDF p.289

- `$Pi v_pi$`：真值函数的投影。
- 图 11.3 图注：`$bold(w) = (w_1, w_2)^top$`（粗体）。

### PDF p.290

- `$|cal(S)| times |cal(S)|$`、`$|cal(S)| times d$`：投影矩阵与特征矩阵的尺寸。
- `$bold(x)(s)^top$`：`bold(X)` 的每一行。
- `$overline(delta)_bold(w) = B_pi v_bold(w) - v_bold(w)$`：贝尔曼误差向量的算子写法。
- `$overline(delta)_bold(w) in bb(R)^|cal(S)|$`：误差向量所在的空间。
- `$v_bold(w) = v_pi$`：BE 为零处的等式。
- `$overline("BE")$`、`$overline("VE")$`、`$Pi v_pi$`：min BE 与 min VE 的指代。

### PDF p.291

- `$B_pi : bb(R)^|cal(S)| -> bb(R)^|cal(S)|$`：贝尔曼算子的函数类型。
- `$s in cal(S)$`、`$v : cal(S) -> bb(R)$`：算子的定义域。
- `$bold(w)_"TD"$`：TD 不动点（粗体，下标直立体 TD）。

### PDF p.293（例题 11.2）

- `$gamma = 1$`：回合制问题的折扣。
- `$rho_t = 1$`：on-policy 训练下的比值。
- `$frac(1, 2)$`、`$frac(3, 4)$`、`$frac(1, 4)$`：A、B、C 的收敛值（正文堆叠分式）。
- `$frac(1, 16)$`：每一步上的平方 TD 误差。
- `$frac(1, 8)$`：真值下两步转移的平均平方 TD 误差。

### PDF p.294（脚注 [^1] 与正文）

- `$S_(t+1)$`、`$rho_t$`：两处相乘的期望涉及的量；脚注 [^1] 说明状态值情形下两者对重要性采样比的处理差别。

### PDF p.295（例题 11.3）

- `$"A1"$`、`$"A2"$`、`$"A"$`、`$"B"$`、`$"C"$`：状态名（直立体，A1 与 A2 的数字不上标）。
- `$frac(1, 2)$`：A1 与 A2 共享的最优值。
- `$frac(3, 4)$`、`$frac(1, 4)$`：B 与 C 的收敛值。

### PDF p.297

- `$gamma = 0$`：使三状态真值依次为 1、0、2 的设定。
- `$w = 1$`（斜体）：两个 MRP 共同的最优解。
- `$bold(w)^*$`：最优参数向量（粗体加星号）。

### PDF p.298（例题 11.4）

- `$bold(w)$`：两个分量的权重向量（粗体，状态 A 用第一个分量，B 与 B′ 共用第二个）。
- `$mu(s) = frac(1, 3)$`，“for all s”：三个状态等时长的分布（正文堆叠分式）。
- `$2^(-k)$`：出现 k 个连串 B 的概率。
- `$bold(w) = bold(0)$`：第一个 MRP 的精确解。
- `$overline("BE") = mu("B") 1 + mu("B'") 1 = frac(2, 3)$`：第二个 MRP 在 `$bold(w) = bold(0)$` 处的 BE。
- `$(-frac(1, 2), 0)^top$`：`$gamma -> 1$` 时最小化 BE 的权重（正文堆叠分式）。
- `$v_bold(w)("A")$`：状态 A 的估计值。
- `$approx -frac(1, 2)$`：A 的 BE 最小化值。

### PDF p.299（图 11.4 图注）

- `$bold(w)^*$`：全部 VE 共有的最优参数向量（粗体加星号，出现两次）。

### PDF p.300

- `$O(d^2)$`、`$O(d)$`：最小二乘方法的复杂度与所求 SGD 方法的复杂度。
- `$d times d$`：前两个期望矩阵的尺寸。

### PDF p.301

- `$(bold(v)^top bold(x)_t - rho_t delta_t)^2$`：LMS 规则最小化的期望平方误差。
- `$beta > 0$`：次级学习过程的步长。
- `$bold(x)_t^top bold(v)_t$`：先算的内积，使 TDC 保持 `$O(d)$` 复杂度。

### PDF p.302（图 11.5 图注）

- `$alpha = 0.005$`、`$beta = 0.05$`：TDC 的两个步长。

### PDF p.303

- `$hat(v)(s) = 0$`：最优解。
- `$(1, 1, 1, 1, 1, 1, 4, -2)^top$`：最优解处 `$bold(w)$` 应成的比例。
- `$beta arrow.l 0$`、`$frac(alpha, beta) arrow.l 0$`：双时间尺度收敛证明的极限条件（正文堆叠分式）。
- `$overline("VE")$`：1000 次迭代后仍接近 2 的量。

### PDF p.304

- `$bb(E)_(s tilde b)[bold(x)(s) bb(E)[bold(x)(S_(t+1))^top | S_t = s, A_t tilde pi]]$`：off-policy 下矩阵 A 的定义（脚注 [^4]）。
- `$gamma = 0.9$`、`$1 - gamma$`：折扣与每一步的伪终止概率。
- `$M_(-1) = 0$`：强调的初始化。
- `$I_t = 1$`：图 11.6 所示轨迹所用的兴趣设定。

### PDF p.305（图 11.6 图注）

- `$alpha = 0.03$`：一步 Emphatic-TD 的步长。

### PDF p.306–307

- `$O(d)$`：把加权重要性采样适配到函数近似的复杂度（p306）。
- `$O(d)$`：PBE 梯度的复杂度（p307）。

### PDF p.308（Bibliographical and Historical Remarks 11.4）

- `$B_pi$`、`$T_pi$`、`$T^((lambda))$`：贝尔曼算子与 TD(λ) 算子的常见记号（`$T_pi$` 称“dynamic programming operator”，`$T^((lambda))$` 称“TD(λ) operator”）。
