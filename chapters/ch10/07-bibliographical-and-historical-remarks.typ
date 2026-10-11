#import "../../template.typ": *

#heading(level: 2, numbering: none)[文献与历史评注]

#block[
  #set par(first-line-indent: 0pt)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.7em,
    row-gutter: 0.9em,
    align: (left + top, left + top),

    [*10.1*],
    [
      带函数近似的半梯度 Sarsa 最早由 Rummery 与 Niranjan（1994）探索。带 ε-greedy 动作选择的线性半梯度 Sarsa 不会按通常意义收敛，但确实会进入最佳解附近的一个有界区域（Gordon，1996a，2001）。Precup 与 Perkins（2003）表明，在可微的动作选择设定中它会收敛。另见 Perkins 与 Pendrith（2002）以及 Melo、Meyn 与 Ribeiro（2008）。Mountain Car 例子基于 Moore（1990）研究的一个类似任务，但这里使用的确切形式来自 Sutton（1996）。
    ],

    [*10.2*],
    [
      回合式 $n$ 步半梯度 Sarsa 基于 van Seijen（2016）的前向 Sarsa($lambda$) 算法。这里展示的实验结果是本书第二版新增的。
    ],

    [*10.3*],
    [
      平均奖励表述曾在动态规划的文献中得到描述（例如 Puterman，1994），也从强化学习的角度得到过描述（Mahadevan，1996；Tadepalli 与 Ok，1994；Bertsekas 与 Tsitsiklis，1996；Tsitsiklis 与 Van Roy，1999）。这里描述的算法是 Schwartz（1993）提出的「R-learning」算法的 on-policy 对应算法。R-learning 这一名称大概意在按字母顺序接续 Q-learning，但我们更愿意把它理解为指代对微分值、也就是#ezh[相对]值的学习。接入控制排队例子受 Carlström 与 Nordström（1997）工作的启发。
    ],

    [*10.4*],
    [
      本书第一版出版后不久，作者们就清楚地认识到了折扣作为一种带函数近似的强化学习问题表述所具有的局限。Singh、Jaakkola 与 Jordan（1994）也许是最早在出版物中观察到这一点的。
    ],
  )
]
