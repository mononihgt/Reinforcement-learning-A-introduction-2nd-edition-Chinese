#import "../../template.typ": *

== $n$ 步截断 $lambda$ 回报方法 <sec-12-3>

离线 $lambda$ 回报算法是一个重要的理想，但它的实用性有限，因为它使用的 $lambda$ 回报 @eq-12-2 直到回合结束才能知道。在持续性情形中，$lambda$ 回报在技术上永远无法知道，因为它依赖于任意大的 $n$ 的 $n$ 步回报，因而依赖于任意远的未来的奖励。然而，奖励延迟得越久，这种依赖就越弱，每延迟一步就衰减 $gamma lambda$。于是，一种自然的近似做法是经过若干步之后把序列截断。我们已有的 $n$ 步回报概念提供了一种自然的实现方式：缺失的奖励用估计值来代替。

一般地，对时间 $t$，只给定截至某个更晚视界 $h$ 的数据，我们这样定义#ezh[截断 $lambda$ 回报]：

$ G_(t:h)^lambda ≐ (1 - lambda) sum_(n=1)^(h-t-1) lambda^(n-1) G_(t:t+n) + lambda^(h-t-1) G_(t:h), quad 0 <= t < h <= T. $ <eq-12-9>

把这个方程与 $lambda$ 回报 @eq-12-3 比较一下，显然视界 $h$ 扮演的角色与先前 $T$（终止时刻）所扮演的角色相同。$lambda$ 回报中有一份剩余权重给了常规回报 $G_t$，这里则给了可用的最长 $n$ 步回报 $G_(t:h)$（@fig-12-2）。

截断 $lambda$ 回报立刻产生一族 $n$ 步 $lambda$ 回报算法，与第 7 章的 $n$ 步方法类似。在所有这些算法中，更新都延迟 $n$ 步进行，并且只考虑前 $n$ 个奖励，但现在 $1 <= k <= n$ 的全部 $k$ 步回报都被纳入（早先的 $n$ 步算法只使用 $n$ 步回报），并按 @fig-12-2 那样做几何加权。在状态值情形中，这一族算法称为截断 TD($lambda$)，即 TTD($lambda$)。@fig-12-7 所示的复合回溯图与 TD($lambda$) 的复合回溯图（@fig-12-1）类似，区别在于最长的分量更新至多 $n$ 步，不会总是走到回合结束。

#figure(
  image("../../assets/figures/ch12/fig-12-7.png", width: 99%),
  caption: [截断 TD($lambda$) 的回溯图。],
)<fig-12-7>

TTD($lambda$) 由下式定义（参见第 9 章的公式 9.15）：

#{
  set math.equation(numbering: none)
  $ bold(w)_(t+n) ≐ bold(w)_(t+n-1) + alpha [G_(t:t+n)^lambda - hat(v)(S_t, bold(w)_(t+n-1))] nabla hat(v)(S_t, bold(w)_(t+n-1)), quad 0 <= t < T. $
}

这个算法可以高效地实现，使每一步的计算量不随 $n$ 增长（当然，内存必须随 $n$ 增长）。与 $n$ 步 TD 方法很相似，在每个回合的前 $n - 1$ 个时间步上不做更新，并在终止时额外做 $n - 1$ 次更新。高效实现依赖于这样的事实：$k$ 步 $lambda$ 回报可以精确地写成

$ G_(t:t+k)^lambda = hat(v)(S_t, bold(w)_(t-1)) + sum_(i=t)^(t+k-1) (gamma lambda)^(i-t) delta'_i, $ <eq-12-10>

其中

#{
  set math.equation(numbering: none)
  $ delta'_t ≐ R_(t+1) + gamma hat(v)(S_(t+1), bold(w)_t) - hat(v)(S_t, bold(w)_(t-1)). $
}

#exercise("12.5")[在本书中我们已经多次（常常是在练习里）确认，如果值函数保持不变，回报就可以写成 TD 误差之和。@eq-12-10 为什么是这件事的又一个实例？请证明 @eq-12-10。]
