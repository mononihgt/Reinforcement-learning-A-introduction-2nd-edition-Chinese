import argparse
import json
import re
import sys
from pathlib import Path

import pymupdf

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_PDF = ROOT.parent / "Reinforcement learning-A introduction 2nd edition.pdf"

# 原书由 LaTeX 排版，正文与数学出自不同字体族。文字层里同一个码位在两类
# 字体中的含义不同（例如 ↵ 在正文里是 ff 连字，在数学里是 α），因此必须按
# 字体把文本流分开，后续处理才能各走各的通道。
MATH_FONT_PREFIXES = (
    "CMMI", "CMSY", "CMEX", "CMBSY", "MSBM", "MSAM", "MSAP", "EUSM", "EUFM", "EUM",
)
TEXT_FONT_PREFIXES = (
    "CMR", "CMBX", "CMTI", "CMTT", "CMSS", "SFRM", "SFSX", "SFTT", "CMB",
)

CAPTION_RE = re.compile(r"^(Figure|Table|Algorithm|Example)\s+(\d+\.\d+)")

# 实测关系：原书页码 = PDF 页码 - 22。前言占 PDF 第 1 至 22 页，正文从 PDF 第 23 页
# （原书第 1 页）开始。该书第 37 页出现在 PDF 第 59 页，与此关系一致。
PAGE_OFFSET = 22


def open_pdf(path):
    return pymupdf.open(path)


def base_font(name):
    if not name:
        return ""
    if "+" in name:
        name = name.split("+", 1)[1]
    return name


def font_kind(name):
    base = base_font(name).upper()
    for prefix in MATH_FONT_PREFIXES:
        if base.startswith(prefix):
            return "math"
    for prefix in TEXT_FONT_PREFIXES:
        if base.startswith(prefix):
            return "text"
    return "other"


def get_page(doc, number):
    # 对外一律用 1 起始的 PDF 页码
    if number < 1 or number > doc.page_count:
        sys.exit(f"页码 {number} 超出范围，本文档共 {doc.page_count} 页")
    return doc[number - 1]


def iter_lines(page):
    data = page.get_text("dict", sort=True)
    for block in data["blocks"]:
        if block.get("type") != 0:
            continue
        for line in block["lines"]:
            yield block, line


def visible_spans(line):
    # 判定字体类别时忽略纯空白片段，重建文字时不能丢，否则词间空格全部消失
    return [s for s in line["spans"] if s["text"].strip()]


def classify_line(line):
    kinds = {font_kind(s["font"]) for s in visible_spans(line)}
    if not kinds:
        return "empty"
    if kinds == {"text"}:
        return "text"
    if kinds == {"math"}:
        return "math"
    return "mixed"


def line_text(line):
    return "".join(s["text"] for s in line["spans"])


def annotated_line(line):
    parts = []
    last_kind = None
    for span in line["spans"]:
        if not span["text"].strip() and last_kind is None:
            continue
        kind = font_kind(span["font"])
        if kind != last_kind:
            parts.append(f"⟪{kind}:{base_font(span['font'])}⟫")
            last_kind = kind
        parts.append(span["text"])
    return "".join(parts).rstrip()


def column_width(doc, page):
    widest = 0.0
    for block in page.get_text("dict", sort=True)["blocks"]:
        if block.get("type") != 0 or not block.get("lines"):
            continue
        if classify_line(block["lines"][0]) == "math":
            continue
        widest = max(widest, block["bbox"][2] - block["bbox"][0])
    return widest


SECTION_RE = re.compile(r"^\*?\d+(\.\d+)*\s+\S")


def block_role(block, width, page_rect):
    lines = block["lines"]
    first_spans = visible_spans(lines[0])
    if not first_spans:
        return "display"
    text = line_text(lines[0]).strip()
    x0, y0, x1, y1 = block["bbox"]

    # 页眉位于顶部页边距内，不进译文
    if y1 < 62:
        return "header"
    # 节标题用粗体，且以小节号开头
    if base_font(first_spans[0]["font"]).upper().startswith("CMBX"):
        return "prose"
    if SECTION_RE.match(text):
        return "prose"
    # 图表例题的题注按行文处理
    if CAPTION_RE.match(text):
        return "prose"
    # 页脚小字号脚注属于正文
    if y0 > page_rect.height - 95 and first_spans[0]["size"] <= 8.5:
        return "prose"
    kind = classify_line(lines[0])
    if kind in ("text", "mixed") and width and (x1 - x0) >= 0.85 * width:
        return "prose"
    return "display"


def cmd_outline(args):
    doc = open_pdf(args.pdf)
    toc = doc.get_toc(simple=True)
    rows = [
        {"level": lvl, "title": title, "pdf_page": page, "book_page": page - PAGE_OFFSET}
        for lvl, title, page in toc
    ]
    if args.json:
        print(json.dumps(rows, ensure_ascii=False, indent=2))
        return
    for row in rows:
        indent = "  " * (row["level"] - 1)
        print(f"{indent}[{row['level']}] p{row['pdf_page']}  {row['title']}")


def cmd_text(args):
    doc = open_pdf(args.pdf)
    page = get_page(doc, args.page)
    if args.json:
        out = []
        for block, line in iter_lines(page):
            spans = [
                {
                    "text": s["text"],
                    "font": base_font(s["font"]),
                    "kind": font_kind(s["font"]),
                    "bbox": [round(v, 1) for v in s["bbox"]],
                }
                for s in line["spans"]
            ]
            out.append(
                {
                    "bbox": [round(v, 1) for v in line["bbox"]],
                    "kind": classify_line(line),
                    "spans": spans,
                }
            )
        print(json.dumps(out, ensure_ascii=False, indent=2))
        return

    width = column_width(doc, page)
    prose = []
    display = []
    for block in page.get_text("dict", sort=True)["blocks"]:
        if block.get("type") != 0 or not block.get("lines"):
            continue
        role = block_role(block, width, page.rect)
        if role == "header":
            continue
        target = prose if role == "prose" else display
        for line in block["lines"]:
            text = annotated_line(line)
            if text:
                target.append((block["bbox"], text))

    print(f"===== PDF 第 {args.page} 页（原书第 {args.page - 22} 页）=====")
    print("--- 正文（阅读顺序可靠）---")
    for bbox, text in prose:
        print(f"[y{bbox[1]:.0f}] {text}")
    if display:
        print("--- 显示公式与图表文字碎片（位置分散，顺序不可靠，须对照页面图重建）---")
        for bbox, text in display:
            print(f"[x{bbox[0]:.0f} y{bbox[1]:.0f}] {text}")


def cmd_blocks(args):
    doc = open_pdf(args.pdf)
    page = get_page(doc, args.page)
    rows = []
    data = page.get_text("dict", sort=True)
    for block in data["blocks"]:
        bbox = [round(v, 1) for v in block["bbox"]]
        if block.get("type") == 0:
            first = ""
            for line in block["lines"]:
                for span in visible_spans(line):
                    first = span["text"].strip()
                    break
                if first:
                    break
            rows.append(
                {
                    "type": "text",
                    "bbox": bbox,
                    "kind": classify_line(block["lines"][0]) if block.get("lines") else "empty",
                    "preview": first[:70],
                }
            )
        elif block.get("type") == 1:
            rows.append(
                {
                    "type": "image",
                    "bbox": bbox,
                    "pixels": [block.get("width"), block.get("height")],
                }
            )
    for info in page.get_image_info():
        bbox = [round(v, 1) for v in info["bbox"]]
        if not any(r["type"] == "image" and r["bbox"] == bbox for r in rows):
            rows.append({"type": "image-block", "bbox": bbox})
    for drawing in page.get_drawings():
        bbox = [round(v, 1) for v in drawing["rect"]]
        rows.append({"type": "drawing", "bbox": bbox, "items": len(drawing["items"])})

    rows.sort(key=lambda r: (r["bbox"][1], r["bbox"][0]))
    print(json.dumps(rows, ensure_ascii=False, indent=2))


def cmd_find(args):
    doc = open_pdf(args.pdf)
    page = get_page(doc, args.page)
    hits = page.search_for(args.text)
    if not hits:
        print(f"未找到 {args.text!r}")
        return
    for rect in hits:
        print(f"{args.text!r} -> bbox=[{rect.x0:.1f}, {rect.y0:.1f}, {rect.x1:.1f}, {rect.y1:.1f}]")


def merge_rects(rects, gap=6.0):
    merged = []
    for rect in sorted(rects, key=lambda r: (r.y0, r.x0)):
        current = pymupdf.Rect(rect)
        for index, existing in enumerate(merged):
            probe = pymupdf.Rect(existing)
            probe.x0 -= gap
            probe.y0 -= gap
            probe.x1 += gap
            probe.y1 += gap
            if probe.intersects(current):
                merged[index] = existing | current
                break
        else:
            merged.append(current)
    return merged


def find_captions(page):
    rows = []
    for block, line in iter_lines(page):
        text = line_text(line).strip()
        match = CAPTION_RE.match(text)
        if match:
            rows.append(
                {
                    "label": f"{match.group(1)} {match.group(2)}",
                    "bbox": pymupdf.Rect(line["bbox"]),
                }
            )
    return rows


def cmd_figure_regions(args):
    doc = open_pdf(args.pdf)
    page = get_page(doc, args.page)
    page_rect = page.rect

    graphics = []
    for info in page.get_image_info():
        graphics.append(pymupdf.Rect(info["bbox"]))
    for drawing in page.get_drawings():
        rect = pymupdf.Rect(drawing["rect"])
        if rect.get_area() > page_rect.get_area() * 0.9:
            continue
        if rect.width < 8 or rect.height < 8:
            continue
        graphics.append(rect)

    text_blocks = []
    for block in page.get_text("dict", sort=True)["blocks"]:
        if block.get("type") != 0:
            continue
        rect = pymupdf.Rect(block["bbox"])
        # 插图内部的坐标轴刻度、图例、标题使用绘图软件自带的字体，与全书正文的
        # Computer Modern 字体不同。这些文字块属于插图，必须并入候选区域，
        # 否则坐标轴刻度会被裁掉；同时它们不计入正文重叠比例。
        spans = [s for line in block["lines"] for s in line["spans"] if s["text"].strip()]
        if spans and all(font_kind(s["font"]) == "other" for s in spans):
            graphics.append(rect)
        else:
            text_blocks.append(rect)

    clusters = merge_rects(graphics, gap=10.0)

    captions = find_captions(page)

    regions = []
    for cluster in clusters:
        area = cluster.get_area()
        if area < 4000:
            continue
        covered = 0.0
        for tb in text_blocks:
            inter = cluster & tb
            if not inter.is_empty:
                covered += inter.get_area()
        text_ratio = covered / area if area else 1.0
        if text_ratio > 0.5:
            continue
        caption = None
        for cap in captions:
            probe = pymupdf.Rect(cap["bbox"])
            probe.x0 = cluster.x0 - 10
            probe.x1 = cluster.x1 + 10
            probe.y0 = cluster.y0 - 60
            probe.y1 = cluster.y1 + 60
            if probe.intersects(pymupdf.Rect(cap["bbox"])):
                caption = cap["label"]
                break
        regions.append(
            {
                "bbox": [round(v, 1) for v in cluster],
                "width": round(cluster.width, 1),
                "height": round(cluster.height, 1),
                "caption": caption,
                "text_overlap_ratio": round(text_ratio, 3),
            }
        )

    regions.sort(key=lambda r: -r["width"] * r["height"])
    print(
        json.dumps(
            {
                "pdf_page": args.page,
                "book_page": args.page - 22,
                "page_size": [round(page_rect.width, 1), round(page_rect.height, 1)],
                "captions": [
                    {"label": c["label"], "bbox": [round(v, 1) for v in c["bbox"]]}
                    for c in captions
                ],
                "regions": regions,
            },
            ensure_ascii=False,
            indent=2,
        )
    )


def render(doc, page_number, dpi, out, clip=None, pad=0.0):
    page = get_page(doc, page_number)
    if clip is not None:
        rect = pymupdf.Rect(clip)
        if pad:
            rect = pymupdf.Rect(rect.x0 - pad, rect.y0 - pad, rect.x1 + pad, rect.y1 + pad)
        rect = rect & page.rect
    else:
        rect = page.rect
    pix = page.get_pixmap(dpi=dpi, clip=rect, colorspace=pymupdf.csRGB)
    out = Path(out)
    out.parent.mkdir(parents=True, exist_ok=True)
    pix.save(str(out))
    return out, pix.width, pix.height


def cmd_page_image(args):
    doc = open_pdf(args.pdf)
    out, width, height = render(doc, args.page, args.dpi, args.out)
    print(f"{out}  {width}x{height}")


def cmd_crop(args):
    doc = open_pdf(args.pdf)
    parts = [float(v) for v in args.bbox.split(",")]
    if len(parts) != 4:
        sys.exit("--bbox 需要四个数：x0,y0,x1,y1")
    if any(v < 0 for v in parts):
        sys.exit("--bbox 的坐标不得为负。裁剪区域会自动与页面求交，负数没有意义。")
    out, width, height = render(doc, args.page, args.dpi, args.out, clip=parts, pad=args.pad)
    print(f"{out}  {width}x{height}  bbox={parts}")


def cmd_render_pages(args):
    doc = open_pdf(args.pdf)
    outdir = Path(args.outdir)
    outdir.mkdir(parents=True, exist_ok=True)
    first = args.first or 1
    last = args.last or doc.page_count
    for number in range(first, last + 1):
        out = outdir / f"p{number:04d}.png"
        if out.exists() and not args.force:
            continue
        _out, width, height = render(doc, number, args.dpi, out)
        print(f"{out}  {width}x{height}", flush=True)


def main():
    parser = argparse.ArgumentParser(description="源 PDF 的提取与渲染工具")
    parser.add_argument("--pdf", default=str(DEFAULT_PDF), help="源 PDF 路径")
    sub = parser.add_subparsers(dest="command", required=True)

    p = sub.add_parser("outline", help="打印书签树与页码")
    p.add_argument("--json", action="store_true")
    p.set_defaults(func=cmd_outline)

    p = sub.add_parser("text", help="提取单页文字，标注每段的字体类别")
    p.add_argument("--page", type=int, required=True)
    p.add_argument("--json", action="store_true")
    p.set_defaults(func=cmd_text)

    p = sub.add_parser("blocks", help="打印页面内文字块、位图块、矢量图形块的边界框")
    p.add_argument("--page", type=int, required=True)
    p.set_defaults(func=cmd_blocks)

    p = sub.add_parser("find", help="定位字符串所在矩形")
    p.add_argument("--page", type=int, required=True)
    p.add_argument("--text", required=True)
    p.set_defaults(func=cmd_find)

    p = sub.add_parser("figure-regions", help="给出该页候选插图区域")
    p.add_argument("--page", type=int, required=True)
    p.set_defaults(func=cmd_figure_regions)

    p = sub.add_parser("page-image", help="渲染整页为 PNG")
    p.add_argument("--page", type=int, required=True)
    p.add_argument("--dpi", type=int, default=150)
    p.add_argument("--out", required=True)
    p.set_defaults(func=cmd_page_image)

    p = sub.add_parser("crop", help="把页面某区域裁成图片")
    p.add_argument("--page", type=int, required=True)
    p.add_argument("--bbox", required=True, help="x0,y0,x1,y1，单位为 PDF point")
    p.add_argument("--dpi", type=int, default=400)
    p.add_argument("--pad", type=float, default=0.0)
    p.add_argument("--out", required=True)
    p.set_defaults(func=cmd_crop)

    p = sub.add_parser("render-pages", help="批量渲染页面")
    p.add_argument("--first", type=int)
    p.add_argument("--last", type=int)
    p.add_argument("--dpi", type=int, default=150)
    p.add_argument("--outdir", required=True)
    p.add_argument("--force", action="store_true")
    p.set_defaults(func=cmd_render_pages)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
