# ZimbaControl - Milestones

## Status Geral

- Marco 00 - Bussola do Projeto: concluido
- Marco 01 - Cofre Visual Lovable: concluido
- Marco 02 - Fundacao do Monorepo: concluido
- Marco 03 - Nucleo Local Offline: concluido para MVP local
- Marco 04 - Caixa de Revisao Real: concluido
- Marco 05 - Estrutura Financeira Familiar: concluido
- Marco 06 - Importacao CSV/OFX: concluido
- Marco 07 - Conciliacao Financeira: concluido
- Marco 08 - Captura Android: concluido
- Marco 09 - Painel e Movimentacoes: concluido
- Marco 10 - Backup e Recuperacao: concluido
- Marco 11 - Sync e Acesso Opcional: em andamento; 11A e 11B concluidos
- Marco 12 - Seguranca e Publicacao: planejado

## Direcao Atual

Os Marcos 00 a 03 permanecem concluidos. A sequencia posterior foi
reorganizada para entregar primeiro uma versao Android local realmente util,
com importacao, notificacoes, conciliacao e backup, deixando MongoDB, login e
publicacao para depois. O Marco 11 foi quebrado em 11A, 11B e 11C para reduzir
risco: primeiro sync tecnico com MongoDB, depois acesso Google, depois dois
dispositivos aplicando eventos remotos.

O codigo novo do Lovable em `/Users/macbookair/Public/dev/pixel-perfect-pixels`
e uma referencia visual importante, especialmente para revisao, edicao,
duplicidades e parcelas. A ultima tentativa com pouco credito nao concluiu o
prompt: o projeto compilou, mas manteve "Tudo ok", navegacao antiga e acoes
mockadas. O Marco 04 foi entao implementado diretamente no Flutter.

## Marco 00 - Bussola do Projeto

Entregaveis:

- `docs/context/PROJECT_BRIEF.md`
- `docs/context/MILESTONES.md`
- `docs/context/CURRENT_STATE.md`
- `docs/context/ARCHITECTURE.md`
- `docs/context/LOVABLE_SCREEN_FACTORY.md`

Criterio de aceite:

- Um novo ciclo consegue recomecar lendo apenas os arquivos de contexto.

Status: concluido.

## Marco 01 - Cofre Visual Lovable

Entregaveis:

- Prototipo Lovable preservado como referencia visual.
- Inventario das rotas e componentes existentes.
- Guia de prompts e traducao visual para Flutter.

Criterio de aceite:

- O prototipo roda localmente e esta claramente separado do app final.

Status: concluido. Ha uma copia historica em `prototypes/lovable` e o novo
download analisado em `/Users/macbookair/Public/dev/pixel-perfect-pixels`.

## Marco 02 - Fundacao do Monorepo

Entregaveis:

- `apps/mobile` com Flutter.
- `apps/api` com Node.js/TypeScript/Fastify.
- `packages/contracts` com OpenAPI e schemas.
- Scripts e README de desenvolvimento local.

Criterio de aceite:

- Mobile e backend sobem localmente com comandos documentados.

Status: concluido. Mobile Flutter, API Fastify e contratos foram criados.

## Marco 03 - Nucleo Local Offline

Entregaveis:

- Drift + SQLite com tabelas principais.
- Entidades de dominio e repositorios locais.
- Seeds pessoais iniciais.
- Streams para dashboard e caixa de revisao.

Criterio de aceite:

- Criar, editar, listar e revisar lancamentos sem internet.

Status: concluido para MVP local. Existe banco Drift local com as tabelas
principais do marco, seeds, dashboard inicial, criacao de rascunho manual,
edicao basica, revisao local, confirmacao/ignorar/duplicado e outbox.

## Marco 04 - Caixa de Revisao Real

Entregaveis:

- Refinar uma ultima vez a Caixa de Revisao no Lovable.
- Portar o visual aprovado para Flutter usando dados reais do Drift.
- Exibir merchant, origem, conta, categoria, centro de custo, beneficiarios,
  confianca e duplicidade.
- Implementar confirmar, editar, ignorar, desfazer, marcar duplicado e
  converter em transferencia.
- Adicionar revisao sequencial e filtros persistentes.
- Remover a acao insegura "Tudo ok".

Criterio de aceite:

- Revisar 20 lancamentos reais sem acoes falsas, cortes de texto ou perda de
  dados.

Status: concluido. A tela Flutter usa dados hidratados do Drift, filtros
persistidos no SQLite, acoes reais, desfazer por `SnackBar`, estados de
carregamento/erro/vazio e navegacao principal ajustada para Resumo, Revisao,
Novo, Movimentacoes e Ajustes.

## Marco 05 - Estrutura Financeira Familiar

Entregaveis:

- Contas e cartoes com proprietario.
- Separacao entre usuario autenticado e membro familiar.
- Transferencias internas entre marido e esposa sem inflar receita/despesa.
- Escola como despesa recorrente com beneficiario filho.
- Pensao como receita destinada a filha.
- Consorcio do carro como compromisso parcelado proprio, separado de
  parcelamento de cartao.
- Recorrencias mensais para escola, pensao, ajuda familiar e despesas fixas.

Criterio de aceite:

- Os principais casos da familia podem ser registrados sem distorcer receitas
  e despesas.

Status: concluido. O schema local agora tem proprietario em contas/cartoes,
usuario de acesso separado, recorrencias familiares, plano de consorcio e
campos de transferencia interna. O seed cobre escola do filho, pensao da filha,
ajuda familiar para a esposa e consorcio do carro. Transferencias internas nao
entram no resumo como receita/despesa.

## Marco 06 - Importacao CSV/OFX

Entregaveis:

- Importacao totalmente local, sem enviar arquivos para servidor.
- Suporte inicial a CSV e OFX; XLSX fora do primeiro MVP.
- Adaptadores Nubank e Mercado Pago.
- Staging com hash do arquivo e da linha.
- Deteccao de formato, encoding e separador decimal.
- Mapeamento manual para CSV desconhecido.
- Resumo com novos, invalidos, duplicados e itens que exigem revisao.

Criterio de aceite:

- Importar extratos reais anonimizados sem duplicar uma segunda importacao do
  mesmo arquivo.

Status: concluido. O app mobile agora tem importacao local CSV/OFX com
`file_picker`, parser CSV/OFX, hashes SHA-256 de arquivo e linha, tabelas
`import_batches` e `staged_source_records`, adapters iniciais Nubank/Mercado
Pago, API de mapeamento manual para CSV desconhecido, resumo de lote e promocao
dos registros validos para a Caixa de Revisao. Reimportar o mesmo arquivo
marca as linhas como duplicadas.

## Marco 07 - Conciliacao Financeira

Entregaveis:

- Deduplicacao entre notificacao, CSV, OFX e lancamento manual.
- Mescla de fontes sem perder origem.
- Pagamento de fatura como transferencia para o cartao.
- Parcelas de cartao usando plano de compra.
- Consorcio com plano proprio, total, parcela atual, valor previsto e
  vencimento.
- Casos incertos voltando para revisao com explicacao.

Criterio de aceite:

- A mesma compra capturada por notificacao e extrato aparece apenas uma vez.

Status: concluido. O banco local agora tem `duplicate_candidates`,
deduplicacao heuristica por valor/data/conta/descricao, merge de
`transaction_sources` preservando origem, reimportacao sem nova despesa,
pagamento de fatura classificado como transferencia, parcelas de cartao criando
planos `credit_card_purchase` e consorcio ligado ao plano proprio do carro.
Casos incertos seguem para a Caixa de Revisao com explicacao.

## Marco 08 - Captura Android

Entregaveis:

- `NotificationListenerService` em Kotlin.
- Lista explicita de aplicativos autorizados.
- Persistencia imediata do evento bruto no SQLite.
- Parsers por instituicao fora da thread principal.
- WorkManager para recuperacao e reprocessamento.
- Tela de permissao, status e aplicativos monitorados.
- Expurgo configuravel das notificacoes brutas.

Criterio de aceite:

- Uma notificacao autorizada gera um rascunho revisavel mesmo sem internet.

Status: concluido para MVP tecnico. O Android agora tem
`NotificationListenerService`, allowlist por app, persistencia nativa imediata
em SQLite, WorkManager preparado para reprocessamento, ponte MethodChannel com
Flutter, tabela Drift `raw_notification_events`, parser local simples de valor
e criacao/merge de rascunhos na Caixa de Revisao. A tela Ajustes mostra
permissao, apps monitorados e ultimos eventos. Validacao final em Android
fisico ainda e recomendada com apps reais.

## Marco 09 - Painel e Movimentacoes

Entregaveis:

- Inicio como resumo operacional do mes.
- Receitas, despesas, saldo, compromissos futuros e itens pendentes.
- Visoes por pessoa, categoria e centro de custo.
- Lista de movimentacoes com busca e filtros.
- Projecao simples de escola, consorcio, pensao e parcelas.
- Sem graficos decorativos ou indicadores sem utilidade.

Criterio de aceite:

- Responder rapidamente quanto entrou, quanto saiu, para quem foi e o que ainda
  vencera.

Status: concluido. A tela Resumo agora usa o mes atual como painel
operacional, com receitas, despesas, saldo, pendencias, transferencias,
compromissos futuros, projecao simples, quebras por pessoa, categoria, centro
de custo e origem, alem de ultimas movimentacoes. A rota Movimentacoes virou
lista real com busca, filtro de mes, tipo, status e origem; importacao CSV/OFX
continua acessivel por acao dentro da tela.

## Marco 10 - Backup e Recuperacao

Entregaveis:

- Exportacao local em formato versionado.
- Backup de transacoes, cadastros, regras e vinculos.
- Restauracao com validacao antes de substituir dados.
- Exportacao CSV para consulta externa.
- Compartilhamento pelo recurso nativo do Android.

Criterio de aceite:

- Reinstalar o aplicativo e recuperar os dados sem MongoDB.

Status: concluido. O app exporta backup JSON versionado, valida arquivo antes
de restaurar, restaura os dados locais em transacao, exporta CSV de
movimentacoes para consulta externa, salva arquivo pelo seletor nativo e
compartilha backup via `share_plus`. A tela Ajustes mostra o fluxo com
confirmacao explicita antes de substituir os dados locais.

## Marco 11 - Sync e Acesso Opcional

Entregaveis:

- Backend Fastify e MongoDB Atlas gratuito.
- Push/pull idempotente usando outbox e `opId`.
- Conflitos financeiros retornando para revisao.
- Google Sign-In via OpenID Connect, nao Gmail API.
- Inicio com allowlist de um unico email de teste.
- Pessoas da familia separadas dos usuarios que podem entrar no sistema.

Criterio de aceite:

- Dois dispositivos sincronizam sem duplicar lancamentos ou sobrescrever
  conflitos silenciosamente.

Status: em andamento.

Sub-marcos:

- 11A - Sync Local com MongoDB Atlas: concluido tecnicamente. A API usa store
  MongoDB quando `MONGODB_URI` existe, cria colecoes/indices, aplica
  `/sync/push` de forma idempotente por `opId`, entrega `/sync/pull`
  incremental por `seq` e registra conflito por `baseVersion`. O mobile tem
  cliente HTTP, envio da `sync_outbox`, ack local e cursor de pull.
- 11B - Acesso Google Opcional: concluido tecnicamente. A API valida Google ID
  token por OpenID Connect, aplica `ALLOWED_EMAILS`, emite sessao JWT local e
  protege sync quando `GOOGLE_OIDC_ENABLED=true`. O mobile conecta Google com
  `GOOGLE_WEB_CLIENT_ID`, guarda o token de sessao em secure storage e envia
  bearer token no sync. Teste real exige Google Cloud configurado.
- 11C - Dois Dispositivos: proximo. Aplicar eventos remotos no banco local,
  gerar `deviceId` por instalacao e expor conflitos financeiros para revisao.

## Marco 12 - Seguranca e Publicacao

Entregaveis:

- Secure Storage para tokens e segredos.
- Avaliar SQLCipher sem impedir funcionamento offline.
- Politica de retencao de dados brutos.
- Testes, lint, CI e geracao de APK.
- Documentar privacidade e permissoes.
- Publicacao publica somente apos uso pessoal estavel.

Criterio de aceite:

- Aplicativo instalavel, recuperavel e com tratamento claro dos dados
  sensiveis.
