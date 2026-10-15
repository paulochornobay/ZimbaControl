# ZimbaControl - Current State

> Fonte operacional canônica desde 2026-08-23:
> `docs/product/PRODUCT_REQUIREMENTS.md`,
> `docs/product/VISUAL_PARITY_AUDIT.md` e
> `docs/product/IMPLEMENTATION_ROADMAP.md`. O inventário abaixo preserva o
> histórico técnico; em caso de divergência, prevalecem os documentos de
> `docs/product`.

## Readequação visual — setembro de 2026

### Marco 0 — Registro operacional

- Registro feito em **2026-09-01** contra o baseline Lovable
  `pixel-perfect-pixels@33fb92b55c884cc61a7eb00307b7a8c2c51e25ad`, branch
  `main`.
- `http://localhost:8080/` foi analisado e respondeu HTTP 200. A referência
  Lovable não foi modificada, gerada, publicada nem recebeu commits.
- O worktree Lovable já estava sujo em `src/routeTree.gen.ts` e
  `package-lock.json`; manter esse estado preexistente é obrigatório.
- O worktree Flutter atual também já estava sujo. A decisão deste marco é
  preservá-lo integralmente, sem `reset`, `stash`, reformatação, atualização de
  goldens ou alteração de produção.

### Inventário das 21 rotas de tela Lovable

`/review` é apenas um redirecionamento para `/` e não é contado como tela.

| # | Rota | # | Rota | # | Rota |
| ---: | --- | ---: | --- | ---: | --- |
| 1 | `/` | 8 | `/import` | 15 | `/settings` |
| 2 | `/backup` | 9 | `/invoices` | 16 | `/summary` |
| 3 | `/capture` | 10 | `/local-data` | 17 | `/sync-privacy` |
| 4 | `/commitments` | 11 | `/movimentacoes` | 18 | `/reports/mensal` |
| 5 | `/duplicates` | 12 | `/onboarding` | 19 | `/reports/parcelas` |
| 6 | `/family` | 13 | `/registries` | 20 | `/transaction/$id` |
| 7 | `/identidade` | 14 | `/rules` | 21 | `/transaction/new` |

### Marco 1 — Fundação visual e shell compartilhado

- Concluído em **2026-09-01**, sem iniciar o Marco 2.
- `ZimbaTheme` e `zimba_ui.dart` agora centralizam shell das cinco jornadas,
  header compacto, navegação inferior segura, botões, sheets, segmentação,
  rows e feedbacks com os tokens Zimba existentes.
- `ZimbaHomeShell` utiliza `ZimbaHomeScaffold`; as telas mantêm seus próprios
  estados e operações. Drift, regras financeiras, sync e importação não foram
  alterados, nem houve atualização de goldens.
- Os componentes foram exercitados em `360×800` e `390×844`, texto `1,3`.

### Marco 2 — Revisão e Movimentações

- Concluído em **2026-09-01**, sem ampliar o escopo para outros fluxos.
- Revisão usa o shell compartilhado, estados visuais de carregamento, vazio e
  erro, e feedback temporário com desfazer; confirmar, ignorar e abrir detalhe
  continuam ligados às operações Drift existentes.
- Movimentações usa cabeçalho compacto, busca, chips, lista densa com valores,
  badges e avatares, e filtros avançados em bottom sheet. Filtros combinados
  ficam explícitos, podem ser removidos individualmente ou limpos por completo.
- A regressão de interface passou em 14 testes (`phase1_widget_test.dart`),
  cobrindo confirmação, ignorar/desfazer, detalhe, busca, filtros combinados e
  limpar filtros. Foram atualizados goldens determinísticos em `360×800` e
  `390×844`, com escala de texto `1,3` e sem exceções/overflow.
- O marco não altera Drift, banco, regras financeiras, sync, parsing,
  importação ou o baseline Lovable.

### Marco 3 — Novo lançamento e detalhe/edição

- Concluído em **2026-09-01**, sem ampliar o trabalho para outras jornadas.
- Novo lançamento usa seções compactas e seleção de instrumento em sheet,
  identificando conta/cartão por instituição, tipo, titular e final. Mantém
  classificação visual, participantes e criação inline de categoria/centro.
- Detalhe/Edição inicia bloqueado para leitura, usa sheets para escolha e
  apresenta origem, confiança, duplicidade provável e transferência sugerida
  quando esses estados já existem. A conversão de transferência preserva a
  operação Drift existente.
- A edição conserva `descriptionRaw` como texto externo imutável e grava o
  título amigável em `displayDescription`, sem alteração de contrato de dados.
- Passaram análise estática e 20 testes nas suítes de regressão exercitadas
  (`phase1_widget_test.dart`, `phase2_test.dart` e `marco3_widget_test.dart`).
  Goldens do detalhe foram atualizados em `360×800` e `390×844`, incluindo
  escala de texto `1,3` e textos longos sem exceção/overflow.

### Marco 4 — Resumo e relatórios

- Concluído em **2026-09-01**, sem ampliar o trabalho para outras jornadas.
- Resumo ganhou competência selecionável e separação explícita entre
  realizados e pendências. Totais e detalhamentos usam confirmados; as
  transferências aparecem como neutras, fora de receita, despesa e saldo.
- O reports_page.dart existente foi consolidado como jornada filha para
  Relatório mensal e Parcelas futuras, com cabeçalho de retorno. A navegação
  principal permanece com cinco itens.
- O mensal alterna categoria/contexto e explica mês vazio. A projeção agrupa
  planos e recorrências por competência sem criar transações no Drift.
- marco4_widget_test.dart passou com 3 testes em 360×800 e 390×844, texto 1,3,
  valores grandes e sem overflow; a regressão de agregação operacional e a
  análise estática também passaram.

### Marco 5 — Ajustes, cadastros e domínio familiar

- Concluído em **2026-09-01**, sem ampliar o trabalho para outras jornadas.
- Ajustes, Família, Cadastros, Compromissos e Faturas usam o shell compacto e
  estados compartilhados, preservando cada fluxo real e seus retornos.
- Cadastros mantém CRUD e arquivamento de pessoas, instrumentos e taxonomia.
  A conta técnica de cartão não é exibida duas vezes como conta bancária, o que
  diferencia corretamente conta e cartão do mesmo banco.
- Recorrências, planos, faturas, pagamentos, estornos e projeções continuam
  ligados às operações Drift existentes; previsão não cria lançamento.
- Passaram 11 testes nas suítes marco5_widget_test.dart, marco_c_widget_test.dart,
  registries_page_widget_test.dart e phase4b_test.dart, em 360×800 e 390×844
  com texto 1,3. Foram cobertos vazio, dados longos, instrumentos equivalentes,
  compromisso ativo, fatura parcial, estorno, pagamento e overflow; flutter
  analyze também passou.

### Marco 6 — Operações de suporte

- Concluído em **2026-09-01**. Importação, Conciliação,
  Regras, Backup, Sync/Privacidade, Captura Android e Dados locais/reset usam
  a hierarquia do shell compacto e os componentes compartilhados.
- CSV/OFX continua local, com mapeamento, prévia e destino confirmado antes da
  promoção para revisão. A conciliação preserva as três resoluções existentes;
  regras, backup/restauração e reset continuam associados às ações Drift.
- Sync sem configuração não simula conectividade nem envio. Captura Android
  informa disponibilidade e permissão reais. Reset exige `ZERAR`; a restauração
  só segue depois da validação do arquivo e da confirmação de substituição.
- marco6_widget_test.dart passou em 360×800 e 390×844 com escala 1,3. Com
  phase2_test.dart, import_parser_test.dart e os casos direcionados de
  app_database_test.dart, foram 20 testes aprovados para estados críticos;
  `flutter analyze` não encontrou problemas.

### Marco 7 — Onboarding progressivo

- Concluído em **2026-09-01**, sem iniciar novo marco. A primeira execução é
  uma jornada por etapas para pessoa, instituição, conta/cartão, identidade,
  ciclo do cartão, categorias e revisão, com progresso visível e retorno que
  preserva respostas enquanto a configuração permanece aberta.
- Instituições e bandeiras usam monogramas e ícones vetoriais internos, com
  “Outra instituição” como fallback; nenhum logo de terceiro foi incluído.
- O setup normal cria dados reais e transacionais, sem lançamentos de exemplo:
  conta ou cartão, pessoa, preferências e apenas as categorias selecionadas.
  Cartão registra bandeira, final, fechamento e vencimento. Demonstração é uma
  escolha explícita; reset devolve o app ao estado de onboarding.
- marco7_widget_test.dart, onboarding_widget_test.dart, phase2_test.dart e a
  regressão de setup inicial passaram (18 testes, com 360×800 e 390×844);
  `flutter analyze` não encontrou problemas.

### Marco 8 — Regressão visual, acessibilidade e homologação

- Concluído em **2026-09-01** para a homologação automatizada, sem redesign
  adicional. O baseline de setembro `pixel-perfect-pixels@33fb92b` foi lido e
  capturado em 21 rotas, sem alterar o worktree Lovable.
- A matriz agora cobre `/`, `/summary`, `/transaction/new`,
  `/transaction/$id`, `/movimentacoes`, `/settings`, `/onboarding`,
  `/import`, `/duplicates`, `/family`, `/rules`, `/backup`,
  `/sync-privacy`, `/reports/mensal`, `/reports/parcelas`, `/identidade`,
  `/registries`, `/invoices`, `/commitments`, `/capture` e `/local-data` em
  `360×800` e `390×844`. Os dois relatórios, antes ausentes da captura ampla,
  foram incluídos na matriz e nos goldens.
- Foram revisados 42 pares lado a lado e 42 overlays nos viewports de aceite
  em `docs/product/comparisons/33fb92b/`; as 63 capturas Lovable ficam em
  `docs/product/baselines/lovable/33fb92b/` e os goldens Flutter em
  `apps/mobile/test/goldens/parity/`. O terceiro viewport `440×900` é
  evidência diagnóstica adicional.
- A suíte cobriu escala de texto `1,3`, vazio, erro, carregamento, offline e
  textos/valores longos nas jornadas e estados existentes. `flutter analyze`
  passou sem problemas e `flutter test` passou com **159 testes**.
- Correções encontradas: os goldens legados foram sincronizados; o ID de lote
  de importação ganhou sequência por instância para impedir colisão em duas
  importações imediatas; testes de filtro e de formulário deixaram de depender
  do relógio ou do teclado do runner. Não houve mudança de layout de produção.
- Diferenças deliberadas: dados, totais e estados vêm do Drift real, não dos
  mocks React; backup, sync, permissões e offline mostram o estado operacional
  honesto; relatórios permanecem jornadas filhas com voltar nativo. O
  comparador tolera somente até `0,04%` de pixels de rasterização
  Chromium/Skia (89 pixels no detalhe), sem dispensar diferenças estruturais.
- `adb` está instalado, mas não enumerou aparelho físico. Há um emulador
  `Pixel_Tablet` configurado, não iniciado por não substituir o roteiro físico.
  A aprovação física/TalkBack permanece pendente de um Android conectado.

### Estratégia de screenshot/overlay

Os marcos posteriores devem capturar Lovable e Flutter na mesma rota/estado,
usando dados demonstrativos determinísticos e os viewports `360×800` e
`390×844`. Cada par será comparado por overlay semitransparente para conferir
moldura, alinhamento, espaçamento, tipografia, cor e overflow, com baseline,
rota, estado e divergências deliberadas registrados. A base responsiva do
Marco 1 está validada; as capturas pareadas das demais rotas pertencem aos
marcos seguintes.

## Atualização canônica de 2026-08-23

- Item 0 do plano de continuidade concluído: requisitos, auditoria das 12
  telas do protótipo e roadmap por fases foram consolidados em `docs/product`.
- Fases 1, 2, 3, 4A, 4B, 4C e 5 concluídas tecnicamente. Além da fundação visual, o app agora
  distingue conta/cartão, persiste ícones e cores de categorias/centros,
  permite criação inline, oferece reset coordenado e exige instrumento
  confirmado em toda importação e possui o modelo calculável e auditável de
  faturas, visão por cartão, conciliação confirmável de pagamentos e projeção
  de parcelas sem despesas artificiais. A Fase 5 também recompôs o Resumo,
  fechou a matriz de paridade e preparou a candidata Android assinada.
- Referência visual oficial local: `C:\dev\pixel-perfect-pixels@2848fc6`.
- Código do app auditado: `ZimbaControl@cd67fcb`.
- Lacuna crítica restante: homologação Android integral em aparelho físico.
- A APK release `1.1.0+2` foi gerada com sucesso em
  `apps/mobile/build/app/outputs/flutter-apk/app-release.apk`, SHA-256
  `36C922AE12AA35C1BE22C4305C1DF8E08E2EB714D76ACCD58D3AB074750C2C57`.
  Ela é um artefato diagnóstico: usa certificado de debug e não é a candidata
  final de distribuição.
- O aparelho Samsung `SM-S908E` passou a ser enumerado pelo ADB e recebeu a
  build release da Fase 2 por atualização (`adb install -r`), preservando os
  dados. O processo iniciou normalmente; a homologação física completa
  continua reservada à Fase 5.
- A build release da Fase 3 foi gerada, SHA-256
  `5EE399A51FF674F82314EAB8838D36A6363D542E72675D51A480AE6AAD977C02`. A
  tentativa de atualização foi interrompida porque o aparelho desapareceu do
  ADB durante a instalação; repetir `adb install -r` quando ele reconectar.
- A build release com as Fases 4A e 4B foi gerada, SHA-256
  `64335CDDCFEE59A80777001C93EE662E54F04EDA0F0A1829AF500BBC2861E61D`.
  O Samsung apareceu inicialmente como `unauthorized` e depois saiu da lista
  do ADB; a instalação por atualização continua pendente de reconexão e aceite
  da depuração USB no aparelho.
- A build release da Fase 4C foi gerada, SHA-256
  `6BC4F771690FD6B19BEC5DCFAE9E20DC798D5A6F25DD8B89F1D355861C8A7E94`.
  O ADB não enumerou aparelho conectado no fechamento do marco, portanto esta
  build ainda não foi instalada no Samsung.
- A candidata pessoal `1.2.0+3` foi gerada com chave RSA 4096 externa ao Git,
  assinatura v2 verificada e SHA-256
  `0D29C9D3D1D0F9177C57DFBE2BFD49E22809A7DE54084603C77396E42E7FC2E5`.
  A regressão passou em 99 testes Flutter e 7 testes da API. Como o APK
  anterior usa certificado de debug, a instalação exige backup seguido de
  desinstalação; o ADB não enumerou o aparelho no fechamento e nenhum dado foi
  apagado.

## Estado Atual

- Repositorio estruturado como monorepo.
- Plano aprovado: Lovable como prototipo; Flutter como app final.
- Toolchains detectadas localmente: Flutter, Dart, Node.js, npm e unzip.
- PDF/DOCX de arquitetura analisado e resumido nos arquivos de contexto.
- O front Lovable duplicado foi removido do monorepo. A referencia visual vive
  exclusivamente em `C:\dev\pixel-perfect-pixels`.
- O ciclo historico de recuperacao mobile usou
  `pixel-perfect-pixels@6a2d072` como baseline visual.
- A recuperacao do app local esta implementada: primeira abertura sem seed,
  onboarding transacional com pessoa e conta reais, demonstracao apenas por
  escolha explicita e lancamento manual sem IDs ficticios.
- O Flutter tem tema proprio inspirado no baseline externo, com Inter
  embutida, tokens compartilhados, cards, botoes, navegacao e formularios
  consistentes. Nenhum componente React/Tailwind foi copiado.
- A estrutura da navegacao principal e Resumo, Revisao, Novo, Movimentacoes e
  Ajustes; o quarto destino agora aparece como “Movim.”. Ajustes expõe apenas
  jornadas com estado real.
- App Flutter criado em `apps/mobile`.
- API Fastify criada em `apps/api`.
- Contratos OpenAPI/JSON Schema criados em `packages/contracts`.
- Mobile tem Drift/SQLite com tabelas principais do Marco 03, seeds,
  dashboard, caixa de revisao real, edicao basica, confirmacao, ignorar,
  duplicado, conversao em transferencia, desfazer e outbox local.
- Mobile tambem tem a estrutura familiar do Marco 05: proprietario em
  contas/cartoes, usuario de acesso separado, recorrencias para escola, pensao
  e ajuda familiar, plano de consorcio e transferencia interna fora do resumo
  de receita/despesa.
- Mobile tem importacao local CSV/OFX do Marco 06: escolha de arquivo,
  parser CSV/OFX, hashes de arquivo/linha, staging, adapters Nubank/Mercado
  Pago, deteccao e mapeamento visual de colunas, previa amigavel, resumo de
  conflitos, promocao para Caixa de Revisao e deteccao de reimportacao
  duplicada.
- A Fase 3 ampliou a importação: `StatementIdentity` preserva identidade,
  moeda, período e saldos do OFX; o lote persiste o destino confirmado e não
  promove nem concilia enquanto houver ambiguidade. Conta/cartão pode ser
  criado no fluxo, e o histórico mostra metadados e instrumento de cada lote.
- A Fase 4A introduziu a migração Drift 14 com faturas, pagamentos e auditoria
  de associação. Compras usam `postedAt` com fallback para `occurredAt`, corte
  e vencimento funcionam em meses curtos e virada anual, estornos reduzem o
  total e pagamentos permanecem transferências fora das despesas. Correções
  manuais ficam protegidas do recálculo e registram motivo/origem.
- A Fase 4B expôs esse domínio em **Ajustes > Faturas de cartões**: seleção
  inequívoca do cartão, fatura atual/próxima, total, datas, estado, compras,
  estornos, pagamentos e filtros por categoria/pessoa/competência. A tela
  diferencia explicitamente mês-calendário e mês da fatura e foi validada em
  360×800 e 390×844 com texto 1,3 e dados longos.
- A Fase 4C acrescentou sugestões explicáveis de pagamento com confirmação
  obrigatória, conciliação de OFX bancário/cartão e parcelas futuras apenas
  projetadas. Confirmar vincula a transferência à fatura sem duplicar despesa;
  cancelar não altera dados, e a transação real substitui a projeção.
- Mobile tem conciliacao financeira do Marco 07: candidatos de duplicidade,
  merge de fontes sem criar nova despesa, fatura como transferencia, parcelas
  de cartao em `installment_plans` e consorcio ligado ao plano do carro.
- Mobile tem captura Android do Marco 08: `NotificationListenerService`,
  allowlist de apps, SQLite nativo para eventos brutos, WorkManager, ponte
  MethodChannel, tabela Drift `raw_notification_events`, parser local inicial e
  painel em Ajustes para permissao/status.
- Marco A ampliou essa captura: a fila nativa confirma entrega somente depois
  de persistir no Drift, pagina backlog, drena ao abrir/retomar o app e mostra
  diagnosticos/retencao reais em Ajustes. Falta homologacao com notificacoes
  reais em aparelho Android, cujo roteiro esta em
  `docs/context/ANDROID_CAPTURE_HOMOLOGATION.md`.
- Mobile tem painel e movimentacoes do Marco 09: Resumo operacional do mes,
  quebras por pessoa/categoria/centro/origem, compromissos futuros, projecao
  simples, ultimas movimentacoes e tela Movimentacoes com busca/filtros. A
  importacao CSV/OFX agora fica como acao dentro de Movimentacoes.
- Mobile tem backup e recuperacao do Marco 10: exportacao JSON versionada,
  validacao antes de restaurar, restauracao transacional, exportacao CSV de
  movimentacoes, salvamento por seletor nativo e compartilhamento Android via
  `share_plus`.
- A Fase 2 adicionou identidade compartilhada para contas/cartões, ícones e
  cores persistidos para categorias/centros, criação contextual dentro de
  Novo/Editar e reset integral coordenado. O reset também limpa regras,
  staging, stores de sync, fila SQLite nativa, preferências da captura e sessão
  segura; permissões concedidas pelo Android permanecem no sistema.
- Marco 11A iniciado/concluido para sync tecnico: API tem store MongoDB/memoria,
  `.env.example`, colecoes/indices planejados no Atlas, push idempotente,
  pull incremental, conflito por `baseVersion` e painel mobile de sync via
  `--dart-define`.
- Marco 11B concluido tecnicamente: API tem `/auth/google`, validacao de ID
  token Google por OpenID Connect, allowlist por `ALLOWED_EMAILS`, sessao JWT
  local, protecao de `/sync/push` e `/sync/pull` quando
  `GOOGLE_OIDC_ENABLED=true`, e o mobile tem login Google opcional com
  `GOOGLE_WEB_CLIENT_ID`, armazenamento do token de sessao em secure storage e
  envio de bearer token no sync.
- Marco 11C foi implementado tecnicamente: o pull agora aplica snapshots de
  transacao versionados no Drift, reconhece eventos proprios por `opId` e
  preserva conflitos concorrentes em `sync_conflicts` para a Caixa de Revisao.
  Falta homologacao em dois aparelhos Android, documentada em
  `docs/context/SYNC_TWO_DEVICE_HOMOLOGATION.md`.
- Marco C foi implementado tecnicamente com
  `pixel-perfect-pixels@ac6bf30` como referencia visual: Compromissos agora
  oferece projecao, estados vazios e formularios responsivos ligados ao Drift;
  Ajustes mostra o estado real de captura, sync, backup e privacidade. O teste
  de widget cobre 360×800 e 390×844 com textos/valores longos. Falta somente
  a comparacao em aparelho Android fisico para aceitacao visual de release.
- Marco D foi implementado tecnicamente: Familia, Cadastros, Backup e Regras
  foram reorganizados sem mudar o CRUD ou a restauracao transacional. Backup
  diferencia aviso, cancelamento, arquivo invalido, sucesso e falha; regras
  expõem prioridade, estado, uso e destino local. O teste responsivo cobre
  360×800 e 390×844. Falta a comparacao em aparelho Android fisico.
- Marco E foi implementado tecnicamente: feedbacks recuperaveis foram
  padronizados, a regressao automatizada agora inclui Resumo, Movimentacoes,
  Duplicidades e Importacao, e um overflow de valores grandes no Resumo foi
  corrigido. O roteiro fisico pendente esta em
  `docs/context/MARCO_E_HOMOLOGATION.md`. A tentativa inicial de release
  travou no `gen_snapshot`, mas uma repetição posterior gerou a APK release
  descrita na atualização canônica acima.
- Uma instalacao limpa nao carrega seed automaticamente. Dados de demonstracao
  sao uma escolha explicita no onboarding ou em Ajustes.
- Para teste visual no Chrome, o banco usa Drift Web com `sql.js`; Android e
  desktop nativo continuam usando SQLite nativo.
- API tem `/health`, `/sync/push`, `/sync/pull`, store MongoDB opcional e stubs
  dos demais endpoints do plano.
- A referencia Lovable e consultada somente no repositorio externo. O visual
  e traduzido para widgets Flutter ligados ao Drift; os mocks e as acoes
  React nao fazem parte do produto final.
- APK debug da recuperacao: `apps/mobile/build/app/outputs/flutter-apk/app-debug.apk`.

## Comandos Uteis

Raiz:

```sh
npm install
npm run check
```

Mobile:

```sh
cd apps/mobile
flutter pub get
flutter run
flutter test
flutter analyze
flutter build apk --debug
```

APK debug gerado em:

```sh
apps/mobile/build/app/outputs/flutter-apk/app-debug.apk
```

Preview web no macOS sem Xcode:

```sh
cd apps/mobile
flutter build web
python3 -m http.server 54321 --directory build/web
open http://localhost:54321
```

API:

```sh
cd apps/api
npm install
npm run dev
npm test
npm run build
```

Referencia Lovable externa:

```sh
cd C:\dev\pixel-perfect-pixels
git fetch origin
npm run build
npm run lint
npm run dev
```

Observacao: `npm run build` passou no novo download. `npm run lint` falhou com
erros de Prettier, alguns `no-explicit-any` e um bug de rota para
`/transaction/undefined` em parcelas. A tentativa com pouco credito ainda
manteve "Tudo ok" e a navegacao antiga.

## Proximas Leituras

Antes de continuar qualquer marco, leia:

1. `docs/context/PROJECT_BRIEF.md`
2. `docs/context/MILESTONES.md`
3. `docs/context/ARCHITECTURE.md`
4. `docs/context/LOVABLE_SCREEN_FACTORY.md`
5. este arquivo

## Problemas Abertos

- A Fase 5H foi iniciada em 2026-09-13. `flutter analyze` passou e as APKs
  debug e release foram compiladas. A candidata release
  `apps/mobile/build/app/outputs/flutter-apk/app-release.apk` tem SHA-256
  `B5611BAB0BECD0868595181281B8F1D03C9B8C926A34C8C9B8014AEA63CFECBA`;
  `apksigner` validou uma assinatura APK v2 com a chave pessoal RSA 4096.
  Essa evidência de build não constitui aceite sem a regressão verde e a
  homologacao fisica.
- A checagem local da Fase 5H em 2026-09-13 encontrou `flutter analyze` sem
  problemas, mas `flutter test` com falhas de agregacao/sync e divergencias de
  golden no worktree atual. Uma nova execucao direcionada tambem foi bloqueada
  por colisao do asset nativo `sqlite3.dll` no diretorio `build`. Corrigir e
  reexecutar a regressao antes de aceitar uma APK desta revisao.
- O Android SDK possui `platform-tools/adb.exe`, mas nenhum aparelho estava
  enumerado em 2026-09-13; a homologacao fisica continua bloqueada ate conectar
  e autorizar um dispositivo.
- Confirmar fixtures reais anonimizadas de Nubank e Mercado Pago.
- Homologar o APK em Android fisico: instalacao limpa, uso offline, reinicio,
  teclado real e permissao de notificacoes concedida/revogada.
- Validar captura com notificacoes reais dos apps permitidos e confirmar
  comportamento com uma lista extensa de eventos.
- Revisar restauracao de backup em um segundo aparelho antes de tratar esta
  build como versao pessoal definitiva.
- Substituir armazenamento local simples por criptografia SQLCipher quando
  viavel no Marco 12.

## Próximo ciclo

Executar os marcos formalizados em
`docs/product/IMPLEMENTATION_ROADMAP.md`, nesta ordem: Fase 5H (homologação
Android física e release pessoal), Marco 11D (sync em dois dispositivos e
recuperação) e Marco 12 (hardening de segurança e preparação de publicação).
Não iniciar um marco posterior sem o aceite documentado do anterior.

Fase 5H começa preservando os dados existentes e homologando a candidata final
assinada no Samsung:

1. Exportar e conferir um backup local antes de remover o APK anterior.
2. Desinstalar o APK de debug e instalar a candidata assinada com banco limpo.
3. Concluir o onboarding com dados anonimizados, reiniciar e criar lancamentos.
4. Exercitar revisao, importacao, captura, cadastros e backup sem internet.
5. Revogar a permissao de notificacoes e verificar a orientacao do app.
6. Restaurar o backup depois de limpar os dados locais.
7. Registrar qualquer falha com modelo Android, versao do sistema e passos.
