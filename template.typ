// 全书版式与宏。各章文件只引用这里的定义，自身不设置页面样式，
// 这样整章被 book.typ 引入时不会产生嵌套的页面设置。

#let body-font = ("New Computer Modern", "Songti SC")
#let head-font = ("Heiti SC", "New Computer Modern")
#let math-font = "New Computer Modern Math"

// 例、练习、算法的独立计数器，随章重置
#let example-counter = counter("example")

// 当前章的中文标题。页眉取这个状态，因此页眉只显示中文标题，
// 不含章标题下方的英文原名。
#let current-chapter = state("current-chapter", none)

#let chapter-number() = {
  let h = counter(heading).get()
  if h.len() == 0 { 0 } else { h.at(0) }
}

// 图、表、公式的编号都带上章号，写作「图 2.1」「表 2.1」「(2.1)」
#let numbered-with-chapter(pattern) = (..n) => numbering(
  pattern,
  chapter-number(),
  if n.pos().len() == 0 { 1 } else { n.pos().at(0) },
)

// 条目结束符。原书用实心方块标记例题结束、空心方框标记练习结束，都排在右边距。
// 原书这两类条目与正文混排，靠结束符划出边界；我们另外给例题套了框、给练习加了
// 缩进，结束符保留以贴合原书。定义必须排在 example 与 exercise 之前。
#let end-example = h(1fr) + text(size: 8pt)[#sym.square.filled]
#let end-exercise = h(1fr) + text(size: 8pt)[#sym.square.stroked]

#let book(
  title: "强化学习导论",
  edition: "第二版",
  authors: ("Richard S. Sutton", "Andrew G. Barto"),
  body,
) = {
  set document(title: title + "（" + edition + "）", author: authors.join("、"))

  set page(
    paper: "a4",
    margin: (inside: 2.6cm, outside: 2.2cm, top: 2.6cm, bottom: 2.4cm),
    numbering: "1",
    number-align: center,
    header: context {
      let current = current-chapter.get()
      if current != none {
        set text(size: 8.5pt, font: head-font, fill: luma(30%))
        set par(first-line-indent: 0pt)
        align(center)[#current]
      }
    },
  )

  set text(font: body-font, size: 10.5pt, lang: "zh", region: "cn")
  // supplement: none 让 @eq- 引用只渲染编号「(2.12)」，不自动加「式」字，
  // 与原书写法一致，也避免中文正文里出现「算法 式 (2.12)」这种多余的词间空格。
  // number-align: bottom 把多行公式的编号排在末行，与英文原书一致；
  // 默认是垂直居中，多行推导式上会与原文不符。
  set math.equation(
    numbering: numbered-with-chapter("(1.1)"),
    supplement: none,
    number-align: bottom,
  )
  show math.equation: set text(font: math-font)
  set par(first-line-indent: 2em, leading: 0.78em, justify: true, spacing: 1.05em)

  set heading(numbering: "1.1")
  show heading: set text(font: head-font)
  show heading.where(level: 2): set block(above: 1.6em, below: 0.8em)
  show heading.where(level: 3): set block(above: 1.3em, below: 0.6em)
  // 章标题自行排布：章号与中文标题同一行，英文原名另起一行。
  // heading 的 numbering 保留，目录仍能取到章号。
  show heading.where(level: 1): it => {
    example-counter.update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(math.equation).update(0)
    pagebreak(weak: true)
    block(above: 1.0em, below: 2.4em)[
      #set text(size: 19pt)
      #set par(first-line-indent: 0pt, spacing: 0.25em)
      #if it.numbering != none {
        context counter(heading).display("1")
        h(0.8em)
      }
      #it.body
    ]
  }
  show heading.where(level: 2): set text(size: 13.5pt)
  show heading.where(level: 3): set text(size: 11.5pt)
  // 三级标题是原书的「9.5.1」这类子小节。上面的 set heading(numbering: "1.1")
  // 对三级标题只会渲染出前两段，故单独指定三段编号。
  show heading.where(level: 3): set heading(numbering: "1.1.1")

  set figure(numbering: numbered-with-chapter("1.1"))
  show figure.where(kind: image): set figure(supplement: [图])
  show figure.where(kind: table): set figure(supplement: [表])
  show figure.caption: it => {
    set text(size: 9.5pt)
    set par(first-line-indent: 0pt, spacing: 0em)
    block(above: 0.5em)[
      #it.supplement
      #h(0.25em)
      #context it.counter.display(it.numbering)
      #h(0.7em)
      #it.body
    ]
  }
  show figure: set block(above: 1.0em, below: 1.0em, breakable: false)
  show figure.where(kind: table): set block(breakable: true)

  set table(stroke: 0.4pt, inset: 6pt)
  show table.cell: set align(center)
  set list(tight: false, indent: 1.4em)
  set enum(tight: false, indent: 1.4em)
  show footnote.entry: set text(size: 8.5pt)

  body
}

// 扉页。整书的第一页，不编页码，页眉为空。
#let title-page(
  title: "强化学习导论",
  edition: "第二版",
  original: "Reinforcement Learning: An Introduction",
  authors: ("Richard S. Sutton", "Andrew G. Barto"),
) = {
  // 先归零，扉页本身占第 0 页且不显示页码，目录便从第 1 页开始
  counter(page).update(0)
  page(
    numbering: none,
    header: none,
    align(center + horizon)[
      #set par(first-line-indent: 0pt)
      #text(size: 30pt, font: head-font)[#title]
      #v(0.9em)
      #text(size: 16pt, font: head-font, fill: luma(35%))[#edition]
      #v(3.2em)
      #text(size: 12pt, font: "New Computer Modern", fill: luma(45%))[#original]
      #v(1.2em)
      #text(size: 14pt)[#authors.join("　　")]
    ],
  )
}

// 目录。收录到二级标题，即各章与其下的小节。
#let contents() = {
  pagebreak(weak: true)
  heading(level: 1, numbering: none, outlined: false)[目录]
  outline(title: none, indent: 1.6em, depth: 2)
}

// 中文强调。中文字体没有斜体字形，原书排斜体表示强调的地方，
// 中文按传统改用楷体，视觉上明确可辨。
#let ezh(body) = text(font: "Kaiti SC")[#body]

// 章标题。英文原名排在中文标题之下，与标题同属一个 heading 元素，
// 这样章节编号、目录条目、页眉标题都只取中文部分，版面也不会错位。
#let chapter(zh, en: none, number: none) = {
  current-chapter.update(zh)
  // 显式给出章号。单章预览时文档里只有这一章，若不显式指定，
  // 章号会从 1 开始，图号与公式号跟着错，与英文原书对不上。
  if number != none {
    counter(heading).update(number - 1)
  }
  if en == none {
    heading(level: 1, zh)
  } else {
    // 正文里不能出现 set 规则，否则标题被拆成两个段落，章号会掉到单独一行
    heading(level: 1, [#zh#linebreak()#text(
      size: 11pt,
      font: "New Computer Modern",
      fill: luma(40%),
      weight: "regular",
    )[#en]])
  }
}

// 不编号的一级标题。前置部分（两版前言、符号表）与后置部分（参考文献）都用它。
// 不计章号，也不推进章计数器，正文第一章仍然从 1 开始。
#let plain-chapter(zh, en: none) = {
  current-chapter.update(zh)
  if en == none {
    heading(level: 1, numbering: none, zh)
  } else {
    heading(level: 1, numbering: none, [#zh#linebreak()#text(
      size: 11pt,
      font: "New Computer Modern",
      fill: luma(40%),
      weight: "regular",
    )[#en]])
  }
  counter(heading).update(0)
  example-counter.update(0)
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
  counter(math.equation).update(0)
}

// 分部标题页。原书分三大部，每部一张独立的分隔页：页顶一条与栏宽等宽的粗横线，
// 线下是部名，导语从页面约五分之一处起排。状态更新与计数器重置的处理与
// plain-chapter 相同（不编号、推进 current-chapter 以便页眉显示部名、重置各计数器），
// 版式另起一套，所以在分隔页内部局部覆盖一级标题的章版式。
#let part-page(zh, en: none, body) = {
  current-chapter.update(zh)
  [
    #show heading.where(level: 1): it => block(above: 0pt, below: 0pt)[
      #v(4pt)
      #line(length: 100%, stroke: 4pt)
      #v(14pt)
      #set par(first-line-indent: 0pt, spacing: 0.4em)
      #set text(size: 22pt, font: head-font, weight: "bold")
      #it.body
    ]
    #pagebreak(weak: true)
    #if en == none {
      heading(level: 1, numbering: none, zh)
    } else {
      heading(level: 1, numbering: none, [#zh#linebreak()#text(
        size: 12pt,
        font: "New Computer Modern",
        fill: luma(40%),
        weight: "regular",
      )[#en]])
    }
    // 导语与部名之间留出与原书分隔页等量的空白（原书此处为 63 点，本版正文字号略大）
    #v(68pt)
    #body
  ]
  // 与 plain-chapter 一致：分隔页本身不让章号前进
  counter(heading).update(0)
  example-counter.update(0)
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
  counter(math.equation).update(0)
}

// 例题框
#let example(title, body) = {
  example-counter.step()
  block(
    above: 1.1em,
    below: 1.1em,
    width: 100%,
    inset: (x: 0.9em, y: 0.75em),
    fill: luma(96%),
    stroke: (left: 1.4pt + luma(55%)),
    radius: (right: 2pt),
  )[
    #set par(first-line-indent: 0pt, spacing: 0.5em)
    #context [*例 #numbering("1.1", chapter-number(), example-counter.get().at(0))*#h(0.5em)#title]
    #v(0.35em)
    #body#end-example
  ]
}

// 数学内容框。原书把数学性较强的部分单独装进带边框的方框，框顶一条浅底标题栏，
// 框内不编号、不进目录。原书另有不带标题的方框，整框浅灰底，用
// `#mathbox(none)[...]` 排版：不给标题就没有标题栏，框内改用浅灰底，与原书一致。
#let mathbox(title, body) = block(
  above: 1.3em,
  below: 1.3em,
  width: 100%,
  stroke: 0.6pt + luma(45%),
  radius: 3pt,
  clip: true,
  stack(
    dir: ttb,
    if title != none {
      block(width: 100%, inset: (x: 0.9em, y: 0.5em), fill: luma(92%))[
        #set text(font: head-font, size: 10pt)
        #title
      ]
    },
    block(
      width: 100%,
      inset: (x: 0.9em, y: 0.8em),
      fill: if title == none { luma(96%) } else { none },
    )[
      #set par(first-line-indent: 0pt, spacing: 0.8em)
      #body
    ],
  ),
)

// 伪代码框。原书的算法伪代码装进独立的框，框顶一条深底白字标题栏，框内浅灰底。
#let algbox(title, body) = block(
  above: 1.3em,
  below: 1.3em,
  width: 100%,
  stroke: 0.8pt + luma(30%),
  radius: 3pt,
  clip: true,
  // 伪代码是一个整体，不能被页面切开；原书的算法框也都是整块的。
  // 数学推导框不设此项，原书里长的推导框本来就跨页。
  breakable: false,
  stack(
    dir: ttb,
    block(width: 100%, inset: (x: 0.9em, y: 0.5em), fill: luma(25%))[
      #set text(font: head-font, size: 10pt, fill: white)
      #title
    ],
    block(width: 100%, inset: (x: 0.9em, y: 0.8em), fill: luma(94%))[
      #set par(first-line-indent: 0pt, spacing: 0.9em)
      // 伪代码不参与全书公式编号，框内的展示公式一律左对齐
      #set math.equation(numbering: none)
      #show math.equation.where(block: true): set align(left + horizon)
      #body
    ],
  ),
)

// 练习。编号沿用原书编号，便于与英文版对照。原书练习整体排斜体，
// 中文不用斜体，改为加粗编号加正常正文，并把星号标在末尾。
#let exercise(number, star: false, body) = {
  block(above: 0.8em, below: 0.8em, width: 100%)[
    #set par(first-line-indent: 0pt, spacing: 0.5em)
    #text(font: head-font, size: 10pt)[练习 #number]
    #h(0.7em)
    #body#if star [#super[#sym.ast.basic]]#end-exercise
  ]
}
