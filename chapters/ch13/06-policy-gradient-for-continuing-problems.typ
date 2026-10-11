#import "../../template.typ": *

== 持续性问题的策略梯度 <sec-13-6>

正如第 10.3 节所讨论的，对于没有回合边界的持续性问题，我们需要用每个时间步的平均奖励率来定义性能：

$ J(bold(theta)) &≐ r(pi) ≐ lim_(h -> oo) frac(1, h) sum_(t=1)^h bb(E) [R_t | S_0, A_(0:t-1) tilde pi] \
  &= lim_(t -> oo) bb(E) [R_t | S_0, A_(0:t-1) tilde pi] \
  &= sum_s mu(s) sum_a pi (a|s) sum_(s', r) p(s', r | s, a) r, $ <eq-13-15>

其中 $mu$ 是 $pi$ 下的稳态分布，$mu(s) ≐ lim_(t -> oo) Pr {S_t = s | A_(0:t) tilde pi}$，并且假定它存在而且与 $S_0$ 无关（一个遍历性假定）。记住这是这样一个特殊的分布：如果按照 $pi$ 选择动作，你就会保持在同一个分布之中：

$ sum_s mu(s) sum_a pi (a|s, bold(theta)) p(s'|s, a) = mu(s'), quad "for all" s' in cal(S). $ <eq-13-16>

持续性情形下 actor–critic 算法（后向视图）的完整伪代码在下面的方框中给出。

#algbox([带资格迹的 actor–critic（持续性情形），用于估计 $pi_bold(theta) approx pi_*$])[
  输入：可微的策略参数化 $pi (a|s, bold(theta))$ \
  输入：可微的状态值函数参数化 $hat(v)(s, bold(w))$ \
  算法参数：$lambda^bold(w) in [0, 1]$、$lambda^theta in [0, 1]$、$alpha^bold(w) > 0$、$alpha^theta > 0$、$alpha^(overline(R)) > 0$ \
  初始化 $overline(R) in bb(R)$（例如取 0）\
  初始化状态值权重 $bold(w) in bb(R)^d$ 与策略参数 $bold(theta) in bb(R)^(d')$（例如取 0）\
  初始化 $S in cal(S)$（例如取 $s_0$）

  $bold(z)^bold(w) arrow.l bold(0)$（$d$ 分量的资格迹向量）\
  $bold(z)^theta arrow.l bold(0)$（$d'$ 分量的资格迹向量）\
  永久循环（对每个时间步）：\
  #h(1.5em) $A tilde pi (dot.op | S, bold(theta))$ \
  #h(1.5em) 采取动作 $A$，观测到 $S'$、$R$ \
  #h(1.5em) $delta arrow.l R - overline(R) + hat(v)(S', bold(w)) - hat(v)(S, bold(w))$ \
  #h(1.5em) $overline(R) arrow.l overline(R) + alpha^(overline(R)) delta$ \
  #h(1.5em) $bold(z)^bold(w) arrow.l lambda^bold(w) bold(z)^bold(w) + nabla hat(v)(S, bold(w))$ \
  #h(1.5em) $bold(z)^theta arrow.l lambda^theta bold(z)^theta + nabla ln pi (A|S, bold(theta))$ \
  #h(1.5em) $bold(w) arrow.l bold(w) + alpha^bold(w) delta bold(z)^bold(w)$ \
  #h(1.5em) $bold(theta) arrow.l bold(theta) + alpha^theta delta bold(z)^theta$ \
  #h(1.5em) $S arrow.l S'$
]

自然，在持续性情形中，我们定义值 $v_pi (s) ≐ bb(E)_pi [G_t | S_t = s]$ 与 $q_pi (s, a) ≐ bb(E)_pi [G_t | S_t = s, A_t = a]$，它们都是关于差分回报的：

$ G_t ≐ R_(t+1) - r(pi) + R_(t+2) - r(pi) + R_(t+3) - r(pi) + dots.c . $ <eq-13-17>

有了这些替代定义，针对回合情形给出的策略梯度定理 @eq-13-5 在持续性情形中仍然成立。证明在下面的方框中给出。前向视图与后向视图的公式也保持不变。

#mathbox("策略梯度定理的证明（持续性情形）")[
  持续性情形的策略梯度定理的证明以与回合情形类似的方式开始。同样，我们在所有情形下都不再显式写出 $pi$ 是 $bold(theta)$ 的函数，全部梯度也都是关于 $bold(theta)$ 的。回想在持续性情形中 $J(bold(theta)) = r(pi)$（@eq-13-15），并且 $v_pi$ 与 $q_pi$ 表示关于差分回报 @eq-13-17 的值。状态值函数的梯度对任何 $s in cal(S)$ 可以写成

  #{
    set text(size: 9.5pt)
    set math.equation(numbering: none)
    $ ∇v_pi (s) &= ∇ [ sum_a pi (a|s) q_pi (s, a) ], quad "for all" s in cal(S) && ("Exercise 3.18") \
      &= sum_a [ ∇pi (a|s) q_pi (s, a) + pi (a|s) nabla q_pi (s, a) ] && ("product rule of calculus") \
      &= sum_a [ ∇pi (a|s) q_pi (s, a) + pi (a|s) nabla sum_(s', r) p(s', r|s, a) (r - r(bold(theta)) + v_pi (s')) ] \
      &= sum_a [ ∇pi (a|s) q_pi (s, a) + pi (a|s) [ -nabla r(bold(theta)) + sum_(s') p(s'|s, a) nabla v_pi (s') ] ] . $
  }

  重新整理各项之后，我们得到

  #{
    set text(size: 9.5pt)
    set math.equation(numbering: none)
    $ nabla r(bold(theta)) = sum_a [ nabla pi (a|s) q_pi (s, a) + pi (a|s) sum_(s') p(s'|s, a) nabla v_pi (s') ] - nabla v_pi (s). $
  }

  注意，左端可以写成 $nabla J(bold(theta))$，而且它不依赖于 $s$。因此右端也不依赖于 $s$，我们可以放心地把它对全部 $s in cal(S)$ 求和，并用 $mu(s)$ 加权而不会改变它（因为 $sum_s mu(s) = 1$）：

  #{
    set text(size: 9.5pt)
    set math.equation(numbering: none)
    $ ∇J(bold(theta)) &= sum_s mu(s) ( sum_a [ ∇pi (a|s) q_pi (s, a) + pi (a|s) sum_(s') p(s'|s, a) nabla v_pi (s') ] - ∇v_pi (s) ) \
      &= sum_s mu(s) sum_a ∇pi (a|s) q_pi (s, a) \
      &quad + sum_s mu(s) sum_a pi (a|s) sum_(s') p(s'|s, a) nabla v_pi (s') - sum_s mu(s) ∇v_pi (s) \
      &= sum_s mu(s) sum_a ∇pi (a|s) q_pi (s, a) \
      &quad + sum_(s') underbrace( sum_s mu(s) sum_a pi (a|s) p(s'|s, a), mu(s') quad (13.16) ) nabla v_pi (s') - sum_s mu(s) ∇v_pi (s) \
      &= sum_s mu(s) sum_a ∇pi (a|s) q_pi (s, a) + sum_(s') mu(s') ∇v_pi (s') - sum_s mu(s) ∇v_pi (s) \
      &= sum_s mu(s) sum_a ∇pi (a|s) q_pi (s, a). quad "Q.E.D." $
  }
]
