# 第 5 章公式（Monte Carlo Methods，PDF 113–139）

全部公式对照 `work/pages/pNNNN.png` 页面渲染图逐条重建，未参考文字层的数学片段。

代码即 Typst 数学代码。块级公式写成 `$ ... $`（两侧留空格），行内公式写成 `$...$`；章文件里直接照抄即可。原书带编号的公式在代码之后给出标签，编号由模板生成。原书中不编号的展示公式按其在页面上的先后记为 `(unnumbered pNN-k)`，与 `source.md` 的占位符一一对应；伪代码框内的公式单列一节。

六条写法约定：

- 下标是单独一个标识符或符号，后面紧跟 `(` 或 `[` 时，中间必须留一个空格：写 `q_pi (s, a)`、`v_pi (s)`、`tilde(v)_* (s)`、`tilde(q)_* (s, a)`、`bb(E)[G_t]`。不留空格时 Typst 把括号吞进下标，编译不报错，肉眼容易看漏。下标是括号组（`rho_(t:T-1)`、`overline(G)_(t:h)`、`G_(t+1)`）时不受影响。
- `argmax` 不是 Typst 内置算子，写成 `op("argmax", limits: #true)`，下标才能排在单词下方，与原书一致。`max_a`、`sum_(s', r)`、`product_(k=t)^(T-1)` 直接用裸写法即可，Typst 在块级公式里把上下限排在符号下方、在行内公式里排在符号右侧，与原书的排版选择恰好相同。例外是 (5.9) 与 (5.10) 里的内层求和：原书排成小型求和号、上下限排在右侧，写成 `op("∑", limits: #false)_(h=t+1)^(T(t)-1)`。
- 集合记号 S、A、R 在原书里是花体，写成 `cal(S)`、`cal(A)`、`cal(R)`；实数集写成 `bb(R)`。期望是空心粗体 E，写成 `bb(E)`。定义为的符号直接写 `≐`。本章的 `cal(T)(s)` 是状态 *s* 的访问时间步集合（花体 T），*T*(*t*) 是终止时刻（斜体 T），两者是不同的符号，分别写 `cal(T)(s)` 与 `T(t)`。
- 重要性采样比写 `rho_(t:T-1)`。上划线写成 `overline(...)`：平坦部分回报与截断回报是 `overline(G)_(t:h)`、`overline(G)_(t:T(t))`，均值的上划线是 `overline(X)`；不要用 `bar(...)`，Typst 的 `bar` 渲染成竖线包夹，与上划线不同。波浪号记号写成 `tilde(G)_t`、`tilde(v)_*`、`tilde(q)_*`，条件竖线后的波浪号策略记号写成 `tilde.op pi`。轨迹概率里的 `Pr` 是直立体，写成 `Pr{...}`。
- 分式一律写成 `frac(...)`。正文行内的 ε/|𝒜(s)| 在原书里也是小型上下分式，写成 `frac(epsilon, |cal(A)(s)|)`，不要写成 `epsilon slash |cal(A)(s)|`（第 4 章的斜杠约定只适用于那一章的行内式）。乘法点号写成 `dot.op`。
- 伪代码框里的词用引号字符串排直立体：`"average"`、`"an empty list"`、`"any policy with coverage of"`、`"any soft policy"`、`"if"`；斜体的 `Returns` 写成 `italic("Returns")`。赋值箭头写成 `arrow.l`。

## (unnumbered p119-1)   PDF p.119

策略迭代产生的策略与动作值函数交替序列。箭头是长右箭头，字母 E（完整策略评估）与 I（完整策略改进）排在箭头上方；链中的省略号是横向居中省略号，写成 `dots.h.c`。

```typst
$ pi_0 arrow.r.long^"E" q_(pi_0) arrow.r.long^"I" pi_1 arrow.r.long^"E" q_(pi_1) arrow.r.long^"I" pi_2 arrow.r.long^"E" dots.h.c arrow.r.long^"I" pi_* arrow.r.long^"E" q_*, $
```

## (5.1)   PDF p.119

```typst
$ pi (s) ≐ op("argmax", limits: #true)_a q(s, a). $ <eq-5-1>
```

## (unnumbered p120-1)   PDF p.120

四行对齐展示，前两行用等号，后两行用 `>=`；第二行的 `argmax` 下标排在单词下方。

```typst
$ q_(pi_k) (s, pi_(k+1) (s)) &= q_(pi_k) (s, op("argmax", limits: #true)_a q_(pi_k) (s, a)) \
                            &= max_a q_(pi_k) (s, a) \
                            &>= q_(pi_k) (s, pi_k (s)) \
                            &>= v_(pi_k) (s). $
```

## (5.2)   PDF p.123–124

五行对齐展示：前两行用等号，第三行用 `>=`，第四行把第三行的加权平均展开，第五行得到 `v_pi (s)`。原书把这一条排在两页上：第 1–3 行在第 101 页，编号 (5.2) 排在第 2 行右侧；第 3 行之后插进一句括注（“这个求和是一个加权平均，权重非负且和为 1，因此它必然小于或等于被平均的那些数中最大的一个”），第 4、5 行接在括注之后，排在第 102 页顶端，不再带编号。第三行的分式分子是 `pi (a|s) - frac(epsilon, |cal(A)(s)|)`。

```typst
$ q_pi (s, pi' (s)) &= sum_a pi' (a|s) q_pi (s, a) \
                    &= frac(epsilon, |cal(A)(s)|) sum_a q_pi (s, a) + (1 - epsilon) max_a q_pi (s, a) \
                    &>= frac(epsilon, |cal(A)(s)|) sum_a q_pi (s, a) + (1 - epsilon) sum_a frac(pi (a|s) - frac(epsilon, |cal(A)(s)|), 1 - epsilon) q_pi (s, a) \
                    &= frac(epsilon, |cal(A)(s)|) sum_a q_pi (s, a) - frac(epsilon, |cal(A)(s)|) sum_a q_pi (s, a) + sum_a pi (a|s) q_pi (s, a) \
                    &= v_pi (s). $ <eq-5-2>
```

## (unnumbered p124-1)   PDF p.124

三行对齐展示，第三行以 `&quad +` 缩进续接。

```typst
$ tilde(v)_* (s) &= max_a sum_(s', r) [(1 - epsilon) p(s', r | s, a) + sum_(a') frac(epsilon, |cal(A)(s)|) p(s', r | s, a')] [r + gamma tilde(v)_* (s')] \
                 &= (1 - epsilon) max_a sum_(s', r) p(s', r | s, a) [r + gamma tilde(v)_* (s')] \
                 &quad + frac(epsilon, |cal(A)(s)|) sum_a sum_(s', r) p(s', r | s, a) [r + gamma tilde(v)_* (s')]. $
```

## (unnumbered p124-2)   PDF p.124

三行对齐展示，对应 `source.md` 里 “from (5.2)” 之后那个占位符：第一行把 `v_pi (s)` 写成 (§5.2) 中 `q_pi (s, a)` 的加权形式，第二行与第三行把 `q_pi` 展开成四参数函数 `p` 的形式，第三行以 `+` 号缩进续接。第二、三行的右端与上一条 `tilde(v)_*` 的相应行逐项对应，只是 `tilde(v)_*` 换成了 `v_pi`。

```typst
$ v_pi (s) &= (1 - epsilon) max_a q_pi (s, a) + frac(epsilon, |cal(A)(s)|) sum_a q_pi (s, a) \
           &= (1 - epsilon) max_a sum_(s', r) p(s', r | s, a) [r + gamma v_pi (s')] \
           &quad + frac(epsilon, |cal(A)(s)|) sum_a sum_(s', r) p(s', r | s, a) [r + gamma v_pi (s')]. $
```

## (unnumbered p126-1)   PDF p.126

三行对齐展示：轨迹概率、按逐步概率展开、写成连乘。`Pr` 是直立体，条件竖线后的策略记号是波浪号。

```typst
$ Pr{A_t, S_(t+1), A_(t+1), dots.c, S_T | S_t, A_(t:T-1) tilde.op pi} \
  &= pi (A_t|S_t) p(S_(t+1)|S_t, A_t) pi (A_(t+1)|S_(t+1)) dots.c p(S_T|S_(T-1), A_(T-1)) \
  &= product_(k=t)^(T-1) pi (A_k|S_k) p(S_(k+1)|S_k, A_k), $
```

## (5.3)   PDF p.126

单行展示，等号左边是两个 ∏ 分式之比，等号右边化简为连乘的 π/b 分式。

```typst
$ rho_(t:T-1) ≐ frac(product_(k=t)^(T-1) pi (A_k|S_k) p(S_(k+1)|S_k, A_k), product_(k=t)^(T-1) b(A_k|S_k) p(S_(k+1)|S_k, A_k)) = product_(k=t)^(T-1) frac(pi (A_k|S_k), b(A_k|S_k)). $ <eq-5-3>
```

## (5.4)   PDF p.126

```typst
$ bb(E)[rho_(t:T-1) G_t | S_t = s] = v_pi (s). $ <eq-5-4>
```

## (5.5)   PDF p.126

普通重要性采样的估计式，单行展示，行末句号。

```typst
$ V(s) ≐ frac(sum_(t in cal(T)(s)) rho_(t:T(t)-1) G_t, |cal(T)(s)|). $ <eq-5-5>
```

## (5.6)   PDF p.127

加权重要性采样的估计式，单行展示，行末逗号。

```typst
$ V(s) ≐ frac(sum_(t in cal(T)(s)) rho_(t:T(t)-1) G_t, sum_(t in cal(T)(s)) rho_(t:T(t)-1)), $ <eq-5-6>
```

## (unnumbered p129-1)   PDF p.129

单行展示，方差的定义与逐步展开，三个等号连写。

```typst
$ op("Var") [X] ≐ bb(E)[(X - overline(X))^2] = bb(E)[X^2 - 2X overline(X) + overline(X)^2] = bb(E)[X^2] - overline(X)^2. $
```

## (unnumbered p130-1)   PDF p.130

```typst
$ bb(E)[(product_(t=0)^(T-1) frac(pi (A_t|S_t), b(A_t|S_t)) G_0)^2]. $
```

## (unnumbered p130-2)   PDF p.130

五行对齐展示，是上一条的展开：前三行是长度为 1、2、3 的剧集各自的贡献，每行右端注 `"(the length N episode)"`；第四行是省略号；最后一行求极限，发散为 `infinity`。

```typst
$ &= frac(1, 2) dot.op 0.1 (frac(1, 0.5))^2 &quad "(the length 1 episode)" \
  &quad + frac(1, 2) dot.op 0.9 dot.op frac(1, 2) dot.op 0.1 (frac(1, 0.5) frac(1, 0.5))^2 &quad "(the length 2 episode)" \
  &quad + frac(1, 2) dot.op 0.9 dot.op frac(1, 2) dot.op 0.9 dot.op frac(1, 2) dot.op 0.1 (frac(1, 0.5) frac(1, 0.5) frac(1, 0.5))^2 &quad "(the length 3 episode)" \
  &quad + dots.c \
  &= 0.1 sum_(k=0)^infinity 0.9^k dot.op 2^k dot.op 2 = 0.2 sum_(k=0)^infinity 1.8^k = infinity. $
```

## (5.7)   PDF p.131

单行展示，行末是条件 `n >= 2` 与逗号。

```typst
$ V_n ≐ frac(sum_(k=1)^(n-1) W_k G_k, sum_(k=1)^(n-1) W_k), quad n >= 2, $ <eq-5-7>
```

## (5.8)   PDF p.131

单行展示，行末是条件 `n >= 1` 与逗号。

```typst
$ V_(n+1) ≐ V_n + frac(W_n, C_n) [G_n - V_n], quad n >= 1, $ <eq-5-8>
```

## (unnumbered p131-1)   PDF p.131

```typst
$ C_(n+1) ≐ C_n + W_(n+1), $
```

## (unnumbered p135-1)   PDF p.135

单行展示，平坦部分回报的定义，行末是条件 `0 <= t < h <= T` 与逗号；`overline(G)_(t:h)` 的上划线写在 `overline(...)` 里。

```typst
$ overline(G)_(t:h) ≐ R_(t+1) + R_(t+2) + dots.c + R_h, quad 0 <= t < h <= T, $
```

## (unnumbered p135-2)   PDF p.135

八行对齐展示：第一行是 *G_t* 的展开，第二行起把它改写成按终止程度加权的部分回报之和，中间以竖直省略号跳过，倒数两行分别到 `R_(T-1)` 与 `R_T`，最后一行用上一行定义的平坦部分回报写成紧凑形式。

```typst
$ G_t &≐ R_(t+1) + gamma R_(t+2) + gamma^2 R_(t+3) + dots.c + gamma^(T-t-1) R_T \
      &= (1 - gamma) R_(t+1) \
      &quad + (1 - gamma) gamma (R_(t+1) + R_(t+2)) \
      &quad + (1 - gamma) gamma^2 (R_(t+1) + R_(t+2) + R_(t+3)) \
      &quad dots.v \
      &quad + (1 - gamma) gamma^(T-t-2) (R_(t+1) + R_(t+2) + dots.c + R_(T-1)) \
      &quad + gamma^(T-t-1) (R_(t+1) + R_(t+2) + dots.c + R_T) \
      &= (1 - gamma) sum_(h=t+1)^(T-1) gamma^(h-t-1) overline(G)_(t:h) + gamma^(T-t-1) overline(G)_(t:T). $
```

## (5.9)   PDF p.135

单行展示，普通重要性采样的打折感知估计式。括号里的内层求和是小型求和号，上下限排在右侧（`op("∑", limits: #false)`），与原书一致。

```typst
$ V(s) ≐ frac(sum_(t in cal(T)(s)) ((1 - gamma) op("∑", limits: #false)_(h=t+1)^(T(t)-1) gamma^(h-t-1) rho_(t:h-1) overline(G)_(t:h) + gamma^(T(t)-t-1) rho_(t:T(t)-1) overline(G)_(t:T(t))), |cal(T)(s)|), $ <eq-5-9>
```

## (5.10)   PDF p.135

单行展示，加权版本：分母是同形式子的权重之和。内层求和与上一条写法相同。

```typst
$ V(s) ≐ frac(sum_(t in cal(T)(s)) ((1 - gamma) op("∑", limits: #false)_(h=t+1)^(T(t)-1) gamma^(h-t-1) rho_(t:h-1) overline(G)_(t:h) + gamma^(T(t)-t-1) rho_(t:T(t)-1) overline(G)_(t:T(t))), sum_(t in cal(T)(s)) ((1 - gamma) op("∑", limits: #false)_(h=t+1)^(T(t)-1) gamma^(h-t-1) rho_(t:h-1) + gamma^(T(t)-t-1) rho_(t:T(t)-1))). $ <eq-5-10>
```

## (5.11)   PDF p.136

两行对齐展示。

```typst
$ rho_(t:T-1) G_t &= rho_(t:T-1) (R_(t+1) + gamma R_(t+2) + dots.c + gamma^(T-t-1) R_T) \
                  &= rho_(t:T-1) R_(t+1) + gamma rho_(t:T-1) R_(t+2) + dots.c + gamma^(T-t-1) rho_(t:T-1) R_T. $ <eq-5-11>
```

## (5.12)   PDF p.136

单行展示，四个 π/b 分式连乘后再乘 `R_(t+1)`。

```typst
$ rho_(t:T-1) R_(t+1) = frac(pi (A_t|S_t), b(A_t|S_t)) frac(pi (A_(t+1)|S_(t+1)), b(A_(t+1)|S_(t+1))) frac(pi (A_(t+2)|S_(t+2)), b(A_(t+2)|S_(t+2))) dots.c frac(pi (A_(T-1)|S_(T-1)), b(A_(T-1)|S_(T-1))) R_(t+1). $ <eq-5-12>
```

## (5.13)   PDF p.136

```typst
$ bb(E)[frac(pi (A_k|S_k), b(A_k|S_k))] ≐ sum_a b(a|S_k) frac(pi (a|S_k), b(a|S_k)) = sum_a pi (a|S_k) = 1. $ <eq-5-13>
```

## (5.14)   PDF p.136

```typst
$ bb(E)[rho_(t:T-1) R_(t+1)] = bb(E)[rho_(t:t) R_(t+1)]. $ <eq-5-14>
```

## (unnumbered p136-1)   PDF p.136

```typst
$ bb(E)[rho_(t:T-1) R_(t+k)] = bb(E)[rho_(t:t+k-1) R_(t+k)]. $
```

## (unnumbered p136-2)   PDF p.136

单行展示，行末逗号。

```typst
$ bb(E)[rho_(t:T-1) G_t] = bb(E)[tilde(G)_t], $
```

## (unnumbered p136-3)   PDF p.136

```typst
$ tilde(G)_t = rho_(t:t) R_(t+1) + gamma rho_(t:t+1) R_(t+2) + gamma^2 rho_(t:t+2) R_(t+3) + dots.c + gamma^(T-t-1) rho_(t:T-1) R_T. $
```

## (5.15)   PDF p.137

```typst
$ V(s) ≐ frac(sum_(t in cal(T)(s)) tilde(G)_t, |cal(T)(s)|), $ <eq-5-15>
```

## 伪代码框内公式

框内的公式是行内公式（求和号与上下限排在符号右侧，与原书一致），因此写成 `$...$` 而不是 `$ ... $`；它们不带编号，`source.md` 的框里也没有占位符。

### PDF p.114 「First-visit MC prediction」框

- 输入：`$pi$`
- 初始化：`$V(s) in bb(R)$`、`$s in cal(S)$`、`$italic("Returns")(s) arrow.l "an empty list"$`
- 生成的剧集：`$S_0, A_0, R_1, S_1, A_1, R_2, dots.c, S_(T-1), A_(T-1), R_T$`
- 逐步回退：`$t = T-1, T-2, dots.c, 0$`、`$G arrow.l gamma G + R_(t+1)$`
- 首次访问判据：`$S_0, S_1, dots.c, S_(t-1)$`
- 更新：`$V(S_t) arrow.l "average"(italic("Returns")(S_t))$`

### PDF p.121 「Monte Carlo ES (Exploring Starts)」框

- 初始化：`$pi (s) in cal(A)(s)$`、`$Q(s, a) in bb(R)$`、`$italic("Returns")(s, a) arrow.l "empty list"$`
- 每幕起点：`$S_0 in cal(S), quad A_0 in cal(A)(S_0)$`
- 回退：`$G arrow.l gamma G + R_(t+1)$`
- 更新：`$Q(S_t, A_t) arrow.l "average"(italic("Returns")(S_t, A_t))$`
- 策略改进：`$pi (S_t) arrow.l op("argmax", limits: #true)_a Q(S_t, a)$`

### PDF p.123 「On-policy first-visit MC control」框

- 参数与初始化：`$epsilon > 0$`、`$pi arrow.l "an arbitrary" epsilon "-soft policy"$`、`$Q(s, a) in bb(R)$`
- 策略改进：`$A^* arrow.l op("argmax", limits: #true)_a Q(S_t, a)$`
- 逐动作遍历：`$a in cal(A)(S_t)$`
- 两种概率赋值：`$pi (a|S_t) arrow.l 1 - epsilon + frac(epsilon, |cal(A)(S_t)|) quad "if" a = A^*$`、`$pi (a|S_t) arrow.l frac(epsilon, |cal(A)(S_t)|) quad "if" a != A^*$`

### PDF p.132 「Off-policy MC prediction」框

- 初始化：`$Q(s, a) in bb(R)$`、`$C(s, a) arrow.l 0$`
- 行为策略：`$b arrow.l "any policy with coverage of" pi$`
- 循环条件与权重累加：`$W != 0$`、`$C(S_t, A_t) arrow.l C(S_t, A_t) + W$`
- 更新：`$Q(S_t, A_t) arrow.l Q(S_t, A_t) + frac(W, C(S_t, A_t)) [G - Q(S_t, A_t)]$`
- 权重更新：`$W arrow.l W frac(pi (A_t|S_t), b(A_t|S_t))$`

### PDF p.133 「Off-policy MC control」框

- 参数与初始化：`$pi (s) arrow.l op("argmax", limits: #true)_a Q(s, a)$`、`$b arrow.l "any soft policy"$`
- 策略改进与退出判据：`$pi (S_t) arrow.l op("argmax", limits: #true)_a Q(S_t, a)$`、`$A_t != pi (S_t)$`
- 权重更新：`$W arrow.l W frac(1, b(A_t|S_t))$`

## 行内公式

只收录有结构或者容易写错的行内式。单字母变量与 `q_pi (s, a)`、`v_pi (s)`、`tilde(v)_* (s)` 这类贯穿全章的符号，写法见 `glossary/notation.typ`，不逐处重复。

### PDF p.115

- `$1 slash sqrt(n)$`：误差标准差随平均回报数 *n* 的下降速度，斜杠表示除法，写成 `slash`。
- `$+1$`、`$-1$`、`$0$`：黑杰克胜、负、平局三种结局的奖励。
- `$gamma = 1$`：黑杰克不折扣。

### PDF p.119

- `$arrow.r.long^"E"$`、`$arrow.r.long^"I"$`：完整策略评估与完整策略改进的箭头记号，字母排在箭头上方。
- `$q_(pi_k)$`：第 *k* 轮迭代的动作值函数。

### PDF p.122

- `$pi (a|s) > 0$`：软策略的定义条件，对全部 `$s in cal(S)$` 与 `$a in cal(A)(s)$` 成立。
- `$frac(epsilon, |cal(A)(s)|)$`：非贪心动作的概率下界。正文中的 ε/|𝒜(s)| 在原书是小型上下分式，写成 `frac(epsilon, |cal(A)(s)|)`；第 4 章同类表达式的 `slash` 写法不适用于本章。
- `$1 - epsilon + frac(epsilon, |cal(A)(s)|)$`：ε-贪心策略给贪心动作的概率。
- `$pi (a|s) >= frac(epsilon, |cal(A)(s)|)$`：ε-soft 策略的定义。
- `$epsilon > 0$`：ε-soft 策略的参数条件。

### PDF p.123

- `$pi'$`：改进后的 ε-贪心策略。
- `$pi' >= pi$`：策略改进定理的结论，展开为 `$v_(pi') (s) >= v_pi (s)$`。
- `$tilde(v)_*$`、`$tilde(q)_*$`：把 ε-soft 要求移入环境后，新环境的最优值函数。
- `$v_pi = tilde(v)_*$`：π 在 ε-soft 策略中最优的充要条件。
- `$1 - epsilon$`：新环境按原环境行为的概率。

### PDF p.125

- `$b != pi$`：目标策略与行为策略不同。
- `$pi (a|s) > 0$`、`$b(a|s) > 0$`：coverage 假设的前件与结论。

### PDF p.126

- `$bb(E)[G_t | S_t = s] = v_b (s)$`：行为策略下回报的期望。
- `$cal(T)(s)$`：状态 *s* 被访问的全部时间步集合。
- `$T(t)$`：时间 *t* 之后首次终止的时刻（斜体 *T*，与花体 `cal(T)` 不同）。
- `${G_t}_(t in cal(T)(s))$`、`${rho_(t:T(t)-1)}_(t in cal(T)(s))$`：两个序列记号。
- `$rho_(t:T(t)-1)$`：重要性采样比。

### PDF p.127

- `$p$`、`$1 - p$`：练习 5.5 中动作的两种转移概率。

### PDF p.128

- `$-0.27726$`：例题 5.4 中该黑杰克状态的目标值。
- `$0.9$`、`$0.1$`：例题 5.5 中左行动的两条转移概率。

### PDF p.129

- `$X$`、`$overline(X)$`：随机变量及其均值，均值上划线写成 `overline(X)`。
- `$gamma = 1$`：例题 5.5 不折扣。

### PDF p.131

- `$W_i = rho_(t_i:T(t_i)-1)$`：第 *i* 个回报对应的随机权重。
- `$C_0 ≐ 0$`：权重累加和的初值。
- `$V_1$`：任意初值，不必指定。
- `$pi = b$`：同策情形下目标策略与行为策略相同（原书这里写作 (π = *b*)）。

### PDF p.133

- `$pi approx pi_*$`：框标题与正文中的收敛结论。

### PDF p.134

- `$frac(pi (A_0|S_0), b(A_0|S_0))$`：连乘中起决定作用的第一因子。
- `$3 times 3$`：练习 5.12 的九种加速度增量组合。

### PDF p.135

- `$gamma in [0, 1)$`：折扣率的取值范围。
- `$(1 - gamma) gamma^2$`：第三步终止的程度。
- `$G_0 = R_1$`：完全折扣时回报只剩第一个奖励。

### PDF p.136

- `$gamma = 1$`：5.9 节中的无折扣情形。

### PDF p.139

- `$cal(T)(s, a)$`：练习 5.15 定义的状态–动作对访问时间步集合。
