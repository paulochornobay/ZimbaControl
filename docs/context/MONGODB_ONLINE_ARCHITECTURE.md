# Dados online e isolamento por e-mail

MongoDB é a fonte única de cadastros, movimentos, revisões e importações. Cada
identidade autenticada resolve uma única conta no servidor; clientes não podem
escolher uma conta por `householdId` em query ou corpo de requisição.

Os modelos de categorias são copiados uma única vez para a conta no primeiro
acesso. Eles não são demonstrações e alterações posteriores pertencem apenas à
conta que as fez.

Flutter e ZimbaFront usam a API online (`/v1/bootstrap` e `/v1/entities/*`).
Quando não há rede, operações financeiras não são enfileiradas. A única
persistência local permitida é a fila Android criptografada de notificações:
ela é limitada a 100 eventos, vinculada à conta ativa, enviada a
`/notification-events/batch` e apagada no logout. O texto bruto é removido do
MongoDB ao concluir a revisão da captura.

Para limpar somente o ambiente de desenvolvimento, use `npm run
reset:development --workspace @zimbacontrol/api` com `NODE_ENV=development`,
`MONGODB_URI` e a confirmação `CONFIRM_ZIMBA_DEV_RESET=RESET_LOCAL_DEVELOPMENT_DATA`.
