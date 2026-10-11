#import "template.typ": *

#show: book.with(
  title: "强化学习导论",
  edition: "第二版",
  authors: ("Richard S. Sutton", "Andrew G. Barto"),
)

#title-page()

#contents()

#include "frontmatter/preface-2nd.typ"
#include "frontmatter/preface-1st.typ"
#include "frontmatter/notation.typ"

#include "parts/part-1.typ"

#include "chapters/ch01.typ"

#include "chapters/ch02.typ"

#include "chapters/ch03.typ"

#include "chapters/ch04.typ"

#include "chapters/ch05.typ"

#include "chapters/ch06.typ"

#include "chapters/ch07.typ"

#include "chapters/ch08.typ"

#include "parts/part-2.typ"

#include "chapters/ch09.typ"

#include "chapters/ch10.typ"

#include "chapters/ch11.typ"

#include "chapters/ch12.typ"

#include "chapters/ch13.typ"

#include "parts/part-3.typ"

#include "chapters/ch14.typ"

#include "chapters/ch15.typ"

#include "chapters/ch16.typ"

#include "chapters/ch17.typ"

#include "backmatter/references.typ"
