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
| 5 | paridade restante, homologação Android e release | próxima |

As fases são sequenciais por dependência de domínio. Correções pequenas e
isoladas da Fase 1 podem compartilhar um ciclo, mas nenhuma fase deve ser
declarada concluída sem seus critérios de aceite.

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
