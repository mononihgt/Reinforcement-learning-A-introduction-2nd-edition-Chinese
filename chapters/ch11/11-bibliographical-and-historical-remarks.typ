#import "../../template.typ": *

#heading(level: 2, numbering: none)[文献与历史评注]

#block[
  #set par(first-line-indent: 0pt)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.7em,
    row-gutter: 0.9em,
    align: (left + top, left + top),

    [*11.1*],
    [
      第一个半梯度方法是线性 TD(λ)（Sutton，1988）。「半梯度」这个名称出现得更晚（Sutton，2015a）。带一般重要性采样率的半梯度 off-policy TD(0) 也许直到 Sutton、Mahmood 与 White（2016）才被明确写出，但它的动作值形式由 Precup、Sutton 与 Singh（2000）引入，他们还给出了这些算法的资格迹形式（见第 12 章）。它们的持续性、不带折扣的形式尚未得到充分探索。这里给出的 $n$ 步形式是新的。
    ],

    [*11.2*],
    [
      最早的 $w$ 到 $2w$ 的例子由 Tsitsiklis 与 Van Roy（1996）给出，他们还引入了原书第 263 页的方框中的那个具体反例。Baird 反例出自 Baird（1995），不过我们这里给出的版本做了少许修改。用于函数近似的平均器方法由 Gordon（1995，1996b）发展。带 off-policy DP 方法与更复杂的函数近似方法的不稳定性的其他例子由 Boyan 与 Moore（1995）给出。Bradtke（1993）给出一个例子：在一个线性二次调节问题中，使用线性函数近似的 Q-learning 收敛到一个使系统失稳的策略。
    ],

    [*11.3*],
    [
      致命三元组最早由 Sutton（1995b）指出，并由 Tsitsiklis 与 Van Roy（1997）做了透彻的分析。「致命三元组」这个名称出自 Sutton（2015a）。
    ],

    [*11.4*],
    [
      这类线性分析由 Tsitsiklis 与 Van Roy（1996；1997）开创，其中包括动态规划算子。像 @fig-11-3 这样的图解由 Lagoudakis 与 Parr（2003）引入。

      我们称为贝尔曼算子、记作 $B_pi$ 的东西，更常见的记法是 $T^pi$，称为「动态规划算子」；而它的一个推广形式记作 $T^((lambda))$，称为「TD(λ) 算子」（Tsitsiklis 与 Van Roy，1996，1997）。
    ],

    [*11.5*],
    [
      BE 最早由 Schweitzer 与 Seidmann（1985）提出，作为动态规划的一个目标函数。Baird（1995，1999）把它推广到基于随机梯度下降的 TD 学习。在文献中，BE 最小化常被称为贝尔曼残差最小化。

      最早的 A-split 例子出自 Dayan（1992）。这里给出的两种形式由 Sutton 等（2009a）引入。
    ],

    [*11.6*],
    [
      本节的内容是本书新增的。
    ],

    [*11.7*],
    [
      gradient-TD 方法由 Sutton、Szepesvári 与 Maei（2009b）引入。本节重点介绍的方法由 Sutton 等（2009a）与 Mahmood 等（2014）引入。向近端 TD 方法的一个重要扩展由 Mahadevan 等（2014）发展。迄今对 gradient-TD 及相关方法最细致的实证研究由 Geist 与 Scherrer（2014）、Dann、Neumann 与 Peters（2014）、White（2015）以及 Ghiassian、Patterson、White、Sutton 与 White（2018）给出。gradient-TD 方法理论的最新进展由 Yu（2017）介绍。
    ],

    [*11.8*],
    [
      emphatic-TD 方法由 Sutton、Mahmood 与 White（2016）引入。完整的收敛性证明与其他理论后来由 Yu（2015；2016；Yu、Mahmood 与 Sutton，2017）、Hallak、Tamar 与 Mannor（2015）以及 Hallak、Tamar、Munos 与 Mannor（2016）建立。
    ],
  )
]
