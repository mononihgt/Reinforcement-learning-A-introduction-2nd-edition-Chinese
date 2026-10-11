#import "../../template.typ": *

== $n$ 步 Sarsa <sec-7-2>

$n$ 步方法怎样才能不仅用于预测，还用于控制？本节我们将说明 $n$ 步方法如何以直接的方式与 Sarsa 结合，产生一个 on-policy TD 控制方法。我们把 Sarsa 的 $n$ 步版本称为 #emph[$n$ 步 Sarsa]，从今往后把上一章介绍的原版本称为 #emph[单步 Sarsa]，即 #emph[Sarsa(0)]。

主要思想只是把状态换成动作（状态–动作对），然后使用 $epsilon$-greedy 策略。$n$ 步 Sarsa 的回溯图（@fig-7-3 中给出）与 $n$ 步 TD 的回溯图（@fig-7-1）一样，是状态与动作交替出现的序列，区别只在于 Sarsa 的那些图都以动作开头和结尾，$n$ 步 TD 的图则以状态开头和结尾。我们按估计的动作值重新定义 $n$ 步回报（更新目标）：

$ G_(t:t+n) ≐ R_(t+1) + gamma R_(t+2) + dots.c + gamma^(n-1) R_(t+n) + gamma^n Q_(t+n-1) (S_(t+n), A_(t+n)), quad n >= 1, quad 0 <= t < T-n, \ quad $ <eq-7-4>

其中如果 $t + n >= T$，则 $G_(t:t+n) ≐ G_t$。自然的算法则是

$ Q_(t+n) (S_t, A_t) ≐ Q_(t+n-1) (S_t, A_t) + alpha [G_(t:t+n) - Q_(t+n-1) (S_t, A_t)], quad 0 <= t < T, $ <eq-7-5>

而所有其他状态的值保持不变：$Q_(t+n) (s, a) = Q_(t+n-1) (s, a)$，对满足 $s != S_t$ 或 $a != A_t$ 的全部 $s$、$a$。这个算法我们称为 #emph[$n$ 步 Sarsa]。伪代码在下一页的方框中给出；@fig-7-4 给出了一个例子，说明与单步方法相比它为什么能加快学习。

#figure(
  image("../../assets/figures/ch07/fig-7-3.png", width: 95%),
  caption: [状态–动作值的 $n$ 步方法谱系的回溯图。它们从 Sarsa(0) 的单步更新一直延伸到蒙特卡洛方法的直到终止更新。中间是基于 $n$ 步真实奖励与第 $n$ 个后继状态–动作对的估计值的 $n$ 步更新，全部经过适当的折扣。最右边是 $n$ 步 Expected Sarsa 的回溯图。],
)<fig-7-3>

#algbox([$n$ 步 Sarsa，用于估计 $Q approx q_*$ 或 $q_pi$])[
  对全部的 $s in cal(S)$、$a in cal(A)$，把 $Q(s, a)$ 初始化为任意值 \
  把 $pi$ 初始化为相对于 $Q$ 的 $epsilon$-greedy 策略，或者初始化为一个给定的固定策略 \
  算法参数：步长 $alpha in (0, 1]$，小量 $epsilon > 0$，一个正整数 $n$ \
  全部的存储与访问操作（针对 $S_t$、$A_t$ 与 $R_t$）都可以对其下标取模 $n + 1$

  对每个回合循环：\
  #h(1.5em) 初始化并存储 $S_0 != "terminal"$ \
  #h(1.5em) 选择并存储一个动作 $A_0 tilde pi (dot.op | S_0)$ \
  #h(1.5em) $T arrow.l infinity$ \
  #h(1.5em) 对 $t = 0, 1, 2, dots.c$ 循环：\
  #h(3em) 若 $t < T$，则：\
  #h(4.5em) 采取动作 $A_t$ \
  #h(4.5em) 观测下一个奖励与下一个状态，分别存储为 $R_(t+1)$ 与 $S_(t+1)$ \
  #h(4.5em) 若 $S_(t+1)$ 是终止状态，则：\
  #h(6em) $T arrow.l t + 1$ \
  #h(4.5em) 否则：\
  #h(6em) 选择并存储一个动作 $A_(t+1) tilde pi (dot.op | S_(t+1))$ \
  #h(3em) $tau arrow.l t - n + 1$　（$tau$ 是其估计正在被更新的那个时刻）\
  #h(3em) 若 $tau >= 0$：\
  #h(4.5em) $G arrow.l sum_(i=tau+1)^(min(tau+n,T)) gamma^(i-tau-1) R_i$ \
  #h(4.5em) 若 $tau + n < T$，则 $G arrow.l G + gamma^n Q(S_(tau+n), A_(tau+n))$#h(1fr)（$G_(tau:tau+n)$）\
  #h(4.5em) $Q(S_tau, A_tau) arrow.l Q(S_tau, A_tau) + alpha [G - Q(S_tau, A_tau)]$ \
  #h(4.5em) 若 $pi$ 正在被学习，则确保 $pi (dot.op | S_tau)$ 是相对于 $Q$ 的 $epsilon$-greedy 策略 \
  #h(1.5em) 直到 $tau = T - 1$
]

#figure(
  image("../../assets/figures/ch07/fig-7-4.png", width: 95%),
  caption: [使用 $n$ 步方法加快策略学习的网格世界示例。第一幅图展示了 agent 在单个回合中走过的路径，终点是高奖励所在的位置，标为 G。在这个例子中，全部值最初都是 0，除 G 处的一个正奖励外，全部奖励都是零。另外两幅图中的箭头展示了由这条路径带来的、单步与 $n$ 步 Sarsa 方法各自强化了哪些动作值。单步方法只强化通向高奖励的动作序列中的最后一个动作，而 $n$ 步方法强化该序列中最后的 $n$ 个动作，因此从这一个回合中学到的东西要多得多。],
)<fig-7-4>

#exercise("7.4")[请证明，Sarsa 的 $n$ 步回报 @eq-7-4 可以精确地用一个新引入的 TD 误差写成

$ G_(t:t+n) = Q_(t-1) (S_t, A_t) + sum_(k=t)^(min(t+n,T)-1) gamma^(k-t) [R_(k+1) + gamma Q_k (S_(k+1), A_(k+1)) - Q_(k-1) (S_k, A_k)]. $ <eq-7-6>
]

Expected Sarsa 呢？$n$ 步 Expected Sarsa 的回溯图展示在 @fig-7-3 的最右边。它由一串采样得到的动作与状态线性排列而成，与 $n$ 步 Sarsa 一样，只不过它的最后一个元素是在全部动作可能性上的分支，权值一如既往是各动作在 $pi$ 下的概率。这个算法可以用与 $n$ 步 Sarsa 相同的方程描述（即上面那个），只是 $n$ 步回报重新定义为

$ G_(t:t+n) ≐ R_(t+1) + dots.c + gamma^(n-1) R_(t+n) + gamma^n overline(V)_(t+n-1) (S_(t+n)), quad t + n < T, $ <eq-7-7>

（其中 $t + n >= T$ 时 $G_(t:t+n) ≐ G_t$）这里 $overline(V)_t (s)$ 是状态 $s$ 的#ezh[期望近似价值]（expected approximate value），它使用时刻 $t$ 的估计动作值，在目标策略下计算：

$ overline(V)_t (s) ≐ sum_a pi (a|s) Q_t (s, a), quad "for all" s in cal(S). $ <eq-7-8>

期望近似价值在本书其余部分许多动作值方法的推导中都会用到。如果 $s$ 是终止状态，则定义它的期望近似价值为 0。
