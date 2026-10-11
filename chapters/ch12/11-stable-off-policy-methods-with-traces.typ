#import "../../template.typ": *

== 带迹的稳定 off-policy 方法 <sec-12-11>

人们已经提出了若干使用资格迹的方法，它们在 off-policy 训练下能够获得稳定性保证；这里我们用本书的标准记号介绍其中最重要的四个，包括一般的自举函数与折扣函数。它们全都基于第 11.7 节与第 11.8 节给出的 gradient-TD 或者 emphatic-TD 思想。所有算法都假定线性函数近似，不过文献中也能找到向非线性函数近似的推广。

#ezh[GTD($lambda$)] 是与 TDC 对应的资格迹算法，TDC 是第 11.7 节讨论的两个状态值 gradient-TD 预测算法中较好的那个。它的目标是学到参数 $bold(w)_t$，使得 $hat(v)(s, bold(w)) ≐ bold(w)_t^top bold(x)(s) approx v_pi (s)$，即使数据来自遵循另一个策略 $b$ 的行为。它的更新式是

#{
  set math.equation(numbering: none)
  $ bold(w)_(t+1) ≐ bold(w)_t + alpha delta_t^s bold(z)_t - alpha gamma_(t+1)(1 - lambda_(t+1))(bold(z)_t^top bold(v)_t) bold(x)_(t+1), $
}

其中 $delta_t^s$、$bold(z)_t$ 与 $rho_t$ 按状态值的通常方式定义，也就是 @eq-12-23、@eq-12-25 与第 11 章的公式 11.1，此外

$ bold(v)_(t+1) ≐ bold(v)_t + beta delta_t^s bold(z)_t - beta (bold(v)_t^top bold(x)_t) bold(x)_t, $ <eq-12-30>

其中与第 11.7 节一样，$bold(v) in bb(R)^d$ 是一个与 $bold(w)$ 维度相同的向量，初始化为 $bold(v)_0 = bold(0)$，$beta > 0$ 是第二个步长参数。

#ezh[GQ($lambda$)] 是带资格迹的动作值 gradient-TD 算法。它的目标是从 off-policy 数据中学到参数 $bold(w)_t$，使得 $hat(q)(s, a, bold(w)_t) ≐ bold(w)_t^top bold(x)(s, a) approx q_pi (s, a)$。如果目标策略是 $epsilon$-greedy，或者以其他方式偏向于相对 $hat(q)$ 的贪婪策略，那么 GQ($lambda$) 就可以用作控制算法。它的更新式是

#{
  set math.equation(numbering: none)
  $ bold(w)_(t+1) ≐ bold(w)_t + alpha delta_t^a bold(z)_t - alpha gamma_(t+1)(1 - lambda_(t+1))(bold(z)_t^top bold(v)_t) overline(bold(x))_(t+1), $
}

其中 $overline(bold(x))_t$ 是 $S_t$ 在目标策略下的平均特征向量，

#{
  set math.equation(numbering: none)
  $ overline(bold(x))_t ≐ sum_a pi (a|S_t) bold(x)(S_t, a), $
}

$delta_t^a$ 是 TD 误差的期望形式，可以写成

#{
  set math.equation(numbering: none)
  $ delta_t^a ≐ R_(t+1) + gamma_(t+1) bold(w)_t^top overline(bold(x))_(t+1) - bold(w)_t^top bold(x)_t, $
}

$bold(z)_t$ 按动作值的通常方式定义 @eq-12-29，其余部分与 GTD($lambda$) 相同，包括 $bold(v)_t$ 的更新式 @eq-12-30。

#ezh[HTD($lambda$)] 是一个混合状态值算法，结合了 GTD($lambda$) 与 TD($lambda$) 的若干特点。它最吸引人的特征是：它是 TD($lambda$) 向 off-policy 学习的一个严格推广，也就是说，如果行为策略恰好与目标策略相同，那么 HTD($lambda$) 就与 TD($lambda$) 相同，而 GTD($lambda$) 没有这个性质。这一点很吸引人，因为当两个算法都收敛时，TD($lambda$) 往往比 GTD($lambda$) 更快，而且 TD($lambda$) 只需要设置一个步长。HTD($lambda$) 由下式定义

#{
  set math.equation(numbering: none)
  $ &bold(w)_(t+1) ≐ bold(w)_t + alpha delta_t^s bold(z)_t + alpha ((bold(z)_t - bold(z)_t^b)^top bold(v)_t)(bold(x)_t - gamma_(t+1) bold(x)_(t+1)), \
    &bold(v)_(t+1) ≐ bold(v)_t + beta delta_t^s bold(z)_t - beta (bold(z)_t^(b top) bold(v)_t)(bold(x)_t - gamma_(t+1) bold(x)_(t+1)), quad "with" bold(v)_0 ≐ bold(0), \
    &bold(z)_t ≐ rho_t (gamma_t lambda_t bold(z)_(t-1) + bold(x)_t), quad "with" bold(z)_(-1) ≐ bold(0), \
    &bold(z)_t^b ≐ gamma_t lambda_t bold(z)_(t-1)^b + bold(x)_t, quad "with" bold(z)_(-1)^b ≐ bold(0), $
}

其中 $beta > 0$ 同样是第二个步长参数。除了第二组权重 $bold(v)_t$ 之外，HTD($lambda$) 还有第二组资格迹 $bold(z)_t^b$。它们是行为策略的常规累积资格迹，如果所有的 $rho_t$ 都等于 1，它们就等于 $bold(z)_t$，这使 $bold(w)_t$ 更新式中的最后一项变成零，整个更新式退化为 TD($lambda$)。

#ezh[Emphatic TD($lambda$)] 是单步 Emphatic-TD 算法（第 9.11 节与第 11.8 节）向资格迹的推广。所得算法保留了很强的 off-policy 收敛保证，同时允许任意程度的自举，但代价是高方差与可能很慢的收敛。Emphatic TD($lambda$) 由下式定义

#{
  set math.equation(numbering: none)
  $ &bold(w)_(t+1) ≐ bold(w)_t + alpha delta_t bold(z)_t \
    &delta_t ≐ R_(t+1) + gamma_(t+1) bold(w)_t^top bold(x)_(t+1) - bold(w)_t^top bold(x)_t \
    &bold(z)_t ≐ rho_t (gamma_t lambda_t bold(z)_(t-1) + M_t bold(x)_t), quad "with" bold(z)_(-1) ≐ bold(0), \
    &M_t ≐ lambda_t I_t + (1 - lambda_t) F_t \
    &F_t ≐ rho_(t-1) gamma_t F_(t-1) + I_t, quad "with" F_0 ≐ i(S_0), $
}

其中 $M_t >= 0$ 是#ezh[强调]的一般形式，$F_t >= 0$ 称为#ezh[后续迹]（followon trace），$I_t >= 0$ 是#ezh[兴趣]，如第 11.8 节所述。注意 $M_t$ 与 $delta_t$ 一样，并不是一个额外的记忆变量。把它的定义代入资格迹方程，就可以把它从算法中去掉。Emphatic-TD($lambda$) 的 true online 版本的伪代码与软件可以在网上获得（Sutton，2015b）。

在 on-policy 情形中（对所有的 $t$ 都有 $rho_t = 1$），Emphatic-TD($lambda$) 与常规 TD($lambda$) 相似，但仍然有显著区别。事实上，Emphatic-TD($lambda$) 对所有依赖状态的 $lambda$ 函数都保证收敛，而 TD($lambda$) 不然：TD($lambda$) 只对所有常数 $lambda$ 保证收敛。参见 Yu 的反例（Ghiassian、Rafiee 与 Sutton，2016）。
