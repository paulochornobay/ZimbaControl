# ZimbaControl - Project Brief

## Objetivo

Construir um app familiar de financas pessoais, offline-first, para uso pessoal
no Android. O app deve transformar notificacoes, arquivos CSV/OFX e lancamentos
manuais em transacoes financeiras ricas, revisaveis e confiaveis.

A primeira versao util deve funcionar bem em um unico Android, sem internet,
sem MongoDB e sem login. O nucleo local, importacao, notificacoes,
conciliacao e backup ja existem; sync em nuvem agora entra como caminho
opcional e incremental.

Dados de demonstracao so podem ser carregados por escolha explicita. Uma
instalacao limpa deve abrir o onboarding e permanecer sem dados ficticios.

O app ja possui caminho local de recuperacao: backup JSON versionado e
restauracao sem MongoDB. Sync em nuvem deve continuar opcional e nunca deve
bloquear o uso local.

## Decisoes Fixas

- O projeto externo `/Users/macbookair/Public/dev/pixel-perfect-pixels`
  (`paulochornobay/pixel-perfect-pixels`) e a referencia visual oficial.
- Nenhum codigo React/Lovable deve ser copiado para este monorepo.
- O app final sera Flutter, nao React.
- A captura de notificacoes sera Android-only no MVP, via Kotlin
  `NotificationListenerService`.
- O banco local sera SQLite com Drift.
- O sync sera proprio, via backend Node.js/TypeScript e MongoDB Atlas.
- MongoDB Atlas e `apps/api/.env` sao necessarios apenas para testar o sync
  opcional com persistencia real; sem `.env`, a API usa memoria local.
- Google Sign-In futuro usara OpenID Connect; Gmail API nao sera usada como
  login.
- Nao usar Realm Sync, Atlas Device Sync, Atlas App Services Data API,
  GraphQL API ou HTTPS Endpoints como base de sincronizacao.
- Ferramentas gratis por padrao: Flutter, Android Studio, Node.js, GitHub,
  MongoDB Atlas Free/M0 e deploy gratuito apenas quando couber.

## Produto

A experiencia principal e a caixa de revisao. Todo evento entra como rascunho
local, recebe sugestoes explicaveis e so vira lancamento consolidado apos
confirmacao ou regra confiavel.

No estado atual, regras de alta confianca podem apenas mesclar fontes de uma
mesma movimentacao ja existente. Classificacoes financeiras incertas continuam
indo para a Caixa de Revisao com explicacao.

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

## Cenarios Familiares Prioritarios

O modelo deve conseguir representar estes casos sem distorcer receitas e
despesas:

- contas e cartoes de mais de uma pessoa da familia;
- dinheiro que o marido envia para a esposa como transferencia interna quando
  ambas as contas estiverem cadastradas;
- ajuda familiar mensal como recorrencia;
- escola do filho como despesa recorrente com beneficiario filho;
- pensao recebida para a filha como receita destinada a ela;
- consorcio do carro como compromisso parcelado proprio, separado de compras
  parceladas no cartao;
- fatura de cartao paga por conta bancaria como transferencia, nao como nova
  despesa;
- importacao de extratos Nubank e Mercado Pago sem duplicar notificacoes ou
  lancamentos manuais.
- compra parcelada de cartao ligada a plano de compra, separada do consorcio
  do carro.

## Fora de Escopo Inicial

- iOS com leitura de notificacoes de terceiros.
- Open Finance ou integracoes bancarias oficiais.
- SaaS publico com multi-tenant comercial.
- Tempo real antes de um nucleo local confiavel.
- CRDT/OT generico para ledger financeiro.
- XLSX no primeiro MVP de importacao.
- Sync obrigatorio, login obrigatorio ou dois dispositivos antes do backup
  local.

## Prioridade de Qualidade

Erros silenciosos de reconciliacao financeira sao o maior risco. O app deve
preferir revisao manual a uma classificacao automatica duvidosa.
