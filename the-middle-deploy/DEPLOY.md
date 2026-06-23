# Deployment Guide

## Package

Deploy folder:

```text
the-middle-deploy/
```

Primary page:

```text
index.html
```

Showcase page:

```text
show.html
```

## Option 1: GitHub Pages

Use this when you want a stable public URL with simple static hosting.

Steps:

1. Create or open a GitHub repository.
2. Copy the contents of `the-middle-deploy/` into the repository root.
3. Commit and push.
4. Go to repository `Settings -> Pages`.
5. Set source to `Deploy from a branch`.
6. Choose branch `main` and folder `/root`.
7. Save.

Expected URL:

```text
https://the-middle-th.github.io/the-middle/
```

## Option 2: Vercel

Use this when you want quick preview URLs and future custom domain support.

Steps:

1. Import the repository into Vercel.
2. Set the project root to `the-middle-deploy` if deploying from this larger workspace.
3. Leave build command empty.
4. Leave output directory empty or set it to `.`.
5. Deploy.

The included `vercel.json` handles static routing.

## Option 3: Netlify

Use this for simple static hosting with form/domain options.

Steps:

1. Create a new Netlify site.
2. Drag and drop the `the-middle-deploy/` folder, or connect a Git repository.
3. If using Git, set publish directory to `the-middle-deploy`.
4. Leave build command empty.
5. Deploy.

The included `netlify.toml` handles fallback routing.

## Pre-Deploy Checklist

- Confirm the public name: The Middle / เดอะมิดเดิ้ล.
- Confirm tagline: ตัวกลางแห่งทุกสรรพสิ่ง.
- Confirm whether the site should be public or private.
- Sitemap and robots URL are already set to `https://the-middle-th.github.io/the-middle/`.
- Add real screenshots or visual assets if this becomes a production identity site.
- Archive source references into `the-middle-admin/sources/`.

## Current Status

Version: `0.1`

Date: `2026-06-23`

Site type: static HTML

Build required: no
