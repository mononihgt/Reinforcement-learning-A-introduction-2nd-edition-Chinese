import argparse
import json
import re
import sys
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parent.parent
CHAPTER_MAP = ROOT / "work" / "chapter-map.json"
TERMS = ROOT / "glossary" / "terms.yml"

PART_PREFIXES = ("I ", "II ", "III ")

# 章标题可能是字符串，也可能是内容块（标题里含数学时比如 [$n$ 步自举] 只能写成块）
CHAPTER_RE = re.compile(r'^#chapter\((?:\[([^\]]+)\]|"([^"]+)")')
FRONT_CHAPTER_RE = re.compile(r'^#front-chapter\("([^"]+)"')
INCLUDE_RE = re.compile(r'^#include\s+"([^"]+)"')
# 必须带 MULTILINE，否则 ^ 只匹配整份文本的开头，每个文件至多计到一个小节标题
SECTION_RE = re.compile(r"^==\s+", re.MULTILINE)
# 裸下标后面紧跟圆括号或方括号时，Typst 会把括号吞进下标，渲染出错误的公式
BAD_SUBSCRIPT_RE = re.compile(r"_[A-Za-z*0-9][\(\[]")
# @fig- 与 @tbl- 自带「图」「表」二字，引用前再写一遍就会渲染成「图 图 2.1」。
# @eq- 的补充字已在 template.typ 里设为 none，正文写不写「式」都对，故不列入本项。
DOUBLED_SUPPLEMENT_RE = re.compile(r"[图表]\s*@(?:fig|tbl)-")
# 正文里裸写公式编号，例如 (2.12)。这类编号与公式下方的自动编号各自独立，
# 公式编号一旦平移就会静默不一致，因此一律要求改写成 @eq-2-12 引用。
BARE_EQUATION_RE = re.compile(r"\([0-9]+\.[0-9]+\)")
CJK_RE = re.compile(r"[一-鿿]")
# 数学写在字符串里不会被渲染。第 7 章曾把章标题写成 #chapter("$n$ 步自举")，
# 结果标题、页眉、目录里都渲染出字面的美元符号加字母。编译不报错，只有看渲染才发现。
def find_math_in_strings(line):
    """找出字符串字面量中含 $ 的片段。

    不能用正则：数学模式里的引号（如 overline("BE")）与真字符串的引号同形，
    必须按字符推进状态，只在非数学状态下把 " 当作字符串的起止。
    """
    hits = []
    in_math = False
    in_string = False
    buf = []
    for ch in line:
        if in_string:
            if ch == '"':
                in_string = False
                text = "".join(buf)
                if "$" in text:
                    hits.append('"' + text + '"')
                buf = []
            else:
                buf.append(ch)
        elif ch == "$":
            in_math = not in_math
        elif ch == '"' and not in_math:
            in_string = True
            buf = []
    return hits

FRONT_MATTER = [
    ("preface-2nd", "第二版前言", "Preface to the Second Edition"),
    ("preface-1st", "第一版前言", "Preface to the First Edition"),
    ("notation", "符号表", "Summary of Notation"),
]

BACK_MATTER = [
    ("references", "参考文献", "References"),
]

# 三大部的分隔页。第四项写明该页插在哪一号章之前；该章还没翻译时整页暂不纳入。
PART_PAGES = [
    ("part-1", "第一部分　表格型解法", "Part I: Tabular Solution Methods", 1),
    ("part-2", "第二部分　近似解法", "Part II: Approximate Solution Methods", 9),
    ("part-3", "第三部分　深入探索", "Part III: Looking Deeper", 14),
]


def load_outline():
    if not CHAPTER_MAP.exists():
        sys.exit(f"缺少 {CHAPTER_MAP}，先运行 tools/pdfkit.py outline --json > work/chapter-map.json")
    return json.loads(CHAPTER_MAP.read_text(encoding="utf-8"))


def load_chapters():
    rows = load_outline()
    chapters = []
    for index, row in enumerate(rows):
        title = row["title"]
        is_chapter = False
        if row["level"] == 1 and title == "Introduction":
            is_chapter = True
        if row["level"] == 2:
            # 只有三大分部之下的小节才是章
            for back in range(index - 1, -1, -1):
                if rows[back]["level"] == 1:
                    is_chapter = rows[back]["title"].startswith(PART_PREFIXES)
                    break
        if is_chapter:
            chapters.append(
                {
                    "title": title,
                    "pdf_start": row["pdf_page"],
                    "book_start": row["book_page"],
                }
            )
    # 正文的结束位置是下一个一级条目（References、Index），不是文档末尾
    tail = None
    for row in rows:
        if row["level"] == 1 and not row["title"].startswith(PART_PREFIXES):
            if row["title"] not in ("Introduction",) and row["pdf_page"] > chapters[-1]["pdf_start"]:
                tail = row["pdf_page"]
                break

    for index, chapter in enumerate(chapters):
        number = index + 1
        chapter["number"] = number
        chapter["dir"] = f"ch{number:02d}"
        if index + 1 < len(chapters):
            chapter["pdf_end"] = chapters[index + 1]["pdf_start"] - 1
        else:
            chapter["pdf_end"] = (tail - 1) if tail else rows[-1]["pdf_page"]
        chapter["book_end"] = chapter["pdf_end"] - 22
    return chapters


def chapter_sections(title):
    """从书签里取出该章的下一级小节标题。"""
    rows = load_outline()
    for index, row in enumerate(rows):
        if row["title"] != title:
            continue
        level = row["level"]
        sections = []
        for following in rows[index + 1 :]:
            if following["level"] <= level:
                break
            if following["level"] == level + 1:
                sections.append(following["title"])
        return sections
    return []


def chapter_dir(number):
    return ROOT / "chapters" / f"ch{number:02d}"


def chapter_files(number):
    directory = chapter_dir(number)
    if not directory.exists():
        return []
    return sorted(directory.glob("*.typ"))


def chapter_title_from_file(number):
    entry = ROOT / "chapters" / f"ch{number:02d}.typ"
    if not entry.exists():
        return None
    for line in entry.read_text(encoding="utf-8").splitlines():
        match = CHAPTER_RE.match(line.strip())
        if match:
            return (match.group(1) or match.group(2)).strip()
    return None


def cmd_make_previews(args):
    targets = []
    for name, zh, _en in FRONT_MATTER:
        source = ROOT / "frontmatter" / f"{name}.typ"
        if source.exists():
            targets.append((f"frontmatter-{name}", source.relative_to(ROOT).as_posix()))
    for name, zh, _en in BACK_MATTER:
        source = ROOT / "backmatter" / f"{name}.typ"
        if source.exists():
            targets.append((f"backmatter-{name}", source.relative_to(ROOT).as_posix()))
    for name, _zh, _en, _number in PART_PAGES:
        source = ROOT / "parts" / f"{name}.typ"
        if source.exists():
            targets.append((f"parts-{name}", source.relative_to(ROOT).as_posix()))
    for chapter in load_chapters():
        entry = ROOT / "chapters" / f"{chapter['dir']}.typ"
        if entry.exists():
            targets.append((chapter["dir"], entry.relative_to(ROOT).as_posix()))

    outdir = ROOT / "preview"
    outdir.mkdir(exist_ok=True)
    for name, relative in targets:
        body = (
            '#import "../template.typ": *\n\n'
            "#show: book\n\n"
            f'#include "../{relative}"\n'
        )
        (outdir / f"{name}.typ").write_text(body, encoding="utf-8")
        print(f"preview/{name}.typ  ->  {relative}")
    if not targets:
        print("还没有任何可预览的文件")


def cmd_make_book(args):
    chapters = load_chapters()
    present = [c for c in chapters if (ROOT / "chapters" / f"{c['dir']}.typ").exists()]
    lines = [
        '#import "template.typ": *',
        "",
        '#show: book.with(',
        '  title: "强化学习导论",',
        '  edition: "第二版",',
        '  authors: ("Richard S. Sutton", "Andrew G. Barto"),',
        ")",
        "",
        "#title-page()",
        "",
        "#contents()",
        "",
    ]
    for name, _zh, _en in FRONT_MATTER:
        source = ROOT / "frontmatter" / f"{name}.typ"
        if source.exists():
            lines.append(f'#include "frontmatter/{name}.typ"')
    lines.append("")
    included_parts = []
    for chapter in present:
        for name, _zh, _en, before in PART_PAGES:
            source = ROOT / "parts" / f"{name}.typ"
            if before == chapter["number"] and source.exists():
                lines.append(f'#include "parts/{name}.typ"')
                lines.append("")
                included_parts.append(name)
        lines.append(f'#include "chapters/{chapter["dir"]}.typ"')
        lines.append("")
    for name, _zh, _en in BACK_MATTER:
        source = ROOT / "backmatter" / f"{name}.typ"
        if source.exists():
            lines.append(f'#include "backmatter/{name}.typ"')
            lines.append("")
    (ROOT / "book.typ").write_text("\n".join(lines), encoding="utf-8")
    print(
        f"book.typ 已生成，纳入 {len(present)} 章，共 {len(chapters)} 章，"
        f"分部页 {len(included_parts)}/{len(PART_PAGES)}"
    )
    missing = [c["dir"] for c in chapters if c not in present]
    if missing:
        print("尚未翻译：" + "、".join(missing))
    pending_parts = [name for name, _zh, _en, _n in PART_PAGES if name not in included_parts]
    if pending_parts:
        print("分部页尚未落位（其后的那一章还没翻译）：" + "、".join(pending_parts))


def cmd_status(args):
    chapters = load_chapters()
    done = 0
    for chapter in chapters:
        entry = (ROOT / "chapters" / f"{chapter['dir']}.typ").exists()
        files = chapter_files(chapter["number"])
        expected = len(chapter_sections(chapter["title"]))
        actual = sum(
            len(SECTION_RE.findall(f.read_text(encoding="utf-8"))) for f in files
        )
        title = chapter_title_from_file(chapter["number"]) or chapter["title"]
        state = "已完成" if entry and actual >= expected else ("进行中" if entry else "未开始")
        if state == "已完成":
            done += 1
        print(
            f"{chapter['dir']}  {state}  "
            f"PDF {chapter['pdf_start']}-{chapter['pdf_end']}  "
            f"小节 {actual}/{expected}  {title}"
        )
    print(f"\n共 {len(chapters)} 章，已完成 {done} 章")


def cmd_check_coverage(args):
    chapters = load_chapters()
    problems = 0
    for chapter in chapters:
        number = chapter["number"]
        entry = ROOT / "chapters" / f"ch{number:02d}.typ"
        if not entry.exists():
            print(f"{chapter['dir']}  缺少章索引文件 {entry.name}")
            problems += 1
            continue
        files = chapter_files(number)
        actual = sum(len(SECTION_RE.findall(f.read_text(encoding="utf-8"))) for f in files)
        expected = len(chapter_sections(chapter["title"]))
        if actual != expected:
            print(
                f"{chapter['dir']}  小节数量不符：原书 {expected} 个，译文 {actual} 个"
            )
            problems += 1
    if problems == 0:
        print(f"章节完整，{len(chapters)} 章全部就位，小节数量逐一吻合")
    return problems


def cmd_check_terms(args):
    config = yaml.safe_load(TERMS.read_text(encoding="utf-8"))
    forbidden = config.get("forbidden", [])
    artifacts = config.get("artifacts", [])

    targets = []
    for folder in ("chapters", "parts", "frontmatter", "backmatter", "glossary"):
        targets += sorted((ROOT / folder).rglob("*.typ"))

    problems = 0
    for path in targets:
        text = path.read_text(encoding="utf-8")
        relative = path.relative_to(ROOT)
        lines = text.splitlines()
        for rule in forbidden:
            wrong = rule["wrong"]
            for index, line in enumerate(lines, start=1):
                if wrong in line:
                    print(
                        f"{relative}:{index}  出现「{wrong}」，应改为「{rule['right']}」：{rule['why']}"
                    )
                    problems += 1
        for char in artifacts:
            for index, line in enumerate(lines, start=1):
                if char in line:
                    print(
                        f"{relative}:{index}  出现源 PDF 的损坏字符 {char!r}，连字修复未完成"
                    )
                    problems += 1
        # 只扫含 $ 的行，且跳过 #let 定义行，避免把函数名里的下划线当成数学下标
        for index, line in enumerate(lines, start=1):
            if "$" not in line or line.lstrip().startswith("#let"):
                continue
            for match in BAD_SUBSCRIPT_RE.finditer(line):
                print(
                    f"{relative}:{index}  下标后紧跟括号 {match.group()!r}，"
                    f"括号会被吞进下标，中间须留一个空格"
                )
                problems += 1
        for index, line in enumerate(lines, start=1):
            for match in DOUBLED_SUPPLEMENT_RE.finditer(line):
                print(
                    f"{relative}:{index}  {match.group()!r} 会渲染成重复的"
                    f"「图 图」「表 表」，@fig- @tbl- 自带图字表字，删掉前面那个"
                )
                problems += 1
        for index, line in enumerate(lines, start=1):
            stripped = line.lstrip()
            if stripped.startswith("//") or stripped.startswith("#let"):
                continue
            for hit in find_math_in_strings(line):
                print(
                    f"{relative}:{index}  字符串里出现数学 {hit!r}，"
                    f"字符串不解析数学，会渲染出字面的美元符号，改用内容块 [...]"
                )
                problems += 1
        # 只查含中文的正文行，避开数学与代码；numbered-with-chapter 的编号格式串不是引用
        for index, line in enumerate(lines, start=1):
            if not CJK_RE.search(line) or "numbered-with-chapter" in line:
                continue
            for match in BARE_EQUATION_RE.finditer(line):
                print(
                    f"{relative}:{index}  正文裸写公式编号 {match.group()!r}，"
                    f"改用引用 @eq-{match.group()[1:-1].replace('.', '-')}，"
                    f"外观相同但由同一个计数器渲染"
                )
                problems += 1
    if problems == 0:
        print(f"术语检查通过，扫描 {len(targets)} 个文件未发现问题")
    else:
        print(f"\n共 {problems} 处问题")
    return problems


# 原书正文栏宽，单位为 PDF point（实测正文文字块横跨 43.2 到 424.8 点）
BOOK_COLUMN_WIDTH = 381.6


def cmd_figure_widths(args):
    """按原书里插图占正文栏宽的比例，给出 #figure 应填的 width 百分比。"""
    found = False
    for chapter in load_chapters():
        if args.chapter is not None and chapter["number"] != args.chapter:
            continue
        path = ROOT / "work" / chapter["dir"] / "figures.json"
        if not path.exists():
            continue
        for figure in json.loads(path.read_text(encoding="utf-8")):
            bbox = figure.get("bbox")
            if not bbox:
                continue
            width = bbox[2] - bbox[0]
            # 少数插图在原书里略微超出栏宽，上限取 100%
            percent = min(width / BOOK_COLUMN_WIDTH * 100, 100)
            print(
                f'{chapter["dir"]}  {figure["label"]:<14} '
                f"原书占栏宽 {width:5.1f} 点  ->  width: {percent:.0f}%"
            )
            found = True
    if not found:
        print("没有找到 figures.json，提取阶段尚未产出")


def main():
    parser = argparse.ArgumentParser(description="整书组装与一致性检查")
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("make-previews", help="为每章生成单章编译入口").set_defaults(
        func=cmd_make_previews
    )
    sub.add_parser("make-book", help="生成 book.typ 整合入口").set_defaults(
        func=cmd_make_book
    )
    sub.add_parser("status", help="显示各章进度").set_defaults(func=cmd_status)
    sub.add_parser("check-coverage", help="比对原书小节与译文小节").set_defaults(
        func=cmd_check_coverage
    )
    sub.add_parser("check-terms", help="扫描禁用译名与损坏字符").set_defaults(
        func=cmd_check_terms
    )
    p = sub.add_parser("figure-widths", help="按原书比例给出插图 width 百分比")
    p.add_argument("--chapter", type=int, help="只列某一章")
    p.set_defaults(func=cmd_figure_widths)

    args = parser.parse_args()
    result = args.func(args)
    if isinstance(result, int) and result != 0:
        sys.exit(1)


if __name__ == "__main__":
    main()
