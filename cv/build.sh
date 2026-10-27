#!/usr/bin/env bash
#
# Build the CV LaTeX templates in this folder into PDFs.
#
# This is a local developer helper for an early work-in-progress PoC; there is
# intentionally no CI for the cv/ templates yet.
#
# Usage:
#   ./build.sh                 # build every *.tex template
#   ./build.sh alta simple     # build only the named templates
#   ./build.sh -c | --clean    # remove the build/ output directory
#
# Output (PDFs and LaTeX aux files) goes to cv/build/. The script keeps going
# if a template fails, prints a summary, and exits non-zero when any build
# failed so problems are easy to spot.

set -u

cd "$(dirname "$0")"

OUTDIR="build"

if [ "${1:-}" = "-c" ] || [ "${1:-}" = "--clean" ]; then
    rm -rf "$OUTDIR"
    echo "Removed $OUTDIR/"
    exit 0
fi

if ! command -v latexmk >/dev/null 2>&1; then
    echo "error: latexmk not found. Install a TeX distribution (e.g. texlive-full)," >&2
    echo "       or build inside the repository dev container." >&2
    exit 1
fi

# Pick the templates to build: the arguments (with or without .tex), or all.
templates=""
if [ "$#" -gt 0 ]; then
    for arg in "$@"; do
        templates="$templates ${arg%.tex}.tex"
    done
else
    templates="$(ls -1 ./*.tex 2>/dev/null)"
fi

if [ -z "${templates// /}" ]; then
    echo "No .tex templates found to build."
    exit 0
fi

# Some templates must be compiled with XeLaTeX (fontspec / custom classes that
# say so). Everything else compiles fine with pdfLaTeX.
detect_engine() {
    if grep -qiE 'compiled with xelatex|\{plushcv\}' "$1"; then
        echo "xelatex"
    else
        echo "pdflatex"
    fi
}

mkdir -p "$OUTDIR"

ok=""
failed=""
for tex in $templates; do
    name="$(basename "${tex%.tex}")"
    if [ ! -f "$tex" ]; then
        echo "!! $name: $tex not found, skipping"
        failed="$failed $name"
        continue
    fi

    engine="$(detect_engine "$tex")"
    case "$engine" in
        xelatex) engine_flag="-xelatex" ;;
        *)       engine_flag="-pdf" ;;
    esac

    echo "==> Building $name ($engine)"
    if latexmk "$engine_flag" -shell-escape -interaction=nonstopmode \
        -halt-on-error -outdir="$OUTDIR" "$tex" >"$OUTDIR/$name.build.log" 2>&1; then
        echo "   ok  -> $OUTDIR/$name.pdf"
        ok="$ok $name"
    else
        echo "   FAILED (see $OUTDIR/$name.build.log)"
        failed="$failed $name"
    fi
done

echo
echo "Summary:"
echo "  built : ${ok:-(none)}"
echo "  failed: ${failed:-(none)}"

[ -z "${failed// /}" ]
