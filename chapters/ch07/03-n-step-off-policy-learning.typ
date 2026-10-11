#import "../../template.typ": *

== $n$ 步 off-policy 学习 <sec-7-3>

回忆一下，off-policy 学习是在遵循另一个策略 $b$ 的同时，学习一个策略 $pi$ 的值函数。$pi$ 常常是当前动作值函数估计的贪婪策略，而 $b$ 是一个更具探索性（exploratory）的策略，也许是 $epsilon$-greedy。为了利用来自 $b$ 的数据，我们必须考虑两个策略之间的差异，用到它们采取所取动作的相对概率（见第 5.5 节）。在 $n$ 步方法中，回报是在 $n$ 步上构造的，因此我们关心的是这 $n$ 个动作的相对概率。例如，要做出 $n$ 步 TD 的一个简单 off-policy 版本，对时刻 $t$ 的更新（实际在时刻 $t + n$ 进行）只需用 $rho_(t:t+n-1)$ 加权：

$ V_(t+n) (S_t) ≐ V_(t+n-1) (S_t) + alpha rho_(t:t+n-1) [G_(t:t+n) - V_(t+n-1) (S_t)], quad 0 <= t < T, $ <eq-7-9>

其中 $rho_(t:t+n-1)$ 称为#ezh[重要性采样率]（importance sampling ratio），它是在两个策略下采取从 $A_t$ 到 $A_(t+n-1)$ 这 $n$ 个动作的相对概率（参见第 5 章的公式 5.3）：

$ rho_(t:h) ≐ product_(k=t)^(min(h,T-1)) frac(pi (A_k|S_k), b(A_k|S_k)). $ <eq-7-10>

例如，如果其中任何一个动作永远不会被 $pi$ 采取（即 $pi (A_k|S_k) = 0$），那么这个 $n$ 步回报的权值就应当取零，被完全忽略。另一方面，如果碰巧采取了一个 $pi$ 采取概率远大于 $b$ 的动作，那么这会增大本来要赋给该回报的权值。这样做是有道理的，因为这个动作是 $pi$ 的特征（因此我们希望学到关于它的信息），但它很少被 $b$ 选中，因而很少出现在数据中。为了弥补这一点，当它出现时我们必须对它加权过度。注意，如果两个策略实际上相同（即 on-policy 情形），那么重要性采样率总是 1。因此我们的新更新 @eq-7-9 更具一般性，可以完全取代早先的 $n$ 步 TD 更新。类似地，我们之前的 $n$ 步 Sarsa 更新也可以完全被一个简单的 off-policy 形式取代：

$ Q_(t+n) (S_t, A_t) ≐ Q_(t+n-1) (S_t, A_t) + alpha rho_(t+1:t+n) [G_(t:t+n) - Q_(t+n-1) (S_t, A_t)], $ <eq-7-11>

对 $0 <= t < T$。注意，这里的重要性采样率比 $n$ 步 TD @eq-7-9 的起点与终点都晚一步。这是因为此处更新的是一个状态–动作对。我们不必关心选中该动作的可能性有多大；既然已经选中了它，我们就希望完全从随后发生的事情中学习，重要性采样只用在其后的动作上。完整算法的伪代码在下面的方框中给出。

#algbox([off-policy $n$ 步 Sarsa，用于估计 $Q approx q_*$ 或 $q_pi$])[
  输入：一个任意的行为策略 $b$，满足对全部的 $s in cal(S)$、$a in cal(A)$ 都有 $b(a|s) > 0$ \
  对全部的 $s in cal(S)$、$a in cal(A)$，把 $Q(s, a)$ 初始化为任意值 \
  把 $pi$ 初始化为相对于 $Q$ 的贪婪策略，或者初始化为一个给定的固定策略 \
  算法参数：步长 $alpha in (0, 1]$，一个正整数 $n$ \
  全部的存储与访问操作（针对 $S_t$、$A_t$ 与 $R_t$）都可以对其下标取模 $n + 1$

  对每个回合循环：\
  #h(1.5em) 初始化并存储 $S_0 != "terminal"$ \
  #h(1.5em) 选择并存储一个动作 $A_0 tilde b(dot.op | S_0)$ \
  #h(1.5em) $T arrow.l infinity$ \
  #h(1.5em) 对 $t = 0, 1, 2, dots.c$ 循环：\
  #h(3em) 若 $t < T$，则：\
  #h(4.5em) 采取动作 $A_t$ \
  #h(4.5em) 观测下一个奖励与下一个状态，分别存储为 $R_(t+1)$ 与 $S_(t+1)$ \
  #h(4.5em) 若 $S_(t+1)$ 是终止状态，则：\
  #h(6em) $T arrow.l t + 1$ \
  #h(4.5em) 否则：\
  #h(6em) 选择并存储一个动作 $A_(t+1) tilde b(dot.op | S_(t+1))$ \
  #h(3em) $tau arrow.l t - n + 1$　（$tau$ 是其估计正在被更新的那个时刻）\
  #h(3em) 若 $tau >= 0$：\
  #h(4.5em) $rho arrow.l product_(i=tau+1)^(min(tau+n,T-1)) frac(pi (A_i|S_i), b(A_i|S_i))$#h(1fr)（$rho_(tau+1:tau+n)$）\
  #h(4.5em) $G arrow.l sum_(i=tau+1)^(min(tau+n,T)) gamma^(i-tau-1) R_i$ \
  #h(4.5em) 若 $tau + n < T$，则 $G arrow.l G + gamma^n Q(S_(tau+n), A_(tau+n))$#h(1fr)（$G_(tau:tau+n)$）\
  #h(4.5em) $Q(S_tau, A_tau) arrow.l Q(S_tau, A_tau) + alpha rho [G - Q(S_tau, A_tau)]$ \
  #h(4.5em) 若 $pi$ 正在被学习，则确保 $pi (dot.op | S_tau)$ 是相对于 $Q$ 的贪婪策略 \
  #h(1.5em) 直到 $tau = T - 1$
]

$n$ 步 Expected Sarsa 的 off-policy 版本与上面的 $n$ 步 Sarsa 更新相同，只是重要性采样率少一个因子。也就是说，上面那个方程以 $rho_(t+1:t+n-1)$ 取代 $rho_(t+1:t+n)$，当然还会使用 Expected Sarsa 版本的 $n$ 步回报 @eq-7-7。这是因为在 Expected Sarsa 中，最后一个状态把所有可能的动作都考虑在内；实际采取的那个动作没有影响，不需要对它作出修正。
