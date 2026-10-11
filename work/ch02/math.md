# 第 2 章公式（Multi-armed Bandits，PDF 47–68）

全部公式对照 `work/pages/pNNNN.png` 页面渲染图逐条重建，未参考文字层的数学片段。

代码即 Typst 数学代码。块级公式写成 `$ ... $`（两侧留空格），行内公式写成 `$...$`；章文件里直接照抄即可。原书带编号的公式在代码之后给出标签，编号由模板生成。原书中不编号的展示公式按其在页面上的先后记为 `(unnumbered pNN-k)`，与 `source.md` 的占位符一一对应。

三条写法约定：

- 下标是单独一个标识符或符号，后面紧跟 `(` 或 `[` 时，中间必须留一个空格：写 `Q_t (a)`、`q_* (a)`、`pi_t (A_t)`、`N_t (a)`、`sum_x (q_* (x) - B_t)`。不留空格时 Typst 把括号吞进下标，`Q_t(a)` 会渲染成下标为 `t(a)` 的 `Q`，编译不报错，肉眼容易看漏。加了空格没有副作用。
- `argmax` 不是 Typst 内置算子，写成 `op("argmax", limits: #true)`，下标才能排在单词下方，与原书一致。
- 原书用斜杠表示的行内除法（如 `α/ō_n`）写成 `slash`；表示分式的场合一律用 `frac()`。

## (unnumbered p48-1)   PDF p.48

```typst
$ q_* (a) ≐ bb(E)[R_t | A_t = a] . $
```

## (2.1)   PDF p.49

```typst
$ Q_t (a) ≐ frac("sum of rewards when " a " taken prior to " t, "number of times " a " taken prior to " t) = frac(sum_(i=1)^(t-1) R_i dot bb(1)_(A_i = a), sum_(i=1)^(t-1) bb(1)_(A_i = a)), $ <eq-2-1>
```

## (2.2)   PDF p.49

```typst
$ A_t ≐ op("argmax", limits: #true)_a Q_t (a), $ <eq-2-2>
```

## (unnumbered p53-1)   PDF p.53

```typst
$ Q_n ≐ frac(R_1 + R_2 + dots.c + R_(n-1), n - 1) . $
```

## (2.3)   PDF p.53

```typst
$ Q_(n+1) &= 1/n sum_(i=1)^n R_i \
          &= 1/n (R_n + sum_(i=1)^(n-1) R_i) \
          &= 1/n (R_n + (n-1) frac(1, n-1) sum_(i=1)^(n-1) R_i) \
          &= 1/n (R_n + (n-1) Q_n) \
          &= 1/n (R_n + n Q_n - Q_n) \
          &= Q_n + 1/n [R_n - Q_n], $ <eq-2-3>
```

## (2.4)   PDF p.53

```typst
$ italic("NewEstimate") arrow.l italic("OldEstimate") + italic("StepSize") [italic("Target") - italic("OldEstimate")] . $ <eq-2-4>
```

## (2.5)   PDF p.54

```typst
$ Q_(n+1) ≐ Q_n + alpha [R_n - Q_n], $ <eq-2-5>
```

## (2.6)   PDF p.54

```typst
$ Q_(n+1) &= Q_n + alpha [R_n - Q_n] \
          &= alpha R_n + (1 - alpha) Q_n \
          &= alpha R_n + (1 - alpha) [alpha R_(n-1) + (1 - alpha) Q_(n-1)] \
          &= alpha R_n + (1 - alpha) alpha R_(n-1) + (1 - alpha)^2 Q_(n-1) \
          &= alpha R_n + (1 - alpha) alpha R_(n-1) + (1 - alpha)^2 alpha R_(n-2) + \
           &quad dots.c + (1 - alpha)^(n-1) alpha R_1 + (1 - alpha)^n Q_1 \
          &= (1 - alpha)^n Q_1 + sum_(i=1)^n alpha (1 - alpha)^(n-i) R_i. $ <eq-2-6>
```

## (2.7)   PDF p.55

```typst
$ sum_(n=1)^infinity alpha_n (a) = infinity quad "and" quad sum_(n=1)^infinity alpha_n^2 (a) < infinity. $ <eq-2-7>
```

## (2.8)   PDF p.57

```typst
$ beta_n ≐ alpha slash overline(o)_n, $ <eq-2-8>
```

## (2.9)   PDF p.57

```typst
$ overline(o)_n ≐ overline(o)_(n-1) + alpha (1 - overline(o)_(n-1)), quad "for " n > 0, quad "with " overline(o)_0 ≐ 0. $ <eq-2-9>
```

## (2.10)   PDF p.57

```typst
$ A_t ≐ op("argmax", limits: #true)_a [Q_t (a) + c sqrt(frac(ln t, N_t (a)))], $ <eq-2-10>
```

## (2.11)   PDF p.59

```typst
$ "Pr"{A_t = a} ≐ frac(e^(H_t (a)), sum_(b=1)^k e^(H_t (b))) ≐ pi_t (a), $ <eq-2-11>
```

## (2.12)   PDF p.59

```typst
$ H_(t+1)(A_t) ≐ H_t (A_t) + alpha (R_t - overline(R)_t)(1 - pi_t (A_t)), &quad "and" \
  H_(t+1)(a) ≐ H_t (a) - alpha (R_t - overline(R)_t) pi_t (a), &quad "for all " a != A_t, $ <eq-2-12>
```

## (2.13)   PDF p.60

```typst
$ H_(t+1)(a) ≐ H_t (a) + alpha frac(partial bb(E)[R_t], partial H_t (a)), $ <eq-2-13>
```

## (unnumbered p60-1)   PDF p.60

```typst
$ bb(E)[R_t] = sum_x pi_t (x) q_* (x), $
```

## (unnumbered p61-1)   PDF p.61

```typst
$ frac(partial bb(E)[R_t], partial H_t (a)) &= frac(partial, partial H_t (a)) [sum_x pi_t (x) q_* (x)] \
  &= sum_x q_* (x) frac(partial pi_t (x), partial H_t (a)) \
  &= sum_x (q_* (x) - B_t) frac(partial pi_t (x), partial H_t (a)), $
```

## (unnumbered p61-2)   PDF p.61

```typst
$ frac(partial bb(E)[R_t], partial H_t (a)) = sum_x pi_t (x)(q_* (x) - B_t) frac(partial pi_t (x), partial H_t (a)) slash pi_t (x). $
```

## (unnumbered p61-3)   PDF p.61

```typst
$ = bb(E)[(q_* (A_t) - B_t) frac(partial pi_t (A_t), partial H_t (a)) slash pi_t (A_t)] \
  = bb(E)[(R_t - overline(R)_t) frac(partial pi_t (A_t), partial H_t (a)) slash pi_t (A_t)], $
```

## (unnumbered p61-4)   PDF p.61

```typst
$ = bb(E)[(R_t - overline(R)_t) pi_t (A_t)(bb(1)_(a=A_t) - pi_t (a)) slash pi_t (A_t)] \
  = bb(E)[(R_t - overline(R)_t)(bb(1)_(a=A_t) - pi_t (a))]. $
```

## (unnumbered p61-5)   PDF p.61

```typst
$ H_(t+1)(a) = H_t (a) + alpha (R_t - overline(R)_t)(bb(1)_(a=A_t) - pi_t (a)), quad "for all " a, $
```

## (unnumbered p62-1)   PDF p.62

```typst
$ frac(partial, partial x) [frac(f(x), g(x))] = frac(frac(partial f(x), partial x) g(x) - f(x) frac(partial g(x), partial x), g(x)^2). $
```

## (unnumbered p62-2)   PDF p.62

```typst
$ frac(partial pi_t (x), partial H_t (a)) &= frac(partial, partial H_t (a)) pi_t (x) \
  &= frac(partial, partial H_t (a)) [frac(e^(H_t (x)), sum_(y=1)^k e^(H_t (y)))] \
  &= frac(frac(partial e^(H_t (x)), partial H_t (a)) sum_(y=1)^k e^(H_t (y)) - e^(H_t (x)) frac(partial sum_(y=1)^k e^(H_t (y)), partial H_t (a)), (sum_(y=1)^k e^(H_t (y)))^2) &quad "(by the quotient rule)" \
  &= frac(bb(1)_(a=x) e^(H_t (x)) sum_(y=1)^k e^(H_t (y)) - e^(H_t (x)) e^(H_t (a)), (sum_(y=1)^k e^(H_t (y)))^2) &quad "(because " frac(partial e^x, partial x) = e^x ")" \
  &= frac(bb(1)_(a=x) e^(H_t (x)), sum_(y=1)^k e^(H_t (y))) - frac(e^(H_t (x)) e^(H_t (a)), (sum_(y=1)^k e^(H_t (y)))^2) \
  &= bb(1)_(a=x) pi_t (x) - pi_t (x) pi_t (a) \
  &= pi_t (x)(bb(1)_(a=x) - pi_t (a)). quad "Q.E.D." $
```

## 行内公式

只收录有结构或者容易写错的行内式。单字母变量与 `Q_t (a)`、`q_* (a)` 这类符号贯穿全章，写法见 `glossary/notation.typ`，不逐处重复；练习中成串出现的数值赋值（如练习 2.2 的 `$A_1 = 1$`、`$R_1 = -1$` 一直到 `$R_5 = 0$`）按同一写法处理。

### PDF p.48

- `$A_t$`、`$R_t$`：时间步 *t* 上选中的动作与对应的奖励。
- `$q_* (a)$`：动作 *a* 的值。
- `$Q_t (a)$`：动作 *a* 在时间步 *t* 的估计值。

### PDF p.49

- `$bb(1)_"predicate"$`：指示随机变量，*predicate* 为真时取 1，否则取 0。
- `$op("argmax", limits: #true)_a$`：使后面表达式取最大值的动作 *a*。

### PDF p.50

- `$1 - epsilon$`：ε-greedy 方法选择最优动作的概率收敛到大于 1 − ε。

### PDF p.51

- `$k = 10$`：10 臂测试平台的动作数。
- `$a = 1, dots, 10$`：动作编号。
- `$q_* (A_t)$`：奖励所服从正态分布的均值。

### PDF p.54

- `$1/n$`：处理第 *n* 个奖励时所用的步长参数。
- `$alpha_t (a)$`：一般的步长参数写法。
- `$alpha in (0, 1]$`：常数步长参数的取值范围。

### PDF p.55

- `$(1 - alpha)^n + sum_(i=1)^n alpha (1 - alpha)^(n-i) = 1$`：权重之和为 1。
- `$alpha (1 - alpha)^(n-i)$`：赋予奖励 *R_i* 的权重。
- `$n - i$`：奖励被观测到的时间距今多少步。
- `$1 - alpha$`：小于 1 的折扣因子。
- `$0^0 = 1$`：约定，用于 *1 − α = 0* 的情形。
- `$alpha_n (a)$`：处理动作 *a* 第 *n* 次被选中后所收到奖励时使用的步长参数。
- `$alpha_n (a) = 1/n$`：样本平均法对应的步长序列。
- `${alpha_n (a)}$`：步长参数序列。
- `$alpha_n (a) = alpha$`：常数步长参数的情形。

### PDF p.56

- `$Q_1 (a)$`：初始动作值估计。
- `$Q_1 (a) = +5$`：乐观初始值。
- `$alpha = 0.1$`：图 2.3 中两方法所用的常数步长参数。

### PDF p.57

- `$alpha > 0$`：练习 2.7 中的常数步长。
- `$overline(o)_n$`：练习 2.7 中从 0 开始的迹。

### PDF p.58

- `$ln t$`：*t* 的自然对数。
- `$e approx 2.71828$`：自然对数的底。
- `$N_t (a)$`：动作 *a* 在时间步 *t* 之前被选中的次数。
- `$N_t (a) = 0$`：此时 *a* 视为最大化动作。
- `$c > 0$`：控制探索程度的常数。

### PDF p.59

- `$H_t (a) in bb(R)$`：动作 *a* 的数值偏好。
- `$H_1 (a) = 0$`：所有动作的初始偏好相同。
- `$pi_t (a)$`：时间步 *t* 采取动作 *a* 的概率。
- `$alpha > 0$`：步长参数。
- `$overline(R)_t in bb(R)$`：截至时间步 *t*（不含）的奖励平均值。
- `$overline(R)_1 ≐ R_1$`：基线的初始值。

### PDF p.60

- `$1000$`：偏好整体加 1000 不影响动作概率。
- `$q_* (x)$`：精确梯度上升需要但无法知道的量。
- `$frac(partial bb(E)[R_t], partial H_t (a))$`：性能测度对动作偏好的偏导。

### PDF p.61

- `$B_t$`：基线。
- `$sum_x frac(partial pi_t (x), partial H_t (a)) = 0$`：梯度对所有动作求和为零。
- `$B_t = overline(R)_t$`：所选取的基线。
- `$bb(E)[R_t | A_t] = q_* (A_t)$`：可用 *R_t* 代替 `$q_* (A_t)$` 的依据。
- `$frac(partial pi_t (x), partial H_t (a)) = pi_t (x)(bb(1)_(a=x) - pi_t (a))$`：偏导的展开式。
- `$bb(1)_(a=x)$`：*a = x* 时为 1，否则为 0。

### PDF p.62

- `$frac(partial pi_t (x), partial H_t (a)) = pi_t (x)(bb(1)_(a=x) - pi_t (a))$`：待证的等式。
- `$1000$`：基线取零或取 1000 都不影响算法的期望更新。

### PDF p.65

- `$2^2000$`：两个动作、两个奖励时，可能性之树的叶子数。

### PDF p.66

- `$alpha = 0.1$`：练习 2.11 中常数步长的 ε-greedy 算法所用的步长。
