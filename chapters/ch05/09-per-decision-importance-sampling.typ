#import "../../template.typ": *

== #sym.ast.basic 逐决策重要性采样 <sec-5-9>

把回报看作奖励之和的这种结构，还可以用另一种方式纳入 off-policy 重要性采样，这种方式即使在没有折扣时（也就是即使 $gamma = 1$）也可能降低方差。在 off-policy 估计量 @eq-5-5 与 @eq-5-6 中，分子里求和式的每一项本身又是一个和：

$ rho_(t:T-1) G_t &= rho_(t:T-1) (R_(t+1) + gamma R_(t+2) + dots.c + gamma^(T-t-1) R_T) \
                  &= rho_(t:T-1) R_(t+1) + gamma rho_(t:T-1) R_(t+2) + dots.c + gamma^(T-t-1) rho_(t:T-1) R_T. $ <eq-5-11>

off-policy 估计量依赖这些项的期望值，而期望值可以写成更简单的形式。注意 @eq-5-11 的每个子项都是随机奖励与随机重要性采样率的乘积。例如，用 @eq-5-3，第一个子项可以写成

$ rho_(t:T-1) R_(t+1) = frac(pi (A_t|S_t), b(A_t|S_t)) frac(pi (A_(t+1)|S_(t+1)), b(A_(t+1)|S_(t+1))) frac(pi (A_(t+2)|S_(t+2)), b(A_(t+2)|S_(t+2))) dots.c frac(pi (A_(T-1)|S_(T-1)), b(A_(T-1)|S_(T-1))) R_(t+1). $ <eq-5-12>

在这些因子中，你可能会猜想只有第一个与最后一个（奖励）是相关的；其他所有因子对应的都是奖励发生之后的事件。此外，其他所有这些因子的期望值都是 1：

$ bb(E)[frac(pi (A_k|S_k), b(A_k|S_k))] ≐ sum_a b(a|S_k) frac(pi (a|S_k), b(a|S_k)) = sum_a pi (a|S_k) = 1. $ <eq-5-13>

再多走几步就可以证明，正如猜想的那样，其他所有这些因子在期望意义下都没有影响，换句话说，

$ bb(E)[rho_(t:T-1) R_(t+1)] = bb(E)[rho_(t:t) R_(t+1)]. $ <eq-5-14>

如果我们对 @eq-5-11 的第 $k$ 个子项重复这一过程，就得到

#{
  set math.equation(numbering: none)
  $ bb(E)[rho_(t:T-1) R_(t+k)] = bb(E)[rho_(t:t+k-1) R_(t+k)]. $
}

于是，原来的项 @eq-5-11 的期望可以写成

#{
  set math.equation(numbering: none)
  $ bb(E)[rho_(t:T-1) G_t] = bb(E)[tilde(G)_t], $
}

其中

#{
  set math.equation(numbering: none)
  $ tilde(G)_t = rho_(t:t) R_(t+1) + gamma rho_(t:t+1) R_(t+2) + gamma^2 rho_(t:t+2) R_(t+3) + dots.c + gamma^(T-t-1) rho_(t:T-1) R_T. $
}

我们把这个想法称为#ezh[逐决策]重要性采样。

紧接着就有一个替代的重要性采样估计量，它在（首次访问情形下）与普通重要性采样估计量 @eq-5-5 有相同的无偏期望，它使用 $tilde(G)_t$：

$ V(s) ≐ frac(sum_(t in cal(T)(s)) tilde(G)_t, |cal(T)(s)|), $ <eq-5-15>

我们或许可以期望它有时方差更低。

对于#ezh[加权]重要性采样，有没有逐决策版本呢？这一点还不太清楚。就我们所知，目前为止提出的所有这类估计量都不是一致的（也就是说，它们不会随数据无限增多而收敛到真实值）。

#exercise("5.13", star: true)[展示从 @eq-5-12 推导 @eq-5-14 的步骤。]

#exercise("5.14", star: true)[修改 off-policy 蒙特卡洛控制的算法（原书第 111 页），改用截断加权平均估计量 @eq-5-10 的想法。注意，你首先需要把这个方程改写成关于动作值的形式。]
