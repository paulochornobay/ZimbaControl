# Homologação manual — Marco 11C: sync em dois aparelhos

Status: pendente de duas instalações Android e API configurada. Não considerar
o Marco 11C aceito para release sem registrar os resultados abaixo.

## Pré-requisitos

- Duas instalações do mesmo APK, cada uma com `deviceId` próprio e login/sync
  configurados quando o ambiente exigir autenticação.
- Mesma residência (`householdId`) e API persistente disponível.
- Backup local feito antes do teste; a sync nunca deve substituir o backup.

## Roteiro

- [ ] Criar um lançamento no aparelho A e sincronizar. No B, sincronizar e
  confirmar valor, descrição, conta, categoria, beneficiários e fonte.
- [ ] Repetir sync nos dois aparelhos e confirmar que não há segunda transação
  nem segunda fonte.
- [ ] Criar lançamento offline no A, reconectar, sincronizar e confirmar a
  chegada no B.
- [ ] Editar o mesmo lançamento nos dois aparelhos sem sincronizar entre as
  edições. Sincronizar A, depois B; confirmar conflito em Revisão com valores
  local e remoto legíveis.
- [ ] Confirmar no B qual estado manter, sincronizar novamente e confirmar que
  A recebe a decisão como nova versão, sem apagar o histórico do conflito.
- [ ] Reiniciar ambos os apps durante o ciclo e confirmar que cursor/operação
  já aplicada não causa duplicação.

## Registro de execução

| Data | Aparelho A | Aparelho B | API | Resultado | Observações |
| --- | --- | --- | --- | --- | --- |
| Pendente | — | — | — | — | — |
