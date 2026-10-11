#import "../../template.typ": *

== 梯度赌博机算法 <sec-2-8>

本章到目前为止，我们考虑的都是估计动作值、再用这些估计来选择动作的方法。这常常是一种好做法，但它并不是唯一可能的做法。在这一节中，我们考虑为每个动作 $a$ 学习一个数值#ezh[偏好]，记作 $H_t (a) in bb(R)$。偏好越大，该动作被采取得越频繁，但偏好在奖励的意义上没有解释。重要的只是一个动作相对于另一个动作的相对偏好；如果给所有动作偏好都加上 1000，对动作概率毫无影响，这些概率按照如下的 soft-max 分布（即吉布斯分布或玻尔兹曼分布）确定：

$ "Pr"{A_t = a} ≐ frac(e^(H_t (a)), sum_(b=1)^k e^(H_t (b))) ≐ pi_t (a), $ <eq-2-11>

这里我们还引入了一个有用的新记号 $pi_t (a)$，表示在时间 $t$ 采取动作 $a$ 的概率。初始时所有动作偏好都相同（例如对所有 $a$ 都有 $H_1 (a) = 0$），因此所有动作被选中的概率相等。

#exercise("2.9")[证明在两个动作的情形中，soft-max 分布与统计学和人工神经网络中常用的 logistic 函数（即 sigmoid 函数）所给出的分布相同。]

基于随机梯度上升的思想，soft-max 动作偏好有一个自然的学习算法。在每一步，选择动作 $A_t$ 并收到奖励 $R_t$ 之后，动作偏好按如下方式更新：

$ H_(t+1)(A_t) ≐ H_t (A_t) + alpha (R_t - overline(R)_t)(1 - pi_t (A_t)), &quad "and" \
  H_(t+1)(a) ≐ H_t (a) - alpha (R_t - overline(R)_t) pi_t (a), &quad "for all " a != A_t, $ <eq-2-12>

其中 $alpha > 0$ 是步长参数，$overline(R)_t in bb(R)$ 是截至时间 $t$（不包括时间 $t$）的奖励平均值（其中 $overline(R)_1 ≐ R_1$），它可以按第 2.4 节所述（如果问题非平稳，则按第 2.5 节所述）增量式地计算。#footnote[本章的经验结果中，基线 $overline(R)_t$ 也把 $R_t$ 包含在内。] $overline(R)_t$ 这一项充当奖励与之比较的基线。如果奖励高于基线，那么今后采取 $A_t$ 的概率增大；如果奖励低于基线，那么该概率减小。未被选中的动作则朝相反方向移动。

@fig-2-5 展示了梯度赌博机算法在 10 臂测试平台的一个变体上的结果，其中真实的期望奖励依照均值为 $+4$（而非 0）的正态分布选择（单位方差与前相同）。由于奖励基线项会立即适应新的水平，把所有奖励整体上移对梯度赌博机算法完全没有影响。但如果省略基线（也就是说，在 @eq-2-12 中令 $overline(R)_t$ 恒为零），表现会显著变差，如图所示。

#figure(
  image("../../assets/figures/ch02/fig-2-5.png", width: 73%),
  caption: [梯度赌博机算法在有、无奖励基线两种情况下于 10 臂测试平台上的平均表现，其中 $q_* (a)$ 选在接近 $+4$ 的位置而非接近零。],
)<fig-2-5>

#mathbox("梯度赌博机算法即随机梯度上升")[
  #set math.equation(numbering: none)

  把梯度赌博机算法理解为梯度上升的一种随机近似，可以更深入地理解它。在精确的#ezh[梯度上升]中，每个动作偏好 $H_t (a)$ 会按照该增量对性能的影响成比例地增加：

  #math.equation(block: true, numbering: numbered-with-chapter("(1.1)"), $ H_(t+1)(a) ≐ H_t (a) + alpha frac(partial bb(E)[R_t], partial H_t (a)), $) <eq-2-13>

  这里的性能度量是期望奖励：

  $ bb(E)[R_t] = sum_x pi_t (x) q_* (x), $

  而增量影响的度量是这个性能度量关于动作偏好的#ezh[偏导数]。当然，在我们的情形中无法精确地实现梯度上升，因为按照假定我们并不知道 $q_* (x)$；但实际上，我们的算法 @eq-2-12 的更新在期望意义上等于 @eq-2-13，这使该算法成为#ezh[随机梯度上升]的一个实例。证明这一点所需的计算只用到初等微积分，但要经过好几步。首先我们更仔细地考察精确的性能梯度：

  $ frac(partial bb(E)[R_t], partial H_t (a)) &= frac(partial, partial H_t (a)) [sum_x pi_t (x) q_* (x)] \
    &= sum_x q_* (x) frac(partial pi_t (x), partial H_t (a)) \
    &= sum_x (q_* (x) - B_t) frac(partial pi_t (x), partial H_t (a)), $

  其中 $B_t$ 称为#ezh[基线]，它可以是任何不依赖于 $x$ 的标量。我们可以在这里引入一个基线而不改变等式的成立，因为梯度对所有动作求和为零，$sum_x frac(partial pi_t (x), partial H_t (a)) = 0$。当 $H_t (a)$ 发生变化时，有些动作的概率上升，有些下降，但变化之和必定为零，因为概率之和始终为 1。

  接下来我们把求和中的每一项都乘以 $pi_t (x) slash pi_t (x)$：

  $ frac(partial bb(E)[R_t], partial H_t (a)) = sum_x pi_t (x)(q_* (x) - B_t) frac(partial pi_t (x), partial H_t (a)) slash pi_t (x). $

  这个等式现在具有期望的形式：对随机变量 $A_t$ 的所有可能取值 $x$ 求和，再乘以采取这些取值的概率。于是：

  $ = bb(E)[(q_* (A_t) - B_t) frac(partial pi_t (A_t), partial H_t (a)) slash pi_t (A_t)] \
    = bb(E)[(R_t - overline(R)_t) frac(partial pi_t (A_t), partial H_t (a)) slash pi_t (A_t)], $

  这里我们取基线 $B_t = overline(R)_t$，并用 $R_t$ 替代 $q_* (A_t)$，这是允许的，因为 $bb(E)[R_t | A_t] = q_* (A_t)$。稍后我们会证明 $frac(partial pi_t (x), partial H_t (a)) = pi_t (x)(bb(1)_(a=x) - pi_t (a))$，其中 $bb(1)_(a=x)$ 在 $a = x$ 时定义为 1，否则为 0。暂且假定它成立，我们得到

  $ = bb(E)[(R_t - overline(R)_t) pi_t (A_t)(bb(1)_(a=A_t) - pi_t (a)) slash pi_t (A_t)] \
    = bb(E)[(R_t - overline(R)_t)(bb(1)_(a=A_t) - pi_t (a))]. $

  回想一下，我们的计划一直是将性能梯度写成可以在每一步采样的某个量的期望，正如我们刚刚做的那样，然后每一步按照这个样本成比例地更新。把上面那个期望的一个样本代入 @eq-2-13 中的性能梯度，得到：

  $ H_(t+1)(a) = H_t (a) + alpha (R_t - overline(R)_t)(bb(1)_(a=A_t) - pi_t (a)), quad "for all " a, $

  你可能已经看出，它等价于我们最初的算法 @eq-2-12。

  于是只剩下证明我们假定的那个等式 $frac(partial pi_t (x), partial H_t (a)) = pi_t (x)(bb(1)_(a=x) - pi_t (a))$。回想一下导数标准的商法则：

  $ frac(partial, partial x) [frac(f(x), g(x))] = frac(frac(partial f(x), partial x) g(x) - f(x) frac(partial g(x), partial x), g(x)^2). $

  利用它，我们可以写出

  $ frac(partial pi_t (x), partial H_t (a)) &= frac(partial, partial H_t (a)) pi_t (x) \
    &= frac(partial, partial H_t (a)) [frac(e^(H_t (x)), sum_(y=1)^k e^(H_t (y)))] \
    &= frac(frac(partial e^(H_t (x)), partial H_t (a)) sum_(y=1)^k e^(H_t (y)) - e^(H_t (x)) frac(partial sum_(y=1)^k e^(H_t (y)), partial H_t (a)), (sum_(y=1)^k e^(H_t (y)))^2) &quad "(by the quotient rule)" \
    &= frac(bb(1)_(a=x) e^(H_t (x)) sum_(y=1)^k e^(H_t (y)) - e^(H_t (x)) e^(H_t (a)), (sum_(y=1)^k e^(H_t (y)))^2) &quad "(because " frac(partial e^x, partial x) = e^x ")" \
    &= frac(bb(1)_(a=x) e^(H_t (x)), sum_(y=1)^k e^(H_t (y))) - frac(e^(H_t (x)) e^(H_t (a)), (sum_(y=1)^k e^(H_t (y)))^2) \
    &= bb(1)_(a=x) pi_t (x) - pi_t (x) pi_t (a) \
    &= pi_t (x)(bb(1)_(a=x) - pi_t (a)). quad "Q.E.D." $

  我们刚刚证明了，梯度赌博机算法的期望更新等于期望奖励的梯度，因此该算法是随机梯度上升的一个实例。这使我们确信，该算法具有稳健的收敛性质。

  注意，对于奖励基线，除了要求它不依赖于所选动作之外，我们不需要它有别的任何性质。例如，我们可以把它设为零，或者设为 1000，算法仍将是随机梯度上升的一个实例。基线的选择不影响算法的期望更新，但它影响更新的方差，从而影响收敛速度（例如 @fig-2-5 所示）。把基线取为奖励的平均值也许不是最好的做法，但它简单，而且在实践中效果很好。
]
