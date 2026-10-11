#import "../../template.typ": *

== #sym.ast.basic 蒙特卡洛学习中的荷兰迹 <sec-12-6>

尽管资格迹在历史上与 TD 学习紧密相关，但实际上它们与 TD 学习毫无关系。事实上，正如本节将要展示的，资格迹甚至出现在蒙特卡洛学习中。我们将表明，把线性 MC 算法（第 9 章）看作前向视图，可以用它导出使用荷兰迹的等价但计算上更廉价的后向视图算法。这是本书中我们明确演示的唯一一个前向视图与后向视图的等价关系。它体现了 true online TD($lambda$) 与在线 $lambda$ 回报算法等价性证明的几分风味，但要简单得多。

梯度蒙特卡洛预测算法的线性版本（原书第 202 页）做出如下一系列更新，回合的每个时间步一个：

$ bold(w)_(t+1) ≐ bold(w)_t + alpha [G - bold(w)_t^top bold(x)_t] bold(x)_t, quad 0 <= t < T. $ <eq-12-13>

为了简化这个例子，我们在这里假定回报 $G$ 是回合结束时收到的单个奖励（这就是 $G$ 不带时间下标的原因），并且不做折扣。在这种情况下，这个更新也称为最小均方（LMS）规则。作为一个蒙特卡洛算法，所有更新都依赖于最终的奖励或者回报，因此在回合结束之前一个更新也做不了。MC 算法是一个离线算法，我们并不寻求改进它的这一方面，我们只寻求这个算法的一种具有计算优势的实现。我们仍然只在回合结束时更新权重向量，但会在回合的每一步做一些计算，使回合结束时的计算量少一些。这将使计算分布更均匀，每步 $O(d)$，并且免除了在每一步存储特征向量、供回合结束时使用的必要。取而代之，我们将引入一个额外的向量记忆，即资格迹，在其中保存到目前为止所见全部特征向量的汇总。到回合结束时，这就足以高效地精确重现与 MC 更新序列 @eq-12-13 相同的总体更新：

#{
  set math.equation(numbering: none)
  $ bold(w)_T &≐ bold(w)_(T-1) + alpha (G - bold(w)_(T-1)^top bold(x)_(T-1)) bold(x)_(T-1) \
    &= bold(w)_(T-1) + alpha bold(x)_(T-1)(-bold(x)_(T-1)^top bold(w)_(T-1)) + alpha G bold(x)_(T-1) \
    &= (bold(I) - alpha bold(x)_(T-1) bold(x)_(T-1)^top) bold(w)_(T-1) + alpha G bold(x)_(T-1) \
    &= bold(F)_(T-1) bold(w)_(T-1) + alpha G bold(x)_(T-1), $
}

其中 $bold(F)_t ≐ bold(I) - alpha bold(x)_t bold(x)_t^top$ 是一个#ezh[遗忘矩阵]，或者说#ezh[衰减矩阵]。现在，递归下去，得到

$ &= bold(F)_(T-1)(bold(F)_(T-2) bold(w)_(T-2) + alpha G bold(x)_(T-2)) + alpha G bold(x)_(T-1) \
    &= bold(F)_(T-1) bold(F)_(T-2) bold(w)_(T-2) + alpha G (bold(F)_(T-1) bold(x)_(T-2) + bold(x)_(T-1)) \
    &= bold(F)_(T-1) bold(F)_(T-2)(bold(F)_(T-3) bold(w)_(T-3) + alpha G bold(x)_(T-3)) + alpha G (bold(F)_(T-1) bold(x)_(T-2) + bold(x)_(T-1)) \
    &= bold(F)_(T-1) bold(F)_(T-2) bold(F)_(T-3) bold(w)_(T-3) + alpha G (bold(F)_(T-1) bold(F)_(T-2) bold(x)_(T-3) + bold(F)_(T-1) bold(x)_(T-2) + bold(x)_(T-1)) \
    &dots.v \
    &= underbrace(bold(F)_(T-1) bold(F)_(T-2) dots.c bold(F)_0 bold(w)_0, bold(a)_(T-1)) + alpha G underbrace(sum_(k=0)^(T-1) bold(F)_(T-1) bold(F)_(T-2) dots.c bold(F)_(k+1) bold(x)_k, bold(z)_(T-1)) \
    &= bold(a)_(T-1) + alpha G bold(z)_(T-1), $ <eq-12-14>

其中 $bold(a)_(T-1)$ 与 $bold(z)_(T-1)$ 是两个辅助记忆向量在时间 $T - 1$ 处的取值，它们可以增量式地更新，既不需要知道 $G$，每步的计算复杂度也是 $O(d)$。$bold(z)_t$ 向量实际上就是一个荷兰迹式的资格迹。它初始化为 $bold(z)_0 = bold(x)_0$，然后按下式更新

#{
  set math.equation(numbering: none)
  $ bold(z)_t &≐ sum_(k=0)^t bold(F)_t bold(F)_(t-1) dots.c bold(F)_(k+1) bold(x)_k, quad 1 <= t < T \
    &= sum_(k=0)^(t-1) bold(F)_t bold(F)_(t-1) dots.c bold(F)_(k+1) bold(x)_k + bold(x)_t \
    &= bold(F)_t sum_(k=0)^(t-1) bold(F)_(t-1) bold(F)_(t-2) dots.c bold(F)_(k+1) bold(x)_k + bold(x)_t \
    &= bold(F)_t bold(z)_(t-1) + bold(x)_t \
    &= (bold(I) - alpha bold(x)_t bold(x)_t^top) bold(z)_(t-1) + bold(x)_t \
    &= bold(z)_(t-1) - alpha bold(x)_t bold(x)_t^top bold(z)_(t-1) + bold(x)_t \
    &= bold(z)_(t-1) - alpha (bold(z)_(t-1)^top bold(x)_t) bold(x)_t + bold(x)_t \
    &= bold(z)_(t-1) + (1 - alpha bold(z)_(t-1)^top bold(x)_t) bold(x)_t, $
}

这就是 $gamma lambda = 1$ 情形下的荷兰迹（参见 @eq-12-11）。辅助向量 $bold(a)_t$ 初始化为 $bold(a)_0 = bold(w)_0$，然后按下式更新

#{
  set math.equation(numbering: none)
  $ bold(a)_t ≐ bold(F)_t bold(F)_(t-1) dots.c bold(F)_0 bold(w)_0 = bold(F)_t bold(a)_(t-1) = bold(a)_(t-1) - alpha bold(x)_t bold(x)_t^top bold(a)_(t-1), quad 1 <= t < T. $
}

辅助向量 $bold(a)_t$ 与 $bold(z)_t$ 在每个时间步 $t < T$ 上更新，然后在时间 $T$ 观测到 $G$ 时，它们被用于 @eq-12-14 来计算 $bold(w)_T$。这样一来，我们得到与计算性质不佳的 MC/LMS 算法 @eq-12-13 完全相同的最终结果，但现在用的是每步时间与内存复杂度均为 $O(d)$ 的增量式算法。这既令人意外又引人深思，因为资格迹（尤其是荷兰迹）的概念是在一个不含时序差分（TD）学习的设定中出现的（与 van Seijen 和 Sutton，2014 相对照）。看来资格迹根本不专属于 TD 学习；它们比这更为根本。只要人们试图以高效的方式学习长期预测，似乎就会出现对资格迹的需要。
