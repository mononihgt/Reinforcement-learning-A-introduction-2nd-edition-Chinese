#import "../../template.typ": *

== 带控制变量的 off-policy 迹 <sec-12-9>

最后一步是把重要性采样纳入进来。对于使用非截断 $lambda$ 回报的方法，把重要性采样加权作用在目标回报上并没有一种实用的方案（对 $n$ 步方法而言则存在这样一种方案，如第 7.3 节所解释的那样）。我们改为直接转到带控制变量的逐决策重要性采样的自举推广（第 7.4 节）。

在状态情形中，我们对 $lambda$ 回报的最终定义仿照第 7 章的公式 7.13，把 @eq-12-18 推广为

$ G_t^(lambda s) ≐ rho_t lr(size: #130%, (R_(t+1) + gamma_(t+1) lr(size: #125%, ((1 - lambda_(t+1)) hat(v)(S_(t+1), bold(w)_t) + lambda_(t+1) G_(t+1)^(lambda s))))) + (1 - rho_t) hat(v)(S_t, bold(w)_t), $ <eq-12-22>

其中 $rho_t = frac(pi (A_t|S_t), b(A_t|S_t))$ 是通常的单步重要性采样比。与本书中见过的其他回报很像，这个最终的 $lambda$ 回报可以简单地用基于状态的 TD 误差

$ delta_t^s ≐ R_(t+1) + gamma_(t+1) hat(v)(S_(t+1), bold(w)_t) - hat(v)(S_t, bold(w)_t), $ <eq-12-23>

之和来近似，写成

$ G_t^(lambda s) approx hat(v)(S_t, bold(w)_t) + rho_t sum_(k=t)^oo delta_k^s product_(i=t+1)^k gamma_i lambda_i rho_i, $ <eq-12-24>

当近似值函数不发生改变时，这个近似就变得精确。

#exercise("12.8")[请证明当值函数不变时 @eq-12-24 是精确的。为了省些笔墨，只考虑 $t = 0$ 的情形，并使用记号 $V_k ≐ hat(v)(S_k, bold(w))$。]

#exercise("12.9")[一般 off-policy 回报的截断版本记为 $G_(t:h)^(lambda s)$。请基于 @eq-12-24 猜出它正确的方程。]

上面这个形式的 $lambda$ 回报 @eq-12-24 便于用在一次前向视图更新中，

#{
  set math.equation(numbering: none)
  $ bold(w)_(t+1) &= bold(w)_t + alpha (G_t^(lambda s) - hat(v)(S_t, bold(w)_t)) nabla hat(v)(S_t, bold(w)_t) \
    &approx bold(w)_t + alpha rho_t (sum_(k=t)^oo delta_k^s product_(i=t+1)^k gamma_i lambda_i rho_i) nabla hat(v)(S_t, bold(w)_t), $
}

在有经验的人看来，这就像一个基于资格迹的 TD 更新：乘积项像是一个资格迹，它被乘上了 TD 误差。但这只是一次前向视图的一个时间步。我们要找的关系是：把前向视图更新按时间求和，近似等于把一个后向视图更新按时间求和（这个关系只是近似的，因为我们又一次忽略了值函数的变化）。前向视图更新按时间求和的结果是

#{
  set math.equation(numbering: none)
  $ &sum_(t=0)^oo (bold(w)_(t+1) - bold(w)_t) approx sum_(t=0)^oo sum_(k=t)^oo alpha rho_t delta_k^s nabla hat(v)(S_t, bold(w)_t) product_(i=t+1)^k gamma_i lambda_i rho_i \
    &= sum_(k=0)^oo sum_(t=0)^k alpha rho_t nabla hat(v)(S_t, bold(w)_t) delta_k^s product_(i=t+1)^k gamma_i lambda_i rho_i \
    &quad "(利用求和规则：" sum_(t=x)^y sum_(k=t)^y = sum_(k=x)^y sum_(t=x)^k ")" \
    &= sum_(k=0)^oo alpha delta_k^s sum_(t=0)^k rho_t nabla hat(v)(S_t, bold(w)_t) product_(i=t+1)^k gamma_i lambda_i rho_i, $
}

如果从第二个求和开始的整个表达式能够作为一个资格迹被增量地写出与更新，它就具有后向视图 TD 更新之和的形式；我们现在证明这是可以做到的。也就是说，我们证明：如果这个表达式是时刻 $k$ 处的迹，那么我们可以按下面的方式从它在时刻 $k - 1$ 处的值把它更新出来：

#{
  set math.equation(numbering: none)
  $ bold(z)_k &= sum_(t=0)^k rho_t nabla hat(v)(S_t, bold(w)_t) product_(i=t+1)^k gamma_i lambda_i rho_i \
    &= sum_(t=0)^(k-1) rho_t nabla hat(v)(S_t, bold(w)_t) product_(i=t+1)^k gamma_i lambda_i rho_i + rho_k nabla hat(v)(S_k, bold(w)_k) \
    &= gamma_k lambda_k rho_k underbrace(sum_(t=0)^(k-1) rho_t nabla hat(v)(S_t, bold(w)_t) product_(i=t+1)^(k-1) gamma_i lambda_i rho_i, bold(z)_(k-1)) + rho_k nabla hat(v)(S_k, bold(w)_k) \
    &= rho_k (gamma_k lambda_k bold(z)_(k-1) + nabla hat(v)(S_k, bold(w)_k)), $
}

把下标从 $k$ 换成 $t$，就得到状态值的一般累积迹更新式：

$ bold(z)_t ≐ rho_t (gamma_t lambda_t bold(z)_(t-1) + nabla hat(v)(S_t, bold(w)_t)), $ <eq-12-25>

这个资格迹与 TD($lambda$) 通常的半梯度参数更新规则 @eq-12-7 一起，构成一个通用的 TD($lambda$) 算法，可以应用于 on-policy 或者 off-policy 数据。在 on-policy 情形中，这个算法恰好就是 TD($lambda$)，因为 $rho_t$ 恒为 1，@eq-12-25 变成通常的累积迹 @eq-12-5（推广到可变的 $lambda$ 与 $gamma$）。在 off-policy 情形中，这个算法往往工作得很好，但作为一个半梯度方法，它并不保证稳定。接下来几节我们将考虑它的一些扩展，那些扩展能够保证稳定性。

对动作值方法，可以遵循一系列非常类似的步骤来导出 off-policy 资格迹以及相应的通用 Sarsa($lambda$) 算法。一般动作值 $lambda$ 回报的两种递归形式 @eq-12-19 与 @eq-12-20 都可以作为出发点，但后者（Expected Sarsa 形式）算起来更简单。仿照第 7 章的公式 7.14，我们把 @eq-12-20 推广到 off-policy 情形，得到

$ G_t^(lambda a) &≐ R_(t+1) + gamma_(t+1) lr(size: #130%, ( (1 - lambda_(t+1)) overline(V)_t (S_(t+1)) + lambda_(t+1) lr(size: #125%, [ rho_(t+1) G_(t+1)^(lambda a) + overline(V)_t (S_(t+1)) - rho_(t+1) hat(q)(S_(t+1), A_(t+1), bold(w)_t) ]) )) \
  &= R_(t+1) + gamma_(t+1) lr(size: #130%, ( overline(V)_t (S_(t+1)) + lambda_(t+1) rho_(t+1) lr(size: #125%, [ G_(t+1)^(lambda a) - hat(q)(S_(t+1), A_(t+1), bold(w)_t) ]) )) $ <eq-12-26>

其中 $overline(V)_t (S_(t+1))$ 由 @eq-12-21 给出。同样，$lambda$ 回报可以近似地写成 TD 误差之和，

$ G_t^(lambda a) approx hat(q)(S_t, A_t, bold(w)_t) + sum_(k=t)^oo delta_k^a product_(i=t+1)^k gamma_i lambda_i rho_i, $ <eq-12-27>

这里用的是基于动作的 TD 误差的期望形式：

$ delta_t^a ≐ R_(t+1) + gamma_(t+1) overline(V)_t (S_(t+1)) - hat(q)(S_t, A_t, bold(w)_t). $ <eq-12-28>

与之前一样，当近似值函数不发生改变时，这个近似就变得精确。

#exercise("12.10")[请证明当值函数不变时 @eq-12-27 是精确的。为了省些笔墨，只考虑 $t = 0$ 的情形，并使用记号 $Q_k = hat(q)(S_k, A_k, bold(w))$。提示：先写出 $delta_0^a$ 与 $G_0^(lambda a)$，再写出 $G_0^(lambda a) - Q_0$。]

#exercise("12.11")[一般 off-policy 回报的截断版本记为 $G_(t:h)^(lambda a)$。请基于 @eq-12-27 猜出它正确的方程。]

使用与状态情形完全类似的步骤，基于 @eq-12-27 可以写出一个前向视图更新，再利用求和规则把更新之和重新组织，最终导出动作值资格迹的如下形式：

$ bold(z)_t ≐ gamma_t lambda_t rho_t bold(z)_(t-1) + nabla hat(q)(S_t, A_t, bold(w)_t). $ <eq-12-29>

这个资格迹与基于期望的 TD 误差 @eq-12-28 以及通常的半梯度参数更新规则 @eq-12-7 一起，构成一个优雅、高效的 Expected Sarsa($lambda$) 算法，可以应用于 on-policy 或者 off-policy 数据。它大概是目前这类算法中最好的一个（当然，在与接下来几节给出的方法以某种方式结合之前，它并不保证稳定）。在 $lambda$ 与 $gamma$ 为常数的 on-policy 情形中，使用通常的状态–动作 TD 误差 @eq-12-16，这个算法与第 12.7 节给出的 Sarsa($lambda$) 算法完全相同。

#exercise("12.12")[请详细展示上面概述的从 @eq-12-27 导出 @eq-12-29 的各个步骤。从更新式 @eq-12-15 出发，用 @eq-12-26 给出的 $G_t^(lambda a)$ 替换 $G_t^lambda$，然后遵循与导出 @eq-12-25 类似的步骤。]

当 $lambda = 1$ 时，这些算法与相应的蒙特卡洛算法密切相关。人们也许会期望，对于回合式问题与离线更新，两者会精确等价；但事实上这种关系更为微妙，也比精确等价稍弱一些。即使在这些最有利的条件下，更新也不是逐个回合等价的，等价的只是它们的期望。这不足为奇，因为这些方法随着轨迹的展开做出不可撤回的更新；而真正的蒙特卡洛方法如果发现轨迹中有任何一个动作在目标策略下的概率为零，就不会为该轨迹做任何更新。特别地，所有这些方法即使在 $lambda = 1$ 时仍然在自举，因为它们的更新目标依赖于当前的值估计，只不过这种依赖在期望值中相互抵消了。这在实践中是一种好性质还是坏性质，是另一个问题。最近有人提出了确实能实现精确等价的方法（Sutton、Mahmood、Precup 与 van Hasselt，2014）。这些方法需要一个额外的「暂定权重」（provisional weights）向量，用来追踪已经做出、但可能因为以后采取的动作而需要撤回（或者强调）的更新。这类方法的状态版本与状态–动作版本分别称为 PTD($lambda$) 与 PQ($lambda$)，其中字母 P 代表暂定。

所有这些新的 off-policy 方法的实际效果尚未得到确认。毫无疑问，会出现高方差问题，就像所有使用重要性采样的 off-policy 方法一样（第 11.9 节）。

如果 $lambda < 1$，那么所有这些 off-policy 算法都涉及自举，致命三元组随之适用（第 11.3 节），这意味着只有当问题是表格型的、或使用状态聚合及其他有限形式的函数近似时，才能保证它们稳定。对于线性以及更一般的函数近似形式，参数向量可能像第 11 章的例子中那样发散到无穷大。正如我们在那里讨论过的，off-policy 学习的挑战有两个部分。带资格迹的 off-policy 方法有效地处理了挑战的第一部分，对更新目标的期望值做出了修正，但完全没有触及挑战的第二部分，也就是与更新分布有关的部分。应对带资格迹的 off-policy 学习第二部分挑战的算法策略总结在第 12.11 节。

#exercise("12.13")[对于状态值方法与动作值方法，off-policy 资格迹的荷兰迹版本与替换迹版本分别是什么？]
