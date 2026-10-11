#import "../../template.typ": *

== REINFORCE：蒙特卡洛策略梯度 <sec-13-3>

现在我们已经准备好推导第一个策略梯度学习算法。回想随机梯度上升的总体策略 @eq-13-1，它要求有一种获得样本的途径，使得样本梯度的期望正比于性能度量作为参数的函数的真实梯度。样本梯度只需要正比于梯度，因为任何比例常数都可以吸收到步长 $alpha$ 之中，而 $alpha$ 本来就可以任意选取。策略梯度定理给出了一个正比于梯度的精确表达式；所需要的只是某种采样途径，使它的期望等于或者近似这个表达式。注意，策略梯度定理的右端是一个对状态的求和，其加权方式是状态在目标策略 $pi$ 下出现的频繁程度；如果遵循 $pi$，那么状态就会按这些比例被遇到。因此

$ ∇J(bold(theta)) &prop sum_s mu(s) sum_a q_pi (s, a) nabla pi (a|s, bold(theta)) \
                  &= bb(E)_pi [ sum_a q_pi (S_t, a) nabla pi (a|S_t, bold(theta)) ] . $ <eq-13-6>

我们可以就此停下，把随机梯度上升算法 @eq-13-1 实例化为

$ bold(theta)_(t+1) ≐ bold(theta)_t + alpha sum_a hat(q)(S_t, a, bold(w)) nabla pi (a|S_t, bold(theta)), $ <eq-13-7>

其中 $hat(q)$ 是对 $q_pi$ 的某种学到的近似。这个算法之所以被称为#ezh[全动作]（all-actions）方法，是因为它的更新涉及全部动作。它很有前景，值得进一步研究，但我们当前感兴趣的是经典的 REINFORCE 算法（Williams，1992），它在时刻 $t$ 的更新只涉及 $A_t$，也就是时刻 $t$ 实际采取的那一个动作。

我们继续 REINFORCE 的推导，引入 $A_t$ 的方式与我们在 @eq-13-6 中引入 $S_t$ 的方式相同：把对随机变量各种可能取值的求和替换为在 $pi$ 下的期望，然后对这个期望采样。@eq-13-6 中已经包含了一个恰当的对动作的求和，但其中的每一项并没有按在 $pi$ 下取期望所需要的那样用 $pi (a|S_t, bold(theta))$ 加权。于是我们在不改变等式的前提下引入这样的加权：把求和的各项先乘以 $pi (a|S_t, bold(theta))$ 再除以 $pi (a|S_t, bold(theta))$。从 @eq-13-6 继续，我们有

#{
  set math.equation(numbering: none)
  $ nabla J(bold(theta)) &prop bb(E)_pi [ sum_a pi (a|S_t, bold(theta)) q_pi (S_t, a) frac(nabla pi (a|S_t, bold(theta)), pi (a|S_t, bold(theta))) ] \
    &= bb(E)_pi [ q_pi (S_t, A_t) frac(nabla pi (A_t|S_t, bold(theta)), pi (A_t|S_t, bold(theta))) ] quad ("replacing" a "by the sample" A_t tilde pi) \
    &= bb(E)_pi [ G_t frac(nabla pi (A_t|S_t, bold(theta)), pi (A_t|S_t, bold(theta))) ], quad ("because" bb(E)_pi [G_t | S_t, A_t] = q_pi (S_t, A_t)) $
}

其中 $G_t$ 一如既往是回报（return）。方括号里的最后一个表达式恰好就是所需要的量：它可以在每个时间步上采样，而且它的期望正比于梯度。用这个样本把我们的一般随机梯度上升算法 @eq-13-1 实例化，就得到 REINFORCE 更新：

$ bold(theta)_(t+1) ≐ bold(theta)_t + alpha G_t frac(nabla pi (A_t|S_t, bold(theta)_t), pi (A_t|S_t, bold(theta)_t)) . $ <eq-13-8>

这个更新有一种直观的吸引力。每一次增量正比于回报 $G_t$ 与一个向量的乘积，这个向量是实际采取的那个动作的概率的梯度除以采取该动作的概率。该向量是参数空间中能够最大程度提高在将来访问状态 $S_t$ 时重复动作 $A_t$ 的概率的方向。更新沿着这个方向按正比于回报、反比于动作概率的幅度增加参数向量。前者合理，因为它使参数在有利于带来最高回报的动作的方向上移动得最多。后者合理，因为否则被频繁选中的动作就处于优势地位（更新会更经常沿着它们的方向进行），即使它们并不带来最高的回报也可能胜出。

注意，REINFORCE 使用从时刻 $t$ 开始的完整回报，其中包含直到回合结束的全部未来奖励。在这个意义上，REINFORCE 是蒙特卡洛算法，而且只有对回合情形才有良好定义，其中全部更新都是在回合结束之后回溯作出的（像第 5 章的蒙特卡洛算法那样）。这一点在下面的方框算法中明确展示。

注意，伪代码最后一行的更新与 REINFORCE 更新规则 @eq-13-8 看起来相当不同。一个差别是，伪代码用紧凑的表达式 $nabla ln pi (A_t|S_t, bold(theta)_t)$ 表示 @eq-13-8 中的分式向量 $nabla pi (A_t|S_t, bold(theta)_t) slash pi (A_t|S_t, bold(theta)_t)$。这两个向量表达式等价，这一点由恒等式 $nabla ln x = frac(nabla x, x)$ 推出。

这个向量在文献中被赋予过若干名称与记号；我们简单地称它为#ezh[资格向量]（eligibility vector）。注意，它是算法中策略参数化出现的唯一位置。

#algbox([REINFORCE：蒙特卡洛策略梯度控制（回合情形），求 $pi_*$])[
  输入：可微的策略参数化 $pi (a|s, bold(theta))$ \
  算法参数：步长 $alpha > 0$ \
  初始化策略参数 $bold(theta) in bb(R)^(d')$（例如取 $bold(0)$）

  永久循环（对每个回合）：\
  #h(1.5em) 遵循 $pi (dot.op | dot.op, bold(theta))$ 生成一个回合 $S_0, A_0, R_1, dots.c, S_(T-1), A_(T-1), R_T$ \
  #h(1.5em) 对回合的每一步循环，$t = 0, 1, dots.c, T - 1$：\
  #h(3em) $G arrow.l sum_(k=t+1)^T gamma^(k-t-1) R_k$ #h(0.6em) $(G_t)$ \
  #h(3em) $bold(theta) arrow.l bold(theta) + alpha gamma^t G nabla ln pi (A_t|S_t, bold(theta))$
]

伪代码中的更新与 REINFORCE 更新公式 @eq-13-8 的第二个差别是，前者包含一个因子 $gamma^t$。这是因为，正如前面提到的，我们在正文中处理的是不打折扣的情形（$gamma = 1$），而在方框给出的算法中，我们给出的是一般的有折扣情形下的算法。全部思想经过适当调整后在有折扣情形下都成立（包括对原书第 199 页的方框的调整），但会引入额外的复杂性，分散我们对主要思想的注意力。

#exercise("13.2", star: true)[推广原书第 199 页的方框、策略梯度定理 @eq-13-5、策略梯度定理的证明（原书第 325 页）以及推导出 REINFORCE 更新公式 @eq-13-8 的各步骤，使 @eq-13-8 最终带有因子 $gamma^t$，从而与伪代码中给出的一般算法一致。]

@fig-13-1 展示了 REINFORCE 在例 13.1 的短走廊网格世界上的性能。

#figure(
  image("../../assets/figures/ch13/fig-13-1.png", width: 86%),
  caption: [短走廊网格世界（例 13.1）上的 REINFORCE。在合适的步长下，每个回合的总奖励趋近于起始状态的最优值。],
)<fig-13-1>

作为一种随机梯度方法，REINFORCE 具有良好的理论收敛性质。根据其构造方式，一个回合上的期望更新与性能梯度方向相同。这保证了在 $alpha$ 足够小时期望性能会改进，并且在标准的随机近似条件下，随着 $alpha$ 递减会收敛到一个局部最优。然而，作为一种蒙特卡洛方法，REINFORCE 的方差可能很大，因此学习缓慢。

#exercise("13.3")[在第 13.1 节中，我们考虑了使用动作偏好上的 soft-max @eq-13-2 与线性动作偏好 @eq-13-3 的策略参数化。对这种参数化，运用定义与初等微积分证明资格向量是

$ nabla ln pi (a|s, bold(theta)) = bold(x)(s, a) - sum_b pi (b|s, bold(theta)) bold(x)(s, b), $ <eq-13-9>

]
