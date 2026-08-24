# ZimbaControl - Architecture

## Visao

Arquitetura offline-first com fonte da verdade local. O app grava primeiro em
SQLite/Drift, coloca operacoes na outbox e sincroniza depois com um backend
proprio. A nuvem nao e requisito para operacao diaria basica.

Ordem de entrega: Android local confiavel primeiro; depois sync tecnico com
MongoDB, login opcional e dois dispositivos.

## Stack

- UI mobile: Flutter.
- Persistencia local: Drift + SQLite.
- Teste web local: Drift Web com `sql.js`, apenas para preview no Chrome sem
  Xcode/emulador.
- Android nativo: Kotlin `NotificationListenerService`.
- Background Android: WorkManager.
- Backend: Node.js + TypeScript + Fastify.
- Cloud DB: MongoDB Atlas Free/M0 no sync opcional.
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
- A conciliacao deve preservar todas as fontes em `transaction_sources`; quando
  uma linha de extrato confirma uma notificacao, ela mescla a origem em vez de
  criar uma segunda despesa.

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
- importacao CSV/OFX local com staging, hashes e promocao para revisao;
- conciliacao financeira local com candidatos de duplicidade, merge de fontes,
  fatura como transferencia, parcelas de cartao e consorcio;
- captura Android local com listener nativo, allowlist, eventos brutos,
  parser inicial e rascunhos na Caixa de Revisao;
- resumo operacional e movimentacoes com filtros por mes, tipo, status, origem
  e busca textual;
- backup local versionado, validacao/restauracao e CSV para consulta externa;
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

Implementado localmente ate o Marco 08:

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

Estado implementado no Marco 07:

- `externalId` e `fileHash + rowHash` continuam bloqueando duplicatas exatas.
- Novos registros validos passam por heuristica de conciliacao por valor,
  data, conta e descricao normalizada.
- Confianca alta vira `merge_candidate` e, ao promover o lote, adiciona nova
  linha em `transaction_sources` na transacao existente.
- Confianca intermediaria segue para Caixa de Revisao com
  `duplicateStatus = probable` e explicacao em `duplicate_candidates`.
- `duplicate_candidates` guarda score, regra e explicacao para auditoria local.

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

No Marco 07, importacoes com texto de pagamento de fatura passam a entrar como
`kind = transfer` para revisao, evitando registrar a fatura como nova despesa.

Na Fase 4C, essa transferência pode aparecer na fatura como sugestão calculada
por descrição, provedor, instrumento, valor e proximidade do vencimento. A
sugestão é somente leitura: apenas o diálogo de confirmação define o cartão de
destino e cria `invoice_payments`. Fonte OFX confirmada usa origem
`ofx_reconciled`; uma transferência ativa não pode pagar duas faturas.

Compras parceladas usam identidade estável de plano por cartão, descrição, mês
inicial, quantidade e valor. As competências restantes são
`InvoiceInstallmentProjection` calculadas; podem materializar a linha de
fatura vazia para navegação, mas nunca uma `transaction`. Quando a transação
real da parcela chega, a competência deixa de ser projetada e o total continua
derivado exclusivamente de compras/estornos reais e pagamentos ativos.

## Importacao Local

- CSV e OFX sao suportados no app local; XLSX fica fora do MVP inicial.
- Arquivos importados nao sao enviados ao servidor.
- Cada lote gera `import_batches` com hash SHA-256 do arquivo.
- Cada linha/registro gera `staged_source_records` com hash SHA-256 proprio.
- Reimportar o mesmo arquivo marca linhas como duplicadas.
- Adaptadores iniciais: Nubank e Mercado Pago.
- CSV desconhecido tem API de mapeamento manual de colunas no parser.
- Registros validos sao promovidos como transacoes pendentes na Caixa de
  Revisao, preservando `fileHash`, `rowHash`, `externalId`, provider e payload
  bruto do registro.
- Registros conciliados com alta confianca sao mesclados como nova fonte da
  transacao existente, sem criar novo lancamento financeiro.
- Compras com marcador `02/10` ou `parcela 2/10` criam/associam plano
  `credit_card_purchase`.
- Registros de consorcio sao associados a `plan-consorcio-carro`.

## Captura Android

- `NotificationListenerService` captura apenas apps explicitamente autorizados.
- O evento bruto deve ser persistido rapidamente no SQLite.
- Parsing por instituicao roda fora da thread principal.
- WorkManager faz reprocessamento e recuperacao.
- Eventos brutos podem ser expurgados apos consolidacao, conforme politica
  configuravel.

Estado implementado no Marco 08:

- `ZimbaNotificationListenerService` captura `package`, horario, titulo, texto,
  `bigText`, id/tag e chave da notificacao.
- A allowlist fica em `SharedPreferences` nativo e comeca vazia por seguranca.
- O evento bruto e gravado imediatamente em SQLite nativo
  `zimba_notification_events.db`.
- `NotificationReprocessWorker` deixa o caminho de recuperacao preparado.
- `MethodChannel br.com.zimbacontrol/notifications` expoe status, permissao,
  allowlist, eventos recentes e expurgo.
- Flutter sincroniza eventos recentes para Drift em `raw_notification_events`.
- Parser local inicial identifica valores em BRL, Nubank/Mercado Pago por
  pacote, cria rascunho pendente ou mescla fonte com transacao existente.
- Preview web/macOS retorna estado indisponivel sem quebrar a tela.

## Painel e Movimentacoes

Estado implementado no Marco 09:

- `watchAllTransactions` e `watchAllTransactionDetails` expoem transacoes
  hidratadas para telas fora da Caixa de Revisao.
- `buildOperationalDashboardSummary` calcula o mes atual, receitas, despesas,
  saldo, pendencias, transferencias, compromissos futuros, projecao simples e
  quebras por pessoa, categoria, centro de custo e origem.
- A tela Resumo prioriza leitura operacional: quanto entrou, quanto saiu, para
  quem foi, de onde veio e o que ainda vencera.
- A tela Movimentacoes filtra localmente por mes atual, tipo, status, origem e
  busca em descricao, merchant, pessoa, categoria, centro de custo e provider.
- Importacao CSV/OFX foi mantida como acao dentro de Movimentacoes, sem virar
  item principal separado na navegacao.

## Backup Local

Estado implementado no Marco 10:

- O backup usa JSON versionado com `format`, `version`, `schemaVersion`,
  `householdId`, `exportedAt`, `counts` e `data`.
- Entram no backup: pessoas, contas, cartoes, categorias, centros de custo,
  merchants, transacoes, inbox de revisao, beneficiarios, fontes, outbox,
  preferencias, usuarios allowlist, recorrencias, planos de parcelas, lotes de
  importacao, registros staged, candidatos de duplicidade e notificacoes brutas
  ja sincronizadas para Drift.
- Validacao confere formato e versao antes de permitir restauracao.
- Restauracao apaga/substitui os dados locais dentro de uma transacao Drift.
- A tela Ajustes exige confirmacao explicita antes de restaurar.
- CSV de movimentacoes e exportado como consulta externa, nao como formato de
  restauracao.
- Salvamento usa `file_picker`; compartilhamento Android usa `share_plus`.

## Sync Opcional

Estado implementado no Marco 11A:

- API Fastify carrega `.env` via `dotenv/config`.
- `apps/api/.env.example` documenta variaveis locais sem segredos reais.
- Quando `MONGODB_URI` existe, a API usa MongoDB Atlas; sem URI, usa store em
  memoria para testes locais.
- Colecoes MongoDB planejadas/criadas pela API: `sync_operations`,
  `sync_events`, `entities`, `devices` e `conflicts`.
- Indices protegem idempotencia por `opId`, pull incremental por
  `householdId + seq`, entidades por `householdId + entityType + entityId` e
  dispositivos por `householdId + deviceId`.
- `POST /sync/push` aplica operacoes da outbox uma vez e retorna `applied`,
  `duplicate`, `conflict` ou `rejected`.
- `GET /sync/pull?householdId=<id>&sinceSeq=<seq>` retorna eventos
  incrementais em ordem.
- `baseVersion` protege updates concorrentes; conflito financeiro ainda fica
  registrado no backend e sera apresentado no mobile no 11C.
- Mobile tem `HttpSyncApiClient`, `runSyncOnce`, envio da `sync_outbox`, ack de
  `applied/duplicate`, marcacao de `conflict/rejected` e cursor local
  `sync_pull_since_seq`.
- A tela Ajustes mostra painel tecnico de sync quando o app roda com
  `--dart-define=SYNC_ENABLED=true` e `--dart-define=API_BASE_URL=...`.

Estado implementado no Marco 11B:

- `/auth/google` recebe ID token do Google, valida por OpenID Connect usando
  `GOOGLE_OIDC_AUDIENCE` e rejeita email fora de `ALLOWED_EMAILS`.
- A API emite sessao JWT local com `SESSION_JWT_SECRET` e
  `SESSION_TTL_SECONDS`.
- Quando `GOOGLE_OIDC_ENABLED=true`, `/sync/push` e `/sync/pull` exigem
  `Authorization: Bearer <token>`.
- Quando Google esta desligado, o modo dev local continua simples para teste.
- Mobile usa `google_sign_in` 7.x, inicializado com `GOOGLE_WEB_CLIENT_ID` como
  `serverClientId`.
- Mobile troca ID token por sessao da API, guarda token/email em secure
  storage e envia bearer token no sync.
- Gmail API nao e mecanismo de login.

Ainda pendente:

- 11C: aplicar eventos remotos no Drift local, gerar/guardar `deviceId` por
  instalacao e expor conflitos para revisao.

## Privacidade

- Allowlist explicita de apps monitorados.
- Parsing on-device.
- Nao enviar payload bruto de notificacoes ao servidor por padrao.
- Expurgo configuravel de eventos crus apos consolidacao.
- Tokens e chaves em secure storage.
- O manifesto de produção bloqueia backup automático e transferência Android
  de arquivos, bancos e preferências financeiras; backups continuam sendo
  criados apenas pela jornada explícita e versionada do app.
- A permissão `INTERNET` é declarada para sync opcional. Captura de
  notificações continua dependente de concessão explícita do usuário.
- A assinatura pessoal de release é injetada por variáveis
  `ZIMBA_RELEASE_*`; chave e senhas permanecem fora do repositório. Sem essas
  variáveis, o Gradle avisa e produz somente artefato diagnóstico com a chave
  de debug.
