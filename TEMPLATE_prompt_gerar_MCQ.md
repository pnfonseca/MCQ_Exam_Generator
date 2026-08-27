# Prompt-modelo: gerar um conjunto de MCQ a partir de materiais de uma UC

Este ficheiro é a metodologia partilhada entre disciplinas — **não contém nenhum parâmetro de
exame concreto**. Os valores concretos (disciplina, sessão, linguagem, nº de perguntas, nº de
variantes, pasta de destino, etc.) vivem exclusivamente no `CLAUDE.md` da pasta do exame que
está a ser gerado. Este ficheiro não deve ser copiado nem editado por exame — é o mesmo para
todas as disciplinas; só se edita quando o *processo em si* muda.

Antes de gerar ou editar qualquer pergunta: **ler o `CLAUDE.md` da pasta atual**. Se algum dos
seus campos estiver por preencher, perguntar ao utilizador antes de avançar — não assumir
valores por omissão em pontos que mudam o resultado (âmbito, idioma, linguagem de programação,
regime do exame, sistema de correção).

**Markdown vs. LaTeX:** todo o processo de geração e revisão — rascunho, conjunto completo,
variantes baralhadas — é feito em Markdown; é o formato usado para rever e aprovar o conteúdo.
Depois de uma variante estar aprovada, o passo final passa a LaTeX: o `.tex` final de cada
variante é sempre montado a partir do template LaTeX partilhado (`CLAUDE.md` → "Localização do
template LaTeX partilhado"), nunca escrito à mão. **Claude Code para neste `.tex` — não gera
PDF.** A compilação para PDF é feita fora, pelo utilizador (ver README do repositório), para
não exigir a cadeia LaTeX completa instalada no ambiente onde o Claude Code corre. Ver Secção 7
para os passos exatos.

---

## 1. Levantamento de fontes
- Localizar todos os ficheiros de aula (slides/PDFs e código) na "Localização das fontes" do
  `CLAUDE.md`.
- Verificar o número de páginas de cada PDF antes de o ler (`pdfinfo ficheiro.pdf | grep
  Pages`); usar leitura por blocos de páginas (≤20) quando o ficheiro for grande.
- Ler também o código de exemplo dado aos alunos (pastas tipo `Codigo/`, `src/`), não só os
  slides — é uma fonte legítima e muitas vezes mais rica para perguntas de código.

## 2. Distribuição das perguntas
- Cobrir todos os tópicos do "Âmbito" definido no `CLAUDE.md`, com peso proporcional ao
  conteúdo de cada aula (não tem de ser uma divisão igual) — incluindo aulas sem código, com
  perguntas puramente concetuais.
- Respeitar o "Nível dos alunos / pré-requisitos assumidos" do `CLAUDE.md`: não gerar
  perguntas que pressuponham matéria posterior à data desta sessão.

## 3. Estilos de pergunta a variar
1. Perguntas diretas de definição/memorização
2. Regras de sintaxe
3. Antecipar o resultado de um excerto de código
4. Identificar o erro num excerto de código
5. "Qual das afirmações NÃO é verdadeira"
6. Escolha de design / boas práticas
7. Comparar dois excertos de código

Antes de gerar as perguntas, perguntar ao utilizador se quer acrescentar outros estilos além
destes. Misturar os estilos ao longo do conjunto — não os agrupar por tópico nem por aula.

## 4. Regra crítica — perguntas autocontidas em exame *closed-book*
Se o "Regime do exame" no `CLAUDE.md` for de livro fechado, qualquer pergunta que dependa de
código (antecipar resultado, identificar erro, comparar excertos) **tem de incluir a definição
completa das classes/funções/`structs` necessárias no próprio enunciado**. Nunca presumir que o
aluno decorou um exemplo específico dos slides — isso transforma uma pergunta de leitura de
código numa pergunta de memorização disfarçada.

Perguntas puramente concetuais (sem código) podem testar memória de conceitos ensinados, mas
evitar formulações do tipo "Segundo o que foi apresentado/discutido na aula, ..." — preferir
cenários aplicados ou afirmações a avaliar pelo próprio mérito técnico, não pela autoridade do
que foi dito.

## 5. Convenções de código
Seguir sempre as "Convenções de código específicas desta disciplina" listadas no `CLAUDE.md` —
não há um conjunto universal, cada UC/linguagem tem o seu. Verificar tecnicamente o próprio
código gerado usando o comando indicado em "Comando de verificação/compilação dos excertos" no
`CLAUDE.md` (compila? o output previsto está correto? respeita as convenções?) — não confiar
cegamente no que foi gerado automaticamente.

## 6. Qualidade dos distratores
- Evitar opções obviamente erradas por incompatibilidade gramatical com o enunciado.
- Evitar "todas as anteriores" / "nenhuma das anteriores".
- Garantir que as alternativas erradas são plausíveis: erros comuns, conceitos trocados,
  off-by-one, etc. — nunca comportamento indefinido gratuito só para tornar a opção errada.

## 7. Processo faseado
1. Confirmar todos os campos do `CLAUDE.md` com o utilizador (perguntar explicitamente o que
   faltar).
2. Propor estilos de pergunta adicionais (Secção 3) para aprovação.
3. Gerar um rascunho pequeno (~10 perguntas), variado em estilos e tópicos, para validar
   formato/tom antes do conjunto completo. Gravar este rascunho como ficheiro Markdown (nome
   definido no `CLAUDE.md`, ver "Convenção de nomes de ficheiros") — não apresentar só inline
   no chat — para o utilizador rever e aprovar antes de continuar.
4. Só depois de aprovado o rascunho, gerar o conjunto completo, com a resposta correta sempre
   na alternativa A — facilita a revisão humana antes de baralhar.
5. Verificar tecnicamente cada pergunta antes de apresentar ao utilizador (especialmente as de
   "antecipar resultado"/"identificar erro"), usando o comando de verificação do `CLAUDE.md`:
   o código compila, o comportamento previsto está certo, as convenções da disciplina são
   respeitadas. Para conjuntos grandes que exigem ler muito material fonte, considerar delegar
   a leitura/rascunho a um subagente para não sobrecarregar o contexto principal — mas rever
   sempre o resultado com o mesmo rigor.
6. Após aprovação do conjunto completo, gerar as variantes com perguntas e alternativas
   baralhadas de forma independente entre versões (número definido no `CLAUDE.md`), e o
   ficheiro de chave de correção coerente com essas variantes. Cada variante aprovada fica
   gravada como Markdown (`..._Prova_<variante>.md`) — este é o único ficheiro de conteúdo
   editado manualmente ou revisto pelo utilizador; nada a partir daqui volta a ser editado à
   mão.
7. Montar o `.tex` final de cada variante **a partir do LaTeX, nunca diretamente do
   Markdown**, seguindo os 2 passos e nomes de ficheiro definidos no `CLAUDE.md`
   ("Comandos"): (a) converter o `.md` aprovado num fragmento LaTeX com pandoc (sem `-s`); (b)
   montar o `.tex` final copiando o template partilhado, substituindo as variáveis do
   cabeçalho pelos valores do mapeamento no `CLAUDE.md` — **incluindo `\theVariant`, que tem
   de mudar para a letra correta em cada variante (A, B, C, ...), nunca deixado igual entre
   ficheiros** — e inserindo o fragmento no lugar do marcador `%%% QUESTIONS_PLACEHOLDER %%%`.
   A letra da variante tem de aparecer de forma visível no documento (o template já mostra
   `\theVariant` na capa e no rodapé de cada página) para os alunos assinalarem a versão
   correta na folha de respostas. **Parar aqui — não compilar, não gerar PDF.** A compilação
   com xelatex é feita fora deste processo, pelo utilizador (comandos documentados no README
   do repositório), para não exigir a cadeia LaTeX completa instalada no ambiente onde o
   Claude Code corre.

## 8. Formato de chave de correção (se aplicável, ex.: ZipGrade)
Sem linha de cabeçalho. Duas linhas por pergunta e por versão:
```
<versão>,<nº pergunta>,<letra correta>,<pontos por acerto>,
<versão>,<nº pergunta>,[a&i],<pontos por erro (negativo)>,
```
Confirmar sempre o formato exato com um ficheiro-exemplo já existente no repositório
(`find . -iname "*keys*.csv"` ou semelhante) antes de o gerar de raiz — o formato pode variar
por sistema de correção ou por disciplina.

Se não houver outra indicação, fazer para uma pontuação total de 20 valores, com peso igual
para todas as perguntas. As respostas erradas descontam um valor dado por C/(N-1), em que C é
a cotação de uma resposta certa e N é o número de alternativas em cada questão.
