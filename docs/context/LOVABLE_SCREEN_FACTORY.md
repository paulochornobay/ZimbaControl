# ZimbaControl - Lovable Screen Factory

## Papel do Lovable

O projeto Lovable e o laboratorio visual. Ele deve gerar e refinar 100% das
telas antes de serem implementadas no Flutter final.

O Lovable nao e o app final porque:

- captura de notificacoes bancarias exige Android nativo;
- o nucleo offline-first precisa Drift/SQLite;
- o documento de arquitetura recomenda Flutter para o app mobile final.

## Local do Prototipo

O prototipo fica em:

```text
prototypes/lovable
```

Ele deve permanecer separado de:

```text
apps/mobile
apps/api
packages/contracts
```

## Rotas Existentes no Zip

- `/`: dashboard familiar.
- `/review`: caixa de revisao.
- `/transaction/new`: novo lancamento manual.
- `/transaction/$id`: detalhe/edicao de lancamento.
- `/import`: importacao CSV/OFX.
- `/duplicates`: resolucao de duplicidades.
- `/installments`: parcelamento.
- `/filters`: filtros.
- `/settings`: ajustes, notificacoes e dados.

## Traducao Visual para Flutter

Preservar:

- layout mobile-first com largura max aproximada de 440px no prototipo;
- estilo clean fintech, superficies claras, bordas sutis e tipografia densa;
- navegacao inferior com 5 acoes principais;
- cards compactos para itens repetidos;
- chips de beneficiarios e badges de status;
- acoes rapidas por icones quando possivel.

Adaptar no Flutter:

- React routes viram telas em `presentation`.
- Componentes `zc` viram widgets compartilhados.
- `mock-data.ts` vira seed local Drift.
- Tailwind tokens viram `ThemeData` e constantes de design.

## Prompt Base para Lovable

Use este formato:

```text
Crie/refine a tela [nome] do ZimbaControl.
Contexto: app familiar de financas offline-first. Lovable e apenas prototipo
visual; o app final sera Flutter. Estilo: mobile-first, clean fintech, iOS/
MacBook-inspired, cards compactos, tipografia Inter/SF Pro, fundo cinza-claro,
chips para beneficiarios e badges de status.

Requisitos funcionais:
- [lista objetiva]

Estados obrigatorios:
- vazio
- carregando
- com dados
- erro/revisao manual quando aplicavel

Nao criar landing page. A primeira tela deve ser a experiencia usavel.
```

## Prompts Prontos

### Dashboard Familiar

Crie a tela "Dashboard Familiar" do ZimbaControl com saldo do mes, receitas,
despesas, revisao pendente, gastos por pessoa, centros de custo e proximas
parcelas. Visual premium, sem excesso de graficos, com foco em leitura rapida.

### Caixa de Revisao

Crie a tela mais importante do app: "Caixa de Revisao". Cada item deve mostrar
merchant normalizado, descricao original, valor, data, origem, categoria
sugerida, centro de custo, beneficiarios sugeridos, confianca, risco de
duplicidade, indicador de parcela e acoes Confirmar, Editar, Duplicado e
Transferencia.

### Edicao de Lancamento

Crie a tela de edicao completa com tipo, valor, data, competencia, conta/cartao,
pagador, beneficiarios, categoria, centro de custo, merchant, parcelamento,
tags, observacao, fontes e opcao de criar regra futura. Incluir modo simples e
modo avancado de rateio.

### Importacao CSV/OFX

Crie o fluxo de importacao com escolher arquivo, detectar banco/provedor,
previa do lote, resumo de validos/invalidos/novos/duplicados/conciliados,
mapeamento manual de colunas e revisao de conflitos.

### Regras

Crie a tela de gerenciamento de regras com prioridade, ativo/inativo,
padrao de match, sugestao aplicada, contador de uso e explicacao de confianca.

### Sync e Privacidade

Crie uma tela de status de sync e privacidade mostrando offline/online,
operacoes pendentes, ultimo sync, dispositivos, expurgo de payload bruto e
configuracao de captura de notificacoes.
