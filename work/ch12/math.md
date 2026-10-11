# 第 12 章公式（Eligibility Traces，PDF 309–342）

全部公式对照 `work/pages/pNNNN.png` 页面渲染图逐条重建，未参考文字层的数学片段。

代码即 Typst 数学代码。块级公式写成 `$ ... $`（两侧留空格），行内公式写成 `$...$`；章文件里直接照抄即可。原书带编号的公式在代码之后给出标签，编号由模板生成。原书中不编号的展示公式按其在页面上的先后记为 `(unnumbered pNNN-k)`，与 `source.md` 的占位符一一对应。

写法约定沿用第 9 章、第 10 章、第 11 章与第 13 章：下标是单独一个标识符或符号、后面紧跟 `(` 或 `[` 时中间必须留空格（`overline(V)_t (S_(t+1))`、`overline(V)_t (s)`）。集合记号写 `cal(S)`、`cal(A)`，含终止状态的扩张写 `cal(S)^+`，活动特征集合函数写 `cal(F)`；`d` 维实空间写 `bb(R)^d`。定义为写 `≐`；约等写 `approx`；分式写 `frac(...)`；转置写 `^top`；梯度算子写 `nabla`；求和写 `sum`，连乘写 `product`；无穷写 `oo`；小于等于与大于等于写 `<=`、`>=`；属于写 `in`；函数类型里的箭头写 `->`；居中三点省略号写 `dots.c`，行内与下标列举的省略号写 `dots`，三角阵里的竖排省略号写 `dots.v`、斜向省略号写 `dots.down`。原书明显放大的括号用 `lr(size: #125%, (...))` 或 `#130%`，以渲染图为准；三角阵用 `mat(delim: #none, ...)`。

本章特有：

- 权重向量、特征向量、轨迹向量与辅助向量都是粗体：`bold(w)`、`bold(x)`、`bold(v)`、`bold(z)`、`bold(a)`；单位矩阵写 `bold(I)`，遗忘矩阵写 `bold(F)_t`，粗体零向量写 `bold(0)`；目标策略下的平均特征向量写 `overline(bold(x))_t`（粗体 x 带上划线）。(12.12) 的替换轨迹分量 `z_(i,t)`、`x_(i,t)` 与原书一致是斜体，不带粗体。
- 值函数带帽：`hat(v)`、`hat(q)`；目标策略下动作值的平均写 `overline(V)_t (s)`（直立体大写 V 带上划线，非粗体）。算法框标题里的“估计 v̂ ≈ v_π”等写法照录。
- 重要性采样比写 `rho_t`、`rho_(t+1)`；第 12.8 节起可变参数写 `gamma_t`、`lambda_t`。
- 状态值情形的 TD 误差有两种记号：权重固定处的 `delta_t`（(12.6)），以及自举到旧权重的 `delta'_t`（(12.10) 的定义行，撇号照录）。可变参数与 off-policy 情形写 `delta_t^s`、`delta_t^a`。
- λ-return 的上标：状态值写 `G_t^lambda` 或 `G_(t:t+n)^lambda`，可变参数的状态值写 `G_t^(lambda s)`，动作值写 `G_t^(lambda a)`。
- 直立体词写引号字符串：`overline("VE")` 中的 `"VE"`、`"or"`、`"with"`、`"if"`、`"otherwise"`、`"accumulating traces"`、`"replacing traces"`。
- 公式 (12.14) 中间插有一整行正文（左顶格）：`where **F**_t ≐ I − α**x**_t**x**_t^⊤ is a *forgetting, or fading*, matrix. Now, recursing,`；其行内数学部分在 `## 行内公式` 里单列。

## (12.1)   PDF p.310

n 步截断回报，页面上方居中，行末左侧接条件、右侧接编号。

```typst
$ G_(t:t+n) ≐ R_(t+1) + gamma R_(t+2) + dots.c + gamma^(n-1) R_(t+n) + gamma^n hat(v)(S_(t+n), bold(w)_(t+n-1)), quad 0 <= t <= T - n, $
```
<eq-12-1>

## (12.2)   PDF p.311

```typst
$ G_t^lambda ≐ (1 - lambda) sum_(n=1)^oo lambda^(n-1) G_(t:t+n). $
```
<eq-12-2>

## (12.3)   PDF p.312

等号两侧印得较宽，原书用的是普通等号。求和上限是 `T - t - 1`，不是 `oo`。

```typst
$ G_t^lambda = (1 - lambda) sum_(n=1)^(T-t-1) lambda^(n-1) G_(t:t+n) + lambda^(T-t-1) G_t, $
```
<eq-12-3>

## (12.4)   PDF p.312

方括号为放大括号。

```typst
$ bold(w)_(t+1) ≐ bold(w)_t + alpha [G_t^lambda - hat(v)(S_t, bold(w)_t)] nabla hat(v)(S_t, bold(w)_t), quad t = 0, dots, T - 1. $
```
<eq-12-4>

## (12.5)   PDF p.314

两行，初始化行在前；条件与编号在第二行右端。

```typst
$ & bold(z)_(-1) ≐ bold(0), \
  & bold(z)_t ≐ gamma lambda bold(z)_(t-1) + nabla hat(v)(S_t, bold(w)_t), quad 0 <= t <= T, $
```
<eq-12-5>

## (12.6)   PDF p.315

```typst
$ delta_t ≐ R_(t+1) + gamma hat(v)(S_(t+1), bold(w)_t) - hat(v)(S_t, bold(w)_t). $
```
<eq-12-6>

## (12.7)   PDF p.315

```typst
$ bold(w)_(t+1) ≐ bold(w)_t + alpha delta_t bold(z)_t. $
```
<eq-12-7>

## (12.8)   PDF p.316–317

跨页公式，分行点在第 317 页；`min` 的下标是粗体 w 向量。

```typst
$ overline("VE")(bold(w)_infinity) <= frac(1 - gamma lambda, 1 - gamma) min_bold(w) overline("VE")(bold(w)). $
```
<eq-12-8>

## (12.9)   PDF p.318

```typst
$ G_(t:h)^lambda ≐ (1 - lambda) sum_(n=1)^(h-t-1) lambda^(n-1) G_(t:t+n) + lambda^(h-t-1) G_(t:h), quad 0 <= t < h <= T. $
```
<eq-12-9>

## (unnumbered p319-1)   PDF p.319

第 12.3 节开头的 TTD(λ) 更新式，方括号为放大括号。

```typst
$ bold(w)_(t+n) ≐ bold(w)_(t+n-1) + alpha [G_(t:t+n)^lambda - hat(v)(S_t, bold(w)_(t+n-1))] nabla hat(v)(S_t, bold(w)_(t+n-1)), quad 0 <= t < T. $
```

## (12.10)   PDF p.319

等号为普通等号；右边第一项自举到上一时刻的权重 `bold(w)_(t-1)`；求和项里的 TD 误差带撇号 `delta'_i`。紧随其后另起一行是定义行：先单出一行正文 `where`，下一行是不编号的 `delta'_t` 定义（见下一条）。

```typst
$ G_(t:t+k)^lambda = hat(v)(S_t, bold(w)_(t-1)) + sum_(i=t)^(t+k-1) (gamma lambda)^(i-t) delta'_i, $
```
<eq-12-10>

## (unnumbered p319-2)   PDF p.319

接收上一级的 `where`，行末是句点。

```typst
$ delta'_t ≐ R_(t+1) + gamma hat(v)(S_(t+1), bold(w)_t) - hat(v)(S_t, bold(w)_(t-1)). $
```

## (unnumbered p319-3)   PDF p.319

正文中重述的截断 λ-return（(12.9) 的重述），无编号。

```typst
$ G_(t:h)^lambda ≐ (1 - lambda) sum_(n=1)^(h-t-1) lambda^(n-1) G_(t:t+n) + lambda^(h-t-1) G_(t:h). $
```

## (unnumbered p320-1)   PDF p.320

截断 λ-return 的逐 h 展开的第一段（`h = 1`），行末逗号。

```typst
$ h = 1 : quad bold(w)_1^1 ≐ bold(w)_0^1 + alpha [G_(0:1)^lambda - hat(v)(S_0, bold(w)_0^1)] nabla hat(v)(S_0, bold(w)_0^1), $
```

## (unnumbered p320-2)   PDF p.320

`h = 2` 的两行，两行左端对齐在 `h = 2 :` 之后，行末均为逗号。

```typst
$ h = 2 : quad & bold(w)_1^2 ≐ bold(w)_0^2 + alpha [G_(0:2)^lambda - hat(v)(S_0, bold(w)_0^2)] nabla hat(v)(S_0, bold(w)_0^2), \
                  & bold(w)_2^2 ≐ bold(w)_1^2 + alpha [G_(1:2)^lambda - hat(v)(S_1, bold(w)_1^2)] nabla hat(v)(S_1, bold(w)_1^2), $
```

## (unnumbered p320-3)   PDF p.320

`h = 3` 的三行，末行为句点。

```typst
$ h = 3 : quad & bold(w)_1^3 ≐ bold(w)_0^3 + alpha [G_(0:3)^lambda - hat(v)(S_0, bold(w)_0^3)] nabla hat(v)(S_0, bold(w)_0^3), \
                  & bold(w)_2^3 ≐ bold(w)_1^3 + alpha [G_(1:3)^lambda - hat(v)(S_1, bold(w)_1^3)] nabla hat(v)(S_1, bold(w)_1^3), \
                  & bold(w)_3^3 ≐ bold(w)_2^3 + alpha [G_(2:3)^lambda - hat(v)(S_2, bold(w)_2^3)] nabla hat(v)(S_2, bold(w)_2^3). $
```

## (unnumbered p320-4)   PDF p.320

由上面几段归纳出的一般式，方括号为放大括号。

```typst
$ bold(w)_(t+1)^h ≐ bold(w)_t^h + alpha [G_(t:h)^lambda - hat(v)(S_t, bold(w)_t^h)] nabla hat(v)(S_t, bold(w)_t^h), quad 0 <= t < h <= T. $
```

## (unnumbered p321-1)   PDF p.321

截断更新序列排成的下三角阵（行数随 h 增加，最后两行是省略号行与 `T` 行），无括号。末行中间的省略号是居中三点。

```typst
$ mat(delim: #none,
  bold(w)_0^0, , , , , ;
  bold(w)_0^1, bold(w)_1^1, , , , ;
  bold(w)_0^2, bold(w)_1^2, bold(w)_2^2, , , ;
  bold(w)_0^3, bold(w)_1^3, bold(w)_2^3, bold(w)_3^3, , ;
  dots.v, dots.v, dots.v, dots.v, dots.down, ;
  bold(w)_0^T, bold(w)_1^T, bold(w)_2^T, bold(w)_3^T, dots.c, bold(w)_T^T;
) $
```

## (unnumbered p322-1)   PDF p.322

真在线 TD(λ) 的权重更新式，是论文版更新（已代入 TD 误差）的原文形式；两处方括号与后面的圆括号都按渲染图放大。

```typst
$ bold(w)_(t+1) ≐ bold(w)_t + alpha delta_t bold(z)_t + alpha (bold(w)_t^top bold(x)_t - bold(w)_(t-1)^top bold(x)_t)(bold(z)_t - bold(x)_t), $
```

## (12.11)   PDF p.322

真在线 TD(λ) 的轨迹更新式；括号内是 `1 - alpha gamma lambda bold(z)_(t-1)^top bold(x)_t`，外层圆括号为放大括号。

```typst
$ bold(z)_t ≐ gamma lambda bold(z)_(t-1) + (1 - alpha gamma lambda bold(z)_(t-1)^top bold(x)_t) bold(x)_t. $
```
<eq-12-11>

## (12.12)   PDF p.323

替换轨迹的分量定义，用 `cases`。左侧分量符号是斜体（不带粗体），条件列写直立体词，行末为句点。

```typst
$ z_(i,t) ≐ cases(1 &"if" x_(i,t) = 1, gamma lambda z_(i,t-1) &"otherwise" .) $
```
<eq-12-12>

## (12.13)   PDF p.323

梯度蒙特卡洛预测的线性版本更新式，方括号为放大括号，行末先逗号再接条件与编号。

```typst
$ bold(w)_(t+1) ≐ bold(w)_t + alpha [G - bold(w)_t^top bold(x)_t] bold(x)_t, quad 0 <= t < T. $
```
<eq-12-13>

## (12.14)   PDF p.324

第一段四行的推导（`G` 是整幕回报），随后插入一行正文 `where ... matrix. Now, recursing,`（见文件头本章特有说明），再接四行递归与带下划线标注的收尾行。下划线标注两处：第一处标在最后一行第一个连乘 `bold(F)_(T-1) dots.c bold(F)_0 bold(w)_0` 之下，标签 `bold(a)_(T-1)`；第二处只标在最后的求和 `sum_(k=0)^(T-1) bold(F)_(T-1) dots.c bold(F)_(k+1) bold(x)_k` 之下（不含前面的 `alpha G`），标签 `bold(z)_(T-1)`。递归段后的省略号为竖排三点。`source.md` 中本式拆成两个占位符：`[[EQ: (12.14)]]` 与 `[[EQ: (12.14) 续]]`。

```typst
$ bold(w)_T &≐ bold(w)_(T-1) + alpha (G - bold(w)_(T-1)^top bold(x)_(T-1)) bold(x)_(T-1) \
  &= bold(w)_(T-1) + alpha bold(x)_(T-1)(-bold(x)_(T-1)^top bold(w)_(T-1)) + alpha G bold(x)_(T-1) \
  &= (bold(I) - alpha bold(x)_(T-1) bold(x)_(T-1)^top) bold(w)_(T-1) + alpha G bold(x)_(T-1) \
  &= bold(F)_(T-1) bold(w)_(T-1) + alpha G bold(x)_(T-1), $
```

```typst
$ &= bold(F)_(T-1)(bold(F)_(T-2) bold(w)_(T-2) + alpha G bold(x)_(T-2)) + alpha G bold(x)_(T-1) \
  &= bold(F)_(T-1) bold(F)_(T-2) bold(w)_(T-2) + alpha G (bold(F)_(T-1) bold(x)_(T-2) + bold(x)_(T-1)) \
  &= bold(F)_(T-1) bold(F)_(T-2)(bold(F)_(T-3) bold(w)_(T-3) + alpha G bold(x)_(T-3)) + alpha G (bold(F)_(T-1) bold(x)_(T-2) + bold(x)_(T-1)) \
  &= bold(F)_(T-1) bold(F)_(T-2) bold(F)_(T-3) bold(w)_(T-3) + alpha G (bold(F)_(T-1) bold(F)_(T-2) bold(x)_(T-3) + bold(F)_(T-1) bold(x)_(T-2) + bold(x)_(T-1)) \
  &dots.v \
  &= underbrace(bold(F)_(T-1) bold(F)_(T-2) dots.c bold(F)_0 bold(w)_0, bold(a)_(T-1)) + alpha G underbrace(sum_(k=0)^(T-1) bold(F)_(T-1) bold(F)_(T-2) dots.c bold(F)_(k+1) bold(x)_k, bold(z)_(T-1)) \
  &= bold(a)_(T-1) + alpha G bold(z)_(T-1), $
```
<eq-12-14>

## (unnumbered p324-1)   PDF p.324

`bold(z)_t` 的递推链，八行，只在第一行右侧带条件 `1 <= t < T`，末行行末逗号。

```typst
$ bold(z)_t &≐ sum_(k=0)^t bold(F)_t bold(F)_(t-1) dots.c bold(F)_(k+1) bold(x)_k, quad 1 <= t < T \
  &= sum_(k=0)^(t-1) bold(F)_t bold(F)_(t-1) dots.c bold(F)_(k+1) bold(x)_k + bold(x)_t \
  &= bold(F)_t sum_(k=0)^(t-1) bold(F)_(t-1) bold(F)_(t-2) dots.c bold(F)_(k+1) bold(x)_k + bold(x)_t \
  &= bold(F)_t bold(z)_(t-1) + bold(x)_t \
  &= (bold(I) - alpha bold(x)_t bold(x)_t^top) bold(z)_(t-1) + bold(x)_t \
  &= bold(z)_(t-1) - alpha bold(x)_t bold(x)_t^top bold(z)_(t-1) + bold(x)_t \
  &= bold(z)_(t-1) - alpha (bold(z)_(t-1)^top bold(x)_t) bold(x)_t + bold(x)_t \
  &= bold(z)_(t-1) + (1 - alpha bold(z)_(t-1)^top bold(x)_t) bold(x)_t, $
```

## (unnumbered p324-2)   PDF p.324

辅助向量 `bold(a)_t` 的一行链式定义，行末条件 `1 <= t < T`。

```typst
$ bold(a)_t ≐ bold(F)_t bold(F)_(t-1) dots.c bold(F)_0 bold(w)_0 = bold(F)_t bold(a)_(t-1) = bold(a)_(t-1) - alpha bold(x)_t bold(x)_t^top bold(a)_(t-1), quad 1 <= t < T. $
```

## (12.15)   PDF p.325

动作值形式的离线 λ-return 更新式，方括号为放大括号，行末为句点再接编号。

```typst
$ bold(w)_(t+1) ≐ bold(w)_t + alpha [G_t^lambda - hat(q)(S_t, A_t, bold(w)_t)] nabla hat(q)(S_t, A_t, bold(w)_t), quad t = 0, dots, T - 1. $
```
<eq-12-15>

## (unnumbered p325-1)   PDF p.325

动作值形式的 n 步回报，紧随正文 `with G_(t:t+n) ≐ G_t if t + n >= T.`（行内公式见后）。行末条件 `t + n < T` 后为逗号；中间省略号为居中三点。

```typst
$ G_(t:t+n) ≐ R_(t+1) + dots.c + gamma^(n-1) R_(t+n) + gamma^n hat(q)(S_(t+n), A_(t+n), bold(w)_(t+n-1)), quad t + n < T, $
```

## (unnumbered p325-2)   PDF p.325

Sarsa(λ) 的平凡形式权重更新（等价于 (12.7)）。

```typst
$ bold(w)_(t+1) ≐ bold(w)_t + alpha delta_t bold(z)_t, $
```

## (12.16)   PDF p.325

```typst
$ delta_t ≐ R_(t+1) + gamma hat(q)(S_(t+1), A_(t+1), bold(w)_t) - hat(q)(S_t, A_t, bold(w)_t), $
```
<eq-12-16>

## (unnumbered p325-3)   PDF p.325

动作值形式的轨迹，两行一块，行首对齐。

```typst
$ & bold(z)_(-1) ≐ bold(0), \
  & bold(z)_t ≐ gamma lambda bold(z)_(t-1) + nabla hat(q)(S_t, A_t, bold(w)_t), quad 0 <= t <= T. $
```

## (12.17)   PDF p.330

可变折扣率下的回报定义，三行；第二行是展开式，第三行把乘积写成连乘记号。全式不带粗体。

```typst
$ G_t &≐ R_(t+1) + gamma_(t+1) G_(t+1) \
  &= R_(t+1) + gamma_(t+1) R_(t+2) + gamma_(t+1) gamma_(t+2) R_(t+3) + gamma_(t+1) gamma_(t+2) gamma_(t+3) R_(t+4) + dots.c \
  &= sum_(k=t)^oo (product_(i=t+1)^k gamma_i) R_(k+1), $
```
<eq-12-17>

## (12.18)   PDF p.330

状态值形式的可变参数 λ-return（自举到旧权重）。紧随其后的正文行是 `where V̄_t is ...`（见 `source.md`；其行内部分不单列）。外层圆括号为放大括号。

```typst
$ G_t^(lambda s) ≐ R_(t+1) + gamma_(t+1) lr(size: #130%, ( (1 - lambda_(t+1)) hat(v)(S_(t+1), bold(w)_t) + lambda_(t+1) G_(t+1)^(lambda s) )), $
```
<eq-12-18>

## (12.19)   PDF p.330

动作值形式的 λ-return（Sarsa 形式）。

```typst
$ G_t^(lambda a) ≐ R_(t+1) + gamma_(t+1) lr(size: #130%, ( (1 - lambda_(t+1)) hat(q)(S_(t+1), A_(t+1), bold(w)_t) + lambda_(t+1) G_(t+1)^(lambda a) )), $
```
<eq-12-19>

## (12.20)   PDF p.330

动作值形式的 λ-return（Expected Sarsa 形式），用 `overline(V)_t (S_(t+1))` 替换 `hat(q)`。

```typst
$ G_t^(lambda a) ≐ R_(t+1) + gamma_(t+1) lr(size: #130%, ( (1 - lambda_(t+1)) overline(V)_t (S_(t+1)) + lambda_(t+1) G_(t+1)^(lambda a) )), $
```
<eq-12-20>

## (12.21)   PDF p.330

`overline(V)_t (s)` 的定义，(7.8) 的函数逼近推广。

```typst
$ overline(V)_t (s) ≐ sum_a pi (a|s) hat(q)(s, a, bold(w)_t). $
```
<eq-12-21>

## (12.22)   PDF p.331

off-policy 状态值 λ-return 的最终定义。外层 `rho_t (...)` 的圆括号与内层 `gamma_(t+1)(...)` 的圆括号都按渲染图放大（外层更大）。

```typst
$ G_t^(lambda s) ≐ rho_t lr(size: #130%, (R_(t+1) + gamma_(t+1) lr(size: #125%, ((1 - lambda_(t+1)) hat(v)(S_(t+1), bold(w)_t) + lambda_(t+1) G_(t+1)^(lambda s))))) + (1 - rho_t) hat(v)(S_t, bold(w)_t), $
```
<eq-12-22>

## (12.23)   PDF p.331

状态值 TD 误差（可变参数、off-policy 情形仍按 (12.6) 的形式）。

```typst
$ delta_t^s ≐ R_(t+1) + gamma_(t+1) hat(v)(S_(t+1), bold(w)_t) - hat(v)(S_t, bold(w)_t), $
```
<eq-12-23>

## (12.24)   PDF p.331

用 TD 误差之和表示的 λ-return 近似，约等号照录。

```typst
$ G_t^(lambda s) approx hat(v)(S_t, bold(w)_t) + rho_t sum_(k=t)^oo delta_k^s product_(i=t+1)^k gamma_i lambda_i rho_i, $
```
<eq-12-24>

## (unnumbered p331-1)   PDF p.331

由 (12.24) 得到的前视更新，两行；第一行的圆括号按渲染图放大。第二行未写结束标点，照录。

```typst
$ bold(w)_(t+1) &= bold(w)_t + alpha (G_t^(lambda s) - hat(v)(S_t, bold(w)_t)) nabla hat(v)(S_t, bold(w)_t) \
  &approx bold(w)_t + alpha rho_t (sum_(k=t)^oo delta_k^s product_(i=t+1)^k gamma_i lambda_i rho_i) nabla hat(v)(S_t, bold(w)_t), $
```

## (unnumbered p332-1)   PDF p.332

前视更新按时间求和后的重组，三行公式，第二行与第三行之间夹一行居中的说明文字。第一行为左端顶格的求和式，第二、三行的等号对齐；第二行的 `delta_k^s` 在 `nabla hat(v)` 之后，第三行的 `delta_k^s` 提到内层求和之前。末行行末逗号。

```typst
$ &sum_(t=0)^oo (bold(w)_(t+1) - bold(w)_t) approx sum_(t=0)^oo sum_(k=t)^oo alpha rho_t delta_k^s nabla hat(v)(S_t, bold(w)_t) product_(i=t+1)^k gamma_i lambda_i rho_i \
  &= sum_(k=0)^oo sum_(t=0)^k alpha rho_t nabla hat(v)(S_t, bold(w)_t) delta_k^s product_(i=t+1)^k gamma_i lambda_i rho_i \
  &quad "(using the summation rule: " sum_(t=x)^y sum_(k=t)^y = sum_(k=x)^y sum_(t=x)^k ")" \
  &= sum_(k=0)^oo alpha delta_k^s sum_(t=0)^k rho_t nabla hat(v)(S_t, bold(w)_t) product_(i=t+1)^k gamma_i lambda_i rho_i, $
```

## (unnumbered p332-2)   PDF p.332

`bold(z)_k` 的展开链，四行；第三行的求和项下有下划线标注，标签 `bold(z)_(k-1)`（标注只覆盖求和本身，不含前面的 `gamma_k lambda_k rho_k`）。

```typst
$ bold(z)_k &= sum_(t=0)^k rho_t nabla hat(v)(S_t, bold(w)_t) product_(i=t+1)^k gamma_i lambda_i rho_i \
  &= sum_(t=0)^(k-1) rho_t nabla hat(v)(S_t, bold(w)_t) product_(i=t+1)^k gamma_i lambda_i rho_i + rho_k nabla hat(v)(S_k, bold(w)_k) \
  &= gamma_k lambda_k rho_k underbrace(sum_(t=0)^(k-1) rho_t nabla hat(v)(S_t, bold(w)_t) product_(i=t+1)^(k-1) gamma_i lambda_i rho_i, bold(z)_(k-1)) + rho_k nabla hat(v)(S_k, bold(w)_k) \
  &= rho_k (gamma_k lambda_k bold(z)_(k-1) + nabla hat(v)(S_k, bold(w)_k)), $
```

## (12.25)   PDF p.332

off-policy 状态值 TD(λ) 的轨迹更新式，圆括号为放大括号。

```typst
$ bold(z)_t ≐ rho_t (gamma_t lambda_t bold(z)_(t-1) + nabla hat(v)(S_t, bold(w)_t)), $
```
<eq-12-25>

## (12.26)   PDF p.333

动作值形式的 λ-return 的 off-policy 版，两行；第一行的方括号与第二行的圆括号也都有放大。

```typst
$ G_t^(lambda a) &≐ R_(t+1) + gamma_(t+1) lr(size: #130%, ( (1 - lambda_(t+1)) overline(V)_t (S_(t+1)) + lambda_(t+1) lr(size: #125%, [ rho_(t+1) G_(t+1)^(lambda a) + overline(V)_t (S_(t+1)) - rho_(t+1) hat(q)(S_(t+1), A_(t+1), bold(w)_t) ]) )) \
  &= R_(t+1) + gamma_(t+1) lr(size: #130%, ( overline(V)_t (S_(t+1)) + lambda_(t+1) rho_(t+1) lr(size: #125%, [ G_(t+1)^(lambda a) - hat(q)(S_(t+1), A_(t+1), bold(w)_t) ]) )) $
```
<eq-12-26>

## (12.27)   PDF p.333

用 TD 误差之和表示的动作值 λ-return 近似；连乘项中是 `gamma_i lambda_i rho_i`。

```typst
$ G_t^(lambda a) approx hat(q)(S_t, A_t, bold(w)_t) + sum_(k=t)^oo delta_k^a product_(i=t+1)^k gamma_i lambda_i rho_i, $
```
<eq-12-27>

## (12.28)   PDF p.333

期望形式的动作值 TD 误差。

```typst
$ delta_t^a ≐ R_(t+1) + gamma_(t+1) overline(V)_t (S_(t+1)) - hat(q)(S_t, A_t, bold(w)_t). $
```
<eq-12-28>

## (12.29)   PDF p.333

Expected Sarsa(λ) 的轨迹更新式，连乘系数是 `gamma_t lambda_t rho_t`。

```typst
$ bold(z)_t ≐ gamma_t lambda_t rho_t bold(z)_(t-1) + nabla hat(q)(S_t, A_t, bold(w)_t). $
```
<eq-12-29>

## (unnumbered p335-1)   PDF p.335

Tree Backup(λ) 的 λ-return 递归展开，两行；第一行的求和号下标是 `a != A_(t+1)`，方括号与外层圆括号为放大括号。

```typst
$ G_t^(lambda a) &≐ R_(t+1) + gamma_(t+1) lr(size: #130%, ( (1 - lambda_(t+1)) overline(V)_t (S_(t+1)) + lambda_(t+1) lr(size: #125%, [ sum_(a != A_(t+1)) pi (a|S_(t+1)) hat(q)(S_(t+1), a, bold(w)_t) + pi (A_(t+1)|S_(t+1)) G_(t+1)^(lambda a) ]) )) \
  &= R_(t+1) + gamma_(t+1) lr(size: #130%, ( overline(V)_t (S_(t+1)) + lambda_(t+1) pi (A_(t+1)|S_(t+1)) lr(size: #125%, ( G_(t+1)^(lambda a) - hat(q)(S_(t+1), A_(t+1), bold(w)_t) )) )) $
```

## (unnumbered p335-2)   PDF p.335

TB(λ) 的 TD 误差之和近似；连乘项中是 `gamma_i lambda_i pi (A_i|S_i)`（没有 `rho_i`），这是与 (12.27) 的唯一区别。

```typst
$ G_t^(lambda a) approx hat(q)(S_t, A_t, bold(w)_t) + sum_(k=t)^oo delta_k^a product_(i=t+1)^k gamma_i lambda_i pi (A_i|S_i), $
```

## (unnumbered p335-3)   PDF p.335

TB(λ) 的轨迹更新式，印在本页最后一行，行末句点。

```typst
$ bold(z)_t ≐ gamma_t lambda_t pi (A_t|S_t) bold(z)_(t-1) + nabla hat(q)(S_t, A_t, bold(w)_t). $
```

## (unnumbered p336-1)   PDF p.336

GTD(λ) 的权重与辅助向量更新式，圆括号为放大括号，行末逗号。

```typst
$ bold(w)_(t+1) ≐ bold(w)_t + alpha delta_t^s bold(z)_t - alpha gamma_(t+1)(1 - lambda_(t+1))(bold(z)_t^top bold(v)_t) bold(x)_(t+1), $
```

## (12.30)   PDF p.337

GTD(λ) 的辅助向量更新式。

```typst
$ bold(v)_(t+1) ≐ bold(v)_t + beta delta_t^s bold(z)_t - beta (bold(v)_t^top bold(x)_t) bold(x)_t, $
```
<eq-12-30>

## (unnumbered p337-1)   PDF p.337

GQ(λ) 的权重更新式，特征向量换成目标策略下的平均特征 `overline(bold(x))`。

```typst
$ bold(w)_(t+1) ≐ bold(w)_t + alpha delta_t^a bold(z)_t - alpha gamma_(t+1)(1 - lambda_(t+1))(bold(z)_t^top bold(v)_t) overline(bold(x))_(t+1), $
```

## (unnumbered p337-2)   PDF p.337

平均特征向量的定义。

```typst
$ overline(bold(x))_t ≐ sum_a pi (a|S_t) bold(x)(S_t, a), $
```

## (unnumbered p337-3)   PDF p.337

GQ(λ) 的 TD 误差定义。

```typst
$ delta_t^a ≐ R_(t+1) + gamma_(t+1) bold(w)_t^top overline(bold(x))_(t+1) - bold(w)_t^top bold(x)_t, $
```

## (unnumbered p337-4)   PDF p.337

HTD(λ) 的两条更新式与两条轨迹定义，四行一块；第二行的 `with bold(v)_0 ≐ bold(0),` 与第四行的 `with bold(z)_(-1)^b ≐ bold(0),` 印在同一行右端。第一行方括号为放大括号。

```typst
$ &bold(w)_(t+1) ≐ bold(w)_t + alpha delta_t^s bold(z)_t + alpha ((bold(z)_t - bold(z)_t^b)^top bold(v)_t)(bold(x)_t - gamma_(t+1) bold(x)_(t+1)), \
  &bold(v)_(t+1) ≐ bold(v)_t + beta delta_t^s bold(z)_t - beta (bold(z)_t^(b top) bold(v)_t)(bold(x)_t - gamma_(t+1) bold(x)_(t+1)), quad "with" bold(v)_0 ≐ bold(0), \
  &bold(z)_t ≐ rho_t (gamma_t lambda_t bold(z)_(t-1) + bold(x)_t), quad "with" bold(z)_(-1) ≐ bold(0), \
  &bold(z)_t^b ≐ gamma_t lambda_t bold(z)_(t-1)^b + bold(x)_t, quad "with" bold(z)_(-1)^b ≐ bold(0), $
```

## (unnumbered p338-1)   PDF p.338

Emphatic TD(λ) 的更新式与三个辅助量的定义，五行一块；第三行右端 `with bold(z)_(-1) ≐ bold(0),`、第五行右端 `with F_0 ≐ i(S_0),`。

```typst
$ &bold(w)_(t+1) ≐ bold(w)_t + alpha delta_t bold(z)_t \
  &delta_t ≐ R_(t+1) + gamma_(t+1) bold(w)_t^top bold(x)_(t+1) - bold(w)_t^top bold(x)_t \
  &bold(z)_t ≐ rho_t (gamma_t lambda_t bold(z)_(t-1) + M_t bold(x)_t), quad "with" bold(z)_(-1) ≐ bold(0), \
  &M_t ≐ lambda_t I_t + (1 - lambda_t) F_t \
  &F_t ≐ rho_(t-1) gamma_t F_(t-1) + I_t, quad "with" F_0 ≐ i(S_0), $
```

## 伪代码框内公式

四个算法框里的公式都写成行内数学式。赋值箭头一律写 `arrow.l`（原书为 ←）；采样写 `$A tilde pi (dot.op | S)$` 这种形式；`≐`、`approx`、`in`、`->` 直接写；`V_"old"`、`Q_"old"` 的下标 `"old"` 用引号字符串。框内公式不带编号，`source.md` 的伪代码框里也没有占位符。

### PDF p.315 「Semi-gradient TD(λ) for estimating v̂ ≈ v_π」框

- 值函数：`$hat(v) : cal(S)^+ times bb(R)^d -> bb(R)$`，且 `$hat(v)("terminal", dot.op) = 0$`。
- 参数：步长 `$alpha > 0$`、迹衰减率 `$lambda in [0, 1]$`。
- 初始化：`$bold(w)$` 任意（例如 `$bold(w) = bold(0)$`）。
- 轨迹清零：`$bold(z) arrow.l bold(0)$`（`$d$` 维向量）。
- 动作选择：`$A tilde pi (dot.op | S)$`。
- 轨迹更新：`$bold(z) arrow.l gamma lambda bold(z) + nabla hat(v)(S, bold(w))$`。
- TD 误差：`$delta arrow.l R + gamma hat(v)(S', bold(w)) - hat(v)(S, bold(w))$`。
- 权重更新：`$bold(w) arrow.l bold(w) + alpha delta bold(z)$`。

### PDF p.322 「True online TD(λ) for estimating w^⊤x ≈ v_π」框

- 特征函数：`$bold(x) : cal(S)^+ -> bb(R)^d$`，且 `$bold(x)("terminal", dot.op) = bold(0)$`。
- 参数：步长 `$alpha > 0$`、迹衰减率 `$lambda in [0, 1]$`。
- 初始化：`$bold(w) in bb(R)^d$`（例如 `$bold(w) = bold(0)$`）；`$bold(z) arrow.l bold(0)$`；临时标量 `$V_"old" arrow.l 0$`。
- 动作选择：`$A tilde pi$`。
- 状态值与后继状态值：`$V arrow.l bold(w)^top bold(x)$`；`$V' arrow.l bold(w)^top bold(x)'$`。
- TD 误差：`$delta arrow.l R + gamma V' - V$`。
- 轨迹更新：`$bold(z) arrow.l gamma lambda bold(z) + (1 - alpha gamma lambda bold(z)^top bold(x)) bold(x)$`。
- 权重更新：`$bold(w) arrow.l bold(w) + alpha (delta + V - V_"old") bold(z) - alpha (V - V_"old") bold(x)$`。
- 收尾赋值：`$V_"old" arrow.l V'$`；`$bold(x) arrow.l bold(x)'$`。
- 终止条件：`$bold(x)' = bold(0)$`，表示到达终止状态。

### PDF p.327 「Sarsa(λ) with binary features and linear function approximation for estimating w^⊤x ≈ q_π or q_*」框

- 活动特征函数：`$cal(F)(s, a)$`，返回 $(s, a)$ 的全部活动特征下标。
- 参数：步长 `$alpha > 0$`、迹衰减率 `$lambda in [0, 1]$`、小常数 `$epsilon > 0$`。
- 初始化：`$bold(w) = (w_1, dots, w_d)^top in bb(R)^d$`（例如 `$bold(w) = bold(0)$`）；`$bold(z) = (z_1, dots, z_d)^top in bb(R)^d$`。
- 动作选择：`$A tilde pi (dot.op | S)$`，或者按 `$hat(q)(S, dot.op, bold(w))$` 取 `$epsilon$`-greedy。
- 轨迹清零：`$bold(z) arrow.l bold(0)$`。
- 误差起点：`$delta arrow.l R$`。
- 对每个活动特征：`$i in cal(F)(S, A)$`，`$delta arrow.l delta - w_i$`。
- 轨迹分量：累积式 `$z_i arrow.l z_i + 1$`；替换式 `$z_i arrow.l 1$`。
- 终止分支的权重更新：`$bold(w) arrow.l bold(w) + alpha delta bold(z)$`。
- 后继动作选择：`$A' tilde pi (dot.op | S')$`，或者按 `$hat(q)(S', dot.op, bold(w))$` 取 `$epsilon$`-greedy。
- 后继特征循环：`$i in cal(F)(S', A')$`，`$delta arrow.l delta + gamma w_i$`。
- 权重更新与轨迹衰减：`$bold(w) arrow.l bold(w) + alpha delta bold(z)$`；`$bold(z) arrow.l gamma lambda bold(z)$`。
- 状态与动作推进：`$S arrow.l S'$`；`$A arrow.l A'$`。

### PDF p.329 「True online Sarsa(λ) for estimating w^⊤x ≈ q_π or q_*」框

- 特征函数：`$bold(x) : cal(S)^+ times cal(A) -> bb(R)^d$`，且 `$bold(x)("terminal", dot.op) = bold(0)$`。
- 参数：步长 `$alpha > 0$`、迹衰减率 `$lambda in [0, 1]$`、小常数 `$epsilon > 0$`。
- 初始化：`$bold(w) in bb(R)^d$`（例如 `$bold(w) = bold(0)$`）；`$bold(x) arrow.l bold(x)(S, A)$`；`$bold(z) arrow.l bold(0)$`；`$Q_"old" arrow.l 0$`。
- 动作选择：`$A tilde pi (dot.op | S)$`，或者按 `$hat(q)(S, dot.op, bold(w))$` 取 `$epsilon$`-greedy；后继 `$A' tilde pi (dot.op | S')$`，或者按 `$hat(q)(S', dot.op, bold(w))$` 取 `$epsilon$`-greedy。
- 后继特征：`$bold(x)' arrow.l bold(x)(S', A')$`。
- 动作值与后继动作值：`$Q arrow.l bold(w)^top bold(x)$`；`$Q' arrow.l bold(w)^top bold(x)'$`。
- TD 误差：`$delta arrow.l R + gamma Q' - Q$`。
- 轨迹更新：`$bold(z) arrow.l gamma lambda bold(z) + (1 - alpha gamma lambda bold(z)^top bold(x)) bold(x)$`。
- 权重更新：`$bold(w) arrow.l bold(w) + alpha (delta + Q - Q_"old") bold(z) - alpha (Q - Q_"old") bold(x)$`。
- 收尾赋值：`$Q_"old" arrow.l Q'$`；`$bold(x) arrow.l bold(x)'$`；`$A arrow.l A'$`。

## 行内公式

只收录有结构或者容易写错的行内式，常见记号（`alpha`、`gamma`、`lambda`、`delta`、`bold(w)`、`bold(z)`、`hat(v)`、`hat(q)`、`S_t`、`R_(t+1)` 等）的写法见 `glossary/notation.typ`，不逐处重复。

### PDF p.309

- `$bold(z)_t in bb(R)^d$`、`$bold(w)_t in bb(R)^d$`：迹向量与权重向量的取值空间。
- `$lambda = 0$`、`$lambda = 1$`、`$lambda in [0, 1]$`：迹参数的两个端点取值与取值范围。

### PDF p.310

- `$frac(1, 2) G_(t:t+2) + frac(1, 2) G_(t:t+4)$`：两步回报与四步回报各取一半的平均目标。

### PDF p.311

- `$1 - lambda$`、`$(1 - lambda) lambda$`、`$(1 - lambda) lambda^2$`：一步、两步、三步回报在 `$lambda$`-回报里的权重。
- `$lambda^(n-1)$`、`$lambda^(T-t-1)$`：权重随步数递减的因子与末项的衰减因子。

### PDF p.314

- `$bold(z)_t in bb(R)^d$`：函数逼近下轨迹是 `$d$` 维实向量。

### PDF p.316

- `$gamma^k$`：回报中第 `$k$` 步奖励的折扣因子。

### PDF p.317

- `$frac(1 - gamma lambda, 1 - gamma)$`：渐近误差至多是可能的最小误差的倍数（(12.8) 的系数）。

### PDF p.320

- `$bold(w)_t ≐ bold(w)_t^t$`：在线 λ-return 算法把对角线上的权重向量重命名后的记号。

### PDF p.322

- `$O(d)$`：真在线 TD(λ) 每步的计算复杂度。
- `$hat(v)(s, bold(w)) = bold(w)^top bold(x)(s)$`：走到真在线 TD(λ) 算法的线性情形条件。
- `$bold(w)_t ≐ bold(w)_t^t$`：把原论文里的上标版本重命名为不带上标的形式。
- `$bold(x)_t ≐ bold(x)(S_t)$`：特征向量的简写。
- `$0 <= t <= T$`：时间步的取值范围。

### PDF p.324

- `$O(d)$`：dutch trace 每步的计算复杂度（不需要知道 `$G$`）。
- `$bold(z)_0 = bold(x)_0$`：dutch trace 的初值。
- `$bold(a)_0 = bold(w)_0$`：辅助权重向量的初值（对 (12.11) 的指代处）。

### PDF p.325

- `$O(d)$`：Sarsa(λ) 的每步计算复杂度。
- `$G_t^lambda ≐ G_(t:oo)^lambda$`：无限项 `$lambda$`-回报的简写。
- `$G_(t:t+n) ≐ G_t quad "if" t + n >= T$`：截断回报越过终止时刻时的取值。

### PDF p.330

- `$product_(k=t)^oo gamma_k = 0$`：为保证和式有限而要求连乘收敛于零（正文行内，大写 Π 带上下限排在右侧）。
- `$gamma_t$`、`$nabla hat(v)(S_t, bold(w)_t)$`：状态相关折扣与函数逼近的记号（(12.17) 前的引入句）。

### PDF p.331

- `$rho_t = frac(pi (A_t|S_t), b(A_t|S_t))$`：单步重要性采样比。

### PDF p.334

- `$lambda < 1$`、`$lambda = 1$`：PTD(λ) 与 PQ(λ) 讨论中的两端取值。

### PDF p.336

- `$hat(v)(s, bold(w)) ≐ bold(w)_t^top bold(x)(s) approx v_pi (s)$`：GTD(λ) 的学习目标。

### PDF p.337

- `$delta_t^a$`：对 (12.28) 所指的期望形式动作值 TD 误差的引用。
- `$bold(v) in bb(R)^d$`、`$bold(v)_0 = bold(0)$`、`$beta > 0$`：辅助权重向量及其初值与第二个步长参数。
- `$bold(x)_t$`：与 (12.30) 一起出现的特征向量记号。

### PDF p.338

- `$M_t >= 0$`、`$F_t >= 0$`、`$I_t >= 0$`：emphasis 的一般形式、followon trace 与 interest 的取值范围（正文均为斜体，非粗体）。
- `$i(S_0)$`：初始兴趣。
