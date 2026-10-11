#import "../../template.typ": *

== 半梯度 $n$ 步 Sarsa <sec-10-2>

把 $n$ 步回报用作半梯度 Sarsa 更新式 @eq-10-1 中的更新目标，就可以得到回合式半梯度 Sarsa 的 $n$ 步版本。$n$ 步回报从它的表格型形式（第 7 章的公式 7.4）直接推广到函数近似形式：

$ G_(t:t+n) ≐ R_(t+1) + gamma R_(t+2) + dots.c + gamma^(n-1) R_(t+n) + gamma^n hat(q)(S_(t+n), A_(t+n), bold(w)_(t+n-1)), quad t + n < T, $ <eq-10-4>

其中照例在 $t + n >= T$ 时取 $G_(t:t+n) ≐ G_t$。$n$ 步更新式是

$ bold(w)_(t+n) ≐ bold(w)_(t+n-1) + alpha [G_(t:t+n) - hat(q)(S_t, A_t, bold(w)_(t+n-1))] nabla hat(q)(S_t, A_t, bold(w)_(t+n-1)), quad 0 <= t < T. $ <eq-10-5>

完整的伪代码见下面的方框。

#algbox([估计 $hat(q) approx q_*$ 或 $q_pi$ 的回合式半梯度 $n$ 步 Sarsa])[
  输入：可微的动作值函数参数化形式 $hat(q) : cal(S) × cal(A) × bb(R)^d -> bb(R)$ \
  输入：一个策略 $pi$（如果估计的是 $q_pi$）\
  算法参数：步长 $alpha > 0$，小量 $epsilon > 0$，一个正整数 $n$ \
  任意初始化值函数权重 $bold(w) in bb(R)^d$（例如 $bold(w) = bold(0)$）\
  全部存储与访问操作（对 $S_t$、$A_t$ 与 $R_t$）都可以对其下标取模 $n + 1$

  对每个回合循环：\
  #h(1.5em) 初始化并存储 $S_0 != "terminal"$ \
  #h(1.5em) 选择并存储一个动作 $A_0 tilde pi (dot.op | S_0)$，或关于 $hat(q)(S_0, dot.op, bold(w))$ 的 ε-greedy 动作 \
  #h(1.5em) $T arrow.l infinity$ \
  #h(1.5em) 对 $t = 0, 1, 2, dots.c$ 循环：
  #pad(left: 1.5em, block(
    inset: (left: 1.5em),
    stroke: (left: 0.5pt),
  )[
    若 $t < T$，则：\
    #h(1.5em) 采取动作 $A_t$ \
    #h(1.5em) 观测下一个奖励与下一个状态，分别存储为 $R_(t+1)$ 与 $S_(t+1)$ \
    #h(1.5em) 若 $S_(t+1)$ 是终止状态，则：\
    #h(3em) $T arrow.l t + 1$ \
    #h(1.5em) 否则：\
    #h(3em) 选择并存储一个动作 $A_(t+1) tilde pi (dot.op | S_(t+1))$，或关于 $hat(q)(S_(t+1), dot.op, bold(w))$ 的 ε-greedy 动作 \
    $tau arrow.l t - n + 1$　（$tau$ 是其估计正在被更新的那个时刻）\
    若 $tau >= 0$：\
    #h(1.5em) $G arrow.l sum_(i=tau+1)^(min(tau+n,T)) gamma^(i-tau-1) R_i$ \
    #h(1.5em) 若 $tau + n < T$，则 $G arrow.l G + gamma^n hat(q)(S_(tau+n), A_(tau+n), bold(w))$#h(1fr)（$G_(tau:tau+n)$）\
    #h(1.5em) $bold(w) arrow.l bold(w) + alpha [G - hat(q)(S_tau, A_tau, bold(w))] nabla hat(q)(S_tau, A_tau, bold(w))$
  ])
  #h(1.5em) 直到 $tau = T - 1$
]

正如我们以前多次看到的，使用中间程度的自举（bootstrapping）、也就是取大于 1 的 $n$ 时表现最好。@fig-10-3 表明，在 Mountain Car 任务上，这个算法在 $n = 8$ 时比在 $n = 1$ 时往往学得更快，渐近性能也更好。@fig-10-4 给出了更详细地研究参数 $alpha$ 与 $n$ 对这个任务学习速率影响的结果。

#figure(
  image("../../assets/figures/ch10/fig-10-3.png", width: 80%),
  caption: [在 Mountain Car 任务上一步与 8 步半梯度 Sarsa 的表现。这里使用的是好的步长：$n = 1$ 时 $alpha = 0.5 slash 8$，$n = 8$ 时 $alpha = 0.3 slash 8$。],
)<fig-10-3>

#figure(
  image("../../assets/figures/ch10/fig-10-4.png", width: 83%),
  caption: [$alpha$ 与 $n$ 对 $n$ 步半梯度 Sarsa 与瓦片编码函数近似在 Mountain Car 任务上早期表现的影响。和通常一样，中间程度的自举（$n = 4$）表现最好。这些结果是在选定的若干 $alpha$ 取值上取得的，$alpha$ 按对数刻度排布，再用直线连接。标准误差从 $n = 1$ 时的 0.5（比线宽还小）到 $n = 16$ 时的约 4，因此主要效应在统计上都是显著的。],
)<fig-10-4>

#exercise("10.1")[本章没有明确考虑过蒙特卡洛方法，也没有给出它们的伪代码。它们会是什么样子？为什么不给出它们的伪代码是合理的？它们在 Mountain Car 任务上会有怎样的表现？]

#exercise("10.2")[给出用于控制的半梯度一步 #emph[Expected] Sarsa 的伪代码。]

#exercise("10.3")[为什么 @fig-10-4 中所示的结果在 $n$ 较大时比 $n$ 较小时标准误差更高？]
