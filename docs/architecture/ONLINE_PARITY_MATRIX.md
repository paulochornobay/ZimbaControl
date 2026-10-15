# Matriz de paridade — domínio online

Esta matriz substitui o `AppDatabase` como fonte de capacidades. Todo comando
é autenticado, resolve `accountId` pelo token e é executado no MongoDB.

| Domínio local anterior | Consulta online | Comando online | Persistência Mongo |
| --- | --- | --- | --- |
| Pessoas, contas, categorias e centros | `GET /v1/entities/:type` | `PUT` / `DELETE /v1/entities/:type/:id` | entidades por `accountId` |
| Cartões e grupos de limite | `GET /v1/entities/creditCard*` | `PUT` / `DELETE` | entidades por `accountId` |
| Movimentos e transferências | `GET /v1/entities/transaction` | `PUT` / `DELETE` | movimentos e fontes por `accountId` |
| Revisão e duplicidades | `GET /v1/entities/reviewItem|duplicateCandidate` | `PUT /v1/entities/:type/:id` | fila de revisão por `accountId` |
| Regras e compromissos | `GET /v1/entities/rule` | `PUT` / `DELETE` | regras por `accountId` |
| Faturas e pagamentos | `GET /v1/entities/invoicePayment` | `PUT` / `DELETE` | pagamentos por `accountId` |
| Captura Android | `GET` de revisão derivada | `POST /notification-events/batch`, resolução | `notification_events` por `accountId` |
| Backup, importação e relatórios | `GET /v1/reports/monthly`, `GET /v1/backups/export` | `POST /v1/imports`, `POST /v1/backups/restore` | lotes, revisão, documentos e artefatos por `accountId` |

Não há fallback local: falha de rede deve produzir estado recuperável de
indisponibilidade, sem criar outbox, snapshot, cache persistente ou dados demo.
