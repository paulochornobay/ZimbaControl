# ZimbaControl

App familiar de finanças pessoais com arquitetura offline-first.

## Leitura obrigatória para próximos ciclos

Antes de implementar novos marcos, leia estes arquivos:

- `docs/context/PROJECT_BRIEF.md`
- `docs/context/MILESTONES.md`
- `docs/context/CURRENT_STATE.md`
- `docs/context/ARCHITECTURE.md`
- `docs/context/LOVABLE_SCREEN_FACTORY.md`

O projeto usa o zip do Lovable como protótipo visual e fonte de telas. O app final
sera Flutter + Drift/SQLite + Android Kotlin + backend Node.js/TypeScript +
MongoDB Atlas.

## Estrutura

- `apps/mobile`: app Flutter final.
- `apps/api`: backend Node.js/TypeScript/Fastify.
- `packages/contracts`: OpenAPI e JSON Schemas compartilhados.
- `prototypes/lovable`: prototipo visual exportado do Lovable.
- `docs/context`: memoria compacta do projeto.

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
