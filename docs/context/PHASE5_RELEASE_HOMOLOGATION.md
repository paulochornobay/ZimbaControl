# Fase 5 — release e homologação Android

**Data:** 2026-08-23

## Candidata técnica

- versão: `1.2.0+3`;
- APK: `apps/mobile/build/app/outputs/flutter-apk/app-release.apk`;
- SHA-256: `0D29C9D3D1D0F9177C57DFBE2BFD49E22809A7DE54084603C77396E42E7FC2E5`;
- assinatura: APK Signature Scheme v2, RSA 4096;
- certificado: `CN=ZimbaControl Personal Release, OU=Personal, O=ZimbaControl, C=BR`;
- fingerprint SHA-256 do certificado:
  `F0:E8:7C:C2:85:5A:48:93:D3:77:EC:94:05:FD:01:42:B2:AD:14:50:ED:BA:0C:E9:D7:43:4A:64:96:2E:BF:77`.

A chave e as senhas não pertencem ao Git. Para configurar/reusar a chave
pessoal, execute `tool/configure_personal_signing.ps1`; para gerar e verificar
a APK, execute `tool/build_personal_release.ps1`, ambos a partir de
`apps/mobile`.

## Evidência automatizada

- `flutter analyze`: sem avisos;
- `flutter test`: 99 aprovados;
- `npm run check`: contrato OpenAPI, TypeScript e 7 testes da API aprovados;
- `app:lintRelease`: aprovado com zero erros;
- `app:assembleAndroidTest`: APK de testes instrumentados compilado;
- regressão Fase 5: 13 jornadas, 360×800 e 390×844, texto 1,3;
- goldens: Resumo, Ajustes e Família nos dois viewports;
- `apksigner verify --verbose --print-certs`: aprovado.

## Pendência física e proteção dos dados

O Samsung `SM-S908E` não estava enumerado pelo ADB no fechamento. O APK
instalado anteriormente usa certificado de debug, enquanto esta candidata usa
a chave pessoal. O Android não permite atualizar um pacote com assinatura
diferente.

Não desinstalar o APK atual antes de:

1. exportar o backup pelo app;
2. conferir que o arquivo foi salvo fora do armazenamento privado do pacote;
3. aceitar explicitamente que a desinstalação apagará os dados locais do APK
   antigo.

Depois do backup e da autorização, a homologação deve executar:

```powershell
$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
& $adb uninstall br.com.zimbacontrol.zimba_control
& $adb install "C:\dev\ZimbaControl\apps\mobile\build\app\outputs\flutter-apk\app-release.apk"
```

Checklist: instalação limpa, execução de `connectedAndroidTest`, onboarding,
rotação/teclado/safe area, offline,
retorno do processo, captura com permissão concedida e revogada, OFX Nubank
anonimizado, backup/restauração, reset `ZERAR` e testes instrumentados Android.
