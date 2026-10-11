# 强化学习导论（第二版）中文版

Sutton 与 Barto 的 *Reinforcement Learning: An Introduction (2nd Edition)* 的中文译本，用 Typst 排版，插图从英文原书按区域高分辨率裁切。

## 著作权说明

**原书著作权归 Richard S. Sutton、Andrew G. Barto 与 MIT Press 所有。** 英文原版于 2018 年由 MIT Press 出版，作者在 <http://incompleteideas.net/book/the-book-2nd.html> 免费提供电子版。

**本仓库是未经授权的非官方中文译本**，由读者自行翻译，与原书作者及出版方没有关联，也未获得其许可或认可。

仓库内容按来源分四类，权利归属各不相同：

| 内容 | 权利归属 |
|---|---|
| `tools/`、`template.typ`、`CHAPTER-GUIDE.md` 等工程文件 | 本仓库作者，按 MIT 许可证授权 |
| 中文译文（`chapters/`、`frontmatter/`、`backmatter/`、`parts/`） | 原书作品的演绎作品，权利仍归原书著作权人，本仓库作者不主张独立著作权 |
| `assets/figures/` 下的 156 张插图 | 裁切自英文原书，权利归原书著作权人 |
| `work/` 下各章的英文原文转录 | 英文原文的逐页转录，权利归原书著作权人 |

**根目录的 MIT 许可证只覆盖第一类。** 它不构成对译文与插图的授权，也不表示原书著作权人放弃任何权利。

本译本仅供个人学习与研究使用，不得用于商业用途。若原书著作权人提出要求，本仓库将删除相关内容。

## 编译

需要 Typst 0.15 以上。

```
typst compile --root . book.typ book.pdf
```

`--root .` 不能省略，否则 Typst 无法访问项目根目录以外的文件。产物是 383 页的 `book.pdf`。

单章编译：

```
uv run tools/assemble.py make-previews
typst compile --root . preview/ch05.typ work/out.pdf
```

单章预览文件由 `assemble.py` 生成，输出到 `preview/`（已 gitignore）。单章能独立编译，是校对阶段逐章比对英文原书的基础。

## 目录结构

| 路径 | 内容 |
|---|---|
| `book.typ` | 整书入口，由 `assemble.py make-book` 生成 |
| `template.typ` | 全部版式与宏 |
| `frontmatter/` | 两版前言、符号表 |
| `parts/` | 三个分部标题页 |
| `chapters/chNN.typ` | 章索引，按顺序 include 各小节 |
| `chapters/chNN/NN-slug.typ` | 单个小节正文 |
| `backmatter/references.typ` | 参考文献 782 条，保留英文 |
| `assets/figures/chNN/` | 插图 156 张 |
| `glossary/TERMINOLOGY.md` | 术语与行文规范，全书的执行标准 |
| `glossary/notation.typ` | 符号表中文版 |
| `glossary/terms.yml` | 机器可读术语表，供一致性检查使用 |
| `tools/pdfkit.py` | 源 PDF 的提取与渲染工具 |
| `tools/assemble.py` | 整书组装与一致性检查 |
| `CHAPTER-GUIDE.md` | 逐章作业指南，提取、翻译、校对、修订四阶段的规范 |
| `work/chNN/` | 各章的翻译记录：英文原文转录、公式代码、插图清单、独立校对报告 |
| `work/parts/`、`work/refs/` | 分部标题页与参考文献的英文原文归档 |

`work/` 下的翻译记录入库。`work/pages/`（原书 548 页的渲染图，139 MB）与 `work/scratch/` 是本地缓存，已 gitignore，可用 `uv run tools/pdfkit.py render-pages` 重新生成。

## 工具

```
uv run tools/pdfkit.py outline                        # 原书书签与页码
uv run tools/pdfkit.py text --page N                  # 单页文字，标注字体类别
uv run tools/pdfkit.py figure-regions --page N        # 该页候选插图区域
uv run tools/pdfkit.py crop --page N --bbox "x0,y0,x1,y1" --dpi 400 --out 路径.png

uv run tools/assemble.py status                       # 各章进度
uv run tools/assemble.py check-terms                  # 术语与排版一致性
uv run tools/assemble.py check-coverage               # 小节数与原书是否一致
uv run tools/assemble.py figure-widths --chapter N    # 插图宽度建议值
uv run tools/assemble.py make-previews                # 生成单章编译入口
uv run tools/assemble.py make-book                    # 生成整书入口
```

`check-terms` 扫描六类问题：源 PDF 的损坏字符、禁用译名、下标吞括号、重复图字、裸写公式编号、数学写在字符串里。

## 译本的处理原则

**方法名与理论词汇保留英文**，通用词译中文，人名保留英文。这项约定沿用既有的中文译本（`a-pdf/chinese-translation.pdf` 的翻译说明），详见 `glossary/TERMINOLOGY.md` 第一节。东亚人名用汉字姓名（樊麾、李世石），西文人名保留英文原名。

**数学全部对照原书页面渲染图重建**，不使用文字层提取。源 PDF 的文字层里希腊字母整体丢失（β、γ、λ、δ、θ、ε 为空，`∈`→`2`、`π`→`⇡`），公式无法从文字层还原，理由详见 `CHAPTER-GUIDE.md` 第二节。

**图内文字保留英文**，图注译为中文。

**原书自身的笔误按本意翻译**，不把笔误照搬成中文语病，也不加译注；参考文献条目按正确拼写呈现，便于读者检索。

**参考文献保留英文原样**，标题不翻译。

## 源文件

译文以 `../Reinforcement learning-A introduction 2nd edition.pdf`（548 页，英文原书）为唯一来源。该项目不包含该 PDF，使用时需要自备，或修改 `tools/pdfkit.py` 里 `DEFAULT_PDF` 的路径。
