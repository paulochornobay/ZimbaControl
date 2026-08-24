# ZimbaControl — Migração visual

> Resumo operacional. A matriz completa e as evidências estão em
> `docs/product/VISUAL_PARITY_AUDIT.md`; requisitos e ordem de implementação
> estão em `docs/product/PRODUCT_REQUIREMENTS.md` e
> `docs/product/IMPLEMENTATION_ROADMAP.md`.

## Referência vigente

- Laboratório visual: `C:\dev\pixel-perfect-pixels`.
- Baseline canônico: `2848fc6` (`Redesenhou telas e componentes`).
- Baseline do app auditado: `ZimbaControl@cd67fcb`.
- O React/Tailwind é apenas referência; widgets Flutter continuam ligados a
  dados e ações reais do Drift.
- O repositório visual possuía alterações locais preexistentes em
  `src/routeTree.gen.ts` e `package-lock.json`; elas não fazem parte desta
  migração.

## Situação

A Fase 1 corrigiu Movimentações, o destino “Movim.”, o feedback de confirmação
e a separação entre título amigável e descrição original. A Fase 2 adicionou
identidade inequívoca de contas/cartões, ícones e cores em classificações,
criação inline e a área segura para zerar o app. Os goldens de Movimentações e
Detalhe foram atualizados para a nova identidade nos dois viewports. A Fase 3
traduziu o stepper de Importação para etapas reais e acrescentou identificação,
confirmação de destino, prévia e histórico ligados ao Drift.
O domínio da Fase 4A calcula ciclos, totais, pagamentos e estados auditáveis; a
Fase 4B agora os apresenta em uma tela Flutter real, pois o protótipo não possui
rota equivalente de fatura. A Fase 4C concluiu a conciliação confirmável de
pagamentos OFX e a projeção de parcelas sem criar despesas futuras.

A Fase 5 recompôs o Resumo conforme a hierarquia mensal do protótipo e validou
as jornadas restantes nos dois viewports. Ajustes, Família e Resumo possuem
goldens próprios; telas sem rota React equivalente preservam o mesmo sistema
visual e registram sua diferença deliberada. A release final usa assinatura
pessoal própria e configurações Android de privacidade revisadas.

A única lacuna restante é a homologação integral em Android físico. Ela exige
backup dos dados atuais antes da troca do APK anterior, assinado com chave de
debug, pela candidata `1.2.0+3` assinada pessoalmente.

## Contrato resumido

| Item | Regra |
| --- | --- |
| Largura | Android usa a largura do aparelho; preview web centraliza em 440 px |
| Grade | múltiplos de 4 px; margem de página usual de 16 px |
| Superfícies | fundo `#F7F8FA`, card branco, borda/sombra discretas |
| Tipografia | Inter, títulos compactos, auxiliares de 12 px, valores legíveis |
| Navegação | Resumo, Revisão, Novo, Movim. e Ajustes |
| Filtros | rápidos na tela; avançados em bottom sheet |
| Estados | vazio, carregando, erro e sucesso baseados em estado real |
| Acessibilidade | alvos de 48 dp, contraste e semântica de ícones |

## Validação

Cada jornada deve ser verificada em 360×800 e 390×844, com escala de texto
1,3, nomes e valores longos. A comparação usa screenshot/overlay e registra
diferenças deliberadas. Homologação final exige Android físico; capturas com
dados pessoais não devem ser commitadas.
