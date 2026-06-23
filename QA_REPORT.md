# CreativEX2026 Knowledge Platform QA Report

Date: 2026-06-20

## Scope

This QA report covers the local static showcase update prepared for deployment to:

https://creativex2026-sharing.vercel.app

## Deployment Audit Baseline

The current deployed site was checked at:

https://creativex2026-sharing.vercel.app/#dashboard

Findings:

- Page title is present: `CreativEX2026 Knowledge Platform | Place Branding สำหรับภาครัฐ`
- Meta description is present.
- No browser console errors were observed during the deployed-page audit.
- Existing hash sections include `#hero`, `#brief`, `#summary`, `#sessions`, `#framework`, `#dashboard`, `#roadmap`, and `#observatory`.
- Canonical URL was missing on the deployed page at audit time.

## Implemented Routes

- `/`
- `/#dashboard`
- `/#knowledge`
- `/#speakers`
- `/#impact`
- `/#downloads`
- `/speaker-unesco-creative-cities.html`
- `/speaker-tech-driven-creative-organization.html`
- `/speaker-uk-creative-industries.html`
- `/impact-evaluation-framework.html`
- `/sitemap.xml`
- `/robots.txt`

## Feature QA Checklist

- Knowledge Library: Added structured resource cards with categories, status labels, and article links.
- Search: Added client-side search across title, summary, owner, category, and status. Tested with `UNESCO`; returned `UNESCO Creative Cities`.
- Speaker Knowledge Pages: Added pages for UNESCO Creative Cities, Tech Driven Creative Organization, and UK Creative Industries.
- Impact Evaluation Framework: Added summary section and full framework page.
- Downloadable Resources: Added PDF, DOCX, and PPTX files under `/downloads`.
- Dashboard: Added local metrics for knowledge articles, downloads, visitors, and search queries.
- SEO: Added meta description, robots meta, canonical URL, Open Graph title/description/type/url, sitemap, and robots.txt.
- Showcase polish: Updated the hero, navigation, and proof strip so the first screen presents a coherent portfolio-ready platform rather than an internal audit page.

## Local Route Verification

All checked routes returned HTTP 200 from the local preview server:

- `/` - `200 text/html`
- `/speaker-unesco-creative-cities.html` - `200 text/html`
- `/speaker-tech-driven-creative-organization.html` - `200 text/html`
- `/speaker-uk-creative-industries.html` - `200 text/html`
- `/impact-evaluation-framework.html` - `200 text/html`
- `/sitemap.xml` - `200 application/xml`
- `/robots.txt` - `200 text/plain`
- `/downloads/creativex2026-knowledge-brief.pdf` - `200 application/pdf`
- `/downloads/creativex2026-impact-worksheet.docx` - `200 application/vnd.openxmlformats-officedocument.wordprocessingml.document`
- `/downloads/creativex2026-knowledge-sharing-deck.pptx` - `200 application/vnd.openxmlformats-officedocument.presentationml.presentation`

## Browser QA

- Main page loaded successfully in the in-app browser.
- Main page title verified as `CreativEX2026 Knowledge Platform | Showcase`.
- Hero verified as `แพลตฟอร์มความรู้ที่เปลี่ยนบทเรียนให้เป็นผลงานและผลกระทบ`.
- Sections verified: `dashboard`, `knowledge`, `speakers`, `impact`, `downloads`, `executives`, `portfolio`, `upload`.
- Search for `UNESCO` returned one matching result.
- Dashboard showed downloadable resources count as `3`.
- Internal Route Audit is not shown in the user-facing UI.
- Kamakaben route verified locally at `/kamakaben.html`; page has title, meta description, canonical URL, 5 scent territory cards, and 6 learning journey steps.
- Kamakaben scent card routes added for Rain On Teak, Jasmine At Dusk, Temple Morning, River Market, and Golden Field.
- Kamakaben Global Brand Profile PDF generated under `/downloads`.
- Kamakaben SVG scent access cards generated under `/assets/kamakaben`.
- Kamakaben Global Scent Passport added for local scent memory and learning entries.
- Partner outreach pack and global market entry plan added for go-to-market execution.
- Kamakaben UX Research Booklet added as an academic companion and UX seed resource:
  - `/downloads/kamakaben-ux-research-booklet.html`
  - `/downloads/kamakaben-ux-research-booklet.docx`
  - `/kamakaben-ux-research-booklet.md`
  - Quick Look thumbnail QA confirmed Thai text renders correctly in the HTML booklet. LibreOffice DOCX-to-PDF rendering dropped Thai glyphs in this environment, so the HTML booklet is the primary visually verified shareable version here.
- Kamakaben UX/UI layer added:
  - `/kamakaben.html#ux-lab` now includes a 4-step Scent Lab flow and UX pilot metric preview.
  - `/kamakaben-scent-passport.html` now captures Memory Fit, Emotional Shift, and Cultural Recall scores.
  - Passport archive now shows summary metrics and per-entry score pills.
  - Local browser QA confirmed the UX Lab section renders, the booklet link exists, Passport form submission creates an entry, score pills render, no console errors appear, and horizontal overflow is not detected.
- Karmakamet Manus benchmark reviewed at `https://karmakamet-5qns9jr6.manus.space`:
  - Page is live and returns `200`.
  - Browser audit found hero, four navigation anchors, four value pillars, six image assets, no console errors, and no horizontal overflow.
  - Full-page screenshot saved under `/downloads/karmakamet-manus-benchmark-screenshot.png`.
  - Benchmark note created at `/kamakaben-karmakamet-benchmark.md`.
- Scent Passport route and script serve successfully; passport form controls and archive container are present; `kamakaben-passport.js` passes syntax check. Browser QA submitted one local entry and verified archive rendering plus score summary output.
- No browser console errors were observed after local QA.
- No horizontal overflow was detected at the tested desktop viewport.

## Known Deployment Notes

- This workspace is not currently a git repository, so a real Pull Request cannot be opened from here.
- The deployment URL will remain the current Vercel URL after the updated files are pushed and redeployed.
- Visitor and search metrics are client-side/local prototype metrics. Production analytics should use Vercel Analytics, Plausible, Google Analytics, or a database-backed event table.
- The download files are starter resources and can be replaced with final branded versions later.

## Recommended Post-Deploy Checks

1. Open `https://creativex2026-sharing.vercel.app/`.
2. Confirm all navigation links scroll or route correctly.
3. Search for `UNESCO`, `Tech`, and `Impact`.
4. Download PDF, DOCX, and PPTX resources.
5. Open each speaker page and the impact framework page.
6. Check `https://creativex2026-sharing.vercel.app/sitemap.xml`.
7. Check `https://creativex2026-sharing.vercel.app/robots.txt`.
