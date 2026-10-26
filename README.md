# latex-docs

Monorepo for my LaTeX documents. Each top-level folder is an independent LaTeX
project; shared tooling (dev container, ignore rules, CI) lives at the repo root.

## Projects

| Folder | Document | Root file(s) | Release |
|---|---|---|---|
| [`todos`](todos/) | Habit / todo tracking sheet (A4) | `main.tex` | `todos-v*` → *Todo List PDF* |
| [`pamietnik`](pamietnik/) | Yearly calendar & journal (A5, `memoir`) | `main.tex` | `pamietnik-v*` → *Dziennik PDF* |
| [`cheatsheets`](cheatsheets/) | Design-pattern & LaTeX cheat sheets | `designPatterns/Patterns.tex`, `simple/simple.tex` | `cheatsheets-v*` → *Cheatsheets PDF* |

## Building locally

A full TeX Live dev container is provided at the repo root (open the repository
in VS Code and *Reopen in Container*), or install `texlive-full` yourself.

```bash
# todos
cd todos && latexmk -pdf main.tex

# pamietnik
cd pamietnik && latexmk -pdf main.tex

# cheatsheets — first generate the MetaPost design-pattern diagrams, then build
cd cheatsheets/designPatterns/metauml && sh makePdf.bash
cd ..        && latexmk -pdf Patterns.tex
cd ../simple && latexmk -pdf simple.tex
```

The `cheatsheets/designPatterns/metauml/*.mp` files are MetaPost **sources** (kept
in git); `makePdf.bash` turns each into a `*-1.pdf` that `Patterns.tex` includes.
Generated PDFs and LaTeX auxiliary files are git-ignored.

## Continuous integration

On every push to `main` (and via *Run workflow*), `.github/workflows/build-pdf.yml`:

1. Uses [`dorny/paths-filter`](https://github.com/dorny/paths-filter) to detect
   which project folders changed, so only those are rebuilt.
2. Calls the reusable `.github/workflows/_build-latex.yml` for each changed
   project, which compiles the PDF(s) and publishes a **per-project GitHub
   Release**. Tags are namespaced (`todos-v<run>`, `pamietnik-v<run>`,
   `cheatsheets-v<run>`) so projects never collide on releases.

A manual `workflow_dispatch` run rebuilds and releases all three projects.
