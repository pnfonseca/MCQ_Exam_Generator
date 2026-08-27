# MCQ Exam Generator

Claude Code–driven pipeline for generating closed/open-book multiple-choice exams: source
material → draft questions → full question set → shuffled variants → correction key →
print-ready LaTeX. PDF compilation is a separate, local step — see "Compiling to PDF" below.

Originally built for PPO (Programação por Objectos), designed to extend to any course —
including introductory C/C++ courses — by editing a single per-exam config file.

## Requirements

**For Claude Code / the generation pipeline:**
- [Claude Code](https://claude.com/claude-code)
- [pandoc](https://pandoc.org/) (Markdown → LaTeX conversion)

**For compiling the generated `.tex` to PDF** (done separately, not by Claude Code — see
below):
- A working TeX distribution with `xelatex` (needed for PT-PT accented characters)

## Repository structure

```
.
├── TEMPLATE_prompt_gerar_MCQ.md   # shared methodology (edit only to change the process itself)
├── MCQ_template.tex               # shared LaTeX layout (header, student-ID box, footer)
├── .gitignore
├── README.md
└── <exam-folder>/                 # one folder per course/session, e.g. PPO_DZ_25-26/
    ├── CLAUDE.md                  # all config values for this exam (the only file you edit per exam)
    └── Exames/
        ├── <prefix>_<session>_MCQ_<N>_rascunho.md               # ~10-question draft, for approval
        ├── <prefix>_<session>_MCQ_<N>_Prova_<variant>.md        # approved questions (Markdown)
        ├── <prefix>_<session>_MCQ_<N>_Prova_<variant>_corpo.tex # pandoc-converted body (intermediate)
        ├── <prefix>_<session>_MCQ_<N>_Prova_<variant>.tex       # Claude Code's final deliverable
        ├── <prefix>_<session>_MCQ_<N>_Prova_<variant>.pdf       # produced locally, see below — not by Claude Code
        └── zipgrade_keys.csv                                    # correction key
```

## Design principle: one fact, one file

- **Concrete values** (course, session, language, question counts, header text, file paths,
  code conventions) live *only* in the exam folder's `CLAUDE.md`.
- **Process** (how sources are surveyed, question styles, the closed-book self-containment
  rule, distractor quality, the phased draft → full set → variants workflow, the render
  pipeline) lives *only* in `TEMPLATE_prompt_gerar_MCQ.md`, shared across every exam.
- Neither file restates the other's content — `TEMPLATE_prompt_gerar_MCQ.md` refers to
  `CLAUDE.md` by field name ("the command defined in *Comando de
  verificação/compilação*...") instead of duplicating values. Nothing needs to be kept in
  sync by hand.

## Setting up a new exam

1. Create a new folder for the course/session.
2. Copy `CLAUDE.md`'s template fields into a new `CLAUDE.md` in that folder and fill in every
   bracketed value (course, session, language/compiler, source location, scope, open/closed
   book, question count, alternatives, variants, destination folder, header text, code
   conventions for that specific course).
3. Point its "Ficheiro de metodologia partilhado" field at the repo's
   `TEMPLATE_prompt_gerar_MCQ.md` (relative path).
4. Start a Claude Code session inside that folder and ask it to generate the exam —
   `CLAUDE.md` is loaded automatically, so no config needs to be pasted in.

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

## A note on visibility

Exam PDFs and correction keys contain answers. If this repository (or any fork/mirror of it)
is public, keep exam content — anything under an exam folder's output directory — in a
private repository or a separate private remote instead.
