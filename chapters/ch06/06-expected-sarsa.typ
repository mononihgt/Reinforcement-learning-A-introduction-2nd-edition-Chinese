#import "../../template.typ": *

== Expected Sarsa <sec-6-6>

考虑这样一个学习算法：它与 Q-learning 完全相同，唯一的区别是它取下一状态–动作对上的期望值（而不是最大值），把当前策略下每个动作的可能性都考虑在内。也就是说，考虑更新规则为

$ Q(S_t, A_t) &arrow.l Q(S_t, A_t) + alpha [R_(t+1) + gamma bb(E)_pi [Q(S_(t+1), A_(t+1)) | S_(t+1)] - Q(S_t, A_t)] \
              &= Q(S_t, A_t) + alpha [R_(t+1) + gamma sum_a pi (a|S_(t+1)) Q(S_(t+1), a) - Q(S_t, A_t)], $ <eq-6-9>

但在其他方面遵循 Q-learning 的模式。给定下一状态 $S_(t+1)$，Sarsa 会在期望意义下朝某个方向移动，而这个算法朝同一方向#ezh[确定性地]移动；因此它称为#ezh[Expected Sarsa]。它的回溯图见 @fig-6-4 的右图。

Expected Sarsa 在计算上比 Sarsa 更复杂，但作为回报，它消除了由于 $A_(t+1)$ 随机选择而产生的方差。给定同样多的经验，我们或许可以期望它比 Sarsa 表现稍好，而它通常确实如此。@fig-6-3 展示了悬崖行走任务上的汇总结果，把 Expected Sarsa 与 Sarsa、Q-learning 作了比较。在这个问题上，Expected Sarsa 保留了 Sarsa 相对 Q-learning 的显著优势。此外，Expected Sarsa 在很宽的步长参数 $alpha$ 取值范围内都显著优于 Sarsa。

#figure(
  image("../../assets/figures/ch06/fig-6-3.png", width: 83%),
  caption: [TD 控制方法在悬崖行走任务上的中期表现与渐近表现，作为 $alpha$ 的函数。所有算法都使用 $epsilon = 0.1$ 的 $epsilon$-greedy 策略。渐近表现是 100,000 个回合上的平均值，中期表现是前 100 个回合上的平均值。这些数据在中期与渐近情形下分别是对 50,000 次以上与 10 次运行取的平均。实心圆标出每种方法最好的中期表现。改编自 van Seijen 等（2009）。],
)<fig-6-3>

#figure(
  image("../../assets/figures/ch06/fig-6-4.png", width: 51%),
  caption: [Q-learning 与 Expected Sarsa 的回溯图。],
)<fig-6-4>

在悬崖行走中，状态转移都是确定性的，所有随机性都来自策略。在这种情形下，Expected Sarsa 可以放心地令 $alpha = 1$，渐近表现不会出现任何退化；而 Sarsa 只有在 $alpha$ 取值很小时才能在长期表现良好，此时短期表现很差。在这个例子以及其他例子中，Expected Sarsa 相对 Sarsa 有一致的经验优势。

在这些悬崖行走结果中，Expected Sarsa 是按 on-policy 方式使用的；但一般来说，它可能使用一个与目标策略 $pi$ 不同的策略来产生行为，这时它就变成一种 off-policy 算法。例如，假设 $pi$ 是贪婪策略，而行为更具探索性；那么 Expected Sarsa 恰好就是 Q-learning。在这个意义上，Expected Sarsa 包含并推广了 Q-learning，同时可靠地优于 Sarsa。除了增加一点计算开销之外，Expected Sarsa 可能完全胜过另外两个更有名的 TD 控制算法。
