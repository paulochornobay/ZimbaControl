# ZimbaControl - Project Brief

## Objetivo

Construir um app familiar de financas pessoais, offline-first, para uso pessoal
no Android. O app deve transformar notificacoes, arquivos CSV/OFX e lancamentos
manuais em transacoes financeiras ricas, revisaveis e confiaveis.

## Decisoes Fixas

- O zip Lovable e a fonte visual oficial e fabrica de telas.
- O app final sera Flutter, nao React.
- A captura de notificacoes sera Android-only no MVP, via Kotlin
  `NotificationListenerService`.
- O banco local sera SQLite com Drift.
- O sync sera proprio, via backend Node.js/TypeScript e MongoDB Atlas.
- Nao usar Realm Sync, Atlas Device Sync, Atlas App Services Data API,
  GraphQL API ou HTTPS Endpoints como base de sincronizacao.
- Ferramentas gratis por padrao: Flutter, Android Studio, Node.js, GitHub,
  MongoDB Atlas Free/M0 e deploy gratuito apenas quando couber.

## Produto

A experiencia principal e a caixa de revisao. Todo evento entra como rascunho
local, recebe sugestoes explicaveis e so vira lancamento consolidado apos
confirmacao ou regra confiavel.

Cada transacao deve separar:

- tipo: receita, despesa, transferencia, estorno ou ajuste
- origem: notificacao Android, CSV, OFX, manual ou integracao futura
- instrumento: conta, cartao, PIX, boleto ou debito
- pagador
- beneficiarios multiplos
- categoria e subcategoria
- centro de custo
- competencia
- relacoes: parcela, compra principal, estorno, fatura, duplicata provavel

## Fora de Escopo Inicial

- iOS com leitura de notificacoes de terceiros.
- Open Finance ou integracoes bancarias oficiais.
- SaaS publico com multi-tenant comercial.
- Tempo real antes de um nucleo local confiavel.
- CRDT/OT generico para ledger financeiro.

## Prioridade de Qualidade

Erros silenciosos de reconciliacao financeira sao o maior risco. O app deve
preferir revisao manual a uma classificacao automatica duvidosa.
