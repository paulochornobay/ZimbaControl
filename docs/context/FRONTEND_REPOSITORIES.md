# Frontends e referências externas

O ZimbaControl mantém o cliente Flutter, a API Fastify e os contratos online.
O frontend React web independente está em
`C:\dev\ZimbaFront` (`paulochornobay/ZimbaFront`) e usa
`VITE_API_BASE_URL` para consumir a mesma API.

`C:\dev\pixel-perfect-pixels` permanece o laboratório Lovable e referência
visual externa. Não copie ou mescle seu código automaticamente em nenhum dos
dois produtos. Para atualizar a referência, use apenas `git fetch` e um
worktree descartável no SHA de `lovable/main`.

Os scripts de captura deste repositório continuam comparando Flutter contra a
referência Lovable. Informe o worktree de revisão explicitamente, por exemplo:

```powershell
$env:LOVABLE_SOURCE = 'C:\dev\ZimbaLovableReview'
npm run visual:capture-lovable-routes
```

Baselines e goldens só mudam após revisão explícita; registros históricos de
commits Lovable existentes permanecem válidos como evidência do seu ciclo.
