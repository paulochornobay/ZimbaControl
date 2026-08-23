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
e a separação entre título amigável e descrição original. Há goldens de
Revisão, Movimentações e Detalhe nos dois viewports de referência.

As maiores lacunas restantes são:

1. contas e cartões indistinguíveis nos seletores;
2. categoria/centro sem ícone padrão e sem criação inline;
3. OFX sem identidade do demonstrativo e sem confirmação do instrumento;
4. reset escondido/incompleto;
5. ausência de fatura como entidade.

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
