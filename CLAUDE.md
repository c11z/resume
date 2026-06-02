# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Static resume website for Cory Dominguez, hosted on GitHub Pages at https://c11z.github.io/resume/. No build system or dependencies to install — just plain HTML, CSS, and vanilla JS with one CDN library (marked.js for Markdown rendering).

## Local Development

```bash
python3 -m http.server 8000
# Open http://localhost:8000
```

## Architecture

The site is three files:

- **`resume.md`** — Resume content in Markdown. This is the single source of truth for all resume text.
- **`index.html`** — Shell that fetches `resume.md` at runtime, strips the YAML front matter, renders it with [marked.js](https://cdn.jsdelivr.net/npm/marked/marked.min.js) into `<main id="resume">`, and provides three buttons: download Markdown, PDF Full, and PDF One Page. PDF export uses the browser's native `window.print()` (no PDF library).
- **`style.css`** — Two rendering modes sharing a single file: screen styles and `@media print` (compact `pt`-sized layout for letter paper, used for both PDF buttons).

Content changes go in `resume.md`. Layout and styling changes go in `style.css`. The HTML rarely needs editing — it's mostly scaffolding and JS glue.

## Key Details

- The production branch is `main` (not `master`). GitHub Pages deploys from `main`, and the release workflow triggers on pushes to `main` that change `resume.md`.
- `.nojekyll` disables Jekyll processing on GitHub Pages so files are served as-is.
- After rendering, JS finds the `<h3>` containing "imgix" and adds the `.page-break` class — in print/PDF this forces a page break before that entry (`h3.page-break { page-break-before: always }`).
- "PDF Full" calls `window.print()` directly. "PDF One Page" hides the `.page-break` element and all its following siblings, prints, then restores them — yielding a one-page export of the most recent experience.
