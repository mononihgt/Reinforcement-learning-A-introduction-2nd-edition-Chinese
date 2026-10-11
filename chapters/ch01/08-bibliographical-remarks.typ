#import "../../template.typ": *

#heading(level: 2, numbering: none)[文献评注]

关于强化学习更一般的综述，我们向读者推荐 Szepesvári（2010）、Bertsekas 与 Tsitsiklis（1996）、Kaelbling（1993a）以及 Sugiyama、Hachiya 与 Morimura（2013）的著作。从控制或运筹学视角出发的著作包括 Si、Barto、Powell 与 Wunsch（2004）、Powell（2011）、Lewis 与 Liu（2012）以及 Bertsekas（2012）。Cao（2009）的综述把强化学习放在随机动态系统的其他学习与最优化方法的背景中加以考察。《Machine Learning》期刊有三期关于强化学习的专辑：Sutton（1992a）、Kaelbling（1996）和 Singh（2002）。有用的综述可见于 Barto（1995b）；Kaelbling、Littman 与 Moore（1996）；以及 Keerthi 与 Ravindran（1997）。Wiering 与 van Otterlo（2012）主编的文集对近期发展做了出色的概述。

#block[
  #set par(first-line-indent: 0pt)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.7em,
    row-gutter: 0.9em,
    align: (left + top, left + top),

    [*1.2*],
    [
      本章中 Phil 的早餐一例受到 Agre（1988）的启发。
    ],

    [*1.5*],
    [
      井字棋例子中使用的时序差分方法在第 6 章中展开。
    ],
  )
]
