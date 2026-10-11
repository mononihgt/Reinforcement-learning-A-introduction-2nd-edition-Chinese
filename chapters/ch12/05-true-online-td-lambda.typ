#import "../../template.typ": *

== true online TD($lambda$) <sec-12-5>

刚才给出的在线 $lambda$ 回报算法是目前表现最好的时序差分算法。它是一个理想，在线 TD($lambda$) 只能近似它。然而，如前所述，在线 $lambda$ 回报算法非常复杂。有没有办法把这个前向视图算法反过来，得到一个使用资格迹的、高效的后向视图算法？事实证明，在线性函数近似的情形中，确实存在在线 $lambda$ 回报算法的一个精确、便于计算的实现。这个实现称为 true online TD($lambda$) 算法，因为它比 TD($lambda$) 算法更「贴近」在线 $lambda$ 回报算法的理想。

true online TD($lambda$) 的推导稍嫌复杂，不适于在这里给出（见下一节以及 van Seijen 等（2016）论文的附录），但它的策略很简单。在线 $lambda$ 回报算法产生的权重向量序列可以排成一个三角形：

#{
  set math.equation(numbering: none)
  $ mat(delim: #none,
    bold(w)_0^0, , , , , ;
    bold(w)_0^1, bold(w)_1^1, , , , ;
    bold(w)_0^2, bold(w)_1^2, bold(w)_2^2, , , ;
    bold(w)_0^3, bold(w)_1^3, bold(w)_2^3, bold(w)_3^3, , ;
    dots.v, dots.v, dots.v, dots.v, dots.down, ;
    bold(w)_0^T, bold(w)_1^T, bold(w)_2^T, bold(w)_3^T, dots.c, bold(w)_T^T;
  ) $
}

这个三角形在每一个时间步产生一行。事实证明，真正需要的只有对角线上的权重向量，即 $bold(w)_t^t$。第一个 $bold(w)_0^0$ 是回合的初始权重向量，最后一个 $bold(w)_T^T$ 是最终权重向量，沿途的每个权重向量 $bold(w)_t^t$ 都在更新的 $n$ 步回报中参与自举。在最终算法中，对角线上的权重向量被重新命名，不带任何上标：$bold(w)_t ≐ bold(w)_t^t$。策略于是就是找到一种紧凑、高效的方式，从前一个权重向量算出每一个 $bold(w)_t^t$。做到这一点之后，对 $hat(v)(s, bold(w)) = bold(w)^top bold(x)(s)$ 的线性情形，我们就得到 true online TD($lambda$) 算法：

#{
  set math.equation(numbering: none)
  $ bold(w)_(t+1) ≐ bold(w)_t + alpha delta_t bold(z)_t + alpha (bold(w)_t^top bold(x)_t - bold(w)_(t-1)^top bold(x)_t)(bold(z)_t - bold(x)_t), $
}

其中我们使用了简写 $bold(x)_t ≐ bold(x)(S_t)$，$delta_t$ 的定义与 TD($lambda$) 中相同（@eq-12-6），$bold(z)_t$ 的定义为

$ bold(z)_t ≐ gamma lambda bold(z)_(t-1) + (1 - alpha gamma lambda bold(z)_(t-1)^top bold(x)_t) bold(x)_t. $ <eq-12-11>

已经证明，这个算法产生的权重向量序列 $bold(w)_t$（$0 <= t <= T$）与在线 $lambda$ 回报算法完全相同（van Seijen 等，2016）。因此，@fig-12-8 左侧随机游走任务上的结果也就是它在该任务上的结果。但现在这个算法的开销小得多。true online TD($lambda$) 的内存需求与常规 TD($lambda$) 完全相同，而每一步的计算量增加约 50%（资格迹更新中多了一次内积）。总体而言，每步的计算复杂度仍然是 $O(d)$，与 TD($lambda$) 相同。完整算法的伪代码见方框。

#algbox([估计 $bold(w)^top bold(x) approx v_pi$ 的 true online TD($lambda$)])[
  输入：待评估的策略 $pi$ \
  输入：特征函数 $bold(x) : cal(S)^+ -> bb(R)^d$，且满足 $bold(x)("terminal", dot.op) = bold(0)$ \
  算法参数：步长 $alpha > 0$、迹衰减率 $lambda in [0, 1]$ \
  初始化值函数权重 $bold(w) in bb(R)^d$（例如 $bold(w) = bold(0)$）

  对每个回合循环：\
  #h(1.5em) 初始化状态，并获得初始特征向量 $bold(x)$ \
  #h(1.5em) $bold(z) arrow.l bold(0)$（一个 $d$ 维向量） \
  #h(1.5em) $V_"old" arrow.l 0$（一个临时标量变量） \
  #h(1.5em) 对该回合的每一步循环：\
  #h(3em) 选择 $A tilde pi$ \
  #h(3em) 采取动作 $A$，观测到 $R$、$bold(x)'$（下一状态的特征向量） \
  #h(3em) $V arrow.l bold(w)^top bold(x)$ \
  #h(3em) $V' arrow.l bold(w)^top bold(x)'$ \
  #h(3em) $delta arrow.l R + gamma V' - V$ \
  #h(3em) $bold(z) arrow.l gamma lambda bold(z) + (1 - alpha gamma lambda bold(z)^top bold(x)) bold(x)$ \
  #h(3em) $bold(w) arrow.l bold(w) + alpha (delta + V - V_"old") bold(z) - alpha (V - V_"old") bold(x)$ \
  #h(3em) $V_"old" arrow.l V'$ \
  #h(3em) $bold(x) arrow.l bold(x)'$ \
  #h(1.5em) 直到 $bold(x)' = bold(0)$（表示到达终止状态）
]

true online TD($lambda$) 中使用的资格迹 @eq-12-11 称为#ezh[荷兰迹]（dutch trace），以区别于 TD($lambda$) 中使用的迹 @eq-12-5，后者称为#ezh[累积迹]（accumulating trace）。

早先的工作常常使用第三种迹，称为替换迹，它只对表格型情形或者二元特征向量（例如瓦片编码产生的那些）定义。替换迹按分量逐个定义，取决于特征向量的分量是 1 还是 0：

$ z_(i,t) ≐ cases(1 &"if" x_(i,t) = 1, gamma lambda z_(i,t-1) &"otherwise" .) $ <eq-12-12>

如今，我们把替换迹看作对荷兰迹的粗略近似，荷兰迹基本取代了它们。荷兰迹通常比替换迹表现更好，理论基础也更清晰。对于荷兰迹不可用的非线性函数近似，累积迹仍然有意义。
