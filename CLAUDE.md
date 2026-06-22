# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Static resume website for Cory Dominguez, hosted on GitHub Pages at <https://c11z.github.io/resume/>. No build system or dependencies to install — plain HTML, CSS, and vanilla JS. It pulls three things from CDNs: marked.js (Markdown rendering), Lucide (icons), and Google Fonts (Inter Tight + IBM Plex Mono, imported by the design system).

## Local Development

```bash
python3 -m http.server 8000
# Open http://localhost:8000
```

## Architecture

The core of the site:

- **`resume.md`** — Resume content in Markdown. This is the single source of truth for all resume text.
- **`index.html`** — Shell that fetches `resume.md` at runtime, strips the YAML front matter, renders it with [marked.js](https://cdn.jsdelivr.net/npm/marked/marked.min.js) into `<main id="resume">`, and provides three buttons: download Markdown, PDF Full, and PDF One Page. PDF export uses the browser's native `window.print()` (no PDF library).
- **`style.css`** — Two rendering modes sharing a single file: screen styles and `@media print` (compact `pt`-sized layout for letter paper, used for both PDF buttons). It owns only resume-specific layout and consumes design tokens from the system below.
- **`assets/c11z.css`** — The c11z design system, a vendored drop-in file: fonts, color tokens, the `.btn` component, and Lucide icon sizing. Loaded **before** `style.css` so its `:root` tokens are available. Treat it as upstream — update it by re-importing a new handoff, not by hand-editing.
- **`assets/`** — Also holds the favicon set referenced from `index.html`.

Content changes go in `resume.md`. Resume layout goes in `style.css`; design tokens/components live in `assets/c11z.css`. The HTML rarely needs editing — it's mostly scaffolding and JS glue.

## Key Details

- The production branch is `main` (not `master`). GitHub Pages deploys from `main`, and the release workflow triggers on pushes to `main` that change `resume.md`.
- The `version` field in `resume.md`'s front matter is bumped automatically by the tracked `pre-commit` hook in `.githooks/` — it advances the minor version once per commit that stages `resume.md` (and skips if you've already changed the version line yourself). This requires a one-time, per-clone setup: `git config core.hooksPath .githooks`.
- `.nojekyll` disables Jekyll processing on GitHub Pages so files are served as-is.
- After rendering, JS finds the `<h3>` containing "imgix" and adds the `.page-break` class — in print/PDF this forces a page break before that entry (`h3.page-break { page-break-before: always }`).
- "PDF Full" calls `window.print()` directly. "PDF One Page" hides the `.page-break` element and all its following siblings, prints, then restores them — yielding a one-page export of the most recent experience.
- **Colors, fonts, and buttons come from the design system (`assets/c11z.css`), not from `style.css`.** Use its semantic tokens — `--text-primary/secondary/tertiary`, `--text-link`, `--accent`, `--highlight`, `--border`, `--rule`, `--bg`, `--surface`, `--font-sans/mono`, `--weight-*`. Color is restricted to the system's [Okabe–Ito](https://jfly.uni-koeln.de/color/)-based palette (`--oi-*`, plus the blue/vermillion ramps); do not introduce new hues or hard-coded hex values in `style.css`. Buttons use the `.btn` classes (`.btn--secondary`, `.btn--sm`, etc.); icons are Lucide (`<i data-lucide="name">`, rendered by `lucide.createIcons()`).
