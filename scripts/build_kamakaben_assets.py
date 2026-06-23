from pathlib import Path
from xml.sax.saxutils import escape

from reportlab.lib import colors
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle


ROOT = Path(__file__).resolve().parents[1]
DOWNLOADS = ROOT / "downloads"
ASSETS = ROOT / "assets" / "kamakaben"
BASE_URL = "https://creativex2026-sharing.vercel.app"

SCENTS = [
    {
        "name": "Rain On Teak",
        "thai": "ฝนแรกบนบ้านไม้",
        "url": f"{BASE_URL}/kamakaben-rain-on-teak.html",
        "notes": "Wet earth, teak wood, soft rain, warm shadow",
    },
    {
        "name": "Jasmine At Dusk",
        "thai": "มะลิยามค่ำ",
        "url": f"{BASE_URL}/kamakaben-jasmine-at-dusk.html",
        "notes": "Jasmine, evening air, clean cotton, soft skin",
    },
    {
        "name": "Temple Morning",
        "thai": "แสงเช้าในพื้นที่ศักดิ์สิทธิ์",
        "url": f"{BASE_URL}/kamakaben-temple-morning.html",
        "notes": "Soft incense, banana leaf, white flowers, morning light",
    },
    {
        "name": "River Market",
        "thai": "ชีวิตริมน้ำ",
        "url": f"{BASE_URL}/kamakaben-river-market.html",
        "notes": "Thai herbs, citrus peel, spice, boat wood, river air",
    },
    {
        "name": "Golden Field",
        "thai": "ภูมิทัศน์ที่เลี้ยงประเทศ",
        "url": f"{BASE_URL}/kamakaben-golden-field.html",
        "notes": "Rice, dry grass, warm sun, field wind, soft grain",
    },
]


def slugify(name: str) -> str:
    return name.lower().replace(" ", "-")


def build_access_cards() -> None:
    ASSETS.mkdir(parents=True, exist_ok=True)
    for scent in SCENTS:
        slug = slugify(scent["name"])
        svg = f"""<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="1600" viewBox="0 0 1200 1600" role="img" aria-label="{escape(scent['name'])} scent access card">
  <rect width="1200" height="1600" fill="#fffaf0"/>
  <rect x="70" y="70" width="1060" height="1460" rx="34" fill="#2f2018"/>
  <circle cx="960" cy="260" r="170" fill="#6f4327" opacity="0.64"/>
  <circle cx="240" cy="1320" r="220" fill="#d8a451" opacity="0.24"/>
  <text x="130" y="170" fill="#d8a451" font-family="Arial, sans-serif" font-size="34" font-weight="700">KAMAKABEN SCENT CARD</text>
  <text x="130" y="360" fill="#fffaf0" font-family="Arial, sans-serif" font-size="92" font-weight="800">{escape(scent['name'])}</text>
  <text x="130" y="440" fill="#f1d08e" font-family="Arial, sans-serif" font-size="42" font-weight="700">{escape(scent['thai'])}</text>
  <foreignObject x="130" y="560" width="850" height="170">
    <div xmlns="http://www.w3.org/1999/xhtml" style="font-family: Arial, sans-serif; color: #fffaf0; font-size: 38px; line-height: 1.38;">{escape(scent['notes'])}</div>
  </foreignObject>
  <rect x="130" y="880" width="940" height="360" rx="26" fill="#fffaf0"/>
  <text x="180" y="970" fill="#2f2018" font-family="Arial, sans-serif" font-size="34" font-weight="800">SCAN / OPEN</text>
  <foreignObject x="180" y="1025" width="840" height="150">
    <div xmlns="http://www.w3.org/1999/xhtml" style="font-family: Arial, sans-serif; color: #2f2018; font-size: 31px; line-height: 1.3; word-break: break-word;">{escape(scent['url'])}</div>
  </foreignObject>
  <text x="130" y="1410" fill="#f1d08e" font-family="Arial, sans-serif" font-size="38" font-weight="800">Smell Thailand. Remember Yourself.</text>
  <text x="130" y="1470" fill="#fffaf0" font-family="Arial, sans-serif" font-size="28">QR matrix to be generated from the URL for production print.</text>
</svg>
"""
        (ASSETS / f"{slug}-access-card.svg").write_text(svg, encoding="utf-8")


def build_brand_profile_pdf() -> None:
    DOWNLOADS.mkdir(exist_ok=True)
    path = DOWNLOADS / "kamakaben-global-brand-profile.pdf"
    styles = getSampleStyleSheet()
    title = ParagraphStyle(
        "KamakabenTitle",
        parent=styles["Title"],
        fontName="Helvetica-Bold",
        fontSize=28,
        leading=34,
        textColor=colors.HexColor("#2f2018"),
        spaceAfter=18,
    )
    h2 = ParagraphStyle(
        "KamakabenH2",
        parent=styles["Heading2"],
        fontName="Helvetica-Bold",
        fontSize=15,
        leading=20,
        textColor=colors.HexColor("#6f4327"),
        spaceBefore=12,
        spaceAfter=8,
    )
    body = ParagraphStyle(
        "KamakabenBody",
        parent=styles["BodyText"],
        fontName="Helvetica",
        fontSize=10.5,
        leading=15,
        textColor=colors.HexColor("#201914"),
    )

    story = [
        Paragraph("Kamakaben Global Brand Profile", title),
        Paragraph("Smell Thailand. Remember Yourself.", h2),
        Paragraph(
            "Kamakaben is a Thai scent culture brand that turns fragrance into memory, ritual, learning, and emotional renewal. "
            "It is designed for global culture seekers, wellness explorers, creative spaces, hotels, museums, and partners who want Thailand to be experienced through scent.",
            body,
        ),
        Spacer(1, 0.18 * inch),
        Paragraph("What Kamakaben Builds", h2),
        Paragraph(
            "Kamakaben creates scent cards, home fragrance, room sprays, discovery kits, QR-linked knowledge journeys, workshops, and signature scent experiences for cultural spaces.",
            body,
        ),
        Spacer(1, 0.18 * inch),
        Paragraph("Signature Scent Territories", h2),
    ]

    table_data = [["Scent", "Cultural doorway", "Use case"]]
    table_data.extend(
        [
            ["Rain On Teak", "First rain, teak houses, wet earth", "Reset after heavy days"],
            ["Jasmine At Dusk", "Evening jasmine, tenderness, care", "Night ritual and gratitude"],
            ["Temple Morning", "Soft incense, flowers, morning light", "Intention setting"],
            ["River Market", "Herbs, spice, citrus, river life", "Creative exchange"],
            ["Golden Field", "Rice, warm grass, rural landscape", "Grounding and reflection"],
        ]
    )
    table = Table(table_data, colWidths=[1.55 * inch, 2.25 * inch, 2.0 * inch])
    table.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#2f2018")),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.HexColor("#fffaf0")),
                ("GRID", (0, 0), (-1, -1), 0.35, colors.HexColor("#e3d8cd")),
                ("PADDING", (0, 0), (-1, -1), 7),
                ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("FONTNAME", (0, 1), (-1, -1), "Helvetica"),
            ]
        )
    )
    story.extend(
        [
            table,
            Spacer(1, 0.18 * inch),
            Paragraph("Partnership Opportunities", h2),
            Paragraph(
                "Hotel signature scent, gallery or museum scent journey, tourism gift set, city branding activation, cultural diplomacy gift, retail discovery kit, and workshop experience.",
                body,
            ),
            Spacer(1, 0.18 * inch),
            Paragraph("Learning Model", h2),
            Paragraph(
                "Sense, Name, Decode, Ritualize, Reflect, Share. The experience begins with smell, then turns sensation into cultural learning and personal meaning.",
                body,
            ),
            Spacer(1, 0.18 * inch),
            Paragraph("Non-Medical Rehab Position", h2),
            Paragraph(
                "Kamakaben uses rehab to mean emotional reset, cultural reconnection, and learning recovery. It does not make medical treatment claims.",
                body,
            ),
        ]
    )

    doc = SimpleDocTemplate(str(path), pagesize=letter, rightMargin=54, leftMargin=54, topMargin=54, bottomMargin=54)
    doc.build(story)


if __name__ == "__main__":
    build_access_cards()
    build_brand_profile_pdf()
