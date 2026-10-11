#import "../../template.typ": *

== Actor–Critic 方法 <sec-13-5>

在带基线的 REINFORCE 中，学到的状态值函数估计的是每个状态转移的#ezh[第一个]状态的值。这个估计为随后的回报设置了一个基线，但它是在该转移的动作之前作出的，因此不能用来评估那个动作。而在 actor–critic 方法中，状态值函数还被应用到状态转移的#ezh[第二个]状态。第二个状态的估计值经过折扣并加上奖励，就构成了一步回报 $G_(t:t+1)$，它是对实际回报的一种有用的估计，因此#ezh[是]评估该动作的一种途径。正如本书通篇在值函数的时序差分（temporal-difference, TD）学习中所看到的，一步回报在方差与计算适宜性方面往往优于实际回报，尽管它引入了偏差。我们也知道如何用 $n$ 步回报与资格迹灵活地调节偏差的程度（第 7 章与第 12 章）。当状态值函数以这种方式用来评估动作时，它被称为#ezh[评论家]（critic），而整个策略梯度方法被称为#ezh[actor–critic]方法。注意，梯度估计中的偏差并非来自自举（bootstrapping）本身；即使评论家是用蒙特卡洛方法学到的，actor 也会有偏差。

首先考虑一步 actor–critic 方法，它们相当于第 6 章介绍的 TD(0)、Sarsa(0) 与 Q-learning 等 TD 方法的对应物。一步方法的主要吸引力在于它们完全在线、增量式，同时又避开了资格迹（eligibility trace）的复杂性。它们是资格迹方法的特例，但更容易理解。一步 actor–critic 方法把 REINFORCE @eq-13-11 的整段回报替换为一步回报（并使用学到的状态值函数作为基线），如下所示：

$ bold(theta)_(t+1) ≐ bold(theta)_t + alpha lr(size: #130%, ( G_(t:t+1) - hat(v)(S_t, bold(w)) )) frac(nabla pi (A_t|S_t, bold(theta)_t), pi (A_t|S_t, bold(theta)_t)) $ <eq-13-12>

$ = bold(theta)_t + alpha lr(size: #130%, ( R_(t+1) + gamma hat(v)(S_(t+1), bold(w)) - hat(v)(S_t, bold(w)) )) frac(nabla pi (A_t|S_t, bold(theta)_t), pi (A_t|S_t, bold(theta)_t)) $ <eq-13-13>

$ = bold(theta)_t + alpha delta_t frac(nabla pi (A_t|S_t, bold(theta)_t), pi (A_t|S_t, bold(theta)_t)) . $ <eq-13-14>

与此搭配的自然的状态值函数学习方法是半梯度 TD(0)。完整算法的伪代码在下面的方框中给出。注意，它现在是一个完全在线、增量式的算法，状态、动作与奖励在出现时就被处理，之后不再重新访问。

#algbox([一步 actor–critic（回合情形），用于估计 $pi_bold(theta) approx pi_*$])[
  输入：可微的策略参数化 $pi (a|s, bold(theta))$ \
  输入：可微的状态值函数参数化 $hat(v)(s, bold(w))$ \
  参数：步长 $alpha^theta > 0$、$alpha^bold(w) > 0$ \
  初始化策略参数 $bold(theta) in bb(R)^(d')$ 与状态值权重 $bold(w) in bb(R)^d$（例如取 0）

  永久循环（对每个回合）：\
  #h(1.5em) 初始化 $S$（回合的第一个状态）\
  #h(1.5em) $I arrow.l 1$ \
  #h(1.5em) 当 $S$ 不是终止状态时循环（对每个时间步）：\
  #h(3em) $A tilde pi (dot.op | S, bold(theta))$ \
  #h(3em) 采取动作 $A$，观测到 $S'$、$R$ \
  #h(3em) $delta arrow.l R + gamma hat(v)(S', bold(w)) - hat(v)(S, bold(w))$ #h(0.6em) （如果 $S'$ 是终止状态，则 $hat(v)(S', bold(w)) ≐ 0$）\
  #h(3em) $bold(w) arrow.l bold(w) + alpha^bold(w) delta nabla hat(v)(S, bold(w))$ \
  #h(3em) $bold(theta) arrow.l bold(theta) + alpha^theta I delta nabla ln pi (A|S, bold(theta))$ \
  #h(3em) $I arrow.l gamma I$ \
  #h(3em) $S arrow.l S'$
]

推广到 $n$ 步方法的前向视图、再进一步推广到 $lambda$ 回报算法，都是直截了当的。@eq-13-12 中的一步回报只需分别替换为 $G_(t:t+n)$ 或 $G_t^lambda$。$lambda$ 回报算法的后向视图同样直截了当，只需要为 actor 与评论家分别使用资格迹，二者分别遵循第 12 章的模式。完整算法的伪代码在下面的方框中给出。

#algbox([带资格迹的 actor–critic（回合情形），用于估计 $pi_bold(theta) approx pi_*$])[
  输入：可微的策略参数化 $pi (a|s, bold(theta))$ \
  输入：可微的状态值函数参数化 $hat(v)(s, bold(w))$ \
  参数：迹衰减率 $lambda^theta in [0, 1]$、$lambda^bold(w) in [0, 1]$；步长 $alpha^theta > 0$、$alpha^bold(w) > 0$ \
  初始化策略参数 $bold(theta) in bb(R)^(d')$ 与状态值权重 $bold(w) in bb(R)^d$（例如取 0）

  永久循环（对每个回合）：\
  #h(1.5em) 初始化 $S$（回合的第一个状态）\
  #h(1.5em) $bold(z)^theta arrow.l bold(0)$（$d'$ 分量的资格迹向量）\
  #h(1.5em) $bold(z)^bold(w) arrow.l bold(0)$（$d$ 分量的资格迹向量）\
  #h(1.5em) $I arrow.l 1$ \
  #h(1.5em) 当 $S$ 不是终止状态时循环（对每个时间步）：\
  #h(3em) $A tilde pi (dot.op | S, bold(theta))$ \
  #h(3em) 采取动作 $A$，观测到 $S'$、$R$ \
  #h(3em) $delta arrow.l R + gamma hat(v)(S', bold(w)) - hat(v)(S, bold(w))$ #h(0.6em) （如果 $S'$ 是终止状态，则 $hat(v)(S', bold(w)) ≐ 0$）\
  #h(3em) $bold(z)^bold(w) arrow.l gamma lambda^bold(w) bold(z)^bold(w) + nabla hat(v)(S, bold(w))$ \
  #h(3em) $bold(z)^theta arrow.l gamma lambda^theta bold(z)^theta + I nabla ln pi (A|S, bold(theta))$ \
  #h(3em) $bold(w) arrow.l bold(w) + alpha^bold(w) delta bold(z)^bold(w)$ \
  #h(3em) $bold(theta) arrow.l bold(theta) + alpha^theta delta bold(z)^theta$ \
  #h(3em) $I arrow.l gamma I$ \
  #h(3em) $S arrow.l S'$
]
