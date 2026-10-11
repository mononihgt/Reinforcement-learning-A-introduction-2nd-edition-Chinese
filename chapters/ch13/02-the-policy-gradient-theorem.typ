#import "../../template.typ": *

== 策略梯度定理 <sec-13-2>

除了策略参数化相对 ε-greedy 动作选择所具有的实用优势之外，它还有一个重要的理论优势。采用连续策略参数化时，动作概率作为学到的参数的函数平滑地变化；而在 ε-greedy 选择中，只要估计的动作值发生任意小的变化，动作概率就可能剧烈变化，前提是这个变化使另一个动作取得了最大值。主要因为这个原因，策略梯度方法比动作值方法有更强的收敛保证。特别是，正是策略对参数的依赖的连续性，使策略梯度方法能够近似梯度上升 @eq-13-1。

回合情形与持续性情形对性能度量 $J(bold(theta))$ 的定义不同，因此在某种程度上必须分别处理。尽管如此，我们会尽量统一地介绍这两种情形，并建立一套记号，使主要的理论结果可以用同一组公式描述。

本节我们处理回合情形，其中性能度量定义为回合起始状态的值。通过假设每个回合都从某个特定的（非随机）状态 $s_0$ 开始，我们可以在不损失任何有意义的一般性的前提下简化记号。于是，在回合情形中我们把性能定义为

$ J(bold(theta)) ≐ v_(pi_bold(theta)) (s_0), $ <eq-13-4>

其中 $v_(pi_bold(theta))$ 是由 $bold(theta)$ 决定的策略 $pi_bold(theta)$ 的真实值函数。此后在我们的讨论中，回合情形一律假设不打折扣（$gamma = 1$），不过为了完整起见，我们在方框给出的算法中确实包含了打折扣的可能性。

在函数近似下，要以确保改进的方式改变策略参数，看起来很有挑战性。问题在于，性能同时依赖于动作的选择以及作出这些选择时所处的状态分布，而这两者都受策略参数的影响。给定一个状态，策略参数对动作的作用，从而对奖励的作用，可以借助参数化的知识以相对直接的方式计算出来。但策略参数

#mathbox("策略梯度定理的证明（回合情形）")[
  只用初等微积分与项的重新整理，我们就能从基本原理出发证明策略梯度定理。为使记号简洁，在所有情形下我们都不再显式写出 $pi$ 是 $bold(theta)$ 的函数，全部梯度也都是关于 $bold(theta)$ 的。首先注意，状态值函数的梯度可以借助动作值函数写成

  #{
    set text(size: 9.5pt)
    set math.equation(numbering: none)
    $ ∇v_pi (s) &= ∇ [ sum_a pi (a|s) q_pi (s, a) ], quad "for all" s in cal(S) && ("Exercise 3.18") \
      &= sum_a [ ∇pi (a|s) q_pi (s, a) + pi (a|s) nabla q_pi (s, a) ] && ("product rule of calculus") \
      &= sum_a [ ∇pi (a|s) q_pi (s, a) + pi (a|s) nabla sum_(s', r) p(s', r|s, a) (r + v_pi (s')) ] && ("Exercise 3.19 and Equation 3.2") \
      &= sum_a [ ∇pi (a|s) q_pi (s, a) + pi (a|s) sum_(s') p(s'|s, a) nabla v_pi (s') ] && ("Eq. 3.4") \
      &= sum_a [ ∇pi (a|s) q_pi (s, a) + pi (a|s) sum_(s') p(s'|s, a) && ("unrolling") \
      &quad quad sum_(a') [ ∇pi (a'|s') q_pi (s', a') + pi (a'|s') sum_(s'') p(s''|s', a') nabla v_pi (s'') ] ] \
      &= sum_(x in cal(S)) sum_(k=0)^oo Pr (s -> x, k, pi) sum_a ∇pi (a|x) q_pi (x, a), $
  }

  这里的最后一行来自反复的展开，其中 $Pr (s -> x, k, pi)$ 是在策略 $pi$ 下从状态 $s$ 经过 $k$ 步转移到状态 $x$ 的概率。由此立即得到

  #{
    set text(size: 9.5pt)
    set math.equation(numbering: none)
    $ ∇J(bold(theta)) &= ∇v_pi (s_0) \
      &= sum_s ( sum_(k=0)^oo Pr (s_0 -> s, k, pi) ) sum_a ∇pi (a|s) q_pi (s, a) \
      &= sum_s eta(s) sum_a ∇pi (a|s) q_pi (s, a) && ("box page 199") \
      &= sum_(s') eta(s') sum_s frac(eta(s), sum_(s') eta(s')) sum_a ∇pi (a|s) q_pi (s, a) \
      &= sum_(s') eta(s') sum_s mu(s) sum_a nabla pi (a|s) q_pi (s, a) && ("Eq. 9.3") \
      &prop sum_s mu(s) sum_a ∇pi (a|s) q_pi (s, a) && ("Q.E.D.") $
  }
]

对状态分布的作用是环境的函数，而且通常是未知的。当梯度依赖于策略改变对状态分布的那种未知作用时，我们怎样才能估计性能关于策略参数的梯度呢？

幸运的是，这个挑战有一个极好的理论答案，它以#ezh[策略梯度定理]的形式出现。策略梯度定理为性能关于策略参数的梯度（也就是我们在梯度上升 @eq-13-1 中需要近似的量）给出了一个解析表达式，其中不含状态分布的导数。回合情形的策略梯度定理表明

$ nabla J(bold(theta)) prop sum_s mu(s) sum_a q_pi (s, a) nabla pi (a|s, bold(theta)), $ <eq-13-5>

其中梯度是关于 $bold(theta)$ 各分量的偏导数组成的列向量，$pi$ 表示参数向量 $bold(theta)$ 对应的策略。这里符号 $prop$ 的意思是「正比于」。在回合情形中，比例常数是一个回合的平均长度；在持续性情形中它是 1，因此这个关系其实是等式。这里的分布 $mu$（如同第 9 章与第 10 章）是 $pi$ 下的 on-policy 分布（见原书第 199 页）。回合情形下的策略梯度定理在前面的方框中得到证明。
