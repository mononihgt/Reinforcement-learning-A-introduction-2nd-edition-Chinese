#import "../../template.typ": *

== 最大化偏差与 Double learning <sec-6-7>

到目前为止讨论的所有控制算法，在构造目标策略时都涉及最大化。例如，在 Q-learning 中，目标策略是给定当前动作值时得到的贪婪策略，它的定义用到了 max；而在 Sarsa 中，策略常常是 $epsilon$-greedy 的，这也涉及一个最大化操作。在这些算法中，对估计值取的最大值被隐含地用作对最大值本身的一个估计，这可能造成显著的正偏差。要看清其中的原因，考虑某个单一状态 $s$，其中有很多动作 $a$，它们的真实值 $q(s, a)$ 全都为零，但它们的估计值 $Q(s, a)$ 不确定，因而有些分布在零以上、有些分布在零以下。真实值的最大值是零，但估计值的最大值是正的，这就是一个正偏差。我们把这种情况称为#ezh[最大化偏差]（maximization bias）。

#example("最大化偏差示例")[
  @fig-6-5 的内嵌图所示的小型 MDP，提供了一个简单的例子，说明最大化偏差如何损害 TD 控制算法的表现。这个 MDP 有两个非终止状态 A 与 B。回合总是从 A 开始，在两种动作 #emph[left] 与 #emph[right] 之间作出选择。#emph[right] 动作立即转移到终止状态，奖励与回报都是零。#emph[left] 动作转移到 B，奖励也是零；从 B 出发有很多可能的动作，它们全都导致立即终止，奖励服从均值为 $-0.1$、方差为 $1.0$ 的正态分布。因此，任何以 #emph[left] 开始的轨迹的期望回报都是 $-0.1$，于是在状态 A 中采取 #emph[left] 永远是一个错误。尽管如此，我们的控制方法可能偏好 #emph[left]，因为最大化偏差使 B 看起来具有正的值。@fig-6-5 显示，在 $epsilon$-greedy 动作选择下，Q-learning 在这个例题中一开始学会强烈偏好 #emph[left] 动作。即使到了渐近阶段，在我们设置的参数（$epsilon = 0.1$、$alpha = 0.1$ 与 $gamma = 1$）下，Q-learning 采取 #emph[left] 动作的次数也比最优情形多出约 5%。

  #figure(
    image("../../assets/figures/ch06/fig-6-5.png", width: 74%),
    caption: [在一个简单的回合制 MDP（见内嵌图）上 Q-learning 与 Double Q-learning 的比较。Q-learning 一开始学会采取 #emph[left] 动作的次数远多于 #emph[right] 动作，并且始终显著多于 $epsilon = 0.1$ 的 $epsilon$-greedy 动作选择所强制的 5% 最小概率。相比之下，Double Q-learning 基本上不受最大化偏差影响。这些数据是对 10,000 次运行取的平均。初始动作值估计为零。$epsilon$-greedy 动作选择中出现并列时随机打破。],
  )<fig-6-5>
]

有没有算法可以避免最大化偏差？先考虑一个赌博机（bandit）情形，其中我们有很多动作，每个动作的值都有一个带噪声的估计，这些估计是对该动作的每一局中得到的奖励取样本平均值获得的。正如上面讨论的，如果我们用估计值的最大值作为真实值最大值的估计，就会出现正的最大化偏差。看待这个问题的一种方式是：它源于用同一批样本（每一局）既确定取得最大值的动作，又估计这个动作的值。假设我们把各局分成两组，用它们学习两个相互独立的估计，称为 $Q_1 (a)$ 与 $Q_2 (a)$，对全部的 $a in cal(A)$，每个都是对真实值 $q(a)$ 的估计。然后我们可以用一个估计，比如 $Q_1$，来确定取得最大值的动作 $A^* = op("argmax", limits: #true)_a Q_1 (a)$，用另一个估计 $Q_2$ 给出它的值的估计 $Q_2 (A^*) = Q_2 (op("argmax", limits: #true)_a Q_1 (a))$。这个估计在 $bb(E)[Q_2 (A^*)] = q(A^*)$ 的意义下是无偏的。我们还可以把这两个估计的角色对调，重复同样的过程，得到第二个无偏估计 $Q_1 (op("argmax", limits: #true)_a Q_2 (a))$。这就是#ezh[Double learning] 的思想。注意，虽然我们学习两个估计，但每一局只更新其中一个估计；Double learning 使内存需求翻倍，但每一步的计算量并不增加。

Double learning 的思想自然地推广到完整 MDP 的算法。例如，与 Q-learning 对应的 Double learning 算法称为 Double Q-learning，它把时间步分成两部分，做法或许是在每一步抛一枚硬币。如果硬币正面朝上，更新为

$ Q_1 (S_t, A_t) arrow.l Q_1 (S_t, A_t) + alpha [R_(t+1) + gamma Q_2 (S_(t+1), op("argmax", limits: #true)_a Q_1 (S_(t+1), a)) - Q_1 (S_t, A_t)]. $ <eq-6-10>

如果硬币背面朝上，就把 $Q_1$ 与 $Q_2$ 对调做同样的更新，也就是更新 $Q_2$。这两个近似值函数被完全对称地对待。行为策略可以使用两个动作值估计。例如，Double Q-learning 的 $epsilon$-greedy 策略可以基于两个动作值估计的平均值（或者和）。下面方框给出了 Double Q-learning 的完整算法。产生 @fig-6-5 中结果的正是这个算法。在那个例题中，Double learning 似乎消除了最大化偏差造成的损害。当然，Sarsa 与 Expected Sarsa 也有对应的双重版本。

#algbox([Double Q-learning，用于估计 $Q_1 approx Q_2 approx q_*$])[
  算法参数：步长 $alpha in (0, 1]$，很小的 $epsilon > 0$ \
  初始化 $Q_1 (s, a)$ 与 $Q_2 (s, a)$，对全部的 $s in cal(S)^+$、$a in cal(A)(s)$，任意取值，但 $Q("terminal", dot.op) = 0$

  对每个回合循环：\
  #h(1.5em) 初始化 $S$ \
  #h(1.5em) 对回合的每一步循环：\
  #h(3em) 用关于 $Q_1 + Q_2$ 的 $epsilon$-greedy 策略从 $S$ 选择 $A$ \
  #h(3em) 采取动作 $A$，观测到 $R$、$S'$ \
  #h(3em) 以 0.5 的概率：\
  #h(4.5em) $Q_1 (S, A) arrow.l Q_1 (S, A) + alpha (R + gamma Q_2 (S', op("argmax", limits: #true)_a Q_1 (S', a)) - Q_1 (S, A))$ \
  #h(3em) 否则：\
  #h(4.5em) $Q_2 (S, A) arrow.l Q_2 (S, A) + alpha (R + gamma Q_1 (S', op("argmax", limits: #true)_a Q_2 (S', a)) - Q_2 (S, A))$ \
  #h(3em) $S arrow.l S'$ \
  #h(1.5em) 直到 $S$ 是终止状态
]

#exercise("6.13", star: true)[目标策略为 $epsilon$-greedy 的 Double Expected Sarsa 的更新公式是什么？]
