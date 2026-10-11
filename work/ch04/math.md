# 第 4 章公式（Dynamic Programming，PDF 95–112）

全部公式对照 `work/pages/pNNNN.png` 页面渲染图逐条重建，未参考文字层的数学片段。

代码即 Typst 数学代码。块级公式写成 `$ ... $`（两侧留空格），行内公式写成 `$...$`；章文件里直接照抄即可。原书带编号的公式在代码之后给出标签，编号由模板生成。原书中不编号的展示公式按其在页面上的先后记为 `(unnumbered pNN-k)`，与 `source.md` 的占位符一一对应；伪代码框内的公式单列一节。

四条写法约定：

- 下标是单独一个标识符或符号，后面紧跟 `(` 或 `[` 时，中间必须留一个空格：写 `v_* (s)`、`q_* (s, a)`、`v_pi (s)`、`bb(E)_pi [G_t]`。不留空格时 Typst 把括号吞进下标，编译不报错，肉眼容易看漏。下标是括号组（`v_(k+1)(s)`、`v_(pi') (s)`）时不受影响，写成 `v_(pi') (s)` 也多留了一个空格，加了没有副作用。
- `argmax` 不是 Typst 内置算子，写成 `op("argmax", limits: #true)`，下标才能排在单词下方，与原书一致。`max_a`、`sum_(s',r)` 直接用裸写法即可，Typst 在块级公式里把上下限排在符号下方、在行内公式里排在符号右侧，与原书的排版选择恰好相同。
- 集合记号 S、A、R 在原书里是花体，写成 `cal(S)`、`cal(A)`、`cal(R)`；实数集写成 `bb(R)`。期望是空心粗体 E，写成 `bb(E)`。定义为的符号直接写 `≐`。
- 原书用打字机字体排出动作名（`up`、`down`、`right`、`left`）和伪代码里的 `terminal`、`policy-stable`、`old-action` 等词。数学模式里用引号字符串写成 `"right"`、`italic("terminal")`，渲染为直立体，与原书的正体字形一致。

## (4.1)   PDF p.95

原书是一个两行对齐展示，编号 (4.1) 排在第二行右侧。

```typst
$ v_* (s) &= max_a bb(E)[R_(t+1) + gamma v_* (S_(t+1)) | S_t = s, A_t = a] \
          &= max_a sum_(s', r) p(s', r | s, a) [r + gamma v_* (s')], $ <eq-4-1>
```

## (4.2)   PDF p.95

同样是两行对齐展示，编号 (4.2) 排在第二行右侧。上式与此式之间的 “or” 是正文。

```typst
$ q_* (s, a) &= bb(E)[R_(t+1) + gamma max_(a') q_* (S_(t+1), a') | S_t = s, A_t = a] \
             &= sum_(s', r) p(s', r | s, a) [r + gamma max_(a') q_* (s', a')], $ <eq-4-2>
```

## (4.3)   PDF p.96

原书这一个展示共四行，第 1 行以 `≐` 起头，第 2 行右侧注 “(from (3.9))”，第 3 行标 (4.3)，第 4 行标 (4.4)。Typst 一条展示只能带一个编号，所以拆成两条：下面这条对应前 3 行，`<eq-4-3>` 标在这里；第 4 行见下一条，它以 `&=` 开头，单独成展示时对齐位置与这一条相同，续接的视觉效果与原书一致。

```typst
$ v_pi (s) &≐ bb(E)_pi [G_t | S_t = s] \
           &= bb(E)_pi [R_(t+1) + gamma G_(t+1) | S_t = s] &quad "(from (3.9))" \
           &= bb(E)_pi [R_(t+1) + gamma v_pi (S_(t+1)) | S_t = s] $ <eq-4-3>
```

## (4.4)   PDF p.96

接上一条的第 4 行，编号 (4.4)。

```typst
$ &= sum_a pi (a | s) sum_(s', r) p(s', r | s, a) [r + gamma v_pi (s')], $ <eq-4-4>
```

## (4.5)   PDF p.96

两行对齐展示，编号 (4.5) 排在第二行右侧。

```typst
$ v_(k+1)(s) &≐ bb(E)_pi [R_(t+1) + gamma v_k (S_(t+1)) | S_t = s] \
             &= sum_a pi (a | s) sum_(s', r) p(s', r | s, a) [r + gamma v_k (s')], $ <eq-4-5>
```

## (4.6)   PDF p.100

两行对齐展示，编号 (4.6) 排在第二行右侧。

```typst
$ q_pi (s, a) &≐ bb(E)[R_(t+1) + gamma v_pi (S_(t+1)) | S_t = s, A_t = a] \
             &= sum_(s', r) p(s', r | s, a) [r + gamma v_pi (s')]. $ <eq-4-6>
```

## (4.7)   PDF p.100

```typst
$ q_pi (s, pi' (s)) >= v_pi (s). $ <eq-4-7>
```

## (4.8)   PDF p.100

```typst
$ v_(pi') (s) >= v_pi (s). $ <eq-4-8>
```

## (unnumbered p100-1)   PDF p.100

策略改进定理的证明链，原书共 10 行，第 2 行右侧注 “(by (4.6))”、第 4 行右侧注 “(by (4.7))”，第 8 行是竖直省略号。

```typst
$ v_pi (s) &<= q_pi (s, pi' (s)) \
           &= bb(E)[R_(t+1) + gamma v_pi (S_(t+1)) | S_t = s, A_t = pi' (s)] &quad "(by (4.6))" \
           &= bb(E)_(pi') [R_(t+1) + gamma v_pi (S_(t+1)) | S_t = s] \
           &<= bb(E)_(pi') [R_(t+1) + gamma q_pi (S_(t+1), pi' (S_(t+1))) | S_t = s] &quad "(by (4.7))" \
           &= bb(E)_(pi') [R_(t+1) + gamma bb(E)[R_(t+2) + gamma v_pi (S_(t+2)) | S_(t+1), A_(t+1) = pi' (S_(t+1))] | S_t = s] \
           &= bb(E)_(pi') [R_(t+1) + gamma R_(t+2) + gamma^2 v_pi (S_(t+2)) | S_t = s] \
           &<= bb(E)_(pi') [R_(t+1) + gamma R_(t+2) + gamma^2 R_(t+3) + gamma^3 v_pi (S_(t+3)) | S_t = s] \
           &dots.v \
           &<= bb(E)_(pi') [R_(t+1) + gamma R_(t+2) + gamma^2 R_(t+3) + gamma^3 R_(t+4) + dots.c | S_t = s] \
           &= v_(pi') (s). $
```

## (4.9)   PDF p.101

三行对齐展示，编号 (4.9) 排在第二行右侧。

```typst
$ pi' (s) &≐ op("argmax", limits: #true)_a q_pi (s, a) \
          &= op("argmax", limits: #true)_a bb(E)[R_(t+1) + gamma v_pi (S_(t+1)) | S_t = s, A_t = a] \
          &= op("argmax", limits: #true)_a sum_(s', r) p(s', r | s, a) [r + gamma v_pi (s')], $ <eq-4-9>
```

## (unnumbered p101-1)   PDF p.101

两行对齐展示，第二行末尾是句号。它对应 `source.md` 里 `[[EQ: (unnumbered p101-1)]]` 那个占位符，原书没有编号。

```typst
$ v_(pi') (s) &= max_a bb(E)[R_(t+1) + gamma v_(pi') (S_(t+1)) | S_t = s, A_t = a] \
              &= max_a sum_(s', r) p(s', r | s, a) [r + gamma v_(pi') (s')]. $
```

## (unnumbered p102-1)   PDF p.102

策略迭代产生的策略与值函数序列。箭头是长右箭头，字母排在上方；`···` 是横向居中省略号。

```typst
$ pi_0 arrow.r.long^"E" v_(pi_0) arrow.r.long^"I" pi_1 arrow.r.long^"E" v_(pi_1) arrow.r.long^"I" pi_2 arrow.r.long^"E" dots.h.c arrow.r.long^"I" pi_* arrow.r.long^"E" v_*, $
```

## (4.10)   PDF p.105

两行对齐展示，编号 (4.10) 排在第二行右侧。

```typst
$ v_(k+1)(s) &≐ max_a bb(E)[R_(t+1) + gamma v_k (S_(t+1)) | S_t = s, A_t = a] \
             &= max_a sum_(s', r) p(s', r | s, a) [r + gamma v_k (s')], $ <eq-4-10>
```

## 伪代码框内公式

框内的公式是行内公式（求和号与上下限排在符号右侧，与原书一致），因此写成 `$...$` 而不是 `$ ... $`；它们不带编号，`source.md` 的框里也没有占位符。

### PDF p.97 「Iterative Policy Evaluation」框

- 值更新一行：`$V(s) arrow.l sum_a pi (a|s) sum_(s',r) p(s',r|s,a) [r + gamma V(s')]$`
- 初始化一行里的终局状态：`$V (italic("terminal"))$`
- 误差与判据：`$Delta arrow.l 0$`、`$v arrow.l V(s)$`、`$Delta arrow.l max(Delta, |v - V(s)|)$`、`$Delta < theta$`
- 输入与阈值：`$pi$`、`$theta > 0$`、`$s in cal(S)$`

### PDF p.102 「Policy Iteration」框

- 初始化：`$V(s) in bb(R)$`、`$pi (s) in cal(A)(s)$`、`$V (italic("terminal")) ≐ 0$`
- 策略评估的更新：`$V(s) arrow.l sum_(s',r) p(s',r | s, pi (s)) [r + gamma V(s')]$`
- 策略改进的更新：`$pi (s) arrow.l op("argmax", limits: #true)_a sum_(s',r) p(s',r | s, a) [r + gamma V(s')]$`
- 改进判据：`$italic("policy-stable") arrow.l italic("true")$`、`$italic("old-action") arrow.l pi (s)$`、`$italic("old-action") != pi (s)$`、`$italic("policy-stable") arrow.l italic("false")$`
- 返回与判据：`$V approx v_*$`、`$pi approx pi_*$`、`$Delta < theta$`

### PDF p.105 「Value Iteration」框

- 初始化：`$V(s)$`、`$s in cal(S)^+$`、`$V (italic("terminal")) = 0$`、`$theta > 0$`
- 值更新一行：`$V(s) arrow.l max_a sum_(s',r) p(s',r|s,a) [r + gamma V(s')]$`
- 误差与判据：`$v arrow.l V(s)$`、`$Delta arrow.l max(Delta, |v - V(s)|)$`、`$Delta < theta$`
- 输出策略：`$pi approx pi_*$`、`$pi (s) = op("argmax", limits: #true)_a sum_(s',r) p(s',r|s,a) [r + gamma V(s')]$`

## 行内公式

只收录有结构或者容易写错的行内式。单字母变量与 `v_pi (s)`、`v_* (s)`、`q_* (s, a)` 这类贯穿全章的符号，写法见 `glossary/notation.typ`，不逐处重复。

### PDF p.95

- `$p(s', r | s, a)$`：环境动力学。
- `$s in cal(S)$`、`$a in cal(A)(s)$`、`$r in cal(R)$`、`$s' in cal(S)^+$`：动力学概率的定义域。
- `$v_*$`、`$q_*$`：两个最优值函数。

### PDF p.96

- `$pi (a | s)$`：策略 π 下在状态 *s* 采取动作 *a* 的概率。
- `$gamma < 1$`：保证 $v_pi$ 存在且唯一的条件之一。
- `$|cal(S)|$`：线性方程组的规模。
- `$v_0, v_1, v_2, dots.c$`：近似值函数序列。
- `$cal(S)^+ -> bb(R)$`：值函数的映射关系，箭头写成 `->`。
- `$v_k = v_pi$`：不动点。
- `$v_k$`、`$v_(k+1)$`、`$s$`：迭代过程中的新旧值。
- `${v_k}$`、`$k -> infinity$`：序列与收敛极限。

### PDF p.97

- `$v_k (s)$`、`$v_(k+1)(s)$`：两个数组分别保存的旧值与新值。
- `$max_(s in cal(S)) |v_(k+1)(s) - v_k (s)|$`：每次扫描后检验的收敛量。

### PDF p.98

- `$cal(S) = {1, 2, dots.c, 14}$`：非终局状态集合。
- `$cal(A) = {"up", "down", "right", "left"}$`：四个动作（原书用打字机字体）。
- `$p(6, -1 | 5, "right") = 1$`、`$p(7, -1 | 7, "right") = 1$`：两条确定性转移。
- `$p(10, r | 5, "right") = 0$`、`$r in cal(R)$`：不可能发生的转移。
- `$r(s, a, s') = -1$`：期望奖励函数。
- `$q_pi (11, "down")$`、`$q_pi (7, "down")$`：练习 4.1 的两个动作值。
- `$v_pi (15)$`：练习 4.2 中新增状态的值。
- `$a != pi (s)$`：与当前策略选择不同的动作。

### PDF p.100

- `$q_pi (s, a) > v_pi (s)$`：换成一个新动作更好的判据。
- `$pi'$`、`$pi''$`：改动后的策略、再次改动后的策略（正文里写作 `pi'` 与 `pi''`）。

### PDF p.101

- `$-1$`、`$-2$`、`$-3$`、`$-14$`：策略改进例子的取值比较。
- `$v_(pi') (s) >= v_pi (s)$`：结论式，与 (4.8) 同形。

### PDF p.103

- `$frac(lambda^n, n!) e^(-lambda)$`：泊松分布取值为 *n* 的概率。
- `$gamma = 0.9$`：折扣率。

### PDF p.104

- `$q_*$`、`$v_*$`：练习 4.5 中要求计算的动作值。
- `$epsilon slash |cal(A)(s)|$`：ε-soft 策略的下界。斜杠表示除法，写成 `slash`；不要把整式写成分式。

### PDF p.106

- `$s in {1, 2, dots.c, 99}$`、`$a in {0, 1, dots.c, min(s, 100 - s)}$`：赌徒问题的状态与动作。
- `$p_h$`：硬币正面朝上的概率（下标是 *h*，紧跟变量，不受吞括号规则影响）。
- `$p_h = 0.4$`：图 4.3 所用的取值。
- `$+1$`、`$0$`：到达目标时的奖励与其余转移的奖励。
- `$theta -> 0$`：练习 4.9 中的极限。

### PDF p.107

- `$10^20$`：西洋双陆棋的状态数。
- `$0 <= gamma < 1$`：异步值迭代收敛的折扣条件。
- `$s_k$`、`$k$`：第 *k* 步更新的那个状态与步号。
- `${s_k}$`：更新顺序序列。

### PDF p.109

- `$n$`、`$k$`：状态数与动作数。
- `$k^n$`：确定性策略的总数；原书排成 $k$ 的上标 $n$，写成 `k^n`。
