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
- Mobile tem Drift/SQLite inicial com seeds, dashboard, confirmacao simples e
  outbox local.
- API tem `/health`, `/sync/push`, `/sync/pull` e stubs dos endpoints do plano.

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

## Proximas Leituras

Antes de continuar qualquer marco, leia:

1. `docs/context/PROJECT_BRIEF.md`
2. `docs/context/MILESTONES.md`
3. `docs/context/ARCHITECTURE.md`
4. `docs/context/LOVABLE_SCREEN_FACTORY.md`
5. este arquivo

## Problemas Abertos

- Confirmar fixtures reais anonimizadas de Nubank e Mercado Pago.
- Escolher provedor de auth gratuito para a fase cloud ou iniciar com JWT
  local simples para uso pessoal.
- Verificar limites atuais do provedor gratuito de deploy quando chegar no
  Marco 08.
- Implementar telas Flutter completas equivalentes ao Lovable.
- Substituir armazenamento local simples por criptografia SQLCipher no Marco 09.
