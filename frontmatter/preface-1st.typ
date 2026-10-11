#import "../template.typ": *

#plain-chapter("第一版前言", en: "Preface to the First Edition")

我们最初开始关注如今被称为强化学习的问题，是在 1979 年末。当时我们两人都在麻省大学，参与最早的一批试图复兴这一思想的研究计划：由类似神经元的自适应元件构成的网络，可能是通往人工自适应智能的一条有前景的途径。这项计划探索了 A. Harry Klopf 提出的「自适应系统的异稳态理论」。Harry 的工作是思想的丰富源泉，我们得以批判性地探索这些思想，并把它们与自适应系统领域长期积累的前人工作相比较。我们的任务变成了把这些思想梳理开来，理解它们之间的关系与相对重要性。这项工作延续至今，不过 1979 年我们逐渐认识到，这些思想中最简单的那个——长期以来被视为理所当然——从计算的视角看，出人意料地很少受到关注。这个思想其实很简单：一个学习系统#ezh[想要]某种东西，它调整自身的行为，以便使来自环境（environment）的某个特殊信号最大化。这就是「享乐主义」学习系统的思想，或者用我们现在的话说，就是强化学习的思想。

像其他人一样，我们有一种感觉：在控制论与人工智能的早期，强化学习已经被彻底研究过了。然而仔细考察之后，我们发现它只被研究过很少一点。强化学习显然曾推动过最早的一批关于学习的计算研究，但这些研究者大多转向了别的东西，例如模式分类、监督学习和自适应控制，或者干脆放弃了学习的研究。结果是，学会如何从环境中获得某种东西所涉及的种种特殊问题，受到的关注相对很少。事后看来，聚焦于这一思想正是启动这个研究分支的关键一步。在人们认识到这样一个基本思想尚未得到彻底探索之前，强化学习的计算研究难以取得进展。

自那时以来，这个领域已取得长足进展，在若干方向上不断演进并走向成熟。强化学习逐渐成为机器学习、人工智能和神经网络研究中最活跃的研究领域之一。这个领域发展出了坚实的数学基础和令人瞩目的应用。强化学习的计算研究如今已是一个庞大的领域，全世界有数百名活跃的研究者，分布在心理学、控制理论、人工智能和神经科学等各不相同的学科中。其中尤其重要的是那些建立并发展它与最优控制理论和动态规划之间关系的贡献。

从交互中学习以实现目标的总体问题远远没有得到解决，但我们对它的理解已经显著改善。现在我们能够把一些构成性的思想，例如时序差分（temporal-difference）学习、动态规划和函数近似，放在相对于这个总体问题的连贯视野之中。

我们写这本书的目标是清晰而简明地阐述强化学习的关键思想与算法。我们希望我们的论述对所有相关学科的读者都是可读的，但无法详细涵盖所有这些视角。大体上，我们的论述采取人工智能与工程的观点。至于与其他领域之间联系的论述，我们留给他人，或者留待日后。我们也选择不对强化学习作严格的形式化论述。我们没有追求尽可能高的数学抽象层次，也没有采用「先定理后证明」的格式。我们力求选择一个恰当的数学详细程度，既为有数学倾向的读者指出正确的方向，又不至于分散人们对底层思想的简洁性与潜在一般性的注意力。

从某种意义上说，我们为这本书已经工作了三十年，要感谢的人很多。首先，我们感谢那些亲自帮助我们形成本书所呈现的总体观点的人：Harry Klopf，他帮助我们认识到强化学习需要被复兴；Chris Watkins、Dimitri Bertsekas、John Tsitsiklis 和 Paul Werbos，他们帮助我们认识到与动态规划之间关系的价值；John Moore 和 Jim Kehoe，他们带来了动物学习理论的洞见与启发；Oliver Selfridge，他强调了自适应的广度与重要性；以及更一般地，以数不清的方式做出贡献的同事和学生：Ron Williams、Charles Anderson、Satinder Singh、Sridhar Mahadevan、Steve Bradtke、Bob Crites、Peter Dayan 和 Leemon Baird。与 Paul Cohen、Paul Utgoff、Martha Steenstrup、Gerry Tesauro、Mike Jordan、Leslie Kaelbling、Andrew Moore、Chris Atkeson、Tom Mitchell、Nils Nilsson、Stuart Russell、Tom Dietterich、Tom Dean 和 Bob Narendra 的讨论，极大地丰富了我们对强化学习的看法。我们感谢 Michael Littman、Gerry Tesauro、Bob Crites、Satinder Singh 和 Wei Zhang 分别提供第 4.7 节、第 15.1 节、第 15.4 节、第 15.5 节和第 15.6 节的具体内容。我们感谢美国空军科学研究局、美国国家科学基金会和 GTE 实验室长期而有远见的支持。

我们还要感谢许多读过本书草稿并提出宝贵意见的人，包括 Tom Kalt、John Tsitsiklis、Pawel Cichosz、Olle Gällmo、Chuck Anderson、Stuart Russell、Ben Van Roy、Paul Steenstrup、Paul Cohen、Sridhar Mahadevan、Jette Randlov、Brian Sheppard、Thomas O'Connell、Richard Coggins、Cristina Versino、John H. Hiett、Andreas Badelt、Jay Ponte、Joe Beck、Justus Piater、Martha Steenstrup、Satinder Singh、Tommi Jaakkola、Dimitri Bertsekas、Torbjörn Ekman、Christina Björkman、Jakob Carlström 和 Olle Palmgren。最后，我们感谢 Gwyn Mitchell 在许多方面的帮助，也感谢 Harry Stanton 和 Bob Prior 在 MIT Press 作为我们的坚定支持者。
