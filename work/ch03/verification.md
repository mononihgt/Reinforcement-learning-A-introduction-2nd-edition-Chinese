# 第 3 章 有限马尔可夫决策过程 校对报告

比对材料：

- 英文原文 `work/ch03/source.md`（PDF 69 至 94 页，对应原书 47 至 72 页）与页面渲染图 `work/pages/p0069.png` 至 `p0094.png`。
- 中文产出 `chapters/ch03.typ` 与 `chapters/ch03/` 下的 9 个小节文件。
- 规范 `glossary/TERMINOLOGY.md` 与 `glossary/terms.yml`。

## 缺陷

未发现缺陷。

## 存疑（2 条）

**存疑 1：例 3.6 正文中 putter、driver 的排印**（`chapters/ch03/05-policies-and-value-functions.typ` 第 74 行，PDF 83，原书 61 页）

- 英文把球杆名排成打字机字体："…which we assume is either a `putter` or a `driver`."
- 译文作「假设可选的球杆要么是推杆（putter），要么是木杆（driver）」，普通字体。

判不准的理由：规范只规定图内文字保留英文，没有规定正文里被原书排成打字机字体的普通名词应该如何处理。译文的「中文（英文）」写法符合首现附英文的约定，公式里也已经用了打字机字体（$v_"putt" (s)$、$q_* (s, "driver")$），例 3.3 的动作名却用了 `#raw`。正文是否也要求写成 `#raw("putter")`，无法从规范判定，故未计入缺陷。

- **裁定**：维持现状。原书用打字机字体标记这两个词是字面记号，中文用「中文（英文）」形式表达更清楚，不必强求字体一致。

**存疑 2：文献与历史评注里「赋予价值」的用词**（`chapters/ch03/09-bibliographical-and-historical-remarks.typ` 第 44 行，PDF 93，原书 71 页）

- 英文："Assigning value on the basis of what is good or bad in the long run has ancient roots."
- 译文：「根据长期来看何为好、何为坏来赋予价值，这种做法有着古老的根源。」

判不准的理由：规范第 31 行规定 value → 值，第 10 行又把「价值」列进通用词例子，第 212 行的术语「general value function 一般价值函数」也含「价值」。本处的 value 是日常语义（赋值、看重），译作「赋予值」不符合中文习惯。这处是否属于规范约束范围无法判定，故未计入缺陷。

- **裁定**：维持现状。术语表的 value → 值 约束的是强化学习的技术术语，本处是日常语义，不受约束。
