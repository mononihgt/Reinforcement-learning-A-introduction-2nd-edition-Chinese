# 第 14 章 心理学 校对报告

比对材料：英文原文（`work/ch14/source.md` 与 `work/pages/p363.png` 到 `p398.png`）、译文（`chapters/ch14.typ` 与 `chapters/ch14/` 下 9 个小节文件）、规范（`glossary/TERMINOLOGY.md`）。

## 缺陷清单

未发现缺陷。

## 存疑

1. **PDF 394（文献与历史评注 14.2.3），「驱动强化理论」**
   - 原文：`Klopf's (1988) drive-reinforcement theory of classical conditioning extends the TD model ...`；译文：「Klopf（1988）的经典条件作用驱动强化理论扩展了 TD 模型……」（`chapters/ch14/09-bibliographical-and-historical-remarks.typ`）。
   - 为什么判不准：《TERMINOLOGY.md》没有收录 drive 与 drive-reinforcement theory，项目其余部分也没有出现过「驱力」或「驱动」的用例；中文心理学通行译法是「驱力强化理论」（Hull 的 drive 译作驱力）。缺少可以据以判定的规范，无法确定现有译法是否算违反规范。Klopf 的理论在第 15.9 节还会出现，建议先在《TERMINOLOGY.md》里补上这条术语的处理规定，再统一处理。

2. **编译输出第 10 页（`work/out-ch14.pdf`），页面底部留白**
   - 现象：图 14.3 这幅图（宽度 55%）在剩余空间里放不下，被推到输出第 11 页顶部，第 10 页正文结束处留下约四分之一页的空白。
   - 为什么判不准：这是 Typst `#figure` 随文排版的固有行为，指南与《TERMINOLOGY.md》都没有图文必须紧邻的条款，无法判定这属于缺陷还是可以接受的排版结果。全书整合阶段分页还会变化，此处留待那时复核。
