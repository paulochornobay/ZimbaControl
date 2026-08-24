# ZimbaControl — Auditoria canônica de paridade visual

**Data:** 2026-08-23

**Protótipo auditado:** `C:\dev\pixel-perfect-pixels@2848fc6`

**Aplicativo auditado:** `C:\dev\ZimbaControl@cd67fcb`

**Escopo:** todas as rotas publicadas pelo protótipo e jornadas adicionais do Flutter

## 1. Resultado executivo

O app Flutter preserva mais comportamento financeiro real que o protótipo e as
Fases 1–5 eliminaram as divergências críticas de Movimentações, confirmação,
descrição, identidade de instrumentos, classificações, reset, importação,
faturas e hierarquia do Resumo. Todas as rotas ficaram equivalentes ou possuem
uma diferença deliberada registrada. Resta somente a homologação Android
física da candidata assinada.

A próxima etapa não é uma troca de tecnologia nem uma cópia do React. É a
tradução sistemática da hierarquia visual do protótipo para widgets Flutter,
mantendo Drift, parsers e ações reais.

### Atualização de implementação — 2026-08-23

As Fases 1, 2 e 3 resolveram localmente os itens 6.1 a 6.6:
navegação e Movimentações compactas, snackbar temporário, detalhe com título
amigável, instrumentos identificáveis, classificações visuais e reset
coordenado. Seis goldens cobrem Revisão, Movimentações e Detalhe em 360×800 e
390×844; testes adicionais cobrem criação inline, migração/backup e todos os
stores do reset. A Importação agora preserva identidade do demonstrativo,
confirma o destino e bloqueia ambiguidade; o item 6.7 permanece no roadmap, e
a Fase 4 resolveu o item 6.7. Na Fase 5, o Resumo foi recomposto, 13 jornadas
foram exercitadas em dois viewports e Resumo/Ajustes/Família receberam goldens.
A homologação Android integral continua pendente apenas porque o ADB não
enumerou o aparelho no fechamento.

## 2. Evidências e limites da auditoria

- As 12 telas do protótipo foram percorridas em `http://localhost:8080/` e
  conferidas também no DOM e nos arquivos de `src/routes`.
- A rota `/review` apenas redireciona para `/`; não é uma 13ª tela.
- O Flutter foi comparado por código, estados disponíveis e capturas fornecidas
  durante a auditoria.
- O protótipo estava com alterações locais preexistentes em
  `src/routeTree.gen.ts` e `package-lock.json`. Nada foi alterado ou publicado
  no repositório de referência.
- Nenhuma captura com dados pessoais integra esta documentação. Novos
  screenshots de homologação devem usar dados demonstrativos anonimizados.
- A validação física ficou pendente: em 2026-08-23 o ADB não enumerou nenhum
  aparelho, mesmo após reiniciar o servidor. Isso não invalida as diferenças
  estruturais encontradas, mas impede declarar homologação Android concluída.

## 3. Contrato visual observado

| Elemento | Regra de referência |
| --- | --- |
| Moldura | largura total no Android; preview web centralizado, máximo de 440 px |
| Fundo e texto | fundo `#F7F8FA`, texto principal próximo de `#0F172A`, superfícies brancas |
| Grade | múltiplos de 4 px; margem horizontal usual de 16 px |
| Cabeçalho | compacto, título de aproximadamente 19 px, subtítulo de 12 px e ação contextual |
| Superfícies | borda discreta, sombra curta e raio coerente; listas densas podem compartilhar uma superfície |
| Controles | raio de 12 px; cards e sheets entre 16 e 28 px conforme hierarquia |
| Tipografia | Inter, valores com peso e alinhamento que facilitem varredura |
| Navegação | Resumo, Revisão, Novo, Movim. e Ajustes; ícone e rótulo sempre coerentes |
| Ícones | traço consistente, tamanho visual uniforme e significado acompanhado por texto/semântica |
| Estados | vazio, carregamento, erro, sucesso e indisponibilidade reais, sem conteúdo fictício |

O aceite de medidas será feito por overlay nos viewports 360×800 e 390×844.
Para componentes estáveis, a tolerância visual é de aproximadamente 2 dp;
diferenças deliberadas exigem registro.

## 4. Inventário completo das telas do protótipo

| Rota | Jornada Flutter | Resultado da Fase 5 | Classificação |
| --- | --- | --- | --- |
| `/` | `review_page.dart` | composição compacta, ações Drift e confirmação temporária | equivalente |
| `/summary` | `dashboard_page.dart` | hierarquia mensal, blocos densos, leituras e origens reais | equivalente |
| `/transaction/new` | `new_transaction_page.dart` | criação real, instrumento inequívoco e classificação inline | equivalente |
| `/transaction/$id` | `edit_transaction_page.dart` | leitura separada da edição e texto original imutável | equivalente |
| `/movimentacoes` | `movements_page.dart` | busca/chips compactos, filtros em sheet e lista densa | equivalente |
| `/settings` | `settings_home_page.dart` | hub compacto preservando todos os estados reais | equivalente |
| `/family` | `family_structure_page.dart` | informações reais agrupadas no mesmo sistema visual | equivalente |
| `/backup` | `BackupSettingsPage` | exportação/restauração local, sem nuvem automática fictícia | diferença deliberada |
| `/rules` | `RulesPreviewPage` | CRUD existente e indisponibilidades explicadas | diferença deliberada |
| `/sync-privacy` | `SyncPrivacyPreviewPage` | estado real de fila/sessão; não promete sync quando desligado | diferença deliberada |
| `/import` | `import_page.dart` | etapas reais com identidade, destino, prévia e histórico | equivalente |
| `/duplicates` | `duplicates_page.dart` | comparação e decisões ligadas à conciliação real | equivalente |

### Redirecionamento

`/review` redireciona para `/`. No Flutter, “Revisão” deve continuar abrindo a
fila real, sem criar uma tela duplicada apenas para reproduzir a URL.

## 5. Jornadas que existem apenas no Flutter

Estas telas não têm rota equivalente no protótipo e precisam adotar o mesmo
sistema visual sem inventar uma referência inexistente:

| Jornada | Implementação atual | Diretriz |
| --- | --- | --- |
| Onboarding | `onboarding_page.dart` | instalação limpa, sem seed; cadastro inicial real ou demo explícita |
| Cadastros | `registries_page.dart` | separar contas, cartões, categorias e centros com ícones e estados claros |
| Compromissos | `commitments_page.dart` | preservar recorrências e parcelas reais; usar cards responsivos e CTAs acessíveis |
| Captura Android | `NotificationSettingsPage` | mostrar permissão, allowlist, fila e erro reais; sem equivalência web fictícia |
| Dados locais/reset | `DataEnvironmentPage` | entregue na Fase 2; homologar backup, teclado e reset em Android físico |

## 6. Defeitos comprovados e causa técnica

### 6.1 Movimentações e navegação

- `ZimbaBottomNavigation` rotula o quarto destino como “Filtros”; o protótipo e
  a arquitetura canônica o definem como “Movim.”.
- `MovementsPage` insere `MovementFilterPanel` e `MovementTotalsCard` antes da
  lista. Isso explica o painel alto e o resumo repetido das capturas atuais.
- A fonte oficial usa busca compacta, chips horizontais e filtros avançados em
  bottom sheet, seguidos imediatamente pela lista densa.

### 6.2 Confirmação que não desaparece

`review_page.dart` cria um `SnackBar` com ação “Desfazer” sem definir
explicitamente persistência. Na versão atual do Flutter, snackbars com ação
podem persistir. O comportamento esperado é duração explícita,
`persist: false`, fechamento acessível e descarte ao mudar de jornada.

### 6.3 Conta e cartão indistinguíveis

`new_transaction_page.dart` mostra `item.account.name` nos chips. Embora o
banco armazene provedor, tipo, titular e últimos quatro dígitos, a seleção não
usa esses dados. Categorias e centros também possuem apenas nome no modelo
atual, sem chave de ícone ou cor.

**Resolvido na Fase 2:** `InstrumentDisplay` apresenta nome, provedor, tipo,
titular e últimos dígitos; categorias e centros persistem `iconKey` e
`colorKey`, com fallback, sugestão e seletor vetorial.

### 6.4 OFX associado pelo banco, não pelo instrumento

O parser atual percorre `STMTTRN`, lê data, valor, `NAME`, `MEMO` e `FITID`, mas
não preserva `BANKACCTFROM`, `CCACCTFROM` ou `ACCTID`. Depois, a promoção chama
`_accountForProvider`, que retorna a primeira conta ativa daquele provedor.
Com conta corrente e cartão Nubank cadastrados, a escolha pode ser ambígua ou
incorreta e os detalhes do cartão desaparecem do lote.

**Resolvido na Fase 3:** o parser preserva `BANKACCTFROM`, `CCACCTFROM`,
`ACCTID`, moeda, período e saldos; o lote exige `targetAccountId` confirmado e
a promoção/conciliação não consulta mais a primeira conta ou cartão. Empates,
tipo/final incompatíveis e identificador ausente permanecem bloqueados até a
escolha explícita.

### 6.5 Descrição sem semântica clara

`Transactions` possui apenas `descriptionRaw`, e o formulário de edição o usa
como texto editável. O requisito aprovado é separar um título amigável
editável da descrição original somente leitura.

### 6.6 Reset escondido e incompleto

“Apagar dados locais” já existe em Ajustes > Dados locais, porém é pouco
encontrável. `clearLocalData()` não remove atualmente `syncAppliedEvents` nem
`syncConflicts` e não coordena a fila SQLite nativa, preferências fora do Drift
ou sessão segura. Portanto, não equivale ainda a “começar do zero”.

**Resolvido na Fase 2:** a área de perigo ficou visível em Dados locais, exige
`ZERAR`, oferece backup, mostra contagens e coordena Drift, staging, sync, fila
nativa, preferências e sessão antes do retorno ao onboarding. A tela explica
que permissões concedidas pelo Android permanecem.

### 6.7 Fatura sem entidade própria

Cartões já armazenam dia de fechamento e vencimento e há helpers de cálculo de
mês/vencimento. Não existe, porém, entidade de fatura, pagamento, estado ou
tela de consolidação. O helper atual não substitui uma fatura auditável e não
cobre sozinho corte, estorno, pagamento parcial e correção manual.

**Modelo resolvido na Fase 4A:** Drift 14 passou a persistir fatura, pagamento,
estado derivado, vínculo da transação e auditoria de correções.

**Visão resolvida na Fase 4B:** o Flutter mostra consolidação, compras,
estornos, pagamentos e filtros em dois viewports.

**Conciliação resolvida na Fase 4C:** OFX bancário pode sugerir pagamento, OFX
de cartão alimenta compras e parcelas futuras aparecem apenas como projeção.
Toda efetivação exige confirmação. O protótipo vigente não oferece uma rota
completa de fatura para comparação direta, portanto esta tela é uma diferença
deliberada baseada no design system canônico.

## 7. Critérios de paridade

Uma tela só pode ser marcada como equivalente quando:

1. preserva todas as ações reais e não introduz ação mockada;
2. mantém hierarquia, densidade, espaçamento, tipografia e iconografia do
   baseline nos dois viewports;
3. funciona com vazio, carregamento, erro, nomes longos, valores grandes e
   escala de texto 1,3;
4. possui alvos de 48 dp e semântica para TalkBack;
5. não causa overflow, CTA encoberto ou feedback persistente entre telas;
6. foi comparada por screenshot/overlay e, no fechamento, em Android físico.
