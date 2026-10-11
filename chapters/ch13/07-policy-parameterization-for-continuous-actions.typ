#import "../../template.typ": *

== 连续动作的策略参数化 <sec-13-7>

基于策略的方法为处理大型动作空间提供了实用的途径，甚至可以处理具有无穷多个动作的连续空间。我们不再为众多动作中的每一个计算学到的概率，而是学习概率分布的统计量。例如，动作集合可以是实数，动作从正态（高斯）分布中选取。

正态分布的概率密度函数通常写成

$ p(x) ≐ frac(1, sigma sqrt(2 pi)) exp( - frac((x - mu)^2, 2 sigma^2) ), $ <eq-13-18>

其中 $mu$ 与 $sigma$ 分别是正态分布的均值与标准差，当然这里的 $pi$ 只是数 $pi ≈ 3.14159$。几个不同均值与标准差对应的概率密度函数如右图所示。值 $p(x)$ 是 $x$ 处概率的#ezh[密度]，而不是概率。它可以大于 1；必须求和为 1 的是 $p(x)$ 下方的总面积。一般来说，对任意范围的 $x$ 取值，取 $p(x)$ 下方的积分，就得到 $x$ 落在这个范围内的概率。

#align(center, image("../../assets/figures/ch13/fig-13-inline-2.png", width: 55%))

为了得到一个策略参数化，可以把策略定义为实值标量动作上的正态概率密度，其均值与标准差由依赖状态的参数化函数近似器给出。也就是说，

$ pi (a|s, bold(theta)) ≐ frac(1, sigma(s, bold(theta)) sqrt(2 pi)) exp( - frac((a - mu(s, bold(theta)))^2, 2 sigma(s, bold(theta))^2) ), $ <eq-13-19>

其中 $mu : cal(S) × bb(R)^(d') -> bb(R)$ 与 $sigma : cal(S) × bb(R)^(d') -> bb(R)^+$ 是两个参数化的函数近似器。

为了完成这个例子，我们只需给这些近似器指定一种形式。为此我们把策略的参数向量分成两部分，$bold(theta) = [bold(theta)_mu, bold(theta)_sigma]^top$，一部分用于均值的近似，另一部分用于标准差的近似。均值可以近似为线性函数。标准差必须始终为正，最好近似为线性函数的指数。因此

$ mu(s, bold(theta)) ≐ bold(theta)_mu^top bold(x)_mu (s) quad "and" quad sigma(s, bold(theta)) ≐ exp( bold(theta)_sigma^top bold(x)_sigma (s) ), $ <eq-13-20>

其中 $bold(x)_mu (s)$ 与 $bold(x)_sigma (s)$ 是状态特征向量，或许可以用第 9.5 节介绍的某种方法构造。有了这些定义，本章余下部分介绍的全部算法都可以用来学习选择实值动作。

#exercise("13.4")[证明：对于高斯策略参数化（公式 @eq-13-19 与 @eq-13-20），资格向量有以下两部分：

#{
  set math.equation(numbering: none)
  $ nabla ln pi (a|s, bold(theta)_mu) = frac(nabla pi (a|s, bold(theta)_mu), pi (a|s, bold(theta))) = frac(1, sigma(s, bold(theta))^2) (a - mu(s, bold(theta))) bold(x)_mu (s), $

  $ nabla ln pi (a|s, bold(theta)_sigma) = frac(nabla pi (a|s, bold(theta)_sigma), pi (a|s, bold(theta))) = ( frac((a - mu(s, bold(theta)))^2, sigma(s, bold(theta))^2) - 1 ) bold(x)_sigma (s). $
}
]

#exercise("13.5")[#ezh[伯努利–logistic 单元]（Bernoulli-logistic unit）是某些 ANN 中使用的一种随机神经元式的单元（第 9.7 节）。它在时刻 $t$ 的输入是特征向量 $bold(x)(S_t)$；它的输出 $A_t$ 是取 0 与 1 两个值的随机变量，其中 $Pr {A_t = 1} = P_t$、$Pr {A_t = 0} = 1 - P_t$（伯努利分布）。设 $h(s, 0, bold(theta))$ 与 $h(s, 1, bold(theta))$ 是给定策略参数 $bold(theta)$ 时该单元的两个动作在状态 $s$ 中的偏好。假定动作偏好之差由该单元输入向量的加权和给出，也就是说，假定 $h(s, 1, bold(theta)) - h(s, 0, bold(theta)) = bold(theta)^top bold(x)(s)$，其中 $bold(theta)$ 是该单元的权重向量。

(a) 证明：如果用指数 soft-max 分布 @eq-13-2 把动作偏好转换为策略，那么 $P_t = pi (1|S_t, bold(theta)_t) = 1 slash (1 + exp( - bold(theta)_t^top bold(x)(S_t) ))$（logistic 函数）。

(b) 在收到回报 $G_t$ 时，把 $bold(theta)_t$ 更新为 $bold(theta)_(t+1)$ 的蒙特卡洛 REINFORCE 更新是什么？

(c) 通过计算梯度，用 $a$、$bold(x)(s)$ 与 $pi (a|s, bold(theta))$ 表示伯努利–logistic 单元的资格 $nabla ln pi (a|s, bold(theta))$。

(c) 部分的提示：定义 $P = pi (1|s, bold(theta))$，对 $P$ 使用链式法则，计算两个动作各自的对数导数。把两个结果合并成一个依赖 $a$ 与 $P$ 的表达式，然后再对 $bold(theta)^top bold(x)(s)$ 使用一次链式法则，注意 logistic 函数 $f(x) = 1 slash (1 + e^(-x))$ 的导数是 $f(x)(1 - f(x))$。]
