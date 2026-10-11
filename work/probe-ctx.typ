#import "../template.typ": *

#show: book

#plain-chapter("探针", en: "Probe")

甲、book 上下文里的纯段落：

均方值误差 $norm(v_w - v_pi)_mu^2$ 结束

乙、book 上下文里的 grid：

#grid(
  columns: (auto, 1fr),
  column-gutter: 1.8em,
  row-gutter: 0.42em,
  align: (left, left),
  $norm(v_w - v_pi)_mu^2$, [均方值误差 $norm(v_w - v_pi)_mu^2$ 结束],
  $norm(overline(delta)_bold(w))_mu^2$, [均方贝尔曼误差 $norm(overline(delta)_bold(w))_mu^2$ 结束],
)

丙、照抄符号表那一行的完整内容：

#grid(
  columns: (auto, 1fr),
  column-gutter: 1.8em,
  row-gutter: 0.42em,
  align: (left, left),
  $overline("VE")(bold(w))$, [均方值误差 $overline("VE")(bold(w)) ≐ norm(v_bold(w) - v_pi)_mu^2$（第 9.2 节）],
  $overline("BE")(bold(w))$, [均方贝尔曼误差 $overline("BE")(bold(w)) ≐ norm(overline(delta)_bold(w))_mu^2$],
)
