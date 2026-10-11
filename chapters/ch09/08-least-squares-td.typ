#import "../../template.typ": *

== 最小二乘 TD <sec-9-8>

本章到目前为止讨论的所有方法，每个时间步所需的计算量都与参数数目成正比。然而，用更多的计算可以做得更好。这一节介绍一种线性函数近似方法，它可以说是这种情形下所能做到的最好方法。

正如第 9.4 节所确立的，线性函数近似下的 TD(0) 在步长适当递减时渐近收敛到 TD 不动点：

#{
  set math.equation(numbering: none)
  $ bold(w)_"TD" = bold(A)^(-1) bold(b), $
}

其中

#{
  set math.equation(numbering: none)
  $ bold(A) ≐ bb(E)[ bold(x)_t ( bold(x)_t - gamma bold(x)_(t+1) )^top ] quad "and" quad bold(b) ≐ bb(E)[ R_(t+1) bold(x)_t ]. $
}

有人可能会问，为什么必须迭代地计算这个解？这样做浪费数据！能不能先计算 $bold(A)$ 与 $bold(b)$ 的估计，然后直接算出 TD 不动点，从而做得更好？#ezh[最小二乘 TD]算法（通常称为 #ezh[LSTD]）正是这样做的。它构造下面这两个自然的估计：

$ hat(bold(A))_t ≐ sum_(k=0)^(t-1) bold(x)_k ( bold(x)_k - gamma bold(x)_(k+1) )^top + epsilon bold(I) quad "and" quad hat(bold(b))_t ≐ sum_(k=0)^(t-1) R_(k+1) bold(x)_k, $ <eq-9-20>

其中 $bold(I)$ 是单位矩阵，而 $epsilon bold(I)$（对某个小的 $epsilon > 0$）保证 $hat(bold(A))_t$ 总是可逆的。这两个估计似乎都应当除以 $t$，它们确实应当如此；按这里的定义，它们实际上是 $t$ 倍的 $bold(A)$ 与 $t$ 倍的 $bold(b)$ 的估计。不过在 LSTD 用这些估计来估计 TD 不动点的时候，多出来的 $t$ 因子会相互抵消，即

$ bold(w)_t ≐ hat(bold(A))_t^(-1) hat(bold(b))_t. $ <eq-9-21>

这个算法是数据效率最高的线性 TD(0) 形式，但计算上也更昂贵。回顾一下，半梯度 TD(0) 所需的内存与每步计算量都只有 $O(d)$。

LSTD 的复杂度如何？按上面的写法，复杂度似乎随 $t$ 增长，但 @eq-9-20 中的两个近似可以用我们前面（例如第 2 章）介绍过的技术增量地实现，使每步都能在常数时间内完成。即便如此，$hat(bold(A))_t$ 的更新会涉及一个外积（列向量乘以行向量），因而是一次矩阵更新；其计算复杂度为 $O(d^2)$，当然，保存 $hat(bold(A))_t$ 矩阵所需的内存也是 $O(d^2)$。

一个可能更大的问题是，我们最后的计算 @eq-9-21 要用到 $hat(bold(A))_t$ 的逆，而一般逆矩阵的计算复杂度是 $O(d^3)$。幸运的是，像我们这种特殊形式的矩阵（外积之和）的逆也可以增量地更新，只需 $O(d^2)$ 次计算，即

$ hat(bold(A))_t^(-1) &= ( hat(bold(A))_(t-1) + bold(x)_(t-1) ( bold(x)_(t-1) - gamma bold(x)_t )^top )^(-1) quad #text(size: 9pt)[（由 #ref(<eq-9-20>)）] \
                       &= hat(bold(A))_(t-1)^(-1) - frac( hat(bold(A))_(t-1)^(-1) bold(x)_(t-1) ( bold(x)_(t-1) - gamma bold(x)_t )^top hat(bold(A))_(t-1)^(-1), 1 + ( bold(x)_(t-1) - gamma bold(x)_t )^top hat(bold(A))_(t-1)^(-1) bold(x)_(t-1) ), $ <eq-9-22>

对 $t > 0$ 成立，其中 $hat(bold(A))_0 ≐ epsilon bold(I)$。恒等式 @eq-9-22 称为#ezh[Sherman-Morrison 公式]，表面上看起来很复杂，但它只涉及向量–矩阵乘法与向量–向量乘法，因此只有 $O(d^2)$。于是我们可以保存逆矩阵 $hat(bold(A))_t^(-1)$，用 @eq-9-22 维护它，然后在 @eq-9-21 中使用它，全部只需 $O(d^2)$ 的内存与每步计算量。完整算法见下面的方框。

#algbox([估计 $hat(v) = bold(w)^top bold(x)(dot.op) approx v_pi$ 的 LSTD（$O(d^2)$ 版本）])[
  输入：特征表示 $bold(x) : cal(S)^+ -> bb(R)^d$，且满足 $bold(x)(italic("terminal")) = bold(0)$ \
  算法参数：小的 $epsilon > 0$

  $hat(bold(A))^(-1) arrow.l epsilon^(-1) bold(I)$#h(1fr)一个 $d × d$ 矩阵 \
  $hat(bold(b)) arrow.l bold(0)$#h(1fr)一个 $d$ 维向量

  对每个回合循环：\
  #h(1.5em) 初始化 $S$；$bold(x) arrow.l bold(x)(S)$ \
  #h(1.5em) 对该回合的每一步循环：\
  #h(3em) 选择并采取动作 $A tilde pi (dot.op | S)$，观测 $R$、$S'$；$bold(x)' arrow.l bold(x)(S')$ \
  #h(3em) $bold(v) arrow.l hat(bold(A))^(-1)^top (bold(x) - gamma bold(x)')$ \
  #h(3em) $hat(bold(A))^(-1) arrow.l hat(bold(A))^(-1) - (hat(bold(A))^(-1) bold(x)) bold(v)^top slash (1 + bold(v)^top bold(x))$ \
  #h(3em) $hat(bold(b)) arrow.l hat(bold(b)) + R bold(x)$ \
  #h(3em) $bold(w) arrow.l hat(bold(A))^(-1) hat(bold(b))$ \
  #h(3em) $S arrow.l S'$；$bold(x) arrow.l bold(x)'$ \
  #h(1.5em) 直到 $S'$ 是终止状态
]

当然，$O(d^2)$ 仍然比半梯度 TD 的 $O(d)$ 昂贵得多。LSTD 更高的数据效率是否值得这些计算开销，取决于 $d$ 有多大、快速学习有多重要，以及系统其他部分的开销。LSTD 不需要步长参数，这一点有时也被称道，但这一优势很可能被夸大了。LSTD 不需要步长，但它确实需要 $epsilon$；如果 $epsilon$ 取得太小，逆矩阵的序列可能剧烈变化，如果 $epsilon$ 取得太大，学习就会变慢。此外，LSTD 没有步长参数，意味着它从不遗忘。这有时是可取的，但如果目标策略 $pi$ 发生变化（如强化学习和 GPI 中那样），就会有问题。在控制应用中，LSTD 通常必须与其他某种机制结合以引入遗忘，这样不需要步长参数这一最初的优势也就无从谈起了。
