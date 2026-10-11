# 第 9 章公式（On-policy Prediction with Approximation，PDF 219–264）

全部公式对照 `work/pages/pNNNN.png` 页面渲染图逐条重建，未参考文字层的数学片段。

代码即 Typst 数学代码。块级公式写成 `$ ... $`（两侧留空格），行内公式写成 `$...$`；章文件里直接照抄即可。原书带编号的公式在代码之后给出标签，编号由模板生成。原书中不编号的展示公式按其在页面上的先后记为 `(unnumbered pNNN-k)`，与 `source.md` 的占位符一一对应；伪代码框内的公式单列一节。

写法约定沿用第 5 章：下标是单独一个标识符或符号、后面紧跟 `(` 或 `[` 时中间必须留空格（`v_pi (s)`、`hat(v)(s, bold(w))`、`pi (a|s)`、`mu(s)`、`hat(v)(S_t, bold(w)_t)`）。下标是括号组或标记组合（`bold(w)_(t+1)`、`G_(t:t+n)`、`bold(x)_(t+1)`、`hat(bold(A))_t`）时不受影响。集合记号写 `cal(S)`、`cal(A)`、`cal(S)^+`，实数集写 `bb(R)`，`d` 维实空间写 `bb(R)^d`，矩阵空间写 `bb(R)^(d×d)`；期望写 `bb(E)`；单位矩阵写 `bb(I)`；定义为的符号直接写 `≐`；上划线写 `overline(...)`（本章的目标函数是 `overline("VE")(bold(w))`）；分式写 `frac(...)`；转置写 `^top`。

本章特有：

- 参数向量与梯度是粗体：`bold(w)`、`bold(x)`、`bold(b)`、`bold(A)`、`bold(D)`、`bold(P)`、`bold(X)`、`bold(mu)`、`bold(s)`、`bold(c)`、`bold(1)`；估值函数带帽：`hat(v)`。LSTD 的估计量在粗体上再带帽：`hat(bold(A))_t`、`hat(bold(b))_t`。
- 上划线的目标函数写成 `overline("VE")`，`VE` 是直立体。最小值的下标是 `bold(w)`（LSTD 的收敛界 (9.14)），写成 `min_bold(w)`。
- 梯度算子写 `nabla`；范数写 `norm(s - c_i)`（RBF 特征）与 `norm(v)_mu^2`（第 11 章才用到，此处只出现前者）。归一化系数写成 `1/sqrt((c_1^i)^2 + ... + (c_k^i)^2)`。
- 前驱状态的短横线写 `overline(s)`：`sum_(overline(s))`、`eta(overline(s))`、`pi (a|overline(s))`。
- 直立体词写引号字符串：`"for all" s in cal(S)`、`bold(b) - bold(A) bold(w)_"TD" = bold(0)`、`quad "and" quad`、`"where" mu(s) "is the stationary distribution under" pi`。
- 盒子内的公式（多项式特征 (9.17)、一维余弦、多维余弦 (9.18) 与伪代码框）与正文同规格，不缩进处理。

## (9.1)   PDF p.221

均方值误差目标函数。求和范围是状态集 `cal(S)`，权重是 on-policy 分布 `mu(s)`，方括号外的平方是上标 `^2`，末尾句点。

```typst
$ overline("VE")(bold(w)) ≐ sum_(s in cal(S)) mu(s) [v_pi (s) - hat(v)(s, bold(w))]^2 . $ <eq-9-1>
```

## (9.2)   PDF p.221

on-policy 分布 `eta(s)` 的方程组，括注框内。第二项对前驱状态 `overline(s)` 求和。**原书这条不含折扣因子 `gamma`**；紧跟其后的正文说明要给它乘上 `gamma` 才是正确的加权版本。

```typst
$ eta(s) = h(s) + sum_(overline(s)) eta(overline(s)) sum_a pi (a|overline(s)) p(s|overline(s), a), quad "for all" s in cal(S). $ <eq-9-2>
```

## (9.3)   PDF p.221

分布归一化，紧接 (9.2) 之后。

```typst
$ mu(s) = frac(eta(s), sum_(s') eta(s')), quad "for all" s in cal(S). $ <eq-9-3>
```

## (9.4)   PDF p.223

随机梯度方法对 `v_pi (S_t)` 的平方误差取梯度下降的第一步。括号内的目标是平方误差，梯度算子作用在方括号上。

```typst
$ bold(w)_(t+1) ≐ bold(w)_t - frac(1, 2) alpha nabla [v_pi (S_t) - hat(v)(S_t, bold(w)_t)]^2 $ <eq-9-4>
```

## (9.5)   PDF p.223

(9.4) 的梯度展开。等号左端对齐。

```typst
$ = bold(w)_t + alpha [v_pi (S_t) - hat(v)(S_t, bold(w)_t)] nabla hat(v)(S_t, bold(w)_t), $ <eq-9-5>
```

## (9.6)   PDF p.223

多变量函数的梯度定义：偏导数向量加转置。省略号写成 `...`。

```typst
$ nabla f(bold(w)) ≐ ( frac(partial f(bold(w)), partial w_1), ..., frac(partial f(bold(w)), partial w_d) )^top . $ <eq-9-6>
```

## (9.7)   PDF p.224

一般的随机梯度下降更新，用样本目标 `U_t` 代替真值。

```typst
$ bold(w)_(t+1) ≐ bold(w)_t + alpha [U_t - hat(v)(S_t, bold(w)_t)] nabla hat(v)(S_t, bold(w)_t). $ <eq-9-7>
```

## (9.8)   PDF p.227

线性函数逼近的定义，两条等价写法。

```typst
$ hat(v)(s, bold(w)) ≐ bold(w)^top bold(x)(s) ≐ sum_(i=1)^d w_i x_i (s). $ <eq-9-8>
```

## (unnumbered p227-1)   PDF p.227

线性情形下梯度等于特征向量。

```typst
$ nabla hat(v)(s, bold(w)) = bold(x)(s). $
```

## (unnumbered p227-2)   PDF p.227

把 (9.8) 与上一条代入一般 SGD 更新 (9.7) 得到的线性 SGD 更新。

```typst
$ bold(w)_(t+1) ≐ bold(w)_t + alpha [U_t - hat(v)(S_t, bold(w)_t)] bold(x)(S_t). $
```

## (9.9)   PDF p.227

半梯度 TD(0) 的更新与其展开式，两行对齐。第一行把 `U_t` 取成 `R_(t+1) + gamma hat(v)(S_(t+1), bold(w)_t)` 后的形式；第二行把梯度与参数分离，注意 `bold(x)_t ( bold(x)_t - gamma bold(x)_(t+1) )^top` 这个外积的次序。

```typst
$ bold(w)_(t+1) &≐ bold(w)_t + alpha ( R_(t+1) + gamma bold(w)_t^top bold(x)_(t+1) - bold(w)_t^top bold(x)_t ) bold(x)_t \
                &= bold(w)_t + alpha ( R_(t+1) bold(x)_t - bold(x)_t ( bold(x)_t - gamma bold(x)_(t+1) )^top bold(w)_t ), $ <eq-9-9>
```

## (9.10)   PDF p.227

线性 TD(0) 的单步期望更新，`bold(b)` 与 `bold(A)` 的定义见 (9.11)。

```typst
$ bb(E)[bold(w)_(t+1) | bold(w)_t] = bold(w)_t + alpha (bold(b) - bold(A) bold(w)_t), $ <eq-9-10>
```

## (9.11)   PDF p.228

`bold(b)` 与 `bold(A)` 的定义，同一行展示，中间用 `"and"` 分隔；两个定义都标出所属集合。

```typst
$ bold(b) ≐ bb(E)[R_(t+1) bold(x)_t] in bb(R)^d quad "and" quad bold(A) ≐ bb(E)[ bold(x)_t ( bold(x)_t - gamma bold(x)_(t+1) )^top ] in bb(R)^(d×d) $ <eq-9-11>
```

## (9.12)   PDF p.228

TD 不动点方程的三步推导，三行对齐，第二、三行以 `arrow.r.double` 开头。

```typst
$ bold(b) - bold(A) bold(w)_"TD" &= bold(0) \
  arrow.r.double bold(b) &= bold(A) bold(w)_"TD" \
  arrow.r.double bold(w)_"TD" &≐ bold(A)^(-1) bold(b). $ <eq-9-12>
```

## (9.13)   PDF p.228

把 (9.11) 代入 (9.10) 得到的期望更新：参数更新是一个线性动力系统。

```typst
$ bb(E)[bold(w)_(t+1) | bold(w)_t] = (bold(I) - alpha bold(A)) bold(w)_t + alpha bold(b). $ <eq-9-13>
```

## (unnumbered p228-1)   PDF p.228

`bold(A)` 的展开推导，四行对齐，末行写成矩阵乘积 `bold(X)^top bold(D) (bold(I) - gamma bold(P)) bold(X)`。右端逗号收尾。

```typst
$ bold(A) &= sum_s mu(s) sum_a pi (a|s) sum_(r,s') p(r, s'|s, a) bold(x)(s) ( bold(x)(s) - gamma bold(x)(s') )^top \
          &= sum_s mu(s) sum_(s') p(s'|s) bold(x)(s) ( bold(x)(s) - gamma bold(x)(s') )^top \
          &= sum_s mu(s) bold(x)(s) ( bold(x)(s) - gamma sum_(s') p(s'|s) bold(x)(s') )^top \
          &= bold(X)^top bold(D) (bold(I) - gamma bold(P)) bold(X), $
```

该推导之后紧跟一行正文（不是展示式，`source.md` 里写成正文）：`where μ(s) is the stationary distribution under π, p(s′|s) is the probability of transition from s to s′ under policy π, P is the |S| × |S| matrix of these probabilities,`。

## (unnumbered p229-1)   PDF p.229

`bold(1)^top bold(D)(bold(I) - gamma bold(P))` 的化简，四行对齐，第三行末尾用括注说明用的是平稳分布性质。

```typst
$ bold(1)^top bold(D)(bold(I) - gamma bold(P)) &= bold(mu)^top (bold(I) - gamma bold(P)) \
                                               &= bold(mu)^top - gamma bold(mu)^top bold(P) \
                                               &= bold(mu)^top - gamma bold(mu)^top quad ("because" bold(mu) "is the stationary distribution") \
                                               &= (1 - gamma) bold(mu)^top, $
```

## (9.14)   PDF p.229

LSTD 之外线性 TD(0) 的收敛界：TD 不动点的 `overline("VE")` 不超过最优值的 `1/(1 - gamma)` 倍。

```typst
$ overline("VE")(bold(w)_"TD") ≤ frac(1, 1 - gamma) min_bold(w) overline("VE")(bold(w)). $ <eq-9-14>
```

## (9.15)   PDF p.231

n 步半梯度 TD 的更新，作用在 `bold(w)_(t+n-1)` 上，步号条件排在右侧。

```typst
$ bold(w)_(t+n) ≐ bold(w)_(t+n-1) + alpha [G_(t:t+n) - hat(v)(S_t, bold(w)_(t+n-1))] nabla hat(v)(S_t, bold(w)_(t+n-1)), quad 0 ≤ t < T, $ <eq-9-15>
```

## (9.16)   PDF p.231

目标回报 `G_(t:t+n)` 的定义：n 步实际奖励加末尾的自举估值。

```typst
$ G_(t:t+n) ≐ R_(t+1) + gamma R_(t+2) + ... + gamma^(n-1) R_(t+n) + gamma^n hat(v)(S_(t+n), bold(w)_(t+n-1)), quad 0 ≤ t ≤ T - n. $ <eq-9-16>
```

## (9.17)   PDF p.233

多项式基特征，排在浅色括注框内。等号是普通的 `=`（不是 `≐`），幂指部分写成 `s_j^(c_(i,j))`。

```typst
$ x_i (s) = product_(j=1)^k s_j^(c_(i,j)), $ <eq-9-17>
```

## (unnumbered p234-1)   PDF p.234

一维傅里叶余弦基特征，展示在正文段落之间，等号是普通的 `=`。

```typst
$ x_i (s) = cos(i pi s), quad s in [0, 1], $
```

## (9.18)   PDF p.234

多维傅里叶余弦基特征，排在浅色括注框内，紧跟其后的正文给出 `bold(c)^i` 与 `c_j^i` 的取值范围。

```typst
$ x_i (s) = cos ( pi bold(s)^top bold(c)^i ), $ <eq-9-18>
```

## (unnumbered p235-1)   PDF p.235

傅里叶特征的逐特征步长建议，行内展示式。

```typst
$ alpha_i = frac(alpha, sqrt((c_1^i)^2 + ... + (c_k^i)^2)) $
```

## (unnumbered p243-1)   PDF p.243

一维径向基函数（RBF）特征，展示式，等号是 `≐`，指数上的范数平方写成 `norm(s - c_i)^2`。

```typst
$ x_i (s) ≐ exp( - frac(norm(s - c_i)^2, 2 sigma_i^2) ). $
```

## (9.19)   PDF p.245

线性情形下手动选择步长参数的推荐值。

```typst
$ alpha ≐ (tau bb(E)[ bold(x)^top bold(x) ])^(-1), $ <eq-9-19>
```

## (unnumbered p250-1)   PDF p.250

引回 9.4 节的 TD 不动点，取没有编号的展示式。下一行给出 `bold(A)` 与 `bold(b)` 的定义（原文用 `"where"` 引出，`"and"` 分隔）。

```typst
$ bold(w)_"TD" = bold(A)^(-1) bold(b), $
```

## (unnumbered p250-2)   PDF p.250

上一行公式的说明行。

```typst
$ "where" bold(A) ≐ bb(E)[ bold(x)_t ( bold(x)_t - gamma bold(x)_(t+1) )^top ] quad "and" quad bold(b) ≐ bb(E)[ R_(t+1) bold(x)_t ]. $
```

## (9.20)   PDF p.250

LSTD 对 `bold(A)` 与 `bold(b)` 的样本估计，`+ epsilon bold(I)` 保证可逆。

```typst
$ hat(bold(A))_t ≐ sum_(k=0)^(t-1) bold(x)_k ( bold(x)_k - gamma bold(x)_(k+1) )^top + epsilon bold(I) quad "and" quad hat(bold(b))_t ≐ sum_(k=0)^(t-1) R_(k+1) bold(x)_k, $ <eq-9-20>
```

## (9.21)   PDF p.251

LSTD 对 TD 不动点的估计。

```typst
$ bold(w)_t ≐ hat(bold(A))_t^(-1) hat(bold(b))_t. $ <eq-9-21>
```

## (9.22)   PDF p.251

Sherman-Morrison 公式：逆矩阵的增量更新，两行对齐，第二行是大分式，分母里的点积写在 `1 +` 之后。

```typst
$ hat(bold(A))_t^(-1) &= ( hat(bold(A))_(t-1) + bold(x)_(t-1) ( bold(x)_(t-1) - gamma bold(x)_t )^top )^(-1) quad ("from" (9.20)) \
                       &= hat(bold(A))_(t-1)^(-1) - frac( hat(bold(A))_(t-1)^(-1) bold(x)_(t-1) ( bold(x)_(t-1) - gamma bold(x)_t )^top hat(bold(A))_(t-1)^(-1), 1 + ( bold(x)_(t-1) - gamma bold(x)_t )^top hat(bold(A))_(t-1)^(-1) bold(x)_(t-1) ), $ <eq-9-22>
```

## (9.23)   PDF p.254

基于记忆的函数逼近：从记忆库 `cal(D)` 中的样本加权平均。

```typst
$ hat(v)(s, cal(D)) = sum_(s' in cal(D)) k(s, s') g(s'). $ <eq-9-23>
```

## (9.24)   PDF p.255

线性参数化的核：两个特征向量的内积。

```typst
$ k(s, s') = bold(x)(s)^top bold(x)(s'). $ <eq-9-24>
```

## (9.25)   PDF p.256

带兴趣与强调的 n 步半梯度 TD 更新，比 (9.15) 多出强调因子 `M_t`。

```typst
$ bold(w)_(t+n) ≐ bold(w)_(t+n-1) + alpha M_t [G_(t:t+n) - hat(v)(S_t, bold(w)_(t+n-1))] nabla hat(v)(S_t, bold(w)_(t+n-1)), quad 0 ≤ t < T, $ <eq-9-25>
```

## (9.26)   PDF p.256

强调的递推定义（原书第二个展示式）。`t < 0` 时 `M_t ≐ 0` 写在正文里。

```typst
$ M_t = I_t + gamma^n M_(t-n), quad 0 ≤ t < T, $ <eq-9-26>
```

## 伪代码框内公式

框内的公式是行内公式（求和号与上下限排在符号右侧，与原书一致），因此写成 `$...$` 而不是 `$ ... $`；它们不带编号，`source.md` 的框里也没有占位符。赋值箭头一律写 `arrow.l`（原书为 `←`）；采样写 `$A tilde pi (dot.op | S)$`；无穷大写 `oo`；`≥`、`≠`、`→` 分别写 `>=`、`!=`、`->`；正文行内与框内的斜线除号都写 `slash`。

### PDF p.224 「Gradient Monte Carlo Algorithm for Estimating v̂ ≈ v_π」框

- 函数与参数：`$hat(v) : cal(S) × bb(R)^d -> bb(R)$`、`$alpha > 0$`
- 初始化：`$bold(w) in bb(R)^d$`、"e.g.," 后跟 `$bold(w) = bold(0)$`（`bold(0)` 是粗体零向量）
- 生成剧集：`$S_0, A_0, R_1, S_1, A_1, ..., R_T, S_T$`（用 `$pi$` 生成）
- 步号：`$t = 0, 1, ..., T - 1$`
- 更新（框内最后一行）：`$bold(w) arrow.l bold(w) + alpha [G_t - hat(v)(S_t, bold(w))] nabla hat(v)(S_t, bold(w))$`

### PDF p.225 「Semi-gradient TD(0) for estimating v̂ ≈ v_π」框

- 函数规格：`$hat(v) : cal(S)^+ × bb(R)^d -> bb(R)$`、`$hat(v)(italic("terminal"), dot.op) = 0$`
- 初始化：`$bold(w) in bb(R)^d$`、"e.g.," 后跟 `$bold(w) = bold(0)$`（`bold(0)` 是粗体零向量）
- 行为选择：`$A tilde pi (dot.op | S)$`
- 更新：`$bold(w) arrow.l bold(w) + alpha [R + gamma hat(v)(S', bold(w)) - hat(v)(S, bold(w))] nabla hat(v)(S, bold(w))$`
- 状态推进：`$S arrow.l S'$`
- 终止判据：`$S$` "is terminal"

### PDF p.231 「n-step semi-gradient TD for estimating v̂ ≈ v_π」框

- 函数规格与参数：`$hat(v) : cal(S)^+ × bb(R)^d -> bb(R)$`、`$alpha > 0$`、`$n$`（正整数）
- 存储说明：`$S_t$`、`$R_t$` 的索引取模 `$n + 1$`
- 初始化：`$S_0 != italic("terminal")$`、`$T arrow.l oo$`
- 步号与行为：`$t = 0, 1, 2, ...$`、`$t < T$`、`$pi (dot.op | S_t)$`
- 记录下一步：`$R_(t+1)$`、`$S_(t+1)$`；`$S_(t+1)$` 终止时 `$T arrow.l t + 1$`
- 待更新步号：`$tau arrow.l t - n + 1$`、`$tau >= 0$`
- 回报累加：`$G arrow.l sum_(i=tau+1)^(min(tau+n, T)) gamma^(i - tau - 1) R_i$`
- 自举项：`$tau + n < T$` 时 `$G arrow.l G + gamma^n hat(v)(S_(tau+n), bold(w))$`（右侧括注 `$(G_(tau:tau+n))$`）
- 更新：`$bold(w) arrow.l bold(w) + alpha [G - hat(v)(S_tau, bold(w))] nabla hat(v)(S_tau, bold(w))$`
- 终止判据：`$tau = T - 1$`

### PDF p.252 「LSTD for estimating v̂ = w^⊤x(·) ≈ v_π  (O(d²) version)」框

- 函数规格：`$bold(x) : cal(S)^+ -> bb(R)^d$`、`$bold(x)(italic("terminal")) = bold(0)$`
- 参数：`$epsilon > 0$`
- 初始化：`$hat(bold(A))^(-1) arrow.l epsilon^(-1) bold(I)$`（右端注 "A d × d matrix"）、`$hat(bold(b)) arrow.l bold(0)$`（右端注 "A d-dimensional vector"）
- 状态初始化：`$S$`、`$bold(x) arrow.l bold(x)(S)$`
- 行为选择与观测：`$A tilde pi (dot.op | S)$`、`$R$`、`$S'$`、`$bold(x)' arrow.l bold(x)(S')$`
- 中间量：`$bold(v) arrow.l hat(bold(A))^(-1)^top (bold(x) - gamma bold(x)')$`（原书把 `⊤` 标在 `Â⁻¹` 的右上角，转置作用在逆矩阵上；`bold(v)` 是粗体直立的 v，与 `bold(x)` 同规格）
- 逆矩阵增量更新：`$hat(bold(A))^(-1) arrow.l hat(bold(A))^(-1) - (hat(bold(A))^(-1) bold(x)) bold(v)^top slash (1 + bold(v)^top bold(x))$`（原书用斜线除号）
- 向量增量更新：`$hat(bold(b)) arrow.l hat(bold(b)) + R bold(x)$`
- 权重：`$bold(w) arrow.l hat(bold(A))^(-1) hat(bold(b))$`
- 状态推进：`$S arrow.l S'$`、`$bold(x) arrow.l bold(x)'$`
- 终止判据：`$S'$` "is terminal"

## 行内公式

只收录有结构或者容易写错的行内式。单字母变量（*s*、*a*、*r*、*α*、*γ*、*ε*、*θ*、*τ*、*λ*、*n*、*k*、*d*、*t*、*T*）与 `v_pi (s)`、`hat(v)(s, bold(w))`、`bold(w)^top bold(x)(s)` 这类贯穿全章的符号，写法见 `glossary/notation.typ`，不逐处重复。

### PDF p.219

- `$s mapsto u$`：一次更新的记号（`mapsto` 渲染 ↦，正文行内写成 *s* ↦ *u*）。
- `$S_t mapsto G_t$`、`$S_t mapsto R_(t+1) + gamma hat(v)(S_(t+1), bold(w)_t)$`、`$S_t mapsto G_(t:t+n)$`：三种预测方法的更新对象与目标。
- `$s mapsto bb(E)_pi [R_(t+1) + gamma hat(v)(S_(t+1), bold(w)_t) | S_t = s]$`：DP 策略评估的更新；期望的下标 π 写成 `bb(E)_pi`。
- `$bold(w) in bb(R)^d$`、`$d << |cal(S)|$`：权重向量与状态数的关系（`<<` 渲染 ≪）。

### PDF p.221

- `$mu(s) >= 0, sum_s mu(s) = 1$`：状态分布满足的条件。

### PDF p.223

- `$bold(w) ≐ (w_1, w_2, ..., w_d)^top$`：列向量写法。
- `$S_t mapsto v_pi (S_t)$`、`$U_t in bb(R)$`、`$S_t mapsto U_t$`：训练样例的记号。
- `$bb(E)[U_t | S_t = s] = v_pi (s)$`：无偏估计的定义。
- `$U_t ≐ G_t$`：蒙特卡洛目标。

### PDF p.225

- `$U_t ≐ R_(t+1) + gamma hat(v)(S_(t+1), bold(w))$`：半梯度 TD(0) 的目标（这里的 `bold(w)` 不带步号）。

### PDF p.226

- `$alpha = 2 times 10^(-5)$`：图 9.1 所用步长；乘号写 `times`。

### PDF p.227

- `$bold(x)(s) ≐ (x_1 (s), x_2 (s), ..., x_d (s))^top$`：特征向量的定义。
- `$x_i : cal(S) -> bb(R)$`：单个特征的函数类型。

### PDF p.229

- `$y^top bold(A) y > 0$`、`$bold(A)^(-1)$`：正定性的判据与逆矩阵。
- `$bold(D)(bold(I) - gamma bold(P))$`：正定性分析里的内层矩阵。
- `$|cal(S)| × |cal(S)|$`、`$|cal(S)| × d$`：矩阵尺寸；乘号写 `×`。

### PDF p.230

- `$U_t ≐ sum_a pi (a|S_t) sum_(s', r) p(s', r | S_t, a) [r + gamma hat(v)(s', bold(w)_t)]$`：线性半梯度 DP 的更新目标。

### PDF p.232–233

- `$bold(x)(s) = (s_1, s_2)^top$`、`$bold(x)(s) = (1, s_1, s_2, s_1 s_2)^top$`、`$bold(x)(s) = (1, s_1, s_2, s_1 s_2, s_1^2, s_2^2, s_1^2 s_2, s_1 s_2^2, s_1^2 s_2^2)^top$`：二维状态的多项式特征，从两维到四维再到九维。
- `$(n + 1)^k$`：k 维 n 阶多项式基的成员个数。

### PDF p.234

- `$bold(c)^i = (c_1^i, ..., c_k^i)^top$`、`$c_j^i in {0, ..., n}$`：傅里叶基的整数向量及其取值范围。
- `$s^top bold(c)^i$`：内积，为每个维度分配一个整数频率。
- `$(n + 1)^k$`：特征个数。

### PDF p.235

- `$alpha_i = alpha slash sqrt((c_1^i)^2 + dots.c + (c_k^i)^2)$`：逐特征步长；斜线除号写 `slash`，居中的三点省略号写 `dots.c`。`$alpha_i = alpha$` 是全部 `$c_j^i = 0$` 时的例外。

### PDF p.238

- `$alpha = 0.2 slash n$`：例题 9.3 的步长，n 是一次激活的特征数。

### PDF p.239

- `$4 × 4 × 4 = 64$`：图 9.9 例子中一个状态激活的特征总数。

### PDF p.240–242

- `$alpha = 1 slash n$`：单个 tiling 时的精确一次学习；`$hat(v)(s, bold(w)_(t+1)) = v$`：一次更新后的估计。
- `$alpha = 1 slash (10 n)$`：常用折中步长。
- `$n << d$`：活跃特征数与特征总数的关系。
- `$(1, 1)$`、`$(1, 3)$`、`$(1, 3, 5, 7, ..., 2 k - 1)$`：位移向量；`$n = 2^3 >= 4 k$`：图 9.11 下方的参数选择。
- `$(0, 0, 0)$`、`$(1, 3, 5)$`、`$(2, 6, 10)$`、`$(3, 9, 15)$`：三维情形前四个 tiling 的累计位移。

### PDF p.244

- `$alpha_t = 1 slash t$`：经典步长序列（本章不采用）。
- `$O(d^2)$`：最优矩阵步长的参数个数。
- `$alpha = 1$`、`$alpha = 1 slash 10$`、`$alpha = 1 slash 100$`、`$alpha = 1 slash tau$`：手动选择步长的经验序列。

### PDF p.245

- `$tau = 1$`、`$x(S_t)^top x(S_t) = bb(E)[bold(x)^top bold(x)]$`：练习 9.6 的前提条件。
- `(7 choose 2) = 21`、`$7 × 8 = 56$`、`$21 × 2 + 56 = 98$`：练习 9.5 的计数；二项式系数在原书里就印成文字 "(7 choose 2)"，若用数学排版写 `$binom(7, 2)$`。

### PDF p.246

- `$f(x) = 1 slash (1 + e^(-x))$`：logistic 激活函数。
- `$f(x) = max(0, x)$`：整流非线性。
- `$f(x) = 1$` 若 `$x >= theta$`，否则为 0：带阈值 θ 的阶跃函数。

### PDF p.249

- `$28 × 28$`、`$5 × 5$`、`$2 × 2$`、`$14 × 14$`：图 9.15 各特征图与感受野的尺寸。

### PDF p.250–251

- `$hat(v) = bold(w)_"TD"^top bold(x)(dot.op)$`：待估的线性值函数（`dot.op` 渲染 ·）。
- `$epsilon bold(I)$`、`$italic("t times") bold(A)$`、`$italic("t times") bold(b)$`：保证可逆的小项与量纲说明（`t times` 是斜体文字加直立体 A）。
- `$O(d)$`、`$O(d^2)$`、`$O(d^3)$`：各步骤的复杂度。
- `$hat(bold(A))_0 ≐ epsilon bold(I)$`、`$hat(bold(A))_t^(-1)$`：初始逆矩阵与随步维护的逆矩阵。

### PDF p.253

- `$s' mapsto g$`：记忆库中一条训练样例。

### PDF p.254

- `$k : bb(R) -> bb(R)$`、`$k : cal(S) × cal(S) -> bb(R)$`：核函数的两种类型。

### PDF p.255

- `$bold(x)(s) = (x_1 (s), x_2 (s), ..., x_d (s))^top$`：特征向量。

### PDF p.256

- `$M_t ≐ 0$`、`$G_(t:t+n) = G_t$`、`$n = T - t$`、`$M_t = I_t$`：蒙特卡洛情形的退化。

### PDF p.257–258

- `$bold(w) = (w_1, w_2)^top$`、`$bold(w)_infinity = (3.5, 1.5)$`、`$bold(w)_infinity = (4, 2)$`：例题 9.4 的参数向量与两种方法的收敛值。
- `$overline("VE")(bold(w))$`、`$v_(pi_bold(w)) (s)$`：摘要里出现的目标函数与带参数策略的值函数；正文行内写成 V̄Ē(w) 与 *v_{π_w}*(*s*)。

### PDF p.262

- `$O(log n)$`：k-d 树最近邻查找的平均时间。
