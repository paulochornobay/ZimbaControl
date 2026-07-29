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
- Marco 05 precisa ampliar o modelo para proprietario de contas/cartoes,
  transferencias internas, recorrencias, pensao e consorcio.
- Substituir armazenamento local simples por criptografia SQLCipher quando
  viavel no Marco 12.

## Proximo Marco

Marco 05 - Estrutura Financeira Familiar.

Sequencia recomendada:

1. Atualizar o schema local com proprietario em contas/cartoes e entidades de
   recorrencia/compromisso familiar.
2. Criar seeds para escola, pensao da filha, ajuda familiar e consorcio.
3. Ajustar a edicao/criacao para registrar transferencia interna sem inflar
   receitas/despesas.
4. Testar recorrencias e classificacao dos cenarios familiares.
5. Opcionalmente pedir ao Lovable as telas de cadastros familiares antes do
   acabamento visual final.
6. Atualizar estes arquivos de contexto ao concluir o marco.
