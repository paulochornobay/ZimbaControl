# ZimbaControl - Milestones

> Registro histórico dos marcos técnicos. A partir de 2026-08-23, a ordem de
> execução vigente está em `docs/product/IMPLEMENTATION_ROADMAP.md`, os
> requisitos em `docs/product/PRODUCT_REQUIREMENTS.md` e a situação visual em
> `docs/product/VISUAL_PARITY_AUDIT.md`.

## Plano de continuidade

- Item 0 — documentação canônica e auditoria completa: concluído.
- Fase 1 — fundação visual e correções críticas: concluída tecnicamente.
- Fase 2 — instrumentos, ícones, criação inline e reset completo: concluída
  tecnicamente.
- Fase 3 — importação vinculada ao instrumento: próxima.
- Fase 4 — faturas completas por etapas: pendente.
- Fase 5 — paridade restante, homologação e release: pendente.

Baseline visual vigente: `pixel-perfect-pixels@2848fc6`. Baselines citados nos
marcos abaixo pertencem aos respectivos ciclos históricos.

### Fase 1 — conclusão técnica em 2026-08-23

- Movimentações passou a seguir a composição compacta do baseline, com filtros
  avançados em bottom sheet e detalhe real ao tocar na linha.
- Revisão não mantém mais a confirmação entre abas; o feedback expira e ainda
  oferece fechar/desfazer.
- Detalhe abre em leitura e preserva a descrição importada, enquanto o título
  amigável usa `displayDescription` sincronizável.
- A regressão inclui seis goldens em 360×800 e 390×844 e testes funcionais dos
  comportamentos críticos.

### Fase 2 — conclusão técnica em 2026-08-23

- Contas e cartões usam uma apresentação compartilhada com provedor, tipo,
  titular e últimos dígitos nas jornadas em que o instrumento é exibido ou
  selecionado.
- Categorias e centros de custo persistem ícone e cor, recebem fallback em
  migrações/backups antigos e oferecem sugestão e escolha vetorial no CRUD.
- Novo e Editar criam categoria/centro em contexto e retomam o lançamento com
  o novo item selecionado.
- “Zerar aplicativo” exige `ZERAR`, oferece backup e coordena Drift, staging,
  sync, fila nativa, preferências e sessão; permissões do Android são
  explicitamente preservadas.
- `flutter analyze` e os 72 testes Flutter passaram. A associação explícita do
  demonstrativo importado à conta/cartão é o próximo trabalho, na Fase 3.

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
- Marco 11 - Sync e Acesso Opcional: em andamento; 11A, 11B e 11C
  implementados tecnicamente; falta homologacao em dois aparelhos
- Marco 12 - Seguranca e Publicacao: planejado
- Marco A - Captura Android ponta a ponta: implementado tecnicamente; falta
  homologacao em aparelho fisico e execucao dos testes instrumentados
- Marco B - Sync de dois dispositivos: implementado tecnicamente; falta
  homologacao com duas instalacoes Android e API configurada
- Marco C - Migracao visual de Compromissos e Ajustes: implementado
  tecnicamente; falta comparacao em aparelho Android fisico
- Marco D - Migracao visual de familia, cadastros, backup e regras:
  implementado tecnicamente; falta comparacao em aparelho Android fisico
- Marco E - Estados transversais, regressao visual e homologacao: conteúdo
  técnico implementado; falta repetir build release e executar o roteiro em
  aparelho Android
- Recuperacao visual e primeira abertura local: concluida no baseline
  `pixel-perfect-pixels@6a2d072`; falta homologacao em Android fisico

## Direcao Atual

Os Marcos 00 a 03 permanecem concluidos. A sequencia posterior foi
reorganizada para entregar primeiro uma versao Android local realmente util,
com importacao, notificacoes, conciliacao e backup, deixando MongoDB, login e
publicacao para depois. O Marco 11 foi quebrado em 11A, 11B e 11C para reduzir
risco: primeiro sync tecnico com MongoDB, depois acesso Google, depois dois
dispositivos aplicando eventos remotos.

O codigo novo do Lovable em `C:\dev\pixel-perfect-pixels`
e uma referencia visual importante, especialmente para revisao, edicao,
duplicidades e parcelas. A ultima tentativa com pouco credito nao concluiu o
prompt: o projeto compilou, mas manteve "Tudo ok", navegacao antiga e acoes
mockadas. O Marco 04 foi entao implementado diretamente no Flutter.

## Marco A - Captura Android ponta a ponta e revisao de notificacoes

Entregaveis tecnicos concluidos:

- Fila SQLite nativa duravel com estados de entrega, tentativas, confirmacao
  apos persistencia no Drift e leitura paginada de no maximo 100 eventos.
- Drenagem automatica ao abrir ou retomar o app Flutter; WorkManager registra
  um pedido duravel de entrega sem executar logica financeira no listener.
- Idempotencia preservada pela chave da notificacao no Drift e por
  `transaction_sources`; uma reentrega nao reabre nem duplica um evento ja
  processado.
- Ajustes mostra permissao, allowlist, fila Android, resultados reais no
  Drift, erros recuperaveis, retencao configuravel e expurgo confirmado que
  nunca remove evento pendente.
- Testes Dart para backlog, idempotencia e falha de confirmacao; testes
  instrumentados Android para fila e expurgo seguro foram adicionados.

Homologacao pendente: executar os testes instrumentados e o roteiro em
`docs/context/ANDROID_CAPTURE_HOMOLOGATION.md` com Nubank e Mercado Pago
reais em aparelho Android. Ate isso, este marco nao deve ser marcado como
aceito para release.

## Marco C - Migracao visual de compromissos e ajustes

Entregaveis tecnicos concluidos:

- Compromissos ganhou projecao mensal, estados vazios com criacao real,
  cartoes responsivos para recorrencias/parcelas e formularios com CTA fixo
  seguro acima da safe area.
- Ajustes passou a expor o estado local real de captura Android, sync e dos
  dados que serao incluidos no backup; todos os atalhos preservam as jornadas
  Drift existentes.
- O baseline visual consultado foi `pixel-perfect-pixels@ac6bf30`. Nenhum
  codigo React/Tailwind foi incorporado ao app Flutter.
- Testes de widget cobrem 360×800 e 390×844 com nomes e valores longos, sem
  overflow ou acao ficticia.

Homologacao pendente: comparar as telas em aparelho Android fisico nos dois
viewports de referencia e registrar diferencas visuais deliberadas antes de
considerar a migracao aceita para release.

## Marco D - Migracao visual de familia, cadastros, backup e regras

Entregaveis tecnicos concluidos:

- Familia apresenta resumo local, jornadas separadas e atualizacao depois de
  editar cadastros, duplicidades ou compromissos; listas suportam nomes longos
  sem cortar a acao disponivel.
- Cadastros manteve todo o CRUD Drift para pessoas, contas, cartoes,
  categorias e centros, com estados ativo/arquivado e formularios cuja acao de
  salvar permanece acessivel acima da safe area.
- Backup deixa evidente que a restauracao substitui dados apenas depois de
  validar o arquivo e confirmar; cancelamento, falha e sucesso exibem retorno
  real da operacao.
- Regras mostra prioridade, ativacao, contador de uso e destino configurado
  em categoria/centro, sem alegar que rateio ou automacao futura ja existem.
- Testes de widget em 360×800 e 390×844 cobrem familia, cadastros, regras e
  backup com dados extensos.

Homologacao pendente: comparar as jornadas em aparelho Android fisico, com
teclado e arquivo de backup real, antes da aceitacao visual para release.

## Marco E - Estados transversais, regressao visual e homologacao

Entregaveis tecnicos concluidos:

- Feedbacks recuperaveis usam o mesmo padrão visual para falha, aviso e
  tentativa novamente; uma falha de consulta não aparece mais como lista vazia
  em Importacao, Duplicidades, Familia, Compromissos ou Ajustes.
- A regressao de widgets cobre os viewports 360×800 e 390×844, textos longos,
  valores grandes e as principais telas operacionais. Um overflow detectado no
  Resumo foi corrigido antes da aprovacao automatizada.
- O baseline visual e as diferencas deliberadas foram registrados em
  `docs/context/MARCO_E_HOMOLOGATION.md`.

Homologacao pendente: executar integralmente
`docs/context/MARCO_E_HOMOLOGATION.md` em Android fisico. A aprovacao dos
testes locais nao substitui permissao real, teclado, safe area, importacao,
backup/restauracao ou sync em dois aparelhos. A tentativa inicial deste marco
travou no `gen_snapshot`; uma repetição posterior gerou a APK diagnóstica
registrada em `docs/product/IMPLEMENTATION_ROADMAP.md`, ainda sem homologação
física e sem assinatura própria de release.

## Marco 11C - Dois dispositivos e conflitos financeiros

Entregaveis tecnicos concluidos:

- A outbox de transacoes envia snapshot versionado completo, com relacoes,
  beneficiarios e fontes, em vez de apenas `entityId`.
- Eventos de `/sync/pull` sao aplicados no Drift em sequencia, com cursor
  avancado somente apos aplicacao e deduplicacao local por `opId`.
- Eventos do proprio aparelho apenas reconhecem a versao remota. Atualizacoes
  externas seguras substituem o snapshot local de forma transacional.
- Edicoes financeiras concorrentes preservam ambos os snapshots em
  `sync_conflicts`, entram na Caixa de Revisao e exibem os valores/origens de
  cada aparelho. Confirmar a decisao local gera uma nova versao para a API.
- Testes cobrem dois bancos Drift independentes, reenvio idempotente, conflito
  concorrente, aplicacao da decisao e os contratos/API validam o payload v1.

Homologacao pendente: seguir
`docs/context/SYNC_TWO_DEVICE_HOMOLOGATION.md` com duas instalacoes Android e
API configurada. Ate isso, o Marco 11C nao deve ser marcado como aceito para
release.

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

Status: concluido. A referencia existe somente no repositorio externo
`C:\dev\pixel-perfect-pixels`; nao ha copia React dentro
do monorepo Flutter.

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
  Pago, tela de deteccao e mapeamento manual para CSV desconhecido, previa,
  resumo de lote e promocao dos registros validos para a Caixa de Revisao.
  Reimportar o mesmo arquivo marca as linhas como duplicadas.

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
- 11C - Dois Dispositivos: concluido tecnicamente. Eventos remotos sao
  aplicados de forma idempotente no Drift, eventos proprios so reconhecem a
  versao e conflitos preservam os dois snapshots para revisao. Falta a
  homologacao com duas instalacoes Android e API configurada.

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
