# ZimbaControl - Milestones

## Status Geral

- Marco 00 - Bussola do Projeto: concluido
- Marco 01 - Cofre Visual Lovable: concluido
- Marco 02 - Fundacao do Monorepo: concluido
- Marco 03 - Nucleo Local Offline: iniciado
- Marco 04 - Caixa de Revisao: planejado
- Marco 05 - Importacao CSV/OFX: planejado
- Marco 06 - Deduplicacao, Parcelas e Faturas: planejado
- Marco 07 - Captura Android: planejado
- Marco 08 - Sync Cloud Gratuito: planejado
- Marco 09 - Seguranca e Publicacao: planejado

## Marco 00 - Bussola do Projeto

Entregaveis:

- `docs/context/PROJECT_BRIEF.md`
- `docs/context/MILESTONES.md`
- `docs/context/CURRENT_STATE.md`
- `docs/context/ARCHITECTURE.md`
- `docs/context/LOVABLE_SCREEN_FACTORY.md`

Criterio de aceite:

- Um novo ciclo consegue recomecar lendo apenas os arquivos de contexto.

Status: concluido.

## Marco 01 - Cofre Visual Lovable

Entregaveis:

- Protótipo Lovable extraido em `prototypes/lovable`.
- Inventario das rotas e componentes existentes.
- Guia de prompts e traducao visual para Flutter.

Criterio de aceite:

- O prototipo roda localmente e esta claramente separado do app final.

Status: concluido. Prototipo extraido em `prototypes/lovable`.

## Marco 02 - Fundacao do Monorepo

Entregaveis:

- `apps/mobile` com Flutter.
- `apps/api` com Node.js/TypeScript/Fastify.
- `packages/contracts` com OpenAPI e schemas.
- Scripts e README de desenvolvimento local.

Criterio de aceite:

- Mobile e backend sobem localmente com comandos documentados.

Status: concluido. Mobile Flutter, API Fastify e contratos foram criados.

## Marco 03 - Nucleo Local Offline

Entregaveis:

- Drift + SQLite com tabelas principais.
- Entidades de dominio e repositorios locais.
- Seeds pessoais iniciais.
- Streams para dashboard e caixa de revisao.

Criterio de aceite:

- Criar, editar, listar e revisar lancamentos sem internet.

Status: iniciado. Ja existe banco Drift local com seeds, dashboard inicial,
criacao de rascunho manual e confirmacao simples com outbox.

## Marco 04 - Caixa de Revisao

Entregaveis:

- Tela de revisao rapida.
- Acoes: confirmar, editar, ignorar, duplicado, transferencia.
- Sugestoes explicaveis com confianca.

Criterio de aceite:

- Revisar 20 a 30 itens seguidos com poucos toques e baixa fadiga.

## Marco 05 - Importacao CSV/OFX

Entregaveis:

- Staging de arquivos com hash.
- Adapters Nubank e Mercado Pago.
- Resumo de lote e mapeamento manual de CSV.

Criterio de aceite:

- Extrato real anonimizado entra sem duplicar lancamentos existentes.

## Marco 06 - Deduplicacao, Parcelas e Faturas

Entregaveis:

- Deduplicacao exata e heuristica.
- Dominio de parcelamento.
- Pagamento de fatura como transferencia.

Criterio de aceite:

- Notificacao + CSV/OFX da mesma compra nao vira gasto duplicado.

## Marco 07 - Captura Android

Entregaveis:

- Plugin Kotlin com `NotificationListenerService`.
- Allowlist de pacotes.
- Captura e persistencia local de eventos brutos.

Criterio de aceite:

- Notificacoes permitidas viram rascunhos na caixa de revisao.

## Marco 08 - Sync Cloud Gratuito

Entregaveis:

- Backend de sync proprio.
- MongoDB Atlas Free/M0.
- Outbox local, idempotencia, `syncEvents` e conflitos revisaveis.

Criterio de aceite:

- Dois dispositivos sincronizam sem duplicar operacoes.

## Marco 09 - Seguranca e Publicacao

Entregaveis:

- Criptografia local quando viavel.
- Secure storage.
- Politica de minimizacao de notificacoes.
- CI e caminho de deploy gratuito/staging.

Criterio de aceite:

- App instalavel, dados sensiveis protegidos e publicacao documentada.
