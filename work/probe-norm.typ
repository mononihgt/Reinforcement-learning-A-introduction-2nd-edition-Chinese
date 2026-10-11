#set page(width: 16cm, height: auto, margin: 1cm)
#set text(size: 10.5pt, lang: "zh", region: "cn")
#set math.equation(numbering: "(1.1)")

甲、正文里单独写：

$ norm(v_bold(w) - v_pi)_mu^2 $

乙、放进与符号表相同的 grid：

#grid(
  columns: (auto, 1fr),
  column-gutter: 1.8em,
  row-gutter: 0.42em,
  align: (left + horizon, left + horizon),
  $overline("VE")(bold(w))$, [均方值误差 $overline("VE")(bold(w)) ≐ norm(v_bold(w) - v_pi)_mu^2$（第 9.2 节）],
  $overline("BE")(bold(w))$, [均方贝尔曼误差 $overline("BE")(bold(w)) ≐ norm(overline(delta)_bold(w))_mu^2$],
  $overline("TDE")(bold(w))$, [均方时序差分误差 $overline("TDE")(bold(w)) ≐ bb(E)_b [rho_t delta_t^2]$（第 11.5 节）],
)

丙、逐项拆开看：

范数本体：$ norm(v) $

带下标：$ norm(v)_mu $

带上标：$ norm(v)^2 $

下标与上标同给：$ norm(v)_mu^2 $
