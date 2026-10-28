#!/usr/bin/env bash
#
# Build the CV LaTeX templates in this folder into PDFs.
#
# Usage:
#   ./build.sh                         # build the maintained CV templates
#   ./build.sh simple plush            # build named templates
#   ./build.sh latexcv/classic          # build a template by path
#   ./build.sh -c | --clean            # remove the build/ output directory
#
# Output (PDFs, logs, and LaTeX aux files) goes to cv/build/.

set -u

cd "$(dirname "$0")"

OUTDIR="$PWD/build"

if [ "$#" -eq 1 ] && { [ "$1" = "-c" ] || [ "$1" = "--clean" ]; }; then
    rm -rf "$OUTDIR"
    echo "Removed build/"
    exit 0
fi

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
    sed -n '1,12p' "$0"
    exit 0
fi

if ! command -v latexmk >/dev/null 2>&1; then
    echo "error: latexmk not found. Install a TeX distribution (e.g. texlive-full)," >&2
    echo "       or build inside the repository dev container." >&2
    exit 1
fi

# These are document entrypoints; support files and legacy examples are excluded.
all_templates=(
    infographics.tex
    libre.tex
    altacv/mmayer.tex
    altacv/sample.tex
    plushcv/plush.tex
    simplecv/simple.tex
)
while IFS= read -r tex; do
    all_templates+=("$tex")
done < <(find latexcv -mindepth 2 -maxdepth 2 -type f -name main.tex -print | sort)
while IFS= read -r tex; do
    all_templates+=("$tex")
done < <(find latexcv/infographics2 -mindepth 2 -maxdepth 2 -type f -name main.tex -print | sort)

resolve_template() {
    local arg="${1#./}"
    local candidate

    for candidate in "$arg" "$arg.tex" "$arg/main.tex"; do
        if [ -f "$candidate" ]; then
            printf '%s\n' "${candidate#./}"
            return 0
        fi
    done

    case "$arg" in
        alta) printf '%s\n' "altacv/sample.tex" ;;
        mmayer) printf '%s\n' "altacv/mmayer.tex" ;;
        sample) printf '%s\n' "altacv/sample.tex" ;;
        plush) printf '%s\n' "plushcv/plush.tex" ;;
        simple) printf '%s\n' "simplecv/simple.tex" ;;
        latexcv-infographics) printf '%s\n' "latexcv/infographics/main.tex" ;;
        *) return 1 ;;
    esac
}

if [ "$#" -gt 0 ]; then
    templates=()
    for arg in "$@"; do
        if ! tex="$(resolve_template "$arg")"; then
            echo "error: unknown CV template '$arg'" >&2
            echo "       pass a template name or path relative to cv/ (see --help)" >&2
            exit 1
        fi
        templates+=("$tex")
    done
else
    templates=("${all_templates[@]}")
fi

if [ "${#templates[@]}" -eq 0 ]; then
    echo "No CV templates found to build."
    exit 0
fi

mkdir -p "$OUTDIR"

ok=()
failed=()
for tex in "${templates[@]}"; do
    if [ ! -f "$tex" ]; then
        echo "!! $tex: source file not found"
        failed+=("$tex")
        continue
    fi

    source_dir="$(dirname "$tex")"
    source_file="$(basename "$tex")"
    name="${tex%.tex}"
    name="${name//\//_}"

    if grep -qiE 'compiled with xelatex|\{plushcv\}' "$tex"; then
        engine="xelatex"
        engine_flag="-xelatex"
    else
        engine="pdflatex"
        engine_flag="-pdf"
    fi

    echo "==> Building $tex ($engine)"
    if (
        cd "$source_dir" &&
        latexmk "$engine_flag" -g -shell-escape -interaction=nonstopmode \
            -halt-on-error -outdir="$OUTDIR" "$source_file"
    ) >"$OUTDIR/$name.build.log" 2>&1; then
        echo "   ok  -> build/$name.pdf"
        ok+=("$name")
    else
        echo "   FAILED (see build/$name.build.log)"
        failed+=("$tex")
    fi
done

echo
echo "Summary:"
printf '  built : %s\n' "${ok[*]:-(none)}"
printf '  failed: %s\n' "${failed[*]:-(none)}"

[ "${#failed[@]}" -eq 0 ]
