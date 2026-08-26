# MCQ Exam Generator

Claude Code–driven pipeline for generating closed/open-book multiple-choice exams: source
material → draft questions → full question set → shuffled variants → correction key →
print-ready PDFs.

Originally built for PPO (Programação por Objectos), designed to extend to any course —
including introductory C/C++ courses — by editing a single per-exam config file.

## Requirements

- [Claude Code](https://claude.com/claude-code)
- [pandoc](https://pandoc.org/) (Markdown → LaTeX conversion)
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
        ├── <prefix>_<session>_MCQ_<N>_Prova_<variant>.md         # approved questions (Markdown)
        ├── <prefix>_<session>_MCQ_<N>_Prova_<variant>_corpo.tex  # pandoc-converted body (intermediate)
        ├── <prefix>_<session>_MCQ_<N>_Prova_<variant>.tex        # assembled from MCQ_template.tex
        ├── <prefix>_<session>_MCQ_<N>_Prova_<variant>.pdf        # final, compiled with xelatex
        └── zipgrade_keys.csv                                     # correction key
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
variants. Only the final render step switches to LaTeX:

1. **Draft** a small sample (~10 questions) for approval, mixing question styles and topics.
2. **Generate the full set**, correct answer always on **A** in the working draft, for easy
   human review before shuffling.
3. **Shuffle into variants** (questions and alternatives independently baralhadas per
   version), together with the matching correction-key rows.
4. **Render each approved variant to PDF**, never straight from Markdown:
   - `pandoc ... -f markdown -t latex -o ..._corpo.tex` — body-only LaTeX fragment
   - assemble `..._Prova_<variant>.tex` from `MCQ_template.tex`: fill the header variables
     from `CLAUDE.md`, insert the fragment at `%%% QUESTIONS_PLACEHOLDER %%%`
   - `xelatex ..._Prova_<variant>.tex` (run twice, to resolve the page-count footer)
5. **Visually check** at least one page with a code snippet per variant.

## A note on visibility

Exam PDFs and correction keys contain answers. If this repository (or any fork/mirror of it)
is public, keep exam content — anything under an exam folder's output directory — in a
private repository or a separate private remote instead.
