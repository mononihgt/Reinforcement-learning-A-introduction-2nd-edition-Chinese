#import "../../template.typ": *

== 不使用重要性采样的 off-policy 学习：$n$ 步 Tree Backup 算法 <sec-7-5>

不使用重要性采样，off-policy 学习可能吗？第 6 章的 Q-learning 与 Expected Sarsa 在单步情形做到了这一点，但是否存在对应的多步算法？本节我们介绍的正是这样一种 $n$ 步方法，称为 #emph[tree-backup 算法]。

#grid(
  columns: (1fr, 15%),
  column-gutter: 1.2em,
  align: (left + top, center + top),
  [
    这个算法的想法由右图所示的三步 tree-backup 回溯图引出。沿中央的脊线，图中标出了三个样本状态与奖励，以及两个样本动作。这些是随机变量，代表初始状态–动作对 $S_t$、$A_t$ 之后发生的事件。每个状态的两侧悬挂着#ezh[未]被选中的动作。（对最后一个状态，全部动作都视为尚未被选中。）由于没有未选中动作的样本数据，我们进行自举，用它们值的估计来构造更新的目标。这略微推广了回溯图的思想。到目前为止，我们总是把图中顶部节点的估计值朝着一个目标更新，这个目标由沿途的奖励（按适当方式折扣）与底部节点的估计值组合而成。在 tree-backup 更新中，目标除了包含这一切，还包含悬挂在两侧的全部悬空动作节点在所有层级上的估计值。它因此被称为 tree-backup 更新：它是一种来自估计动作值的整棵树的更新。
  ],
  image("../../assets/figures/ch07/fig-7-inline-1.png", width: 100%),
)

更确切地说，更新来自树的#ezh[叶节点]的估计动作值。内部对应实际采取动作的那些动作节点不参与。每个叶节点以正比于它在目标策略 $pi$ 下出现概率的权值对目标作出贡献。因此，每个第一层动作 $a$ 以权值 $pi (a|S_(t+1))$ 作出贡献，唯独实际采取的动作 $A_(t+1)$ 完全不参与。它的概率 $pi (A_(t+1)|S_(t+1))$ 被用来对全部第二层动作值加权。于是，每个未被选中的第二层动作 $a'$ 以权值 $pi (A_(t+1)|S_(t+1)) pi (a'|S_(t+2))$ 作出贡献。每个第三层动作以权值 $pi (A_(t+1)|S_(t+1)) pi (A_(t+2)|S_(t+2)) pi (a''|S_(t+3))$ 作出贡献，依此类推。这就好像图中每条通往动作节点的箭头都按该动作在目标策略下被选中的概率加权，并且如果该动作下方还有一棵树，那么这个权值适用于树中的全部叶节点。

我们可以把三步 tree-backup 更新看作由 6 个半步组成，它们在两种半步之间交替：从动作到后继状态的采样半步，以及从该状态出发考虑全部可能动作、按它们在策略下发生概率加权的期望半步。

现在我们来推导 $n$ 步 tree-backup 算法的具体方程。单步回报（目标）与 Expected Sarsa 的相同，

$ G_(t:t+1) ≐ R_(t+1) + gamma sum_a pi (a|S_(t+1)) Q_t (S_(t+1), a), $ <eq-7-15>

对 $t < T - 1$；双步 tree-backup 回报是

#{
  set math.equation(numbering: none)
  $ G_(t:t+2) &≐ R_(t+1) + gamma sum_(a != A_(t+1)) pi (a|S_(t+1)) Q_(t+1) (S_(t+1), a) \
              &quad + gamma pi (A_(t+1)|S_(t+1)) (R_(t+2) + gamma sum_a pi (a|S_(t+2)) Q_(t+1) (S_(t+2), a)) \
              &= R_(t+1) + gamma sum_(a != A_(t+1)) pi (a|S_(t+1)) Q_(t+1) (S_(t+1), a) + gamma pi (A_(t+1)|S_(t+1)) G_(t+1:t+2), $
}

对 $t < T - 2$。后一种形式提示了 tree-backup 的 $n$ 步回报的一般递归定义：

$ G_(t:t+n) ≐ R_(t+1) + gamma sum_(a != A_(t+1)) pi (a|S_(t+1)) Q_(t+n-1) (S_(t+1), a) + gamma pi (A_(t+1)|S_(t+1)) G_(t+1:t+n), $ <eq-7-16>

对 $t < T - 1$、$n >= 2$，其中 $n = 1$ 的情形由 @eq-7-15 处理，只是 $G_(T-1:t+n) ≐ R_T$。这个目标随后与 $n$ 步 Sarsa 中常规的动作值更新规则一起使用：

#{
  set math.equation(numbering: none)
  $ Q_(t+n) (S_t, A_t) ≐ Q_(t+n-1) (S_t, A_t) + alpha [G_(t:t+n) - Q_(t+n-1) (S_t, A_t)], $
}

对 $0 <= t < T$，而所有其他状态–动作对的值保持不变：$Q_(t+n) (s, a) = Q_(t+n-1) (s, a)$，对满足 $s != S_t$ 或 $a != A_t$ 的全部 $s$、$a$。这个算法的伪代码在下一页的方框中给出。

#exercise("7.11")[请证明，如果近似的动作值不变，那么 tree-backup 回报 @eq-7-16 可以写成基于期望的 TD 误差之和：

#{
  set math.equation(numbering: none)
  $ G_(t:t+n) = Q(S_t, A_t) + sum_(k=t)^(min(t+n-1,T-1)) delta_k product_(i=t+1)^k gamma pi (A_i|S_i), $
}

其中 $delta_t ≐ R_(t+1) + gamma overline(V)_t (S_(t+1)) - Q(S_t, A_t)$，而 $overline(V)_t$ 由 @eq-7-8 给出。]

#algbox([$n$ 步 Tree Backup，用于估计 $Q approx q_*$ 或 $q_pi$])[
  对全部的 $s in cal(S)$、$a in cal(A)$，把 $Q(s, a)$ 初始化为任意值 \
  把 $pi$ 初始化为相对于 $Q$ 的贪婪策略，或者初始化为一个给定的固定策略 \
  算法参数：步长 $alpha in (0, 1]$，一个正整数 $n$ \
  全部的存储与访问操作都可以对其下标取模 $n + 1$

  对每个回合循环：\
  #h(1.5em) 初始化并存储 $S_0 != "terminal"$ \
  #h(1.5em) 任意选取一个动作 $A_0$，它是 $S_0$ 的函数；存储 $A_0$ \
  #h(1.5em) $T arrow.l infinity$ \
  #h(1.5em) 对 $t = 0, 1, 2, dots.c$ 循环：\
  #h(3em) 若 $t < T$：\
  #h(4.5em) 采取动作 $A_t$；观测下一个奖励与下一个状态，分别存储为 $R_(t+1)$、$S_(t+1)$ \
  #h(4.5em) 若 $S_(t+1)$ 是终止状态：\
  #h(6em) $T arrow.l t + 1$ \
  #h(4.5em) 否则：\
  #h(6em) 任意选取一个动作 $A_(t+1)$，它是 $S_(t+1)$ 的函数；存储 $A_(t+1)$ \
  #h(3em) $tau arrow.l t + 1 - n$　（$tau$ 是其估计正在被更新的那个时刻）\
  #h(3em) 若 $tau >= 0$：\
  #h(4.5em) 若 $t + 1 >= T$：\
  #h(6em) $G arrow.l R_T$ \
  #h(4.5em) 否则\
  #h(6em) $G arrow.l R_(t+1) + gamma sum_a pi (a|S_(t+1)) Q(S_(t+1), a)$ \
  #h(4.5em) 对 $k = min(t, T - 1)$ 向下循环到 $tau + 1$：\
  #h(6em) $G arrow.l R_k + gamma sum_(a != A_k) pi (a|S_k) Q(S_k, a) + gamma pi (A_k|S_k) G$ \
  #h(4.5em) $Q(S_tau, A_tau) arrow.l Q(S_tau, A_tau) + alpha [G - Q(S_tau, A_tau)]$ \
  #h(4.5em) 若 $pi$ 正在被学习，则确保 $pi (dot.op | S_tau)$ 是相对于 $Q$ 的贪婪策略 \
  #h(1.5em) 直到 $tau = T - 1$
]
