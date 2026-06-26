# หนังสือสวดมนต์ออนไลน์

Next.js + TypeScript + Tailwind CSS website for a calm Thai Buddhist online prayer book.

## Run locally

```bash
npm install
npm run dev
```

Open `http://localhost:3000`.

## Build

```bash
npm run build
```

## Notes

- Prayer data lives in `data/prayers.ts`.
- Modern Thai translations are intentionally not copied. Content that needs review is marked `TODO`.
- Bookmarks and reading theme are stored in `localStorage`.
- The app is ready for Vercel / Manus deployment after installing dependencies.
