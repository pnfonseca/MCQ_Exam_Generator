# CLAUDE.md — modelo para pasta de exame/teste MCQ

> **Como usar este modelo:** copiar para `CLAUDE.md` na pasta do novo exame e preencher todos
> os campos entre `< >`. Este é o **único** ficheiro onde os parâmetros deste exame são
> definidos — não copiar estes valores para mais nenhum ficheiro. A metodologia (o "como
> fazer") vive só em `<caminho para TEMPLATE_prompt_gerar_MCQ.md>`, partilhada entre
> disciplinas; este `CLAUDE.md` só contém o "com que valores" e as regras específicas desta
> disciplina. Apagar este aviso depois de preenchido.
>
> Ao iniciar uma conversa nesta pasta, não é preciso colar nada: o Claude Code lê este
> ficheiro automaticamente. Basta pedir, por exemplo, "gera o conjunto de MCQ". Se algum campo
> abaixo ficar por preencher, a instrução é perguntar antes de avançar — nunca assumir valores
> por omissão em pontos que mudam o resultado.

## Ficheiro de metodologia partilhado

- **Localização:** `<caminho relativo, ex.: ../TEMPLATE_prompt_gerar_MCQ.md>`

Ler esse ficheiro para todo o processo (levantamento de fontes, estilos de pergunta, regras de
autocontenção, fases de geração, formato da chave, comando de referência do pandoc). Este
`CLAUDE.md` não repete nada disso — só os valores concretos abaixo.

## Parâmetros deste exame

- **Disciplina / código da UC:** `<ex.: Programação por Objectos (41519)>`
- **Prefixo curto para nomes de ficheiro:** `<ex.: PPO, PC>`
- **Código da sessão de exame:** `<ex.: DZ, Época Normal, Recurso, Teste 1>`
- **Idioma das perguntas:** `<ex.: PT-PT, EN>`
- **Linguagem de programação e norma:** `<ex.: C17 (gcc), C++17 (g++), C99>`
- **Comando de verificação/compilação dos excertos:**
  `<ex.: gcc -std=c17 -Wall -Wextra -o /tmp/check ficheiro.c && /tmp/check>`
- **Nível dos alunos / pré-requisitos assumidos:**
  `<ex.: 1º ano de engenharia; já viram ponteiros e arrays, ainda não viram alocação dinâmica>`
- **Localização das fontes:** `<caminho relativo às aulas>`
- **Âmbito:** `<ex.: todas as aulas encontradas, só as Aulas TP, só os capítulos 1–5>`
- **Regime do exame:** `<aberto|fechado>`
- **Número total de perguntas:** `<N>`
- **Número de alternativas por pergunta:** `<ex.: 4>`
- **Formato de saída pretendido:** `<ex.: Markdown para imprimir>`
- **Sistema de correção:** `<ex.: ZipGrade>` (procurar por `find . -iname "*keys*.csv"` ou
  semelhante antes de inventar um formato — ver metodologia)
- **Número de versões/variantes finais a gerar:** `<ex.: 2>`
- **Pasta de destino dos ficheiros gerados:** `<ex.: Exames/>`
- **Localização do template LaTeX partilhado:** `<caminho relativo, ex.: ../MCQ_template.tex>`
  (ficheiro único, partilhado entre disciplinas — não copiar nem editar por exame; ver
  "Cabeçalho do exame" abaixo para os valores que o preenchem)

## Cabeçalho do exame (valores para `MCQ_template.tex`)

Instituição e departamento são fixos dentro de `MCQ_template.tex`
(`Universidade de Aveiro` / DETI) — só mudar lá diretamente se for usado noutra instituição.
Os restantes valores do cabeçalho vêm só daqui:

- **Nome da disciplina (cabeçalho, sem código):** `<ex.: Programação por Objectos>`
- **Tipo de exame:** `<ex.: Exame Final, Teste, Frequência>`
- **Época/sessão (texto completo do cabeçalho):** `<ex.: Época Especial>`
- **Componente:** `<ex.: Componente Teórico-Prática>`
- **Semestre:** `<ex.: 2º Semestre>`
- **Ano letivo:** `<ex.: 25-26>`
- **Duração:** `<ex.: 1h00m>`
- **Rodapé curto:** `<ex.: PpO 25-26>`

## Convenção de nomes de ficheiros

Derivada apenas dos parâmetros acima — nunca nomes fixos copiados de outra disciplina/sessão.
O `.md` é o suporte de trabalho e revisão; o `.tex` e o `.pdf` só existem para a variante já
aprovada (ver "Comandos" abaixo):

```
<pasta de destino>/<prefixo>_<sessão>_MCQ_<N>_Prova_<variante>.md    (perguntas aprovadas, Markdown)
<pasta de destino>/<prefixo>_<sessão>_MCQ_<N>_Prova_<variante>.tex   (gerado a partir do .md + MCQ_template.tex)
<pasta de destino>/<prefixo>_<sessão>_MCQ_<N>_Prova_<variante>.pdf   (compilado a partir do .tex)
```

`<variante>` percorre A, B, C, ... até ao "número de versões" definido acima.

## Comandos

O Markdown serve para todo o processo de geração e revisão (rascunho, conjunto completo,
variantes baralhadas) — só o passo final de impressão passa a LaTeX. Ver a metodologia
partilhada para o processo completo; aqui ficam só os comandos, com os nomes de ficheiro já
seguindo o padrão acima.

**1. Converter as perguntas aprovadas de uma variante para um fragmento LaTeX** (sem `-s`, para
obter só o corpo, sem preâmbulo):

```bash
pandoc "<pasta destino>/<prefixo>_<sessão>_MCQ_<N>_Prova_A.md" \
  -f markdown -t latex \
  -o "<pasta destino>/<prefixo>_<sessão>_MCQ_<N>_Prova_A_corpo.tex"
```

**2. Montar o `.tex` final da variante** a partir de `MCQ_template.tex`: copiar o template,
substituir as variáveis do cabeçalho (Secção "EXAM-SPECIFIC VARIABLES" do template) pelos
valores desta secção, e substituir a linha `%%% QUESTIONS_PLACEHOLDER %%%` por
`\input{<prefixo>_<sessão>_MCQ_<N>_Prova_A_corpo.tex}`. Gravar como
`<prefixo>_<sessão>_MCQ_<N>_Prova_A.tex`. Nenhum placeholder `< >` pode sobrar no ficheiro que
vai ser compilado.

**3. Compilar o `.tex` com xelatex** (não pandoc — xelatex é necessário para acentuação PT-PT;
correr duas vezes para resolver `\pageref{LastPage}` no rodapé):

```bash
xelatex -interaction=nonstopmode "<pasta destino>/<prefixo>_<sessão>_MCQ_<N>_Prova_A.tex"
xelatex -interaction=nonstopmode "<pasta destino>/<prefixo>_<sessão>_MCQ_<N>_Prova_A.tex"
```

Repetir os 3 passos para cada variante (lista de letras com o mesmo comprimento que o "número
de versões" definido acima). Depois de gerar, verificar visualmente pelo menos uma página com
um excerto de código — o `MCQ_template.tex` já traz o suporte de realce de sintaxe necessário
para os blocos de código produzidos pelo pandoc no passo 1.

## Convenções de código específicas desta disciplina

> Preencher com as regras pedagógicas reais desta UC — não há um conjunto universal, cada
> UC/linguagem tem o seu. Exemplos (substituir, não copiar):
> - *OOP/C++ (ex.: PPO):* atributos sempre privados; sem `cin`/`cout` dentro de classes;
>   invariantes garantidos por `bool` antes de exceções serem ensinadas, por exceções depois;
>   observadores `const`; sem herança nas aulas iniciais.
> - *C procedural (1º ano):* sem alocação dinâmica (`malloc`/`free`) antes de ensinada;
>   protótipos sempre consistentes com a definição; gestão de memória explícita e sem fugas
>   nos excertos usados como "código correto"; sem comportamento indefinido mesmo em
>   distratores; `const` usado corretamente em parâmetros não modificados; arrays vs.
>   ponteiros tratados de forma consistente com o que já foi ensinado até à data do exame.

`<regras reais desta disciplina aqui>`

Qualquer excerto original escrito para uma pergunta tem de passar pelo "comando de
verificação/compilação" definido acima antes de entrar no exame.
