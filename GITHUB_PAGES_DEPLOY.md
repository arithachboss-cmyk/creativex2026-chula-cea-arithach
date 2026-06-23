# GitHub Pages Deploy Notes

Prepared on 2026-06-24.

## Current Status

The site is ready to publish as a static GitHub Pages website.

Prepared files:

- `.nojekyll`
- `.gitignore`
- `README.md`

## Recommended Repository Name

`creativex2026-chula-cea-arithach`

## Publish Commands

Use these commands after creating an empty GitHub repository:

```bash
cd "/Users/arithachbossabc/Documents/CreativEX2026 Chula CEA Arithach"
git remote add origin https://github.com/<github-username>/creativex2026-chula-cea-arithach.git
git push -u origin main
```

Then open GitHub repository settings:

1. `Settings`
2. `Pages`
3. `Build and deployment`
4. `Source`: `Deploy from a branch`
5. `Branch`: `main`
6. Folder: `/ (root)`

The published site will be:

`https://<github-username>.github.io/creativex2026-chula-cea-arithach/`

## Important Note

GitHub Pages sites are public on the internet. Do not publish private keys, passwords, or confidential personal data.
