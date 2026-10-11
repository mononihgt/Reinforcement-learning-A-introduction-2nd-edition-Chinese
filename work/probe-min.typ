#set page(width: 16cm, height: auto, margin: 1cm)
#set text(size: 10.5pt, lang: "zh", region: "cn")

甲、纯段落：

均方值误差 $norm(v_w - v_pi)_mu^2$ 结束

乙、两列 grid：

#grid(
  columns: (auto, 1fr),
  column-gutter: 1.8em,
  $norm(v_w - v_pi)_mu^2$, [均方值误差 $norm(v_w - v_pi)_mu^2$ 结束],
)

丙、单列 grid：

#grid(
  columns: 1fr,
  [均方值误差 $norm(v_w - v_pi)_mu^2$ 结束],
)
