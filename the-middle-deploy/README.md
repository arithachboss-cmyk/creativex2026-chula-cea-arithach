# The Middle Deploy Kit

Static deploy package for **The Middle / เดอะมิดเดิ้ล**.

This package is intentionally self-contained. It can be deployed to GitHub Pages, Vercel, Netlify, Cloudflare Pages, or any static host.

## Files

- `index.html` - deploy-ready website page.
- `show.html` - full-screen 16:9-style showcase page for presentation or video capture.
- `404.html` - fallback page for static hosting.
- `robots.txt` - crawler rule.
- `sitemap.xml` - basic sitemap placeholder.
- `vercel.json` - Vercel static routing config.
- `netlify.toml` - Netlify static routing config.
- `DEPLOY.md` - deployment instructions.

## Quick Local Preview

Open `index.html` directly in a browser.

If a local server is available:

```bash
cd the-middle-deploy
python3 -m http.server 4173
```

Then open:

```text
http://127.0.0.1:4173/
```

## Recommended Deploy Target

For fastest deployment, use GitHub Pages:

1. Create a repository named `the-middle`.
2. Upload all files from this `the-middle-deploy` folder.
3. In repository settings, enable Pages from the `main` branch root.
4. The site will become available at:

```text
https://the-middle-th.github.io/the-middle/
```
