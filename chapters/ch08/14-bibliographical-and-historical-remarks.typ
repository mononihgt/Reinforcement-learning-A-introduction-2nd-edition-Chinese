#import "../../template.typ": *

#heading(level: 2, numbering: none)[文献与历史评注]

#block[
  #set par(first-line-indent: 0pt)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.7em,
    row-gutter: 0.9em,
    align: (left + top, left + top),

    [*8.1*],
    [
      这里给出的关于规划与学习的总体观点是多年来逐渐发展起来的，其中一部分工作出自本书作者（Sutton，1990，1991a，1991b；Barto、Bradtke 与 Singh，1991，1995；Sutton 与 Pinette，1985；Sutton 与 Barto，1981b）；它深受 Agre 与 Chapman（1990；Agre，1988）、Bertsekas 与 Tsitsiklis（1989）、Singh（1993）等人的影响。本书作者还深受关于潜在学习的心理学研究（Tolman，1932）以及关于思维本质的心理学观点（例如 Galanter 与 Gerstenhaber，1956；Craik，1943；Campbell，1960；Dennett，1978）的影响。在本书第三部分，第 14.6 节把 model-based 与 model-free 方法同学习与行为的心理学理论联系起来，第 15.11 节讨论关于大脑如何实现这些类型方法的想法。
    ],

    [*8.2*],
    [
      我们用来描述不同类型强化学习的术语#ezh[直接]与#ezh[间接]，来自自适应控制文献（例如 Goodwin 与 Sin，1984），在那里它们被用来作同样的区分。术语#ezh[系统辨识]在自适应控制中指的是我们所说的#ezh[模型学习]（例如 Goodwin 与 Sin，1984；Ljung 与 Söderstrom，1983；Young，1984）。Dyna 架构出自 Sutton（1990），本节与下一节的结果基于那里报告的结果。Barto 与 Singh（1990）考虑了比较直接与间接强化学习方法时的一些问题。把 Dyna 扩展到线性函数近似的早期工作由 Sutton、Szepesvári、Geramifard 与 Bowling（2008）以及 Parr、Li、Taylor、Painter-Wakefield 与 Littman（2008）完成。
    ],

    [*8.3*],
    [
      基于模型的强化学习中有若干工作把探索奖励与乐观初始化的想法推到了逻辑上的极端：假定所有未完全探索过的选择都能带来最大奖励，并计算出最优路径来检验它们。Kearns 与 Singh（2002）的 $E^3$ 算法与 Brafman 与 Tennenholtz（2003）的 R-max 算法保证在状态与动作数目的多项式时间内找到接近最优的解。对实际算法来说这通常太慢，但在最坏情况下这大概已经是所能做到的最好结果。
    ],

    [*8.4*],
    [
      优先级扫描由 Moore 与 Atkeson（1993）以及 Peng 与 Williams（1993）同时且相互独立地提出。原书第 170 页方框中的结果出自 Peng 与 Williams（1993）。原书第 171 页方框中的结果出自 Moore 与 Atkeson。这一领域后续的重要工作包括 McMahan 与 Gordon（2005）以及 van Seijen 与 Sutton（2013）的工作。
    ],

    [*8.5*],
    [
      本节深受 Singh（1993）实验的影响。
    ],

    [*8.6–7*],
    [
      轨迹采样从一开始就隐含地是强化学习的一部分，但 Barto、Bradtke 与 Singh（1995）在提出 RTDP 时对它作了最明确的强调。他们认识到，Korf（1990）的#ezh[学习实时 $A^*$]（$"LRTA"^*$）算法是一个异步 DP 算法，既适用于随机问题，也适用于 Korf 重点研究的确定性问题。在 $"LRTA"^*$ 之外，RTDP 还包含这样的做法：在动作执行之间的时间间隔里更新许多状态的值。Barto 等人（1995）把 Korf（1990）关于 $"LRTA"^*$ 的收敛性证明与 Bertsekas（1982）（以及 Bertsekas 与 Tsitsiklis，1989）的结果结合起来，证明了这里描述的收敛结果，后面的结果保证了在不做折扣的情形下随机最短路径问题的异步 DP 的收敛性。把模型学习与 RTDP 结合起来称为#emph[Adaptive RTDP]，这也是由 Barto 等人（1995）提出的，并由 Barto（2011）讨论过。
    ],

    [*8.9*],
    [
      要想进一步阅读启发式搜索方面的内容，建议读者参考 Russell 与 Norvig（2009）以及 Korf（1988）等教材与综述。Peng 与 Williams（1993）探索了一种更新的向前聚焦，与本节所建议的方式非常相似。
    ],

    [*8.10*],
    [
      Abramson（1990）的期望结果模型是把 rollout 算法应用于双人博弈，其中双方模拟棋手的走法都是随机的。他论证说，即使走法是随机的，它也是一种「强大的启发式方法」，它「精确、准确、容易估计、计算高效且与领域无关」。Tesauro 与 Galperin（1997）展示了 rollout 算法在提高双陆棋程序棋力方面的有效性，并采用了「rollout」这一术语，该术语来自用不同随机生成的掷骰子序列把局面走完以评估双陆棋局面的用法。Bertsekas、Tsitsiklis 与 Wu（1997）考察了应用于组合优化问题的 rollout 算法，Bertsekas（2013）综述了它们在离散确定性优化问题中的使用，并指出它们「往往出人意料地有效」。
    ],

    [*8.11*],
    [
      MCTS 的核心思想由 Coulom（2006）以及 Kocsis 与 Szepesvári（2006）提出。他们建立在以前关于蒙特卡洛规划算法的研究之上，这些作者对相关研究作了综述。Browne、Powley、Whitehouse、Lucas、Cowling、Rohlfshagen、Tavener、Perez、Samothrakis 与 Colton（2012）是一篇关于 MCTS 方法及其应用的出色综述。David Silver 对本节的思想与表述有所贡献。
    ],
  )
]
