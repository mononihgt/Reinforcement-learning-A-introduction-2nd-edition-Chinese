#import "../../template.typ": *

== Sarsa($lambda$) <sec-12-7>

要把资格迹推广到动作值方法，本章已经给出的想法几乎不需要做什么改动。为了学习近似动作值 $hat(q)(s, a, bold(w))$，而不是学习近似状态值 $hat(v)(s, bold(w))$，我们需要使用第 10 章的动作值形式的 $n$ 步回报：

#{
  set math.equation(numbering: none)
  $ G_(t:t+n) ≐ R_(t+1) + dots.c + gamma^(n-1) R_(t+n) + gamma^n hat(q)(S_(t+n), A_(t+n), bold(w)_(t+n-1)), quad t + n < T, $
}

其中当 $t + n >= T$ 时取 $G_(t:t+n) ≐ G_t$。利用它，我们可以写出动作值形式的 $lambda$ 回报，除此之外它与状态值形式 @eq-12-3 完全相同。动作值形式的离线 $lambda$ 回报算法 @eq-12-4 只需用 $hat(q)$ 代替 $hat(v)$：

$ bold(w)_(t+1) ≐ bold(w)_t + alpha [G_t^lambda - hat(q)(S_t, A_t, bold(w)_t)] nabla hat(q)(S_t, A_t, bold(w)_t), quad t = 0, dots, T - 1. $ <eq-12-15>

其中 $G_t^lambda ≐ G_(t:oo)^lambda$。这个前向视图的复合回溯图见 @fig-12-9。注意它与 TD($lambda$) 算法的回溯图（@fig-12-1）的相似之处。第一次更新向前看完整的一步，看到下一个状态–动作对；第二次向前看两步，看到第二个状态–动作对；依此类推。最后一次更新基于完整的回报。$lambda$ 回报中每个 $n$ 步更新的加权与 TD($lambda$) 和 $lambda$ 回报算法 @eq-12-3 中完全一样。

动作值的时序差分方法称为#ezh[Sarsa($lambda$)]，它近似这个前向视图。它的更新规则与前面给出的 TD($lambda$) 相同：

#{
  set math.equation(numbering: none)
  $ bold(w)_(t+1) ≐ bold(w)_t + alpha delta_t bold(z)_t, $
}

只不过自然要使用动作值形式的 TD 误差：

$ delta_t ≐ R_(t+1) + gamma hat(q)(S_(t+1), A_(t+1), bold(w)_t) - hat(q)(S_t, A_t, bold(w)_t), $ <eq-12-16>

以及动作值形式的资格迹：

#{
  set math.equation(numbering: none)
  $ & bold(z)_(-1) ≐ bold(0), \
    & bold(z)_t ≐ gamma lambda bold(z)_(t-1) + nabla hat(q)(S_t, A_t, bold(w)_t), quad 0 <= t <= T. $
}

#figure(
  image("../../assets/figures/ch12/fig-12-9.png", width: 97%),
  caption: [Sarsa($lambda$) 的回溯图。请与 @fig-12-1 比较。],
)<fig-12-9>

带线性函数近似、二元特征以及累积迹或替换迹的 Sarsa($lambda$) 的完整伪代码在下面的方框中给出。这段伪代码突出了二元特征这一特殊情形（特征要么是活动的（=1），要么是不活动的（=0））中可能的若干优化。

#example("网格世界中的迹")[
  使用资格迹可以显著提高控制算法的效率，使之超过一步方法，甚至超过 $n$ 步方法。原因由下面的网格世界例子来说明。

  #align(center, image("../../assets/figures/ch12/fig-12-inline-2.png", width: 100%))

  第一个面板给出了 agent 在一个回合中所走的路径。初始估计值都是零，除 G 标出的目标位置有一个正奖励之外，所有奖励都是零。其他面板中的箭头表明，对不同的算法而言，在到达目标时哪些动作值会被增大、增大多少。一步方法只会增大最后一个动作值，$n$ 步方法会同样地增大最后 $n$ 个动作的值（假定 $gamma = 1$），而资格迹方法会更新直到回合开头的全部动作值，程度各不相同，越久远衰减得越多。这种衰减策略往往是最好的。
]

#algbox([带二元特征与线性函数近似、估计 $bold(w)^top bold(x) approx q_pi$ 或 $q_*$ 的 Sarsa($lambda$)])[
  输入：函数 $cal(F)(s, a)$，返回 $(s, a)$ 的全部活动特征（的下标） \
  输入：策略 $pi$ \
  算法参数：步长 $alpha > 0$、迹衰减率 $lambda in [0, 1]$、小的 $epsilon > 0$ \
  初始化：$bold(w) = (w_1, dots, w_d)^top in bb(R)^d$（例如 $bold(w) = bold(0)$）；$bold(z) = (z_1, dots, z_d)^top in bb(R)^d$

  对每个回合循环：\
  #h(1.5em) 初始化 $S$ \
  #h(1.5em) 选择 $A tilde pi (dot.op | S)$，或者按 $hat(q)(S, dot.op, bold(w))$ 取 $epsilon$-greedy \
  #h(1.5em) $bold(z) arrow.l bold(0)$ \
  #h(1.5em) 对该回合的每一步循环：\
  #h(3em) 采取动作 $A$，观测到 $R$、$S'$ \
  #h(3em) $delta arrow.l R$ \
  #h(3em) 对 $i in cal(F)(S, A)$ 循环：\
  #h(4.5em) $delta arrow.l delta - w_i$ \
  #h(4.5em) $z_i arrow.l z_i + 1$（累积迹） \
  #h(4.5em) 或者 $z_i arrow.l 1$（替换迹） \
  #h(3em) 如果 $S'$ 是终止状态，那么：\
  #h(4.5em) $bold(w) arrow.l bold(w) + alpha delta bold(z)$ \
  #h(4.5em) 进入下一个回合 \
  #h(3em) 选择 $A' tilde pi (dot.op | S')$，或者按 $hat(q)(S', dot.op, bold(w))$ 取 $epsilon$-greedy \
  #h(3em) 对 $i in cal(F)(S', A')$ 循环：$delta arrow.l delta + gamma w_i$ \
  #h(3em) $bold(w) arrow.l bold(w) + alpha delta bold(z)$ \
  #h(3em) $bold(z) arrow.l gamma lambda bold(z)$ \
  #h(3em) $S arrow.l S'$；$A arrow.l A'$
]

#exercise("12.6")[请修改 Sarsa($lambda$) 的伪代码，让它使用荷兰迹 @eq-12-11，但不带有 true online 算法的其他那些独特特征。假定线性函数近似与二元特征。]

#example([Mountain Car 上的 Sarsa($lambda$)])[
  @fig-12-10（左）给出了在例 10.1 引入的 Mountain Car 任务上使用 Sarsa($lambda$) 的结果。函数近似、动作选择与环境的细节都与第 10 章完全相同，因此适合把这些结果与第 10 章 $n$ 步 Sarsa 的结果（图中右侧）做数值比较。早先的结果改变的是更新长度 $n$，而这里对 Sarsa($lambda$) 我们改变的是迹参数 $lambda$，二者扮演类似的角色。Sarsa($lambda$) 的衰减迹自举策略在这个问题上似乎带来了更高效的学习。
]

理想 TD 方法还有一个动作值版本，也就是在线 $lambda$ 回报算法（第 12.4 节）以及它作为 true online TD($lambda$) 的高效实现（第 12.5 节）。第 12.4 节的一切都原样成立，只需要改用本节开头给出的动作值形式的 $n$ 步回报。第 12.5 节与第 12.6 节的分析对动作值同样成立，唯一的变化是使用状态–动作特征向量 $bold(x)_t = bold(x)(S_t, A_t)$，而不是状态特征向量 $bold(x)_t = bold(x)(S_t)$。所得高效算法称为 true online Sarsa($lambda$)，其伪代码在下面的方框中给出。下面两幅图比较了 Sarsa($lambda$) 各版本在 Mountain Car 例子上的表现。

#figure(
  image("../../assets/figures/ch12/fig-12-10.png", width: 100%),
  caption: [使用替换迹的 Sarsa($lambda$) 与 $n$ 步 Sarsa（复制自图 10.4）在 Mountain Car 任务上的早期表现，横轴是步长 $alpha$。],
)<fig-12-10>

#figure(
  image("../../assets/figures/ch12/fig-12-11.png", width: 100%),
  caption: [Sarsa($lambda$) 各算法在 Mountain Car 任务上的汇总比较。true online Sarsa($lambda$) 的表现优于同时使用累积迹与替换迹的常规 Sarsa($lambda$)。图中还包括一个使用替换迹的 Sarsa($lambda$) 版本，它在每个时间步上把状态以及未被选中的动作的迹都置为零。],
)<fig-12-11>

#algbox([估计 $bold(w)^top bold(x) approx q_pi$ 或 $q_*$ 的 true online Sarsa($lambda$)])[
  输入：特征函数 $bold(x) : cal(S)^+ × cal(A) -> bb(R)^d$，且满足 $bold(x)("terminal", dot.op) = bold(0)$ \
  输入：策略 $pi$（如果估计 $q_pi$） \
  算法参数：步长 $alpha > 0$、迹衰减率 $lambda in [0, 1]$、小的 $epsilon > 0$ \
  初始化：$bold(w) in bb(R)^d$（例如 $bold(w) = bold(0)$）

  对每个回合循环：\
  #h(1.5em) 初始化 $S$ \
  #h(1.5em) 选择 $A tilde pi (dot.op | S)$，或者按 $hat(q)(S, dot.op, bold(w))$ 取 $epsilon$-greedy \
  #h(1.5em) $bold(x) arrow.l bold(x)(S, A)$ \
  #h(1.5em) $bold(z) arrow.l bold(0)$ \
  #h(1.5em) $Q_"old" arrow.l 0$ \
  #h(1.5em) 对该回合的每一步循环：\
  #h(3em) 采取动作 $A$，观测到 $R$、$S'$ \
  #h(3em) 选择 $A' tilde pi (dot.op | S')$，或者按 $hat(q)(S', dot.op, bold(w))$ 取 $epsilon$-greedy \
  #h(3em) $bold(x)' arrow.l bold(x)(S', A')$ \
  #h(3em) $Q arrow.l bold(w)^top bold(x)$ \
  #h(3em) $Q' arrow.l bold(w)^top bold(x)'$ \
  #h(3em) $delta arrow.l R + gamma Q' - Q$ \
  #h(3em) $bold(z) arrow.l gamma lambda bold(z) + (1 - alpha gamma lambda bold(z)^top bold(x)) bold(x)$ \
  #h(3em) $bold(w) arrow.l bold(w) + alpha (delta + Q - Q_"old") bold(z) - alpha (Q - Q_"old") bold(x)$ \
  #h(3em) $Q_"old" arrow.l Q'$ \
  #h(3em) $bold(x) arrow.l bold(x)'$ \
  #h(3em) $A arrow.l A'$ \
  #h(1.5em) 直到 $S'$ 是终止状态
]

最后，Sarsa($lambda$) 还有一个截断版本，称为#ezh[前向 Sarsa($lambda$)]（van Seijen，2016），它似乎是一种与多层人工神经网络配合使用时特别有效的无模型控制方法。
