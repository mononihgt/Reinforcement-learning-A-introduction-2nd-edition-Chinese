# 第 10 章校对报告：带近似的 on-policy 控制

比对材料：英文原文 `work/ch10/source.md` 与页面渲染图 `work/pages/p0265.png` 至 `p0278.png`（原书第 243–256 页）；中文产出 `chapters/ch10.typ` 与 `chapters/ch10/` 下的 7 个小节文件；规范 `glossary/TERMINOLOGY.md`。

未发现缺陷。

## 存疑（2 条）

1. **推导框内出处注解的位置**（PDF 第 276 页；`chapters/ch10/04-deprecating-the-discounted-setting.typ` 第 22–24 行）

- 规范：`glossary/TERMINOLOGY.md` 第 350 行规定公式后的出处注解「排在公式块的下一行左端」。
- 实际：译文把注解排在公式同一行的右端（`&quad "（由 #ref(<eq-10-7>)）"` 等），与原书右端注解的版式一致。
- 判不准的理由：第 3、4、6 章的同类注解也都行内排列，第 9 章校对报告已就同一问题写明「属全项目层面的统一问题……维持现状，待全项目统一时一并调整」。规范文字与全项目既有实践不一致，单改第 10 章会与已校对章节不一致。

2. **第 276 页数学推导框与句子的先后关系**（PDF 第 275–276 页；`chapters/ch10/04-deprecating-the-discounted-setting.typ` 第 13–15 行）

- 英文原文：p275 段末是 "…That guarantee was key to the theory of our reinforcement learning control methods. With"，p276 页首是推导框，框后紧接 "function approximation we have lost it!"。
- 中文译文：句子写完整（「……有了函数近似，我们已经失去了它！」），推导框排在整段之后。
- 判不准的理由：无法断定原书把方框排在页首、恰好把句子断开，是出于有意的插句排版还是分页造成的断句。译文保持句子完整，且两处「下一页的方框」的指代与当前预览分页吻合。
