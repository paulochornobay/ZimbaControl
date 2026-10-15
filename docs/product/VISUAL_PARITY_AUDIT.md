# ZimbaControl — Auditoria canônica de paridade visual

**Data:** 2026-08-23

**Protótipo auditado:** `C:\dev\pixel-perfect-pixels@2848fc6`

**Aplicativo auditado:** `C:\dev\ZimbaControl@cd67fcb`

**Escopo:** todas as rotas publicadas pelo protótipo e jornadas adicionais do Flutter

## Readequação visual — setembro de 2026

### Marco 0 — Registro

- **Data do registro:** 2026-09-01.
- **Baseline Lovable congelado:** `pixel-perfect-pixels@33fb92b55c884cc61a7eb00307b7a8c2c51e25ad`, branch `main`.
- **Local analisado:** `http://localhost:8080/`, disponível na data do registro
  (HTTP 200). A inspeção deste marco é somente de referência; nada foi alterado,
  gerado, publicado ou enviado ao repositório Lovable.
- **Estado observado no Lovable:** worktree já sujo em
  `src/routeTree.gen.ts` e `package-lock.json`; essas alterações preexistentes
  não fazem parte deste marco e devem permanecer intactas.
- **Worktree Flutter:** estava sujo no início da readequação. A decisão é
  preservá-lo integralmente: não fazer `reset`, `stash`, reformatar, atualizar
  goldens ou alterar código/testes como efeito deste Marco 0.

### Inventário das 21 rotas de tela

O inventário é derivado de `src/routes` no baseline. A rota `/review` existe
somente como redirecionamento para `/` e, portanto, não é contada como tela.

| # | Rota |
| ---: | --- |
| 1 | `/` |
| 2 | `/backup` |
| 3 | `/capture` |
| 4 | `/commitments` |
| 5 | `/duplicates` |
| 6 | `/family` |
| 7 | `/identidade` |
| 8 | `/import` |
| 9 | `/invoices` |
| 10 | `/local-data` |
| 11 | `/movimentacoes` |
| 12 | `/onboarding` |
| 13 | `/registries` |
| 14 | `/rules` |
| 15 | `/settings` |
| 16 | `/summary` |
| 17 | `/sync-privacy` |
| 18 | `/reports/mensal` |
| 19 | `/reports/parcelas` |
| 20 | `/transaction/$id` |
| 21 | `/transaction/new` |

### Marco 1 — Fundação visual e shell compartilhado

Concluído em 2026-09-01. A fundação consolidou tokens Zimba existentes no
tema e nas primitivas compartilhadas: shell principal, cabeçalho compacto,
navegação inferior com área segura, botões, sheets, segmentação, rows e
feedbacks. A validação de layout ocorreu em `360×800` e `390×844`, com texto
em `1,3`, sem alterar Drift, regras financeiras, sync, importação ou goldens.
O Marco 2 está registrado abaixo.

### Marco 2 — Revisão e Movimentações

Concluído em 2026-09-01, limitado às jornadas de Revisão e Movimentações.

- **Revisão:** aplica o cabeçalho compacto e estados visuais de carregamento,
  vazio e erro; preserva os cartões, avatares, badges e todas as ações Drift.
  Confirmar e ignorar seguem oferecendo feedback temporário com **Desfazer**.
- **Movimentações:** aplica cabeçalho compacto com importação, busca com
  limpeza, chips rápidos, lista densa, valores, avatares e badges. Filtros
  avançados continuam em bottom sheet e agora ficam visíveis/removíveis quando
  ativos, inclusive por combinação de filtros.
- **Validação automatizada:** confirmação, ignorar/desfazer, abertura do
  detalhe, busca, filtros combinados e limpeza dos filtros foram exercitados
  em `phase1_widget_test.dart`. O conjunto passou com 14 testes, nos viewports
  `360×800` e `390×844`, incluindo escala de texto `1,3`, sem exceções ou
  overflow.
- **Evidência Flutter:** os goldens determinísticos de Revisão e Movimentações
  foram atualizados em `apps/mobile/test/goldens/phase1/` para os dois
  viewports solicitados. Não houve nova captura pareada ou alteração no
  Lovable neste marco.
- **Limite:** não houve mudança em Drift, banco, regras financeiras, sync,
  parsing ou fluxo de importação; apenas apresentação, testes e documentação.

### Marco 3 — Novo lançamento e detalhe/edição

Concluído em 2026-09-01, limitado a Novo lançamento e Detalhe/Edição.

- **Novo lançamento:** aplica cabeçalho compacto, seções de valor/tipo,
  descrição, instrumento, classificação e participantes. A escolha de conta ou
  cartão ocorre em sheet compartilhado e exibe tipo, instituição, titular e
  final para eliminar ambiguidade; categoria e centro continuam com criação
  inline e retorno já selecionado.
- **Detalhe/Edição:** mantém leitura como estado inicial e edição somente por
  ação explícita. Exibe badges de estado, tipo, origem e confiança; alertas
  reais de duplicidade provável, baixa confiança e sugestão de transferência;
  classificação, participantes, instrumento e origem permanecem em seus
  seletores e sheets.
- **Integridade:** o título amigável continua em `displayDescription`; a
  descrição externa `descriptionRaw` é mostrada bloqueada e não é alterada pela
  edição. Nenhum contrato, schema Drift ou regra de domínio foi modificado.
- **Validação:** passaram `phase1_widget_test.dart` (14), `phase2_test.dart`
  (4) e `marco3_widget_test.dart` (2). A cobertura inclui receita, despesa,
  transferência, criação inline, instrumento ambíguo, texto externo imutável,
  edição explícita, alertas e texto longo em `360×800` com escala `1,3`.
- **Evidência Flutter:** os goldens do detalhe em
  `apps/mobile/test/goldens/phase1/` foram atualizados para `360×800` e
  `390×844`; não houve alteração ou publicação no Lovable.

### Marco 4 — Resumo e relatórios

Concluído em 2026-09-01, limitado a Resumo, Relatório mensal e Parcelas
futuras.

- **Resumo (/summary):** ganhou seletor de competência, totais realizados,
  pendências isoladas e leitura alternável por categoria ou grupo/contexto. Os
  totais e seus detalhamentos usam somente lançamentos confirmados;
  transferências confirmadas são mostradas como neutras.
- **Relatórios filhos:** o reports_page.dart existente foi consolidado como
  entrada para Relatório mensal (/reports/mensal) e Parcelas futuras
  (/reports/parcelas), ambos com cabeçalho de retorno. Eles não integram a
  navegação principal, que continua com cinco destinos.
- **Mensal e projeção:** o mensal separa pendências dos valores realizados,
  permite alternar categoria/contexto e mostra mês vazio. Parcelas futuras
  agrupa planos e recorrências por competência conhecida e deixa explícito que
  é previsão; o cálculo é local e não cria transações.
- **Validação:** marco4_widget_test.dart passou com 3 testes em 360×800 e
  390×844, escala 1,3, cobrindo mês vazio, valores grandes, alternância de
  detalhamento e projeção sem escrita. A regressão da agregação operacional e
  flutter analyze também passaram, sem exceções ou overflow.
- **Integridade:** não houve alteração de schema, contrato Drift, dados
  existentes, sync, importação ou baseline Lovable.

### Marco 5 — Ajustes, cadastros e domínio familiar

Concluído em 2026-09-01, limitado a Ajustes, Família, Cadastros,
Compromissos e Faturas.

- **Shell e estados:** as jornadas filhas usam cabeçalho compacto com retorno
  e ações reais de atualizar, salvar ou criar. O carregamento, vazio e erro
  usam os componentes compartilhados; o estado de carregamento passou a
  truncar seu rótulo em telas estreitas, sem overflow.
- **Ajustes e Família:** Ajustes preserva todos os acessos reais no hub denso.
  Família apresenta a composição existente e continua encaminhando para
  cadastros e compromissos, sem criar membros ou permissões fictícias.
- **Cadastros e Compromissos:** pessoas, contas, cartões, taxonomia,
  arquivamento e formulários continuam no CRUD existente. A conta técnica de
  um cartão não é mais duplicada como conta bancária; isso mantém claros conta
  e cartão do mesmo banco. Recorrências e planos continuam alternáveis e
  editáveis, com suas projeções apenas de leitura.
- **Faturas:** a consolidação existente mantém ciclos, limite, compras,
  estornos, pagamentos parciais, conciliação, desfazer e projeções, agora no
  mesmo shell visual; nenhum pagamento foi convertido em despesa.
- **Validação:** passaram 11 testes nas suítes marco5_widget_test.dart,
  marco_c_widget_test.dart, registries_page_widget_test.dart e phase4b_test.dart,
  em 360×800 e 390×844 com texto 1,3. A cobertura inclui vazio, dados longos,
  conta/cartão do mesmo banco, compromisso ativo, fatura parcial, estorno,
  pagamento e ausência de overflow. flutter analyze também passou.
- **Integridade:** não houve mudança de schema, contratos Drift, cálculos de
  fatura, pagamentos, recorrências, planos ou projeções.

### Marco 6 — Operações de suporte

Concluído em 2026-09-01, limitado a Importação, Conciliação, Regras, Backup,
Sync/Privacidade, Captura Android e Dados locais/reset.

- **Shell e estrutura:** todas as jornadas adotam o cabeçalho compacto, a
  largura e o espaçamento do shell compartilhado. Importação mantém o
  stepper, a prévia e os badges; Conciliação usa o card de comparação e deixa
  explícito o efeito de mesclar, manter separado ou ignorar.
- **Operações reais:** CSV/OFX continuam aceitos somente pelo fluxo local, com
  mapeamento, prévia e confirmação de destino antes de enviar registros à
  revisão. As regras persistentes mantêm texto, prioridade, estado e destino;
  backup continua validando o arquivo antes da confirmação de restauração.
- **Estados honestos:** sync sem `SYNC_ENABLED` e `API_BASE_URL` informa que
  nada será enviado. Captura expõe a disponibilidade e a permissão efetiva do
  Android, sem habilitar apps fora da plataforma. Dados locais mostra o
  inventário real; reset exige `ZERAR` e explica as permissões preservadas.
- **Validação:** marco6_widget_test.dart passou em 360×800 e 390×844, texto
  1,3, cobrindo shell, sync desligado, captura Android indisponível e reset.
  Também passaram phase2_test.dart, import_parser_test.dart e os testes
  direcionados de backup/restauração, importação CSV com destino confirmado e
  captura no app_database_test.dart (20 testes no total), sem exceções ou
  overflow. `flutter analyze` não reportou problemas.
- **Integridade:** não houve mudança de schema, contratos Drift, parser,
  confirmação de destino, regras financeiras, reset coordenado ou protocolo
  de sync.

### Marco 7 — Onboarding progressivo

Concluído em 2026-09-01, limitado à jornada de configuração inicial.

- **Jornada visual:** o onboarding agora avança por boas-vindas, pessoa,
  instituição, tipo de instrumento, identidade, dados do cartão quando
  aplicável, categorias e revisão. O cabeçalho informa etapa e progresso;
  voltar mantém as respostas enquanto a tela está aberta e interromper não
  cria dados.
- **Catálogo seguro:** instituições e bandeiras são apresentadas por
  monogramas, cores e ícones vetoriais próprios, com “Outra instituição” como
  fallback. Não foram adicionados logos ou ativos de terceiros.
- **Persistência real:** `saveInitialSetup` passou a criar conta ou cartão de
  crédito real na mesma transação da pessoa, preferências e catálogo inicial.
  Cartão persiste bandeira, final, fechamento e vencimento; a conta técnica
  continua sendo o instrumento primário. As categorias escolhidas são as
  únicas provisionadas, e nenhum lançamento de demonstração é criado.
- **Retorno e demonstração:** reset volta ao estado que exige onboarding. A
  demonstração segue disponível apenas por ação explícita e usa o fluxo de
  demo existente, separado da configuração normal.
- **Validação:** marco7_widget_test.dart passou com cinco cenários: instalação
  limpa/demonstração explícita, conta versus cartão, dados de cartão,
  categorias selecionadas, respostas ao voltar, validações, interrupção,
  conclusão transacional e retorno após reset. As jornadas visuais foram
  exercitadas em 360×800 e 390×844. onboarding_widget_test.dart, phase2_test.dart
  e a regressão de setup inicial no app_database_test.dart também passaram
  (18 testes ao todo); `flutter analyze` não reportou problemas.
- **Integridade:** não houve mudança de schema nem lançamento automático;
  somente a entrada de setup foi estendida para representar cartão e catálogo
  inicial de modo explícito.

### Marco 8 — Regressão visual, acessibilidade e homologação

Concluído em 2026-09-01 para homologação automatizada; não houve redesign fora
das correções abaixo.

| Cobertura | Evidência revisada |
| --- | --- |
| 21 rotas Lovable, incluindo relatórios mensal e parcelas | 42 pares e 42 overlays em `360×800` e `390×844` |
| Diagnóstico responsivo adicional | 21 pares em `440×900` |
| Baseline | `docs/product/baselines/lovable/33fb92b/` (63 capturas; commit `33fb92b55c884cc61a7eb00307b7a8c2c51e25ad`) |
| Flutter | `apps/mobile/test/goldens/parity/<viewport>/` (21 goldens por viewport) |
| Comparação | `docs/product/comparisons/33fb92b/<viewport>/` |

- A matriz inclui shell, revisão, novo, detalhe, movimentações, ajustes,
  onboarding, importação, conciliação, família, regras, backup,
  sync/privacidade, relatórios, identidade, cadastros, faturas, compromissos,
  captura e dados locais. `/reports/mensal` e `/reports/parcelas` passaram a
  integrar também o capturador e o teste golden de paridade.
- Acessibilidade/regressão: os cenários de texto `1,3`, vazio, erro,
  carregamento, offline e textos/valores longos foram reexecutados pelas
  suítes de cada marco. `flutter analyze` passou sem problemas e a suíte
  integral passou com **159 testes**.
- Correções de regressão: goldens legados foram renovados; lotes de importação
  agora acrescentam uma sequência por instância ao timestamp, evitando colisão
  em importações imediatas; os testes de filtros e de formulário tornaram-se
  independentes do relógio e do teclado do runner.
- Diferenças deliberadas: conteúdos financeiros e filas usam Drift real, não
  os mocks do Lovable; permissões, rede/sync e backup exibem estados reais;
  relatórios Flutter usam retorno nativo como jornadas filhas. A tolerância do
  golden é limitada a `0,04%` para rasterização Chromium/Skia (89 pixels no
  detalhe); dimensões, hierarquia e overflow continuam obrigatórios.
- Android físico: `adb` disponível, porém sem dispositivo enumerado. O AVD
  `Pixel_Tablet` não foi iniciado porque não equivale ao roteiro físico. A
  aprovação automatizada é favorável; TalkBack, toque e ciclo no aparelho
  continuam pendentes de conexão física.

### Estratégia de evidência para os marcos posteriores

Para cada rota aplicável, capturar Lovable e Flutter com dados demonstrativos
determinísticos, sem dados pessoais, em `360×800` e `390×844`. Comparar pares
de mesma rota/estado por overlay semitransparente, conferindo moldura,
alinhamento, espaçamento, tipografia, cores e cortes/overflow. A evidência
deve registrar baseline, rota, estado e viewport; diferenças deliberadas devem
ser anotadas antes de qualquer aceite. O Marco 1 validou somente a fundação;
as capturas pareadas dos demais fluxos permanecem trabalho dos marcos
posteriores.

## 1. Resultado executivo

O app Flutter preserva mais comportamento financeiro real que o protótipo e as
Fases 1–5 eliminaram as divergências críticas de Movimentações, confirmação,
descrição, identidade de instrumentos, classificações, reset, importação,
faturas e hierarquia do Resumo. Todas as rotas ficaram equivalentes ou possuem
uma diferença deliberada registrada. Resta somente a homologação Android
física da candidata assinada.

A próxima etapa não é uma troca de tecnologia nem uma cópia do React. É a
tradução sistemática da hierarquia visual do protótipo para widgets Flutter,
mantendo Drift, parsers e ações reais.

### Atualização de implementação — 2026-08-23

As Fases 1, 2 e 3 resolveram localmente os itens 6.1 a 6.6:
navegação e Movimentações compactas, snackbar temporário, detalhe com título
amigável, instrumentos identificáveis, classificações visuais e reset
coordenado. Seis goldens cobrem Revisão, Movimentações e Detalhe em 360×800 e
390×844; testes adicionais cobrem criação inline, migração/backup e todos os
stores do reset. A Importação agora preserva identidade do demonstrativo,
confirma o destino e bloqueia ambiguidade; o item 6.7 permanece no roadmap, e
a Fase 4 resolveu o item 6.7. Na Fase 5, o Resumo foi recomposto, 13 jornadas
foram exercitadas em dois viewports e Resumo/Ajustes/Família receberam goldens.
A homologação Android integral continua pendente apenas porque o ADB não
enumerou o aparelho no fechamento.

## 2. Evidências e limites da auditoria

- As 12 telas do protótipo foram percorridas em `http://localhost:8080/` e
  conferidas também no DOM e nos arquivos de `src/routes`.
- A rota `/review` apenas redireciona para `/`; não é uma 13ª tela.
- O Flutter foi comparado por código, estados disponíveis e capturas fornecidas
  durante a auditoria.
- O protótipo estava com alterações locais preexistentes em
  `src/routeTree.gen.ts` e `package-lock.json`. Nada foi alterado ou publicado
  no repositório de referência.
- Nenhuma captura com dados pessoais integra esta documentação. Novos
  screenshots de homologação devem usar dados demonstrativos anonimizados.
- A validação física ficou pendente: em 2026-08-23 o ADB não enumerou nenhum
  aparelho, mesmo após reiniciar o servidor. Isso não invalida as diferenças
  estruturais encontradas, mas impede declarar homologação Android concluída.

## 3. Contrato visual observado

| Elemento | Regra de referência |
| --- | --- |
| Moldura | largura total no Android; preview web centralizado, máximo de 440 px |
| Fundo e texto | fundo `#F7F8FA`, texto principal próximo de `#0F172A`, superfícies brancas |
| Grade | múltiplos de 4 px; margem horizontal usual de 16 px |
| Cabeçalho | compacto, título de aproximadamente 19 px, subtítulo de 12 px e ação contextual |
| Superfícies | borda discreta, sombra curta e raio coerente; listas densas podem compartilhar uma superfície |
| Controles | raio de 12 px; cards e sheets entre 16 e 28 px conforme hierarquia |
| Tipografia | Inter, valores com peso e alinhamento que facilitem varredura |
| Navegação | Resumo, Revisão, Novo, Movim. e Ajustes; ícone e rótulo sempre coerentes |
| Ícones | traço consistente, tamanho visual uniforme e significado acompanhado por texto/semântica |
| Estados | vazio, carregamento, erro, sucesso e indisponibilidade reais, sem conteúdo fictício |

O aceite de medidas será feito por overlay nos viewports 360×800 e 390×844.
Para componentes estáveis, a tolerância visual é de aproximadamente 2 dp;
diferenças deliberadas exigem registro.

## 4. Inventário completo das telas do protótipo

| Rota | Jornada Flutter | Resultado da Fase 5 | Classificação |
| --- | --- | --- | --- |
| `/` | `review_page.dart` | composição compacta, ações Drift e confirmação temporária | equivalente |
| `/summary` | `dashboard_page.dart` | hierarquia mensal, blocos densos, leituras e origens reais | equivalente |
| `/transaction/new` | `new_transaction_page.dart` | criação real, instrumento inequívoco e classificação inline | equivalente |
| `/transaction/$id` | `edit_transaction_page.dart` | leitura separada da edição e texto original imutável | equivalente |
| `/movimentacoes` | `movements_page.dart` | busca/chips compactos, filtros em sheet e lista densa | equivalente |
| `/settings` | `settings_home_page.dart` | hub compacto preservando todos os estados reais | equivalente |
| `/family` | `family_structure_page.dart` | informações reais agrupadas no mesmo sistema visual | equivalente |
| `/backup` | `BackupSettingsPage` | exportação/restauração local, sem nuvem automática fictícia | diferença deliberada |
| `/rules` | `RulesPreviewPage` | CRUD existente e indisponibilidades explicadas | diferença deliberada |
| `/sync-privacy` | `SyncPrivacyPreviewPage` | estado real de fila/sessão; não promete sync quando desligado | diferença deliberada |
| `/import` | `import_page.dart` | etapas reais com identidade, destino, prévia e histórico | equivalente |
| `/duplicates` | `duplicates_page.dart` | comparação e decisões ligadas à conciliação real | equivalente |

### Redirecionamento

`/review` redireciona para `/`. No Flutter, “Revisão” deve continuar abrindo a
fila real, sem criar uma tela duplicada apenas para reproduzir a URL.

## 5. Jornadas que existem apenas no Flutter

Estas telas não têm rota equivalente no protótipo e precisam adotar o mesmo
sistema visual sem inventar uma referência inexistente:

| Jornada | Implementação atual | Diretriz |
| --- | --- | --- |
| Onboarding | `onboarding_page.dart` | instalação limpa, sem seed; cadastro inicial real ou demo explícita |
| Cadastros | `registries_page.dart` | separar contas, cartões, categorias e centros com ícones e estados claros |
| Compromissos | `commitments_page.dart` | preservar recorrências e parcelas reais; usar cards responsivos e CTAs acessíveis |
| Captura Android | `NotificationSettingsPage` | mostrar permissão, allowlist, fila e erro reais; sem equivalência web fictícia |
| Dados locais/reset | `DataEnvironmentPage` | entregue na Fase 2; homologar backup, teclado e reset em Android físico |

## 6. Defeitos comprovados e causa técnica

### 6.1 Movimentações e navegação

- `ZimbaBottomNavigation` rotula o quarto destino como “Filtros”; o protótipo e
  a arquitetura canônica o definem como “Movim.”.
- `MovementsPage` insere `MovementFilterPanel` e `MovementTotalsCard` antes da
  lista. Isso explica o painel alto e o resumo repetido das capturas atuais.
- A fonte oficial usa busca compacta, chips horizontais e filtros avançados em
  bottom sheet, seguidos imediatamente pela lista densa.

### 6.2 Confirmação que não desaparece

`review_page.dart` cria um `SnackBar` com ação “Desfazer” sem definir
explicitamente persistência. Na versão atual do Flutter, snackbars com ação
podem persistir. O comportamento esperado é duração explícita,
`persist: false`, fechamento acessível e descarte ao mudar de jornada.

### 6.3 Conta e cartão indistinguíveis

`new_transaction_page.dart` mostra `item.account.name` nos chips. Embora o
banco armazene provedor, tipo, titular e últimos quatro dígitos, a seleção não
usa esses dados. Categorias e centros também possuem apenas nome no modelo
atual, sem chave de ícone ou cor.

**Resolvido na Fase 2:** `InstrumentDisplay` apresenta nome, provedor, tipo,
titular e últimos dígitos; categorias e centros persistem `iconKey` e
`colorKey`, com fallback, sugestão e seletor vetorial.

### 6.4 OFX associado pelo banco, não pelo instrumento

O parser atual percorre `STMTTRN`, lê data, valor, `NAME`, `MEMO` e `FITID`, mas
não preserva `BANKACCTFROM`, `CCACCTFROM` ou `ACCTID`. Depois, a promoção chama
`_accountForProvider`, que retorna a primeira conta ativa daquele provedor.
Com conta corrente e cartão Nubank cadastrados, a escolha pode ser ambígua ou
incorreta e os detalhes do cartão desaparecem do lote.

**Resolvido na Fase 3:** o parser preserva `BANKACCTFROM`, `CCACCTFROM`,
`ACCTID`, moeda, período e saldos; o lote exige `targetAccountId` confirmado e
a promoção/conciliação não consulta mais a primeira conta ou cartão. Empates,
tipo/final incompatíveis e identificador ausente permanecem bloqueados até a
escolha explícita.

### 6.5 Descrição sem semântica clara

`Transactions` possui apenas `descriptionRaw`, e o formulário de edição o usa
como texto editável. O requisito aprovado é separar um título amigável
editável da descrição original somente leitura.

### 6.6 Reset escondido e incompleto

“Apagar dados locais” já existe em Ajustes > Dados locais, porém é pouco
encontrável. `clearLocalData()` não remove atualmente `syncAppliedEvents` nem
`syncConflicts` e não coordena a fila SQLite nativa, preferências fora do Drift
ou sessão segura. Portanto, não equivale ainda a “começar do zero”.

**Resolvido na Fase 2:** a área de perigo ficou visível em Dados locais, exige
`ZERAR`, oferece backup, mostra contagens e coordena Drift, staging, sync, fila
nativa, preferências e sessão antes do retorno ao onboarding. A tela explica
que permissões concedidas pelo Android permanecem.

### 6.7 Fatura sem entidade própria

Cartões já armazenam dia de fechamento e vencimento e há helpers de cálculo de
mês/vencimento. Não existe, porém, entidade de fatura, pagamento, estado ou
tela de consolidação. O helper atual não substitui uma fatura auditável e não
cobre sozinho corte, estorno, pagamento parcial e correção manual.

**Modelo resolvido na Fase 4A:** Drift 14 passou a persistir fatura, pagamento,
estado derivado, vínculo da transação e auditoria de correções.

**Visão resolvida na Fase 4B:** o Flutter mostra consolidação, compras,
estornos, pagamentos e filtros em dois viewports.

**Conciliação resolvida na Fase 4C:** OFX bancário pode sugerir pagamento, OFX
de cartão alimenta compras e parcelas futuras aparecem apenas como projeção.
Toda efetivação exige confirmação. O protótipo vigente não oferece uma rota
completa de fatura para comparação direta, portanto esta tela é uma diferença
deliberada baseada no design system canônico.

## 7. Critérios de paridade

Uma tela só pode ser marcada como equivalente quando:

1. preserva todas as ações reais e não introduz ação mockada;
2. mantém hierarquia, densidade, espaçamento, tipografia e iconografia do
   baseline nos dois viewports;
3. funciona com vazio, carregamento, erro, nomes longos, valores grandes e
   escala de texto 1,3;
4. possui alvos de 48 dp e semântica para TalkBack;
5. não causa overflow, CTA encoberto ou feedback persistente entre telas;
6. foi comparada por screenshot/overlay e, no fechamento, em Android físico.
