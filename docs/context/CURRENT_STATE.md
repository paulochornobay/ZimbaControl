# ZimbaControl - Current State

## Estado Atual

- Repositorio estruturado como monorepo.
- Plano aprovado: Lovable como prototipo; Flutter como app final.
- Toolchains detectadas localmente: Flutter, Dart, Node.js, npm e unzip.
- PDF/DOCX de arquitetura analisado e resumido nos arquivos de contexto.
- O front Lovable duplicado foi removido do monorepo. A referencia visual vive
  exclusivamente em `/Users/macbookair/Public/dev/pixel-perfect-pixels`.
- O ciclo de recuperacao mobile usa `pixel-perfect-pixels@6a2d072` como
  baseline visual.
- A recuperacao do app local esta implementada: primeira abertura sem seed,
  onboarding transacional com pessoa e conta reais, demonstracao apenas por
  escolha explicita e lancamento manual sem IDs ficticios.
- O Flutter tem tema proprio inspirado no baseline externo, com Inter
  embutida, tokens compartilhados, cards, botoes, navegacao e formularios
  consistentes. Nenhum componente React/Tailwind foi copiado.
- A navegacao principal agora e Resumo, Revisao, Novo, Movimentacoes e
  Ajustes. Ajustes mostra apenas jornadas funcionais; Regras, Google e Sync
  ficam ocultos.
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
cd /Users/macbookair/Public/dev/pixel-perfect-pixels
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

## Proximo Marco

Homologacao Android local.

Sequencia recomendada:

1. Desinstalar o APK anterior e instalar a build recuperada com banco limpo.
2. Concluir o onboarding com dados reais, reiniciar e criar lancamentos.
3. Exercitar revisao, importacao, captura, cadastros e backup sem internet.
4. Revogar a permissao de notificacoes e verificar a orientacao do app.
5. Restaurar o backup depois de limpar os dados locais.
6. Registrar qualquer falha com modelo Android, versao do sistema e passos.
7. So depois retomar Sync, Google ou Regras como jornadas publicas.
