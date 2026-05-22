# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Static resume website for Cory Dominguez, hosted on GitHub Pages at https://c11z.github.io/resume/. No build system or dependencies to install — just plain HTML, CSS, and vanilla JS with two CDN libraries.

## Local Development

```bash
python3 -m http.server 8000
# Open http://localhost:8000
```

## Architecture

The site is three files:

- **`resume.md`** — Resume content in Markdown. This is the single source of truth for all resume text.
- **`index.html`** — Shell that fetches `resume.md` at runtime, renders it with [marked.js](https://cdn.jsdelivr.net/npm/marked/marked.min.js) into `<main id="resume">`, and provides download/print buttons. PDF export uses [html2pdf.js](https://cdn.jsdelivr.net/npm/html2pdf.js@0.10.1/dist/html2pdf.bundle.min.js).
- **`style.css`** — Three rendering modes sharing a single file: screen styles, `.pdf-mode` (toggled by JS during PDF export for compact letter-size output), and `@media print`.

Content changes go in `resume.md`. Layout and styling changes go in `style.css`. The HTML rarely needs editing — it's mostly scaffolding and JS glue.

## Key Details

- `.nojekyll` disables Jekyll processing on GitHub Pages so files are served as-is.
- The second `<h2>` in the rendered resume gets a `.page-break` class for PDF/print page breaks.
- PDF export temporarily adds `.pdf-mode` to `#resume`, generates the PDF, then removes it — CSS for this mode uses `pt` units sized for letter paper.
