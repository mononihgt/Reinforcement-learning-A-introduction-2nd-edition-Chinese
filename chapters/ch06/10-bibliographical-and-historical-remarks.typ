#import "../../template.typ": *

#heading(level: 2, numbering: none)[文献与历史评注]

正如第 1 章所概述的，TD 学习的思想早期植根于动物学习心理学与人工智能，其中最值得注意的是 Samuel（1959）与 Klopf（1972）的工作。Samuel 的工作在第 16.2 节作为一个案例研究来介绍。与 TD 学习有关的还有 Holland（1975，1976）关于值预测之间一致性的早期思想。这些思想影响了本书作者之一（Barto），1970 年至 1975 年他在密歇根大学读研究生，Holland 当时在那里任教。Holland 的思想引出了若干与 TD 有关的系统，包括 Booker（1982）的工作，以及 Holland（1986）的桶链算法；如下文所讨论的，桶链算法与 Sarsa 有关。

#block[
  #set par(first-line-indent: 0pt)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.7em,
    row-gutter: 0.9em,
    align: (left + top, left + top),

    [*6.1–2*],
    [
      这两节的大部分具体材料都出自 Sutton（1988），包括 TD(0) 算法、随机游走例题以及「时序差分学习」这一术语。对它与动态规划方法及蒙特卡洛方法之间关系的刻画，受到了 Watkins（1989）、Werbos（1987）等人的影响。回溯图的使用是本书第一版新增的内容。

      表格型 TD(0) 按均值收敛由 Sutton（1988）证明，以概率 1 收敛由 Dayan（1992）证明，后者依据的是 Watkins 与 Dayan（1992）的工作。Jaakkola、Jordan 与 Singh（1994）以及 Tsitsiklis（1994）把这些结果加以扩展和加强，做法是使用现有强大的随机近似理论的推广。其他扩展与推广在后面的章节中介绍。
    ],

    [*6.3*],
    [
      TD 算法在批式训练下的最优性由 Sutton（1988）确立。对这一结果很有启发的是 Barnard（1993）的推导：他把 TD 算法推导为两种方法的结合，即学习马尔可夫链模型的增量方法的一步，以及由该模型计算预测的方法的一步。确定性等价这一术语来自自适应控制文献（例如 Goodwin 与 Sin，1984）。
    ],

    [*6.4*],
    [
      Sarsa 算法由 Rummery 与 Niranjan（1994）提出。他们结合人工神经网络对它作了探索，称之为「改进的连接主义 Q-learning」。Sarsa 这个名称由 Sutton（1996）引入。单步表格型 Sarsa（本章所处理的形式）的收敛性已由 Singh、Jaakkola、Littman 与 Szepesvári（2000）证明。风之网格世界这个例题由 Tom Kalt 建议。

      Holland（1986）的桶链思想演变成一个与 Sarsa 密切相关的算法。桶链算法最初的想法是规则链彼此触发；它关注的是把信用从当前规则传回触发它的那些规则。随着时间推移，桶链算法在把信用传回任何时间上更早的规则、而不仅仅是触发当前规则的那些规则这一点上，变得更像 TD 学习。桶链算法的现代形式在按各种自然方式简化之后，与单步 Sarsa 几乎完全相同，Wilson（1994）对此作了详细说明。
    ],

    [*6.5*],
    [
      Q-learning 由 Watkins（1989）提出，他给出的收敛性证明提纲由 Watkins 与 Dayan（1992）变得严格。更一般的收敛结果由 Jaakkola、Jordan 与 Singh（1994）以及 Tsitsiklis（1994）证明。
    ],

    [*6.6*],
    [
      Expected Sarsa 算法由 George John（1994）提出，他称之为「Q-learning」，并强调了它作为 off-policy 算法相对于 Q-learning 的优势。我们在本书第一版中把 Expected Sarsa 作为一道练习介绍时，并不知道 John 的工作；van Seijen、van Hasselt、Whiteson 与 Weiring（2009）在确立 Expected Sarsa 的收敛性质以及它在什么条件下优于普通 Sarsa 与 Q-learning 时，也不知道这项工作。@fig-6-3 改编自他们的结果。van Seijen 等人把「Expected Sarsa」专门定义为一个 on-policy 方法（正如我们在第一版中所做的那样），而我们现在用这个名字指代目标策略与行为策略可以不同的更一般的算法。Expected Sarsa 的一般 off-policy 视角由 van Hasselt（2011）指出，他把这个算法称为「General Q-learning」。
    ],

    [*6.7*],
    [
      最大化偏差与 Double learning 由 van Hasselt（2010，2011）提出并作了广泛研究。@fig-6-5 中的例题 MDP 改编自他论文中的图 4.1（van Hasselt，2011）。
    ],

    [*6.8*],
    [
      后续状态的概念与「决策后状态」（post-decision state）的概念相同（Van Roy、Bertsekas、Lee 与 Tsitsiklis，1997；Powell，2011）。
    ],
  )
]
