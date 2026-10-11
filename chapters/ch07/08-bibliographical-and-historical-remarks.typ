#import "../../template.typ": *

#heading(level: 2, numbering: none)[文献与历史评注]

$n$ 步回报的概念归功于 Watkins（1989），他最早讨论了它的误差缩减性质。$n$ 步算法在本书第一版中得到了探讨，当时它们被视为有概念上的意义，但在实践中不可行。Cichosz（1995）以及尤其是 van Seijen（2016）的工作表明，它们实际上是完全可以实用的算法。鉴于这一点，再加上它们概念上的清晰与简单，我们在第二版中选择在这里突出它们。特别是，我们现在把关于后向视角与资格迹的全部讨论推迟到第 12 章。

#block[
  #set par(first-line-indent: 0pt)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.7em,
    row-gutter: 0.9em,
    align: (left + top, left + top),

    [*7.1–2*],
    [
      随机游走例子中的结果是基于 Sutton（1988）以及 Singh 与 Sutton（1996）的工作，为本书制作的。用回溯图来描述本章这些算法及其他算法是新的做法。
    ],

    [*7.3–5*],
    [
      这几节的发展基于 Precup、Sutton 与 Singh（2000），Precup、Sutton 与 Dasgupta（2001），以及 Sutton、Mahmood、Precup 与 van Hasselt（2014）的工作。

      tree-backup 算法来自 Precup、Sutton 与 Singh（2000），但这里对它的介绍是新的。
    ],
  )
]

#block[
  #set par(first-line-indent: 0pt)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.7em,
    row-gutter: 0.9em,
    align: (left + top, left + top),

    [*7.6*],
    [
      Q($sigma$) 算法是本书新提出的，但 De Asis、Hernandez-Garcia、Holland 与 Sutton（2017）对与之密切相关的算法做了进一步探索。
    ],
  )
]
