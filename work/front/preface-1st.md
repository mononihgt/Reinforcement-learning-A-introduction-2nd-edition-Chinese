# Preface to the First Edition

<!-- PDF 17 | 书 xvii -->

We first came to focus on what is now known as reinforcement learning in late 1979. We
were both at the University of Massachusetts, working on one of the earliest projects to
revive the idea that networks of neuronlike adaptive elements might prove to be a promising
approach to artificial adaptive intelligence. The project explored the "heterostatic theory
of adaptive systems" developed by A. Harry Klopf. Harry's work was a rich source of
ideas, and we were permitted to explore them critically and compare them with the long
history of prior work in adaptive systems. Our task became one of teasing the ideas apart
and understanding their relationships and relative importance. This continues today,
but in 1979 we came to realize that perhaps the simplest of the ideas, which had long
been taken for granted, had received surprisingly little attention from a computational
perspective. This was simply the idea of a learning system that *wants* something, that
adapts its behavior in order to maximize a special signal from its environment. This
was the idea of a "hedonistic" learning system, or, as we would say now, the idea of
reinforcement learning.

Like others, we had a sense that reinforcement learning had been thoroughly explored
in the early days of cybernetics and artificial intelligence. On closer inspection, though,
we found that it had been explored only slightly. While reinforcement learning had clearly
motivated some of the earliest computational studies of learning, most of these researchers
had gone on to other things, such as pattern classification, supervised learning, and
adaptive control, or they had abandoned the study of learning altogether. As a result, the
special issues involved in learning how to get something from the environment received
relatively little attention. In retrospect, focusing on this idea was the critical step that
set this branch of research in motion. Little progress could be made in the computational
study of reinforcement learning until it was recognized that such a fundamental idea had
not yet been thoroughly explored.

The field has come a long way since then, evolving and maturing in several directions.
Reinforcement learning has gradually become one of the most active research areas in ma-
chine learning, artificial intelligence, and neural network research. The field has developed
strong mathematical foundations and impressive applications. The computational study
of reinforcement learning is now a large field, with hundreds of active researchers around
the world in diverse disciplines such as psychology, control theory, artificial intelligence,
and neuroscience. Particularly important have been the contributions establishing and
developing the relationships to the theory of optimal control and dynamic programming.

<!-- PDF 18 | 书 xviii -->

The overall problem of learning from interaction to achieve goals is still far from being
solved, but our understanding of it has improved significantly. We can now place compo-
nent ideas, such as temporal-difference learning, dynamic programming, and function
approximation, within a coherent perspective with respect to the overall problem.

Our goal in writing this book was to provide a clear and simple account of the key
ideas and algorithms of reinforcement learning. We wanted our treatment to be accessible
to readers in all of the related disciplines, but we could not cover all of these perspectives
in detail. For the most part, our treatment takes the point of view of artificial intelligence
and engineering. Coverage of connections to other fields we leave to others or to another
time. We also chose not to produce a rigorous formal treatment of reinforcement learning.
We did not reach for the highest possible level of mathematical abstraction and did not
rely on a theorem–proof format. We tried to choose a level of mathematical detail that
points the mathematically inclined in the right directions without distracting from the
simplicity and potential generality of the underlying ideas.

In some sense we have been working toward this book for thirty years, and we have lots
of people to thank. First, we thank those who have personally helped us develop the overall
view presented in this book: Harry Klopf, for helping us recognize that reinforcement
learning needed to be revived; Chris Watkins, Dimitri Bertsekas, John Tsitsiklis, and
Paul Werbos, for helping us see the value of the relationships to dynamic programming;
John Moore and Jim Kehoe, for insights and inspirations from animal learning theory;
Oliver Selfridge, for emphasizing the breadth and importance of adaptation; and, more
generally, our colleagues and students who have contributed in countless ways: Ron
Williams, Charles Anderson, Satinder Singh, Sridhar Mahadevan, Steve Bradtke, Bob
Crites, Peter Dayan, and Leemon Baird. Our view of reinforcement learning has been
significantly enriched by discussions with Paul Cohen, Paul Utgoff, Martha Steenstrup,
Gerry Tesauro, Mike Jordan, Leslie Kaelbling, Andrew Moore, Chris Atkeson, Tom
Mitchell, Nils Nilsson, Stuart Russell, Tom Dietterich, Tom Dean, and Bob Narendra.
We thank Michael Littman, Gerry Tesauro, Bob Crites, Satinder Singh, and Wei Zhang
for providing specifics of Sections 4.7, 15.1, 15.4, 15.5, and 15.6 respectively. We thank
the Air Force Office of Scientific Research, the National Science Foundation, and GTE
Laboratories for their long and farsighted support.

We also wish to thank the many people who have read drafts of this book and
provided valuable comments, including Tom Kalt, John Tsitsiklis, Pawel Cichosz, Olle
Gällmo, Chuck Anderson, Stuart Russell, Ben Van Roy, Paul Steenstrup, Paul Cohen,
Sridhar Mahadevan, Jette Randlov, Brian Sheppard, Thomas O'Connell, Richard Coggins,
Cristina Versino, John H. Hiett, Andreas Badelt, Jay Ponte, Joe Beck, Justus Piater,
Martha Steenstrup, Satinder Singh, Tommi Jaakkola, Dimitri Bertsekas, Torbjörn Ekman,
Christina Björkman, Jakob Carlström, and Olle Palmgren. Finally, we thank Gwyn
Mitchell for helping in many ways, and Harry Stanton and Bob Prior for being our
champions at MIT Press.
