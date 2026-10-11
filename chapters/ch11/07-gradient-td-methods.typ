#import "../../template.typ": *

== gradient-TD 方法 <sec-11-7>

现在我们来考虑最小化 PBE 的 SGD 方法。这些 #emph[gradient-TD] 方法作为真正的 SGD 方法，即使在 off-policy 训练与非线性函数近似下，也具有稳健的收敛性质。回忆一下，在线性情形中总是存在精确解，也就是 TD 不动点 $bold(w)_"TD"$，在该点 PBE 为零。这个解可以由最小二乘方法（第 9.8 节）找到，但只能由复杂度关于参数数目为二次 $O(d^2)$ 的方法找到。我们要找的则是一个 SGD 方法，它应当是 $O(d)$ 的，并且具有稳健的收敛性质。gradient-TD 方法接近实现这些目标，代价是计算复杂度大约翻倍。

为了导出针对 PBE 的 SGD 方法（假定使用线性函数近似），我们先展开目标 @eq-11-22，并用矩阵形式改写它：

$ overline("PBE")(bold(w)) &= norm(Pi overline(delta)_bold(w))_mu^2 \
                          &= (Pi overline(delta)_bold(w))^top bold(D) Pi overline(delta)_bold(w) quad #text(size: 9pt)[（由 #ref(<eq-11-14>)）] \
                          &= overline(delta)_bold(w)^top Pi^top bold(D) Pi overline(delta)_bold(w) \
                          &= overline(delta)_bold(w)^top bold(D) bold(X) ( bold(X)^top bold(D) bold(X) )^(-1) bold(X)^top bold(D) overline(delta)_bold(w) $ <eq-11-25>

这里用到了 @eq-11-13 与恒等式 $Pi^top bold(D) Pi = bold(D) bold(X) ( bold(X)^top bold(D) bold(X) )^(-1) bold(X)^top bold(D)$。

$ = ( bold(X)^top bold(D) overline(delta)_bold(w) )^top ( bold(X)^top bold(D) bold(X) )^(-1) ( bold(X)^top bold(D) overline(delta)_bold(w) ) . $ <eq-11-26>

对 $bold(w)$ 的梯度是

#{
  set math.equation(numbering: none)
  $ nabla overline("PBE")(bold(w)) = 2 nabla [ bold(X)^top bold(D) overline(delta)_bold(w) ]^top ( bold(X)^top bold(D) bold(X) )^(-1) ( bold(X)^top bold(D) overline(delta)_bold(w) ) . $
}

要把它变成 SGD 方法，我们必须能在每个时间步上采样到某个以这个量为期望值的东西。让我们取 $mu$ 为行为策略下访问到的状态的分布。于是上面三个因子中的每一个都可以写成这个分布下的期望。例如，最后一个因子可以写成

#{
  set math.equation(numbering: none)
  $ bold(X)^top bold(D) overline(delta)_bold(w) = sum_s mu(s) bold(x)(s) overline(delta)_bold(w)(s) = bb(E)[rho_t delta_t bold(x)_t], $
}

它正是半梯度 TD(0) 更新 @eq-11-2 的期望。第一个因子是这个更新的梯度的转置：

#{
  set math.equation(numbering: none)
  $ nabla bb(E)[rho_t delta_t bold(x)_t]^top &= bb(E)[rho_t nabla delta_t^top bold(x)_t^top] \
                                             &= bb(E)[rho_t nabla (R_(t+1) + gamma bold(w)^top bold(x)_(t+1) - bold(w)^top bold(x)_t)^top bold(x)_t^top] quad #text(size: 9pt)[（使用回合制的 $delta_t$）] \
                                             &= bb(E)[rho_t (gamma bold(x)_(t+1) - bold(x)_t) bold(x)_t^top] . $
}

最后，中间那个因子是特征向量外积的期望矩阵的逆：

#{
  set math.equation(numbering: none)
  $ bold(X)^top bold(D) bold(X) = sum_s mu(s) bold(x)(s) bold(x)(s)^top = bb(E)[bold(x)_t bold(x)_t^top] . $
}

把这三个期望代回我们关于 PBE 梯度的表达式中的三个因子处，就得到

$ nabla overline("PBE")(bold(w)) = 2 bb(E)[rho_t (gamma bold(x)_(t+1) - bold(x)_t) bold(x)_t^top] bb(E)[bold(x)_t bold(x)_t^top]^(-1) bb(E)[rho_t delta_t bold(x)_t] . $ <eq-11-27>

把梯度写成这种形式是否让我们有任何进展，这一点也许并不明显。它是三个表达式的乘积，而第一个与最后一个并不独立。它们都依赖于下一个特征向量 $bold(x)_(t+1)$；我们不能简单地分别采样这两个期望，再把样本相乘。那样得到的是梯度的有偏估计，就像残差梯度算法中一样。

另一个想法是分别估计这三个期望，再把它们组合起来，产生梯度的无偏估计。这样做可以奏效，但会需要大量计算资源，尤其是要存储前两个期望（它们是 $d times d$ 矩阵）以及计算第二个期望的逆。这个想法还可以改进。如果估计并存储三个期望中的两个，那么第三个就可以被采样，并与存储下来的两个量结合起来使用。例如，可以存储后两个量的估计（使用第 9.8 节的增量式逆更新技术），然后采样第一个表达式。遗憾的是，整个算法的复杂度仍然是二次的（$O(d^2)$ 的量级）。

分别存储一些估计、再把它们与样本结合起来，这个想法很好，gradient-TD 方法也采用了它。gradient-TD 方法估计并存储 @eq-11-27 中后两个因子的乘积。这两个因子一个是 $d times d$ 矩阵，另一个是 $d$ 维向量，所以它们的乘积只是一个 $d$ 维向量，与 $bold(w)$ 本身一样。我们用 $bold(v)$ 表示这第二个被学习的向量：

$ bold(v) approx bb(E)[bold(x)_t bold(x)_t^top]^(-1) bb(E)[rho_t delta_t bold(x)_t] . $ <eq-11-28>

这个形式对学习过线性监督学习的人应该很熟悉。它是用特征近似 $rho_t delta_t$ 的线性最小二乘问题的解。增量式地找到使期望平方误差 $(bold(v)^top bold(x)_t - rho_t delta_t)^2$ 最小的向量 $bold(v)$，所用的标准 SGD 方法称为最小均方（LMS）规则（这里还乘上了重要性采样率）：

#{
  set math.equation(numbering: none)
  $ bold(v)_(t+1) ≐ bold(v)_t + beta rho_t ( delta_t - bold(v)_t^top bold(x)_t ) bold(x)_t, $
}

其中 $beta > 0$ 是另一个步长参数。用这个方法能以 $O(d)$ 的存储量与每步计算量有效地实现 @eq-11-28。

有了近似 @eq-11-28 的存储估计 $bold(v)_t$，我们就可以基于 @eq-11-27 用 SGD 方法更新主参数向量 $bold(w)_t$。这类规则中最简单的是

$ bold(w)_(t+1) &= bold(w)_t - frac(1, 2) alpha nabla overline("PBE")(bold(w)_t) quad #text(size: 9pt)[（一般的 SGD 规则）] \
                &= bold(w)_t - frac(1, 2) alpha 2 bb(E)[rho_t (gamma bold(x)_(t+1) - bold(x)_t) bold(x)_t^top] bb(E)[bold(x)_t bold(x)_t^top]^(-1) bb(E)[rho_t delta_t bold(x)_t] quad #text(size: 9pt)[（由 #ref(<eq-11-27>)）] \
                &= bold(w)_t + alpha bb(E)[rho_t (bold(x)_t - gamma bold(x)_(t+1)) bold(x)_t^top] bb(E)[bold(x)_t bold(x)_t^top]^(-1) bb(E)[rho_t delta_t bold(x)_t] \
                &approx bold(w)_t + alpha bb(E)[rho_t (bold(x)_t - gamma bold(x)_(t+1)) bold(x)_t^top] bold(v)_t quad #text(size: 9pt)[（基于 #ref(<eq-11-28>)）] \
                &approx bold(w)_t + alpha rho_t ( bold(x)_t - gamma bold(x)_(t+1) ) bold(x)_t^top bold(v)_t . quad #text(size: 9pt)[（采样）] $ <eq-11-29>

这个算法称为 GTD2。注意，如果先做最后那个内积 $bold(x)_t^top bold(v)_t$，那么整个算法就是 $O(d)$ 复杂度的。

在代入 $bold(v)_t$ 之前再多做几步解析推导，就可以导出一个略好一些的算法。从 @eq-11-29 继续：

#{
  set math.equation(numbering: none)
  $ bold(w)_(t+1) &= bold(w)_t + alpha bb(E)[rho_t (bold(x)_t - gamma bold(x)_(t+1)) bold(x)_t^top] bb(E)[bold(x)_t bold(x)_t^top]^(-1) bb(E)[rho_t delta_t bold(x)_t] \
                  &= bold(w)_t + alpha ( bb(E)[rho_t bold(x)_t bold(x)_t^top] - gamma bb(E)[rho_t bold(x)_(t+1) bold(x)_t^top] ) bb(E)[bold(x)_t bold(x)_t^top]^(-1) bb(E)[rho_t delta_t bold(x)_t] \
                  &= bold(w)_t + alpha ( bb(E)[bold(x)_t bold(x)_t^top] - gamma bb(E)[rho_t bold(x)_(t+1) bold(x)_t^top] ) bb(E)[bold(x)_t bold(x)_t^top]^(-1) bb(E)[rho_t delta_t bold(x)_t] \
                  &= bold(w)_t + alpha ( bb(E)[rho_t delta_t bold(x)_t] - gamma bb(E)[rho_t bold(x)_(t+1) bold(x)_t^top] bb(E)[bold(x)_t bold(x)_t^top]^(-1) bb(E)[rho_t delta_t bold(x)_t] ) \
                  &approx bold(w)_t + alpha ( bb(E)[rho_t delta_t bold(x)_t] - gamma bb(E)[rho_t bold(x)_(t+1) bold(x)_t^top] bold(v)_t ) quad #text(size: 9pt)[（基于 #ref(<eq-11-28>)）] \
                  &approx bold(w)_t + alpha rho_t ( delta_t bold(x)_t - gamma bold(x)_(t+1) bold(x)_t^top bold(v)_t ), quad #text(size: 9pt)[（采样）] $
}

同样，如果先做最后那个乘积 $bold(x)_t^top bold(v)_t$，它也是 $O(d)$ 的。这个算法称为带梯度修正的 TD(0)（TDC），或者称为 GTD(0)。

@fig-11-5 给出了 TDC 在 Baird 反例上的一个样本以及它的期望行为。正如预期，PBE 降到零，但请注意，参数向量的各个分量并没有趋近于零。事实上，这些值仍然远离最优解 $hat(v)(s) = 0$（对所有 $s$ 成立），要达到那个最优解，$bold(w)$ 必须与 $(1, 1, 1, 1, 1, 1, 4, -2)^top$ 成比例。经过 1000 次迭代，我们仍然远离最优解，从几乎保持在 2 附近的 VE 上可以看出这一点。系统实际上正在收敛到一个最优解，但进展极其缓慢，因为 PBE 已经如此接近零。

#figure(
  image("../../assets/figures/ch11/fig-11-5.png", width: 94%),
  caption: [TDC 算法在 Baird 反例上的行为。左侧给出一次典型的单次运行，右侧给出在更新同步进行（与 @eq-11-9 类似，只是换成 TDC 的两个参数向量）时这个算法的期望行为。步长为 $alpha = 0.005$ 与 $beta = 0.05$。],
)<fig-11-5>

GTD2 与 TDC 都涉及两个学习过程：一个是为 $bold(w)$ 的主学习过程，另一个是为 $bold(v)$ 的次级学习过程。主学习过程的逻辑依赖于次级学习过程已经完成，至少近似完成，而次级学习过程的前进不受主学习过程的影响。我们把这种不对称的依赖关系称为级联（cascade）。在级联中，我们通常假定次级学习过程进行得更快，因此总是处于它的渐近值上，随时可以准确协助主学习过程。这类方法的收敛性证明常常明确做出这个假设。它们被称为双时间尺度（two-time-scale）证明。快的时间尺度属于次级学习过程，较慢的时间尺度属于主学习过程。如果 $alpha$ 是主学习过程的步长，$beta$ 是次级学习过程的步长，那么这些收敛性证明通常会要求取极限时 $beta arrow.l 0$ 且 $frac(alpha, beta) arrow.l 0$。

gradient-TD 方法目前是理解得最透彻、应用得最广泛的稳定 off-policy 方法。它们已被扩展到动作值与控制（GQ，Maei 等，2010）、资格迹（GTD(λ) 与 GQ(λ)，Maei，2011；Maei 与 Sutton，2010）以及非线性函数近似（Maei 等，2009）。人们还提出了介于半梯度 TD 与 gradient-TD 之间的混合算法（Hackman，2012；White 与 White，2016）。混合 TD 算法在目标策略与行为策略差别很大的状态上表现得像 gradient-TD 算法，在目标策略与行为策略相同的状态上表现得像半梯度算法。最后，gradient-TD 思想还与近端方法（proximal methods）与控制变量（control variates）的思想结合起来，产生了更高效的方法（Mahadevan 等，2014；Du 等，2017）。
