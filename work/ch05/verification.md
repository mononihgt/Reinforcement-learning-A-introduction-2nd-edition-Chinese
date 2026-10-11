# 第 5 章《蒙特卡洛方法》校对报告（阶段三）

比对对象：

- 英文原文：`work/ch05/source.md`；页面渲染图 `work/pages/p0113.png`–`p0140.png`（原书第 91–118 页）。
- 中文译文：`chapters/ch05.typ` 与 `chapters/ch05/01-monte-carlo-prediction.typ` … `11-bibliographical-and-historical-remarks.typ`。
- 规范：`glossary/TERMINOLOGY.md`（含模板与引用规范）。
- 编译基线：`typst compile --root . preview/ch05.typ` 退出码 0，全章 20 页；`uv run tools/assemble.py check-terms` 对本章无任何报告。

## 缺陷清单

未发现缺陷。

## 存疑

1. 方框位置指代依赖最终版面。5.3、5.6、5.7 节的「下一页的方框」与 5.4 节的「下面方框」按原书英文措辞翻译（on the next page / the box below）。单章预览当前版面上，5.3 节的引语与方框同页相邻、5.4 节的方框落在下一页，5.6、5.7 节的方框都落在下一页；最终全书整合（第 11 项任务）后的分页可能变化。这些指代用词是否与最终版面相合，留待整合阶段复核。
