# Relatório de implementação — reconstrução Lovable no Flutter

Data da revalidação: 30 de agosto de 2026  
Referência: `pixel-perfect-pixels@979b7eef816ac5510b45071121d165da3d4feed8`

## Resultado por marco

| Marco | Resultado | Evidência |
| --- | --- | --- |
| Baseline e auditoria | concluído | 57 capturas em `baselines/lovable/979b7ee` e matriz em `LOVABLE_REBUILD_PLAN.md` |
| Design system e shell | concluído | tokens canônicos, Inter, Lucide, grade de 4 dp, raios, sombras, viewport de 440 dp e navegação de cinco abas |
| Identidade visual | concluído | `BrandIdentityPage`, acesso por Ajustes, três goldens e testes de preview, clipboard e retorno |
| Telas centrais | revalidado | Resumo, Revisão, Novo, Movim. e Ajustes exercitados pela shell real nos três viewports |
| Fluxos operacionais | revalidado | detalhe, onboarding, importação e duplicidades capturados nos três viewports; testes Drift preservados |
| Cartões e faturas | implementado | limite compartilhado, fatura real, pagamento parcial/total auditável, cancelamento e CSV |
| Sincronização de cartões e faturas | implementado | grupos de limite, cartões, conta do cartão, pagamentos e auditoria trafegam versionados e de forma idempotente |
| Jornadas complementares | revalidado | Cadastros, Compromissos, Captura Android e Dados locais agora têm rotas Lovable diretas |
| Homologação automatizada | concluído | 42 goldens Flutter, 42 pares lado a lado, 42 overlays, análise estática, suíte e APK debug |
| Homologação Android física | pendente externa | nenhum dispositivo Android estava conectado; o APK foi gerado com sucesso |

## Evidências visuais

- Referência Lovable: `docs/product/baselines/lovable/979b7ee/<viewport>/<rota>.png`.
- Flutter: `apps/mobile/test/goldens/parity/<viewport>/<rota>.png`.
- Comparações anteriores permanecem em `docs/product/comparisons/d78a50d`; os novos overlays devem usar `979b7ee`.
- Viewports: 360×800, 390×844 e 440×900.
- Gerador reproduzível: `tools/compare_visual_baselines.ps1`.

As capturas full-page do Lovable são normalizadas para a largura lógica do
viewport. Quando a captura separa a navegação sticky do início da página, o
comparador recompõe os 68 px inferiores antes de criar o lado a lado e o
overlay. Isso remove a diferença artificial de 15 px da barra de rolagem do
Chrome sem alterar a hierarquia da referência.

## Identidade visual

A implementação reproduz as variantes `mark`, `wordmark` e `lockup`, nos
tamanhos `sm`, `md`, `lg` e `xl`, e os tons colorido, monocromático claro e
monocromático escuro. O monograma é desenhado vetorialmente em Flutter com a
mesma geometria de três barras e o gradiente da referência.

A página também contém hero claro/escuro, swatches copiáveis, escala
tipográfica, espaçamentos, raios, sombras e catálogo de componentes. O toggle
altera somente a prévia, sem introduzir tema escuro global.

## Diferenças deliberadas e limites

1. Valores, quantidades, instituições e filas vêm do Drift real. Eles podem
   diferir dos mocks congelados do Lovable; os testes de comparação não trocam
   o estado funcional por fixtures React.
2. Backup e sync/privacidade mostram o estado operacional do Flutter, não a
   simulação do protótipo.
3. A shell mantém a navegação inferior nas cinco jornadas principais e em
   Identidade. Fluxos secundários empilhados pelo `Navigator` preservam o botão
   Voltar do Android em vez de duplicar uma rota web literal.
4. Diferenças de antialiasing entre Chromium e Skia são visíveis nos overlays,
   mas não alteram tokens ou dimensões lógicas.
5. A etapa física de TalkBack e toque em aparelho Android precisa ser executada
   quando um dispositivo estiver disponível. A ausência de dispositivo não foi
   tratada como aprovação dessa etapa.

## Comandos de reprodução

Última execução registrada:

- `flutter analyze`: sem problemas;
- `flutter test`: 129 testes aprovados;
- `flutter build apk --debug`: APK gerado em
  `apps/mobile/build/app/outputs/flutter-apk/app-debug.apk`;
- dispositivo Android físico: não disponível em `flutter devices`.

```powershell
cd C:\dev\ZimbaControl\apps\mobile
flutter analyze
flutter test
flutter test --update-goldens test/visual_parity_baseline_test.dart
flutter build apk --debug

cd C:\dev\ZimbaControl
.\tools\compare_visual_baselines.ps1 -ReferenceCommit 979b7ee
```

O repositório `C:\dev\pixel-perfect-pixels` foi sincronizado por fast-forward,
compilado e capturado no commit `979b7ee`; não recebeu alterações do Flutter.
