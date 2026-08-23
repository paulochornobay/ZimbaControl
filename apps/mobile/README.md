# ZimbaControl Mobile

Aplicativo Flutter offline-first do ZimbaControl. O banco principal é SQLite
via Drift; importações, classificação, revisão e backup funcionam localmente.

## Desenvolvimento

```powershell
flutter pub get
flutter analyze
flutter test
flutter run
```

Para regenerar o código do Drift após alterar tabelas:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

## Android release

Gerar a APK:

```powershell
flutter build apk --release
```

Instalar ou atualizar no aparelho conectado, preservando os dados:

```powershell
adb install -r build\app\outputs\flutter-apk\app-release.apk
```

O artefato atual é adequado para desenvolvimento e homologação pessoal. A
assinatura própria e o release final de distribuição pertencem à Fase 5 do
roadmap.

## Dados locais

Em **Ajustes > Dados locais**, “Zerar aplicativo” mostra contagens, oferece um
backup e só habilita a exclusão após digitar `ZERAR`. O fluxo remove dados
financeiros, importações em staging, regras, estado de sync, fila nativa,
preferências internas e sessão, retornando ao onboarding. Permissões já
concedidas pelo Android precisam ser revogadas nas configurações do sistema.

O escopo e a ordem dos próximos trabalhos estão em
`../../docs/product/IMPLEMENTATION_ROADMAP.md`.
