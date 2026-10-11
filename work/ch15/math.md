# 第 15 章公式（Neuroscience，PDF 399–442）

全部公式对照 `work/pages/pNNNN.png` 页面渲染图逐条重建，未参考文字层的数学片段。

代码即 Typst 数学代码。块级公式写成 `$ ... $`（两侧留空格），行内公式写成 `$...$`；章文件里直接照抄即可。原书带编号的公式在代码之后给出标签，编号由模板生成。原书中不编号的展示公式按其在页面上的先后记为 `(unnumbered pNNN-k)`，与 `source.md` 的占位符一一对应。

写法约定沿用第 5 章、第 9 章与第 14 章：下标是单独一个标识符或符号、后面紧跟 `(` 或 `[` 时中间必须留空格（`pi (1|s, bold(theta))`、`A_t - pi (1|S_t, bold(theta))`、`V (S_t)`、`x_i (s)`）；下标是括号组或带括号的时间步（`S_(t+1)`、`R_(t+1)`、`S_(t-1)`、`bold(z)_(t-1)`）时不受影响。转置写 `^top`。

本章特有：

- 特征向量、权重向量、资格迹向量是粗体直立：`bold(x)`、`bold(w)`、`bold(z)`；策略参数是粗体斜体：`bold(theta)`（原书里 w、x、z 用 mathbf，θ 用 boldsymbol）。特征与权重的分量不带粗体：`x_i (s)`、`w_i`、`theta_j`。
- 预测值带帽：`hat(v)`；状态、动作、奖励、TD 误差、时间步、折扣因子、步长参数、资格迹衰减参数写斜体：`S_t`、`S_(t+1)`、`A_t`、`R_t`、`R_(t+1)`、`delta_t`、`delta_(t-1)`、`t`、`gamma`、`alpha`、`lambda`。
- 参数上标区分 critic 与 actor：`alpha^bold(w)`、`alpha^bold(theta)`、`lambda^bold(w)`、`lambda^bold(theta)`、`bold(z)_t^bold(w)`、`bold(z)_t^bold(theta)`（w 上标是粗体直立，θ 上标是粗体斜体）。
- 折扣因子的取值范围写 `[0, 1)`，包含关系写 `in`。
- ∇ 直接接被作用的函数，中间不空格：`nabla hat(v)(S_t, bold(w))`、`nabla ln pi (A_t|S_t, bold(theta))`。
- 奖励数量 R⋆ 写 `R^star`。图 15.4 与图 15.5 的坐标轴与网络标注（R、V、δ、TD、Dopamine 等）不属正文公式，见 `figures.json`。

## (unnumbered p421-1)   PDF p.421

五行对齐的 actor–critic 更新式组：前三行的等号对齐，第四、五行的左端箭头与前三行的等号在同一列对齐。原书没有编号，紧跟其后的是 "where γ ∈ [0, 1) ..." 一段。各行末尾都是逗号；z 的上下标里 w 是粗体直立、θ 是粗体斜体，v̂ 的参数里 w 是粗体直立。δ 与 t、R、γ、λ 是斜体。

```typst
$ delta_t &= R_(t+1) + gamma hat(v)(S_(t+1), bold(w)) - hat(v)(S_t, bold(w)), \
  bold(z)_t^bold(w) &= gamma lambda^bold(w) bold(z)_(t-1)^bold(w) + nabla hat(v)(S_t, bold(w)), \
  bold(z)_t^bold(theta) &= gamma lambda^bold(theta) bold(z)_(t-1)^bold(theta) + nabla ln pi (A_t|S_t, bold(theta)), \
  bold(w) &arrow.l bold(w) + alpha^bold(w) delta_t bold(z)_t^bold(w), \
  bold(theta) &arrow.l bold(theta) + alpha^bold(theta) delta_t bold(z)_t^bold(theta), $
```

## (15.1)   PDF p.421

线性值函数，w 与 x 都是粗体直立，末尾句点。紧跟其后的一句是 "Each x_i (s) ..."。

```typst
$ hat(v)(s, bold(w)) = bold(w)^top bold(x)(s). $ <eq-15-1>
```

## (15.2)   PDF p.422

Bernoulli-logistic 单元的动作概率，右端是竖排分式 `frac`，`exp` 为直立体，末尾句点。

```typst
$ pi (1|s, bold(theta)) = 1 - pi (0|s, bold(theta)) = frac(1, 1 + exp(-bold(theta)^top bold(x)(s))). $ <eq-15-2>
```

## (15.3)   PDF p.422

策略梯度的对数形式。左端 ∇ 直接接 `ln pi`；右端是 (A_t − π(1|S_t, θ)) 的外层大括号后直接紧接粗体 x(S_t)，无乘号，末尾句点。

```typst
$ nabla ln pi (A_t|S_t, bold(theta)) = (A_t - pi (1|S_t, bold(theta))) bold(x)(S_t). $ <eq-15-3>
```

## 行内公式写法

只收录有结构或容易写错的行内式，按页码排序。

- p402 奖励信号写 `$R_t$`，正文里 TD 误差写作 `$delta_(t-1) = R_t + gamma V (S_t) - V (S_(t-1))$`；同页脚注 1（"δ_t 直到 t + 1 才可得"）给出两条式子：`$delta_t = R_(t+1) + gamma V (S_(t+1)) - V (S_t)$` 与 `$delta_(t-1) = R_t + gamma V (S_t) - V (S_(t-1))$`。
- p403 估值写 `$V$`、`$Q$`。
- p404 脚注 2 的同一改写：`$delta_(t-1) = R_t + gamma V (S_t) - V (S_(t-1))$`。
- p413–p415 图 15.4 相关的简化式子：奖励数量写 `$R^star$`；第一试次里 `$delta_(t-1) = R_t + V_t - V_(t-1) = R_t + 0 - 0 = R_t$`；学习收敛后 `$delta_(t-1) = R_t + V_t - V_(t-1) = 0 + R^star - R^star = 0$` 与 `$delta_(t-1) = R_t + V_t - V_(t-1) = R^star + 0 - R^star = 0$`；奖励被省略后 `$delta_(t-1) = R_t + V_t - V_(t-1) = 0 + 0 - R^star = -R^star$`。图 15.4 图注里的时间写法是 `$delta_(t-1)$`。
- p418 actor 单元及其编号：`$A_i$`、`$i = 1, . . . , k$`；`$k$` 维动作向量。
- p419 特征的分量：`$x_1$`、`$x_2$`、`$x_n$`、`$x_i$`，critic 单元写 `$V$`。
- p420 资格迹向量：`$bold(z)_t^bold(w)$`、`$bold(z)_t^bold(theta)$`；跨页到 p421 的参数写 `$bold(w)$`、`$bold(theta)$`。
- p421 参数范围与步长：`$gamma in [0, 1)$`、`$lambda^bold(w) in [0, 1]$`、`$lambda^bold(theta) in [0, 1]$`、`$alpha^bold(w) > 0$`、`$alpha^bold(theta) > 0$`；特征向量与权重向量：`$x(s) = (x_1 (s), . . . , x_n (s))^top$`、`$bold(w) = (w_1, . . . , w_n)^top$`；critic 的增量、梯度与衰减：`$alpha^bold(w) delta_t bold(z)_t^bold(w)$`、`$nabla hat(v)(S_t, bold(w))$`、`$nabla hat(v)(S_t, bold(w)) = bold(x)(S_t)$`、`$x(S_t)$`、`$lambda^bold(w)$`；突触前后配对写 `$x_i (s)$` 与 `$w_i$`。
- p421–p422 actor 单元的参数与规则：`$x(S_t)$`、`$theta_j$`、`$j = 1, . . . , k$`、`$theta^top bold(x)(S_t)$`、`$bold(theta) arrow.l bold(theta) + alpha^bold(theta) delta_t bold(z)_t^bold(theta)$`、`$nabla ln pi (A_t|S_t, bold(theta))$`、`$nabla ln pi (a|s, bold(theta))$`、`$pi (a|s, bold(theta))$`、`$x(s)$`。
- p422–p423 资格迹里的两个因子：`$A_t - pi (1|S_t, bold(theta))$` 与整体 `$(A_t - pi (1|S_t, bold(theta))) bold(x)(S_t)$`（正文共出现五次：p422 一处、p423 三处、p437 一处，另有显示公式 (15.3) 自身）。
- p426 动作向量的写法：`$(A_1, A_2, dots.c, A_k)^top$`。
- p437 15.8 节对比两种资格迹：`$A_t times bold(x)(S_t)$`（原书用显式乘号 `times`）与 `$(A_t - pi (1|S_t, bold(theta))) bold(x)(S_t)$`（无乘号）。
