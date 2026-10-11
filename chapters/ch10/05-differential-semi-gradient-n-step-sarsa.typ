#import "../../template.typ": *

== 微分半梯度 $n$ 步 Sarsa <sec-10-5>

为了推广到 $n$ 步自举，我们需要 TD 误差的 $n$ 步版本。先把 $n$ 步回报（第 7 章的公式 7.4）推广到带函数近似的微分形式：

$ G_(t:t+n) ≐ R_(t+1) - overline(R)_(t+n-1) + dots.c + R_(t+n) - overline(R)_(t+n-1) + hat(q)(S_(t+n), A_(t+n), bold(w)_(t+n-1)), $ <eq-10-14>

其中 $overline(R)$ 是 $r(pi)$ 的估计，$n >= 1$，$t + n < T$。若 $t + n >= T$，则照例定义 $G_(t:t+n) ≐ G_t$。$n$ 步 TD 误差则是

$ delta_t ≐ G_(t:t+n) - hat(q)(S_t, A_t, bold(w)), $ <eq-10-15>

此后就可以应用我们通常的半梯度 Sarsa 更新式 @eq-10-12。完整算法的伪代码见方框。

#algbox([估计 $hat(q) approx q_pi$ 或 $q_*$ 的微分半梯度 $n$ 步 Sarsa])[
  输入：一个可微的动作值函数参数化形式 $hat(q) : cal(S) × cal(A) × bb(R)^d -> bb(R)$，一个策略 $pi$ \
  任意初始化值函数权重 $bold(w) in bb(R)^d$（例如 $bold(w) = bold(0)$）\
  任意初始化平均奖励估计 $overline(R) in bb(R)$（例如 $overline(R) = 0$）\
  算法参数：步长 $alpha, beta > 0$，小量 $epsilon > 0$，一个正整数 $n$ \
  全部存储与访问操作（对 $S_t$、$A_t$ 与 $R_t$）都可以对其下标取模 $n + 1$

  初始化并存储 $S_0$ 与 $A_0$ \
  对每一步循环，$t = 0, 1, 2, dots.c$：\
  #h(1.5em) 采取动作 $A_t$ \
  #h(1.5em) 观测下一个奖励与下一个状态，分别存储为 $R_(t+1)$ 与 $S_(t+1)$ \
  #h(1.5em) 选择并存储一个动作 $A_(t+1) tilde pi (dot.op | S_(t+1))$，或关于 $hat(q)(S_(t+1), dot.op, bold(w))$ 的 ε-greedy 动作 \
  #h(1.5em) $tau arrow.l t - n + 1$　（$tau$ 是其估计正在被更新的那个时刻）\
  #h(1.5em) 若 $tau >= 0$：\
  #h(3em) $delta arrow.l sum_(i=tau+1)^(tau+n) (R_i - overline(R)) + hat(q)(S_(tau+n), A_(tau+n), bold(w)) - hat(q)(S_tau, A_tau, bold(w))$ \
  #h(3em) $overline(R) arrow.l overline(R) + beta delta$ \
  #h(3em) $bold(w) arrow.l bold(w) + alpha delta nabla hat(q)(S_tau, A_tau, bold(w))$
]

#exercise("10.9")[在微分半梯度 $n$ 步 Sarsa 算法中，平均奖励上的步长参数 $beta$ 需要相当小，这样 $overline(R)$ 才能成为平均奖励的良好长期估计。遗憾的是，这样一来 $overline(R)$ 在很长的时期内都会受其初始值的影响而带有偏差，这可能使学习效率低下。另一种做法是对观测到的奖励使用样本平均作为 $overline(R)$。它会在一开始迅速适应，但从长远来看也会适应得很慢。随着策略缓慢变化，$overline(R)$ 也会变化；这种长期非平稳的可能性使样本平均方法不合适。事实上，平均奖励上的步长参数正是使用练习 2.7 中无偏的常数步长技巧的绝佳位置。请描述为了使用这个技巧，微分半梯度 $n$ 步 Sarsa 的方框算法需要作哪些具体的改动。]
