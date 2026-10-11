#set page(width: 16cm, height: auto, margin: 1cm)
#set text(size: 10.5pt, lang: "zh", region: "cn")

甲、align 带 horizon（当前符号表的写法）：

#grid(
  columns: (auto, 1fr),
  column-gutter: 1.8em,
  row-gutter: 0.42em,
  align: (left + horizon, left + horizon),
  $overline("VE")(bold(w))$, [均方值误差 $norm(v_bold(w) - v_pi)_mu^2$],
  $overline("BE")(bold(w))$, [均方贝尔曼误差 $norm(overline(delta)_bold(w))_mu^2$],
  $overline("TDE")(bold(w))$, [均方时序差分误差 $bb(E)_b[rho_t delta_t^2]$],
)

乙、align 只用 left：

#grid(
  columns: (auto, 1fr),
  column-gutter: 1.8em,
  row-gutter: 0.42em,
  align: (left, left),
  $overline("VE")(bold(w))$, [均方值误差 $norm(v_bold(w) - v_pi)_mu^2$],
  $overline("BE")(bold(w))$, [均方贝尔曼误差 $norm(overline(delta)_bold(w))_mu^2$],
  $overline("TDE")(bold(w))$, [均方时序差分误差 $bb(E)_b[rho_t delta_t^2]$],
)
