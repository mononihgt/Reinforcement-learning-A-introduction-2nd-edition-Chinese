# 第 13 章校对报告：策略梯度方法

- 校对对象：`chapters/ch13.typ` 与 `chapters/ch13/` 下 9 个小节文件。
- 比对基准：`work/ch13/source.md`、页面渲染 `work/pages/p343.png` 至 `work/pages/p362.png`（原书第 321–338 页）。
- 规范：`glossary/TERMINOLOGY.md`。
- 修订后编译：`typst compile --root . preview/ch13.typ work/out.pdf` 退出码 0，全章 13 页；`uv run tools/assemble.py check-terms` 与 `check-coverage` 均无第 13 章报告。

## 缺陷

未发现缺陷。

## 存疑（2 条）

以下两条判不准，修订阶段保持原文未动。

1. **推导框内直接写编号「(13.16)」**（PDF 356；`chapters/ch13/06-policy-gradient-for-continuing-problems.typ` 第 74 行）

- 规范：`glossary/TERMINOLOGY.md` 第 344 行「公式引用一律用 `@eq-`，不要在正文里裸写编号……`check-terms` 会扫描含中文的行并报出裸编号」（CHAPTER-GUIDE 第 204 行同款说明）。
- 实际：译文在 `underbrace(..., mu(s') quad (13.16))` 中把编号写成字面文本，渲染为「μ(s′) (13.16)」，与原书 p334 的排法相同；`check-terms` 未报告。
- 判不准的理由：这条规则针对正文，此处在数学展示内部，且两个推导框的右端注解（`Exercise 3.18`、`Eq. 9.3`、`box page 199` 等）本来就照录原书的英文边注。已实测 `@eq-` 在数学内部不解析（会渲染成「@eq-t-1」字面记号），改编号需要改用别的写法才能渲染成原样，是否值得改动无法判定，故未改动。

2. **「值（value）」是否也需要首现附英文**（`chapters/ch13/01-...typ` 第 3 行「它们学习动作（action）的值」）

- 规范：术语表第 31 行「value | 值 | 首现附英文」。
- 实际：本章「值」大量出现，译文均未附英文；同句中的「动作（action）」已附。
- 判不准的理由：第 3、6、9、10 章的既有实践同样未给独立的「值」加对照（第 10 章校对报告列的 16 个缺失词中不含「值」），给「值」逐章附英文会改动大量行文。规范文字与全项目既有实践不一致，判不准，故未改动。
