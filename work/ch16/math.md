# 第 16 章公式（Applications and Case Studies，PDF 443–480）

全部公式对照 `work/pages/pNNNN.png` 页面渲染图（关键公式另用 600 DPI 局部裁切）逐条重建，未参考文字层的数学片段。

代码即 Typst 数学代码。块级公式写成 `$ ... $`（两侧留空格），行内公式写成 `$...$`；章文件里直接照抄即可。原书带编号的公式在代码之后给出标签，编号由模板生成。原书中不编号的展示公式按其在页面上的先后记为 `(unnumbered pNNN-k)`，与 `source.md` 的占位符一一对应。本章没有伪代码框。

写法约定沿用第 9 章：下标是单独一个标识符或符号、后面紧跟 `(` 或 `[` 时中间必须留空格（`v_theta (s)`、`tau (...)`、`v_pi (s)`）；下标是括号组（`bold(w)_(t+1)`、`bold(z)_(t-1)`、`S_(t+1)`）时不受影响。估值函数带帽写 `hat(v)(S_t, bold(w)_t)`、`hat(q)(s, a, bold(theta))`，函数名与左括号之间不留空格（沿用第 9 章写法）。定义为写 `≐`，分式写 `frac(...)`，× 写 `times`，横向省略号写 `dots.h`。本章特有：多字母词形下标写 `italic("DD")`、`italic("bet")`（原书是斜体词，不是两个变量相乘）；(16.2) 与 (16.3) 里的 max、min 在独立展示公式中上下限排在符号下方，直接写 `max_a`、用 Typst 的块级默认行为；p.477 的偏好函数里 min、max 位于分式内部，原书把下标排在符号右下角，须写 `op("min", limits: #false)_b`、`op("max", limits: #false)_b`；sigmoid 里的 σ 是原书没有下标的排版，照写；`tau` 是希腊字母 τ（温度参数），`⌧` 在文字层里就是这个 τ。

## (unnumbered p446-1)   PDF p.446

隐单元输出，原文上下文为 “The output, *h(j)*, of hidden unit *j* was a nonlinear sigmoid function of the weighted sum:”。右侧分式的指数是一个带下标的求和，指数中求和的 i 排在 ∑ 的右下角。

```typst
$ h(j) = sigma (sum_i w_(i j) x_i) = frac(1, 1 + e^(- sum_i w_(i j) x_i)), $
```

## (16.1)   PDF p.446

半梯度 TD(λ) 的一般更新式，等号是带点的 `≐`。错误项前的方括号随内容伸展。

```typst
$ bold(w)_(t+1) ≐ bold(w)_t + alpha [R_(t+1) + gamma hat(v)(S_(t+1), bold(w)_t) - hat(v)(S_t, bold(w)_t)] bold(z)_t, $ <eq-16-1>
```

## (unnumbered p446-2)   PDF p.446

资格迹向量的更新，原文上下文为 “updated by”。z_0 ≐ 0 在随后的正文里，是行内公式。

```typst
$ bold(z)_t ≐ gamma lambda bold(z)_(t-1) + nabla hat(v)(S_t, bold(w)_t), $
```

## (16.2)   PDF p.452

Watson 的下注动作价值，两个省略号是基线上的三个点（原书排 `. . .`）。`bet` 与 `DD` 是斜体词形。

```typst
$ hat(q)(s, italic("bet")) = p_(italic("DD")) times hat(v)(S_W + italic("bet"), dots.h) + (1 - p_(italic("DD"))) times hat(v)(S_W - italic("bet"), dots.h), $ <eq-16-2>
```

## (16.3)   PDF p.461

DQN 的半梯度 Q-learning 更新，max 的下标 a 排在符号正下方。

```typst
$ bold(w)_(t+1) = bold(w)_t + alpha [R_(t+1) + gamma max_a hat(q)(S_(t+1), a, bold(w)_t) - hat(q)(S_t, A_t, bold(w)_t)] nabla hat(q)(S_t, A_t, bold(w)_t), $ <eq-16-3>
```

## (unnumbered p462-1)   PDF p.462

用副本网络输出作目标时的更新式，原文上下文为 “then instead of (16.3) the update rule was:”。目标项用波浪号 q ̃，两个 q 分别是 `tilde(q)` 与 `hat(q)`，结尾是句点。

```typst
$ bold(w)_(t+1) = bold(w)_t + alpha [R_(t+1) + gamma max_a tilde(q)(S_(t+1), a, bold(w)_t) - hat(q)(S_t, A_t, bold(w)_t)] nabla hat(q)(S_t, A_t, bold(w)_t). $
```

## (16.4)   PDF p.466

AlphaGo 中新加入节点的价值混合，η 是混合参数。

```typst
$ v(s) = (1 - eta) v_theta (s) + eta G, $ <eq-16-4>
```

## (unnumbered p474-1)   PDF p.474

点击率指标，内容全部是直立体文字，结尾是逗号（与下一条 LTV 连排）。原文上下文为 “the CTR metric and a metric they called the LTV metric... the LTV metric critically distinguishes between individual website visitors:”。

```typst
$ "CTR" = frac("Total # of Clicks", "Total # of Visits"), $
```

## (unnumbered p474-2)   PDF p.474

终生价值指标，分母是 Visitors（不是 Visits），结尾是句点。

```typst
$ "LTV" = frac("Total # of Clicks", "Total # of Visitors"). $
```

## (unnumbered p477-1)   PDF p.477

soft-max 的动作偏好函数。原文上下文为 “computed according to (13.2) with action preferences:”。分式内的 min、max 下标排在符号右下角（`limits: #false`），与原书一致；θ 是粗体参数向量；τ 是斜体温度参数，括住分母的两个括号随内容伸展。偏好区间 [0, 1] 的说明在随后的正文里。

```typst
$ h(s, a, bold(theta)) = frac(hat(q)(s, a, bold(theta)) - op("min", limits: #false)_b hat(q)(s, b, bold(theta)), tau (op("max", limits: #false)_b hat(q)(s, b, bold(theta)) - op("min", limits: #false)_b hat(q)(s, b, bold(theta)))), $
```

## 行内公式

只收录有结构或者容易写错的行内式。单字母变量（*s*、*a*、*t*、*T*、*C*、*n*、*i*、*j*、*r*、*x*、*z*、*G*）与 `hat(v)(s, bold(w))`、`hat(q)(s, a, bold(theta))`、`bold(w)_t`、`bold(z)_t` 这类贯穿全章的符号，写法见 `glossary/notation.typ`，不逐处重复。本章特有的写法：词形下标 DD 与 bet 是斜体词，写 `italic("DD")`、`italic("bet")`；尺寸和乘积的乘号写 `times`；近似号写 `approx`；度数写 `degree`；斜杠分式写 `slash`。数学模式里数字之间的空格会被忽略（`$32 20$` 渲染成 3220），需要空格时写 `space`。

### PDF p.444

- `$hat(v)(s, bold(w))$`：TD-Gammon 的状态估值，估计从任意局面（棋盘位置）*s* 开始获胜的概率。

### PDF p.445

- `$(n - 3) slash 2$`：第四个输入单元在 *n* > 3 时取的值（原书排成行内斜杠分式）。
- `$n slash 2$`、`$n slash 15$`：中路棋子与已退场棋子的编码值（*n* 是相应棋子数）。

### PDF p.446

- `$h(j)$`：隐藏单元 *j* 的输出。
- `$z_0 ≐ 0$`：资格迹的初值。
- `$gamma = 1$`：倒转棋应用中的折扣率。
- `$hat(v)(S_(t+1), bold(w)) - hat(v)(S_t, bold(w))$`：γ = 1 且只在获胜时给奖励时，TD 误差通常就只剩这一项。
- `$S_0, S_1, S_2, dots.h$`：自对弈轨迹的状态序列（原书省略号排成基线上的三个点 `. . .`）。

### PDF p.447

- `$tilde.op 5 - 10$`：约 5 到 10 秒的思考时间（`tilde.op` 渲染 ∼，不能用 `~`，`~` 在 Typst 里是不换行空格；原书数字之间是连接号）。

### PDF p.452

- `$hat(q)(s, italic("bet"))$`：下注时比较的动作价值。
- `$hat(v)(dot.op, bold(w))$`：状态值函数（`dot.op` 渲染 ·）。
- `$p_(italic("DD"))$`：类内 DD 置信度。
- `$(r, w)$`：当前类别中答对与答错的次数（这里的 *w* 不是权重向量）。
- `$S_W$`：Watson 的当前得分。

### PDF p.456

- `$A_t in cal(A)(S_t)$`：可用动作集合的记号（正文行内写成 𝒜(*S_t*)）。
- `$epsilon = 0.05$`：ε-greedy 的探索参数。

### PDF p.460–461

- `$210 times 160$`、`$84 times 84$`、`$84 times 84 times 4$`：原始帧尺寸、预处理后的亮度数组尺寸、四帧堆叠后的网络输入维度。
- `$32 space 20 times 20$`、`$64 space 9 times 9$`、`$64 space 7 times 7$`：三个卷积层特征图的数量与尺寸。
- `$max(0, x)$`：整流非线性。
- `$3,136 space (64 times 7 times 7)$`：第三个卷积层的单元总数及其计算方式。

### PDF p.462

- `$(S_t, A_t, R_(t+1), S_(t+1))$`：存入记忆库的转移元组。
- `$gamma max_a hat(q)(S_(t+1), a, bold(w)_t)$`：更新式里的目标项（行内 max 的下标排在右下角）。
- `$R_(t+1) + gamma max_a tilde(q)(S_(t+1), a, bold(w)_t) - hat(q)(S_t, A_t, bold(w)_t)$`：被截断的误差项。
- `$[-1, 1]$`：误差项的截断区间。

### PDF p.465

- `$approx 250$`、`$approx 35$`、`$approx 150$`、`$approx 80$`：Go 与象棋的平均合法着法数和平均着法数。
- `$9 times 9$`：小型棋盘尺寸。

### PDF p.467

- `$19 times 19$`：棋盘每边 19 条线的交叉点数。
- `$19 times 19 times 48$`：SL 与 RL 策略网络的输入图像栈维度。

### PDF p.469–470

- `$eta = 0$`、`$eta = 1$`、`$eta = 0.5$`：混合参数在 (16.4) 中的三种取值。
- `$f_theta$`：图 16.7 标注的深度卷积网络（θ 是它的权重向量）。
- `$s_i$`、`$a_i$`、`$pi_i$`、`$z$`、`$T$`：自对弈轨迹的棋盘位置、着法、MCTS 返回的动作概率、胜者与结束时刻；`$i = 1, 2, dots.h, T$`。
- `$19 times 19 times 17$`：AlphaGo Zero 网络的输入图像栈维度。
- `$19^2 + 1$`：动作概率的输出单元数（361 个落子加停一手；平方写成上标）。

### PDF p.474

- `$1 - epsilon$`：选择 RF 预测点击概率最高的 offer 的概率（原书用连字符排成 `1-ε`）。

### PDF p.476

- `$mu$`、`$alpha$`：图 16.9 右图标注的倾斜角与迎角。
- `$5 degree$`、`$2.5 degree$`：每步调整倾斜角与迎角的幅度。
- `$3^2$`：调整方式的组合数（原书排成 3²）。
- `$-15 degree$`、`$+15 degree$`：倾斜角的上下界。

### PDF p.477

- `$hat(q)(s, a, bold(theta))$`：状态聚合下的近似动作价值，返回 *s*, *a* 对应的分量。
- `$1 slash tau$`：最高估计动作价值对应的偏好。
- `$[0, 1]$`：归一化后的动作价值区间。
- `$tau = 2.0$`、`$tau = 0.2$`：温度参数的初值与终值。
- `$alpha = 0.1$`、`$gamma = 0.98$`：步长与折扣率。

### PDF p.479

- `$gamma = .99$`：高度增益达到最大值时的折扣率（原书排成 `.99`，没有前导零）。
