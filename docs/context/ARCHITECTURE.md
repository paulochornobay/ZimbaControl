# ZimbaControl - Architecture

## Visao

Arquitetura offline-first com fonte da verdade local. O app grava primeiro em
SQLite/Drift, coloca operacoes na outbox e sincroniza depois com um backend
proprio. A nuvem nao e requisito para operacao diaria basica.

Ordem de entrega: Android local confiavel primeiro; MongoDB, login e dois
dispositivos ficam para depois de importacao, notificacoes, conciliacao e
backup local.

## Stack

- UI mobile: Flutter.
- Persistencia local: Drift + SQLite.
- Teste web local: Drift Web com `sql.js`, apenas para preview no Chrome sem
  Xcode/emulador.
- Android nativo: Kotlin `NotificationListenerService`.
- Background Android: WorkManager.
- Backend: Node.js + TypeScript + Fastify.
- Cloud DB: MongoDB Atlas Free/M0 somente no marco de sync.
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

## Principios do Modelo Familiar

- `amountCents` permanece assinado: negativo para saida e positivo para
  entrada.
- Conta e cartao devem ter proprietario.
- Usuario autenticado e membro familiar sao entidades distintas.
- Transferencia interna entre contas cadastradas nao entra como receita nem
  despesa do agregado familiar.
- Receitas destinadas a uma pessoa, como pensao da filha, devem preservar o
  beneficiario/destino economico.
- Escola, ajuda familiar e outras obrigacoes fixas usam recorrencia mensal.
- Consorcio usa plano proprio de compromisso; compra parcelada no cartao usa
  plano de parcelas de compra.
- Uma transacao pode ter multiplas fontes: notificacao, CSV, OFX e manual.

Estado implementado no Marco 05:

- `accounts.ownerPersonId` e `creditCards.ownerPersonId`.
- `auth_users` com email allowlist local e vinculo opcional com pessoa.
- `recurring_schedules` para escola, pensao, ajuda familiar e fixos mensais.
- `installment_plans` para consorcio e futuros parcelamentos.
- `transactions.transferFromAccountId`, `transferToAccountId`,
  `recurringScheduleId` e `installmentPlanId`.
- Seed familiar com escola da Sofia, pensao destinada a Sofia, ajuda familiar
  para Marina e consorcio do carro.

## Estado do Nucleo Local

O MVP local atual cobre:

- seed de familia, contas, cartao, categorias, centros de custo e merchants;
- transacoes com beneficiarios, fonte de confianca e status de revisao;
- `review_inbox` aberta/resolvida;
- outbox para operacoes locais;
- dashboard inicial;
- caixa de revisao real com dados hidratados, filtros persistidos, acoes reais
  e desfazer;
- estrutura familiar local com proprietarios de contas/cartoes, usuario de
  acesso separado, recorrencias e consorcio;
- edicao basica de descricao, valor, tipo, categoria e centro de custo.

As telas ainda evoluirao por marco. Lovable continua sendo a fonte para
acabamento visual, mas a Caixa de Revisao ja possui fluxo Flutter funcional.

## Preview Web

O preview web existe para facilitar teste no macOS quando Xcode ou emulador
Android nao estao prontos. Ele nao substitui o alvo Android-first. No Chrome,
o banco usa `sql.js` carregado por CDN; em Android/desktop nativo, o app usa
SQLite nativo.

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
- `transferFromAccountId`
- `transferToAccountId`
- `recurringScheduleId`
- `installmentPlanId`
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

Entidades planejadas:

- `RecurringSchedule`
- `InstallmentPlan`
- `ImportBatch`
- `StagedSourceRecord`
- `DuplicateCandidate`
- `RawNotificationEvent`

Sugestoes:

- toda sugestao deve carregar `confidence`, `explanation` e regra responsavel;
- baixa confianca nunca deve consolidar lancamento silenciosamente;
- conflitos financeiros voltam para a caixa de revisao.

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

Transferencias entre marido e esposa tambem devem ser tratadas como movimento
interno quando as duas contas estiverem cadastradas. Se apenas uma ponta for
conhecida, o app deve sugerir classificacao e pedir revisao.

No nucleo local atual, `kind = transfer` fica fora dos calculos de receita e
despesa do dashboard. A transferencia preserva conta de origem, conta de
destino, pagador e beneficiario.

## Importacao Local

- CSV e OFX sao o primeiro alvo; XLSX fica fora do MVP inicial.
- Arquivos importados nao devem ser enviados ao servidor.
- Cada lote gera `ImportBatch` com hash do arquivo.
- Cada linha/registro gera `StagedSourceRecord` com hash proprio.
- Reimportar o mesmo arquivo deve ser idempotente.
- Adaptadores iniciais: Nubank e Mercado Pago.
- CSV desconhecido deve abrir mapeamento manual de colunas.

## Captura Android

- `NotificationListenerService` captura apenas apps explicitamente autorizados.
- O evento bruto deve ser persistido rapidamente no SQLite.
- Parsing por instituicao roda fora da thread principal.
- WorkManager faz reprocessamento e recuperacao.
- Eventos brutos podem ser expurgados apos consolidacao, conforme politica
  configuravel.

## Sync Futuro

Sync so deve comecar depois do app Android local ficar confiavel e recuperavel
por backup.

- Backend Fastify + MongoDB Atlas Free/M0.
- Google Sign-In futuro via OpenID Connect, com allowlist inicial de um email.
- Gmail API nao e mecanismo de login.
- Outbox idempotente por `opId`.
- `baseVersion` protege updates concorrentes.
- Conflitos em valor, beneficiarios, conta, cartao, categoria critica e
  transferencia voltam para revisao.

## Privacidade

- Allowlist explicita de apps monitorados.
- Parsing on-device.
- Nao enviar payload bruto de notificacoes ao servidor por padrao.
- Expurgo configuravel de eventos crus apos consolidacao.
- Tokens e chaves em secure storage.
