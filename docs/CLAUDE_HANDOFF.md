# Handoff para continuidade do ZimbaControl

O projeto depende deste repositório para API/mobile e do repositório irmão [`ZimbaFront`](https://github.com/paulochornobay/ZimbaFront) para a web. Clone os dois lado a lado.

```bash
git clone https://github.com/paulochornobay/ZimbaControl.git
git clone https://github.com/paulochornobay/ZimbaFront.git
```

## Execução local

```bash
cd ZimbaControl/apps/api && npm install && npm run dev
cd ZimbaFront && npm install && npm run dev -- --port 5173 --host 127.0.0.1
```

API: `3333`; web: `5173`. Configure MongoDB sem versionar `.env` nem segredos.

## Pontos de manutenção

- Importação CSV/OFX: `apps/api/src/statement-import.ts` e `apps/api/src/app.ts`.
- Importações exigem conta/cartão ou permitem criar um; lotes antigos podem ser reassociados.
- Itens ignorados não são referência de duplicidade. O reprocessador é `apps/api/src/recheck-duplicate-candidates.ts`.
- A interface web mantém categorias e subcategorias em `ZimbaFront/src/lib/registry.ts`; `parentId: null` é categoria principal.
- Testes: `cd apps/api && npm run build && npm test`; depois `cd ../../ZimbaFront && npm run build`.

O guia operacional detalhado fica em `C:\dev\zimbacontrol.md` no computador de desenvolvimento.
