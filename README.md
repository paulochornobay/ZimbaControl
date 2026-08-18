# ZimbaControl

App familiar de finanças pessoais com arquitetura offline-first.

## Leitura obrigatória para próximos ciclos

Antes de implementar novos marcos, leia estes arquivos:

- `docs/context/PROJECT_BRIEF.md`
- `docs/context/MILESTONES.md`
- `docs/context/CURRENT_STATE.md`
- `docs/context/ARCHITECTURE.md`
- `docs/context/LOVABLE_SCREEN_FACTORY.md`

O projeto Flutter usa como referencia visual externa o projeto Lovable em
`/Users/macbookair/Public/dev/pixel-perfect-pixels`
(`paulochornobay/pixel-perfect-pixels`). Nenhum codigo React/Lovable e mantido
neste monorepo.

## Estrutura

- `apps/mobile`: app Flutter final.
- `apps/api`: backend Node.js/TypeScript/Fastify.
- `packages/contracts`: OpenAPI e JSON Schemas compartilhados.
- `docs/context`: memoria compacta do projeto.

## Referencia visual

Antes de portar ou revisar uma tela, atualize apenas o repositorio externo e
registre o commit usado no ciclo:

```sh
cd /Users/macbookair/Public/dev/pixel-perfect-pixels
git fetch origin
git log -1 --oneline origin/main
```

Nao copie o front React para dentro deste repositorio e nao misture o historico
Git dos dois projetos.

Baseline visual da recuperacao mobile atual: `6a2d072`.

## Comandos

```sh
npm install
npm run check
```

```sh
cd apps/mobile
flutter pub get
flutter analyze
flutter test
flutter run
```

API sem MongoDB, usando memoria local:

```sh
cd apps/api
npm run dev
```

API com MongoDB Atlas:

```sh
cd apps/api
cp .env.example .env
# preencher MONGODB_URI, MONGODB_DB e segredos locais
npm run dev
```

Mobile apontando para a API local:

```sh
cd apps/mobile
flutter run \
  --dart-define=API_BASE_URL=http://SEU_IP_LOCAL:3333 \
  --dart-define=SYNC_ENABLED=true
```

Mobile com Google Sign-In opcional:

```sh
cd apps/mobile
flutter run \
  --dart-define=API_BASE_URL=http://SEU_IP_LOCAL:3333 \
  --dart-define=SYNC_ENABLED=true \
  --dart-define=GOOGLE_WEB_CLIENT_ID=SEU_CLIENT_ID_WEB.apps.googleusercontent.com
```

Para exigir Google na API, preencha no `apps/api/.env`:

```env
GOOGLE_OIDC_ENABLED=true
GOOGLE_OIDC_AUDIENCE=SEU_CLIENT_ID_WEB.apps.googleusercontent.com
ALLOWED_EMAILS=seuemail@gmail.com
SESSION_JWT_SECRET=uma-string-grande-local
```
