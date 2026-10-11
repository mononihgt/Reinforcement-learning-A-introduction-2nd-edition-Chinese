#import "../../template.typ": *

本章回到控制问题，不过现在是用参数化形式来近似动作值（action-value）函数 $hat(q)(s, a, bold(w)) approx q_* (s, a)$，其中 $bold(w) in bb(R)^d$ 是一个有限维的权重向量。我们继续只关注 on-policy 情形，把 off-policy 方法留到第 11 章。本章的重点是半梯度 Sarsa 算法，它是半梯度时序差分（temporal-difference, TD）算法 TD(0)（上一章）到动作值与 on-policy 控制的自然推广。在回合（episode）情形中，这个推广直截了当；但在持续性情形中，我们必须退后几步，重新审视我们是如何用折扣来定义最优策略（policy）的。出人意料的是，一旦有了真正意义上的函数近似（function approximation），我们就必须放弃折扣，转而采用控制问题的一种新的「平均奖励」表述，并配以新的「微分」值函数（value function）。

我们先从回合情形开始，把上一章介绍的函数近似思想从状态值推广到动作值。然后按照 on-policy GPI 的一般模式，用 ε-greedy 做动作选择，把这些思想推广到控制。我们会给出 $n$ 步线性 Sarsa 在 Mountain Car 问题上的结果。此后转向持续性情形，针对带微分值的平均奖励情形，把这些思想的推导过程重复一遍。

== 回合式半梯度控制 <sec-10-1>

把第 9 章的半梯度预测方法推广到动作值，做法直截了当。这时被表示成带权重向量 $bold(w)$ 的参数化函数形式的，是近似动作值函数 $hat(q) approx q_pi$。以前我们考虑的训练样例是形如 $S_t mapsto U_t$ 的随机样例，现在则考虑形如 $S_t, A_t mapsto U_t$ 的样例。更新目标 $U_t$ 可以是 $q_pi (S_t, A_t)$ 的任意近似，包括通常的回溯（backup）值，例如完整的蒙特卡洛回报（return）（$G_t$），或任意一种 $n$ 步 Sarsa 回报（第 7 章的公式 7.4）。动作值预测的一般梯度下降更新是

$ bold(w)_(t+1) ≐ bold(w)_t + alpha [U_t - hat(q)(S_t, A_t, bold(w)_t)] nabla hat(q)(S_t, A_t, bold(w)_t). $ <eq-10-1>

例如，一步 Sarsa 方法的更新是

$ bold(w)_(t+1) ≐ bold(w)_t + alpha [R_(t+1) + gamma hat(q)(S_(t+1), A_(t+1), bold(w)_t) - hat(q)(S_t, A_t, bold(w)_t)] nabla hat(q)(S_t, A_t, bold(w)_t). $ <eq-10-2>

我们称这个方法为#ezh[回合式半梯度一步 Sarsa]。对固定策略而言，这个方法的收敛方式与 TD(0) 相同，也有同样形式的误差界（第 9 章的公式 9.14）。

要构成控制方法，我们需要把这类动作值预测方法与策略改进、动作选择的技术结合起来。适用于连续动作、或者适用于来自很大的离散动作集合的动作的合适技术，是一个仍在研究中的课题，目前还没有明确的解决方案。另一方面，如果动作集合是离散的而且不太大，我们就可以使用前面各章已经发展出来的技术。也就是说，对于下一个状态（state）$S_(t+1)$ 中可用的每个动作（action）$a$，我们可以计算 $hat(q)(S_(t+1), a, bold(w)_t)$，然后找出贪婪动作 $A^*_(t+1) = op("argmax", limits: #true)_a hat(q)(S_(t+1), a, bold(w)_t)$。随后（在本章讨论的 on-policy 情形中）通过把估计策略改成贪婪策略的一种软近似，例如 ε-greedy 策略，来完成策略改进。动作按同一个策略选择。完整算法的伪代码见方框。

#algbox([估计 $hat(q) approx q_*$ 的回合式半梯度 Sarsa])[
  输入：可微的动作值函数参数化形式 $hat(q) : cal(S) × cal(A) × bb(R)^d -> bb(R)$ \
  算法参数：步长 $alpha > 0$，小的 $epsilon > 0$ \
  任意初始化值函数权重 $bold(w) in bb(R)^d$（例如 $bold(w) = bold(0)$）

  对每个回合循环：\
  #h(1.5em) 初始化 $S$、$A$ 为回合的初始状态与动作（例如 ε-greedy）\
  #h(1.5em) 对该回合的每一步循环：\
  #h(3em) 采取动作 $A$，观测到 $R$、$S'$ \
  #h(3em) 如果 $S'$ 是终止状态：\
  #h(4.5em) $bold(w) arrow.l bold(w) + alpha [R - hat(q)(S, A, bold(w))] nabla hat(q)(S, A, bold(w))$ \
  #h(4.5em) 转到下一个回合\
  #h(3em) 选择 $A'$ 作为 $hat(q)(S', dot.op, bold(w))$ 的函数（例如 ε-greedy）\
  #h(3em) $bold(w) arrow.l bold(w) + alpha [R + gamma hat(q)(S', A', bold(w)) - hat(q)(S, A, bold(w))] nabla hat(q)(S, A, bold(w))$ \
  #h(3em) $S arrow.l S'$ \
  #h(3em) $A arrow.l A'$
]

#example("Mountain Car 任务")[
  考虑把一辆动力不足的小车沿陡峭的山路向上开的任务，如 @fig-10-1 左上角的示意图所示。困难在于重力比小车的引擎更强，即使全开油门，小车也无法沿陡坡加速上行。唯一的办法是先离开目标，沿左边相反的坡向上开。然后全开油门，小车就能积累足够的惯性，尽管一路上都在减速，却仍能被带着冲上陡坡。这是一个连续控制任务的简单例子，其中情况必须先变糟（离目标更远），之后才可能变好。许多控制方法在处理这类任务时都遇到很大困难，除非有设计者明确提供帮助。

  这个问题中，在小车越过山顶的目标位置之前，所有时间步（time step）的奖励（reward）都是 $-1$；越过之后回合结束。动作有三种可能：全速前进（$+1$）、全速后退（$-1$）与零油门（$0$）。小车的运动遵循简化的物理规律。它的位置 $x_t$ 与速度 $dot(x)_t$ 按下面二式更新：

  #{
    set math.equation(numbering: none)
    $ x_(t+1) ≐ italic("bound")[x_t + dot(x)_(t+1)] $
    $ dot(x)_(t+1) ≐ italic("bound")[dot(x)_t + 0.001 A_t - 0.0025 cos(3x_t)], $
  }

  其中 $italic("bound")$ 操作强制 $-1.2 <= x_(t+1) <= 0.5$ 与 $-0.07 <= dot(x)_(t+1) <= 0.07$。此外，当 $x_(t+1)$ 到达左端点时，$dot(x)_(t+1)$ 被重置为零。当它到达右端点时，就到达了目标，回合终止。每个回合都从随机位置 $x_t in [-0.6, -0.4)$ 与零速度开始。为了把这两个连续状态变量转换成二值特征，我们使用了像图 9.9 那样的网格平铺。我们用了 8 个平铺，每个瓦片在每个维度上覆盖受界距离的 $1 slash 8$，并采用第 9.5.4 节所述的非对称偏移。#footnote[具体来说，我们使用了瓦片编码软件（可从 `http://incompleteideas.net/tiles/tiles3.html` 获得），用 `iht=IHT(4096)` 与 `tiles(iht,8,[8*x/(0.5+1.2),8*xdot/(0.07+0.07)],[A])` 求得状态（`x`、`xdot`）与动作 `A` 的特征向量中那些 1 的下标。] 瓦片编码生成的特征向量 $bold(x)(s, a)$ 随后与参数向量线性组合，用来近似动作值函数：

  $ hat(q)(s, a, bold(w)) ≐ bold(w)^top bold(x)(s, a) = sum_(i=1)^d w_i dot.op x_i (s, a), $ <eq-10-3>

  其中 $s$ 与 $a$ 是任意一对状态与动作。

  @fig-10-1 展示了用这种形式的函数近似学习解决这个任务时通常会发生的情况。#footnote[这些数据实际上来自「半梯度 Sarsa($lambda$)」算法，我们要到第 12 章才会遇到它，不过半梯度 Sarsa 的表现会与之类似。] 图中给出的是单次运行中学到的值函数的负值（即#ezh[代价函数]，cost-to-go function）。初始动作值全为零，这是乐观的（这个任务中所有真实值都是负的），因此即使探索（exploration）参数 $epsilon$ 取 0，仍然出现了广泛的探索。这一点可以从图中上排中间那一幅看到，它的标签是「Step 428」。那时连一个回合都还没有完成，但小车已经在山谷中来回振荡，在状态空间里走出一条条环形轨迹。所有被频繁访问过的状态，其价值都比未被探索过的状态差，因为实际收到的奖励比（不切实际地）预期的要差。这不断把 agent 从它到过的任何地方赶开，去探索新的状态，直到找到解决办法。

  #figure(
    image("../../assets/figures/ch10/fig-10-1.png", width: 100%),
    caption: [Mountain Car 任务（左上角那一幅）与一次运行中学到的代价函数（$- max_a hat(q)(s, a, bold(w))$）。],
  )<fig-10-1>

  @fig-10-2 给出了这个问题上取不同步长时半梯度 Sarsa 的几条学习曲线。

  #figure(
    image("../../assets/figures/ch10/fig-10-2.png", width: 80%),
    caption: [使用瓦片编码函数近似与 ε-greedy 动作选择的半梯度 Sarsa 方法在 Mountain Car 上的学习曲线。],
  )<fig-10-2>
]
