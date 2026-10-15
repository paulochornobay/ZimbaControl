# Auditoria de integração da migração MongoDB online — 2026-09-19

## Conclusão

O MongoDB e a API local estão saudáveis. O bloqueio após o login é causado por
uma incompatibilidade de contrato: o atalho `C:\dev\ZimbaStart.bat` abre o
painel Web em `C:\dev\pixel-perfect-pixels`, mas esse painel ainda chama as
rotas removidas da sincronização offline. A API atual rejeita essas rotas com
HTTP `410 legacy_route_removed_use_v1`.

Não há evidência de que o processo esteja tentando encontrar MongoDB local ou
uma base SQLite inexistente. O texto de "base local" provavelmente vem de uma
tela/instalação legada; o atalho não inicia o Flutter nem instala uma APK.

## Evidências coletadas

| Verificação | Resultado |
| --- | --- |
| `GET http://127.0.0.1:3333/health` | `200`, `storage: mongodb` |
| Conexão da API com Atlas | conexões TCP estabelecidas com a porta `27017` |
| API (`npm run check --workspace @zimbacontrol/api`) | build e 5 testes aprovados |
| Flutter (`flutter analyze`) | nenhum problema encontrado |
| Painel aberto pelo BAT | `http://127.0.0.1:8080`, projeto `pixel-perfect-pixels` |
| Chamadas feitas por esse painel | `/data/entities`, `/sync/status`, `/sync/push` |
| Resposta das três chamadas no servidor ativo | HTTP `410` |
| Dispositivo ADB no momento da auditoria | nenhum conectado |

O `410` é intencional: `apps/api/test/online-api.test.ts` exige que as rotas
legadas estejam indisponíveis. A correção, portanto, não é reativá-las nem
criar fallback local.

## Causa raiz

O corte para "MongoDB only, sempre online" foi concluído no servidor e no
cliente Flutter atual, mas não no painel Web que o `ZimbaStart.bat` inicia.

| Camada | Contrato atual | Estado encontrado |
| --- | --- | --- |
| API | `/v1/bootstrap`, `/v1/entities/:entityType`, `PUT`/`DELETE /v1/entities/:entityType/:entityId` | correto; as rotas antigas respondem `410` |
| Flutter | usa `OnlineFinanceClient` e as rotas `/v1/*`; não abre `AppDatabase` no `main.dart` | alinhado em nível de contrato |
| Painel Web aberto pelo BAT | ainda monta `householdId`, `deviceId` e `operations` para `/sync/push` e consulta `/data/entities` | incompatível; toda leitura e escrita financeira falha |
| BAT | inicia API e Vite do painel Web, faz `adb reverse`; não executa `flutter run`, build nem instalação | pode deixar uma APK antiga em uso |

Como as telas Web tratam parte das falhas apenas limpando dados ou mantendo um
estado de carregamento, o `410` não aparece como diagnóstico útil para quem
acabou de entrar.

## Correções necessárias, em ordem

## Execução desta correção

Concluído em 2026-09-19:

1. O cliente do painel Web foi migrado de `/data/entities` e `/sync/push` para
   `GET`/`PUT`/`DELETE /v1/entities/*`. A consulta de conectividade agora usa
   `GET /v1/bootstrap`, e a tela correspondente passou a informar o estado
   online real, sem sequência, dispositivos ou fila offline fictícios.
2. `C:\dev\ZimbaStart.bat` agora chama `tools/start-local.ps1`. O iniciador
   espera a API com MongoDB e o painel Web ficarem prontos, mostra falhas no
   terminal e só configura `adb reverse` quando há Android conectado.
3. A validação compilou o painel Web e exercitou login, bootstrap e listagem
   contra a API local ativa. As rotas antigas não são mais referenciadas pelo
   código-fonte do painel.
4. Foram enviados à Lixeira, exclusivamente dentro de `C:\dev\ZimbaControl`,
   os diretórios regeneráveis `artifacts/`, `apps/api/dist/` e
   `apps/mobile/build/` (aproximadamente 3,6 GB). Nenhum outro projeto em
   `C:\dev` foi alterado.
5. O cadastro de pessoas passou a conservar o nome escolhido para o titular
   (em vez de restaurar o e-mail a cada autenticação) e registra a relação
   `Titular`, `Cônjuge`, `Filho(a)` ou `Outro dependente`. A tela Estrutura
   familiar agora lê exclusivamente esses cadastros, sem membros de exemplo.
   Os ícones das categorias também são convertidos das chaves da API para os
   ícones visuais corretos.

Validação adicional: API saudável em `:3333`, painel Web em `:8080`, build do
painel aprovado e 6 testes de API aprovados, incluindo a alteração persistente
do nome do titular.

Ainda pendente de um ciclo próprio: equivalência completa das jornadas Flutter
que ainda vivem em `AppDatabase`, migração do onboarding Web simulado e a
consolidação dos documentos históricos offline.

### P0 — restabelecer o painel local

1. Migrar `C:\dev\pixel-perfect-pixels/src/lib/api.ts` para o contrato `/v1`:
   - leitura: `GET /v1/entities/:entityType`, sem `householdId` na URL;
   - criação/edição: `PUT /v1/entities/:entityType/:entityId` com
     `{ baseVersion, payload }`;
   - remoção: `DELETE /v1/entities/:entityType/:entityId?baseVersion=N`;
   - tratar `401/403`, `409` e `410` explicitamente.
2. Remover do cliente Web a fabricação de `deviceId`, `opId` e `householdId`.
   O servidor determina o escopo da conta a partir do bearer token.
3. Substituir a tela de status de sync (`/sync/status`) por um estado de
   conexão online baseado em `GET /health` ou em uma leitura autenticada de
   `/v1/bootstrap`. Não há sincronização offline no modelo vigente.
4. Fazer erros de carga visíveis e recuperáveis. Um `410` deve explicar que o
   painel está em versão incompatível, em vez de parecer "base local" vazia ou
   ficar carregando indefinidamente.
5. Incluir testes de integração Web × API que exercitem login, bootstrap,
   lista, criação, atualização, exclusão e erro de versão. Eles devem executar
   contra `buildApp`, não contra mocks do contrato antigo.

Critério de aceite: após login no endereço que o BAT abre, `GET /v1/bootstrap`
e `GET /v1/entities/transaction` retornam dados da conta e uma criação Web
aparece após atualizar a página.

### P0 — tornar o BAT honesto e determinístico

1. Definir o alvo do BAT: **painel Web migrado** ou **Flutter no Android**.
   Hoje ele abre o primeiro, embora também configure `adb reverse` para o
   segundo.
2. Se o alvo for Web, só abrir o navegador depois de aguardar `/health` e a
   porta do Vite; mostrar URLs, PID e uma mensagem de falha em vez de ocultar
   todo o diagnóstico com `-WindowStyle Hidden`.
3. Se o alvo for Android, adicionar uma ação explícita de `flutter run` ou de
   instalação da APK, mantendo `adb reverse tcp:3333 tcp:3333`, e confirmar
   `adb devices` antes de prosseguir.
4. Não fazer o BAT reativar endpoints `/sync/*` ou dados locais. Isso
   contrariaria a migração e a proteção de escopo por token.

### P1 — completar o produto Flutter online

O Flutter deixou de carregar o Drift no ponto de entrada, mas a nova
`OnlineHomePage` expõe apenas Resumo, criação simples de lançamento e uma
consulta limitada de cadastros. As jornadas antigas continuam no repositório,
dependendo de `AppDatabase`, porém estão inacessíveis.

É preciso migrar, para as APIs `/v1`, pelo menos cadastros completos,
movimentações/edição, revisão/duplicidades, importação, relatórios, backup e
restauração antes de considerar o corte online funcionalmente equivalente. Os
endpoints para várias dessas jornadas já existem no servidor.

Depois da equivalência e da migração de dados de instalações antigas, remover
de forma deliberada o código Drift/SQLite, dependências e testes que ficaram
inativos. Não removê-los agora: eles ainda são a única implementação das
jornadas ausentes.

### P1 — eliminar os fluxos simulados do painel Web

O onboarding Web ainda conclui com `setTimeout` e se apresenta como fluxo de
demonstração/salvamento no aparelho. No modelo online, ele deve persistir pela
API ou ficar inequivocamente identificado como protótipo visual não aberto pelo
atalho operacional.

## Documentação a alinhar

O repositório contém dois desenhos contraditórios. A matriz
`docs/architecture/ONLINE_PARITY_MATRIX.md` e
`docs/context/MONGODB_ONLINE_ARCHITECTURE.md` descrevem o modo online atual;
`README.md`, `docs/context/ARCHITECTURE.md`, `docs/context/CURRENT_STATE.md` e
vários documentos de produto ainda registram Drift/SQLite e offline-first como
estado operacional. Deve haver uma única fonte canônica e os documentos
históricos precisam ser marcados claramente como históricos, para não orientar
o BAT, novas telas ou testes para o modelo antigo.

## Próxima verificação manual

Após migrar o painel Web, conectar o Android e verificar:

1. `adb devices -l` mostra o aparelho como `device` e `adb reverse --list`
   contém `tcp:3333`;
2. a APK instalada foi gerada após o corte online e recebeu
`--dart-define=API_BASE_URL=http://127.0.0.1:3333` quando usada com `adb
reverse`;
3. login, bootstrap, lista vazia, criação e logout funcionam com a API local;
4. desligar a API/rede exibe indisponibilidade recuperável, sem referência a
base local, sem dados fictícios e sem fila financeira persistente.
