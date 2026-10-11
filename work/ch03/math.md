# 第 3 章公式（Finite Markov Decision Processes，PDF 69–94）

全部公式对照 `work/pages/pNNNN.png` 页面渲染图逐条重建，未参考文字层的数学片段。

代码即 Typst 数学代码。块级公式写成 `$ ... $`（两侧留空格），行内公式写成 `$...$`；章文件里直接照抄即可。原书带编号的公式在代码之后给出标签，编号由模板生成。原书中不编号的展示公式按其在页面上的先后记为 `(unnumbered pNN-k)`，与 `source.md` 的占位符一一对应，即例题 3.9 的两条式子 `[[EQ: (unnumbered p87-1)]]` 与 `[[EQ: (unnumbered p88-1)]]`。

四条写法约定：

- 下标是单独一个标识符或符号，后面紧跟 `(` 或 `[` 时，中间必须留一个空格：写 `v_* (s)`、`q_* (s, a)`、`v_pi (s)`、`bb(E)_pi [G_t]`、`r_"s" [x]`。不留空格时 Typst 把括号吞进下标，编译不报错，肉眼容易看漏。下标是括号组（`v_(pi') (s)`、`q_(pi_*) (s, a)`）时不受影响。
- `max_a`、`max_pi`、`sum_(s',r)` 直接用裸写法；Typst 在块级公式里把上下限排在符号下方、在行内公式里排在符号右侧，与原书的排版选择恰好相同。
- 集合记号 S、A、R 在原书里是花体，写成 `cal(S)`、`cal(A)`、`cal(R)`；实数集写成 `bb(R)`。期望是空心粗体 E，写成 `bb(E)`，带策略下标的期望写成 `bb(E)_pi`、`bb(E)_(pi_*)`。定义为的符号直接写 `≐`。
- 原书用打字机字体排出状态与动作的名字（`high`、`low`、`search`、`wait`、`recharge`，例题 3.9 的缩写 `h`、`l`、`s`、`w`、`re`，以及高尔夫例题里的 `driver`、`putter`）。`source.md` 里用反引号写出；数学模式里用引号字符串写成 `"h"`、`"driver"`，渲染为直立体，与原书字形一致。

省略号按原书区分：逗号分隔的序列用低点 `dots.h`（如 (3.1)），加法式子中间用居中点 `dots.c`（如 (3.7)–(3.9)）。策略的概率在原书里是紧排的 `pi(a|s)`，动力学函数是松排的 `p(s', r | s, a)`，两者照原样写。

## (3.1)   PDF p.70

轨迹的开头一段。单行展示，逗号分隔的序列，末尾是低点省略号，右侧编号。

```typst
$ S_0, A_0, R_1, S_1, A_1, R_2, S_2, A_2, R_3, dots.h $ <eq-3-1>
```

## (3.2)   PDF p.70

单行展示，右端逗号。`Pr` 是正体的概率记号，花括号括住事件。

```typst
$ p(s', r | s, a) ≐ Pr{S_t = s', R_t = r | S_(t-1) = s, A_(t-1) = a}, $ <eq-3-2>
```

## (3.3)   PDF p.71

单行展示，右端是 “for all …”。

```typst
$ sum_(s' in cal(S)) sum_(r in cal(R)) p(s', r | s, a) = 1, quad "for all " s in cal(S), a in cal(A)(s). $ <eq-3-3>
```

## (3.4)   PDF p.71

单行展示，右端句号。

```typst
$ p(s' | s, a) ≐ Pr{S_t = s' | S_(t-1) = s, A_(t-1) = a} = sum_(r in cal(R)) p(s', r | s, a). $ <eq-3-4>
```

## (3.5)   PDF p.71

单行展示，右端逗号。期望写成 `bb(E)[...]`，求和范围是花体集合。

```typst
$ r(s, a) ≐ bb(E)[R_t | S_(t-1) = s, A_(t-1) = a] = sum_(r in cal(R)) r sum_(s' in cal(S)) p(s', r | s, a), $ <eq-3-5>
```

## (3.6)   PDF p.71

单行展示，右端逗号。分式的分母是状态转移概率。

```typst
$ r(s, a, s') ≐ bb(E)[R_t | S_(t-1) = s, A_(t-1) = a, S_t = s'] = sum_(r in cal(R)) r frac(p(s', r | s, a), p(s' | s, a)). $ <eq-3-6>
```

## (3.7)   PDF p.76

单行展示，右端逗号。三项之后是居中省略号。

```typst
$ G_t ≐ R_(t+1) + R_(t+2) + R_(t+3) + dots.c + R_T, $ <eq-3-7>
```

## (3.8)   PDF p.77

单行展示，右端逗号。`≐` 后面是折扣求和的前几项与省略号，再等于紧致的求和式。

```typst
$ G_t ≐ R_(t+1) + gamma R_(t+2) + gamma^2 R_(t+3) + dots.c = sum_(k=0)^infinity gamma^k R_(t+k+1), $ <eq-3-8>
```

## (3.9)   PDF p.77

三行对齐展示，编号 (3.9) 排在第三行右侧。第一行以 `≐` 起头，后两行以 `=` 起头；第二行的括号里再次出现省略号。

```typst
$ G_t &≐ R_(t+1) + gamma R_(t+2) + gamma^2 R_(t+3) + gamma^3 R_(t+4) + dots.c \
     &= R_(t+1) + gamma (R_(t+2) + gamma R_(t+3) + gamma^2 R_(t+4) + dots.c) \
     &= R_(t+1) + gamma G_(t+1) $ <eq-3-9>
```

## (3.10)   PDF p.77

单行展示，右端句号。

```typst
$ G_t = sum_(k=0)^infinity gamma^k = frac(1, 1 - gamma). $ <eq-3-10>
```

## (3.11)   PDF p.79

单行展示，右端逗号。

```typst
$ G_t ≐ sum_(k=t+1)^T gamma^(k-t-1) R_k, $ <eq-3-11>
```

## (3.12)   PDF p.80

单行展示，右端是 “for all s ∈ S,”（含逗号）。

```typst
$ v_pi (s) ≐ bb(E)_pi [G_t | S_t = s] = bb(E)_pi [sum_(k=0)^infinity gamma^k R_(t+k+1) | S_t = s], quad "for all " s in cal(S), $ <eq-3-12>
```

## (3.13)   PDF p.80

单行展示，右端句号。

```typst
$ q_pi (s, a) ≐ bb(E)_pi [G_t | S_t = s, A_t = a] = bb(E)_pi [sum_(k=0)^infinity gamma^k R_(t+k+1) | S_t = s, A_t = a]. $ <eq-3-13>
```

## (3.14)   PDF p.81

四行对齐展示。第二行右侧注 “(by (3.9))”，编号 (3.14) 排在第四行右侧；第四行的右端先写 “,”，再接 “for all s ∈ S,”。第三行到第四行把两个求和合并成 `sum_(s', r)`。

```typst
$ v_pi (s) &≐ bb(E)_pi [G_t | S_t = s] \
           &= bb(E)_pi [R_(t+1) + gamma G_(t+1) | S_t = s] &quad "(by (3.9))" \
           &= sum_a pi(a|s) sum_(s') sum_r p(s', r | s, a) [r + gamma bb(E)_pi [G_(t+1) | S_(t+1) = s']] \
           &= sum_a pi(a|s) sum_(s', r) p(s', r | s, a) [r + gamma v_pi (s')], quad "for all " s in cal(S), $ <eq-3-14>
```

## (3.15)   PDF p.84

单行展示，右端逗号。

```typst
$ v_* (s) ≐ max_pi v_pi (s), $ <eq-3-15>
```

## (3.16)   PDF p.85

单行展示，右端逗号。

```typst
$ q_* (s, a) ≐ max_pi q_pi (s, a), $ <eq-3-16>
```

## (3.17)   PDF p.85

单行展示，右端句号。

```typst
$ q_* (s, a) = bb(E)[R_(t+1) + gamma v_* (S_(t+1)) | S_t = s, A_t = a]. $ <eq-3-17>
```

## (3.18)   PDF p.85

原书这一个展示共五行，第 3 行右侧注 “(by (3.9))”，第 4 行标 (3.18)、第 5 行标 (3.19)。Typst 一条展示只能带一个编号，所以拆成两条：下面这条对应前 4 行，`<eq-3-18>` 标在这里；第 5 行见下一条，它以 `&=` 开头，单独成展示时对齐位置与这一条相同，续接的视觉效果与原书一致。第 1 行的 “=” 是普通等号，不是 `≐`；第 4 行的期望不带策略下标。

```typst
$ v_* (s) &= max_(a in cal(A)(s)) q_(pi_*) (s, a) \
          &= max_a bb(E)_(pi_*) [G_t | S_t = s, A_t = a] \
          &= max_a bb(E)_(pi_*) [R_(t+1) + gamma G_(t+1) | S_t = s, A_t = a] &quad "(by (3.9))" \
          &= max_a bb(E)[R_(t+1) + gamma v_* (S_(t+1)) | S_t = s, A_t = a] $ <eq-3-18>
```

## (3.19)   PDF p.85

接上一条的第 5 行，编号 (3.19)。

```typst
$ &= max_a sum_(s', r) p(s', r | s, a) [r + gamma v_* (s')]. $ <eq-3-19>
```

## (3.20)   PDF p.86

两行对齐展示，编号 (3.20) 排在第二行右侧。

```typst
$ q_* (s, a) &= bb(E)[R_(t+1) + gamma max_(a') q_* (S_(t+1), a') | S_t = s, A_t = a] \
             &= sum_(s', r) p(s', r | s, a) [r + gamma max_(a') q_* (s', a')]. $ <eq-3-20>
```

## (unnumbered p87-1)   PDF p.87

例题 3.9 中 v_*(`h`) 的三行推导，原书没有编号。每个 `max` 后面是一对花括号，里面并列两条分支，分支之间用逗号隔开：逗号写成 `#sym.comma` 放在分支内容末尾，接着隔一个空格再写 `;`（mat 的行分隔符），否则 Typst 会把 `;` 当作前一个行内表达式的结尾吞掉。花括号用 `mat(delim: "{", align: #left)` 排出，`{` 与 `}` 都随内容拉伸，条目靠左对齐，与原书一致。

```typst
$ v_* ("h") &= max mat(
    p("h" | "h", "s")[r("h", "s", "h") + gamma v_* ("h")] + p("l" | "h", "s")[r("h", "s", "l") + gamma v_* ("l")] #sym.comma ;
    p("h" | "h", "w")[r("h", "w", "h") + gamma v_* ("h")] + p("l" | "h", "w")[r("h", "w", "l") + gamma v_* ("l")],
    delim: "{", align: #left) , \
  &= max mat(
    alpha [r_"s" + gamma v_* ("h")] + (1 - alpha)[r_"s" + gamma v_* ("l")] #sym.comma ;
    1[r_"w" + gamma v_* ("h")] + 0[r_"w" + gamma v_* ("l")],
    delim: "{", align: #left) , \
  &= max mat(
    r_"s" + gamma [alpha v_* ("h") + (1 - alpha) v_* ("l")] #sym.comma ;
    r_"w" + gamma v_* ("h"),
    delim: "{", align: #left) . $
```

## (unnumbered p88-1)   PDF p.88

例题 3.9 中 v_*(`l`) 的式子，同样没有编号。花括号里并列三条分支，前两条分支末尾各有逗号，闭括号之后是句号。其余写法同上一条。

```typst
$ v_* ("l") = max mat(
    beta r_"s" - 3(1 - beta) + gamma [(1 - beta) v_* ("h") + beta v_* ("l")] #sym.comma ;
    r_"w" + gamma v_* ("l") #sym.comma ;
    gamma v_* ("h"),
    delim: "{", align: #left) . $
```

## 行内公式

只收录有结构或者容易写错的行内式。单字母变量与 `v_pi (s)`、`v_* (s)`、`q_* (s, a)` 这类贯穿全章的符号，写法见 `glossary/notation.typ`，不逐处重复。

### PDF p.69

- `$q_* (a)$`、`$q_* (s, a)$`、`$v_* (s)$`：赌博机与 MDP 中要估计的动作值、状态值。

### PDF p.70

- `$t = 0, 1, 2, 3, dots.h$`：离散时间步序列，低点省略号。
- `$S_t in cal(S)$`、`$A_t in cal(A)(s)$`：状态与动作的取值范围。
- `$R_(t+1) in cal(R) subset bb(R)$`：奖励取自有限集合，奖励集合是实数集的子集。
- `$p : cal(S) times cal(R) times cal(S) times cal(A) -> [0, 1]$`：四参数动力学函数的类型，箭头写成 `->`。
- `$r in cal(R)$`：方程 (3.2) 中奖励的取值。

### PDF p.71

- `$S_(t-1)$`、`$A_(t-1)$`：马尔可夫性质所依赖的上一步状态与动作。
- `$p : cal(S) times cal(S) times cal(A) -> [0, 1]$`：状态转移概率函数的类型。
- `$r : cal(S) times cal(A) -> bb(R)$`、`$r : cal(S) times cal(A) times cal(S) -> bb(R)$`：两个期望奖励函数的类型，值域写成 `bb(R)`。

### PDF p.74

- `$cal(S) = {"high", "low"}$`：回收机器人的状态集合。
- `$cal(A)("high") = {"search", "wait"}$`、`$cal(A)("low") = {"search", "wait", "recharge"}$`：两个状态上各自的动作集合。
- `$r_"search" > r_"wait"$`：两个期望奖励的大小关系，下标是打字机体的 search 与 wait。
- `$p(s' | s, a)$`、`$r(s, a, s')$`：转移图上箭头的标注。

### PDF p.75

- `$R_t in bb(R)$`：每个时间步的奖励是简单数值。

### PDF p.76

- `$R_(t+1), R_(t+2), R_(t+3), dots.h$`：奖励序列的开头，低点省略号。
- `$cal(S)^+$`：全体状态加上终止状态，写成 `cal(S)^+`。

### PDF p.77

- `$0 <= gamma <= 1$`：折扣率的取值范围。
- `$gamma^(k-1)$`：第 k 步之后收到的奖励折算到现在的系数。
- `${R_k}$`：奖励序列，集合记号。
- `$gamma = 0$`：短视 agent 的折扣取值。

### PDF p.78

- `$R_1 = -1$`、`$R_2 = 2$`、`$R_3 = 6$`、`$R_4 = 3$`、`$R_5 = 2$`、`$T = 5$`：练习 3.8 给出的奖励序列与终止时间。
- `$G_0, G_1, dots.c, G_5$`：练习 3.8 要求计算的各步回报。
- `$gamma = 0.5$`、`$gamma = 0.9$`：练习 3.8 与练习 3.9 的折扣率。
- `$R_1 = 2$`：练习 3.9 的奖励序列首项。
- `$-gamma^(K-1)$`：持续型平衡杆任务中失败时刻的回报项，K 是失败前的步数。

### PDF p.79

- `$S_(t,i)$`、`$A_(t,i)$`、`$R_(t,i)$`、`$pi_(t,i)$`、`$T_i$`：带回合编号的记号。
- `$S_0$`：吸收状态图示的起点。
- `$+1, +1, +1, 0, 0, 0, dots.h$`：从 S_0 出发得到的奖励序列，低点省略号。
- `$T = 3$`：取前三个奖励求和的情形。
- `$gamma = 1$`、`$T = infinity$`：回报和仍有定义时允许的两种取值。

### PDF p.80

- `$pi(a|s)$`：策略，紧排的条件概率写法。
- `$A_t = a$`、`$S_t = s$`：π(a|s) 的含义。
- `$a in cal(A)(s)$`、`$s in cal(S)$`：策略的定义域。
- `$R_(t+1)$`、`$p$`：练习 3.11 中要求用它们表示期望。

### PDF p.81

- `$pi(a|s) p(s', r | s, a)$`：方程 (3.14) 里每个三元组的概率。

### PDF p.82

- `$gamma = 0.9$`：网格世界例子所用的折扣率。
- `$+10$`、`$+5$`、`$-1$`、`$0$`：状态 A、B 与其余转移的奖励。
- `$+0.7$`、`$+2.3$`、`$+0.4$`、`$-0.4$`：练习 3.14 要验算的四个相邻状态值。

### PDF p.83

- `$v_("putt")(s)$`：一直用推杆的策略的状态值函数。
- `$-infinity$`：沙坑状态的取值，原书印作 `−∞`。
- `$-2$`、`$-3$`：等高线的标注。

### PDF p.84

- `$pi >= pi'$`、`$v_pi (s) >= v_(pi') (s)$`：策略的偏序定义，prime 写成 `pi'`。
- `$pi_*$`：全体最优策略。

### PDF p.85

- `$q_* (s, "driver")$`：高尔夫例题的最优动作值，`driver` 是打字机体的动作名。

### PDF p.86

- `$n$`：贝尔曼最优方程组的规模，n 个方程 n 个未知数。

### PDF p.87

- `$v_* ("h")$`、`$v_* ("l")$`：例题 3.9 中两个状态的缩写。

### PDF p.88

- `$r_"s"$`、`$r_"w"$`：两个期望奖励的缩写，下标是打字机体的 s 与 w。
- `$10^20$`：西洋双陆棋的状态数。
- `$A^*$`：A* 启发式搜索，星号写成 `^*`。
- `$0 <= gamma < 1$`、`$0 <= alpha, beta <= 1$`：例题 3.9 中方程解存在的取值范围。
- `$q_* (s, "putter")$`：练习 3.21 中推杆的最优动作值函数。
- `$gamma = 0$`、`$gamma = 0.9$`、`$gamma = 0.5$`：练习 3.22 的三个折扣取值。
- `$pi_"left"$`、`$pi_"right"$`：两个确定性策略，下标是原书的无衬线体 left 与 right，用引号字符串写。

### PDF p.89

- `$q_*$`：练习 3.23 里要写贝尔曼方程的动作值函数。
- `$24.4$`：练习 3.24 中网格世界最好状态的最优值。
- `$v_*$`、`$q_*$`、`$pi_*$`：练习 3.25–3.28 要求互相表示的三个量。
- `$v_pi$`、`$q_pi$`、`$v_*$`、`$q_*$`：练习 3.29 要用三参数 `p` 与两参数 `r` 改写的四个值函数。

### PDF p.92

- `$p(s', r | s, a)$`：本书采用的动力学写法。
- `$p(s' | s, a)$`、`$r(s, a)$`：MDP 文献里更常见的写法。
- `$S_t$`、`$R_t$`：联合确定、共享同一时间下标。

### PDF p.93

- `$q_*$`：Watkins 的 Q-learning 估计的对象，由它派生出 “Q-functions” 的叫法。
- `$h(P, M)$`：Shannon 提出的棋类程序评估函数，参数是局面 P 与着法 M。
