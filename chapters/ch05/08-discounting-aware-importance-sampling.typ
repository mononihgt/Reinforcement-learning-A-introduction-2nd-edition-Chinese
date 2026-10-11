#import "../../template.typ": *

== #sym.ast.basic 考虑折扣的重要性采样 <sec-5-8>

到目前为止我们考虑过的 off-policy 方法，都是把回报当作一个整体来构造重要性采样权重，没有考虑回报作为折扣奖励之和的内部结构。现在我们简要介绍一些前沿研究想法，它们利用这种结构来显著降低 off-policy 估计量的方差。

例如，考虑回合很长而 $gamma$ 明显小于 1 的情形。具体一点，假设回合持续 100 步，且 $gamma = 0$。此时从时刻 0 出发的回报就是 $G_0 = R_1$，但它的重要性采样率却是 100 个因子的乘积，$pi (A_0|S_0) slash b(A_0|S_0) dots.c pi (A_99|S_99) slash b(A_99|S_99)$。在普通重要性采样中，回报会被整个乘积缩放，而实际上只需用第一个因子 $pi (A_0|S_0) slash b(A_0|S_0)$ 缩放就够了。其余 99 个因子 $pi (A_1|S_1) slash b(A_1|S_1) dots.c pi (A_99|S_99) slash b(A_99|S_99)$ 是无关的，因为在第一个奖励之后，回报已经确定了。这些靠后的因子都与回报独立，期望值为 1；它们不改变期望的更新，却极大地增加更新的方差。在某些情形下，它们甚至可能使方差无穷大。现在我们来考虑一个避免这种巨大额外方差的想法。

这个想法的要点是，把折扣看作在确定一个终止概率，或者等价地说，一个#ezh[部分终止的程度]。对任何 $gamma in [0, 1)$，我们可以把回报 $G_0$ 看成以 $1 - gamma$ 的程度在第 1 步部分终止，产生只含第一个奖励 $R_1$ 的回报；以 $(1 - gamma) gamma$ 的程度在第 2 步部分终止，产生 $R_1 + R_2$ 的回报；依此类推。后一个程度对应于在第 2 步终止（$1 - gamma$）且没有已经在第 1 步终止（$gamma$）。因此第 3 步终止的程度是 $(1 - gamma) gamma^2$，其中的 $gamma^2$ 反映的是前两步都没有发生终止。这里的部分回报称为#ezh[平坦部分回报]：

#{
  set math.equation(numbering: none)
  $ overline(G)_(t:h) ≐ R_(t+1) + R_(t+2) + dots.c + R_h, quad 0 <= t < h <= T, $
}

其中「平坦」表示没有折扣，而「部分」表示这些回报并没有一直延伸到终止，而是停在 $h$，$h$ 称为#ezh[视界]（$T$ 是回合的终止时刻）。按照上面提示的方式，通常的完整回报 $G_t$ 可以看成平坦部分回报之和：

#{
  set math.equation(numbering: none)
  $ G_t &≐ R_(t+1) + gamma R_(t+2) + gamma^2 R_(t+3) + dots.c + gamma^(T-t-1) R_T \
        &= (1 - gamma) R_(t+1) \
        &quad + (1 - gamma) gamma (R_(t+1) + R_(t+2)) \
        &quad + (1 - gamma) gamma^2 (R_(t+1) + R_(t+2) + R_(t+3)) \
        &quad dots.v \
        &quad + (1 - gamma) gamma^(T-t-2) (R_(t+1) + R_(t+2) + dots.c + R_(T-1)) \
        &quad + gamma^(T-t-1) (R_(t+1) + R_(t+2) + dots.c + R_T) \
        &= (1 - gamma) sum_(h=t+1)^(T-1) gamma^(h-t-1) overline(G)_(t:h) + gamma^(T-t-1) overline(G)_(t:T). $
}

现在我们需要用一个同样截断的重要性采样率来缩放平坦部分回报。由于 $overline(G)_(t:h)$ 只涉及直到视界 $h$ 的奖励，我们只需要到 $h - 1$ 的概率之比。我们定义一个与 @eq-5-5 类似的普通重要性采样估计量：

$ V(s) ≐ frac(sum_(t in cal(T)(s)) ((1 - gamma) op("∑", limits: #false)_(h=t+1)^(T(t)-1) gamma^(h-t-1) rho_(t:h-1) overline(G)_(t:h) + gamma^(T(t)-t-1) rho_(t:T(t)-1) overline(G)_(t:T(t))), |cal(T)(s)|), $ <eq-5-9>

以及与 @eq-5-6 类似的加权重要性采样估计量：

$ V(s) ≐ frac(sum_(t in cal(T)(s)) ((1 - gamma) op("∑", limits: #false)_(h=t+1)^(T(t)-1) gamma^(h-t-1) rho_(t:h-1) overline(G)_(t:h) + gamma^(T(t)-t-1) rho_(t:T(t)-1) overline(G)_(t:T(t))), sum_(t in cal(T)(s)) ((1 - gamma) op("∑", limits: #false)_(h=t+1)^(T(t)-1) gamma^(h-t-1) rho_(t:h-1) + gamma^(T(t)-t-1) rho_(t:T(t)-1))). $ <eq-5-10>

我们把这两个估计量称为#ezh[考虑折扣的]重要性采样估计量。它们把折扣率考虑在内，但如果 $gamma = 1$，它们就不产生任何影响（与第 5.5 节的 off-policy 估计量相同）。
