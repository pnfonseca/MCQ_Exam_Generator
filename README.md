# MCQ Exam Generator — template repository

Claude Code–driven pipeline for generating closed/open-book multiple-choice exams: source
material → draft questions → full question set → shuffled variants → correction key →
print-ready LaTeX. PDF compilation is a separate, local step — see "Compiling to PDF" below.

This is a **template repository**: check it out fresh for every new exam (new course, new
session, even a re-run of the same exam), fill in one config file, and run. It is not meant to
accumulate multiple exams inside itself — each checkout is a self-contained working folder for
one exam.

Originally built for PPO (Programação por Objectos), designed to extend to any course —
including introductory C/C++ courses.

## Requirements

**For Claude Code / the generation pipeline:**
- [Claude Code](https://claude.com/claude-code)
- [pandoc](https://pandoc.org/) (Markdown → LaTeX conversion)

**For compiling the generated `.tex` to PDF** (done separately, not by Claude Code — see
below):
- A working TeX distribution with `xelatex` (needed for PT-PT accented characters)

Both are provided by this repo's `Dockerfile` — see "Running via Docker" below.

## Repository structure

```
.
├── Dockerfile                       # host-side: builds the container image
├── build.bash                       # host-side: builds the image
├── launch.bash                      # host-side: runs the container, mounts workspace/
├── .gitignore
├── README.md                        # this file — not seen by Claude Code
└── workspace/                       # mounted as /workspace in the container
    ├── CLAUDE.md                    # THE file you edit per exam — fill in every < > field
    ├── MCQ_template.tex             # shared LaTeX layout — do not edit per exam
    ├── TEMPLATE_prompt_gerar_MCQ.md # shared methodology — do not edit per exam
    ├── zipgrade_keys_example.csv    # correction-key format reference
    └── Exames/                      # created by the pipeline; holds this exam's output:
        ├── <prefix>_<session>_MCQ_<N>_rascunho.md
        ├── <prefix>_<session>_MCQ_<N>_Prova_<variant>.md
        ├── <prefix>_<session>_MCQ_<N>_Prova_<variant>_corpo.tex
        ├── <prefix>_<session>_MCQ_<N>_Prova_<variant>.tex
        └── zipgrade_keys.csv
```

## Design principle: one fact, one file

- **Concrete values** (course, session, language, question counts, header text, file paths,
  code conventions) live *only* in `workspace/CLAUDE.md`.
- **Process** (how sources are surveyed, question styles, the closed-book self-containment
  rule, distractor quality, the phased draft → full set → variants workflow, the render
  pipeline) lives *only* in `workspace/TEMPLATE_prompt_gerar_MCQ.md`, which arrives unchanged
  with every checkout — you only edit it if you're updating this template repository itself,
  never while generating a specific exam.
- Neither file restates the other's content — `TEMPLATE_prompt_gerar_MCQ.md` refers to
  `CLAUDE.md` by field name ("the command defined in *Comando de
  verificação/compilação*...") instead of duplicating values. Nothing needs to be kept in
  sync by hand.

## Setting up a new exam

1. Check out this repository into your exam's folder (e.g.
   `Lecturing/Course A/Year 1/Exams/MidTerm/`) — either via "Use this template" on GitHub, or
   `git clone --depth 1 <repo-url> <exam-folder> && rm -rf <exam-folder>/.git` if you don't
   want the checkout itself under version control.
2. Open `workspace/CLAUDE.md` and fill in every bracketed `< >` field (course, session,
   language/compiler, source location, scope, open/closed book, question count, alternatives,
   variants, destination folder, header text, code conventions for this specific course).
3. Build and launch the container (`./build.bash` if the image doesn't exist yet, then
   `./launch.bash`) — it mounts `workspace/` to `/workspace` and starts there.
4. Start Claude Code and ask it to generate the exam — `CLAUDE.md` is loaded automatically, so
   no config needs to be pasted in.

## Pipeline

Markdown is the working medium through drafting, review, the full question set, and shuffled
variants. Only the final step switches to LaTeX — and that's where Claude Code's job ends:

1. **Draft** a small sample (~10 questions), saved as `..._rascunho.md`, for approval — mixing
   question styles and topics.
2. **Generate the full set**, correct answer always on **A** in the working draft, for easy
   human review before shuffling.
3. **Shuffle into variants** (questions and alternatives independently baralhadas per
   version), together with the matching correction-key rows.
4. **Assemble each approved variant's final `.tex`**, never straight from Markdown to PDF:
   - `pandoc ... -f markdown -t latex -o ..._corpo.tex` — body-only LaTeX fragment
   - assemble `..._Prova_<variant>.tex` from `MCQ_template.tex`: fill the header variables
     from `CLAUDE.md`, insert the fragment at `%%% QUESTIONS_PLACEHOLDER %%%`
   - **stop here** — this `.tex` is Claude Code's final deliverable; it does not compile a PDF

## Compiling to PDF

This step is intentionally separate from the Claude Code pipeline, so that generating exam
content never requires a full LaTeX distribution in that environment. Once you have a
variant's `.tex` file, compile it yourself:

```bash
xelatex -interaction=nonstopmode "<prefix>_<session>_MCQ_<N>_Prova_A.tex"
xelatex -interaction=nonstopmode "<prefix>_<session>_MCQ_<N>_Prova_A.tex"
```

Run twice — the first pass resolves cross-references (e.g. the page-count footer via
`\pageref{LastPage}`), the second pass renders them correctly. Repeat per variant. Afterwards,
visually check at least one page with a code snippet to confirm the formatting and syntax
highlighting survived.

## Running via Docker

`Dockerfile`, `build.bash`, and `launch.bash` live at the repo root, outside `workspace/`, so
rebuilding the image never touches exam content. `launch.bash` bind-mounts `workspace/` to
`/workspace` inside the container and starts the container there — that's also where
`CLAUDE.md` needs to sit, since Claude Code auto-loads it from the working directory.

## A note on visibility

Exam PDFs and correction keys contain answers. If a checked-out exam folder (or any
fork/mirror of it) ends up in a public repository, keep the exam content — `workspace/Exames/`
— in a private repository instead.
