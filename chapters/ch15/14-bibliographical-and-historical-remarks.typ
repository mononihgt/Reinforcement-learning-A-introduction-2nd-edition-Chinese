#import "../../template.typ": *

#heading(level: 2, numbering: none)[文献与历史评注]

研究与学习和决策的神经科学同本书所介绍的强化学习方法之间平行对应关系的出版物数量极为庞大。我们只能引用其中很小一部分。Niv（2009）、Dayan 与 Niv（2008）、Glimcher（2011）、Ludvig、Bellemare 与 Pearson（2011）以及 Shah（2012）是很好的起点。

与经济学、演化生物学和数学心理学一道，强化学习理论正在帮助建立关于人类与非人灵长类选择神经机制的定量模型。本章聚焦于学习，对决策的神经科学只略有涉及。Glimcher（2003）引入了「神经经济学」（neuroeconomics）这一领域，在其中，强化学习从经济学的视角为决策神经基础的研究作出贡献。另见 Glimcher 与 Fehr（2013）。Dayan 与 Abbott（2001）关于神经科学中计算与数学建模的教科书包含了强化学习在这些方法中的作用。Sterling 与 Laughlin（2015）从使高效适应行为成为可能的一般设计原理出发，考察了学习的神经基础。

#block[
  #set par(first-line-indent: 0pt)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.7em,
    row-gutter: 0.9em,
    align: (left + top, left + top),

    [*15.1*],
    [
      关于基础神经科学有许多出色的论述。Kandel、Schwartz、Jessell、Siegelbaum 与 Hudspeth（2013）是一部权威而且非常全面的参考书。
    ],

    [*15.2*],
    [
      Berridge 与 Kringelbach（2008）评述了奖励与愉悦的神经基础，指出奖励加工有许多维度，涉及许多神经系统。篇幅不允许我们讨论 Berridge 与 Robinson（1998）那项有影响力的研究，他们区分了一个刺激的享乐性影响（他们称之为「喜欢」，liking）与动机性效应（他们称之为「想要」，wanting）。Hare、O’Doherty、Camerer、Schultz 与 Rangel（2008）从经济学的视角考察了与价值有关的信号的神经基础，区分了目标价值、决策价值与预测误差。决策价值等于目标价值减去动作成本。另见 Rangel、Camerer 与 Montague（2008），Rangel 与 Hare（2010），以及 Peters 与 Büchel（2010）。
    ],

    [*15.3*],
    [
      多巴胺神经元活动的奖励预测误差假说在 Schultz、Dayan 与 Montague（1997）中得到最突出的讨论。这一假说最早由 Montague、Dayan 与 Sejnowski（1996）明确提出。他们陈述这一假说时，指的是奖励预测误差（reward prediction errors，RPEs），并没有特指 TD 误差；不过他们对这一假说的发展清楚地表明，他们所指的就是 TD 误差。据我们所知，最早认识到 TD 误差与多巴胺之间联系的是 Montague、Dayan、Nowlan、Pouget 与 Sejnowski（1993），他们受到 Schultz 小组关于多巴胺信号传导结果的启发，提出了一种由 TD 误差调制的 Hebb 学习规则。这一联系也在 Quartz、Dayan、Montague 与 Sejnowski（1992）的一篇摘要中被指出。Montague 与 Sejnowski（1994）强调了预测在大脑中的重要性，并概述了由 TD 误差调制的预测性 Hebb 学习如何能够凭借弥散的神经调质系统（例如多巴胺系统）来实现。Friston、Tononi、Reeke、Sporns 与 Edelman（1994）提出了一个大脑中价值依赖学习的模型，其中突触变化由全局神经调质信号提供的类 TD 误差所介导（尽管他们没有特别指出多巴胺）。Montague、Dayan、Person 与 Sejnowski（1995）提出了一个用 TD 误差解释蜜蜂觅食的模型。该模型基于 Hammer、Menzel 及其同事的研究（Hammer 与 Menzel，1995；Hammer，1997），这些研究表明，神经调质章鱼胺（octopamine）在蜜蜂中起着强化信号的作用。Montague 等（1995）指出，多巴胺很可能在脊椎动物大脑中起着类似的作用。Barto（1995a）把 actor–critic 架构与基底神经节回路联系起来，并讨论了 TD 学习与 Schultz 小组主要结果之间的关系。Houk、Adams 与 Barto（1995）提出了 TD 学习与 actor–critic 架构如何能够对应到基底神经节的解剖结构、生理机制与分子机制上。Doya 与 Sejnowski（1998）扩展了他们早先关于鸣禽鸣唱学习模型的论文（Doya 与 Sejnowski，1995），在其中加入了一种与多巴胺相对应的类 TD 误差，用来强化对所记忆听觉输入的选择。O’Reilly 与 Frank（2006）以及 O’Reilly、Frank、Hazy 与 Watz（2007）主张，多巴胺的相位性信号是 RPE，但不是 TD 误差。为支持他们的理论，他们引用了刺激间间隔可变时的实验结果，这些结果不符合简单 TD 模型的预测，他们还引用了这样一个观察：超出二阶条件作用的高阶条件作用很少被观察到，而 TD 学习则不受此限制。Dayan 与 Niv（2008）讨论了强化学习理论与奖励预测误差假说同实验数据的一致性中「好的、坏的与丑的」各个方面。Glimcher（2011）评述了支持奖励预测误差假说的实证发现，并强调了这一假说对当代神经科学的重要意义。
    ],

    [*15.4*],
    [
      Graybiel（2000）是一篇关于基底神经节的简明入门读物。提到的涉及对多巴胺神经元进行光遗传学激活的实验由 Tsai、Zhang、Adamantidis、Stuber、Bonci、de Lecea 与 Deisseroth（2009），Steinberg、Keiflin、Boivin、Witten、Deisseroth 与 Janak（2013），以及 Claridge-Chang、Roorda、Vrontou、Sjulson、Li、Hirsh 与 Miesenböck（2009）完成。Fiorillo、Yun 与 Song（2013），Lammel、Lim 与 Malenka（2014），以及 Saddoris、Cacciapaglia、Wightman 与 Carelli（2015）等研究表明，多巴胺神经元的信号传导特性是针对不同目标脑区特化的。传递 RPE 信号的神经元可能属于多巴胺神经元的多个群体之一，这些群体有不同的目标脑区，承担不同的功能。Eshel、Tian、Bukwich 与 Uchida（2016）在小鼠经典条件作用期间发现，外侧 VTA 中多巴胺神经元的奖励预测误差反应具有同质性，不过他们的结果并未排除在更大范围内存在反应多样性的可能。Gershman、Pesaran 与 Daw（2009）研究了可以分解为具有独立奖励信号的独立组成部分的强化学习任务，在人类神经成像数据中发现了提示大脑利用这种结构的证据。
    ],

    [*15.5*],
    [
      Schultz 1998 年的综述文章是进入关于多巴胺神经元奖励预测信号传导这一极其丰富的文献的良好入口。Berns、McClure、Pagnoni 与 Montague（2001），Breiter、Aharon、Kahneman、Dale 与 Shizgal（2001），Pagnoni、Zink、Montague 与 Berns（2002），以及 O’Doherty、Dayan、Friston、Critchley 与 Dolan（2003）描述了支持人脑中存在类似 TD 误差的信号的功能脑成像研究。
    ],

    [*15.6*],
    [
      本节在解释 TD 误差如何模拟 Schultz 小组关于多巴胺神经元相位性反应的主要结果时，大致参照了 Barto（1995a）。
    ],

    [*15.7*],
    [
      本节主要基于 Takahashi、Schoenbaum 与 Niv（2008）以及 Niv（2009）。据我们所知，Barto（1995a）以及 Houk、Adams 与 Barto（1995）最先推测 actor–critic 算法在基底神经节中的可能实现。O’Doherty、Dayan、Schultz、Deichmann、Friston 与 Dolan（2004）根据人类被试进行工具性条件作用时的功能性磁共振成像，提出 actor 与评论家最可能分别位于背侧纹状体与腹侧纹状体。Gershman、Moustafa 与 Ludvig（2014）关注时间在基底神经节的强化学习模型中如何被表示，讨论了各种时间表示计算方法各自的证据与含义。

      本节描述的 actor–critic 架构的假想神经实现，关于已知基底神经节解剖结构与生理机制的细节非常少。除 Houk、Adams 与 Barto（1995）更为详细的假说之外，还有若干其他假说与解剖结构和生理机制有更具体的联系，并声称能解释更多的数据，其中包括 Suri 与 Schultz（1998，1999）、Brown、Bullock 与 Grossberg（1999）、Contreras-Vidal 与 Schultz（1999）、Suri、Bargas 与 Arbib（2001）、O’Reilly 与 Frank（2006）以及 O’Reilly、Frank、Hazy 与 Watz（2007）提出的假说。Joel、Niv 与 Ruppin（2002）批判性地评估了其中几个模型的解剖学合理性，并提出了一个替代模型，试图包容基底神经节回路中一些被忽略的特征。
    ],

    [*15.8*],
    [
      这里讨论的 actor 学习规则比 Barto 等（1983）早期 actor–critic 网络中的学习规则更复杂。那个网络中 actor 单元的资格迹只是 $A_t times bold(x)(S_t)$ 的迹，而不是完整的 $(A_t - pi (1|S_t, bold(theta))) bold(x)(S_t)$。那项工作没有受益于第 13 章给出的策略梯度理论，也没有受益于 Williams（1986，1992）的贡献，后者表明由伯努利–logistic 单元组成的 ANN 如何能够实现一种策略梯度方法。

      Reynolds 与 Wickens（2002）为皮质纹状体通路中的突触可塑性提出了一种三因子规则，其中多巴胺调节皮质纹状体突触功效的变化。他们讨论了支持这类学习规则的实验证据及其可能的分子基础。锋电位时序依赖可塑性的决定性证明要归功于 Markram、Lübke、Frotscher 与 Sakmann（1997），更早由 Levy 与 Steward（1983）等人的实验提供了证据：突触前与突触后锋电位的相对时序对诱导突触功效变化至关重要。Rao 与 Sejnowski（2001）提出，STDP 可能是带有持续约 10 毫秒的非相依资格迹的突触处一种类 TD 机制的结果。Dayan（2002）评论说，这需要的是一种像 Sutton 与 Barto（1981a）早期经典条件作用模型中的那种误差，而不是真正的 TD 误差。关于奖励调制 STDP 的大量文献中具有代表性的出版物有 Wickens（1990）、Reynolds 与 Wickens（2002），以及 Calabresi、Picconi、Tozzi 与 Di Filippo（2007）。Pawlak 与 Kerr（2008）表明，多巴胺是诱导中型多棘神经元皮质纹状体突触处 STDP 所必需的。另见 Pawlak、Wickens、Kirkwood 与 Kerr（2010）。Yagishita、Hayashi-Takagi、Ellis-Davies、Urakubo、Ishii 与 Kasai（2014）发现，多巴胺只在 STDP 刺激之后 0.3 秒到 2 秒的时间窗口内促进小鼠中型多棘神经元棘突的增大。Izhikevich（2007）提出并探索了利用 STDP 的时序条件来触发相依资格迹的想法。Frémaux、Sprekeler 与 Gerstner（2010）提出了基于奖励调制 STDP 的规则成功学习的理论条件。
    ],

    [*15.9*],
    [
      Klopf 的享乐神经元假说（Klopf 1972，1982）启发了我们的 actor–critic 算法，这个算法实现为一个带单个类神经元单元的 ANN，该单元称为 actor 单元，实现一种类似效果定律的学习规则（Barto、Sutton 与 Anderson，1983）。与 Klopf 的突触局部资格相关的想法也由其他人提出过。Crow（1968）提出，皮质神经元突触的变化对神经活动的后果敏感。他强调了在奖励调制形式的突触可塑性中必须处理神经活动与其后果之间的时间延迟，据此提出了一种相依形式的资格，但它与整个神经元相关联，而不是与单个突触相关联。按照他的假说，一波神经活动

      #quote(block: true)[
        使参与这一波活动的细胞发生短期变化，从而把它们从未如此激活的细胞背景中挑选出来。……这样的细胞因这一短期变化而对奖励信号变得敏感……其方式是，如果这样的信号在这一变化的衰减时间结束之前出现，细胞之间的突触连接就变得更加有效。（Crow，1968）
      ]

      Crow 反对此前关于回响式神经回路担当这一角色的提议，他指出，奖励信号对这样一个回路的作用将是「……确立导致回响的突触连接（也就是说，在奖励信号出现时参与活动的那些连接），而不是通向适应性运动输出的路径上的那些连接。」Crow 还进一步假设，奖励信号经由一个「独特的神经纤维系统」传递（大概就是 Olds 与 Milner（1954）所接入的那个系统），它会将突触连接「从短期形式转变为长期形式」。

      在另一个有远见的假说中，Miller 提出了一种类似效果定律的学习规则，其中包含突触局部的相依资格迹：

      #quote(block: true)[
        ……可以设想，在特定的感觉情境中，神经元 B 偶然发放一阵「有意义的活动爆发」，它随即被转换为运动动作，而运动动作又改变情境。必须假定，有意义的爆发#ezh[在神经元层面]对它当时处于活动状态的全部自身突触产生影响……从而初步选出应当被强化的突触，尽管还没有实际强化它们。……强化信号……作出最终选择……并在适当的突触中完成确定性的改变。（Miller，1981，第 81 页）
      ]

      Miller 的假说还包含一个类似评论家的机制，他称之为「感觉分析器单元」，它按照经典条件作用的原理工作，向神经元提供强化信号，使它们学会从价值较低的状态转移到价值较高的状态，从而预见了在 actor–critic 架构中把 TD 误差用作强化信号的做法。Miller 的想法不仅与 Klopf 的假说平行（不同之处在于它明确援引了一个独特的「强化信号」），还预见了奖励调制 STDP 的一般特征。

      一个相关但有所不同的想法被 Seung（2003）称为「享乐突触」：突触按照效果定律的方式各自调整释放神经递质的概率，如果释放之后有奖励，释放概率就提高；如果未释放之后有奖励，释放概率就降低。这实质上与 Minsky 在 1954 年普林斯顿大学博士论文中使用的学习方案相同，他把这种类突触的学习元件称为 SNARC（Stochastic Neural-Analog Reinforcement Calculator，随机神经模拟强化计算器）。这些想法也涉及相依资格，不过它相依于单个突触的活动，而不是突触后神经元的活动。与之相关的还有 Unnikrishnan 与 Venugopal（1994）的提议，它使用 Harth 与 Tzanakou（1974）基于相关性的方法来调整 ANN 的权重。

      Frey 与 Morris（1997）提出了「突触标签」的想法，用于诱导突触功效的持久增强。他们的标签与 Klopf 的资格不无相似，按照他们的假设，标签由突触的暂时增强构成，随后的神经元激活可以把这种暂时增强转变为持久增强。O’Reilly 与 Frank（2006）以及 O’Reilly、Frank、Hazy 与 Watz（2007）的模型使用工作记忆（working memory）来跨接时间间隔，而不是使用资格迹。Wickens 与 Kotter（1995）讨论了突触资格的可能机制。He、Huertas、Hong、Tie、Hell、Shouval 与 Kirkwood（2015）提供的证据支持皮质神经元突触中存在相依资格迹，其时间进程与 Klopf 所假设的资格迹相似。

      神经元使用与细菌趋化性有关的学习规则这一比喻由 Barto（1989）讨论过。Koshland 对细菌趋化性的大量研究，部分动机来自细菌的特征与神经元的特征之间的相似性（Koshland，1980）。另见 Berg（1975）。Shimansky（2009）提出了一种与上面提到的 Seung 的想法有几分相似的突触学习规则，其中每个突触各自表现得像趋化细菌一样。在这种情况下，一组突触在突触权重值的高维空间中「游」向吸引剂。Montague、Dayan、Person 与 Sejnowski（1995）提出了蜜蜂觅食行为的趋化式模型，其中涉及神经调质章鱼胺。
    ],

    [*15.10*],
    [
      关于强化学习 agent 在团队问题与博弈问题中行为的研究有很长的历史，大致经历了三个阶段。据我们所知，第一个阶段始于俄罗斯数学家兼物理学家 M. L. Tsetlin 的研究。他的文集在他 1966 年去世后出版为 Tsetlin（1973）。本书第 1.7 节与第 4.8 节在赌博机问题的语境中提到了他关于学习自动机的研究。Tsetlin 的文集还包含对团队问题与博弈问题中学习自动机的研究，这些研究引出了后来这一领域中关于随机学习自动机（stochastic learning automata）的工作，由 Narendra 与 Thathachar（1974，1989）、Viswanathan 与 Narendra（1974）、Lakshmivarahan 与 Narendra（1982）、Narendra 与 Wheeler（1983）以及 Thathachar 与 Sastry（2002）描述。Thathachar 与 Sastry（2011）是更近期的全面论述。这些研究大多局限于非联想学习自动机，意思是没有处理联想式或者说情境式赌博机问题（第 2.9 节）。

      第二个阶段始于把学习自动机扩展到联想式或者说情境式的情形。Barto、Sutton 与 Brouwer（1981）以及 Barto 与 Sutton（1981b）在广播全局强化信号的单层 ANN 中实验了联想式随机学习自动机。其学习算法是 Harth 与 Tzanakou（1974）的 Alopex 算法的联想式扩展。Barto 等把实现这类学习的类神经元元件称为#ezh[联想搜索元件]（associative search elements，ASEs）。Barto 与 Anandan（1985）提出了一种联想的强化学习算法，称为#ezh[联想奖励–惩罚]（associative reward-penalty，AR−P）算法。他们把随机学习自动机理论与模式分类理论结合起来，证明了一个收敛结果。Barto（1985，1986）以及 Barto 与 Jordan（1987）描述了把 AR−P 单元连接成多层 ANN 的团队所得到的结果，表明它们能够在全局广播的强化信号下学习非线性函数，例如 XOR 以及其他函数。Barto（1985）广泛讨论了这种处理 ANN 的方法，以及这类学习规则与当时文献中其他学习规则的关系。Williams（1992）从数学上分析并推广了这类学习规则，并把它们的使用与训练多层 ANN 的误差反向传播方法联系起来。Williams（1988）描述了把反向传播与强化学习结合起来训练 ANN 的若干方式。Williams（1992）表明，AR−P 算法的一个特例是 REINFORCE 算法，不过使用一般的 AR−P 算法能得到更好的结果（Barto，1985）。

      对强化学习 agent 团队产生兴趣的第三个阶段，受到两方面的影响：对多巴胺作为广泛广播的神经调质这一作用的理解不断加深，以及对奖励调制 STDP 存在的推测。与更早的研究相比，这项研究更多地考虑突触可塑性的细节以及来自神经科学的其他约束。出版物包括以下这些（按时间顺序排列，同一年内按字母顺序）：Bartlett 与 Baxter（1999，2000）、Xie 与 Seung（2004）、Baras 与 Meir（2007）、Farries 与 Fairhall（2007）、Florian（2007）、Izhikevich（2007）、Pecevski、Maass 与 Legenstein（2008）、Legenstein、Pecevski 与 Maass（2008）、Kolodziejski、Porr 与 Wörgötter（2009）、Urbanczik 与 Senn（2009）以及 Vasilaki、Frémaux、Urbanczik、Senn 与 Gerstner（2009）。Nowé、Vrancx 与 De Hauwere（2012）评述了更广泛的多 agent 强化学习领域中的较新进展。
    ],

    [*15.11*],
    [
      Yin 与 Knowlton（2006）评述了用啮齿动物进行的结果贬值实验的发现，这些发现支持这样一种观点：习惯性行为与目标导向行为（按照心理学家的用法）分别与背侧外侧纹状体（DLS）和背侧内侧纹状体（DMS）中的加工关系最密切。Valentin、Dickinson 与 O’Doherty（2007）用人类被试在结果贬值情境中进行的脑功能成像实验的结果表明，眶额皮质（OFC）是目标导向选择的一个重要组成部分。Padoa-Schioppa 与 Assad（2006）在猴子身上的单个单元记录支持 OFC 在编码引导选择行为的价值中的作用。Rangel、Camerer 与 Montague（2008）以及 Rangel 与 Hare（2010）从神经经济学的视角评述了关于大脑如何进行目标导向决策的发现。Pezzulo、van der Meer、Lansink 与 Pennartz（2014）评述了关于内部生成序列的神经科学，并提出了一个模型，说明这些机制如何可能是基于模型规划的组成部分。Daw 与 Shohamy（2008）提出，多巴胺信号与习惯性或者说无模型的行为有很好的联系，而目标导向或者说基于模型的行为则涉及其他过程。Bromberg-Martin、Matsumoto、Hong 与 Hikosaka（2010）的实验数据表明，多巴胺信号包含同时与习惯性行为和目标导向行为有关的信息。Doll、Simon 与 Daw（2012）主张，大脑中服务于习惯性学习与选择以及目标导向学习与选择的机制之间可能并不存在清晰的分离。
    ],

    [*15.12*],
    [
      Keiflin 与 Janak（2015）评述了 TD 误差与成瘾之间的联系。Nutt、Lingford-Hughes、Erritzoe 与 Stokes（2015）批判性地评估了成瘾源于多巴胺系统失调这一假说。Montague、Dolan、Friston 与 Dayan（2012）概述了计算精神病学领域的目标与早期努力，Adams、Huys 与 Roiser（2015）评述了较新的进展。
    ],
  )
]
