# ZimbaControl - Architecture

## Visao

Arquitetura offline-first com fonte da verdade local. O app grava primeiro em
SQLite/Drift, coloca operacoes na outbox e sincroniza depois com um backend
proprio. A nuvem nao e requisito para operacao diaria basica.

## Stack

- UI mobile: Flutter.
- Persistencia local: Drift + SQLite.
- Android nativo: Kotlin `NotificationListenerService`.
- Background Android: WorkManager.
- Backend: Node.js + TypeScript + Fastify.
- Cloud DB: MongoDB Atlas Free/M0 no MVP pessoal.
- Contratos: OpenAPI e JSON schemas em `packages/contracts`.
- Sync quase tempo real futuro: Change Streams + WebSocket/SSE.

## Fluxo Local

1. Evento entra por notificacao, CSV, OFX ou cadastro manual.
2. Evento vira `CanonicalSourceRecord`.
3. App cria ou atualiza rascunho local.
4. Motor de regras sugere classificacao, beneficiarios, centro de custo,
   parcelamento e duplicidade.
5. Item entra na caixa de revisao.
6. Usuario confirma, edita, ignora, converte em transferencia ou marca
   duplicado.
7. Confirmacao gera operacao em `sync_outbox`.

## Modelo Canonico

Transacao:

- `id`
- `householdId`
- `kind`
- `amountCents`
- `currencyCode`
- `occurredAt`
- `postedAt`
- `competenceMonth`
- `descriptionRaw`
- `merchantId`
- `categoryId`
- `costCenterId`
- `payerId`
- `beneficiaryIds`
- `sourceRecords`
- `reviewStatus`
- `duplicateStatus`
- `baseVersion`
- `serverVersion`
- `updatedAt`
- `deletedAt`

Source record:

- `id`
- `sourceKind`
- `provider`
- `externalId`
- `fileHash`
- `rowHash`
- `notificationKey`
- `rawPayload`
- `confidence`

Sync operation:

- `opId`
- `deviceId`
- `householdId`
- `entityType`
- `entityId`
- `operationType`
- `baseVersion`
- `payload`
- `createdAt`
- `status`
- `retryCount`

## Regras de Concorrencia

- Toda operacao de sync deve ser idempotente por `opId`.
- Updates remotos usam `baseVersion` para concorrencia otimista.
- Campos monetarios e relacoes financeiras nao usam last-writer-wins puro.
- Conflitos importantes voltam para a caixa de revisao.

## Deduplicacao

Niveis:

- Tecnica: evita reenvio duplicado de sync.
- Financeira: evita que notificacao, CSV e OFX criem despesas duplicadas.

Sinais:

- `externalId`
- `fileHash + rowHash`
- valor, moeda, merchant normalizado, conta/cartao, janela de data e marcador
  de parcela.

## Faturas e Transferencias

Pagamento de fatura de cartao nao e despesa nova. Deve virar transferencia
entre instrumento pagador e passivo/cartao. Baixa confianca gera acao rapida
na caixa de revisao.

## Privacidade

- Allowlist explicita de apps monitorados.
- Parsing on-device.
- Nao enviar payload bruto de notificacoes ao servidor por padrao.
- Expurgo configuravel de eventos crus apos consolidacao.
- Tokens e chaves em secure storage.
