import fs from "node:fs/promises";
import { fileURLToPath } from "node:url";
import { Presentation, PresentationFile } from "/Users/arithachbossabc/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/@oai/artifact-tool/dist/artifact_tool.mjs";

const root = fileURLToPath(new URL("../", import.meta.url));
const downloads = new URL("downloads/", new URL("../", import.meta.url));
await fs.mkdir(fileURLToPath(downloads), { recursive: true });

const presentation = Presentation.create({
  slideSize: { width: 1280, height: 720 },
});

const slides = [
  {
    eyebrow: "CREATIVEX2026",
    title: "Knowledge Sharing Platform",
    body: "A shared hub for knowledge articles, speaker pages, downloads, dashboard metrics, and impact evaluation.",
  },
  {
    eyebrow: "CORE MODULES",
    title: "From Learning to Impact",
    body: "Knowledge Library, Search, Speaker Knowledge Pages, Downloads, Dashboard, and Impact Evaluation Framework.",
  },
  {
    eyebrow: "DASHBOARD",
    title: "What Leaders Can Track",
    body: "Knowledge articles, downloadable resources, visitor activity, search queries, learning scores, and submitted portfolios.",
  },
];

for (const item of slides) {
  const slide = presentation.slides.add();
  slide.background.fill = "slate-50";
  const panel = slide.shapes.add({
    geometry: "roundRect",
    position: { left: 72, top: 64, width: 1136, height: 592 },
    fill: "white",
    line: { style: "solid", fill: "slate-200", width: 1 },
    borderRadius: "rounded-xl",
  });
  const eyebrow = slide.shapes.add({
    geometry: "textbox",
    position: { left: 124, top: 122, width: 420, height: 36 },
    fill: "none",
    line: { style: "solid", fill: "none", width: 0 },
  });
  eyebrow.text = item.eyebrow;
  eyebrow.text.style = { fontSize: 16, bold: true, color: "teal-700" };

  const title = slide.shapes.add({
    geometry: "textbox",
    position: { left: 124, top: 210, width: 760, height: 150 },
    fill: "none",
    line: { style: "solid", fill: "none", width: 0 },
  });
  title.text = item.title;
  title.text.style = { fontSize: 52, bold: true, color: "slate-950" };

  const body = slide.shapes.add({
    geometry: "textbox",
    position: { left: 124, top: 402, width: 840, height: 120 },
    fill: "none",
    line: { style: "solid", fill: "none", width: 0 },
  });
  body.text = item.body;
  body.text.style = { fontSize: 24, color: "slate-600" };

  const accent = slide.shapes.add({
    geometry: "rect",
    position: { left: 72, top: 64, width: 16, height: 592 },
    fill: "teal-700",
    line: { style: "solid", fill: "teal-700", width: 0 },
  });
  accent.name = "brand-accent";
  panel.name = "content-panel";
}

const pptx = await PresentationFile.exportPptx(presentation);
await pptx.save(fileURLToPath(new URL("creativex2026-knowledge-sharing-deck.pptx", downloads)));
