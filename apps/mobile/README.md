# ZimbaControl Mobile

Cliente Flutter online do ZimbaControl. MongoDB, acessado exclusivamente pela
API autenticada, e a fonte de dados de cadastros, movimentos, importações,
revisões, relatórios e backups. O aplicativo não possui banco financeiro local
nem modo demonstrativo.

Sem `API_BASE_URL` ou sem conectividade, o app informa indisponibilidade e não
aceita operações financeiras. A exceção limitada é a fila Android criptografada
de notificações: ela é vinculada à conta autenticada, limitada, enviada à API
em lote e apagada ao sair da conta.

## Desenvolvimento

```powershell
flutter pub get
flutter analyze
flutter test
flutter run --dart-define=API_BASE_URL=http://SEU_IP_LOCAL:3333
```

Para Google Sign-In, acrescente
`--dart-define=GOOGLE_WEB_CLIENT_ID=SEU_CLIENT_ID_WEB.apps.googleusercontent.com`.

## Android release

```powershell
flutter build apk --release --dart-define=API_BASE_URL=https://api.exemplo.com
```

Não use instalação que preserve dados de versões offline anteriores: o reset de
desenvolvimento deve remover essas bases antes da homologação do corte online.
