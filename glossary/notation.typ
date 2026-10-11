#import "../template.typ": *

#plain-chapter("符号表", en: "Summary of Notation")

大写字母用于随机变量，小写字母用于随机变量的取值与标量函数。要求取实数值的量用粗体小写字母书写，即使它是随机变量。矩阵用粗体大写字母书写。

#grid(
  columns: (auto, 1fr),
  column-gutter: 1.8em,
  // 0.42em 时带上下标的公式（如 ‖v‖²_μ）会溢出到下一行。在 book 上下文里
  // 行高算不足，只有加大行距能隔开，已逐行核对过全表。
  row-gutter: 0.9em,
  // 不能用 left + horizon：带上下标的公式（如 ‖v‖²_μ）在 horizon 对齐下会使
  // 行高算不足，下标溢出压到下一行。plain left 让行高按内容实际高度计算。
  align: (left, left),

  $≐$, [定义为真的相等关系],
  $approx$, [近似等于],
  $prop$, [正比于],
  $"Pr"{X = x}$, [随机变量 $X$ 取值 $x$ 的概率],
  $X tilde p$, [随机变量 $X$ 取自分布 $p(x) ≐ "Pr"{X = x}$],
  $bb(E)[X]$, [随机变量 $X$ 的期望，即 $bb(E)[X] ≐ sum_x p(x) x$],
  $"arg max"_a f(a)$, [使 $f(a)$ 取到最大值的 $a$ 的取值],
  $ln x$, [$x$ 的自然对数],
  $e^x, "exp"(x)$, [自然对数的底 $e approx 2.71828$ 的 $x$ 次幂；$e^(ln x) = x$],
  $bb(R)$, [实数集合],
  $f : cal(X) -> cal(Y)$, [从集合 $cal(X)$ 的元素到集合 $cal(Y)$ 的元素的函数 $f$],
  $arrow.l$, [赋值],
  $(a, b]$, [$a$ 与 $b$ 之间的实数区间，包含 $b$ 但不包含 $a$],

  grid.cell(colspan: 2, inset: (y: 0.35em))[],

  $epsilon$, [$epsilon$-greedy 策略中采取随机动作的概率],
  $alpha, beta$, [步长参数],
  $gamma$, [折扣率参数],
  $lambda$, [资格迹的衰减率参数],
  $bb(1)_"predicate"$, [指示函数，当 $"predicate"$ 为真时 $bb(1)_"predicate" ≐ 1$，否则为 $0$],

  grid.cell(colspan: 2, inset: (y: 0.35em))[],

  grid.cell(colspan: 2)[多臂赌博机问题中：],
  $k$, [动作（臂）的个数],
  $t$, [离散时间步或博弈次数],
  $q_* (a)$, [动作 $a$ 的真实值（期望奖励）],
  $Q_t (a)$, [时刻 $t$ 对 $q_* (a)$ 的估计],
  $N_t (a)$, [时刻 $t$ 之前动作 $a$ 被选择的次数],
  $H_t (a)$, [时刻 $t$ 选择动作 $a$ 的习得偏好],
  $pi_t (a)$, [时刻 $t$ 选择动作 $a$ 的概率],
  $overline(R)_t$, [时刻 $t$ 对给定 $pi_t$ 时期望奖励的估计],

  grid.cell(colspan: 2, inset: (y: 0.35em))[],

  grid.cell(colspan: 2)[马尔可夫决策过程（MDP）中：],
  $s, s'$, [状态],
  $a$, [一个动作],
  $r$, [一个奖励],
  $cal(S)$, [所有非终止状态的集合],
  $cal(S)^+$, [所有状态的集合，包含终止状态],
  $cal(A)(s)$, [状态 $s$ 中可用的所有动作的集合],
  $cal(R)$, [所有可能奖励的集合，是 $bb(R)$ 的有限子集],
  $subset$, [子集，例如 $cal(R) subset bb(R)$],
  $in$, [属于，例如 $s in cal(S)$，$r in cal(R)$],
  $|cal(S)|$, [集合 $cal(S)$ 的元素个数],

  grid.cell(colspan: 2, inset: (y: 0.35em))[],

  $t$, [离散时间步],
  $T, T(t)$, [一个回合的最终时间步，或包含时间步 $t$ 的那个回合的最终时间步],
  $A_t$, [时刻 $t$ 的动作],
  $S_t$, [时刻 $t$ 的状态，通常由 $S_(t-1)$ 与 $A_(t-1)$ 随机决定],
  $R_t$, [时刻 $t$ 的奖励，通常由 $S_(t-1)$ 与 $A_(t-1)$ 随机决定],
  $pi$, [策略（决策规则）],
  $pi(s)$, [确定性策略 $pi$ 下在状态 $s$ 采取的动作],
  $pi(a|s)$, [随机策略 $pi$ 下在状态 $s$ 采取动作 $a$ 的概率],

  grid.cell(colspan: 2, inset: (y: 0.35em))[],

  $G_t$, [时刻 $t$ 之后的回报],
  $h$, [视界，前向视角中向前看到的时间步],
  $G_(t:t+n), G_(t:h)$, [从 $t+1$ 到 $t+n$ 或到 $h$ 的 $n$ 步回报（折扣并修正）],
  $overline(G)_(t:h)$, [从 $t+1$ 到 $h$ 的平坦回报（不折扣也不修正）（第 5.8 节）],
  $G_t^lambda$, [$lambda$ 回报（第 12.1 节）],
  $G_(t:h)^lambda$, [截断并修正的 $lambda$ 回报（第 12.3 节）],
  $G_t^(lambda s), G_t^(lambda a)$, [按估计的状态值或动作值修正的 $lambda$ 回报（第 12.8 节）],

  grid.cell(colspan: 2, inset: (y: 0.35em))[],

  $p(s', r | s, a)$, [从状态 $s$ 采取动作 $a$ 转移到状态 $s'$ 并得到奖励 $r$ 的概率],
  $p(s' | s, a)$, [从状态 $s$ 采取动作 $a$ 转移到状态 $s'$ 的概率],
  $r(s, a)$, [状态 $s$ 采取动作 $a$ 后的期望立即奖励],
  $r(s, a, s')$, [动作 $a$ 下从 $s$ 转移到 $s'$ 的期望立即奖励],

  grid.cell(colspan: 2, inset: (y: 0.35em))[],

  $v_pi (s)$, [策略 $pi$ 下状态 $s$ 的值（期望回报）],
  $v_* (s)$, [最优策略下状态 $s$ 的值],
  $q_pi (s, a)$, [策略 $pi$ 下在状态 $s$ 采取动作 $a$ 的值],
  $q_* (s, a)$, [最优策略下在状态 $s$ 采取动作 $a$ 的值],

  grid.cell(colspan: 2, inset: (y: 0.35em))[],

  $V, V_t$, [状态值函数 $v_pi$ 或 $v_*$ 的数组估计],
  $Q, Q_t$, [动作值函数 $q_pi$ 或 $q_*$ 的数组估计],
  $overline(V)_t (s)$, [期望的近似动作值，例如 $overline(V)_t (s) ≐ sum_a pi(a|s) Q_t (s, a)$],
  $U_t$, [时刻 $t$ 估计的目标],

  grid.cell(colspan: 2, inset: (y: 0.35em))[],

  $delta_t$, [时刻 $t$ 的时序差分（TD）误差（随机变量）（第 6.1 节）],
  $delta_t^s, delta_t^a$, [TD 误差的状态特定形式与动作特定形式（第 12.9 节）],
  $n$, [$n$ 步方法中自举的步数],

  grid.cell(colspan: 2, inset: (y: 0.35em))[],

  $d$, [维度，即 $bold(w)$ 的分量个数],
  $d'$, [另一个维度，即 $bold(theta)$ 的分量个数],
  $bold(w), bold(w)_t$, [近似值函数所依据的权重的 $d$ 维向量],
  $w_i, w_(t,i)$, [可学习权重向量的第 $i$ 个分量],
  $hat(v)(s, bold(w))$, [给定权重向量 $bold(w)$ 时状态 $s$ 的近似值],
  $v_bold(w)(s)$, [$hat(v)(s, bold(w))$ 的另一种记法],
  $hat(q)(s, a, bold(w))$, [给定权重向量 $bold(w)$ 时状态动作对 $s, a$ 的近似值],
  $nabla hat(v)(s, bold(w))$, [$hat(v)(s, bold(w))$ 关于 $bold(w)$ 的偏导数构成的列向量],
  $nabla hat(q)(s, a, bold(w))$, [$hat(q)(s, a, bold(w))$ 关于 $bold(w)$ 的偏导数构成的列向量],

  grid.cell(colspan: 2, inset: (y: 0.35em))[],

  $bold(x)(s)$, [处于状态 $s$ 时可见的特征向量],
  $bold(x)(s, a)$, [在状态 $s$ 采取动作 $a$ 时可见的特征向量],
  $x_i (s), x_i (s, a)$, [向量 $bold(x)(s)$ 或 $bold(x)(s, a)$ 的第 $i$ 个分量],
  $bold(x)_t$, [$bold(x)(S_t)$ 或 $bold(x)(S_t, A_t)$ 的简写],
  $bold(w)^top bold(x)$, [向量的内积，$bold(w)^top bold(x) ≐ sum_i w_i x_i$，例如 $hat(v)(s, bold(w)) ≐ bold(w)^top bold(x)(s)$],
  $bold(v), bold(v)_t$, [用于学习 $bold(w)$ 的次 $d$ 维权重向量（第 11 章）],
  $bold(z)_t$, [时刻 $t$ 的资格迹 $d$ 维向量（第 12 章）],

  grid.cell(colspan: 2, inset: (y: 0.35em))[],

  $bold(theta), bold(theta)_t$, [目标策略的参数向量（第 13 章）],
  $pi(a | s, bold(theta))$, [给定参数向量 $bold(theta)$ 时在状态 $s$ 采取动作 $a$ 的概率],
  $pi_bold(theta)$, [参数 $bold(theta)$ 对应的策略],
  $nabla pi(a | s, bold(theta))$, [$pi(a | s, bold(theta))$ 关于 $bold(theta)$ 的偏导数构成的列向量],
  $J(bold(theta))$, [策略 $pi_bold(theta)$ 的性能度量],
  $nabla J(bold(theta))$, [$J(bold(theta))$ 关于 $bold(theta)$ 的偏导数构成的列向量],
  $h(s, a, bold(theta))$, [基于 $bold(theta)$ 在状态 $s$ 选择动作 $a$ 的偏好],

  grid.cell(colspan: 2, inset: (y: 0.35em))[],

  $b(a | s)$, [学习目标策略 $pi$ 时用于选择动作的行为策略],
  $b(s)$, [策略梯度方法的基线函数 $b : cal(S) arrow.r bb(R)$],
  $b$, [MDP 或搜索树的分支因子],
  $rho_(t:h)$, [从时刻 $t$ 到时刻 $h$ 的重要性采样率（第 5.5 节）],
  $rho_t$, [仅时刻 $t$ 的重要性采样率，$rho_t ≐ rho_(t:t)$],
  $r(pi)$, [策略 $pi$ 的平均奖励（奖励率）（第 10.3 节）],
  $overline(R)_t$, [时刻 $t$ 对 $r(pi)$ 的估计],

  grid.cell(colspan: 2, inset: (y: 0.35em))[],

  $mu(s)$, [状态上的 on-policy 分布（第 9.2 节）],
  $bold(mu)$, [所有 $s in cal(S)$ 的 $mu(s)$ 构成的 $|cal(S)|$ 维向量],
  $norm(v)_mu^2$, [值函数 $v$ 的 $mu$ 加权平方范数，即 $norm(v)_mu^2 ≐ sum_(s in cal(S)) mu(s) v(s)^2$],
  $eta(s)$, [每个回合访问状态 $s$ 的期望次数（原书第 199 页）],
  $Pi$, [值函数的投影算子（原书第 268 页）],
  $B_pi$, [值函数的贝尔曼算子（第 11.4 节）],

  grid.cell(colspan: 2, inset: (y: 0.35em))[],

  $bold(A)$, [$d times d$ 矩阵 $bold(A) ≐ bb(E)[bold(x)_t (bold(x)_t - gamma bold(x)_(t+1))^top]$],
  $bold(b)$, [$d$ 维向量 $bold(b) ≐ bb(E)[R_(t+1) bold(x)_t]$],
  $bold(w)_"TD"$, [TD 不动点 $bold(w)_"TD" ≐ bold(A)^(-1) bold(b)$，一个 $d$ 维向量（第 9.4 节）],
  $bold(I)$, [单位矩阵],
  $bold(P)$, [$pi$ 下状态转移概率的 $|cal(S)| times |cal(S)|$ 矩阵],
  $bold(D)$, [对角线为 $bold(mu)$ 的 $|cal(S)| times |cal(S)|$ 对角矩阵],
  $bold(X)$, [以 $bold(x)(s)$ 为行的 $|cal(S)| times d$ 矩阵],

  grid.cell(colspan: 2, inset: (y: 0.35em))[],

  $overline(delta)_bold(w)(s)$, [状态 $s$ 处 $v_bold(w)$ 的贝尔曼误差（期望 TD 误差）（第 11.4 节）],
  $overline(delta)_bold(w), "BE"$, [分量为 $overline(delta)_bold(w)(s)$ 的贝尔曼误差向量],
  $overline("VE")(bold(w))$, [均方值误差 $overline("VE")(bold(w)) ≐ norm(v_bold(w) - v_pi)_mu^2$（第 9.2 节）],
  $overline("BE")(bold(w))$, [均方贝尔曼误差 $overline("BE")(bold(w)) ≐ norm(overline(delta)_bold(w))_mu^2$],
  $overline("PBE")(bold(w))$, [均方投影贝尔曼误差 $overline("PBE")(bold(w)) ≐ norm(Pi overline(delta)_bold(w))_mu^2$],
  $overline("TDE")(bold(w))$, [均方时序差分误差 $overline("TDE")(bold(w)) ≐ bb(E)_b [rho_t delta_t^2]$（第 11.5 节）],
  $overline("RE")(bold(w))$, [均方回报误差（第 11.6 节）],
)
