#import "../../template.typ": *

== Watkins 的 Q($lambda$) 到 Tree-Backup($lambda$) <sec-12-10>

多年来人们提出了若干方法，把 Q-learning 推广到资格迹。最早的是#ezh[Watkins 的 Q($lambda$)]，只要采取的是贪婪动作，它就按通常方式衰减资格迹，而在第一个非贪婪动作之后把迹截断为零。Watkins 的 Q($lambda$) 的回溯图见 @fig-12-12。在第 6 章中，我们在 Expected Sarsa 的 off-policy 版本中统一了 Q-learning 与 Expected Sarsa，该版本把 Q-learning 作为特殊情形包含在内，并将它推广到任意目标策略；在本章上一节中，我们通过把 Expected Sarsa 推广到 off-policy 资格迹，完成了对它的讨论。然而在第 7 章中，我们把 $n$ 步 Expected Sarsa 与 $n$ 步 Tree Backup 区分开来，后者保留了不使用重要性采样的性质。于是剩下 Tree Backup 的资格迹版本需要介绍，我们把它称为#ezh[Tree-Backup($lambda$)]，或者简称#ezh[TB($lambda$)]。可以说它才是 Q-learning 的真正后继者，因为它可以应用于 off-policy 数据，同时保留了不使用重要性采样这一受人欢迎的性质。

#figure(
  image("../../assets/figures/ch12/fig-12-12.png", width: 97%),
  caption: [Watkins 的 Q($lambda$) 的回溯图。这一系列分量更新要么在回合结束时终止，要么在第一个非贪婪动作处终止，以先发生者为准。],
)<fig-12-12>

TB($lambda$) 的概念很直接。如 @fig-12-13 的回溯图所示，各种长度的 Tree Backup 更新（来自第 7.5 节）按通常方式加权，权重取决于自举参数 $lambda$。要得到详细的方程，并在一般的自举参数与折扣参数上配上正确的下标，最好从使用动作值的 $lambda$ 回报的递归形式 @eq-12-20 出发，然后仿照第 7 章的公式 7.16 展开更新目标的自举情形：

#{
  set math.equation(numbering: none)
  $ G_t^(lambda a) &≐ R_(t+1) + gamma_(t+1) lr(size: #130%, ( (1 - lambda_(t+1)) overline(V)_t (S_(t+1)) + lambda_(t+1) lr(size: #125%, [ sum_(a != A_(t+1)) pi (a|S_(t+1)) hat(q)(S_(t+1), a, bold(w)_t) + pi (A_(t+1)|S_(t+1)) G_(t+1)^(lambda a) ]) )) \
    &= R_(t+1) + gamma_(t+1) lr(size: #130%, ( overline(V)_t (S_(t+1)) + lambda_(t+1) pi (A_(t+1)|S_(t+1)) lr(size: #125%, ( G_(t+1)^(lambda a) - hat(q)(S_(t+1), A_(t+1), bold(w)_t) )) )) $
}

按照通常的模式，它也可以近似地（忽略近似值函数的变化）写成 TD 误差之和，

#{
  set math.equation(numbering: none)
  $ G_t^(lambda a) approx hat(q)(S_t, A_t, bold(w)_t) + sum_(k=t)^oo delta_k^a product_(i=t+1)^k gamma_i lambda_i pi (A_i|S_i), $
}

这里使用基于动作的 TD 误差的期望形式 @eq-12-28。

遵循与上一节相同的步骤，我们得到一个特殊的资格迹更新式，其中涉及所选动作在目标策略下的概率，

#{
  set math.equation(numbering: none)
  $ bold(z)_t ≐ gamma_t lambda_t pi (A_t|S_t) bold(z)_(t-1) + nabla hat(q)(S_t, A_t, bold(w)_t). $
}

#figure(
  image("../../assets/figures/ch12/fig-12-13.png", width: 98%),
  caption: [$lambda$ 版本的 Tree Backup 算法的回溯图。],
)<fig-12-13>

这个更新式与通常的参数更新规则 @eq-12-7 一起，定义了 TB($lambda$) 算法。与所有半梯度算法一样，当与 off-policy 数据以及强大的函数近似器一起使用时，TB($lambda$) 并不保证稳定。要获得那些保证，就必须把 TB($lambda$) 与下一节给出的方法之一结合起来。

#exercise("12.14", star: true)[Double Expected Sarsa 怎样才能推广到资格迹？]
