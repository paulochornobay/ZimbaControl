# Marco E — roteiro de regressao visual e homologacao Android

Data de preparacao: 2026-08-23
Baseline visual: `pixel-perfect-pixels@ac6bf30`

## Resultado automatizado

- `flutter analyze`: aprovado.
- `flutter test`: aprovado, com regressao em 360×800 e 390×844 para
  onboarding, novo lancamento, revisao, detalhe/edicao, resumo,
  movimentacoes, importacao, duplicidades, compromissos, ajustes, familia,
  cadastros, regras e backup.
- Valores e textos longos fazem parte das fixtures. Um overflow encontrado no
  resumo foi corrigido em `BreakdownRow` antes deste registro.
- APK debug: gerada em `apps/mobile/build/app/outputs/flutter-apk/app-debug.apk`.
- APK release: a tentativa em 2026-08-23 ficou travada no `gen_snapshot` AOT
  sem produzir artefato novo e foi encerrada após alguns minutos. A APK release
  existente nao deve ser tratada como validacao deste marco; repetir a build
  em ambiente Android/Flutter saudavel e obrigatorio antes da release pessoal.

## Homologacao fisica pendente

Esta lista deve ser executada em aparelho Android real antes de considerar a
build aceita para release pessoal. Nenhum item abaixo foi marcado como feito
somente por testes de widget.

- [ ] Instalar a APK debug com dados limpos, concluir onboarding real e voltar
  ao app depois de reiniciar o aparelho.
- [ ] Validar em 360×800 e 390×844 (ou equivalentes) Resumo, Movimentacoes,
  Revisao, Novo e Detalhe com teclado aberto, nomes longos e valores grandes.
- [ ] Importar CSV/OFX local offline, confirmar uma revisao e verificar que
  duplicidades continuam explicaveis.
- [ ] Conceder/revogar permissao de notificacoes e seguir o roteiro de
  `ANDROID_CAPTURE_HOMOLOGATION.md` para Nubank e Mercado Pago.
- [ ] Exportar backup, tentar arquivo JSON invalido, cancelar a restauracao e
  restaurar um backup valido depois de confirmar a substituicao dos dados.
- [ ] Conferir safe areas, botoes inferiores, snackbars, dialogs e retorno de
  todas as jornadas de Ajustes.
- [ ] Com API configurada e duas instalacoes, seguir
  `SYNC_TWO_DEVICE_HOMOLOGATION.md`.

## Diferencas visuais deliberadas

- O Flutter usa os componentes locais `Zimba*`; nenhum componente React ou
  Tailwind da referencia foi copiado.
- Estados de sync, captura, backup e regras mostram apenas dados e acoes que
  o dominio local executa. A homologacao fisica acima continua obrigatoria.
