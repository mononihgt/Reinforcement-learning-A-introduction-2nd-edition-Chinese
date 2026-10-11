#set page(width: 470pt, height: auto, margin: 12pt)
#set text(size: 10pt)

= (unnumbered p48-1) PDF p.48

$ q_* (a) ≐ bb(E)[R_t | A_t = a] . $

= (2.1) PDF p.49

$ Q_t (a) ≐ frac("sum of rewards when " a " taken prior to " t, "number of times " a " taken prior to " t) = frac(sum_(i=1)^(t-1) R_i dot bb(1)_(A_i = a), sum_(i=1)^(t-1) bb(1)_(A_i = a)), $

= (2.2) PDF p.49

$ A_t ≐ op("argmax", limits: #true)_a Q_t (a), $

= (unnumbered p53-1) PDF p.53

$ Q_n ≐ frac(R_1 + R_2 + dots.c + R_(n-1), n - 1) . $

= (2.3) PDF p.53

$ Q_(n+1) &= 1/n sum_(i=1)^n R_i \
          &= 1/n (R_n + sum_(i=1)^(n-1) R_i) \
          &= 1/n (R_n + (n-1) frac(1, n-1) sum_(i=1)^(n-1) R_i) \
          &= 1/n (R_n + (n-1) Q_n) \
          &= 1/n (R_n + n Q_n - Q_n) \
          &= Q_n + 1/n [R_n - Q_n], $

= (2.4) PDF p.53

$ italic("NewEstimate") arrow.l italic("OldEstimate") + italic("StepSize") [italic("Target") - italic("OldEstimate")] . $

= (2.5) PDF p.54

$ Q_(n+1) ≐ Q_n + alpha [R_n - Q_n], $

= (2.6) PDF p.54

$ Q_(n+1) &= Q_n + alpha [R_n - Q_n] \
          &= alpha R_n + (1 - alpha) Q_n \
          &= alpha R_n + (1 - alpha) [alpha R_(n-1) + (1 - alpha) Q_(n-1)] \
          &= alpha R_n + (1 - alpha) alpha R_(n-1) + (1 - alpha)^2 Q_(n-1) \
          &= alpha R_n + (1 - alpha) alpha R_(n-1) + (1 - alpha)^2 alpha R_(n-2) + \
           &quad dots.c + (1 - alpha)^(n-1) alpha R_1 + (1 - alpha)^n Q_1 \
          &= (1 - alpha)^n Q_1 + sum_(i=1)^n alpha (1 - alpha)^(n-i) R_i. $

= (2.7) PDF p.55

$ sum_(n=1)^infinity alpha_n (a) = infinity quad "and" quad sum_(n=1)^infinity alpha_n^2 (a) < infinity. $

= (2.8) PDF p.57

$ beta_n ≐ alpha slash overline(o)_n, $

= (2.9) PDF p.57

$ overline(o)_n ≐ overline(o)_(n-1) + alpha (1 - overline(o)_(n-1)), quad "for " n > 0, quad "with " overline(o)_0 ≐ 0. $

= (2.10) PDF p.57

$ A_t ≐ op("argmax", limits: #true)_a [Q_t (a) + c sqrt(frac(ln t, N_t (a)))], $

= (2.11) PDF p.59

$ "Pr"{A_t = a} ≐ frac(e^(H_t (a)), sum_(b=1)^k e^(H_t (b))) ≐ pi_t (a), $

= (2.12) PDF p.59

$ H_(t+1)(A_t) ≐ H_t (A_t) + alpha (R_t - overline(R)_t)(1 - pi_t (A_t)), &quad "and" \
  H_(t+1)(a) ≐ H_t (a) - alpha (R_t - overline(R)_t) pi_t (a), &quad "for all " a != A_t, $

= (2.13) PDF p.60

$ H_(t+1)(a) ≐ H_t (a) + alpha frac(partial bb(E)[R_t], partial H_t (a)), $

= (unnumbered p60-1) PDF p.60

$ bb(E)[R_t] = sum_x pi_t (x) q_* (x), $

= (unnumbered p61-1) PDF p.61

$ frac(partial bb(E)[R_t], partial H_t (a)) &= frac(partial, partial H_t (a)) [sum_x pi_t (x) q_* (x)] \
  &= sum_x q_* (x) frac(partial pi_t (x), partial H_t (a)) \
  &= sum_x (q_* (x) - B_t) frac(partial pi_t (x), partial H_t (a)), $

= (unnumbered p61-2) PDF p.61

$ frac(partial bb(E)[R_t], partial H_t (a)) = sum_x pi_t (x)(q_* (x) - B_t) frac(partial pi_t (x), partial H_t (a)) slash pi_t (x). $

= (unnumbered p61-3) PDF p.61

$ = bb(E)[(q_* (A_t) - B_t) frac(partial pi_t (A_t), partial H_t (a)) slash pi_t (A_t)] \
  = bb(E)[(R_t - overline(R)_t) frac(partial pi_t (A_t), partial H_t (a)) slash pi_t (A_t)], $

= (unnumbered p61-4) PDF p.61

$ = bb(E)[(R_t - overline(R)_t) pi_t (A_t)(bb(1)_(a=A_t) - pi_t (a)) slash pi_t (A_t)] \
  = bb(E)[(R_t - overline(R)_t)(bb(1)_(a=A_t) - pi_t (a))]. $

= (unnumbered p61-5) PDF p.61

$ H_(t+1)(a) = H_t (a) + alpha (R_t - overline(R)_t)(bb(1)_(a=A_t) - pi_t (a)), quad "for all " a, $

= (unnumbered p62-1) PDF p.62

$ frac(partial, partial x) [frac(f(x), g(x))] = frac(frac(partial f(x), partial x) g(x) - f(x) frac(partial g(x), partial x), g(x)^2). $

= (unnumbered p62-2) PDF p.62

$ frac(partial pi_t (x), partial H_t (a)) &= frac(partial, partial H_t (a)) pi_t (x) \
  &= frac(partial, partial H_t (a)) [frac(e^(H_t (x)), sum_(y=1)^k e^(H_t (y)))] \
  &= frac(frac(partial e^(H_t (x)), partial H_t (a)) sum_(y=1)^k e^(H_t (y)) - e^(H_t (x)) frac(partial sum_(y=1)^k e^(H_t (y)), partial H_t (a)), (sum_(y=1)^k e^(H_t (y)))^2) &quad "(by the quotient rule)" \
  &= frac(bb(1)_(a=x) e^(H_t (x)) sum_(y=1)^k e^(H_t (y)) - e^(H_t (x)) e^(H_t (a)), (sum_(y=1)^k e^(H_t (y)))^2) &quad "(because " frac(partial e^x, partial x) = e^x ")" \
  &= frac(bb(1)_(a=x) e^(H_t (x)), sum_(y=1)^k e^(H_t (y))) - frac(e^(H_t (x)) e^(H_t (a)), (sum_(y=1)^k e^(H_t (y)))^2) \
  &= bb(1)_(a=x) pi_t (x) - pi_t (x) pi_t (a) \
  &= pi_t (x)(bb(1)_(a=x) - pi_t (a)). quad "Q.E.D." $
