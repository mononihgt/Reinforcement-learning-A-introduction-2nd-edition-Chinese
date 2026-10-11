#import "../../template.typ": *

从第 5 章起，本书一直把 on-policy 与 off-policy 学习方法主要视为两种备选方式，用来处理利用与探索之间的冲突，这种冲突内在于各种形式的广义策略迭代学习。前两章处理了带函数近似的 on-policy 情形，本章则处理带函数近似的 off-policy 情形。事实证明，推广到函数近似对 off-policy 学习而言显著不同，而且比 on-policy 学习更困难。第 6 章与第 7 章发展的表格型 off-policy 方法可以顺利推广为半梯度算法，但这些算法的收敛不像在 on-policy 训练下那样稳健。本章将探讨这些收敛问题，更仔细地考察线性函数近似的理论，引入可学习性（learnability）的概念，然后讨论在 off-policy 情形下具有更强收敛保证的新算法。最终我们会得到一些有所改进的方法，但理论结果不会像 on-policy 学习那么强，实验结果也不会那么令人满意。在此过程中，我们将更深入地理解强化学习中的近似，无论是 on-policy 学习还是 off-policy 学习。

回忆一下，在 off-policy 学习中，我们要针对一个目标策略 $pi$ 学习值函数，而数据来自另一个不同的行为策略 $b$。在预测情形中，两个策略都是静态的、给定的，我们要么学习状态值 $hat(v) approx v_pi$，要么学习动作值 $hat(q) approx q_pi$。在控制情形中，学习的是动作值，并且两个策略通常在学习过程中变化：$pi$ 是关于 $hat(q)$ 的贪婪策略，$b$ 则更具探索性，例如关于 $hat(q)$ 的 ε-greedy 策略。

off-policy 学习所面临的挑战可以分为两部分，一部分出现在表格型情形中，另一部分只在有函数近似时才出现。挑战的第一部分与更新的目标有关（不要与目标策略混淆），第二部分与更新的分布有关。第 5 章与第 7 章发展的与重要性采样有关的技术处理第一部分；这些技术可能增大方差，但对所有成功的算法来说都是必需的，无论是表格型的还是近似的。这些技术向函数近似的推广将在本章第一节中很快交代完毕。

对于带函数近似的 off-policy 学习挑战的第二部分，还需要别的东西，因为在 off-policy 情形中更新的分布并不服从 on-policy 分布。on-policy 分布对半梯度方法的稳定性很重要。为了处理这个问题，人们已经探索了两类一般的方法。一类是再次使用重要性采样方法，这一次是把更新分布扭回 on-policy 分布，从而使半梯度方法（在线性情形下）保证收敛。另一类是发展不依赖任何特定分布来获得稳定性的真正的梯度方法。我们将介绍基于这两类方法的各种算法。这是一个前沿研究领域，其中哪一类方法在实践中最为有效还不清楚。

== 半梯度方法 <sec-11-1>

我们先描述前面各章为 off-policy 情形发展的方法如何顺利推广到函数近似，成为半梯度方法。这些方法处理 off-policy 学习挑战的第一部分（改变更新目标），但不处理第二部分（改变更新分布）。因此，这些方法在某些情形中可能发散，从这个意义上说并不健全，但它们仍然经常被成功使用。要记住，这些方法在表格型情形下有保证稳定、渐近无偏，而表格型情形对应函数近似的一个特例。因此，也许仍然有可能把它们与特征选择方法结合起来，使整个组合系统可以保证稳定。无论如何，这些方法简单，因此是一个很好的起点。

第 7 章描述了各种表格型 off-policy 算法。要把它们转换成半梯度形式，只需把对数组（$V$ 或 $Q$）的更新替换成对权重向量（$bold(w)$）的更新，使用近似值函数（$hat(v)$ 或 $hat(q)$）及其梯度。这些算法中有许多使用每步的重要性采样率：

$ rho_t ≐ rho_(t:t) = frac(pi (A_t|S_t), b(A_t|S_t)). $ <eq-11-1>

例如，单步状态值算法是半梯度 off-policy TD(0)，它和对应的 on-policy 算法（原书第 203 页）完全一样，只是加上了 $rho_t$：

$ bold(w)_(t+1) ≐ bold(w)_t + alpha rho_t delta_t nabla hat(v)(S_t, bold(w)_t), $ <eq-11-2>

其中 $delta_t$ 的定义取决于问题是回合制且带折扣的，还是使用平均奖励的持续型且无折扣的：

$ delta_t ≐ R_(t+1) + gamma hat(v)(S_(t+1), bold(w)_t) - hat(v)(S_t, bold(w)_t), quad "or" $ <eq-11-3>

$ delta_t ≐ R_(t+1) - overline(R)_t + hat(v)(S_(t+1), bold(w)_t) - hat(v)(S_t, bold(w)_t). $ <eq-11-4>

对动作值而言，单步算法是半梯度 Expected Sarsa：

$ bold(w)_(t+1) ≐ bold(w)_t + alpha delta_t nabla hat(q)(S_t, A_t, bold(w)_t), quad "with" $ <eq-11-5>

#{
  set math.equation(numbering: none)
  $ delta_t ≐ R_(t+1) + gamma sum_a pi (a|S_(t+1)) hat(q)(S_(t+1), a, bold(w)_t) - hat(q)(S_t, A_t, bold(w)_t), quad "or" quad "(episodic)" $
}

#{
  set math.equation(numbering: none)
  $ delta_t ≐ R_(t+1) - overline(R)_t + sum_a pi (a|S_(t+1)) hat(q)(S_(t+1), a, bold(w)_t) - hat(q)(S_t, A_t, bold(w)_t). quad "(continuing)" $
}

注意，这个算法不使用重要性采样。在表格型情形中，这样做显然是合适的，因为唯一的样本动作是 $A_t$，学习它的值时我们不必考虑任何其他动作。带函数近似时这一点就不那么清楚了，因为当不同的状态–动作对都对同一个总体近似有所贡献时，我们可能想对它们区别加权。要妥善解决这个问题，有待对强化学习中函数近似理论更透彻的理解。

在这些算法的多步推广中，状态值算法与动作值算法都涉及重要性采样。半梯度 Sarsa 的 $n$ 步版本是

$ bold(w)_(t+n) ≐ bold(w)_(t+n-1) + alpha rho_(t+1) dots.c rho_(t+n) [G_(t:t+n) - hat(q)(S_t, A_t, bold(w)_(t+n-1))] nabla hat(q)(S_t, A_t, bold(w)_(t+n-1)) $ <eq-11-6>

#{
  set math.equation(numbering: none)
  $ G_(t:t+n) ≐ R_(t+1) + dots.c + gamma^(n-1) R_(t+n) + gamma^n hat(q)(S_(t+n), A_(t+n), bold(w)_(t+n-1)), quad "or" quad "(episodic)" $
}

#{
  set math.equation(numbering: none)
  $ G_(t:t+n) ≐ R_(t+1) - overline(R)_t + dots.c + R_(t+n) - overline(R)_(t+n-1) + hat(q)(S_(t+n), A_(t+n), bold(w)_(t+n-1)), quad "(continuing)" $
}

这里我们对回合末端的处理略微不严格。在第一式中，对 $k >= T$（其中 $T$ 是回合的最后一个时间步）的 $rho_k$ 应取为 1，而如果 $t + n >= T$，则 $G_(t:t+n)$ 应取为 $G_t$。

回忆一下，第 7 章还给出了一个完全不涉及重要性采样的 off-policy 算法：$n$ 步 tree-backup 算法。它的半梯度版本是

$ bold(w)_(t+n) ≐ bold(w)_(t+n-1) + alpha [G_(t:t+n) - hat(q)(S_t, A_t, bold(w)_(t+n-1))] nabla hat(q)(S_t, A_t, bold(w)_(t+n-1)), $ <eq-11-7>

$ G_(t:t+n) ≐ hat(q)(S_t, A_t, bold(w)_(t+n-1)) + sum_(k=t)^(t+n-1) delta_k product_(i=t+1)^k gamma pi (A_i|S_i), $ <eq-11-8>

其中 $delta_t$ 与前面为 Expected Sarsa 给出的定义相同。第 7 章还定义了一个统一全部动作值算法的算法：$n$ 步 $Q(sigma)$。我们把这个算法的半梯度形式，以及 $n$ 步状态值算法的半梯度形式，都留给读者作为练习。

#exercise("11.1")[把 $n$ 步 off-policy TD 的等式（第 7 章的公式 7.9）转换成半梯度形式。给出回合制与持续型两种情形下配套的回报定义。]

#exercise("11.2", star: true)[把 $n$ 步 $Q(sigma)$ 的等式（第 7 章的公式 7.11 与 7.17）转换成半梯度形式。给出同时覆盖回合制与持续型两种情形的定义。]
