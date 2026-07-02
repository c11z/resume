#!/usr/bin/env bash
# Pre-render the resume PDFs (resume.pdf, resume_one_page.pdf) with headless
# Chrome so every visitor downloads the same Chrome-rendered file regardless
# of their browser. The release workflow runs this in CI; run it locally to
# regenerate after style changes (requires Google Chrome or Chromium).
set -euo pipefail
cd "$(dirname "$0")/.."

CHROME="${CHROME:-}"
if [ -z "$CHROME" ]; then
    for candidate in \
        google-chrome \
        chromium-browser \
        chromium \
        "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"; do
        if command -v "$candidate" > /dev/null 2>&1 || [ -x "$candidate" ]; then
            CHROME="$candidate"
            break
        fi
    done
fi
if [ -z "$CHROME" ]; then
    echo "error: Chrome not found; set CHROME=/path/to/chrome" >&2
    exit 1
fi

# index.html fetches resume.md at runtime, so Chrome needs an HTTP origin
# rather than a file:// URL.
PORT=8123
python3 -m http.server "$PORT" --bind 127.0.0.1 > /dev/null 2>&1 &
SERVER_PID=$!
trap 'kill "$SERVER_PID"' EXIT
sleep 1

print_pdf() {
    local query=$1 out=$2
    # --virtual-time-budget waits out the resume.md fetch, Markdown render,
    # and webfont loading before Chrome snapshots the page.
    "$CHROME" --headless=new --disable-gpu --no-pdf-header-footer \
        --virtual-time-budget=10000 \
        --print-to-pdf="$out" \
        "http://127.0.0.1:$PORT/$query"
    echo "wrote $out"
}

print_pdf "" resume.pdf
print_pdf "?variant=one-page" resume_one_page.pdf
