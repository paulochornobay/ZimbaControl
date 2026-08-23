# ZimbaControl - Current State

> Fonte operacional canônica desde 2026-08-23:
> `docs/product/PRODUCT_REQUIREMENTS.md`,
> `docs/product/VISUAL_PARITY_AUDIT.md` e
> `docs/product/IMPLEMENTATION_ROADMAP.md`. O inventário abaixo preserva o
> histórico técnico; em caso de divergência, prevalecem os documentos de
> `docs/product`.

## Atualização canônica de 2026-08-23

- Item 0 do plano de continuidade concluído: requisitos, auditoria das 12
  telas do protótipo e roadmap por fases foram consolidados em `docs/product`.
- Fase 1 concluída tecnicamente: Movimentações compacta com bottom sheet de
  filtros, navegação “Movim.”, detalhe em leitura, snackbar temporário e título
  amigável separado da descrição original. A Fase 2 é a próxima.
- Referência visual oficial local: `C:\dev\pixel-perfect-pixels@2848fc6`.
- Código do app auditado: `ZimbaControl@cd67fcb`.
- Lacunas críticas confirmadas: Movimentações, snackbar persistente,
  identificação de contas/cartões, destino do OFX, semântica da descrição,
  reset completo e domínio de faturas.
- A APK release `1.1.0+2` foi gerada com sucesso em
  `apps/mobile/build/app/outputs/flutter-apk/app-release.apk`, SHA-256
  `36C922AE12AA35C1BE22C4305C1DF8E08E2EB714D76ACCD58D3AB074750C2C57`.
  Ela é um artefato diagnóstico: usa certificado de debug e não é a candidata
  final de distribuição.
- ADB não enumerou aparelho durante a auditoria; homologação física continua
  pendente.

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

Executar a Fase 1 de `docs/product/IMPLEMENTATION_ROADMAP.md`: fundação visual,
Movimentações, correção do feedback de confirmação e separação entre título
amigável e descrição original. A homologação Android física continua
obrigatória antes de uma candidata final de release.

Sequencia recomendada:

1. Desinstalar o APK anterior e instalar a build recuperada com banco limpo.
2. Concluir o onboarding com dados reais, reiniciar e criar lancamentos.
3. Exercitar revisao, importacao, captura, cadastros e backup sem internet.
4. Revogar a permissao de notificacoes e verificar a orientacao do app.
5. Restaurar o backup depois de limpar os dados locais.
6. Registrar qualquer falha com modelo Android, versao do sistema e passos.
7. So depois retomar Sync, Google ou Regras como jornadas publicas.
