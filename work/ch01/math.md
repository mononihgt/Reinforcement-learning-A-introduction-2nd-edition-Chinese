# 第 1 章公式（Introduction，PDF 23–46）

全部公式对照 `work/pages/pNNNN.png` 页面渲染图逐条重建，未参考文字层的数学片段。

代码即 Typst 数学代码。块级公式写成 `$ ... $`（两侧留空格），行内公式写成 `$...$`；章文件里直接照抄即可。原书中不编号的展示公式按其在页面上的先后记为 `(unnumbered pNN-k)`，与 `source.md` 的占位符一一对应。本章只有一条展示公式，原书未加编号。

写法约定：

- 下标是单独一个标识符或符号，后面紧跟 `(` 或 `[` 时，中间必须留一个空格：写 `$Q_t (s, a)$`，不写 `$Q_t(s, a)$`，后者渲染成下标为 `t(s, a)` 的 Q。本章的 `V(S_t)` 里下标 `t` 后面是右括号，不受此规则影响，照原样写。
- 左箭头 `←` 写成 `arrow.l`，与第 2 章一致。
- 展示公式末尾的逗号是原书自带的，照录。

## (unnumbered p32-1)   PDF p.32

```typst
$ V(S_t) arrow.l V(S_t) + alpha [V(S_(t+1)) - V(S_t)], $
```

第 1.5 节价值函数的更新式：把较早状态的价值朝较晚状态的价值移动一小步。原书未编号，`source.md` 里用 `[[EQ: (unnumbered p32-1)]]` 占位。

## 行内公式

只收录有结构或者容易写错的行内式。单字母变量与 `$S_t$`、`$V(S_t)$` 这类符号贯穿全章，写法见 `glossary/notation.typ`，不逐处重复。

### PDF p.31

- `$S_t$`：贪心动作之前的状态（“If we let $S_t$ denote the state before the greedy move”）。
- `$S_(t+1)$`：该动作之后的状态（“and $S_(t+1)$ the state after that move”）。
- `$V(S_t)$`：对 $S_t$ 的估计价值（“the update to the estimated value of $S_t$, denoted $V(S_t)$”）。

### PDF p.32

- `$V(S_(t+1)) - V(S_t)$`：相邻两次估计之差，时序差分法由此得名（“based on a difference, $V(S_(t+1)) - V(S_t)$, between estimates at two successive times”）。
- `$alpha$`：小于 1 的正数，步长参数（“where α is a small positive fraction called the step-size parameter”）。

### PDF p.33

- `$10^20$`：双陆棋的状态数（“which has approximately $10^20$ states”）。

### PDF p.40

- `$k$`：赌博机的臂数（“except with $k$ levers”）。同段 `*k-armed bandit*` 里的 k 是正文字体的斜体，见 `source.md`。

### PDF p.43

- `$op("TD")(lambda)$`：TD(λ) 算法（“introduced the TD(λ) algorithm and proved some of its convergence properties”）。
- `$op("TD")(0)$`：表格型 TD(0)（“the method that we now call tabular TD(0)”）。
