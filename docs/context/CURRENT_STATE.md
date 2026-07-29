# ZimbaControl - Current State

## Estado Atual

- Repositorio estruturado como monorepo.
- Plano aprovado: Lovable como prototipo; Flutter como app final.
- Toolchains detectadas localmente: Flutter, Dart, Node.js, npm e unzip.
- PDF/DOCX de arquitetura analisado e resumido nos arquivos de contexto.
- Prototipo Lovable extraido em `prototypes/lovable`.
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
  Pago, resumo de lote, promocao para Caixa de Revisao e deteccao de
  reimportacao duplicada.
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
- O app ainda chama `seedIfEmpty()` ao iniciar. Em uma instalacao limpa, isso
  cria dados de exemplo/desenvolvimento para testar dashboard, revisao,
  familia, consorcio e importacao. Para uso real, limpar dados do app no
  Android remove esses lancamentos; depois devemos transformar a seed em uma
  acao explicita de demo.
- Para teste visual no Chrome, o banco usa Drift Web com `sql.js`; Android e
  desktop nativo continuam usando SQLite nativo.
- API tem `/health`, `/sync/push`, `/sync/pull` e stubs dos endpoints do plano.
- Novo projeto Lovable analisado em
  `/Users/macbookair/Public/dev/pixel-perfect-pixels`. Ele e boa referencia
  visual para revisao, edicao, duplicidades e parcelas, mas segue com dados
  mockados e acoes nao persistentes.
- A tentativa final de refinamento da Caixa de Revisao no Lovable compilou,
  mas nao concluiu os pontos centrais do prompt. O Marco 04 foi implementado
  diretamente no Flutter.
- Plano reorganizado: Marcos 04 a 12 priorizam Android local util antes de
  MongoDB, login, sync e publicacao.

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

Lovable:

```sh
cd prototypes/lovable
npm install
npm run dev
```

Novo download Lovable analisado:

```sh
cd /Users/macbookair/Public/dev/pixel-perfect-pixels
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
- Nao configurar MongoDB nem `.env` agora; isso fica para o Marco 11.
- Auth futuro deve ser Google Sign-In via OpenID Connect com allowlist inicial
  de um email, nao Gmail API.
- Verificar limites atuais do provedor gratuito de deploy quando chegar no
  Marco 11.
- Implementar telas Flutter completas equivalentes ao Lovable conforme cada
  marco avancar.
- Validar Marco 08 em Android fisico com permissao real de notificacoes e apps
  Nubank/Mercado Pago instalados.
- Transformar a seed automatica em opcao explicita antes de uso real continuo.
- Substituir armazenamento local simples por criptografia SQLCipher quando
  viavel no Marco 12.

## Proximo Marco

Marco 10 - Backup e Recuperacao.

Sequencia recomendada:

1. Definir formato versionado de backup local.
2. Exportar transacoes, fontes, beneficiarios, recorrencias, parcelas,
   cadastros, importacoes e preferencias.
3. Criar validacao de restauracao antes de substituir dados.
4. Implementar restauracao local com confirmacao de risco.
5. Exportar CSV simples para consulta externa.
6. Compartilhar arquivo pelo recurso nativo do Android.
7. Testar reinstalacao/limpeza de dados e recuperacao sem MongoDB.
8. Atualizar estes arquivos de contexto ao concluir o marco.
