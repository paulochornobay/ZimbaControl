# Homologação manual — Marco A: captura Android

Status: pendente de aparelho Android físico. Não considerar o Marco A aceito
para release antes de registrar nesta lista o modelo, Android, versão do APK,
data e resultado de cada cenário.

## Pré-requisitos

- APK debug desta implementação instalado sobre banco limpo ou instalação já
  configurada com conta local.
- Serviço de acesso a notificações concedido ao ZimbaControl.
- Apenas Nubank e/ou Mercado Pago explicitamente habilitados em Ajustes.
- Sem dados demonstrativos criados para mascarar o resultado.

## Roteiro

- [ ] Nubank: receber notificação real, deixar o app encerrado, abri-lo e
  confirmar a criação ou conciliação na Caixa de Revisão.
- [ ] Mercado Pago: repetir o cenário, incluindo retorno após reinício do app.
- [ ] Reabrir sem nova notificação e confirmar que nem a transação nem a fonte
  foram duplicadas.
- [ ] Confirmar backlog acima de 50 eventos, sem perda dos mais antigos.
- [ ] Revogar permissão: Ajustes deve indicar estado ausente e permitir abrir
  as configurações novamente.
- [ ] Desabilitar todos os apps: allowlist vazia não pode criar lançamentos.
- [ ] Receber notificação sem valor: deve ficar como `ignored_no_amount`, com
  motivo legível e sem lançamento fictício.
- [ ] Fechar o app durante a entrega: o evento deve permanecer pendente e ser
  entregue ao abrir novamente.
- [ ] Confirmar expurgo: somente eventos entregues e fora da retenção podem
  desaparecer; pendentes devem permanecer.

## Registro de execução

| Data | Aparelho / Android | APK | Nubank | Mercado Pago | Observações |
| --- | --- | --- | --- | --- | --- |
| Pendente | — | — | — | — | — |
