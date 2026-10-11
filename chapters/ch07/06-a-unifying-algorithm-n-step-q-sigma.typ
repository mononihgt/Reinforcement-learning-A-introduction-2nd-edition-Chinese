#import "../../template.typ": *

== #sym.ast.basic 统一的算法：$n$ 步 Q($sigma$) <sec-7-6>

本章到目前为止，我们考虑了三种不同的动作值算法，对应 @fig-7-5 中最前面的三幅回溯图。$n$ 步 Sarsa 的全部转移都是采样的；tree-backup 算法全部从状态到动作的转移都是完全分支的、不作采样；$n$ 步 Expected Sarsa 的全部转移都是采样的，唯独最后一个从状态到动作的转移例外，它用一个期望值完全分支。这些算法能在多大程度上被统一？

@fig-7-5 中的第四幅回溯图提示了一种统一的思路。这个思路是，人们可以逐步决定：是像 Sarsa 那样把动作取作样本，还是像 tree-backup 更新那样改为考虑全部动作上的期望。那么，如果总是选择采样，就得到 Sarsa；而如果从不采样，就得到 tree-backup 算法。Expected Sarsa 则是除最后一步之外全部步骤都选择采样的情形。

#figure(
  image("../../assets/figures/ch07/fig-7-5.png", width: 71%),
  caption: [本章到目前为止考虑的三类 $n$ 步动作值更新的回溯图（四步情形），以及第四类更新的回溯图，后者把它们全部统一起来。标签「ρ」表示在 off-policy 情形下需要重要性采样的半转移。第四类更新在每个状态上逐一选择采样（$sigma_t = 1$）或不采样（$sigma_t = 0$），从而统一了其他所有更新。],
)<fig-7-5>

当然还会有许多其他可能性，正如图中最后一幅图所提示的那样。为了进一步增加可能性，我们可以考虑在采样与期望之间连续变化。令 $sigma_t in [0, 1]$ 表示第 $t$ 步的采样程度，$sigma = 1$ 表示完全采样，$sigma = 0$ 表示不作采样、纯用期望。随机变量 $sigma_t$ 可以设为时刻 $t$ 的状态、动作或状态–动作对的函数。我们把这个新提出的算法称为 #emph[$n$ 步 Q($sigma$)]。

现在我们来推导 $n$ 步 Q($sigma$) 的方程。首先把 tree-backup 的 $n$ 步回报 @eq-7-16 写成视界 $h = t + n$ 的形式，再写成期望近似价值 $overline(V)$ @eq-7-8 的形式：

#{
  set math.equation(numbering: none)
  $ G_(t:h) &= R_(t+1) + gamma sum_(a != A_(t+1)) pi (a|S_(t+1)) Q_(h-1) (S_(t+1), a) + gamma pi (A_(t+1)|S_(t+1)) G_(t+1:h) \
           &= R_(t+1) + gamma overline(V)_(h-1) (S_(t+1)) - gamma pi (A_(t+1)|S_(t+1)) Q_(h-1) (S_(t+1), A_(t+1)) + gamma pi (A_(t+1)|S_(t+1)) G_(t+1:h) \
           &= R_(t+1) + gamma pi (A_(t+1)|S_(t+1)) (G_(t+1:h) - Q_(h-1) (S_(t+1), A_(t+1))) + gamma overline(V)_(h-1) (S_(t+1)), $
}

此后它就和带控制变量的 Sarsa 的 $n$ 步回报 @eq-7-14 完全一样，只是把重要性采样率 $rho_(t+1)$ 换成了动作概率 $pi (A_(t+1)|S_(t+1))$。对 Q($sigma$)，我们在这两种情形之间线性滑动：

$ G_(t:h) ≐ R_(t+1) + gamma (sigma_(t+1) rho_(t+1) + (1 - sigma_(t+1)) pi (A_(t+1)|S_(t+1))) (G_(t+1:h) - Q_(h-1) (S_(t+1), A_(t+1))) \
        + gamma overline(V)_(h-1) (S_(t+1)), $ <eq-7-17>

对 $t < h <= T$。如果 $h < T$，递归以 $G_(h:h) ≐ Q_(h-1) (S_h, A_h)$ 结束；如果 $h = T$，则以 $G_(T-1:T) ≐ R_T$ 结束。然后我们使用前面那个不带重要性采样率的 $n$ 步 Sarsa 更新 @eq-7-5；现在这些比值已经并入 $n$ 步回报之中，因此不需要 @eq-7-11 那样的额外加权。完整算法在方框中给出。

#algbox([off-policy $n$ 步 Q($sigma$)，用于估计 $Q approx q_*$ 或 $q_pi$])[
  输入：一个任意的行为策略 $b$，满足对全部的 $s in cal(S)$、$a in cal(A)$ 都有 $b(a|s) > 0$ \
  对全部的 $s in cal(S)$、$a in cal(A)$，把 $Q(s, a)$ 初始化为任意值 \
  把 $pi$ 初始化为相对于 $Q$ 的贪婪策略，或者让它是一个给定的固定策略 \
  算法参数：步长 $alpha in (0, 1]$，一个正整数 $n$ \
  全部的存储与访问操作都可以对其下标取模 $n + 1$

  对每个回合循环：\
  #h(1.5em) 初始化并存储 $S_0 != "terminal"$ \
  #h(1.5em) 选取并存储一个动作 $A_0 tilde b(dot.op | S_0)$ \
  #h(1.5em) $T arrow.l infinity$ \
  #h(1.5em) 对 $t = 0, 1, 2, dots.c$ 循环：\
  #h(3em) 若 $t < T$：\
  #h(4.5em) 采取动作 $A_t$；观测下一个奖励与下一个状态，分别存储为 $R_(t+1)$、$S_(t+1)$ \
  #h(4.5em) 若 $S_(t+1)$ 是终止状态：\
  #h(6em) $T arrow.l t + 1$ \
  #h(4.5em) 否则：\
  #h(6em) 选取并存储一个动作 $A_(t+1) tilde b(dot.op | S_(t+1))$ \
  #h(6em) 选择并存储 $sigma_(t+1)$ \
  #h(6em) 把 $frac(pi (A_(t+1)|S_(t+1)), b(A_(t+1)|S_(t+1)))$ 存储为 $rho_(t+1)$ \
  #h(3em) $tau arrow.l t - n + 1$　（$tau$ 是其估计正在被更新的那个时刻）\
  #h(3em) 若 $tau >= 0$：\
  #h(4.5em) 若 $t + 1 < T$：\
  #h(6em) $G arrow.l Q(S_(t+1), A_(t+1))$ \
  #h(4.5em) 对 $k = min(t + 1, T)$ 向下循环到 $tau + 1$：\
  #h(6em) 若 $k = T$：\
  #h(7.5em) $G arrow.l R_T$ \
  #h(6em) 否则：\
  #h(7.5em) $overline(V) arrow.l sum_a pi (a|S_k) Q(S_k, a)$ \
  #h(7.5em) $G arrow.l R_k + gamma (sigma_k rho_k + (1 - sigma_k) pi (A_k|S_k)) (G - Q(S_k, A_k)) + gamma overline(V)$ \
  #h(4.5em) $Q(S_tau, A_tau) arrow.l Q(S_tau, A_tau) + alpha [G - Q(S_tau, A_tau)]$ \
  #h(4.5em) 若 $pi$ 正在被学习，则确保 $pi (dot.op | S_tau)$ 是相对于 $Q$ 的贪婪策略 \
  #h(1.5em) 直到 $tau = T - 1$
]
