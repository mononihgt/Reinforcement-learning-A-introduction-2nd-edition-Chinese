#import "../../template.typ": *

#heading(level: 2, numbering: none)[文献与历史评注]

我们今天看作与策略梯度相关的方法，实际上是强化学习中最早被研究的方法之一（Witten，1977；Barto、Sutton 与 Anderson，1983；Sutton，1984；Williams，1987，1992），在前身领域中也是如此（见 Phansalkar 与 Thathachar，1995）。20 世纪 90 年代，它们在很大程度上被本书其他各章关注的动作值方法取代。然而近年来，人们的注意力又回到了 actor–critic 方法以及一般的策略梯度方法上。除我们这里介绍的内容之外的进一步发展包括自然梯度方法（Amari，1998；Kakade，2002；Peters、Vijayakumar 与 Schaal，2005；Peters 与 Schaal，2008；Park、Kim 与 Kang，2005；Bhatnagar、Sutton、Ghavamzadeh 与 Lee，2009；见 Grondman、Busoniu、Lopes 与 Babuska，2012）、确定性策略梯度方法（Silver et al.，2014）、off-policy 策略梯度方法（Degris、White 与 Sutton，2012；Maei，2018）以及熵正则化（见 Schulman、Chen 与 Abbeel，2017）。重要应用包括特技直升机自动驾驶仪与 AlphaGo（第 16.6 节）。

本章的讲述主要基于 Sutton、McAllester、Singh 与 Mansour（2000）的工作，「策略梯度方法」这个术语就是他们提出的。Bhatnagar et al.（2009）提供了一份有用的综述。最早的相关工作之一是 Aleksandrov、Sysoyev 与 Shemeneva（1968）。Thomas（2014）最先意识到，在本章各算法方框中给出的因子 $gamma^t$ 在有折扣的回合问题中是必需的。

#block[
  #set par(first-line-indent: 0pt)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.7em,
    row-gutter: 0.9em,
    align: (left + top, left + top),

    [*13.1*],
    [
      例 13.1 以及本章中与它有关的结果是与 Eric Graves 共同得到的。
    ],

    [*13.2*],
    [
      这里介绍的策略梯度定理以及原书第 334 页上的那个，最先由 Marbach 与 Tsitsiklis（1998，2001）得到，随后由 Sutton et al.（2000）独立得到。Cao 与 Chen（1997）得到了类似的表达式。其他早期结果来自 Konda 与 Tsitsiklis（2000，2003）、Baxter 与 Bartlett（2001）以及 Baxter、Bartlett 与 Weaver（2001）。Sutton、Singh 与 McAllester（2000）给出了另外一些结果。
    ],

    [*13.3*],
    [
      REINFORCE 来自 Williams（1987，1992）。Phansalkar 与 Thathachar（1995）为 REINFORCE 算法的若干修改版本证明了局部与全局收敛定理。

      全动作算法最先出现在一篇未发表但广为流传的不完整论文中（Sutton、Singh 与 McAllester，2000），随后由 Ciosek 与 Whiteson（2017，2018）进一步发展，他们称之为「expected policy gradients」；Asadi、Allen、Roderick、Mohamed、Konidaris 与 Littman（2017）也作了发展，称之为「mean actor critic」。
    ],

    [*13.4*],
    [
      基线由 Williams（1987，1992）的原始工作引入。Greensmith、Bartlett 与 Baxter（2004）分析了一个可以说更好的基线（见 Dick，2015）。Thomas 与 Brunskill（2017）主张，使用依赖动作的基线可以不招致偏差。
    ],

    [*13.5–6*],
    [
      actor–critic 方法是最早在强化学习中被研究的方法之一（Witten，1977；Barto、Sutton 与 Anderson，1983；Sutton，1984）。这里给出的算法基于 Degris、White 与 Sutton（2012）的工作。在文献中，actor–critic 方法有时被称为优势 actor–critic（「A2C」）方法。
    ],

    [*13.7*],
    [
      最先展示可以用这种方式处理连续动作的看来是 Williams（1987，1992）。原书第 335 页的图改编自 Wikipedia。
    ],
  )
]
