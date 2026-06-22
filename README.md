# Resume

Cory Dominguez is a Senior Data Engineer at Meta (WhatsApp) with over a decade of
experience building data infrastructure, analytics, and measurement systems across
companies including Meta, Vacasa, imgix, and Chartboost. This repository hosts an
extended, always-current version of his resume as a static website on GitHub Pages.
The site renders the full resume from Markdown in the browser and offers one-click
downloads of the Markdown source and printable PDFs (full and one-page).

**Live site:** <https://c11z.github.io/resume/>

## Features

- **Single source of truth** — all resume content lives in [`resume.md`](resume.md).
- **Client-side rendering** — Markdown is fetched and rendered at runtime; no build step.
- **Downloads & printing** — export the Markdown source, a full PDF, or a condensed one-page PDF.
- **Automatic releases** — bumping the version in `resume.md` tags a GitHub Release.

## Local Development

No dependencies or build system — just serve the directory with any static file server:

```bash
python3 -m http.server 8000
```

Then open <http://localhost:8000>.

## Project Structure

| File | Purpose |
| --- | --- |
| `resume.md` | Resume content in Markdown — the single source of truth. |
| `index.html` | Shell that fetches and renders `resume.md` ([marked.js](https://marked.js.org/)) and wires up the download/print buttons. |
| `style.css` | Screen, PDF, and print styles in one file. |
| `.github/workflows/release.yml` | Tags a GitHub Release when `resume.md`'s version changes. |
| `.nojekyll` | Disables Jekyll processing so files are served as-is. |

## Editing the Resume

1. Edit [`resume.md`](resume.md). Content is the only thing that usually changes;
   layout and styling live in `style.css`.
2. Bump the `version` field in the front matter to trigger a new GitHub Release.
3. Push to `main` — GitHub Pages deploys automatically.

## Deployment

The site is served by GitHub Pages from the `main` branch. Every push to `main`
deploys the latest content. When `resume.md`'s version changes, the release
workflow creates a matching `vX.Y` tag and GitHub Release.

## License

Licensed under the [MIT License](LICENSE).
