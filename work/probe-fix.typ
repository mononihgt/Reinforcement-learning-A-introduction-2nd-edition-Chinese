#import "../template.typ": *

#show: book

#plain-chapter("探针", en: "Probe")

甲、原样，row-gutter 0.42em（复现重叠）：

#grid(
  columns: (auto, 1fr),
  column-gutter: 1.8em,
  row-gutter: 0.42em,
  $norm(v_w - v_pi)_mu^2$, [均方值误差 $norm(v_w - v_pi)_mu^2$ 结束],
  $norm(overline(delta)_bold(w))_mu^2$, [均方贝尔曼误差 $norm(overline(delta)_bold(w))_mu^2$ 结束],
)

乙、row-gutter 加到 0.9em：

#grid(
  columns: (auto, 1fr),
  column-gutter: 1.8em,
  row-gutter: 0.9em,
  $norm(v_w - v_pi)_mu^2$, [均方值误差 $norm(v_w - v_pi)_mu^2$ 结束],
  $norm(overline(delta)_bold(w))_mu^2$, [均方贝尔曼误差 $norm(overline(delta)_bold(w))_mu^2$ 结束],
)

丙、单元格内放开行距：

#grid(
  columns: (auto, 1fr),
  column-gutter: 1.8em,
  row-gutter: 0.42em,
  $norm(v_w - v_pi)_mu^2$, [#set par(leading: 1.6em); 均方值误差 $norm(v_w - v_pi)_mu^2$ 结束],
  $norm(overline(delta)_bold(w))_mu^2$, [#set par(leading: 1.6em); 均方贝尔曼误差 $norm(overline(delta)_bold(w))_mu^2$ 结束],
)
