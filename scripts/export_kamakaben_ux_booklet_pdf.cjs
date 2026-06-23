const path = require("node:path");
const { pathToFileURL } = require("node:url");
const { chromium } = require("/Users/arithachbossabc/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright");

(async () => {
  const root = path.resolve(__dirname, "..");
  const htmlPath = path.join(root, "downloads", "kamakaben-ux-research-booklet.html");
  const pdfPath = path.join(root, "downloads", "kamakaben-ux-research-booklet.pdf");

  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({ viewport: { width: 1240, height: 1754 }, deviceScaleFactor: 1 });
  await page.goto(pathToFileURL(htmlPath).href, { waitUntil: "networkidle" });
  await page.pdf({
    path: pdfPath,
    format: "A4",
    printBackground: true,
    preferCSSPageSize: true,
  });
  await browser.close();

  console.log(pdfPath);
})();
