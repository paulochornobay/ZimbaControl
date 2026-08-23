# ZimbaControl — Próximos marcos e prompts de execução

Data da auditoria: 2026-08-23
Escopo deste arquivo: planejar os próximos ciclos. Não é autorização para
alterar domínio, banco, Android ou interface fora do marco escolhido.

## Como usar este roteiro

1. Abra um ciclo novo com **um único prompt** da seção “Prompts prontos”.
2. O agente deve primeiro ler `PROJECT_BRIEF.md`, `ARCHITECTURE.md`,
   `MILESTONES.md`, `CURRENT_STATE.md` e este arquivo.
3. O agente deve preservar dados locais, Drift, parsers, hashes de importação
   e ações financeiras existentes. Não usar dados ou sucessos simulados.
4. Todo marco precisa terminar com testes proporcionais ao risco, APK debug e
   uma atualização objetiva do estado deste arquivo e de `MILESTONES.md`.
5. Não iniciar o próximo marco enquanto os critérios de aceite do atual não
   estiverem registrados.

## Estado constatado

### Já existe e é funcional localmente

- Caixa de Revisão com dados Drift, filtros persistentes, confirmar, editar,
  ignorar, duplicidades, transferência e desfazer.
- Importação CSV/OFX, staging, hashes, conciliação e candidatos de
  duplicidade.
- Banco local, cadastros familiares, recorrências, parcelamentos, backup e
  restauração.
- Captura Android nativa mínima: `NotificationListenerService`, allowlist de
  Nubank/Mercado Pago, armazenamento bruto em SQLite nativo e bridge por
  `MethodChannel`.
- Ao receber um evento dentro do Drift, o parser cria ou concilia um rascunho
  pendente e o coloca na Caixa de Revisão. Isso é coberto por testes locais.
- Sync 11A/11B técnico: outbox, push/pull API, cursor, `deviceId` local e
  login Google opcional, configurados por `dart-define`.
- Migração visual já iniciada para Resumo, Revisão, Movimentações, Novo
  lançamento, Detalhe/Edição, Importação/Mapeamento e Duplicidades.

### Marco A — implementação técnica registrada em 2026-08-23

- A fila nativa agora mantém estado de entrega (`pending`, `delivering` e
  `delivered`), tentativas e confirmação posterior à gravação no Drift.
- O Flutter drena automaticamente ao abrir ou retomar o app, em páginas de
  até 100 eventos. O WorkManager registra o pedido de entrega pendente sem
  processar dados financeiros fora do Drift.
- A ponte não usa mais a janela fixa dos 50 eventos recentes. Reentregas não
  reprocessam um evento Drift já finalizado e a fonte continua idempotente por
  `notificationKey`.
- Ajustes passou a exibir permissão, allowlist, fila, resultados de parser,
  erro recuperável e retenção/expurgo apenas de eventos já entregues.
- Permanecem pendentes a execução de testes instrumentados e a homologação em
  aparelho físico real, registrada em
  `docs/context/ANDROID_CAPTURE_HOMOLOGATION.md`.

Portanto, os critérios técnicos locais do Marco A foram implementados, mas a
aceitação para release continua dependente da homologação Android física.

### Marco B — implementação técnica registrada em 2026-08-23

- A outbox passou a transmitir payload de transacao versionado (v1), completo
  com vinculos financeiros, beneficiarios e fontes.
- Pull aplica eventos em transacao Drift, registra `opId` aplicado e avanca o
  cursor somente ate a ultima sequencia aplicada.
- Eventos proprios atualizam versao sem regravar dados. Eventos remotos seguros
  atualizam o snapshot; edicoes concorrentes preservam payload local/remoto em
  `sync_conflicts` e voltam para a Caixa de Revisao com os dois valores.
- Testes locais cobrem dois bancos independentes, repeticao, concorrencia e
  decisao local; a API agora valida o payload versionado.
- Falta a homologacao manual com duas instalacoes Android e a API configurada,
  em `docs/context/SYNC_TWO_DEVICE_HOMOLOGATION.md`.

### Marco C — implementação técnica registrada em 2026-08-23

- Compromissos agora mostra projeção de recorrências e parcelas ativas,
  estados vazios com CTA funcional e cartões que preservam edição e
  arquivamento já existentes.
- Formulários mantêm o salvamento Drift e deixam a ação principal acessível
  acima da safe area; nomes de pessoas/contas e valores extensos não causam
  overflow nos tamanhos validados.
- Ajustes passou a ser um hub de estado: captura Android, fila de sync,
  dados locais que entrarão no backup e privacidade mostram informação real,
  sem simular recursos indisponíveis.
- O teste `marco_c_widget_test.dart` cobre 360×800 e 390×844 com textos e
  valores longos; `flutter analyze` e `flutter test` devem ser repetidos
  junto à geração do APK debug a cada alteração posterior.

### Marco D — implementação técnica registrada em 2026-08-23

- Família passou a ter resumo dos membros/instrumentos, textos longos em
  linhas legíveis e atualização ao retornar das jornadas de cadastros,
  duplicidades e compromissos.
- Cadastros preserva o CRUD Drift e agora usa cartões de leitura responsivos,
  status de ativo/arquivado, seletores expansíveis e CTA de salvar fora da
  área coberta pelo teclado ou safe area.
- Backup/restauração deixa explícito o efeito destrutivo antes da confirmação
  e informa cancelamento, arquivo inválido, sucesso e falha com estados reais.
- Regras mostra prioridade, ativação, contador de uso e destino resolvido
  para categoria/centro de custo, sem prometer rateio ou automação inexistente.
- O teste `marco_d_widget_test.dart` cobre as quatro jornadas em 360×800 e
  390×844 com nomes e valores longos.

### Marco E — implementação técnica registrada em 2026-08-23

- Foi criado um banner reutilizável para feedback recuperável e telas de
  importação, duplicidades, família, compromissos e Ajustes passaram a
  distinguir erro de uma lista vazia; ações de atualização preservam os dados.
- A regressão agora cobre Resumo, Movimentações, Duplicidades e Importação
  com lançamento, descrição e valor extensos em 360×800 e 390×844. O teste
  encontrou e corrigiu overflow no detalhamento do Resumo.
- O estado técnico de sync deixou de anunciar como futuro o pull/conflito já
  implementados; a pendência real de dois aparelhos continua explícita.
- O baseline `pixel-perfect-pixels@ac6bf30`, diferenças deliberadas e o
  checklist físico pendente estão em `MARCO_E_HOMOLOGATION.md`.
- A APK debug foi gerada. A build release travou no `gen_snapshot` AOT sem
  criar artefato novo; ela precisa ser repetida antes de iniciar o Marco F.

### Lacunas técnicas confirmadas

| Tema | Estado atual | Falta para concluir |
| --- | --- | --- |
| Captura Android | Serviço nativo, allowlist e armazenamento bruto existem. | Drenagem confiável para Drift, reprocessamento real, retenção e homologação física. |
| Revisão de notificações | Parser/rascunho/ações reais existem. | Integração automática com a captura e telas de diagnóstico que expliquem cada falha. |
| Sync 11C | Push, pull, cursor e conflito de push existem. | Aplicar eventos recebidos do pull no Drift; mesclar/conflitar sem perdas; teste em dois aparelhos. |
| Regras | CRUD local, prioridade e contador de uso existem. | Auditoria/explicação da regra aplicada, rateio e ligação mais profunda com a edição. |
| Visual Lovable | Migração e regressão automatizada das telas atuais concluídas. | Comparação física tela a tela e homologação Android. |
| Segurança/publicação | Token em secure storage e backup local existem. | Retenção configurável, revisão de privacidade, CI/release e avaliação de criptografia em repouso. |

## Ordem recomendada dos próximos marcos

### Marco A — Captura Android ponta a ponta e revisão de notificações

Objetivo: uma notificação autorizada virar, sem ação manual obrigatória, um
item explicável na Caixa de Revisão ou uma fonte conciliada de lançamento já
existente.

Escopo:

- Definir uma fila nativa durável com cursor/estado de entrega para o Drift.
- Criar uma ponte segura de drenagem, acionada ao abrir o app e por trabalho
  agendado compatível com Flutter/Android; não executar lógica financeira no
  `NotificationListenerService`.
- Tornar `NotificationReprocessWorker` real ou substituí-lo por arquitetura
  equivalente documentada. Ele não pode simplesmente retornar sucesso.
- Garantir idempotência por chave da notificação e por `transaction_sources`.
- Processar backlog paginado, e não só os 50 eventos recentes.
- Exibir no Ajustes: permissão, allowlist, última drenagem, pendentes,
  processados, duplicados, ignorados, erro e ação de tentar novamente.
- Aplicar expurgo configurável, com confirmação e sem apagar eventos ainda não
  entregues ao Drift.
- Incluir cenários Nubank e Mercado Pago; notificações sem valor devem ter
  motivo legível e nunca criar lançamento fictício.

Critérios de aceite:

- Com permissão e app permitido, uma notificação real gera/atualiza um item de
  revisão após abrir o app, mesmo depois de reinício.
- A mesma notificação nunca duplica despesa nem fonte.
- Sem permissão, allowlist vazia, parser sem valor, falha de bridge e expurgo
  exibem estado correto e recuperável.
- Testes unitários/instrumentados cobrem entrega, idempotência, backlog e
  falhas; homologação manual em Android físico é registrada.

### Marco B — Sync 11C: dois dispositivos e conflitos financeiros reais

Objetivo: aplicar no Drift os eventos remotos de `/sync/pull`, preservar
versões e devolver conflitos à Caixa de Revisão.

Escopo:

- Especificar payload completo e versionado para cada entidade sincronizada.
- Aplicar eventos do pull em transação Drift, de modo idempotente por `opId` e
  sequência remota.
- Diferenciar evento próprio já reconhecido, atualização remota segura,
  exclusão e conflito financeiro.
- Para conflito, preservar ambos os lados e criar item de revisão com contexto
  suficiente para a decisão humana; nunca sobrescrever silenciosamente.
- Testar dois bancos locais independentes contra a API, incluindo offline,
  reenvio e inversão da ordem dos eventos.

Critérios de aceite:

- Um lançamento criado/editado no aparelho A aparece corretamente no B.
- Repetir push/pull não duplica dados.
- Edições concorrentes entram em revisão, com valores e origens preservados.

### Marco C — Migração visual: compromissos e ajustes

Objetivo: levar `commitments_page.dart` e `settings_home_page.dart` ao padrão
Lovable, preservando as jornadas já funcionais.

Escopo:

- Compromissos: lista, projeção, vazio, recorrência, parcela e formulários.
- Ajustes: hub com ícone, descrição, estado e affordance; captura Android,
  backup, sync e privacidade devem refletir estado real.
- Usar o projeto externo `pixel-perfect-pixels` apenas como referência visual,
  sem copiar React/Tailwind.

Critérios de aceite:

- Screenshots em 360×800 e 390×844 sem overflow, rótulo cortado ou CTA
  inacessível.
- Nenhuma ação de dados deixa de usar o domínio atual.

### Marco D — Migração visual: família, cadastros, backup e regras

Objetivo: dividir jornadas extensas e aplicar o sistema visual aos fluxos de
pessoas, contas, cartões, categorias, centros, backup/restauração e regras.

Escopo:

- Reestruturar `family_structure_page.dart` e `registries_page.dart` em
  jornadas compreensíveis, sem remover CRUD existente.
- Aplicar aos fluxos de backup/restauração os estados de aviso, confirmação,
  arquivo inválido, sucesso e falha real.
- Dar às regras uma visualização explícita de prioridade, ativação, uso e
  destino; não prometer automação que o domínio ainda não executa.

Critérios de aceite:

- Textos longos, muitos membros e listas vazias não causam corte ou overflow.
- Restauro continua transacional e requer confirmação explícita.

### Marco E — Estados transversais, regressão visual e homologação

Objetivo: consolidar qualidade antes de release pessoal.

Escopo:

- Padronizar loading, erro, vazio, confirmação, sheets e snackbars em todas as
  telas migradas.
- Criar testes de widget/golden por tela nos viewports 360×800 e 390×844,
  incluindo valores grandes e nomes longos.
- Comparar com o baseline Lovable vigente, registrando o commit utilizado.
- Gerar APK debug a cada marco e APK release no fechamento.
- Homologar em Android físico: onboarding limpo, offline, revisão, importação,
  captura, backup/restauração, retorno do app e teclado/safe area.

Critérios de aceite:

- Nenhum `RenderFlex overflow`, rótulo invisível ou ação falsa.
- Todas as diferenças visuais deliberadas ficam registradas.
- Fluxos financeiros continuam locais e recuperáveis sem rede.

### Marco F — Segurança e preparação de publicação

Objetivo: transformar o uso pessoal estável em uma base segura para release.

Escopo:

- Política de retenção para eventos brutos e dados de backup.
- Revisão das permissões Android e texto de privacidade no app.
- Avaliar criptografia do banco em repouso, impacto em backup e migração.
- CI para análise, testes e build; assinatura/release e checklist de instalação.

Critérios de aceite:

- A pessoa usuária entende o que é capturado, onde fica e como apagar.
- Build release reproduzível e checklist de restauração aprovados.

## Prompts prontos para novos ciclos

### Prompt 0 — Preparar um marco sem implementar

```text
No repositório /Users/macbookair/Public/dev/ZimbaControl, leia primeiro:
docs/context/PROJECT_BRIEF.md, ARCHITECTURE.md, MILESTONES.md,
CURRENT_STATE.md e NEXT_IMPLEMENTATION_PROMPTS.md.

Quero preparar o Marco [A/B/C/D/E/F], sem implementar nada ainda.
Faça uma inspeção read-only do código relacionado, confirme o escopo,
dependências, riscos, critérios de aceite e a lista exata de arquivos que
seriam alterados. Não faça commits, builds, alterações de banco ou de UI.
```

### Prompt A — Implementar captura Android ponta a ponta

```text
Implemente somente o Marco A de docs/context/NEXT_IMPLEMENTATION_PROMPTS.md:
captura Android ponta a ponta e revisão de notificações.

Antes de editar, leia todos os arquivos de contexto e audite o fluxo atual
NotificationListenerService -> SQLite nativo -> MethodChannel -> Drift ->
Caixa de Revisão. Corrija a lacuna de drenagem automática/idempotente e o
backlog paginado; o worker atual não pode continuar como no-op.

Preserve os parsers, a conciliação e os dados existentes. Não processe valores
financeiros no listener Android e não simule captura em web/iOS. Atualize a
tela de Ajustes apenas com estados reais. Adicione testes e, ao final, rode
flutter analyze, flutter test e gere APK debug. Registre a homologação Android
que ainda depender de aparelho físico. Faça commit apenas se eu pedir.
```

### Prompt B — Implementar sync de dois dispositivos

```text
Implemente somente o Marco B de docs/context/NEXT_IMPLEMENTATION_PROMPTS.md.
Antes de editar, inspecione runSyncOnce, a API /sync/push e /sync/pull,
contratos e testes existentes. Faça o pull aplicar eventos remotos no Drift de
forma idempotente, sem sobrescrever conflito financeiro; conflitos devem
voltar à Caixa de Revisão com contexto útil.

Não altere a captura Android nem redesenhe telas fora do necessário. Crie
testes com dois bancos locais e execute check da API, flutter analyze e
flutter test. Faça commit apenas se eu pedir.
```

### Prompt C — Implementar migração visual de compromissos e ajustes

```text
Implemente somente o Marco C de docs/context/NEXT_IMPLEMENTATION_PROMPTS.md.
Use /Users/macbookair/Public/dev/pixel-perfect-pixels como referência visual,
sem copiar código React. Primeiro registre o commit da referência e compare as
rotas aplicáveis. Migre compromissos e Ajustes com dados e ações reais.

Valide cada tela em 360×800 e 390×844, com nomes e valores longos. Não crie
ações falsas para recursos indisponíveis. Rode flutter analyze e flutter test;
gere APK debug ao final. Faça commit apenas se eu pedir.
```

### Prompt D — Implementar migração visual de família/cadastros/backup/regras

```text
Implemente somente o Marco D de docs/context/NEXT_IMPLEMENTATION_PROMPTS.md.
Preserve o CRUD Drift, backup transacional e regras atuais. Reestruture a
apresentação para o padrão Lovable, tela a tela, sem concentrar tudo em painéis
longos. Registre diferenças inevitáveis por ausência de domínio.

Inclua testes responsivos 360×800 e 390×844 e valide analyze/test/build debug.
Faça commit apenas se eu pedir.
```

### Prompt E — Regressão visual e homologação

```text
Implemente somente o Marco E de docs/context/NEXT_IMPLEMENTATION_PROMPTS.md.
Não introduza novas funcionalidades. Cubra as telas migradas com testes de
widget/golden e cenários de texto/valor longo, padronize estados transversais e
registre a comparação com o commit Lovable usado. Gere APK debug e release.
Se não houver Android conectado, documente o checklist pendente sem declarar
homologação concluída.
```

### Prompt F — Segurança e publicação

```text
Implemente somente o Marco F de docs/context/NEXT_IMPLEMENTATION_PROMPTS.md.
Comece com auditoria de permissões, retenção, backup e segredos. Proponha e
implemente apenas mudanças que não comprometam o uso offline e a recuperação
de dados. Inclua CI/checklists de build e documentação de privacidade. Não
publique em lojas nem faça alterações externas sem minha autorização explícita.
```

## Pendências administrativas antes do próximo código

- Há alterações locais ainda não commitadas em `apps/mobile` (incluindo a
  melhoria visual recente do detalhe de lançamento). Um ciclo futuro deve
  verificar o diff, testar e decidir conscientemente se cria um commit antes
  de misturar novo marco.
- O Marco C usou `pixel-perfect-pixels@ac6bf30` como referência visual. O
  repositório de referência tinha alterações locais não relacionadas; antes de
  uma nova migração visual, confirmar e registrar um baseline limpo.
- Não há homologação concluída em Android físico registrada para captura,
  permissão revogada, restauração e sync em dois aparelhos.
