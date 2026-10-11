#import "../../template.typ": *

== 线性方法 <sec-9-4>

函数近似最重要的特例之一，是近似函数 $hat(v)(dot.op, bold(w))$ 为权重向量 $bold(w)$ 的线性函数的情形。对每个状态 $s$ 都对应一个实值向量 $bold(x)(s) ≐ (x_1 (s), x_2 (s), ..., x_d (s))^top$，其分量个数与 $bold(w)$ 相同。线性方法用 $bold(w)$ 与 $bold(x)(s)$ 的内积来近似状态值函数：

$ hat(v)(s, bold(w)) ≐ bold(w)^top bold(x)(s) ≐ sum_(i=1)^d w_i x_i (s). $ <eq-9-8>

此时称近似值函数是#ezh[权重的线性函数]，或简称#ezh[线性]的。

向量 $bold(x)(s)$ 称为表示状态 $s$ 的#ezh[特征向量]（feature vector）。$bold(x)(s)$ 的每个分量 $x_i (s)$ 都是函数 $x_i : cal(S) -> bb(R)$ 的一个取值。我们把#ezh[特征]看成其中一个函数的整体，并把它在某个状态 $s$ 处的取值称为 $s$ 的一个特征。对线性方法来说，特征是#ezh[基函数]（basis function），因为它们构成近似函数集合的一组线性基。构造 $d$ 维特征向量来表示状态，等同于选取一组 $d$ 个基函数。特征可以有许多不同的定义方式；接下来几节介绍其中几种可能。

在线性函数近似下使用 SGD 更新是很自然的。此时近似值函数对 $bold(w)$ 的梯度是

#{
  set math.equation(numbering: none)
  $ nabla hat(v)(s, bold(w)) = bold(x)(s). $
}

因此在线性情形下，一般 SGD 更新 @eq-9-7 化为一个特别简单的形式：

#{
  set math.equation(numbering: none)
  $ bold(w)_(t+1) ≐ bold(w)_t + alpha [U_t - hat(v)(S_t, bold(w)_t)] bold(x)(S_t). $
}

由于形式非常简单，线性 SGD 情形是最便于做数学分析的情形之一。各类学习系统中几乎所有有用的收敛结果都针对线性（或更简单）的函数近似方法。

特别地，在线性情形中只有一个最优（在退化情形中则只有一组同样好的最优），因此任何保证收敛到局部最优或接近局部最优的方法，都自动保证收敛到全局最优或接近全局最优。例如，如果按通常的条件随时间减小 $alpha$，上一节给出的梯度蒙特卡洛算法在线性函数近似下收敛到 $overline("VE")$ 的全局最优。

上一节给出的半梯度 TD(0) 算法在线性函数近似下也收敛，但这不能由关于 SGD 的一般结果推出，需要单独的定理。它收敛到的权重向量也不是全局最优，而是一个接近局部最优的点。更详细地考察这个重要情形很有用，我们具体考虑持续性情形。每个时刻 $t$ 的更新是

$ bold(w)_(t+1) &≐ bold(w)_t + alpha ( R_(t+1) + gamma bold(w)_t^top bold(x)_(t+1) - bold(w)_t^top bold(x)_t ) bold(x)_t \
                &= bold(w)_t + alpha ( R_(t+1) bold(x)_t - bold(x)_t ( bold(x)_t - gamma bold(x)_(t+1) )^top bold(w)_t ), $ <eq-9-9>

这里我们使用了记号简写 $bold(x)_t = bold(x)(S_t)$。一旦系统达到稳态，对任何给定的 $bold(w)_t$，下一个权重向量的期望可以写成

$ bb(E)[bold(w)_(t+1) | bold(w)_t] = bold(w)_t + alpha (bold(b) - bold(A) bold(w)_t), $ <eq-9-10>

其中

$ bold(b) ≐ bb(E)[R_(t+1) bold(x)_t] in bb(R)^d quad "and" quad bold(A) ≐ bb(E)[ bold(x)_t ( bold(x)_t - gamma bold(x)_(t+1) )^top ] in bb(R)^(d×d) $ <eq-9-11>

由 @eq-9-10 可以清楚地看出，如果系统收敛，就必然收敛到权重向量 $bold(w)_"TD"$，它满足

$ bold(b) - bold(A) bold(w)_"TD" &= bold(0) \
  arrow.r.double bold(b) &= bold(A) bold(w)_"TD" \
  arrow.r.double bold(w)_"TD" &≐ bold(A)^(-1) bold(b). $ <eq-9-12>

这个量称为#ezh[TD 不动点]。线性半梯度 TD(0) 实际上就收敛到这个点。证明它收敛以及上述逆矩阵存在的部分理论，见下面的方框。

#mathbox("线性 TD(0) 收敛性的证明")[
  线性 TD(0) 算法 @eq-9-9 的收敛性由哪些性质保证？把 @eq-9-10 改写成下面的形式，可以得到一些启示：

  $ bb(E)[bold(w)_(t+1) | bold(w)_t] = (bold(I) - alpha bold(A)) bold(w)_t + alpha bold(b). $ <eq-9-13>

  注意，矩阵 $bold(A)$ 乘的是权重向量 $bold(w)_t$，$bold(b)$ 不参与这个乘积；对收敛重要的只有 $bold(A)$。为了建立直觉，考虑 $bold(A)$ 是对角矩阵的特殊情形。如果任何对角元素为负，那么 $bold(I) - alpha bold(A)$ 的相应对角元素就会大于 1，$bold(w)_t$ 的相应分量会被放大，继续下去将导致发散。另一方面，如果 $bold(A)$ 的对角元素全部为正，就可以把 $alpha$ 取得小于其中最大者的倒数，使 $bold(I) - alpha bold(A)$ 是对角矩阵，且全部对角元素都在 0 与 1 之间。在这种情形下，更新式的第一项倾向于缩小 $bold(w)_t$，稳定性得到保证。一般地，只要 $bold(A)$ 是#ezh[正定]的，$bold(w)_t$ 就会被推向零；正定的含义是，对任何实向量 $bold(y) != bold(0)$ 都有 $bold(y)^top bold(A) bold(y) > 0$。正定性还保证逆 $bold(A)^(-1)$ 存在。

  对线性 TD(0)，在 $gamma < 1$ 的持续性情形中，$bold(A)$ 矩阵 @eq-9-11 可以写成

  #{
    set math.equation(numbering: none)
    $ bold(A) &= sum_s mu(s) sum_a pi (a|s) sum_(r,s') p(r, s'|s, a) bold(x)(s) ( bold(x)(s) - gamma bold(x)(s') )^top \
              &= sum_s mu(s) sum_(s') p(s'|s) bold(x)(s) ( bold(x)(s) - gamma bold(x)(s') )^top \
              &= sum_s mu(s) bold(x)(s) ( bold(x)(s) - gamma sum_(s') p(s'|s) bold(x)(s') )^top \
              &= bold(X)^top bold(D) (bold(I) - gamma bold(P)) bold(X), $
  }

  其中 $mu(s)$ 是 $pi$ 下的平稳分布，$p(s'|s)$ 是在策略 $pi$ 下从 $s$ 转移到 $s'$ 的概率，$bold(P)$ 是由这些概率组成的 $|cal(S)| × |cal(S)|$ 矩阵，$bold(D)$ 是以 $mu(s)$ 为对角元素的 $|cal(S)| × |cal(S)|$ 对角矩阵，$bold(X)$ 是以 $bold(x)(s)$ 为各行的 $|cal(S)| × d$ 矩阵。由此可以清楚地看到，内层矩阵 $bold(D)(bold(I) - gamma bold(P))$ 是判定 $bold(A)$ 正定性的关键。

  对这种形式的关键矩阵，如果它的各列之和都等于非负数，就保证了正定性。这一点由 Sutton（1988，第 27 页）基于此前已有的两个定理证明。一个定理说，任何矩阵 $bold(M)$ 正定当且仅当对称矩阵 $bold(S) = bold(M) + bold(M)^top$ 正定（Sutton，1988，附录）。第二个定理说，任何实对称矩阵 $bold(S)$ 正定，如果它的所有对角元素都为正，且大于相应非对角元素绝对值之和（Varga，1962，第 23 页）。对我们的关键矩阵 $bold(D)(bold(I) - gamma bold(P))$ 来说，对角元素为正而非对角元素为负，因此只需证明每一行之和与相应列之和的和为正。行和全部为正，因为 $bold(P)$ 是随机矩阵且 $gamma < 1$。于是只剩下证明列和非负。注意，任何矩阵 $bold(M)$ 的各列之和组成的行向量可以写成 $bold(1)^top bold(M)$，其中 $bold(1)$ 是所有分量都等于 1 的列向量。设 $bold(mu)$ 表示由 $mu(s)$ 组成的 $|cal(S)|$ 维向量；由于 $bold(mu)$ 是平稳分布，有 $bold(mu) = bold(P)^top bold(mu)$。于是我们的关键矩阵的列和是：

  #{
    set math.equation(numbering: none)
    $ bold(1)^top bold(D)(bold(I) - gamma bold(P)) &= bold(mu)^top (bold(I) - gamma bold(P)) \
                                                   &= bold(mu)^top - gamma bold(mu)^top bold(P) \
                                                   &= bold(mu)^top - gamma bold(mu)^top quad ("因为" bold(mu) "是平稳分布") \
                                                   &= (1 - gamma) bold(mu)^top, $
  }

  其中的全部分量都为正。于是关键矩阵与 $bold(A)$ 矩阵都正定，on-policy TD(0) 是稳定的。（要证明以概率 1 收敛，还需要额外的条件以及随时间减小 $alpha$ 的安排。）
]

在 TD 不动点处，还证明了（在持续性情形中）$overline("VE")$ 处于最低可能误差的一个有界倍数之内：

$ overline("VE")(bold(w)_"TD") ≤ frac(1, 1 - gamma) min_bold(w) overline("VE")(bold(w)). $ <eq-9-14>

也就是说，TD 方法的渐近误差不超过最小可能误差的 $1 slash (1 - gamma)$ 倍；这个最小可能误差是蒙特卡洛方法在极限中达到的。由于 $gamma$ 常常接近 1，这个放大倍数可能相当大，因此使用 TD 方法在渐近性能上可能有可观的损失。另一方面，回顾一下，与蒙特卡洛方法相比，TD 方法的方差往往大大减小，因而更快，正如我们在第 6 章与第 7 章看到的。哪种方法最好，取决于近似与问题的性质，以及学习持续多久。

与 @eq-9-14 类似的界也适用于其他 on-policy 自举方法。例如，按 on-policy 分布进行更新的线性半梯度 DP（@eq-9-7，其中 $U_t ≐ sum_a pi (a|S_t) sum_(s', r) p(s', r | S_t, a) [r + gamma hat(v)(s', bold(w)_t)]$）也会收敛到 TD 不动点。单步半梯度#ezh[动作值]方法，例如下一章要讲的半梯度 Sarsa(0)，收敛到一个类似的不动点，也有一个类似的界。对回合任务，有一个略有不同但相关的界（见 Bertsekas 与 Tsitsiklis，1996）。此外，对奖励、特征以及步长参数的递减还有若干技术性条件，我们在这里省略了。完整的细节见原始论文（Tsitsiklis 与 Van Roy，1997）。

这些收敛结果的关键在于状态按 on-policy 分布得到更新。对其他的更新分布，使用函数近似的自举方法实际上可能发散到无穷。这方面的例子以及对可能解决方法的讨论见第 11 章。

#example("1000 状态随机游走上的自举")[
  状态聚合是线性函数近似的一个特例，因此我们回到 1000 状态随机游走，来说明本章的一些观察。@fig-9-2 的左图给出了使用与例 9.1 相同的状态聚合时，半梯度 TD(0) 算法（原书第 203 页）学到的最终值函数。可以看到，接近渐近的 TD 近似确实比 @fig-9-1 所示的蒙特卡洛近似离真实值更远。

  不过，TD 方法在学习速度上仍有很大的潜在优势，并把蒙特卡洛方法推广了，正如我们在第 7 章用 $n$ 步 TD 方法充分考察过的那样。@fig-9-2 的右图给出了在 1000 状态随机游走上使用状态聚合的 $n$ 步半梯度 TD 方法的结果，它们与我们在表格型方法和 19 状态随机游走上早先得到的结果（图 7.2）惊人地相似。为了得到这种定量上相似的结果，我们把状态聚合改成了 20 组、每组 50 个状态。这 20 个组在数量上接近表格型问题的 19 个状态。特别地，回忆一下，状态转移最多可以向左或向右 100 个状态。那么一个典型的转移就是向左或向右 50 个状态，这在数量上类似于 19 状态表格型系统的单状态转移。为了与前面的结果完全对应，这里使用相同的性能度量，即对所有状态与前 10 个回合的 RMS 误差取未加权平均，而没有采用 $overline("VE")$ 目标，尽管在使用函数近似时后者本来更合适。

  #figure(
    image("../../assets/figures/ch09/fig-9-2.png", width: 100%),
    caption: [在 1000 状态随机游走任务上用状态聚合做自举。左：半梯度 TD 的渐近值比 @fig-9-1 中的渐近蒙特卡洛值差。右：使用状态聚合的 $n$ 步方法的性能与使用表格型表示时（参见图 7.2）惊人地相似。这些数据是 100 次运行的平均值。],
  )<fig-9-2>
]

上面例题中使用的半梯度 $n$ 步 TD 算法，是第 7 章给出的表格型 $n$ 步 TD 算法向半梯度函数近似的自然推广。伪代码见下面方框。

#algbox([估计 $hat(v) approx v_pi$ 的 $n$ 步半梯度 TD])[
  输入：待评估的策略 $pi$ \
  输入：可微函数 $hat(v) : cal(S)^+ × bb(R)^d -> bb(R)$，且满足 $hat(v)("terminal", dot.op) = 0$ \
  算法参数：步长 $alpha > 0$，一个正整数 $n$ \
  任意初始化值函数权重 $bold(w)$（例如 $bold(w) = bold(0)$）\
  全部的存储与访问操作（针对 $S_t$ 与 $R_t$）都可以对其下标取模 $n + 1$

  对每个回合循环：\
  #h(1.5em) 初始化并存储 $S_0 != "terminal"$ \
  #h(1.5em) $T arrow.l infinity$ \
  #h(1.5em) 对 $t = 0, 1, 2, dots.c$ 循环：\
  #h(3em) 若 $t < T$，则：\
  #h(4.5em) 根据 $pi (dot.op | S_t)$ 采取一个动作 \
  #h(4.5em) 观测下一个奖励与下一个状态，分别存储为 $R_(t+1)$ 与 $S_(t+1)$ \
  #h(4.5em) 若 $S_(t+1)$ 是终止状态，则 $T arrow.l t + 1$ \
  #h(3em) $tau arrow.l t - n + 1$　（$tau$ 是其状态的估计正在被更新的那个时刻）\
  #h(3em) 若 $tau >= 0$：\
  #h(4.5em) $G arrow.l sum_(i=tau+1)^(min(tau+n,T)) gamma^(i-tau-1) R_i$ \
  #h(4.5em) 若 $tau + n < T$，则 $G arrow.l G + gamma^n hat(v)(S_(tau+n), bold(w))$　（$G_(tau:tau+n)$）\
  #h(4.5em) $bold(w) arrow.l bold(w) + alpha [G - hat(v)(S_tau, bold(w))] nabla hat(v)(S_tau, bold(w))$ \
  #h(1.5em) 直到 $tau = T - 1$
]

这个算法的关键方程类似于第 7 章的公式 7.2，它是

$ bold(w)_(t+n) ≐ bold(w)_(t+n-1) + alpha [G_(t:t+n) - hat(v)(S_t, bold(w)_(t+n-1))] nabla hat(v)(S_t, bold(w)_(t+n-1)), quad 0 ≤ t < T, $ <eq-9-15>

其中 $n$ 步回报从第 7 章的公式 7.1 推广为

$ G_(t:t+n) ≐ R_(t+1) + gamma R_(t+2) + ... + gamma^(n-1) R_(t+n) + gamma^n hat(v)(S_(t+n), bold(w)_(t+n-1)), quad 0 ≤ t ≤ T - n. $ <eq-9-16>

#exercise("9.1")[证明本书第一部分介绍的那种表格型方法是线性函数近似的一个特例。此时特征向量是什么？]
