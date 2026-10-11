#import "../../template.typ": *

== Q-learning：off-policy TD 控制 <sec-6-5>

强化学习早期的突破之一，是一种名为#ezh[Q-learning]（Watkins, 1989）的 off-policy TD 控制算法的提出，它定义为

$ Q(S_t, A_t) arrow.l Q(S_t, A_t) + alpha [R_(t+1) + gamma max_a Q(S_(t+1), a) - Q(S_t, A_t)]. $ <eq-6-8>

在这里，学到的动作值函数 $Q$ 直接逼近最优动作值函数 $q_*$，与所遵循的策略无关。这极大地简化了对算法的分析，也使早期的收敛性证明成为可能。策略仍然有影响，因为它决定了哪些状态–动作对被访问和更新。不过，正确收敛所需要的只是所有状态–动作对都持续得到更新。正如我们在第 5 章观察到的，这是一个最低限度的要求，因为在一般情况下，任何保证找到最优行为的方法都必须满足它。在这个假定下，再加上关于步长参数序列的通常随机近似条件的一个变体，已经证明 $Q$ 以概率 1 收敛到 $q_*$。Q-learning 算法以过程形式在下面给出。

#algbox([Q-learning（off-policy TD 控制），用于估计 $pi approx pi_*$])[
  算法参数：步长 $alpha in (0, 1]$，很小的 $epsilon > 0$ \
  初始化 $Q(s, a)$，对全部的 $s in cal(S)^+$、$a in cal(A)(s)$，任意取值，但 $Q("terminal", dot.op) = 0$

  对每个回合循环：\
  #h(1.5em) 初始化 $S$ \
  #h(1.5em) 对回合的每一步循环：\
  #h(3em) 用由 $Q$ 导出的策略（例如 $epsilon$-greedy）从 $S$ 选择 $A$ \
  #h(3em) 采取动作 $A$，观测到 $R$、$S'$ \
  #h(3em) $Q(S, A) arrow.l Q(S, A) + alpha [R + gamma max_a Q(S', a) - Q(S, A)]$ \
  #h(3em) $S arrow.l S'$ \
  #h(1.5em) 直到 $S$ 是终止状态
]

Q-learning 的回溯图是什么？规则 @eq-6-8 更新一个状态–动作对，所以顶部的节点，也就是更新的根节点，必须是一个小的实心动作节点。这个更新也#ezh[来自]动作节点，并且要在下一状态中所有可能的这些动作上取最大值。因此，回溯图底部的节点应该是所有这些动作节点。最后，回想一下，我们用一条横跨这些「下一动作」节点的弧线来表示对它们取最大值（图 3.4 右侧）。你现在能猜出这个图是什么样子吗？如果能，请在翻到 @fig-6-4（原书第 134 页）查看答案之前先自己猜一猜。

#example("悬崖行走")[
  #grid(
    columns: (1fr, 60%),
    column-gutter: 1.2em,
    align: (left + top, center + top),
    [
      这个网格世界例题比较 Sarsa 与 Q-learning，突出 on-policy（Sarsa）方法与 off-policy（Q-learning）方法之间的差别。考虑右图所示的网格世界。这是一个标准的、不做折扣的回合任务，带起始状态与目标状态，通常的四种动作引起向上、向下、向右与向左的移动。除进入标着「The Cliff」（悬崖）的区域之外，所有转移的奖励都是 $-1$。踏入这个区域会招致 $-100$ 的奖励，并立即把 agent 送回起点。
    ],
    image("../../assets/figures/ch06/fig-6-inline-8.png", width: 100%),
  )

  #grid(
    columns: (1fr, 61%),
    column-gutter: 1.2em,
    align: (left + top, center + top),
    [
      右图展示了 Sarsa 与 Q-learning 在 $epsilon$-greedy 动作选择、$epsilon = 0.1$ 时的表现。经过最初的一段过渡之后，Q-learning 学到了最优策略的值，这个策略沿着悬崖边缘向右走。不幸的是，由于 $epsilon$-greedy 动作选择，这导致它偶尔会跌下悬崖。另一方面，Sarsa 把动作选择的影响考虑在内，学会了从网格上方的部分通过、更长但更安全的路径。尽管 Q-learning 学到的确实是最优策略的值，但它的在线表现比 Sarsa 更差，而 Sarsa 学到的是绕行的策略。当然，如果 $epsilon$ 逐渐减小，那么两种方法都会渐近地收敛到最优策略。
    ],
    image("../../assets/figures/ch06/fig-6-inline-9.png", width: 100%),
  )
]

#exercise("6.11")[为什么 Q-learning 被视为一种 off-policy 控制方法？]

#exercise("6.12")[假设动作选择是贪婪的。此时 Q-learning 与 Sarsa 是完全相同的算法吗？它们会作出完全相同的动作选择与权重更新吗？]
