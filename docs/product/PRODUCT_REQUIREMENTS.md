# ZimbaControl — Requisitos canônicos do produto

**Versão:** 1.0

**Data da consolidação:** 2026-08-23

**Estado:** aprovado como fonte funcional para os próximos ciclos

**Baseline visual:** `pixel-perfect-pixels@2848fc6`

## 1. Finalidade e precedência

O ZimbaControl é um aplicativo Android de finanças familiares, offline-first,
que transforma lançamentos manuais, notificações e arquivos CSV/OFX em dados
financeiros revisáveis, explicáveis e recuperáveis.

Este documento define **o que o produto deve fazer**. Para decisões de
implementação e ordem de entrega, usar também:

1. [Auditoria de paridade visual](VISUAL_PARITY_AUDIT.md);
2. [Roadmap de implementação](IMPLEMENTATION_ROADMAP.md);
3. `docs/context/ARCHITECTURE.md`, para as restrições técnicas vigentes.

Em caso de conflito sobre requisitos ou prioridade, os três documentos de
`docs/product` prevalecem sobre roteiros históricos de `docs/context`.

O projeto React em `C:\dev\pixel-perfect-pixels` é a fonte visual oficial. Ele
é um protótipo, não uma especificação de comportamento: nenhuma ação mockada
deve ser reproduzida como se estivesse funcional, e nenhum código
React/Tailwind deve ser copiado para o Flutter.

## 2. Princípios obrigatórios

- **Offline primeiro:** cadastro, revisão, importação, movimentações e backup
  devem continuar úteis sem rede, login ou MongoDB.
- **Verdade financeira antes de automação:** uma classificação incerta entra
  em revisão; o app não confirma silenciosamente uma despesa duvidosa.
- **Instrumentos inequívocos:** conta corrente, conta de pagamento e cartão
  precisam ser distinguíveis mesmo quando pertencem ao mesmo banco.
- **Origem preservada:** o texto recebido de OFX, CSV ou notificação não deve
  ser perdido ao editar o título exibido.
- **Ações reais e recuperáveis:** estados de sucesso, vazio, erro e
  indisponibilidade devem refletir o domínio e os dados reais.
- **Privacidade local:** captura, backup, sync e exclusão exigem comunicação
  clara sobre o que permanece no aparelho ou fora dele.
- **Acessibilidade:** ícones não podem ser a única fonte de significado;
  textos, contraste, leitura por TalkBack e alvos de toque fazem parte do
  aceite.

## 3. Arquitetura de informação

A navegação principal deve conter exatamente cinco destinos:

| Destino | Função |
| --- | --- |
| Resumo | leitura consolidada do mês e próximos compromissos |
| Revisão | fila de eventos ainda não consolidados |
| Novo | criação rápida de um lançamento real |
| Movim. | busca, filtros e auditoria de todos os lançamentos |
| Ajustes | cadastros, importação, backup, captura, sync e privacidade |

O quarto item representa **Movimentações**. “Filtros” é uma ação interna dessa
tela, nunca o nome do destino principal.

## 4. Requisitos funcionais

### 4.1 Revisão

- **REV-01:** confirmar, editar, ignorar, desfazer e tratar duplicidades deve
  usar transações reais do Drift.
- **REV-02:** ao confirmar ou ignorar, o item deve sair da fila imediatamente.
- **REV-03:** a confirmação deve aparecer por tempo limitado, admitir
  “Desfazer” e não permanecer sobre outras telas.
- **REV-04:** cada sugestão deve explicar origem, confiança e motivo da
  revisão quando esses dados existirem.
- **REV-05:** eventos com conflito de sync ou possível duplicidade não podem
  ser sobrescritos silenciosamente.

### 4.2 Movimentações

- **MOV-01:** apresentar cabeçalho compacto, busca sempre acessível, filtros
  rápidos horizontais e lista densa no padrão do protótipo.
- **MOV-02:** filtros avançados devem abrir em bottom sheet e incluir período,
  pessoa, conta/cartão, categoria, centro de custo e origem.
- **MOV-03:** a tela não deve manter um painel grande de filtros nem cartões de
  totais repetidos antes da lista.
- **MOV-04:** cada linha deve mostrar título, categoria/centro, participantes,
  status, origem, valor e data com hierarquia legível, sem transformar cada
  item em um cartão alto.
- **MOV-05:** filtros ativos devem ser visíveis, removíveis e persistir apenas
  pelo tempo necessário à jornada; “Limpar” restaura a visão padrão.
- **MOV-06:** busca e filtros devem operar sobre dados reais e preservar a
  possibilidade de abrir o detalhe do lançamento.

### 4.3 Lançamento e detalhe

- **LAN-01:** o cadastro rápido deve solicitar tipo, valor, data, título,
  conta/cartão, categoria, centro de custo, pagador e beneficiários conforme o
  caso.
- **LAN-02:** conta/cartão, categoria e centro de custo devem ter rótulos e
  ícones reconhecíveis, inclusive em listas extensas.
- **LAN-03:** a ausência de categoria ou centro deve oferecer criação inline,
  retornar ao formulário e selecionar automaticamente o item criado.
- **LAN-04:** o detalhe abre em modo de leitura. Alterações só começam após uma
  ação explícita “Editar”.
- **LAN-05:** o produto separa dois conceitos:
  - **título amigável:** texto curto e editável mostrado nas listas;
  - **descrição original:** texto bruto e somente leitura recebido da fonte.
- **LAN-06:** em lançamento manual, o título é obrigatório e a origem deve ser
  identificada como Manual. Em importação/captura, editar o título nunca
  altera o texto original.
- **LAN-07:** campos técnicos ou futuros sem efeito claro não devem aparecer
  como caixas de texto abertas.

### 4.4 Contas, cartões e demais cadastros

- **CAD-01:** todo instrumento deve exibir, quando disponível: ícone do tipo,
  provedor, nome, titular, tipo e quatro últimos dígitos.
- **CAD-02:** duas opções “Nubank” devem continuar distinguíveis como, por
  exemplo, “Conta corrente · Paulo · •1234” e “Cartão de crédito · Paulo ·
  •5678”.
- **CAD-03:** usar ícones vetoriais genéricos e monogramas próprios. Logos
  oficiais de bancos não são requisito e não devem ser embutidos sem licença.
- **CAD-04:** categorias e centros de custo possuem `iconKey` e `colorKey`,
  com padrão automático, fallback seguro e seletor no CRUD.
- **CAD-05:** registros existentes recebem backfill determinístico; a ausência
  de ícone nunca resulta em espaço vazio ou significado perdido.
- **CAD-06:** arquivar preserva o histórico e remove o item apenas das novas
  seleções, salvo quando necessário para editar um lançamento antigo.

### 4.5 Importação CSV/OFX

- **IMP-01:** o fluxo deve ser explícito e progressivo: arquivo, origem,
  mapeamento quando aplicável, prévia, confirmação e resultado.
- **IMP-02:** o OFX deve distinguir extrato bancário de cartão e ler a
  identidade do demonstrativo, incluindo `BANKACCTFROM` ou `CCACCTFROM`,
  `ACCTID`, moeda, período e saldos quando fornecidos.
- **IMP-03:** antes de promover linhas, o app sempre mostra e confirma a
  conta/cartão de destino. A sugestão pode usar tipo, provedor e últimos
  dígitos, mas nunca escolher silenciosamente apenas pelo banco.
- **IMP-04:** se houver mais de um candidato plausível, a confirmação é
  obrigatória; sem candidato, a pessoa pode cadastrar o instrumento e voltar
  ao fluxo.
- **IMP-05:** lote e registros promovidos preservam a identidade do
  demonstrativo e o `targetAccountId` confirmado.
- **IMP-06:** a tela do lote mostra de qual conta/cartão vieram os dados,
  período, contagens de novos/duplicados/inválidos e motivo dos conflitos.
- **IMP-07:** hashes de arquivo/linha, staging e idempotência existentes devem
  ser preservados.

### 4.6 Faturas de cartão

- **FAT-01:** cartão, fatura, transação da fatura e pagamento da fatura são
  conceitos distintos.
- **FAT-02:** cada cartão deve permitir configurar dia de fechamento, dia de
  vencimento e regra de competência; sugestões do provedor são editáveis.
- **FAT-03:** o app deve mostrar fatura atual e próxima, período, datas de
  fechamento/vencimento, total, pagamentos, estornos, parcelas e estado:
  aberta, fechada, parcialmente paga, paga ou atrasada.
- **FAT-04:** a associação usa `postedAt` quando confiável e `occurredAt` como
  fallback. Compra realizada a partir do corte de fechamento vai para a fatura
  seguinte por padrão, com correção manual auditável.
- **FAT-05:** estorno reduz a fatura; pagamento não cria nova despesa e deve
  ser conciliado como transferência entre conta bancária e cartão.
- **FAT-06:** o Resumo pode alternar leitura por mês-calendário e por mês da
  fatura, deixando o critério visível.
- **FAT-07:** compras parceladas exibem parcela atual, total de parcelas e
  projeção nas faturas seguintes sem duplicar a compra principal.

### 4.7 Zerar o aplicativo

- **RST-01:** Ajustes deve expor uma área de perigo clara para apagar tudo e
  começar do zero.
- **RST-02:** antes da exclusão, mostrar contagens, oferecer backup e exigir
  confirmação forte (texto `ZERAR`).
- **RST-03:** apagar o banco Drift completo, staging/importações, conflitos e
  cursores de sync, outbox, fila SQLite nativa de notificações, preferências e
  sessão armazenada no aparelho.
- **RST-04:** permissões concedidas pelo Android não são revogadas pelo app; a
  confirmação deve explicar isso.
- **RST-05:** após concluir, fechar estados transitórios e retornar ao
  onboarding sem dados de demonstração.

### 4.8 Backup, captura e sync

- **BCS-01:** backup continua versionado, validado antes da restauração e
  restaurado transacionalmente.
- **BCS-02:** captura de notificações mantém allowlist explícita, parsing local
  e diagnóstico de permissão/fila sem sucesso simulado.
- **BCS-03:** sync e login são opcionais; falha de rede nunca bloqueia o uso
  local.
- **BCS-04:** exclusão, restauração e resolução de conflito precisam deixar o
  resultado e a possibilidade de recuperação claros.

## 5. Requisitos não funcionais

- **NFR-01 — tamanhos:** validar 360×800 e 390×844, incluindo escala de texto
  de 1,3 e nomes/valores longos.
- **NFR-02 — toque:** controles interativos com alvo mínimo de 48×48 dp.
- **NFR-03 — contraste:** texto pequeno com contraste mínimo de 4,5:1.
- **NFR-04 — semântica:** ícones acionáveis têm rótulo acessível; valores não
  dependem apenas de cor.
- **NFR-05 — estabilidade:** nenhum `RenderFlex overflow`, CTA encoberto pelo
  teclado ou snackbar persistente entre destinos.
- **NFR-06 — integridade:** migrações Drift e restaurações são testadas com
  dados existentes; nenhuma etapa de redesign pode apagar dados.
- **NFR-07 — desempenho:** listas financeiras usam renderização preguiçosa e
  não repetem resumos pesados a cada linha.
- **NFR-08 — qualidade:** cada fase termina com `flutter analyze`,
  `flutter test`, testes proporcionais ao risco e build Android reproduzível.

## 6. Fora de escopo deste ciclo

- integração online com Open Finance ou scraping bancário;
- uso comercial multi-tenant ou publicação em loja;
- cópia de código React/Tailwind do protótipo;
- logos de bancos sem licença;
- confirmação automática de classificação financeira incerta;
- iOS com captura de notificações de terceiros.

## 7. Referências de domínio e qualidade

- [OFX Banking Specification 2.3 — Financial Data Exchange](https://financialdataexchange.org/common/Uploaded%20files/OFX%20files/OFX%20Banking%20Specification%20v2.3.pdf): separação entre conta bancária e conta de cartão e uso de `ACCTID`.
- [Data de fechamento e vencimento — Nubank](https://blog.nubank.com.br/data-de-vencimento-data-fechamento-cartao-de-credito/): comportamento divulgado para fechamento e compras posteriores ao corte.
- [Open Finance Brasil — API Cartão de Crédito](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/310607893): referência conceitual para contas de cartão, faturas e transações de fatura; não implica integração online.
- [Android Core App Quality](https://developer.android.com/docs/quality-guidelines/archive/core/core-app-quality-2026-03-20?hl=en) e [acessibilidade em Views](https://developer.android.com/guide/topics/ui/accessibility/views/apps-views?hl=en): alvos de toque, contraste, descrições e validação de telas.
