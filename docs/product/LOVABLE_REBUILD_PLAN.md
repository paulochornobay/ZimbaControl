# ZimbaControl — reconstrução visual do Lovable

**Referência congelada:** `pixel-perfect-pixels@979b7eef816ac5510b45071121d165da3d4feed8`

**Fonte validada:** `C:\dev\pixel-perfect-pixels`

O repositório `C:\dev\pixel-perfect-pixels` permanece somente leitura. A
implementação visual é traduzida para Flutter sem copiar componentes React e
sem substituir as ações reais ligadas ao Drift.

**Relatório da execução:** `docs/product/LOVABLE_REBUILD_REPORT.md`.

## Contrato visual

- Viewports de aceite: 360×800, 390×844 e 440×900.
- Conteúdo Android ocupa a largura disponível; o preview web centraliza em
  uma moldura de no máximo 440 dp.
- Grade de 4 dp, margem horizontal de 16 dp e alvo mínimo de 48×48 dp.
- Inter; cores, raios e sombras definidos em `ZimbaTheme`/`ZimbaLayout`.
- Tolerância geométrica: até 2 dp para elementos estáveis. Diferenças de
  rasterização nativa não dispensam a igualdade de hierarquia, quebra de texto,
  cor, vetor, alinhamento e tamanho lógico.

## Matriz de rotas

| Lovable | Flutter | Estado funcional preservado | Classificação |
| --- | --- | --- | --- |
| `/` (`/review` redireciona) | `ReviewPage` | fila Drift, filtros, confirmar, desfazer, editar, ignorar e conciliar | referência direta |
| `/summary` | `DashboardPage` | consolidação mensal e leituras reais | referência direta |
| `/transaction/new` | `NewTransactionPage` | cadastro real e criação inline | referência direta |
| `/transaction/$id` | `EditTransactionPage` | leitura, edição explícita e origem imutável | referência direta |
| `/movimentacoes` | `MovementsPage` | busca, filtros e abertura do detalhe | referência direta |
| `/settings` | `SettingsHomePage` | hub de estados locais | referência direta |
| `/onboarding` | `OnboardingPage` | instalação limpa, configuração real ou demo explícita | referência direta |
| `/import` | `ImportPage` | arquivo, identidade, destino, preview, promoção e histórico | referência direta |
| `/duplicates` | `DuplicatesPage` | comparação e conciliação real | referência direta |
| `/family` | `FamilyStructurePage` | pessoas, instrumentos, recorrências e acesso | referência direta |
| `/rules` | `RulesPreviewPage` | regras reais ou indisponibilidade explicada | referência direta |
| `/backup` | `BackupSettingsPage` | exportação e restauração transacional | referência direta com diferença funcional deliberada |
| `/sync-privacy` | `SyncPrivacyPreviewPage` | fila, sessão e privacidade reais | referência direta com diferença funcional deliberada |
| `/identidade` | `BrandIdentityPage` | catálogo local de marca e tokens | nova página Flutter |
| `/registries` | `RegistriesPage` | cadastros reais, incluindo grupo e limite compartilhado de cartões | referência direta |
| `/invoices` | `InvoicesPage` | faturas, parcelas, estornos, pagamentos auditáveis e CSV reais | referência direta com domínio ampliado |
| `/commitments` | `CommitmentsPage` | recorrências e parcelamentos reais | referência direta |
| `/capture` | `NotificationSettingsPage` | ponte Android, allowlist, diagnóstico e retenção reais | referência direta |
| `/local-data` | `DataEnvironmentPage` | inventário e exclusão local protegida reais | referência direta |

## Baselines

As 57 capturas full-page ficam em
`docs/product/baselines/lovable/979b7ee`, separadas por viewport. O
`manifest.json` registra rota, viewport e SHA-256 de cada evidência. O conjunto
é reproduzível por `npm run visual:capture-lovable-routes`.

## Marcos e aceite

1. Consolidar tokens, shell, iconografia, marca e componentes-base.
2. Entregar Identidade Visual, navegação por Ajustes e testes nos três
   viewports.
3. Revalidar as cinco jornadas principais e os fluxos operacionais.
4. Revalidar Ajustes e aplicar o sistema às jornadas exclusivas do Flutter.
5. Fechar com overlays, goldens, texto 1,3×, nomes/valores longos,
   `flutter analyze`, `flutter test` e build Android reproduzível.

Um marco só é concluído sem overflow, ação mockada, regressão funcional ou
divergência visual não registrada.
