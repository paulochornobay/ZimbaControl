# ZimbaControl - Current State

> Fonte operacional canônica desde 2026-08-23:
> `docs/product/PRODUCT_REQUIREMENTS.md`,
> `docs/product/VISUAL_PARITY_AUDIT.md` e
> `docs/product/IMPLEMENTATION_ROADMAP.md`. O inventário abaixo preserva o
> histórico técnico; em caso de divergência, prevalecem os documentos de
> `docs/product`.

## Atualização canônica de 2026-08-23

- Item 0 do plano de continuidade concluído: requisitos, auditoria das 12
  telas do protótipo e roadmap por fases foram consolidados em `docs/product`.
- Fases 1, 2, 3, 4A, 4B, 4C e 5 concluídas tecnicamente. Além da fundação visual, o app agora
  distingue conta/cartão, persiste ícones e cores de categorias/centros,
  permite criação inline, oferece reset coordenado e exige instrumento
  confirmado em toda importação e possui o modelo calculável e auditável de
  faturas, visão por cartão, conciliação confirmável de pagamentos e projeção
  de parcelas sem despesas artificiais. A Fase 5 também recompôs o Resumo,
  fechou a matriz de paridade e preparou a candidata Android assinada.
- Referência visual oficial local: `C:\dev\pixel-perfect-pixels@2848fc6`.
- Código do app auditado: `ZimbaControl@cd67fcb`.
- Lacuna crítica restante: homologação Android integral em aparelho físico.
- A APK release `1.1.0+2` foi gerada com sucesso em
  `apps/mobile/build/app/outputs/flutter-apk/app-release.apk`, SHA-256
  `36C922AE12AA35C1BE22C4305C1DF8E08E2EB714D76ACCD58D3AB074750C2C57`.
  Ela é um artefato diagnóstico: usa certificado de debug e não é a candidata
  final de distribuição.
- O aparelho Samsung `SM-S908E` passou a ser enumerado pelo ADB e recebeu a
  build release da Fase 2 por atualização (`adb install -r`), preservando os
  dados. O processo iniciou normalmente; a homologação física completa
  continua reservada à Fase 5.
- A build release da Fase 3 foi gerada, SHA-256
  `5EE399A51FF674F82314EAB8838D36A6363D542E72675D51A480AE6AAD977C02`. A
  tentativa de atualização foi interrompida porque o aparelho desapareceu do
  ADB durante a instalação; repetir `adb install -r` quando ele reconectar.
- A build release com as Fases 4A e 4B foi gerada, SHA-256
  `64335CDDCFEE59A80777001C93EE662E54F04EDA0F0A1829AF500BBC2861E61D`.
  O Samsung apareceu inicialmente como `unauthorized` e depois saiu da lista
  do ADB; a instalação por atualização continua pendente de reconexão e aceite
  da depuração USB no aparelho.
- A build release da Fase 4C foi gerada, SHA-256
  `6BC4F771690FD6B19BEC5DCFAE9E20DC798D5A6F25DD8B89F1D355861C8A7E94`.
  O ADB não enumerou aparelho conectado no fechamento do marco, portanto esta
  build ainda não foi instalada no Samsung.
- A candidata pessoal `1.2.0+3` foi gerada com chave RSA 4096 externa ao Git,
  assinatura v2 verificada e SHA-256
  `0D29C9D3D1D0F9177C57DFBE2BFD49E22809A7DE54084603C77396E42E7FC2E5`.
  A regressão passou em 99 testes Flutter e 7 testes da API. Como o APK
  anterior usa certificado de debug, a instalação exige backup seguido de
  desinstalação; o ADB não enumerou o aparelho no fechamento e nenhum dado foi
  apagado.

## Estado Atual

- Repositorio estruturado como monorepo.
- Plano aprovado: Lovable como prototipo; Flutter como app final.
- Toolchains detectadas localmente: Flutter, Dart, Node.js, npm e unzip.
- PDF/DOCX de arquitetura analisado e resumido nos arquivos de contexto.
- O front Lovable duplicado foi removido do monorepo. A referencia visual vive
  exclusivamente em `C:\dev\pixel-perfect-pixels`.
- O ciclo historico de recuperacao mobile usou
  `pixel-perfect-pixels@6a2d072` como baseline visual.
- A recuperacao do app local esta implementada: primeira abertura sem seed,
  onboarding transacional com pessoa e conta reais, demonstracao apenas por
  escolha explicita e lancamento manual sem IDs ficticios.
- O Flutter tem tema proprio inspirado no baseline externo, com Inter
  embutida, tokens compartilhados, cards, botoes, navegacao e formularios
  consistentes. Nenhum componente React/Tailwind foi copiado.
- A estrutura da navegacao principal e Resumo, Revisao, Novo, Movimentacoes e
  Ajustes; o quarto destino agora aparece como “Movim.”. Ajustes expõe apenas
  jornadas com estado real.
- App Flutter criado em `apps/mobile`.
- API Fastify criada em `apps/api`.
- Contratos OpenAPI/JSON Schema criados em `packages/contracts`.
- Mobile tem Drift/SQLite com tabelas principais do Marco 03, seeds,
  dashboard, caixa de revisao real, edicao basica, confirmacao, ignorar,
  duplicado, conversao em transferencia, desfazer e outbox local.
- Mobile tambem tem a estrutura familiar do Marco 05: proprietario em
  contas/cartoes, usuario de acesso separado, recorrencias para escola, pensao
  e ajuda familiar, plano de consorcio e transferencia interna fora do resumo
  de receita/despesa.
- Mobile tem importacao local CSV/OFX do Marco 06: escolha de arquivo,
  parser CSV/OFX, hashes de arquivo/linha, staging, adapters Nubank/Mercado
  Pago, deteccao e mapeamento visual de colunas, previa amigavel, resumo de
  conflitos, promocao para Caixa de Revisao e deteccao de reimportacao
  duplicada.
- A Fase 3 ampliou a importação: `StatementIdentity` preserva identidade,
  moeda, período e saldos do OFX; o lote persiste o destino confirmado e não
  promove nem concilia enquanto houver ambiguidade. Conta/cartão pode ser
  criado no fluxo, e o histórico mostra metadados e instrumento de cada lote.
- A Fase 4A introduziu a migração Drift 14 com faturas, pagamentos e auditoria
  de associação. Compras usam `postedAt` com fallback para `occurredAt`, corte
  e vencimento funcionam em meses curtos e virada anual, estornos reduzem o
  total e pagamentos permanecem transferências fora das despesas. Correções
  manuais ficam protegidas do recálculo e registram motivo/origem.
- A Fase 4B expôs esse domínio em **Ajustes > Faturas de cartões**: seleção
  inequívoca do cartão, fatura atual/próxima, total, datas, estado, compras,
  estornos, pagamentos e filtros por categoria/pessoa/competência. A tela
  diferencia explicitamente mês-calendário e mês da fatura e foi validada em
  360×800 e 390×844 com texto 1,3 e dados longos.
- A Fase 4C acrescentou sugestões explicáveis de pagamento com confirmação
  obrigatória, conciliação de OFX bancário/cartão e parcelas futuras apenas
  projetadas. Confirmar vincula a transferência à fatura sem duplicar despesa;
  cancelar não altera dados, e a transação real substitui a projeção.
- Mobile tem conciliacao financeira do Marco 07: candidatos de duplicidade,
  merge de fontes sem criar nova despesa, fatura como transferencia, parcelas
  de cartao em `installment_plans` e consorcio ligado ao plano do carro.
- Mobile tem captura Android do Marco 08: `NotificationListenerService`,
  allowlist de apps, SQLite nativo para eventos brutos, WorkManager, ponte
  MethodChannel, tabela Drift `raw_notification_events`, parser local inicial e
  painel em Ajustes para permissao/status.
- Marco A ampliou essa captura: a fila nativa confirma entrega somente depois
  de persistir no Drift, pagina backlog, drena ao abrir/retomar o app e mostra
  diagnosticos/retencao reais em Ajustes. Falta homologacao com notificacoes
  reais em aparelho Android, cujo roteiro esta em
  `docs/context/ANDROID_CAPTURE_HOMOLOGATION.md`.
- Mobile tem painel e movimentacoes do Marco 09: Resumo operacional do mes,
  quebras por pessoa/categoria/centro/origem, compromissos futuros, projecao
  simples, ultimas movimentacoes e tela Movimentacoes com busca/filtros. A
  importacao CSV/OFX agora fica como acao dentro de Movimentacoes.
- Mobile tem backup e recuperacao do Marco 10: exportacao JSON versionada,
  validacao antes de restaurar, restauracao transacional, exportacao CSV de
  movimentacoes, salvamento por seletor nativo e compartilhamento Android via
  `share_plus`.
- A Fase 2 adicionou identidade compartilhada para contas/cartões, ícones e
  cores persistidos para categorias/centros, criação contextual dentro de
  Novo/Editar e reset integral coordenado. O reset também limpa regras,
  staging, stores de sync, fila SQLite nativa, preferências da captura e sessão
  segura; permissões concedidas pelo Android permanecem no sistema.
- Marco 11A iniciado/concluido para sync tecnico: API tem store MongoDB/memoria,
  `.env.example`, colecoes/indices planejados no Atlas, push idempotente,
  pull incremental, conflito por `baseVersion` e painel mobile de sync via
  `--dart-define`.
- Marco 11B concluido tecnicamente: API tem `/auth/google`, validacao de ID
  token Google por OpenID Connect, allowlist por `ALLOWED_EMAILS`, sessao JWT
  local, protecao de `/sync/push` e `/sync/pull` quando
  `GOOGLE_OIDC_ENABLED=true`, e o mobile tem login Google opcional com
  `GOOGLE_WEB_CLIENT_ID`, armazenamento do token de sessao em secure storage e
  envio de bearer token no sync.
- Marco 11C foi implementado tecnicamente: o pull agora aplica snapshots de
  transacao versionados no Drift, reconhece eventos proprios por `opId` e
  preserva conflitos concorrentes em `sync_conflicts` para a Caixa de Revisao.
  Falta homologacao em dois aparelhos Android, documentada em
  `docs/context/SYNC_TWO_DEVICE_HOMOLOGATION.md`.
- Marco C foi implementado tecnicamente com
  `pixel-perfect-pixels@ac6bf30` como referencia visual: Compromissos agora
  oferece projecao, estados vazios e formularios responsivos ligados ao Drift;
  Ajustes mostra o estado real de captura, sync, backup e privacidade. O teste
  de widget cobre 360×800 e 390×844 com textos/valores longos. Falta somente
  a comparacao em aparelho Android fisico para aceitacao visual de release.
- Marco D foi implementado tecnicamente: Familia, Cadastros, Backup e Regras
  foram reorganizados sem mudar o CRUD ou a restauracao transacional. Backup
  diferencia aviso, cancelamento, arquivo invalido, sucesso e falha; regras
  expõem prioridade, estado, uso e destino local. O teste responsivo cobre
  360×800 e 390×844. Falta a comparacao em aparelho Android fisico.
- Marco E foi implementado tecnicamente: feedbacks recuperaveis foram
  padronizados, a regressao automatizada agora inclui Resumo, Movimentacoes,
  Duplicidades e Importacao, e um overflow de valores grandes no Resumo foi
  corrigido. O roteiro fisico pendente esta em
  `docs/context/MARCO_E_HOMOLOGATION.md`. A tentativa inicial de release
  travou no `gen_snapshot`, mas uma repetição posterior gerou a APK release
  descrita na atualização canônica acima.
- Uma instalacao limpa nao carrega seed automaticamente. Dados de demonstracao
  sao uma escolha explicita no onboarding ou em Ajustes.
- Para teste visual no Chrome, o banco usa Drift Web com `sql.js`; Android e
  desktop nativo continuam usando SQLite nativo.
- API tem `/health`, `/sync/push`, `/sync/pull`, store MongoDB opcional e stubs
  dos demais endpoints do plano.
- A referencia Lovable e consultada somente no repositorio externo. O visual
  e traduzido para widgets Flutter ligados ao Drift; os mocks e as acoes
  React nao fazem parte do produto final.
- APK debug da recuperacao: `apps/mobile/build/app/outputs/flutter-apk/app-debug.apk`.

## Comandos Uteis

Raiz:

```sh
npm install
npm run check
```

Mobile:

```sh
cd apps/mobile
flutter pub get
flutter run
flutter test
flutter analyze
flutter build apk --debug
```

APK debug gerado em:

```sh
apps/mobile/build/app/outputs/flutter-apk/app-debug.apk
```

Preview web no macOS sem Xcode:

```sh
cd apps/mobile
flutter build web
python3 -m http.server 54321 --directory build/web
open http://localhost:54321
```

API:

```sh
cd apps/api
npm install
npm run dev
npm test
npm run build
```

Referencia Lovable externa:

```sh
cd C:\dev\pixel-perfect-pixels
git fetch origin
npm run build
npm run lint
npm run dev
```

Observacao: `npm run build` passou no novo download. `npm run lint` falhou com
erros de Prettier, alguns `no-explicit-any` e um bug de rota para
`/transaction/undefined` em parcelas. A tentativa com pouco credito ainda
manteve "Tudo ok" e a navegacao antiga.

## Proximas Leituras

Antes de continuar qualquer marco, leia:

1. `docs/context/PROJECT_BRIEF.md`
2. `docs/context/MILESTONES.md`
3. `docs/context/ARCHITECTURE.md`
4. `docs/context/LOVABLE_SCREEN_FACTORY.md`
5. este arquivo

## Problemas Abertos

- Confirmar fixtures reais anonimizadas de Nubank e Mercado Pago.
- Homologar o APK em Android fisico: instalacao limpa, uso offline, reinicio,
  teclado real e permissao de notificacoes concedida/revogada.
- Validar captura com notificacoes reais dos apps permitidos e confirmar
  comportamento com uma lista extensa de eventos.
- Revisar restauracao de backup em um segundo aparelho antes de tratar esta
  build como versao pessoal definitiva.
- Substituir armazenamento local simples por criptografia SQLCipher quando
  viavel no Marco 12.

## Próximo ciclo

Concluir a parte física da Fase 5 de
`docs/product/IMPLEMENTATION_ROADMAP.md`: preservar os dados existentes e
homologar a candidata final assinada no Samsung.

Sequencia recomendada:

1. Exportar e conferir um backup local antes de remover o APK anterior.
2. Desinstalar o APK de debug e instalar a candidata assinada com banco limpo.
3. Concluir o onboarding com dados anonimizados, reiniciar e criar lancamentos.
4. Exercitar revisao, importacao, captura, cadastros e backup sem internet.
5. Revogar a permissao de notificacoes e verificar a orientacao do app.
6. Restaurar o backup depois de limpar os dados locais.
7. Registrar qualquer falha com modelo Android, versao do sistema e passos.
