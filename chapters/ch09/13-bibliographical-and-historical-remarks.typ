#import "../../template.typ": *

#heading(level: 2, numbering: none)[文献与历史评注]

泛化与函数近似一直是强化学习不可分割的一部分。Bertsekas 与 Tsitsiklis（1996）、Bertsekas（2012）以及 Sugiyama 等（2013）给出了强化学习中函数近似的现状综述。本节末尾还会讨论强化学习中一些早期的函数近似工作。

#block[
  #set par(first-line-indent: 0pt)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.7em,
    row-gutter: 0.9em,
    align: (left + top, left + top),

    [*9.3*],
    [
      监督学习中最小化均方误差的梯度下降方法是众所周知的。Widrow 与 Hoff（1960）提出了最小均方（LMS）算法，它是增量梯度下降算法的原型。这类算法及相关算法的细节在许多教材中都有介绍（例如 Widrow 与 Stearns，1985；Bishop，1995；Duda 与 Hart，1973）。

      半梯度 TD(0) 最早由 Sutton（1984，1988）探索，它是我们将在第 12 章讨论的线性 TD(λ) 算法的一部分。用「半梯度」这一术语描述这些自举方法是本书第二版新增的。

      强化学习中最先使用状态聚合的可能是 Michie 与 Chambers 的 BOXES 系统（1968）。强化学习中状态聚合的理论由 Singh、Jaakkola 与 Jordan（1995）以及 Tsitsiklis 与 Van Roy（1996）发展起来。状态聚合从动态规划的早期就已被使用（例如 Bellman，1957a）。
    ],

    [*9.4*],
    [
      Sutton（1988）在特征向量 ${bold(x)(s) : s in cal(S)}$ 线性无关的情形下，证明了线性 TD(0) 按均值收敛到最小的 $overline("VE")$ 解。几乎同一时期，若干研究者证明了以概率 1 收敛（Peng，1993；Dayan 与 Sejnowski，1994；Tsitsiklis，1994；Gurvits、Lin 与 Hanson，1994）。此外，Jaakkola、Jordan 与 Singh（1994）证明了在线更新下的收敛性。所有这些结果都假设特征向量线性无关，这意味着 $bold(w)_t$ 的分量数目至少与状态数目一样多。对于更重要的、（线性）相关的特征向量的一般情形，收敛性最先由 Dayan（1992）证明。Dayan 结果的一个重要推广与加强由 Tsitsiklis 与 Van Roy（1997）证明。他们证明了本节给出的主要结果，即线性自举方法渐近误差的界。
    ],

    [*9.5*],
    [
      我们对线性函数近似各种可能方式的介绍基于 Barto（1990）的工作。
    ],

    [*9.5.2*],
    [
      Konidaris、Osentoski 与 Thomas（2011）引入了傅里叶基的一种简单形式，适合处理带多维连续状态空间、且函数不必是周期的强化学习问题。
    ],

    [*9.5.3*],
    [
      #ezh[粗编码]这一术语来自 Hinton（1984），@fig-9-6 也基于他的一张插图。Waltz 与 Fu（1965）给出了这种函数近似在强化学习系统中的一个早期例子。
    ],

    [*9.5.4*],
    [
      瓦片编码（包括散列）由 Albus（1971，1981）提出。他用他的「小脑模型关节控制器」（cerebellar model articulator controller，CMAC）来描述它，文献中瓦片编码有时也称为 CMAC。「瓦片编码」这一术语是本书第一版新增的，不过用这些术语来描述 CMAC 的想法来自 Watkins（1989）。瓦片编码已经用在许多强化学习系统中（例如 Shewchuk 与 Dean，1990；Lin 与 Kim，1991；Miller、Scalera 与 Kim，1994；Sofge 与 White，1992；Tham，1994；Sutton，1996；Watkins，1989），也用在其他类型的学习控制系统中（例如 Kraft 与 Campagna，1990；Kraft、Miller 与 Dietz，1992）。本节大量取材于 Miller 与 Glanz（1996）的工作。瓦片编码的通用软件已有多种语言的实现（例如参见 http://incompleteideas.net/tiles/tiles3.html）。
    ],

    [*9.5.5*],
    [
      把径向基函数用于函数近似，自从 Broomhead 与 Lowe（1988）把它与 ANN 联系起来之后，就受到了广泛关注。Powell（1987）综述了 RBF 更早的用法，Poggio 与 Girosi（1989，1990）对这种方法做了大量开发与应用。
    ],

    [*9.6*],
    [
      自适应调整步长参数的自动方法包括 RMSprop（Tieleman 与 Hinton，2012）、Adam（Kingma 与 Ba，2015）、随机元下降方法如 Delta-Bar-Delta（Jacobs，1988）、它的增量推广（Sutton，1992b, c；Mahmood 等，2012）以及非线性推广（Schraudolph，1999，2002）。专为强化学习设计的方法包括 AlphaBound（Dabney 与 Barto，2012）、SID 与 NOSID（Dabney，2014）、TIDBD（Kearney 等，即将发表），以及把随机元下降应用于策略梯度学习（Schraudolph、Yu 与 Aberdeen，2006）。
    ],

    [*9.7*],
    [
      McCulloch 与 Pitts（1943）把阈值逻辑单元引入为一种抽象的模型神经元，这是 ANN 的开端。ANN 作为分类或回归学习方法的历史经历了几个阶段：大致说来，先是单层 ANN 学习的感知机（Rosenblatt，1962）与 ADALINE（ADAptive LInear Element，自适应线性元件）（Widrow 与 Hoff，1960）阶段，然后是误差反向传播（LeCun，1985；Rumelhart、Hinton 与 Williams，1986）的多层 ANN 学习阶段，以及当前强调表示学习的深度学习阶段（例如 Bengio、Courville 与 Vincent，2012；Goodfellow、Bengio 与 Courville，2016）。关于 ANN 的众多教材的例子有 Haykin（1994）、Bishop（1995）与 Ripley（2007）。

      作为强化学习函数近似的 ANN 可以追溯到 Farley 与 Clark（1954）的早期工作，他们用类强化的学习来修改表示策略的线性阈值函数的权重。Widrow、Gupta 与 Maitra（1973）提出了一个类神经元的线性阈值单元，实现了一种他们称为#ezh[带评论家的学习]（learning with a critic）或#ezh[选择性自举自适应]（selective bootstrap adaptation）的学习过程，它是 ADALINE 算法的一个强化学习变体。Werbos（1987，1994）发展了一种预测与控制方法，用误差反向传播训练的 ANN 通过 TD 类算法学习策略与值函数。Barto、Sutton 与 Brouwer（1981）以及 Barto 与 Sutton（1981b）把联想记忆网络的思想（例如 Kohonen，1977；Anderson、Silverstein、Ritz 与 Jones，1977）推广到强化学习。Barto、Anderson 与 Sutton（1982）用两层 ANN 学习一种非线性控制策略，并强调了第一层在学习合适表示方面的作用。Hampson（1983，1989）是早期主张用多层 ANN 学习值函数的人。Barto、Sutton 与 Anderson（1983）提出了一个 actor–critic 算法，其形式是一个学习平衡模拟杆的 ANN（见第 15.7 与 15.8 节）。Barto 与 Anandan（1985）引入了 Widrow 等（1973）选择性自举算法的随机版本，称为#ezh[联想奖励–惩罚]（$A_(R-P)$）算法。Barto（1985，1986）以及 Barto 与 Jordan（1987）描述了由 $A_(R-P)$ 单元组成的多层 ANN，用全局广播的强化信号训练，来学习线性不可分的分类规则。Barto（1985）讨论了这种 ANN 方法，以及这类学习规则与当时文献中其他学习规则的关系。（关于这种训练多层 ANN 方法的更多讨论见第 15.10 节。）Anderson（1986，1987，1989）评估了许多训练多层 ANN 的方法，并表明在平衡杆与汉诺塔任务中，actor 与 critic 都由误差反向传播训练的两层 ANN 实现的 actor–critic 算法优于单层 ANN。Williams（1988）描述了把反向传播与强化学习结合起来训练 ANN 的几种方式。Gullapalli（1990）与 Williams（1992）为输出连续而非二值的类神经元单元设计了强化学习算法。Barto、Sutton 与 Watkins（1990）主张 ANN 可以在近似求解序列决策问题所需的函数方面扮演重要角色。Williams（1992）把 REINFORCE 学习规则（第 13.3 节）与训练多层 ANN 的误差反向传播方法联系起来。Tesauro 的 TD-Gammon（Tesauro，1992，1994；第 16.1 节）有影响力地展示了带多层 ANN 函数近似的 TD(λ) 算法在学习玩西洋双陆棋（backgammon）时的学习能力。Silver 等（2016，2017a, b；第 16.6 节）的 AlphaGo、AlphaGo Zero 与 AlphaZero 程序用带深度卷积 ANN 的强化学习在围棋上取得了令人瞩目的结果。Schmidhuber（2015）综述了 ANN 在强化学习中的应用，包括循环 ANN 的应用。
    ],

    [*9.8*],
    [
      LSTD 归功于 Bradtke 与 Barto（见 Bradtke，1993，1994；Bradtke 与 Barto，1996；Bradtke、Ydstie 与 Barto，1994），并由 Boyan（1999，2002）、Nedić 与 Bertsekas（2003）以及 Yu（2010）进一步发展。逆矩阵的增量更新至少从 1949 年起就为人所知（Sherman 与 Morrison，1949）。把最小二乘方法推广到控制由 Lagoudakis 与 Parr（2003；Buşoniu、Lazaric、Ghavamzadeh、Munos、Babuška 与 De Schutter，2012）引入。
    ],

    [*9.9*],
    [
      我们对基于记忆的函数近似的讨论主要基于 Atkeson、Moore 与 Schaal（1997）对局部加权学习的综述。Atkeson（1992）讨论了局部加权回归在基于记忆的机器人学习中的应用，并给出了一个广泛的参考文献目录，涵盖这个思想的历史。Stanfill 与 Waltz（1986）有影响力地主张基于记忆的方法在人工智能中的重要性，尤其是考虑到当时开始可用的并行体系结构，例如连接机（Connection Machine）。Baird 与 Klopf（1993）引入了一种新颖的基于记忆的方法，并把它用作 Q-learning 的函数近似方法应用于平衡杆任务。Schaal 与 Atkeson（1994）把局部加权回归应用于机器人抛接控制问题，用来学习一个系统模型。Peng（1995）用平衡杆任务试验了几种最近邻方法，用来近似值函数、策略与环境模型。Tadepalli 与 Ok（1996）用局部加权线性回归为一个模拟的自动导引车任务学习值函数，取得了有希望的结果。Bottou 与 Vapnik（1992）证明，在某些模式识别任务中，几种局部学习算法相比非局部算法具有令人惊讶的效率，并讨论了局部学习对泛化的影响。

      Bentley（1975）引入了 $k$-$d$ 树，并报告在 $n$ 条记录上做最近邻查找时观察到 $O(log n)$ 的平均运行时间。Friedman、Bentley 与 Finkel（1977）澄清了用 $k$-$d$ 树做最近邻查找的算法。Omohundro（1987）讨论了像 $k$-$d$ 树这样的层次数据结构可能带来的效率提升。Moore、Schneider 与 Deng（1997）引入了用 $k$-$d$ 树做高效局部加权回归。
    ],

    [*9.10*],
    [
      核回归的起源是 Aizerman、Braverman 与 Rozonoer（1964）的#ezh[势函数方法]。他们把数据比作分布在空间中的带各种符号与大小的点电荷。把这些点电荷的势相加，得到的空间电势对应于插值曲面。在这个类比中，核函数就是点电荷的势，它按与电荷距离的倒数衰减。Connell 与 Utgoff（1987）把一个 actor–critic 方法应用于平衡杆任务，其中评论家（critic）用带距离倒数加权的核回归来近似值函数。这些作者的工作早于机器学习中对核回归的广泛关注，他们没有使用「核」这一术语，而是称之为「Shepard 方法」（Shepard，1968）。强化学习中其他基于核的方法包括 Ormoneit 与 Sen（2002）、Dietterich 与 Wang（2002）、Xu、Xie、Hu 与 Lu（2005）、Taylor 与 Parr（2009）、Barreto、Precup 与 Pineau（2011）以及 Bhat、Farias 与 Moallemi（2012）的工作。
    ],

    [*9.11*],
    [
      关于强调型 TD（Emphatic-TD）方法，见第 11.8 节的文献注释。
    ],
  )
]

我们所知最早的把函数近似方法用于学习值函数的例子是 Samuel 的跳棋程序（1959，1967）。Samuel 遵循 Shannon（1950）的建议：值函数不必精确，也能作为选择棋着的有用指南，并且它可以用特征的线性组合来近似。除线性函数近似之外，Samuel 还试验了查表法以及称为签名表（signature table）的层次查表法（Griffith，1966，1974；Page，1977；Biermann、Fairfield 与 Beres，1982）。

大约在 Samuel 工作的同一时期，Bellman 与 Dreyfus（1959）提出把函数近似方法用于 DP。（人们很容易认为 Bellman 与 Samuel 相互有过一些影响，但据我们所知，两人的工作中都没有任何一处引用过对方。）现在关于函数近似方法与 DP 已有相当多的文献，例如多重网格方法以及使用样条与正交多项式的方法（例如 Bellman 与 Dreyfus，1959；Bellman、Kalaba 与 Kotkin，1963；Daniel，1976；Whitt，1978；Reetz，1977；Schweitzer 与 Seidmann，1985；Chow 与 Tsitsiklis，1991；Kushner 与 Dupuis，1992；Rust，1996）。

Holland（1986）的分类器系统用一种选择性特征匹配技术把评估信息泛化到各状态–动作对之间。每个分类器匹配具有指定特征子集取值的一个状态子集，其余特征取任意值（即「通配符」）。这些子集随后被用于传统的状态聚合函数近似方法。Holland 的想法是用遗传算法演化出一组分类器，它们共同实现一个有用的动作值函数。Holland 的思想影响了本书作者早期的强化学习研究，但我们关注的是不同的函数近似方法。作为函数近似器，分类器在几个方面受到限制。第一，它们是状态聚合方法，因而在可扩展性以及高效表示平滑函数方面都有相应的局限。此外，分类器的匹配规则只能实现与特征轴平行的聚合边界。传统分类器系统最重要的局限也许是，分类器通过遗传算法这一演化方法学习。正如我们在第 1 章所讨论的，学习过程中可以获得的关于「如何学习」的详细信息，比演化方法所能利用的要多得多。这一视角使我们转而改造监督学习方法用于强化学习，特别是梯度下降与 ANN 方法。Holland 的方法与我们的方法之间的这些差异并不奇怪，因为 Holland 的思想是在 ANN 由于计算能力太弱而普遍被认为不可用的时期发展起来的，而我们的工作正处在人们开始广泛质疑这一传统看法的时期之初。把这些不同方法的各个方面结合起来，仍有许多机会。

Christensen 与 Korf（1986）试验了用回归方法修改线性值函数近似的系数，下的是国际象棋。Chapman 与 Kaelbling（1991）以及 Tan（1991）改造了决策树方法来学习值函数。基于解释的学习方法也被改造用来学习值函数，产生了紧凑的表示（Yee、Saxena、Utgoff 与 Barto，1990；Dietterich 与 Flann，1995）。
