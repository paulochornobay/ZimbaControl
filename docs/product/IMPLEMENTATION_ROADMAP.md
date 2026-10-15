# ZimbaControl — Roadmap de implementação

**Data-base:** 2026-08-23

**Fonte funcional:** [PRODUCT_REQUIREMENTS.md](PRODUCT_REQUIREMENTS.md)

**Fonte visual:** `pixel-perfect-pixels@2848fc6`

## 1. Estado do plano

| Fase | Resultado | Estado |
| --- | --- | --- |
| 0 | documentação canônica, auditoria completa e roteiro reproduzível | concluída em 2026-08-23 |
| 1 | fundação visual e correções críticas de interação | concluída em 2026-08-23 |
| 2 | instrumentos, ícones, criação inline e reset completo | concluída em 2026-08-23 |
| 3 | importação vinculada à conta/cartão correto | concluída em 2026-08-23 |
| 4 | faturas completas por etapas | concluída em 2026-08-23 |
| 5 | paridade restante, homologação Android e release | concluída tecnicamente; homologação física pendente |
| 5H | homologação Android física e release pessoal | planejada; depende de aparelho Android físico |
| 11D | sync em dois dispositivos e recuperação | planejada; depende de API configurada e duas instalações |
| 12 | hardening de segurança e preparação de publicação | planejada; só inicia após os aceites 5H e 11D |

As fases são sequenciais por dependência de domínio. Correções pequenas e
isoladas da Fase 1 podem compartilhar um ciclo, mas nenhuma fase deve ser
declarada concluída sem seus critérios de aceite.

## Próximos marcos de aceite — setembro de 2026

Os Marcos 0–8 da readequação visual encerraram a validação automatizada. Os
marcos abaixo fecham evidências físicas, sincronização real e proteção de dados
antes de qualquer distribuição além do uso pessoal estável.

### Fase 5H — Homologação Android física e release pessoal

**Objetivo:** aceitar uma candidata de release em Android real, sem perder os
dados existentes nem confundir resultado de emulador/widget com comportamento
físico.

**Pré-requisitos:** aparelho enumerado por ADB, APK candidata assinada e backup
local conferido. A troca de certificado exige tratar a instalação como nova:
exportar o backup e não desinstalar o app atual sem confirmação do responsável
pelos dados.

**Escopo:**

1. Executar instalação limpa, onboarding, reinício e uso offline; registrar
   modelo, Android, APK, assinatura e checksum.
2. Exercitar Resumo, Movimentações, Revisão, Novo e Detalhe com teclado, safe
   areas, textos/valores extensos, toque e TalkBack.
3. Importar CSV/OFX anonimizado, revisar um lançamento, verificar duplicidade e
   validar concessão/revogação da permissão de notificações.
4. Executar `ANDROID_CAPTURE_HOMOLOGATION.md`: allowlist, backlog, retomada e
   expurgo seguro.
5. Exportar backup, recusar JSON inválido, cancelar restauração e restaurar um
   backup válido; revisar recuperação em segundo aparelho quando disponível.
6. Registrar evidências e falhas reproduzíveis; corrigir somente defeitos
   confirmados e repetir os itens afetados.

**Não escopo:** nova regra financeira, schema, integração ou publicação em loja.

**Aceite:** `MARCO_E_HOMOLOGATION.md` e `ANDROID_CAPTURE_HOMOLOGATION.md`
preenchidos com aprovação ou divergência aceita; testes instrumentados relevantes
executados no dispositivo; APK assinada instalada e recuperável. Sem evidência,
o marco permanece **em andamento**.

### Marco 11D — Sync em dois dispositivos e recuperação

**Objetivo:** comprovar, com API configurada e duas instalações independentes,
que a sincronização preserva integridade, autoria e conflitos financeiros.

**Pré-requisitos:** Fase 5H aceita; API HTTPS com banco persistente; segredo de
sessão fora do repositório; identidade de acesso permitida; dois aparelhos com
backups independentes.

**Escopo:**

1. Validar login configurado, sessão expirada/rejeitada, sync desligado e
   operação offline sem envio involuntário.
2. Criar, editar e sincronizar transações, cadastros e relações nos dois
   aparelhos; confirmar reenvio idempotente, cursor e retomada após interrupção.
3. Criar edição concorrente deliberada, revisar os dois snapshots, decidir o
   resultado e confirmar a nova versão nos dois lados.
4. Verificar que payload bruto de notificação e arquivo OFX não entram no sync;
   restaurar backup de um aparelho sem criar duplicatas no outro.
5. Executar `SYNC_TWO_DEVICE_HOMOLOGATION.md`, guardando apenas evidência
   anonimizada e sem tokens, e-mails ou dados financeiros reais.

**Não escopo:** multitenancy comercial, Open Finance, backup automático em nuvem
ou resolução silenciosa de conflitos.

**Aceite:** push/pull, offline, repetição, conflito e recuperação passam em dois
aparelhos físicos; nenhum lançamento é duplicado, perdido ou sobrescrito sem
revisão; a API é reconfigurável pela documentação sem expor segredos.

### Marco 12 — Hardening de segurança e preparação de publicação

**Objetivo:** decidir e aplicar a proteção adequada ao uso pessoal estável,
preservando funcionamento offline e um processo reproduzível de release.

**Pré-requisitos:** Fase 5H e Marco 11D aceitos. SQLCipher é decisão de projeto: não
será introduzido como troca invisível de banco nem declarado obrigatório sem
análise de migração, desempenho, recuperação e custo operacional.

**Escopo:**

1. Revisar dados em SQLite/Drift, backup exportado, notificações brutas, logs,
   tokens, chaves de release, API e telemetria inexistente.
2. Formalizar retenção configurável de eventos brutos, expurgo verificável e
   privacidade/permissões coerentes com o comportamento real.
3. Registrar a decisão de criptografia: manter SQLite com mitigação documentada
   ou adotar SQLCipher com migração, rollback e testes de backup/restauração.
4. Automatizar Flutter, API, contratos, lint Android e assinatura/checksum;
   falhar a validação quando segredos ou dados pessoais surgirem em artefatos.
5. Criar runbook de release/revogação: segredos fora do Git, versionamento,
   checksum, instalação, recuperação e resposta a incidente.

**Aceite:** inventário e privacidade revisados; decisão de criptografia
justificada e testada; pipeline gera APK assinada com proveniência/checksum;
restauração e revogação ensaiadas sem expor segredos. Publicação pública segue
como decisão posterior ao uso pessoal estável.

## Readequação visual — setembro de 2026

### Marco 0 — Registro e limite

- **Data:** 2026-09-01; **baseline Lovable:**
  `pixel-perfect-pixels@33fb92b55c884cc61a7eb00307b7a8c2c51e25ad`, branch
  `main`.
- **Localhost analisado:** `http://localhost:8080/` respondeu HTTP 200. O
  Lovable foi somente lido: não houve edição, geração, commit ou publicação.
- **Estado sujo preexistente do Lovable:** `src/routeTree.gen.ts` e
  `package-lock.json`. Esse estado é apenas registrado e deve ser preservado.
- **Decisão sobre Flutter:** preservar o worktree atual, já sujo; este Marco 0
  não autoriza `reset`, `stash`, reformat, atualização de goldens ou mudanças
  em código, testes e artefatos de produção.

### Inventário das 21 rotas de tela

`/review` redireciona para `/` e não entra na contagem de telas.

| # | Rota | # | Rota | # | Rota |
| ---: | --- | ---: | --- | ---: | --- |
| 1 | `/` | 8 | `/import` | 15 | `/settings` |
| 2 | `/backup` | 9 | `/invoices` | 16 | `/summary` |
| 3 | `/capture` | 10 | `/local-data` | 17 | `/sync-privacy` |
| 4 | `/commitments` | 11 | `/movimentacoes` | 18 | `/reports/mensal` |
| 5 | `/duplicates` | 12 | `/onboarding` | 19 | `/reports/parcelas` |
| 6 | `/family` | 13 | `/registries` | 20 | `/transaction/$id` |
| 7 | `/identidade` | 14 | `/rules` | 21 | `/transaction/new` |

### Marco 1 — Fundação visual e shell compartilhado

- **Concluído em:** 2026-09-01, sem iniciar o Marco 2.
- Consolidada a fundação em `ZimbaTheme` e `zimba_ui.dart`: shell das cinco
  jornadas, cabeçalho compacto, viewport, navegação inferior com área segura,
  botões, sheets, segmentação, rows e feedbacks reutilizáveis.
- Os componentes usam exclusivamente os tokens Zimba já canônicos (cores,
  raios, sombras, espaçamentos e tipografia Inter); não introduzem tokens ou
  comportamento de domínio novos.
- A shell principal passou a usar `ZimbaHomeScaffold`; páginas continuam donas
  de seus estados e operações Drift. Não houve mudança em regras financeiras,
  sync, importação, banco, parsing ou goldens.
- Cobertura de regressão dos componentes executada em `360×800` e `390×844`
  com escala de texto `1,3`; ela verifica leitura, áreas de toque, folha modal,
  navegação e ausência de exceções/overflow.

### Marco 2 — Revisão e Movimentações

- **Concluído em:** 2026-09-01; escopo encerrado após estas duas jornadas.
- A Caixa de Revisão recebeu o shell de cabeçalho compacto, estados de
  carregamento/erro/vazio e feedback temporal com desfazer, mantendo confirmar,
  ignorar, abrir detalhe e as operações Drift já existentes.
- Movimentações recebeu o mesmo shell, busca limpável, chips rápidos, linhas
  densas com avatares, badges e valores, além de filtros avançados em bottom
  sheet. Os filtros ativos são exibidos individualmente, podem ser removidos e
  podem ser limpos de uma vez.
- `flutter analyze` não reportou problemas e `flutter test
  test/phase1_widget_test.dart --update-goldens` passou com 14 testes. Os
  goldens de Revisão e Movimentações foram atualizados em `360×800` e
  `390×844`; as verificações cobrem confirmar, ignorar/desfazer, detalhe,
  busca, filtros combinados e limpar filtros.
- Não foram alterados Drift, domínio financeiro, sync, parsing, importação ou
  o repositório Lovable.

### Marco 3 — Novo lançamento e detalhe/edição

- **Concluído em:** 2026-09-01; escopo encerrado após Novo e Detalhe/Edição.
- Novo passou a agrupar valor/tipo, descrição, instrumento, classificação e
  participantes no shell visual. O seletor de instrumento abre em sheet e
  identifica conta/cartão por tipo, instituição, titular e final; criação
  inline de categoria e centro permanece integrada ao formulário.
- Detalhe abre em leitura e só expõe campos após **Editar**. Os seletores usam
  sheets compartilhados e a tela mostra origem, confiança, duplicidade provável
  e sugestão de transferência a partir do estado existente, sem inventar dados.
- A edição atualiza somente `displayDescription`; `descriptionRaw` é visível
  como texto externo imutável para auditoria. Nenhum contrato Drift, schema ou
  regra financeira foi alterado.
- Passaram `flutter analyze`, `phase1_widget_test.dart` (14),
  `phase2_test.dart` (4) e `marco3_widget_test.dart` (2). A cobertura valida
  receita, despesa, transferência, criação inline, instrumento ambíguo, edição
  explícita, texto externo e textos longos; goldens do detalhe foram renovados
  em `360×800` e `390×844`.

### Marco 4 — Resumo e relatórios

- **Concluído em:** 2026-09-01; escopo encerrado após Resumo, Relatório mensal
  e Parcelas futuras.
- O Resumo passa a selecionar competência e separa pendências dos realizados.
  Receita, despesa, saldo e detalhamentos consideram apenas confirmados;
  transferências continuam neutras e visíveis sem contaminar os totais.
- O reports_page.dart existente foi consolidado em uma entrada filha para
  /reports/mensal e /reports/parcelas, com retorno explícito. Relatórios não
  foram adicionados como sexto item da navegação principal.
- Relatório mensal oferece competência, estado vazio e alternância de
  categoria para grupo/contexto. Parcelas futuras agrupa a projeção de planos
  e recorrências na competência, respeita o horizonte conhecido e não insere
  lançamento, compromisso ou dado no Drift.
- marco4_widget_test.dart passou com 3 testes nos viewports 360×800 e 390×844,
  com escala 1,3, cobrindo valores grandes, mês vazio, detalhamento alternável
  e projeção sem escrita. Também passaram a regressão de agregação operacional
  e flutter analyze, sem overflow.
- Não houve mudança de schema ou contrato de dados; o ajuste de agregação
  aplica a regra já exigida de excluir pendências e transferências dos totais.

### Marco 5 — Ajustes, cadastros e domínio familiar

- **Concluído em:** 2026-09-01; escopo encerrado após Ajustes, Família,
  Cadastros, Compromissos e Faturas.
- As jornadas secundárias passaram a usar cabeçalho compacto, retorno e ações
  reais; loading, vazio e erro foram alinhados aos componentes compartilhados.
  O rótulo de carregamento foi tornado responsivo para não exceder 360 px.
- Ajustes preserva todas as jornadas filhas. Família mantém a estrutura
  existente e seus encaminhamentos. Cadastros conserva CRUD, formulários e
  arquivamento; a lista de contas deixa de repetir a conta técnica de cartões,
  distinguindo corretamente os instrumentos do mesmo banco.
- Compromissos preserva recorrências, planos, arquivamento, edição e projeção
  sem lançamento novo. Faturas preserva ciclo, compra, estorno, pagamento
  parcial, conciliação, desfazer e projeções, sem alterar seus cálculos.
- Passaram 11 testes em marco5_widget_test.dart, marco_c_widget_test.dart,
  registries_page_widget_test.dart e phase4b_test.dart, incluindo 360×800,
  390×844, texto 1,3, vazio, valores e nomes longos, instrumentos do mesmo
  banco, compromisso ativo, fatura parcial, estorno e pagamento. flutter
  analyze não reportou problemas.
- Não houve alteração de schema, contrato Drift ou regra financeira.

### Marco 6 — Operações de suporte

- **Concluído em:** 2026-09-01; escopo encerrado após Importação, Conciliação,
  Regras, Backup, Sync/Privacidade, Captura Android e Dados locais/reset.
- As páginas secundárias passaram a usar o shell compacto e seus estados
  compartilhados. Importação preserva stepper, prévia, badges e confirmação
  de destino; Conciliação preserva mesclar, manter separados e ignorar.
- Regras continua persistindo match, prioridade, estado e destino. Backup
  valida o JSON antes de uma confirmação explícita de substituição. Reset usa
  sheet compartilhado, exige `ZERAR` e mantém explícitas as permissões Android
  que não podem ser revogadas pelo app.
- Sync sem configuração mostra somente a fila local e declara que nenhum dado
  será enviado. Captura mostra disponibilidade, permissão e apps reais; em
  ambiente não Android, os controles permanecem indisponíveis.
- Passaram marco6_widget_test.dart, phase2_test.dart, import_parser_test.dart
  e três verificações direcionadas de app_database_test.dart: 20 testes em
  total, incluindo 360×800 e 390×844, escala 1,3, estados de plataforma,
  reset, backup/restauração e CSV com destino confirmado. `flutter analyze`
  não reportou problemas.
- Não houve mudança de schema, contratos Drift, parser, regras financeiras ou
  transporte de sync.

### Marco 7 — Onboarding progressivo

- **Concluído em:** 2026-09-01; escopo encerrado após a configuração inicial.
- O onboarding foi refeito como jornada progressiva: pessoa, instituição,
  tipo, identidade, dados específicos de cartão, categorias e revisão. O
  progresso é visível, voltar mantém as respostas e sair não grava dados.
- O catálogo usa somente monogramas, cores e ícones vetoriais internos, com
  fallback “Outra instituição”; não há logos sem licença.
- `SetupInput` e `saveInitialSetup` agora aceitam cartão, bandeira, final,
  fechamento, vencimento e categorias selecionadas. A criação de pessoa,
  instrumento, preferências e catálogo ocorre na transação de setup; a opção
  de demonstração continua explícita e separada.
- Passaram 18 testes entre marco7_widget_test.dart, onboarding_widget_test.dart,
  phase2_test.dart e a regressão de setup inicial: instalação limpa, retorno
  após reset, validações, conta/cartão, dados de cartão, categorias, retorno,
  interrupção e conclusão, incluindo 360×800 e 390×844. `flutter analyze` não
  reportou problemas.
- Não houve schema novo, logo externo ou criação de lançamento artificial.

### Marco 8 — Regressão visual, acessibilidade e homologação

- **Automação aprovada em:** 2026-09-01. Não houve redesign adicional; apenas
  correções de regressão e atualização de evidências.
- O capturador de baseline e a matriz golden passaram a cobrir as **21 rotas**
  Lovable, incluindo `/reports/mensal` e `/reports/parcelas`. Foram geradas 63
  capturas de `pixel-perfect-pixels@33fb92b`, 42 pares/overlays nos viewports
  obrigatórios `360×800` e `390×844`, e 21 diagnósticos extras em `440×900`.
  Artefatos: `baselines/lovable/33fb92b`, `comparisons/33fb92b` e
  `apps/mobile/test/goldens/parity`.
- Foram revalidados texto `1,3`, vazio, erro, loading, offline e conteúdo
  longo nas jornadas cobertas pelas suítes dos Marcos 1–7. `flutter analyze`
  passou sem problemas; `flutter test` passou com **159 testes**.
- As correções limitaram-se a: sincronizar goldens, impedir colisão de ID em
  dois lotes de importação imediatos e estabilizar testes que dependiam do
  relógio/teclado. A tolerância de comparação é `0,04%` apenas para
  rasterização (89 pixels no detalhe); não é tolerância de geometria.
- Diferenças aceitas: Flutter preserva dados e estados reais de Drift, sync,
  permissões e backup; relatórios são jornadas filhas com retorno nativo, sem
  sexto item de navegação. Essas diferenças não são mascaradas nos overlays.
- **Pendência externa:** não houve Android físico no ADB. Há AVD Pixel_Tablet,
  mas ele não substitui toque/TalkBack em aparelho; o roteiro físico permanece
  pendente de reconexão de dispositivo.

### Estratégia de screenshot/overlay

Nos marcos posteriores, produzir pares Lovable/Flutter da mesma rota e estado,
com dados demonstrativos determinísticos, nos viewports `360×800` e `390×844`.
Sobrepor as imagens para verificar moldura, alinhamento, espaçamento,
tipografia, cor e overflow; registrar baseline, rota, estado e viewport junto
de qualquer divergência deliberada. O Marco 1 validou a base responsiva; as
capturas pareadas das demais rotas pertencem aos marcos posteriores.

## 2. Fase 0 — Base canônica e auditoria

### Entregue

- requisitos funcionais e não funcionais consolidados;
- inventário das 12 telas do protótipo, redirecionamento e jornadas exclusivas
  do Flutter;
- baseline e estado sujo do repositório visual registrados;
- divergências críticas ligadas às causas atuais do código;
- roadmap com dependências, testes e política de release;
- documentos históricos apontando para esta fonte canônica.

### Limite

Esta fase não altera banco, UI, regras financeiras, protótipo ou APK.

## 3. Fase 1 — Fundação visual e correções críticas

### Objetivo

Tornar navegação, Movimentações, Revisão e detalhe coerentes com a fonte
visual, eliminando os defeitos mais visíveis sem migrar ainda o domínio.

### Escopo

1. Consolidar shell, cabeçalhos, largura, grid, densidade, raios, tipografia e
   navegação compartilhada.
2. Corrigir o quarto destino para “Movim.” com ícone apropriado.
3. Refatorar Movimentações:
   - busca compacta e ação de filtros;
   - chips rápidos horizontais;
   - bottom sheet para filtros avançados;
   - lista densa, sem painel/totais redundantes;
   - abertura do detalhe real.
4. Corrigir o snackbar de confirmação: saída imediata da fila, duração
   explícita, `persist: false`, fechar e desfazer acessíveis.
5. Abrir detalhe em leitura e edição apenas por ação explícita.
6. Introduzir `displayDescription` com fallback e manter
   `descriptionRaw` somente leitura para fontes externas.

### Aceite

- goldens/overlays de Revisão, Movimentações e Detalhe em 360×800 e 390×844;
- snackbar desaparece sozinho e não acompanha troca de aba;
- nenhuma regressão em confirmar/desfazer, busca ou filtros;
- migração de título preserva descrições existentes e backup compatível.

### Entregue em 2026-08-23

- navegação principal corrigida para “Movim.” e feedback removido ao trocar de
  aba;
- Movimentações refeita com cabeçalho e busca compactos, chips rápidos,
  filtros avançados em bottom sheet, linhas densas e abertura do detalhe;
- snackbar de confirmação com duração explícita, fechamento e desfazer;
- detalhe inicialmente somente leitura, com edição por ação explícita;
- `displayDescription` adicionado por migração Drift 11, com backfill,
  contratos e sync retrocompatíveis; `descriptionRaw` permanece imutável;
- seis goldens de Revisão, Movimentações e Detalhe nos viewports 360×800 e
  390×844, além de testes de troca de aba, expiração e preservação do texto
  original.

A homologação em Android físico continua concentrada na Fase 5; ela não
bloqueia o encerramento técnico local desta fase.

## 4. Fase 2 — Instrumentos, cadastros e recomeço seguro

### Objetivo

Eliminar seleções ambíguas e tornar o cadastro contextual, com uma limpeza
realmente completa do app.

### Escopo

1. Criar um componente `InstrumentDisplay` compartilhado com tipo, provedor,
   titular, nome e últimos dígitos.
2. Aplicá-lo em Novo, Editar, Movimentações, Importação e Cadastros.
3. Adicionar `iconKey` e `colorKey` a categorias e centros, com backfill,
   fallback, sugestões e seletor vetorial.
4. Permitir criar categoria/centro dentro de Novo/Editar e selecionar o novo
   registro após salvar.
5. Criar área de perigo “Zerar aplicativo” com contagens, oferta de backup e
   confirmação `ZERAR`.
6. Coordenar exclusão de todas as tabelas Drift, sync, staging, fila nativa,
   preferências e sessão; explicar que permissões do Android permanecem;
   retornar ao onboarding.

### Aceite

- conta e cartão do mesmo provedor são inequívocos em toda seleção;
- registros antigos recebem ícone/cor sem perda;
- criação inline retorna ao lançamento com a opção selecionada;
- teste de integração comprova ausência de dados em todos os stores e retorno
  ao onboarding;
- backup anterior ao reset continua restaurável.

### Entregue em 2026-08-23

- `InstrumentDisplay` compartilhado identifica nome, provedor, tipo, titular e
  últimos dígitos em Novo, Editar, Movimentações, Importação e Cadastros;
- categorias e centros ganharam `iconKey`/`colorKey` na migração Drift 12,
  backfill, fallback para backups antigos, sugestões em português e seletor
  vetorial;
- Novo e Editar permitem criar categoria ou centro sem abandonar o lançamento
  e retornam com o registro recém-criado selecionado;
- Ajustes > Dados locais ganhou a área de perigo “Zerar aplicativo”, contagens,
  atalho para backup, explicação das permissões Android preservadas e
  confirmação digitada `ZERAR`;
- o reset coordenado limpa tabelas financeiras, staging, regras, stores de
  sync, fila SQLite nativa, preferências da captura e sessão segura antes de
  retornar ao onboarding;
- testes cobrem instrumentos do mesmo provedor, criação inline, fallback de
  backup e reset de todos os stores com restauração posterior. A suíte completa
  soma 72 testes aprovados, com `flutter analyze` sem avisos.

A associação do arquivo OFX ao instrumento correto permanece deliberadamente
na Fase 3: nesta fase o histórico de importação passou a mostrar a identidade
disponível, mas não infere um destino que o parser ainda não comprovou.

## 5. Fase 3 — Importação orientada ao instrumento

### Objetivo

Garantir que cada arquivo seja associado explicitamente à conta ou cartão
correto antes de gerar lançamentos.

### Escopo

1. Evoluir o parser para produzir `StatementIdentity` com tipo, provedor,
   `ACCTID`, moeda, período e saldos disponíveis.
2. Persistir metadados e `targetAccountId` no lote de importação.
3. Implementar etapas reais: arquivo, identificação, mapeamento CSV quando
   necessário, prévia, confirmação do destino e resultado.
4. Sugerir destino por tipo/provedor/últimos dígitos, sempre mostrando a
   confirmação; bloquear ambiguidade.
5. Permitir cadastrar instrumento ausente e retornar ao lote.
6. Promover e conciliar usando exclusivamente o destino confirmado, removendo
   a dependência de “primeira conta do provedor”.
7. Exibir conta/cartão e metadados do demonstrativo no histórico do lote.

### Aceite

- testes com conta corrente e cartão Nubank simultâneos;
- cenários `BANKACCTFROM`, `CCACCTFROM`, `ACCTID` ausente, destino incorreto,
  mais de um candidato e criação durante o fluxo;
- reimportação preserva idempotência de arquivo/linha;
- nenhum lote ambíguo é promovido silenciosamente.

### Entregue em 2026-08-23

- o parser produz `StatementIdentity` com tipo bancário/cartão, provedor,
  `ACCTID`, banco/agência, moeda, período e saldos contábil/disponível quando o
  OFX fornece esses campos; CSV mantém identidade honesta quando a fonte não é
  comprovável;
- a migração Drift 13 persiste os metadados, `targetAccountId`, instante e
  motivo da confirmação, mantendo restore de backups anteriores;
- a jornada real segue arquivo/mapeamento, identificação, destino, prévia e
  resultado, com histórico dos lotes e instrumento confirmado visível;
- destinos são sugeridos por tipo, provedor, moeda e últimos dígitos, mas a
  promoção permanece bloqueada até confirmação explícita; empates e `ACCTID`
  ausente nunca escolhem silenciosamente;
- conta/cartão ausente pode ser cadastrado dentro do lote e retorna
  selecionado para confirmação;
- conciliação e promoção deixaram de usar a primeira conta do provedor e o
  primeiro cartão: transações, merges e parcelas usam exclusivamente o destino
  confirmado, sem inferir a outra ponta do pagamento de fatura;
- testes cobrem conta e cartão Nubank simultâneos, `BANKACCTFROM`,
  `CCACCTFROM`, `ACCTID` ausente, tipo/final incorretos, cadastro contextual,
  idempotência existente, backup retrocompatível e responsividade em 360×800 e
  390×844 com texto 1,3.

A consolidação de faturas, seus pagamentos, fechamento e vencimento permanece
na Fase 4; esta fase apenas garante que cada origem importada chegue ao
instrumento correto.

## 6. Fase 4 — Faturas completas por etapas

### Objetivo

Consolidar gastos de cartão no mês de fatura correto, sem contar pagamento da
fatura como nova despesa.

### Etapa 4A — Modelo e cálculo

- criar `CreditCardInvoice`, `InvoicePayment` e vínculo opcional da transação;
- armazenar período, fechamento, vencimento, origem e estado efetivo;
- associar por `postedAt` com fallback para `occurredAt`;
- tratar corte, virada de ano, estorno, pagamento parcial/total e correção
  manual auditável;
- migrar helpers atuais sem mudar dados históricos silenciosamente.

#### Entregue em 2026-08-23

- a migração Drift 14 criou `credit_card_invoices`, `invoice_payments` e
  `invoice_assignment_audits`, além do vínculo opcional e sua origem/data na
  transação;
- ciclos determinísticos calculam período, fechamento e vencimento antes, no e
  depois do corte, inclusive fevereiro, dia 31 e virada anual;
- a associação usa `postedAt` e recorre a `occurredAt`; recálculo derivado não
  altera competência nem valor histórico e respeita correção manual;
- total e estado efetivo derivam compras, estornos e pagamentos ativos;
  pagamentos vinculados exigem transação do tipo transferência e não entram
  novamente como despesa;
- correção e remoção de vínculo deixam trilha com origem, motivo, fatura
  anterior e nova; backup/restore anterior permanece aceito;
- o payload sincronizável da transação inclui o vínculo da fatura, e 8 testes
  dedicados cobrem os casos de aceite dentro da regressão total de 88 testes.

### Etapa 4B — Visão de fatura

- visão por cartão com fatura atual/próxima, total, datas e estado;
- detalhe com compras, estornos, parcelas, pagamentos e total derivado;
- filtros por categoria, pessoa e competência;
- indicação clara de mês-calendário versus mês da fatura.

#### Entregue em 2026-08-23

- **Ajustes > Faturas de cartões** abre uma visão real por instrumento, cria a
  fatura atual/próxima determinística e permite navegar pelas competências;
- o resumo exibe total, fechamento, vencimento, pago, em aberto e estado
  efetivo; compras, estornos e pagamentos possuem seções próprias;
- filtros de categoria e pessoa atuam nos lançamentos da competência escolhida
  e cada item abre a edição real da transação;
- a interface explica o intervalo do ciclo e preserva visualmente a diferença
  entre mês da fatura e mês-calendário;
- o protótipo vigente não possui rota equivalente de fatura, então a composição
  reutiliza o design system Flutter validado, sem copiar mock ou inventar ações;
- testes cobrem 360×800 e 390×844, texto 1,3, dois cartões com nomes longos,
  valor grande, estorno, pagamento parcial e ausência de cartão.

### Etapa 4C — Conciliação e projeção

- sugerir pagamento de fatura como transferência, sempre com confirmação;
- reconciliar OFX bancário com pagamento e OFX/cartão com compras;
- projetar parcelas nas faturas seguintes sem duplicar a despesa.

#### Entregue em 2026-08-23

- transferências candidatas são pontuadas por descrição, provedor, cartão,
  valor e proximidade do vencimento, mas permanecem apenas sugestões;
- a confirmação possui diálogo explícito, vincula conta de origem ao cartão e
  registra `InvoicePayment` sem incluir a transferência no total de despesas;
- fontes OFX bancárias preservadas na transação produzem pagamento com origem
  `ofx_reconciled`; compras de OFX/cartão seguem o instrumento confirmado e
  entram automaticamente no ciclo correto;
- planos de compra parcelada passaram a ter identidade estável por cartão,
  compra e mês inicial, permitindo reconhecer parcelas sucessivas;
- parcelas restantes criam competências de planejamento e linhas projetadas,
  sem inserir transações e sem alterar compras, total ou saldo da fatura;
- a tela separa sugestões, pagamentos confirmados e projeções, explicando que
  previsão não é nova despesa; quatro testes dedicados cobrem regra, OFX ponta
  a ponta, cancelamento da confirmação e responsividade em 360×800/390×844.

### Aceite

- testes de corte antes/no/depois do fechamento, meses curtos e virada anual;
- estorno reduz total, pagamento não aumenta despesas e estados derivam dos
  valores reais;
- Nubank pode sugerir fechamento a partir do vencimento, mas a configuração é
  editável e visível;
- correções manuais deixam trilha suficiente para explicar a fatura.

## 7. Fase 5 — Paridade restante, homologação e release

### Objetivo

Finalizar as telas restantes e produzir uma build Android validada, assinada
adequadamente para distribuição pessoal.

### Escopo

1. Migrar Resumo, Ajustes, Família, Backup, Regras, Sync/privacidade,
   Duplicidades, Onboarding, Cadastros, Compromissos e Captura Android.
2. Registrar diferenças deliberadas quando o protótipo simular recurso que o
   produto não possui.
3. Executar regressão visual de todas as telas e estados.
4. Homologar em Android físico com instalação limpa, dados Nubank
   anonimizados, offline, teclado, retorno do app, notificações, importação,
   backup/restauração e reset.
5. Configurar assinatura de release própria, revisar permissões/privacidade e
   gerar APK final com checksum.

### Aceite

- todas as linhas da auditoria marcadas como equivalentes ou com diferença
  deliberada justificada;
- `flutter analyze` sem avisos e suíte de testes completa aprovada;
- testes instrumentados Android relevantes aprovados;
- nenhuma captura pessoal incluída no Git;
- APK release reproduzível, assinado para release e instalado no aparelho de
  homologação.

### Entregue tecnicamente em 2026-08-23

- o Resumo foi recomposto segundo a hierarquia do protótipo: saldo único,
  entradas/saídas, transferência interna, revisão pendente, leitura alternável
  por pessoa/categoria/centro, origens, compromissos e lista densa;
- Resumo, Ajustes e Família ganharam goldens em 360×800 e 390×844; uma
  regressão adicional percorre 13 jornadas reais nos dois viewports com texto
  em 1,3, incluindo Backup, Regras, Sync/privacidade, Duplicidades,
  Cadastros, Compromissos, Captura, Importação, Novo e Onboarding;
- as diferenças sem equivalente no protótipo foram mantidas deliberadamente:
  backup é local, sync informa quando está desabilitado, faturas usam domínio
  real e nenhuma ação simulada foi introduzida;
- o Android passou a declarar rede explicitamente, desabilitar backup e
  transferência automática dos dados financeiros, usar ícone/splash próprios
  e assinar a release com uma chave pessoal externa ao repositório;
- `flutter analyze`, 99 testes Flutter, contrato OpenAPI, build TypeScript e 7
  testes da API foram aprovados; o lint Android terminou com zero erros e o
  APK de testes instrumentados foi compilado; a APK `1.2.0+3` foi verificada pelo
  `apksigner` com RSA 4096 e tem SHA-256
  `0D29C9D3D1D0F9177C57DFBE2BFD49E22809A7DE54084603C77396E42E7FC2E5`.

A instalação limpa e a execução dos testes instrumentados em aparelho continuam
pendentes porque o ADB deixou de enumerar o Samsung no fechamento. A versão
anterior usa certificado de debug; substituí-la pela assinatura pessoal exige
backup e desinstalação, portanto os dados existentes não serão apagados sem
confirmação explícita.

## 8. Evoluções públicas de dados previstas

| Área | Evolução planejada |
| --- | --- |
| Transação | `displayDescription` separado de `descriptionRaw`; vínculo opcional de fatura |
| Categoria/centro | `iconKey` e `colorKey` com fallback e backfill |
| Importação | `targetAccountId` e metadados de `StatementIdentity` no lote |
| Cartão | entidades de fatura, pagamento e resumo derivado |
| Apresentação | `InstrumentDisplay` compartilhado entre seletores e listas |

Toda evolução exige migração Drift, backup/restore retrocompatível, ajuste no
payload de sync quando a entidade for sincronizada e testes com banco
preexistente.

## 9. Matriz mínima de testes

| Tema | Casos obrigatórios |
| --- | --- |
| Visual | goldens 360×800 e 390×844, texto 1,3, nomes e valores longos |
| Movimentações | filtros combinados, limpar, vazio, detalhe, lista extensa |
| Revisão | confirmar, desfazer, trocar aba, snackbar temporário |
| Instrumentos | mesmo banco com conta/cartão/titulares diferentes |
| OFX | banco/cartão, ACCTID presente/ausente, ambiguidade, reimportação |
| Fatura | fechamento, vencimento, estorno, pagamento parcial/total, parcelas |
| Reset | Drift, sync, fila nativa, preferências, sessão, onboarding e restore |
| Acessibilidade | TalkBack, contraste, ícones rotulados e alvos de 48 dp |

## 10. Estado de build na abertura do plano

Em 2026-08-23, o código-base `cd67fcb` passou em `flutter analyze` e nos 61
testes então existentes. A APK `1.1.0+2` foi gerada em
`apps/mobile/build/app/outputs/flutter-apk/app-release.apk`, SHA-256
`36C922AE12AA35C1BE22C4305C1DF8E08E2EB714D76ACCD58D3AB074750C2C57`.

Esse artefato é diagnóstico, não o release final: ele usa certificado de debug
e o manifesto principal não declara `INTERNET`. Uma nova APK só deve ser
considerada candidata após a Fase 5 e a homologação física.

Após a Fase 2, a APK release `1.1.0+2` foi reconstruída e instalada por
atualização no Samsung `SM-S908E`. O SHA-256 do artefato diagnóstico é
`9422CC20D010FB0F483ADDD24530B42B39B55864D72B7BF12775F7EC34F84003`.
Isso comprova compilação e instalação, mas não altera a política: assinatura
própria e homologação integral continuam sendo critérios da Fase 5.
