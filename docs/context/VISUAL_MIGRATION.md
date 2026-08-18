# ZimbaControl — Baseline de migracao visual

## Referencia fixa

- Laboratorio visual: `/Users/macbookair/Public/dev/pixel-perfect-pixels`.
- Commit aprovado para este ciclo: `2848fc6` (`Redesenhou telas e componentes`).
- O React/Tailwind nunca deve ser copiado para o monorepo. A referencia e
  traduzida em widgets Flutter ligados a dados reais do Drift.

## Contrato visual

| Item | Regra Flutter |
| --- | --- |
| Largura | Android usa a largura do aparelho; preview web centraliza em 440 px. |
| Grade | Espacamentos em multiplos de 4 px; margem de pagina de 16 px. |
| Superficies | Fundo `#F7F8FA`, card branco, borda `#E5E7EB`, sombra discreta. |
| Raios | 12 px em controles e 16 px em cards/listas. |
| Tipografia | Inter; titulos densos, texto auxiliar 12 px e valores com leitura tabular. |
| Navegacao | Resumo, Revisao, Novo, Movim. e Ajustes, fixa na parte inferior. |
| Estados | Vazio, carregando, erro e revisao manual usam componentes compartilhados. |

## Matriz de migracao

| Jornada Lovable | Flutter | Situacao |
| --- | --- | --- |
| Resumo | `dashboard_page.dart` | Dados reais; usa a nova moldura e tokens. |
| Caixa de Revisao | `review_page.dart` | Dados e acoes reais; card e acoes compactadas no padrao aprovado. |
| Movimentacoes | `movements_page.dart` | Fluxo real; refinamento visual incremental. |
| Novo / Edicao | `new_transaction_page.dart`, `edit_transaction_page.dart` | Fluxo real; rateio avancado permanece pendente. |
| Importacao / Duplicidades | `import_page.dart`, `duplicates_page.dart` | Parser, staging e conciliacao reais; acabamento incremental. |
| Familia / cadastros / compromissos | `family_structure_page.dart`, `registries_page.dart`, `commitments_page.dart` | Fluxos reais; agrupamento em Ajustes permanece em migracao. |
| Backup / captura Android | `family_structure_page.dart` | Funcional, a ser separado em jornadas visuais proprias. |
| Regras | `feature_availability_page.dart` | UI honesta criada; dominio persistente pendente. |
| Sync e privacidade | `feature_availability_page.dart` | UI honesta criada; Marco 11C pendente. |

## Lacunas que nao podem ser simuladas

1. Regras persistentes: prioridade, padrao, ativacao, historico e explicacao.
2. Rateio avancado, fontes editaveis e vinculo de regras/parcelas na edicao.
3. Sync 11C: `deviceId`, aplicacao de eventos remotos no Drift e conflitos em
   revisao.
4. Estados finais da captura Android: expurgo, erros de permissao e allowlist
   administravel.

## Validacao por marco

Cada tela deve ser verificada em 360x800 e 390x844, com escala de texto 1.3.
Nao aprovar cortes de texto, overflow, acoes falsas ou divergencias de
hierarquia que alterem a leitura da referencia.
