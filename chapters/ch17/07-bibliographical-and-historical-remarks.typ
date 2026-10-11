#import "../../template.typ": *

#heading(level: 2, numbering: none)[文献与历史评注]

#block[
  #set par(first-line-indent: 0pt)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.7em,
    row-gutter: 0.9em,
    align: (left + top, left + top),

    [*17.1*],
    [
      一般值函数最先由 Sutton 及其同事明确提出（Sutton，1995a；Sutton 等，2011；Modayil、White 与 Sutton，2013）。Ring（待发表）用一个关于 GVF（「预报」）的详尽思想实验进行了发展，这个思想实验尽管还没有发表，却很有影响力。

      强化学习中多头学习的最早展示由 Jaderberg 等（2017）给出。Bellemare、Dabney 与 Munos（2017）表明，对奖励的分布预测更多的东西可以显著加快对它的期望的最优化，这是辅助任务的一个实例。此后许多人都接过了这条研究路线。

      据我们所知，心理学文献中还没有清楚地阐明这样一种一般理论：把#ezh[经典条件作用]看作学到的预测再加上对这些预测的内置反射性反应。Modayil 与 Sutton（2014）把它描述为一种用于机器人及其他 agent 工程的途径，称之为「巴甫洛夫式控制」（Pavlovian control），以暗示它在经典条件作用中的根源。
    ],

    [*17.2*],
    [
      把时间抽象的动作方案形式化为 option，是 Sutton、Precup 与 Singh（1999）引入的，它建立在 Parr（1998）与 Sutton（1995a）先前工作的基础上，也建立在关于半 MDP（Semi-MDP）的经典工作之上（例如见 Puterman，1994）。Precup（2000）的博士论文充分发展了 option 的各种想法。这些早期工作的一个重要局限在于，它们没有处理带函数近似的 off-policy 情形。option 内部学习一般需要 off-policy 学习，而当时用函数近似无法可靠地做到这一点。尽管现在我们有了多种使用函数近似的稳定 off-policy 学习方法，但在本书出版之时，把它们与 option 的想法结合起来还没有得到多少探索。Barto 与 Mahadevan（2003）以及 Hengst（2012）综述了 option 形式体系以及其他时间抽象途径。

      用 GVF 实现 option 模型此前未见描述。我们的介绍使用了 Modayil、White 与 Sutton（2014）引入的技巧，用来预测策略终止时的信号。

      用函数近似学习 option 模型的工作很少，其中有 Sorg 与 Singh（2010）以及 Bacon、Harb 与 Precup（2017）。

      文献中还没有发展出把 option 与 option 模型推广到平均奖励情形的工作。
    ],

    [*17.3*],
    [
      Monahan（1982）对 POMDP 途径作了很好的介绍。PSR 与测试由 Littman、Sutton 与 Singh（2002）引入。OOM 由 Jaeger（1997，1998，2000）引入。#ezh[序列系统]统一了 PSR、OOM 以及许多其他工作，它由 Michael Thon 的博士论文（2017；Thon 与 Jaeger，2015）引入。向时间关系网络的扩展由 Tanner（2006；Sutton 与 Tanner，2005）发展，随后又被扩展到 option（Sutton、Rafols 与 Koop，2006）。

      带非马尔可夫状态表示的强化学习理论由 Singh、Jaakkola 与 Jordan（1994；Jaakkola、Singh 与 Jordan，1995）明确地发展起来。处理部分可观测的早期强化学习途径由 Chrisman（1992）、McCallum（1993，1995）、Parr 与 Russell（1995）、Littman、Cassandra 与 Kaelbling（1995）以及 Lin 与 Mitchell（1992）发展。
    ],

    [*17.4*],
    [
      在强化学习中纳入建议与教学的最早努力包括 Lin（1992）、Maclin 与 Shavlik（1994）、Clouse（1996）以及 Clouse 与 Utgoff（1992）的工作。

      Skinner 的塑造不应与 Ng、Harada 与 Russell（1999）提出的「基于势能的塑造」（potential-based shaping）技术相混淆。Wiewiora（2003）表明，他们的技术与一个更简单的想法等价：为值函数提供一个初始近似，如 @eq-17-11 那样。
    ],

    [*17.5*],
    [
      关于当今深度学习技术的讨论，我们推荐 Goodfellow、Bengio 与 Courville（2016）的书。ANN 中的灾难性干扰问题由 McCloskey 与 Cohen（1989）、Ratcliff（1990）以及 French（1999）发展。重放缓冲区的想法由 Lin（1992）引入，并在 Atari 游戏系统（第 16.5 节；Mnih 等，2013，2015）中显著地用于深度学习。

      Minsky（1961）是最早指出表示学习问题的人之一。

      考虑用学到的近似模型来做规划的工作很少，其中有 Kuvayev 与 Sutton（1996）、Sutton、Szepesvari、Geramifard 与 Bowling（2008）、Nouri 与 Littman（2009）以及 Hester 与 Stone（2012）。

      在人工智能中，模型构造需要有选择性、以免拖慢规划，这一点是众所周知的。一些经典工作是 Minton（1990）以及 Tambe、Newell 与 Rosenbloom（1990）做的。Hauskrecht、Meuleau、Kaelbling、Dean 与 Boutilier（1998）在带确定性 option 的 MDP 中展示了这种效应。

      Schmidhuber（1991a, b）提出，如果奖励信号是 agent 的环境模型改进速度的函数，就会产生某种像好奇心那样的东西。Klyubin、Polani 与 Nehaniv（2005）提出的 empowerment 函数是 agent 控制其环境能力的一种信息论度量，可以作为内在奖励信号发挥作用。Baldassarre 与 Mirolli（2013）是一部文集，收录了从生物学与计算两种视角研究内在奖励与动机的研究者的文章，其中包括对「内在动机强化学习」这一视角的讨论——这个术语是 Singh、Barto 与 Chentenez（2004）引入的。另见 Oudeyer 与 Kaplan（2007）、Oudeyer、Kaplan 与 Hafner（2007）以及 Barto（2013）。
    ],
  )
]
