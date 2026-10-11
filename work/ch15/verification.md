# 第 15 章《神经科学》校对报告

- 校对对象：`chapters/ch15.typ` 与 `chapters/ch15/` 下 14 个小节文件。
- 比对基准：`work/ch15/source.md` 全文；源页面渲染图 `work/pages/p399.png` 至 `work/pages/p442.png`（原书第 377–420 页）。
- 规范：`glossary/TERMINOLOGY.md`、`glossary/terms.yml`。
- 编译与检查：`typst compile --root . preview/ch15.typ work/out.pdf` 退出码 0，全章 28 页；`uv run tools/assemble.py check-terms` 与 `check-coverage` 均无报告；`figure-widths --chapter 15` 给出的六个宽度（63%／66%／47%／68%／100%／46%）与译文所用值一致。

## 缺陷

未发现缺陷。

## 存疑（2 条）

以下两条判不准，未作改动。

1. **p421 展示方程组第 5 行 δ_t 与普通 δ 的差异**（PDF 421／书 399；`chapters/ch15/08-actor-and-critic-learning-rules.typ` 第 14–16 行）
   - 源页面渲染图（900 dpi 裁切）显示第 4 行为 `w ← w + α^w δ_t z_t^w`（δ 带下标 t），第 5 行为 `θ ← θ + α^θ δ z_t^θ`（δ 无下标）；而 p422 行内对应句 "The weights of each actor unit are incremented, as above, by: θ ← θ + α^θ δ_t z_t^θ" 中 δ 带下标 t。
   - 译文五行统一写作 δ_t（`$bold(theta) arrow.l bold(theta) + alpha^bold(theta) delta_t bold(z)_t^bold(theta)$`）。
   - 判不准的理由：原书自身在同一公式块内 δ 与 δ_t 混用（p421 第 5 行对第 4 行不一致），且全章正文把 δ 与 δ_t 作为同一个量的两种写法（如「TD 误差 δ」与 δ_t 交替出现）。译文按本意统一与 TERMINOLOGY.md「原书笔误按本意翻译、不加译注」一致；但也可逐字保留普通 δ 以与源页面完全对应。是否需要在阶段四改回，规范没有规定，故列入存疑。
   - **裁定**：维持现状。δ 与 δ_t 在原书全章本就是同一个量的两种写法，统一写作 δ_t 符合「原书笔误按本意翻译」的处理方式。

2. **PDF 436（书 414）文献评注 15.4 中人名 Wightmman 被归一为 Wightman**（`chapters/ch15/14-bibliographical-and-historical-remarks.typ` 第 34 行）
   - 900 dpi 裁切确认原书印作 "Saddoris, Cacciapaglia, Wightmman, and Carelli (2015)"（双 m）；正确的拼写是 Wightman（该文献为 Saddoris 等 2015 年发表于 Nature Neuroscience 的论文，作者为 R. M. Wightman）。
   - 译文写作「Saddoris、Cacciapaglia、Wightman 与 Carelli（2015）」。
   - 判不准的理由：按 TERMINOLOGY.md「原书笔误」一节，按本意翻译且不加译注是允许的；但与本报告同类的第 1 章校对报告（Weiring → Wiering 案）把这种静默更正列为存疑，译本读者无从知道与原书字面不同，文献评注位置是否应保留原书拼写，规范没有规定，故列入存疑。
   - **裁定**：维持现状。正常人名拼写按本意写出，与第 1 章 Weiring → Wiering 案的处理保持全书一致。
