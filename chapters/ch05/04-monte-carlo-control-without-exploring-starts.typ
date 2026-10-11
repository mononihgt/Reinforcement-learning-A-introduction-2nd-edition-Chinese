#import "../../template.typ": *

== 不使用探索起始的蒙特卡洛控制 <sec-5-4>

我们怎样才能避免探索起始这个不大可能成立的假定呢？要保证所有动作都被选择无穷多次，唯一的通用办法是让 agent 持续选择它们。有两种做法可以保证这一点，它们分别产生我们所说的 #emph[on-policy] 方法与 #emph[off-policy] 方法。on-policy 方法试图评估或改进用来作决策的那个策略，而 off-policy 方法评估或改进的策略与用来生成数据的策略不同。上面介绍的蒙特卡洛 ES 方法就是 on-policy 方法的一个例子。本小节我们说明如何设计一种不使用探索起始这一不现实假定的 on-policy 蒙特卡洛控制方法。off-policy 方法在下一节考虑。

在 on-policy 控制方法中，策略一般是软策略，也就是说对所有的 $s in cal(S)$ 与所有的 $a in cal(A)(s)$ 都有 $pi (a|s) > 0$，但会逐渐向一个确定性最优策略靠近。第 2 章讨论的许多方法都为此提供了机制。本节介绍的 on-policy 方法使用 $epsilon$-#emph[greedy] 策略，也就是大多数时候选择估计动作值最大的动作，但有概率 $epsilon$ 随机选择一个动作。也就是说，所有非贪婪动作都被赋予最小的选择概率 $frac(epsilon, |cal(A)(s)|)$，剩余的大部分概率 $1 - epsilon + frac(epsilon, |cal(A)(s)|)$ 赋予贪婪动作。$epsilon$-greedy 策略是 $epsilon$-#emph[soft] 策略的例子，$epsilon$-soft 策略定义为对某个 $epsilon > 0$、对所有状态与动作都有 $pi (a|s) >= frac(epsilon, |cal(A)(s)|)$ 的策略。在 $epsilon$-soft 策略中，$epsilon$-greedy 策略在某种意义上是最接近贪婪的那些策略。

on-policy 蒙特卡洛控制的总体思路仍然是 GPI。与蒙特卡洛 ES 一样，我们用首次访问 MC 方法估计当前策略的动作值函数。然而，在没有探索起始假定的情况下，我们不能简单地通过让策略相对于当前值函数成为贪婪的来改进它，因为那样会妨碍对非贪婪动作的进一步探索。幸运的是，GPI 并不要求把策略一路推进到贪婪策略，只要求把它向贪婪策略的方向#ezh[推进]。在我们的 on-policy 方法中，我们只把它推进到 $epsilon$-greedy 策略。对任意的 $epsilon$-soft 策略 $pi$，相对于 $q_pi$ 的任意 $epsilon$-greedy 策略都保证不差于 $pi$。完整的算法在下面方框中给出。

#algbox([on-policy 首次访问 MC 控制（用于 $epsilon$-soft 策略），估计 $pi approx pi_*$])[
  算法参数：一个很小的 $epsilon > 0$ \
  初始化：\
  #h(1.5em) $pi arrow.l "an arbitrary" epsilon "-soft policy"$ \
  #h(1.5em) $Q(s, a) in bb(R)$（任意取值），对全部的 $s in cal(S)$、$a in cal(A)(s)$ \
  #h(1.5em) $italic("Returns")(s, a) arrow.l "empty list"$，对全部的 $s in cal(S)$、$a in cal(A)(s)$

  永久重复（对每个回合）：\
  #h(1.5em) 遵循 $pi$ 生成一个回合：$S_0, A_0, R_1, dots.c, S_(T-1), A_(T-1), R_T$ \
  #h(1.5em) $G arrow.l 0$ \
  #h(1.5em) 对回合的每一步循环，$t = T-1, T-2, dots.c, 0$：\
  #h(3em) $G arrow.l gamma G + R_(t+1)$ \
  #h(3em) 除非配对 $S_t, A_t$ 出现在 $S_0, A_0, S_1, A_1 dots.c, S_(t-1), A_(t-1)$ 中：\
  #h(4.5em) 把 $G$ 追加到 $italic("Returns")(S_t, A_t)$ \
  #h(4.5em) $Q(S_t, A_t) arrow.l "average"(italic("Returns")(S_t, A_t))$ \
  #h(4.5em) $A^* arrow.l op("argmax", limits: #true)_a Q(S_t, a)$（出现平局时任意打破）\
  #h(4.5em) 对全部的 $a in cal(A)(S_t)$：\
  #h(6em) $pi (a|S_t) arrow.l 1 - epsilon + frac(epsilon, |cal(A)(S_t)|) quad "if" a = A^*$ \
  #h(6em) $pi (a|S_t) arrow.l frac(epsilon, |cal(A)(S_t)|) quad "if" a != A^*$
]

相对于 $q_pi$ 的任意 $epsilon$-greedy 策略都不差于任意 $epsilon$-soft 策略 $pi$，这一点由策略改进定理保证。设 $pi'$ 为 $epsilon$-greedy 策略。策略改进定理的条件成立，因为对任意的 $s in cal(S)$：

$ q_pi (s, pi' (s)) &= sum_a pi' (a|s) q_pi (s, a) \
                    &= frac(epsilon, |cal(A)(s)|) sum_a q_pi (s, a) + (1 - epsilon) max_a q_pi (s, a) \
                    &>= frac(epsilon, |cal(A)(s)|) sum_a q_pi (s, a) + (1 - epsilon) sum_a frac(pi (a|s) - frac(epsilon, |cal(A)(s)|), 1 - epsilon) q_pi (s, a) $ <eq-5-2>

（这个求和是一个加权平均，权重非负且和为 1，因此它必然小于或等于被平均的那些数中最大的一个）

#{
  set math.equation(numbering: none)
  $ &= frac(epsilon, |cal(A)(s)|) sum_a q_pi (s, a) - frac(epsilon, |cal(A)(s)|) sum_a q_pi (s, a) + sum_a pi (a|s) q_pi (s, a) \
    &= v_pi (s). $
}

于是，由策略改进定理，$pi' >= pi$（即对所有的 $s in cal(S)$ 都有 $v_(pi') (s) >= v_pi (s)$）。下面我们证明，等号成立只可能在 $pi'$ 与 $pi$ 都是 $epsilon$-soft 策略中最优的时候，也就是它们不差于所有其他 $epsilon$-soft 策略的时候。

考虑一个新环境，它与原环境完全一样，只是把「策略必须是 $epsilon$-soft」这一要求#ezh[移入]了环境内部。新环境具有与原环境相同的动作集与状态集，其行为如下。如果在状态 $s$ 采取动作 $a$，那么新环境以概率 $1 - epsilon$ 表现得与原环境完全相同。以概率 $epsilon$，它重新随机选取动作（各个动作被选中的概率相等），然后带着这个新的随机动作，按原环境的方式继续运行。在新环境中用一般策略所能达到的最好结果，与原环境中用 $epsilon$-soft 策略所能达到的最好结果相同。设 $tilde(v)_*$ 与 $tilde(q)_*$ 表示新环境的最优值函数。那么，策略 $pi$ 在 $epsilon$-soft 策略中是最优策略，当且仅当 $v_pi = tilde(v)_*$。我们知道，$tilde(v)_*$ 是转移概率改变后的贝尔曼最优方程（第 3 章的公式 3.19）的唯一解：

#{
  set math.equation(numbering: none)
  $ tilde(v)_* (s) &= max_a sum_(s', r) [(1 - epsilon) p(s', r | s, a) + sum_(a') frac(epsilon, |cal(A)(s)|) p(s', r | s, a')] [r + gamma tilde(v)_* (s')] \
                   &= (1 - epsilon) max_a sum_(s', r) p(s', r | s, a) [r + gamma tilde(v)_* (s')] \
                   &quad + frac(epsilon, |cal(A)(s)|) sum_a sum_(s', r) p(s', r | s, a) [r + gamma tilde(v)_* (s')]. $
}

当等号成立、$epsilon$-soft 策略 $pi$ 不再得到改进时，由 @eq-5-2 我们还知道

#{
  set math.equation(numbering: none)
  $ v_pi (s) &= (1 - epsilon) max_a q_pi (s, a) + frac(epsilon, |cal(A)(s)|) sum_a q_pi (s, a) \
             &= (1 - epsilon) max_a sum_(s', r) p(s', r | s, a) [r + gamma v_pi (s')] \
             &quad + frac(epsilon, |cal(A)(s)|) sum_a sum_(s', r) p(s', r | s, a) [r + gamma v_pi (s')]. $
}

然而，除了用 $v_pi$ 替换 $tilde(v)_*$ 之外，这个方程与上一个方程相同。由于 $tilde(v)_*$ 是唯一解，必定有 $v_pi = tilde(v)_*$。

实质上，我们在前面几页里已经说明，策略迭代对 $epsilon$-soft 策略同样有效。使用 $epsilon$-soft 策略的自然的贪婪策略概念，就能保证每一步都有改进，除非已经在 $epsilon$-soft 策略中找到了最好的策略。这一分析与各阶段如何确定动作值函数无关，但它确实假定动作值函数被精确计算。这把我们带到了与上一节大致相同的位置。现在我们只能得到 $epsilon$-soft 策略中最好的策略，但从另一方面看，我们已经消除了探索起始假设。
