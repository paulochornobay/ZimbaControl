# ZimbaControl - Lovable Screen Factory

## Papel do Lovable

O projeto Lovable e o laboratorio visual. Ele deve gerar e refinar 100% das
telas antes de serem implementadas no Flutter final.

As telas Flutter criadas antes do Lovable devem ser vistas como funcionais e
temporarias. Elas existem para validar dados, fluxos e contratos; o acabamento
de produto vem depois que a tela correspondente estiver boa no Lovable.

O Lovable nao e o app final porque:

- captura de notificacoes bancarias exige Android nativo;
- o nucleo offline-first precisa Drift/SQLite;
- o documento de arquitetura recomenda Flutter para o app mobile final.

Usar o Lovable tela por tela. Ele sera usado para revisao, cadastros
familiares, importacao, painel e backup. Captura Android, banco, parsers, sync
e seguranca devem ser implementados diretamente no app final.

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

Novo download analisado:

```text
/Users/macbookair/Public/dev/pixel-perfect-pixels
```

Esse download e a referencia mais recente para Caixa de Revisao, edicao,
duplicidades e parcelas. Ainda e mock visual. A tentativa final de refinamento
da Caixa de Revisao com pouco credito nao concluiu o prompt; use o Flutter como
fonte funcional do Marco 04 e Lovable apenas para proximas telas.

## Rotas Existentes no Zip

- `/`: no novo download esta como Caixa de Revisao.
- `/review`: redireciona para `/` no novo download.
- `/transaction/new`: novo lancamento manual.
- `/transaction/$id`: detalhe/edicao de lancamento.
- `/import`: importacao CSV/OFX.
- `/duplicates`: resolucao de duplicidades.
- `/installments`: parcelamento.
- `/filters`: filtros.
- `/settings`: ajustes, notificacoes e dados.

Navegacao alvo apos o refinamento:

- `Resumo`: dashboard familiar operacional.
- `Revisao`: Caixa de Revisao.
- `Novo`: lancamento manual.
- `Movimentacoes`: lista, busca e filtros.
- `Ajustes`: dados, privacidade, notificacoes e backup.

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

Refine a Caixa de Revisao existente do ZimbaControl sem criar landing page.

O app e de uso pessoal para controle financeiro familiar e precisa ser rapido,
sobrio e sem elementos decorativos desnecessarios.

Corrija estes pontos:

- em telas de 360 a 440 px nenhum texto ou botao pode ficar cortado;
- os cards devem ser mais compactos para revisar 20 a 30 itens;
- manter merchant, descricao original, valor, data, origem, conta, categoria,
  centro de custo, beneficiarios e confianca;
- mostrar avisos de baixa confianca, duplicidade, parcela e transferencia;
- Confirmar deve ser a acao principal;
- Editar deve permanecer visivel;
- Duplicado, Transferencia e Ignorar podem usar icones com tooltip ou menu;
- remover a acao "Tudo ok", pois nao e seguro confirmar tudo sem revisao;
- incluir feedback apos confirmar e opcao de desfazer;
- criar estados vazio, carregando e erro;
- preservar a identidade visual atual.

A navegacao inferior deve ser:

Resumo, Revisao, Novo, Movimentacoes e Ajustes.

A rota Resumo sera o dashboard familiar.
A rota Revisao sera exclusivamente a Caixa de Revisao.
Filtros devem ficar dentro de Movimentacoes, nao como item principal.

Nao implemente backend nem autenticacao. Use dados mockados realistas e
mantenha o projeto como prototipo visual para posterior traducao para Flutter.

### Edicao de Lancamento

Crie a tela de edicao completa com tipo, valor, data, competencia, conta/cartao,
pagador, beneficiarios, categoria, centro de custo, merchant, parcelamento,
tags, observacao, fontes e opcao de criar regra futura. Incluir modo simples e
modo avancado de rateio.

### Importacao CSV/OFX

Crie o fluxo de importacao com escolher arquivo, detectar banco/provedor,
previa do lote, resumo de validos/invalidos/novos/duplicados/conciliados,
mapeamento manual de colunas e revisao de conflitos.

### Estrutura Familiar

Crie as telas de cadastros familiares do ZimbaControl para pessoas, contas,
cartoes, recorrencias e compromissos. Incluir proprietario de contas/cartoes,
escola do filho como recorrencia, pensao destinada a filha, ajuda mensal entre
familiares, consorcio do carro e transferencias internas. Manter fluxo simples
e sem dashboard decorativo.

Prompt recomendado para o Marco 05:

```text
Crie as telas de Estrutura Familiar do ZimbaControl sem landing page.

Contexto:
- app pessoal de controle financeiro familiar;
- Lovable e apenas prototipo visual;
- app final sera Flutter offline-first;
- nao criar backend, login, MongoDB nem integracoes reais.

Telas/fluxos necessarios:
- Pessoas da familia: adultos, filhos e outros beneficiarios;
- Contas: banco, nome, tipo, proprietario, ativo/inativo;
- Cartoes: banco, bandeira, ultimos digitos, proprietario, dia de fechamento e vencimento;
- Recorrencias: escola, pensao, ajuda familiar, despesas fixas;
- Compromissos parcelados: consorcio do carro separado de parcelas de cartao;
- Transferencia interna: dinheiro entre marido e esposa quando ambas as contas existem.

Regras de UX:
- visual sobrio, compacto e utilitario;
- mobile-first 360 a 440 px sem texto cortado;
- cadastros com listas compactas e formularios claros;
- usar tabs ou segmentacao para Pessoas, Contas, Cartoes, Recorrencias e Compromissos;
- mostrar estados vazio, carregando, erro e preenchido;
- incluir exemplos mockados realistas: escola do filho, pensao da filha, consorcio do carro e ajuda mensal;
- nao usar graficos decorativos.

Objetivo:
validar a organizacao visual para depois traduzir para Flutter.
```

### Painel e Movimentacoes

Crie o painel operacional do mes e a tela de movimentacoes. O painel deve
responder quanto entrou, quanto saiu, saldo, compromissos futuros, pendencias
de revisao e projecoes simples de escola, consorcio, pensao e parcelas. A tela
de movimentacoes deve ter busca, filtros por pessoa/categoria/centro de custo
e lista compacta.

### Backup

Crie o fluxo de backup e recuperacao local com exportar arquivo versionado,
validar restauracao antes de substituir dados, exportar CSV para consulta
externa e compartilhar pelo Android. Mostrar estados de sucesso, erro e
confirmacao de risco antes de restaurar.

### Regras

Crie a tela de gerenciamento de regras com prioridade, ativo/inativo,
padrao de match, sugestao aplicada, contador de uso e explicacao de confianca.

### Sync e Privacidade

Crie uma tela de status de sync e privacidade mostrando offline/online,
operacoes pendentes, ultimo sync, dispositivos, expurgo de payload bruto e
configuracao de captura de notificacoes.
