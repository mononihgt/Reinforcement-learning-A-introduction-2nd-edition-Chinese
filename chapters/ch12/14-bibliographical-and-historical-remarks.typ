#import "../../template.typ": *

#heading(level: 2, numbering: none)[文献与历史评注]

资格迹通过 Klopf（1972）富有创造力的思想进入强化学习。我们对资格迹的使用基于 Klopf 的工作（Sutton，1978a, b, c；Barto 与 Sutton，1981a, b；Sutton 与 Barto，1981a；Barto、Sutton 与 Anderson，1983；Sutton，1984）。我们也许是最先用「资格迹」这一术语的人（Sutton 与 Barto，1981a）。刺激会在神经系统中产生对学习很重要的后效，这个想法非常古老（见第 14 章）。资格迹最早的若干应用出现在第 13 章讨论的 actor–critic 方法中（Barto、Sutton 与 Anderson，1983；Sutton，1984）。

#block[
  #set par(first-line-indent: 0pt)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.7em,
    row-gutter: 0.9em,
    align: (left + top, left + top),

    [*12.1*],
    [
      复合更新在本书第一版中称为「复杂回溯」（complex backups）。

      $lambda$ 回报及其误差缩减性质由 Watkins（1989）引入，并由 Jaakkola、Jordan 与 Singh（1994）进一步发展。本节以及随后几节的随机游走结果都是本书新增的，「前向视图」与「后向视图」这两个术语也是如此。$lambda$ 回报算法的概念是在本书第一版中引入的。这里给出的更精细的处理是与 Harm van Seijen 共同发展出来的（例如 van Seijen 与 Sutton，2014）。
    ],

    [*12.2*],
    [
      带累积迹的 TD($lambda$) 由 Sutton（1988，1984）提出。按均值收敛由 Dayan（1992）证明，以概率 1 收敛由许多研究者证明，包括 Peng（1993）、Dayan 与 Sejnowski（1994）、Tsitsiklis（1994）以及 Gurvits、Lin 与 Hanson（1994）。线性 TD($lambda$) 渐近的、依赖于 $lambda$ 的解的误差界由 Tsitsiklis 与 Van Roy（1997）给出。
    ],

    [*12.3*],
    [
      截断 TD 方法由 Cichosz（1995）与 van Seijen（2016）发展。
    ],

    [*12.4*],
    [
      重做更新的想法由 van Seijen 广泛发展，最初使用的名称是「最佳匹配学习」（best-match learning）（van Seijen，2011；van Seijen、Whiteson、van Hasselt 与 Weiring，2011）。
    ],

    [*12.5*],
    [
      true online TD($lambda$) 主要归功于 Harm van Seijen（van Seijen 与 Sutton，2014；van Seijen 等，2016），尽管它的某些关键想法由 Hado van Hasselt 独立发现（私人交流）。「荷兰迹」这个名字是为了表彰这两位科学家的贡献。替换迹由 Singh 与 Sutton（1996）提出。
    ],

    [*12.6*],
    [
      本节的材料来自 van Hasselt 与 Sutton（2015）。
    ],

    [*12.7*],
    [
      带累积迹的 Sarsa($lambda$) 作为一种控制方法，最早由 Rummery 与 Niranjan（1994；Rummery，1995）探索。true online Sarsa($lambda$) 由 van Seijen 与 Sutton（2014）提出。原书第 307 页的算法改编自 van Seijen 等（2016）。Mountain Car 的结果是为本书制作的，只有 @fig-12-11 例外，它改编自 van Seijen 与 Sutton（2014）。
    ],

    [*12.8*],
    [
      关于可变 $lambda$ 最早公开发表的讨论也许出自 Watkins（1989），他指出：在他的 Q($lambda$) 中，当选中非贪婪动作时更新序列的截断（@fig-12-12）可以通过暂时把 $lambda$ 置为零来实现。

      可变 $lambda$ 是在本书第一版中引入的。可变 $gamma$ 的根源在于 option 方面的工作（Sutton、Precup 与 Singh，1999）及其前身（Sutton，1995a），并在 GQ($lambda$) 论文（Maei 与 Sutton，2010）中变得明确，该论文也引入了 $lambda$ 回报的一些递归形式。

      另一种不同的可变 $lambda$ 概念由 Yu（2012）发展。
    ],

    [*12.9*],
    [
      off-policy 资格迹由 Precup 等（2000，2001）提出，之后由 Bertsekas 与 Yu（2009）、Maei（2011；Maei 与 Sutton，2010）、Yu（2012）以及 Sutton、Mahmood、Precup 与 van Hasselt（2014）进一步发展。最后那篇文献尤其给出了带一般依赖状态的 $lambda$ 与 $gamma$ 的 off-policy TD 方法的一个强有力的前向视图。这里的表述似乎是新的。

      本节最后给出一个优雅的 Expected Sarsa($lambda$) 算法。虽然它是一个自然的算法，但据我们所知，之前文献中从未描述或者测试过它。
    ],

    [*12.10*],
    [
      Watkins 的 Q($lambda$) 归功于 Watkins（1989）。表格型、回合式、离线的版本已由 Munos、Stepleton、Harutyunyan 与 Bellemare（2016）证明收敛。其他 Q($lambda$) 算法由 Peng 与 Williams（1994，1996）以及 Sutton、Mahmood、Precup 与 van Hasselt（2014）提出。Tree Backup($lambda$) 归功于 Precup、Sutton 与 Singh（2000）。
    ],

    [*12.11*],
    [
      GTD($lambda$) 归功于 Maei（2011）。GQ($lambda$) 归功于 Maei 与 Sutton（2010）。HTD($lambda$) 归功于 White 与 White（2016），它基于 Hackman（2012）提出的单步 HTD 算法。gradient-TD 方法理论的最新进展由 Yu（2017）给出。Emphatic TD($lambda$) 由 Sutton、Mahmood 与 White（2016）提出，他们证明了它的稳定性。Yu（2015，2016）证明了它的收敛性，该算法由 Hallak 等（2015，2016）进一步发展。
    ],
  )
]
