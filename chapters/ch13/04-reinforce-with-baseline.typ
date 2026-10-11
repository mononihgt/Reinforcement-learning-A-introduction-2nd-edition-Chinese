#import "../../template.typ": *

== 带基线的 REINFORCE <sec-13-4>

策略梯度定理 @eq-13-5 可以推广到把动作值与任意#ezh[基线]（baseline）$b(s)$ 作比较的情形：

$ nabla J(bold(theta)) prop sum_s mu(s) sum_a lr(size: #125%, ( q_pi (s, a) - b(s) )) nabla pi (a|s, bold(theta)), $ <eq-13-10>

基线可以是任何函数，甚至可以是随机变量，只要它不随 $a$ 变化；等式仍然成立，因为被减去的量等于零：

#{
  set math.equation(numbering: none)
  $ sum_a b(s) nabla pi (a|s, bold(theta)) = b(s) nabla sum_a pi (a|s, bold(theta)) = b(s) nabla 1 = 0. $
}

带基线的策略梯度定理 @eq-13-10 可以用与上一节类似的步骤导出一个更新规则。我们最终得到的更新规则是 REINFORCE 的一个新版本，其中包含一个一般的基线：

$ bold(theta)_(t+1) ≐ bold(theta)_t + alpha lr(size: #130%, ( G_t - b(S_t) )) frac(nabla pi (A_t|S_t, bold(theta)_t), pi (A_t|S_t, bold(theta)_t)) . $ <eq-13-11>

由于基线可以恒为零，这个更新是 REINFORCE 的严格推广。一般来说，基线使更新的期望值保持不变，但它可能对更新的方差有很大影响。例如，我们在第 2.8 节看到，类似的基线可以显著降低梯度赌博机算法的方差（从而加快学习）。在赌博机算法中，基线只是一个数（迄今为止见过的奖励的平均值），但对 MDP 来说，基线应当随状态而变化。在某些状态中全部动作都有很高的值，我们需要一个很高的基线才能把值较高的动作与值较低的动作区分开来；在另一些状态中全部动作的值都很低，这时低的基线是合适的。

基线的一种自然选择是状态值的估计 $hat(v)(S_t, bold(w))$，其中 $bold(w) in bb(R)^d$ 是由前面各章介绍的某种方法学到的权重向量。因为 REINFORCE 是学习策略参数 $bold(theta)$ 的蒙特卡洛方法，自然也可以用蒙特卡洛方法来学习状态值权重 $bold(w)$。使用这样学到的状态值函数作为基线的完整 REINFORCE 伪代码算法在下面的方框中给出。

#algbox([带基线的 REINFORCE（回合情形），用于估计 $pi_bold(theta) approx pi_*$])[
  输入：可微的策略参数化 $pi (a|s, bold(theta))$ \
  输入：可微的状态值函数参数化 $hat(v)(s, bold(w))$ \
  算法参数：步长 $alpha^theta > 0$、$alpha^bold(w) > 0$ \
  初始化策略参数 $bold(theta) in bb(R)^(d')$ 与状态值权重 $bold(w) in bb(R)^d$（例如取 0）

  永久循环（对每个回合）：\
  #h(1.5em) 遵循 $pi (dot.op | dot.op, bold(theta))$ 生成一个回合 $S_0, A_0, R_1, dots.c, S_(T-1), A_(T-1), R_T$ \
  #h(1.5em) 对回合的每一步循环，$t = 0, 1, dots.c, T - 1$：\
  #h(3em) $G arrow.l sum_(k=t+1)^T gamma^(k-t-1) R_k$ #h(0.6em) $(G_t)$ \
  #h(3em) $delta arrow.l G - hat(v)(S_t, bold(w))$ \
  #h(3em) $bold(w) arrow.l bold(w) + alpha^bold(w) delta nabla hat(v)(S_t, bold(w))$ \
  #h(3em) $bold(theta) arrow.l bold(theta) + alpha^theta gamma^t delta nabla ln pi (A_t|S_t, bold(theta))$
]

这个算法有两个步长，分别记作 $alpha^theta$ 与 $alpha^bold(w)$（其中 $alpha^theta$ 就是 @eq-13-11 中的 $alpha$）。为值函数选择步长（这里是 $alpha^bold(w)$）相对容易；在线性情形中我们有设置它的经验法则，例如 $alpha^bold(w) = 0.1 slash bb(E) [ norm(nabla hat(v)(S_t, bold(w)))_mu^2 ]$（见第 9.6 节）。为策略参数设置步长 $alpha^theta$ 则远不这么清楚，它的最佳取值取决于奖励的变化范围以及策略参数化。

#figure(
  image("../../assets/figures/ch13/fig-13-2.png", width: 84%),
  caption: [在 REINFORCE 中加入基线可以使它学习得快得多，此处以短走廊网格世界（例 13.1）为例说明。这里用于普通 REINFORCE 的步长是它表现最好的步长（精确到 2 的幂；见 @fig-13-1）。],
)<fig-13-2>

@fig-13-2 比较了有基线与无基线的 REINFORCE 在短走廊网格世界（例 13.1）上的行为。这里基线中使用的近似状态值函数是 $hat(v)(s, bold(w)) = w$。也就是说，$bold(w)$ 只有一个分量 $w$。
