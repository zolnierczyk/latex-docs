# Copilot instructions for latex-docs

## Repository shape

This repository is a monorepo of independent LaTeX projects rather than a single application. Each top-level folder is a self-contained document project:

- `todos/`: habit / todo tracker sheet
- `pamietnik/`: yearly calendar and journal
- `cheatsheets/`: various cheat sheets like LaTeX and design-pattern 
- `recipebook/`: recipe book for home cooking and baking
- `cv/`: CV / resume templates and related assets

The root is mostly orchestration: shared CI, devcontainer, and gitignore rules. The GitHub workflow in `.github/workflows/build-pdf.yml` detects which project folders changed and rebuilds only those PDFs, publishing per-project releases.

## Build, test, and validation commands

There is no single root test suite or linter. Validation is primarily compile-based. Use the repo devcontainer or install TeX Live first (`latexmk` and a TeX distribution are required).

### Standard local builds

```bash
# todos
cd todos && latexmk -pdf main.tex

# pamietnik
cd pamietnik && latexmk -pdf main.tex

# cheatsheets: generate MetaPost sources first, then compile each document
cd cheatsheets/designPatterns/metauml && sh makePdf.bash
cd .. && latexmk -pdf Patterns.tex
cd ../simple && latexmk -pdf simple.tex

# recipebook (requires XeLaTeX because it uses fontspec)
cd recipebook && latexmk -xelatex main.tex
```

## High-level architecture

- The repo is organized around document roots rather than shared code modules. Each folder owns its own `.tex` source, styles, assets, and build instructions.
- Root CI is path-aware: changed folders trigger separate LaTeX builds instead of rebuilding everything. This matters when editing one document because the build contract is local to that project.
- The `cheatsheets` project is special: `designPatterns/Patterns.tex` includes generated PDF diagrams produced by `cheatsheets/designPatterns/metauml/*.mp` via `makePdf.bash`. The PDF generation step is part of the normal document build.
- `recipebook` is intentionally compiled with `latexmk -xelatex` because of `fontspec`; do not assume all projects use the same engine.
- Root-level generated artifacts (`*.pdf`, LaTeX aux files) are git-ignored; source documents and supporting `.cls` / `.sty` / image assets are what should be committed.

## Key conventions

- Prefer project-local builds and paths over root-level assumptions. Editing `todo` sources should not require thinking about `recipebook` or `pamietnik` unless the shared CI or docs are affected.
- Keep `main.tex` or the project-specific root file as the canonical entry point. When making a change, validate by compiling that document in its own folder.
- Respect relative image/include paths. Some projects compile from their own directory context; `cheatsheets/designPatterns/Patterns.tex` is an example where the workflow intentionally compiles from the directory containing the file because the source includes relative paths.
- Use the repo devcontainer (`.devcontainer/devcontainer.json`) when working locally; it installs a full TeX Live environment and the editor extensions for LaTeX work.
- Keep generated outputs out of git. Source changes should be limited to `.tex`, classes, styles, images, scripts, and CI config; do not check in compiled PDFs or auxiliary build artifacts.

## Working style for Copilot

When making changes in this repo:

- Confirm which document project is affected before editing.
- Prefer the smallest compile command that exercises the changed file or folder.
- If a change touches the root CI or cross-project workflow, validate the workflow assumptions rather than assuming a single project build covers all folders.
