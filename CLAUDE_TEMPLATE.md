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
- **Nome do template LaTeX a usar:** `<ex.: PPO_25-26_DZ_TP.tex — criar se não existir>`

## Convenção de nomes de ficheiros

Derivada apenas dos parâmetros acima — nunca nomes fixos copiados de outra disciplina/sessão:

```
<pasta de destino>/<prefixo>_<sessão>_MCQ_<N>_Prova_<variante>.md
<pasta de destino>/<prefixo>_<sessão>_MCQ_<N>_Prova_<variante>.pdf
```

`<variante>` percorre A, B, C, ... até ao "número de versões" definido acima.

## Comandos

Renderizar uma variante para PDF (xelatex é necessário para acentuação PT-PT):

```bash
pandoc "<pasta destino>/<prefixo>_<sessão>_MCQ_<N>_Prova_A.md" \
  -o "<pasta destino>/<prefixo>_<sessão>_MCQ_<N>_Prova_A.pdf" \
  --pdf-engine=xelatex \
  -V geometry:a4paper,margin=2.2cm \
  -V fontsize=11pt \
  --highlight-style=tango
```

Percorrer todas as variantes (a lista de letras tem de ter o mesmo comprimento que o "número
de versões" definido acima):

```bash
for v in <lista de letras, ex.: A B ou A B C D>; do
  pandoc "<pasta destino>/<prefixo>_<sessão>_MCQ_<N>_Prova_${v}.md" \
    -o "<pasta destino>/<prefixo>_<sessão>_MCQ_<N>_Prova_${v}.pdf" \
    --pdf-engine=xelatex -V geometry:a4paper,margin=2.2cm -V fontsize=11pt \
    --highlight-style=tango
done
```

Depois de gerar, verificar visualmente pelo menos uma página com um excerto de código.

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
