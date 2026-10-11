# 第 14 章公式（Psychology，PDF 363–398）

全部公式对照 `work/pages/pNNNN.png` 页面渲染图逐条重建，未参考文字层的数学片段。

代码即 Typst 数学代码。块级公式写成 `$ ... $`（两侧留空格），行内公式写成 `$...$`；章文件里直接照抄即可。原书带编号的公式在代码之后给出标签，编号由模板生成。原书中不编号的展示公式按其在页面上的先后记为 `(unnumbered pNNN-k)`，与 `source.md` 的占位符一一对应。

写法约定沿用第 5 章与第 9 章：下标是单独一个标识符或符号、后面紧跟 `(` 或 `[` 时中间必须留空格（`V_"AX" (R_"Y" - ...)`、`x_i (s)`、`V (S_t)`、`hat(v)(S_t, bold(w)_t)`）。下标是括号组或标记组合（`bold(w)_(t+1)`、`bold(z)_(t-1)`、`S_(t+1)`、`R_(t+1)`）时不受影响。求和的下标是 `_"CS"_i` 时写成 `sum_("CS"_i)`。定义为的符号直接写 `≐`，转置写 `^top`。

本章特有：

- 关联强度向量、刺激特征向量、资格迹向量是粗体直立：`bold(w)`、`bold(x)`、`bold(z)`；预测值带帽：`hat(v)`；时间步、状态、奖励、TD 误差、折扣因子、步长参数、资格迹衰减参数写斜体：`t`、`S_t`、`R_t`、`delta_t`、`gamma`、`alpha`、`lambda`。
- Rescorla–Wagner 记号的刺激标签 A、X、Y 及其复合刺激 AX 是直立体下标：`V_"A"`、`V_"X"`、`V_"AX"`、`R_"Y"`、`alpha_"A"`、`alpha_"X"`、`beta_"Y"`；条件刺激标签同样直立：`"CS"_i`。
- 增量符号写 `Δ`。脚注 5 的 CSC 特征写成上下标组合 `x_i^t`（下标 i 是刺激分量编号，上标 t 是时间步），其调用写 `x_i^t (S_(t'))`。
- 直立体词写引号字符串。
- 图 14.1 与图 14.4 的内部坐标轴标注不属正文公式，见 `figures.json`。

## (unnumbered p369-1)   PDF p.369

Rescorla–Wagner 模型的两行增量式，等号左端对齐。原书没有编号，紧跟其后的是文字层里的 "where" 一句。字母 A、X、Y 是直立体下标；第一行末尾无标点，第二行末尾是逗号。

```typst
$ ΔV_"A" &= alpha_"A" beta_"Y" (R_"Y" - V_"AX") \
  ΔV_"X" &= alpha_"X" beta_"Y" (R_"Y" - V_"AX"), $
```

## (14.1)   PDF p.370

关联强度向量的线性组合，末尾句点。粗体 `bold(w)` 上标转置。

```typst
$ hat(v)(s, bold(w)) = bold(w)^top bold(x)(s). $ <eq-14-1>
```

## (14.2)   PDF p.370

LMS 及 Rescorla–Wagner 的参数更新，末尾逗号。

```typst
$ bold(w)_(t+1) = bold(w)_t + alpha delta_t bold(x)(S_t), $ <eq-14-2>
```

## (14.3)   PDF p.370

预测误差的定义，末尾句点。

```typst
$ delta_t = R_t - hat(v)(S_t, bold(w)_t). $ <eq-14-3>
```

## (14.4)   PDF p.372

用资格迹向量替换特征向量的更新式，末尾逗号。

```typst
$ bold(w)_(t+1) = bold(w)_t + alpha delta_t bold(z)_t, $ <eq-14-4>
```

## (14.5)   PDF p.372

TD 误差的定义，末尾逗号。括号组下标 `(t+1)`、`(t-1)` 等不受空格规则影响。

```typst
$ delta_t = R_(t+1) + gamma hat(v)(S_(t+1), bold(w)_t) - hat(v)(S_t, bold(w)_t), $ <eq-14-5>
```

## (14.6)   PDF p.372

资格迹的递推定义，末尾句点。

```typst
$ bold(z)_t = gamma lambda bold(z)_(t-1) + bold(x)(S_t). $ <eq-14-6>
```

## 行内公式写法

只收录有结构或容易写错的行内式，按页码排序。

- p369 复合刺激的关联强度是各分量的和：`$V_"AX" = V_"A" + V_"X"$`；预测误差写 `$R_"Y" - V_"AX"$`；指示函数写 `$x_i (s) = 1$`。
- p370 输入向量写 `$bold(x)_t$`（脚注 3）。
- p373 特征向量的分量写法（脚注 4）：`$x_i$`、`$"CS"_i$`、`$i = 1, . . . , n$`、`$x_i (S_t) = 1$`。
- p374 逐次试验的 CSC 特征（脚注 5）：`$x_i^t$`、`$x_i^t (S_(t')) = 1$` 当 `$t = t'$`。
- p372 特征向量及其转置：`$bold(x)(s) = (x_1 (s), x_2 (s), . . . , x_n (s))^top$`；(14.2) 中被资格迹替换的那一项写作 `$bold(x)_t (S_t)$`（粗体 x，下标 t）。
- p377 二阶条件作用一节的 TD 误差与其分量：`$delta_t$`、`$gamma hat(v)(S_(t+1), bold(w)_t)$`、`$hat(v)(S_t, bold(w)_t)$`。
- p378 同节的写法一致：`$hat(v)(S_t, bold(w)_t)$`。
- p396 奖励信号写 `$R_t$`。
- p397 TD 误差改写为不带上标参数的估值形式：`$delta_t = R_(t+1) + gamma V (S_(t+1)) - V (S_t)$`；预测停驻的条件写 `$gamma V (S_(t+1)) - V (S_t) = 0$`，此时 `$R_(t+1) = 0$`。
