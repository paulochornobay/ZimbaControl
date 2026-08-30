# ZimbaControl — Catálogo funcional e briefing canônico de UX

**Versão:** 1.0  
**Data:** 2026-08-23  
**Público:** ChatGPT, Lovable, design, produto e implementação Flutter  
**Aplicativo final:** Android em Flutter, offline-first  
**Laboratório visual:** Lovable/TanStack em `pixel-perfect-pixels`  
**Fonte funcional:** código vigente, `PRODUCT_REQUIREMENTS.md` e `ARCHITECTURE.md`

## 1. Como usar este documento

Este arquivo descreve o produto real e a experiência desejada. Ele pode ser
anexado integralmente a uma conversa do ChatGPT ou do Lovable. O protótipo deve
representar todos os fluxos e estados descritos aqui, mas não pode inventar
backend, captura, importação ou sync que não existam no aplicativo Flutter.

### Legenda de maturidade

| Estado | Significado |
| --- | --- |
| `[IMPLEMENTADO]` | existe no código e possui comportamento local real |
| `[CONDICIONAL]` | existe, mas depende de Android, permissão, configuração externa ou homologação |
| `[PROPOSTO]` | requisito aprovado para desenho/prototipação; ainda não migrado ao Flutter |
| `[FORA DO ESCOPO]` | não deve ser prometido nem simulado como funcional |

Sempre preservar o rótulo de maturidade ao resumir ou transformar este
documento. Uma tela visualmente pronta não muda o estado funcional do recurso.

## 2. Produto, público e resultado esperado

O ZimbaControl é um aplicativo de finanças pessoais e familiares que organiza
lançamentos manuais, notificações bancárias e arquivos CSV/OFX em uma base
local revisável, explicável e recuperável.

O público principal não precisa conhecer contabilidade, OFX, provedores,
staging, outbox ou competência financeira. A interface deve responder em
linguagem cotidiana:

- quanto entrou, quanto saiu e quanto sobrou no período;
- em que conta ou cartão uma movimentação ocorreu;
- de quem é o gasto e para quem ele se destina;
- em qual categoria e centro de custo ele foi classificado;
- qual fatura contém uma compra e quando ela fecha ou vence;
- o que precisa de revisão e por quê;
- quais compromissos ainda vencem;
- o que está apenas no aparelho, em backup ou aguardando sync.

### Personas de referência

- **Pessoa responsável:** configura o app, contas, cartões, regras, backup e
  visão consolidada da família.
- **Membro familiar:** aparece como titular, pagador ou beneficiário, mesmo
  quando não possui login.
- **Dependente:** recebe despesas ou receitas destinadas a ele, sem precisar
  operar o aplicativo.

## 3. Princípios obrigatórios de produto e UX

1. **Offline primeiro:** operações diárias não dependem de login ou internet.
2. **Verdade antes da automação:** incerteza gera revisão, não confirmação
   silenciosa.
3. **Instrumentos inequívocos:** conta e cartão do mesmo banco nunca aparecem
   apenas com o nome do banco.
4. **Progressão, não formulário gigante:** mostrar primeiro o essencial e
   revelar detalhes quando necessários.
5. **Linguagem humana:** nunca expor nomes como `provider`, `brand`, `opId`,
   `payload`, `staging` ou `targetAccountId` ao usuário.
6. **Origem preservada:** o título amigável pode mudar; o texto original de
   notificação/OFX/CSV permanece auditável e somente leitura.
7. **Ação real:** não oferecer botões que apenas fingem importar, sincronizar,
   pagar ou restaurar.
8. **Recuperação clara:** confirmar, desfazer, tentar novamente, fazer backup e
   voltar devem estar próximos do problema.
9. **Privacidade explícita:** explicar o que fica local, o que sai do aparelho
   e quais permissões continuam concedidas pelo Android.
10. **Acessibilidade desde o desenho:** texto, semântica e forma acompanham
    cor e ícone.

## 4. Arquitetura de informação

A navegação principal possui exatamente cinco destinos:

| Destino | Propósito | Regra de composição |
| --- | --- | --- |
| Resumo | leitura do mês, faturas e compromissos | visão, não administração |
| Revisão | itens que exigem decisão | fila acionável e explicável |
| Novo | lançamento rápido | ação central, passo a passo |
| Movim. | consulta e auditoria | busca, filtros e lista densa |
| Ajustes | cadastros e operações de suporte | hub organizado por assunto |

“Filtros” é uma ação dentro de Movimentações, nunca um destino principal.
Onboarding aparece antes da navegação. Detalhes, formulários, importação,
faturas e configurações são jornadas filhas.

## 5. Catálogo completo de funcionalidades

### 5.1 Onboarding e ambiente inicial

| Estado | Funcionalidade | Valor e comportamento real |
| --- | --- | --- |
| `[IMPLEMENTADO]` | primeira abertura vazia | não cria transações demonstrativas sem escolha |
| `[IMPLEMENTADO]` | configuração inicial | cria pessoa principal, primeira conta e categorias opcionais |
| `[IMPLEMENTADO]` | demonstração explícita | carrega dados fictícios somente após ação da pessoa |
| `[IMPLEMENTADO]` | retorno após reset | volta ao onboarding sem seed financeiro |
| `[PROPOSTO]` | onboarding progressivo | jornada em nove etapas descrita na seção 6 |
| `[PROPOSTO]` | catálogo visual de instituições | substitui digitação técnica do banco por busca e seleção |

**Fluxo vigente:** boas-vindas → configurar dados ou explorar demonstração →
nome → primeira conta → categorias iniciais → concluir.

**Estados obrigatórios no redesign:** primeira abertura, progresso, voltar sem
perder dados, validação contextual, salvamento, falha recuperável, conclusão e
retomada após interrupção.

**Restrição:** o catálogo padrão oferece opções. Ele nunca cria conta, cartão,
saldo ou transação automaticamente.

### 5.2 Pessoas e estrutura familiar

| Estado | Funcionalidade | Valor e comportamento real |
| --- | --- | --- |
| `[IMPLEMENTADO]` | pessoas | adulto, dependente ou outro membro |
| `[IMPLEMENTADO]` | titularidade | contas e cartões podem ter proprietário |
| `[IMPLEMENTADO]` | papéis financeiros | pagador e múltiplos beneficiários por lançamento |
| `[IMPLEMENTADO]` | estrutura familiar | visão de pessoas, instrumentos, recorrências e parcelas |
| `[IMPLEMENTADO]` | arquivamento lógico | preserva histórico sem oferecer o item em novas seleções |

**Fluxo:** Ajustes → Estrutura familiar/Cadastros → Pessoas → criar ou editar →
definir tipo → salvar localmente.

**Estados:** família vazia, um único responsável, vários membros, dependentes,
nomes longos, pessoa arquivada e erro de leitura.

### 5.3 Contas e cartões

| Estado | Funcionalidade | Valor e comportamento real |
| --- | --- | --- |
| `[IMPLEMENTADO]` | contas | nome, instituição, tipo, moeda, titular e final |
| `[IMPLEMENTADO]` | cartões | nome, instituição, titular, bandeira, final, fechamento e vencimento |
| `[IMPLEMENTADO]` | apresentação inequívoca | nome + banco + tipo + titular + últimos dígitos |
| `[IMPLEMENTADO]` | criação contextual | instrumento ausente pode ser criado durante importação |
| `[IMPLEMENTADO]` | atividade/arquivamento | inativos permanecem no histórico |
| `[PROPOSTO]` | catálogo brasileiro | instituições e bandeiras da seção 7 |
| `[PROPOSTO]` | assets locais | logo permitido ou monograma vetorial consistente |
| `[PROPOSTO]` | recentes e busca | seletor prioriza escolhas recentes e aceita aliases |

**Exemplo obrigatório:**

- `Nubank Crédito` — Nubank · Cartão de crédito · Paulo · •5678;
- `Nubank Conta` — Nubank · Conta corrente · Paulo · •1234.

**Estados:** vazio, conta sem final, cartão sem bandeira, mesmo banco com vários
titulares, instrumento arquivado, “Outra instituição” e nomes extensos.

### 5.4 Categorias, centros de custo e estabelecimentos

| Estado | Funcionalidade | Valor e comportamento real |
| --- | --- | --- |
| `[IMPLEMENTADO]` | categorias | receita/despesa, nome, ícone, cor, ordem e atividade |
| `[IMPLEMENTADO]` | centros de custo | nome, ícone, cor e atividade |
| `[IMPLEMENTADO]` | sugestões visuais | ícone e cor sugeridos pelo nome/tipo |
| `[IMPLEMENTADO]` | criação inline | cria categoria/centro e retorna com seleção aplicada |
| `[IMPLEMENTADO]` | fallback | registros antigos nunca ficam sem representação |
| `[CONDICIONAL]` | estabelecimentos | entidade e normalização existem; não há CRUD público completo |

**Fluxo:** Novo/Editar → Categoria ou Centro → opção inexistente → Criar →
nome/ícone/cor → Salvar → retorno com o novo item selecionado.

**Estados:** padrão inicial, item customizado, arquivado, vazio, duplicidade de
nome, ícone desconhecido e cor com contraste insuficiente.

### 5.5 Lançamento manual, detalhe e edição

| Estado | Funcionalidade | Valor e comportamento real |
| --- | --- | --- |
| `[IMPLEMENTADO]` | novo lançamento | receita, despesa ou transferência com valor/data/título |
| `[IMPLEMENTADO]` | classificações | conta/cartão, categoria, centro, pagador e beneficiários |
| `[IMPLEMENTADO]` | título amigável | editável e usado em listas |
| `[IMPLEMENTADO]` | descrição original | preservada e somente leitura para fontes externas |
| `[IMPLEMENTADO]` | detalhe em leitura | editar exige ação explícita |
| `[IMPLEMENTADO]` | validação de instrumento | impede referência a conta inexistente |

**Fluxo:** Novo → tipo → valor → data → título → instrumento → classificação
→ participantes → salvar. Campos avançados aparecem apenas quando aplicáveis.

**Estados:** formulário vazio, erro por campo, salvando, salvo, falha
recuperável, transferência, descrição externa e classificação criada inline.

### 5.6 Caixa de Revisão

| Estado | Funcionalidade | Valor e comportamento real |
| --- | --- | --- |
| `[IMPLEMENTADO]` | fila pendente | reúne notificações, importações e conflitos ainda não consolidados |
| `[IMPLEMENTADO]` | filtros | todos, sugestões, duplicidades e conflitos |
| `[IMPLEMENTADO]` | confirmar | remove imediatamente da fila e registra operação local |
| `[IMPLEMENTADO]` | editar | abre detalhe real antes da decisão |
| `[IMPLEMENTADO]` | ignorar | resolve o item sem transformá-lo em movimento consolidado |
| `[IMPLEMENTADO]` | desfazer | feedback temporário e reversível |
| `[IMPLEMENTADO]` | converter transferência | disponível quando há indício explicável |
| `[IMPLEMENTADO]` | conflitos de sync | preserva versões local/remota para decisão humana |

**Estados:** caixa zerada, filtro vazio, item sugerido, provável duplicidade,
conflito financeiro, confirmação, desfazer expirado e erro de consulta.

### 5.7 Regras de classificação

| Estado | Funcionalidade | Valor e comportamento real |
| --- | --- | --- |
| `[IMPLEMENTADO]` | regras locais | termo de correspondência, categoria, centro e prioridade |
| `[IMPLEMENTADO]` | ativar/arquivar | controla aplicação sem apagar histórico |
| `[IMPLEMENTADO]` | explicação | indica regra responsável quando disponível |
| `[IMPLEMENTADO]` | baixa confiança | mantém lançamento em revisão |
| `[FORA DO ESCOPO]` | confirmação autônoma incerta | nunca consolidar gasto duvidoso silenciosamente |

### 5.8 Resumo financeiro

| Estado | Funcionalidade | Valor e comportamento real |
| --- | --- | --- |
| `[IMPLEMENTADO]` | saldo do período | receitas menos despesas confirmadas |
| `[IMPLEMENTADO]` | entradas e saídas | valores separados e legíveis |
| `[IMPLEMENTADO]` | transferências internas | visíveis, mas fora da receita/despesa familiar |
| `[IMPLEMENTADO]` | pendências | quantidade e valor aguardando revisão |
| `[IMPLEMENTADO]` | leituras | pessoa, categoria, centro de custo e origem |
| `[IMPLEMENTADO]` | compromissos próximos | recorrências e parcelas futuras |
| `[IMPLEMENTADO]` | últimas movimentações | lista densa com abertura do detalhe |
| `[PROPOSTO]` | alternância calendário/fatura | deixar o critério temporal explícito no Resumo |

**Estados:** mês sem dados, somente receitas, somente despesas, valor grande,
transferências, pendências, várias fontes e compromissos vencidos/próximos.

### 5.9 Movimentações, busca e filtros

| Estado | Funcionalidade | Valor e comportamento real |
| --- | --- | --- |
| `[IMPLEMENTADO]` | lista consolidada | todos os lançamentos com densidade de leitura |
| `[IMPLEMENTADO]` | busca | título, texto original, estabelecimento, pessoa e provedor |
| `[IMPLEMENTADO]` | filtros rápidos | todos, despesas, entradas, transferências e ajustes |
| `[IMPLEMENTADO]` | filtros avançados | período, pessoa, instrumento, categoria, centro, status e origem |
| `[IMPLEMENTADO]` | limpar filtros | restaura visão padrão |
| `[IMPLEMENTADO]` | detalhe | toque abre lançamento real |
| `[IMPLEMENTADO]` | atalho de importação | CSV/OFX permanece contextual à consulta |

**Estados:** longa lista, nenhum resultado, múltiplos filtros, filtro ativo,
busca sem acento, item pendente/revisado e erro local.

### 5.10 Captura Android de notificações

| Estado | Funcionalidade | Valor e comportamento real |
| --- | --- | --- |
| `[CONDICIONAL]` | listener Android | captura somente com permissão do sistema |
| `[CONDICIONAL]` | allowlist | começa vazia e monitora apenas apps escolhidos |
| `[CONDICIONAL]` | persistência imediata | grava evento bruto em SQLite nativo |
| `[CONDICIONAL]` | processamento local | reconhece valor/instituição e cria rascunho ou mescla fonte |
| `[CONDICIONAL]` | recuperação | WorkManager e drenagem paginada/idempotente |
| `[CONDICIONAL]` | diagnóstico | permissão, apps, fila, última drenagem e erros |
| `[CONDICIONAL]` | expurgo | remove apenas eventos entregues segundo política local |

**Dependências:** Android físico, permissão de acesso às notificações e
notificação compatível. Preview web deve mostrar “Disponível apenas no
Android”, nunca sucesso fictício.

### 5.11 Importação CSV e OFX

| Estado | Funcionalidade | Valor e comportamento real |
| --- | --- | --- |
| `[IMPLEMENTADO]` | seleção de arquivo | CSV e OFX locais |
| `[IMPLEMENTADO]` | detecção | formato, encoding, separador e decimal |
| `[IMPLEMENTADO]` | OFX bancário/cartão | distingue `BANKACCTFROM` e `CCACCTFROM` |
| `[IMPLEMENTADO]` | identidade | conta, tipo, moeda, período e saldos quando presentes |
| `[IMPLEMENTADO]` | mapeamento CSV | data, descrição e valor em arquivo desconhecido |
| `[IMPLEMENTADO]` | destino confirmado | conta/cartão explícito antes da promoção |
| `[IMPLEMENTADO]` | criação contextual | cria instrumento ausente e volta ao lote |
| `[IMPLEMENTADO]` | prévia e resultado | novos, inválidos, duplicados, total e revisão |
| `[IMPLEMENTADO]` | histórico | lote, arquivo, identidade, destino e estado |
| `[IMPLEMENTADO]` | idempotência | hashes de arquivo e linha evitam repetição exata |
| `[FORA DO ESCOPO]` | XLSX e Open Finance | não simular suporte atual |

**Fluxo:** arquivo → detecção/mapeamento → identidade → destino → prévia →
confirmar → resultado. Nenhum empate escolhe a primeira conta silenciosamente.

### 5.12 Duplicidades e conciliação

| Estado | Funcionalidade | Valor e comportamento real |
| --- | --- | --- |
| `[IMPLEMENTADO]` | duplicidade exata | bloqueia mesma identidade/hashes |
| `[IMPLEMENTADO]` | heurística | compara valor, data, instrumento e descrição |
| `[IMPLEMENTADO]` | score e explicação | mostra por que dois registros parecem iguais |
| `[IMPLEMENTADO]` | mesclar fontes | preserva notificação, CSV, OFX e manual na mesma transação |
| `[IMPLEMENTADO]` | decisão humana | casos intermediários permanecem na revisão |

**Estados:** nenhum candidato, alta confiança, provável duplicidade, fontes
divergentes, item já resolvido e falha de consulta.

### 5.13 Transferências e pagamentos de fatura

| Estado | Funcionalidade | Valor e comportamento real |
| --- | --- | --- |
| `[IMPLEMENTADO]` | transferência interna | liga origem/destino e não infla receita/despesa |
| `[IMPLEMENTADO]` | sugestão de pagamento | considera texto, banco, cartão, valor e vencimento |
| `[IMPLEMENTADO]` | confirmação explícita | cria pagamento somente após diálogo |
| `[IMPLEMENTADO]` | origem OFX | preserva conciliação bancária quando aplicável |
| `[IMPLEMENTADO]` | exclusividade | uma transferência ativa não paga duas faturas |

### 5.14 Faturas, estornos e parcelas

| Estado | Funcionalidade | Valor e comportamento real |
| --- | --- | --- |
| `[IMPLEMENTADO]` | ciclo de fatura | período, fechamento, vencimento e competência |
| `[IMPLEMENTADO]` | fatura atual/próxima | navegação por cartão e mês, inclusive vazios |
| `[IMPLEMENTADO]` | total derivado | compras e estornos reais |
| `[IMPLEMENTADO]` | pagamentos | total pago e saldo em aberto sem nova despesa |
| `[IMPLEMENTADO]` | estado efetivo | aberta, fechada, parcial, paga ou atrasada |
| `[IMPLEMENTADO]` | filtros | categoria e pessoa dentro da competência |
| `[IMPLEMENTADO]` | correção manual | vínculo auditável com motivo |
| `[IMPLEMENTADO]` | parcelas projetadas | próximas competências sem criar transação futura |

**Estados:** sem cartão, fatura vazia, aberta, fechada, estorno, pagamento
parcial/total, atrasada, parcela real versus projetada e datas de mês curto.

### 5.15 Compromissos e parcelamentos

| Estado | Funcionalidade | Valor e comportamento real |
| --- | --- | --- |
| `[IMPLEMENTADO]` | recorrências | receitas/despesas/transferências mensais com responsáveis |
| `[IMPLEMENTADO]` | vigência | início, fim, dia do mês e atividade |
| `[IMPLEMENTADO]` | planos | consórcio e compra parcelada com parcela atual/total |
| `[IMPLEMENTADO]` | projeção | compromissos futuros no Resumo e nas faturas |
| `[IMPLEMENTADO]` | cadastro/edição | formulários locais responsivos |

### 5.16 Backup, exportação e restauração

| Estado | Funcionalidade | Valor e comportamento real |
| --- | --- | --- |
| `[IMPLEMENTADO]` | backup JSON | versão, schema, data, família, contagens e dados |
| `[IMPLEMENTADO]` | validação | confere formato/versão antes de restaurar |
| `[IMPLEMENTADO]` | restauração | substituição transacional após confirmação explícita |
| `[IMPLEMENTADO]` | exportação CSV | consulta externa de movimentações, não restauração |
| `[IMPLEMENTADO]` | compartilhar/salvar | arquivo escolhido pela pessoa no Android |
| `[CONDICIONAL]` | segundo aparelho | compatibilidade técnica; homologação física pendente |
| `[FORA DO ESCOPO]` | backup automático em nuvem | não existe e não deve ser simulado |

### 5.17 Zerar aplicativo e dados locais

| Estado | Funcionalidade | Valor e comportamento real |
| --- | --- | --- |
| `[IMPLEMENTADO]` | área de perigo | visível em Ajustes → Dados locais |
| `[IMPLEMENTADO]` | contagens | explica o que será removido |
| `[IMPLEMENTADO]` | oferta de backup | disponível antes da exclusão |
| `[IMPLEMENTADO]` | confirmação forte | exige digitar `ZERAR` |
| `[IMPLEMENTADO]` | limpeza coordenada | Drift, staging, sync, fila nativa, preferências e sessão |
| `[IMPLEMENTADO]` | retorno seguro | fecha estados e volta ao onboarding |

**Restrição:** permissões concedidas no sistema Android não são revogadas pelo
reset. A interface deve explicar isso antes da confirmação.

### 5.18 Login, sync, conflitos e privacidade

| Estado | Funcionalidade | Valor e comportamento real |
| --- | --- | --- |
| `[CONDICIONAL]` | login Google | depende de OIDC, client ID e allowlist configurados |
| `[CONDICIONAL]` | sessão | JWT da API guardado em armazenamento seguro |
| `[CONDICIONAL]` | outbox | operações locais aguardam envio idempotente |
| `[CONDICIONAL]` | push/pull | API Fastify e MongoDB opcionais |
| `[CONDICIONAL]` | device ID | identifica cada instalação no sync |
| `[CONDICIONAL]` | conflitos | versões financeiras concorrentes voltam à Revisão |
| `[IMPLEMENTADO]` | modo local | app continua útil sem login, rede ou MongoDB |
| `[IMPLEMENTADO]` | privacidade | backup Android automático e transferência do banco estão bloqueados |

**Estados:** sync desativado, sem sessão, offline, enviando, fila pendente,
rejeitado, conflito, sucesso e homologação de dois aparelhos pendente.

### 5.19 Segurança, qualidade e distribuição

| Estado | Funcionalidade | Valor e comportamento real |
| --- | --- | --- |
| `[IMPLEMENTADO]` | armazenamento local | Drift/SQLite como fonte de verdade diária |
| `[IMPLEMENTADO]` | assinatura pessoal | release Android assinada fora do Git |
| `[IMPLEMENTADO]` | privacidade de backup | dados financeiros excluídos do backup automático Android |
| `[CONDICIONAL]` | homologação física final | instalação limpa e roteiro completo ainda dependem do aparelho |
| `[PROPOSTO]` | criptografia SQLCipher | evolução de segurança, não promessa vigente |

### 5.20 Fora de escopo confirmado

- `[FORA DO ESCOPO]` integração online com Open Finance nesta versão;
- `[FORA DO ESCOPO]` scraping de internet banking;
- `[FORA DO ESCOPO]` pagamento, Pix ou transferência iniciados pelo app;
- `[FORA DO ESCOPO]` publicação comercial multi-tenant/lojas;
- `[FORA DO ESCOPO]` iOS capturando notificações bancárias;
- `[FORA DO ESCOPO]` confirmação automática de classificação incerta;
- `[FORA DO ESCOPO]` upload automático de OFX ou notificação bruta à nuvem;
- `[FORA DO ESCOPO]` ação visual sem comportamento real correspondente.

## 6. Onboarding alvo em nove etapas

O onboarding deve ser uma jornada curta, salvável e compreensível. Mostrar
progresso (`Etapa 2 de 9`), voltar sem perder respostas e permitir pular apenas
etapas opcionais.

### Etapa 1 — Boas-vindas e privacidade

- promessa: “Organize as finanças da família sem depender da internet”;
- três benefícios curtos: revisar antes de consolidar, importar OFX/CSV e
  acompanhar contas/cartões/faturas;
- aviso: dados financeiros ficam neste aparelho por padrão;
- ações: `Começar configuração` e `Explorar demonstração`.

### Etapa 2 — Pessoa principal

- nome pelo qual a pessoa quer ser chamada;
- explicação de que membros familiares podem ser adicionados depois;
- nenhum pedido de CPF, endereço ou dado desnecessário.

### Etapa 3 — Instituição

- busca por nome ou alias;
- grade visual de instituições frequentes;
- seção `Usadas recentemente` quando houver histórico;
- opções `Outra instituição` e `Dinheiro/carteira` sempre visíveis;
- seleção mostra logo permitido ou monograma, nome e tipos suportados.

### Etapa 4 — Tipo de instrumento

- conta corrente, poupança, conta de pagamento/carteira ou cartão de crédito;
- ocultar tipos não aplicáveis à instituição escolhida sem impedir `Outro`;
- explicar em uma linha a diferença entre conta e cartão.

### Etapa 5 — Identificação

- nome amigável sugerido, editável;
- titular preselecionado;
- quatro últimos dígitos opcionais;
- prévia em tempo real do `InstrumentDisplay` final.

### Etapa 6 — Dados do cartão

Somente para cartão:

- bandeira visual e pesquisável;
- dia de fechamento e vencimento entre 1 e 31;
- explicação simples: fechamento define em qual fatura a compra entra;
- não inferir datas silenciosamente quando não houver evidência.

### Etapa 7 — Categorias iniciais

- seleção revisável das sugestões: Mercado, Casa, Saúde, Transporte, Educação,
  Lazer, Renda, Transferência e Ajuste;
- mostrar ícone e cor; permitir continuar sem categorias sugeridas.

### Etapa 8 — Como adicionar movimentos

- manual funciona imediatamente;
- OFX/CSV pode ser configurado depois;
- notificações exigem Android e permissão específica, concedida apenas quando a
  pessoa abrir a configuração do sistema;
- não pedir login nem permissão nesta etapa.

### Etapa 9 — Revisão e conclusão

- resumo da pessoa, instrumento e categorias;
- ações `Editar` por bloco;
- `Concluir configuração` cria somente os dados confirmados;
- sucesso leva ao Resumo com orientação breve para Novo, Revisão e Importar.

## 7. Catálogo proposto de instituições e bandeiras

### 7.1 Contratos do protótipo

```ts
type InstrumentType =
  | 'checking'
  | 'savings'
  | 'wallet'
  | 'credit_card'

interface FinancialInstitutionOption {
  id: string
  displayName: string
  aliases: string[]
  assetKey: string
  brandColor: string
  supportedInstrumentTypes: InstrumentType[]
}

interface CardNetworkOption {
  id: string
  displayName: string
  assetKey: string
}
```

`id` deve ser estável e compatível com o `provider` legado sempre que possível.
`assetKey` referencia arquivo local. `brandColor` serve como detalhe de
identidade, nunca como fundo obrigatório nem único significado.

### 7.2 Instituições iniciais

| ID | Nome | Aliases úteis | Tipos sugeridos |
| --- | --- | --- | --- |
| `banco_do_brasil` | Banco do Brasil | BB | corrente, poupança, cartão |
| `caixa` | Caixa | Caixa Econômica, CEF | corrente, poupança, cartão |
| `itau` | Itaú | Itaú Unibanco | corrente, poupança, cartão |
| `bradesco` | Bradesco | Next | corrente, poupança, cartão |
| `santander` | Santander | SX | corrente, poupança, cartão |
| `nubank` | Nubank | Nu, NuBank | conta de pagamento, cartão |
| `inter` | Inter | Banco Inter | corrente, cartão |
| `c6` | C6 Bank | Banco C6 | corrente, cartão |
| `mercado_pago` | Mercado Pago | MercadoPago, MP | conta de pagamento, cartão |
| `pagbank` | PagBank | PagSeguro | conta de pagamento, cartão |
| `picpay` | PicPay | Pic Pay | conta de pagamento, cartão |
| `neon` | Neon | Banco Neon | conta de pagamento, cartão |
| `btg_pactual` | BTG Pactual | BTG, BTG Banking | corrente, cartão |
| `sicredi` | Sicredi | Cooperativa Sicredi | corrente, poupança, cartão |
| `sicoob` | Sicoob | Bancoob | corrente, poupança, cartão |
| `other` | Outra instituição | Outro banco | todos |
| `cash_wallet` | Dinheiro/carteira | Dinheiro, espécie | carteira |

Esta é uma curadoria de cobertura para reduzir digitação; não é ranking de
qualidade, recomendação financeira nem lista exaustiva.

### 7.3 Bandeiras iniciais

| ID | Nome exibido | Política visual |
| --- | --- | --- |
| `visa` | Visa | asset permitido ou texto/monograma |
| `mastercard` | Mastercard | asset permitido ou círculos abstratos próprios |
| `elo` | Elo | asset permitido ou monograma |
| `amex` | American Express | asset permitido ou `AMEX` tipográfico |
| `hipercard` | Hipercard / Hiper | asset permitido ou monograma |
| `cabal` | Cabal | asset permitido ou monograma |
| `other` | Outra | ícone genérico de cartão |

### 7.4 Política de assets

1. Preferir kit oficial cuja página permita uso de marca para identificação.
2. Guardar o arquivo no projeto; nunca usar hotlink externo.
3. Registrar origem e data em `public/brands/ATTRIBUTION.md`.
4. Se a permissão não estiver clara, criar monograma original neutro.
5. Não redesenhar logo oficial de forma parecida nem usar ícone de aplicativo
   bancário extraído do aparelho.
6. Todo asset precisa de fallback textual e semântica acessível.

## 8. Inventário de telas para o protótipo

| Rota | Tela | Estado funcional | Estados mínimos no Lovable |
| --- | --- | --- | --- |
| `/onboarding` | configuração inicial | implementado básico; redesign proposto | boas-vindas, 9 etapas, erro, conclusão |
| `/summary` | Resumo | implementado | mês cheio, vazio, pendências, faturas |
| `/` | Revisão | implementado | fila, vazio, duplicidade, conflito |
| `/review` | redirecionamento | implementado | redirecionar para `/` |
| `/transaction/new` | Novo | implementado | receita, despesa, transferência, inline |
| `/transaction/$id` | Detalhe | implementado | leitura, edição, descrição original |
| `/movimentacoes` | Movim. | implementado | busca, chips, sheet, vazio, longa lista |
| `/settings` | Ajustes | implementado | status reais e agrupamento por assunto |
| `/registries` | Cadastros | implementado no Flutter | pessoas, contas, cartões, categorias, centros |
| `/family` | Família | implementado | membros, instrumentos, responsabilidades |
| `/invoices` | Faturas | implementado no Flutter | aberta, parcial, paga, atrasada, projeções |
| `/commitments` | Compromissos | implementado no Flutter | recorrências, parcelas, vazio |
| `/import` | Importar | implementado | etapas, destino, prévia, resultado, histórico |
| `/duplicates` | Duplicidades | implementado | comparação, score, mescla, vazio |
| `/rules` | Regras | implementado | lista, editor, explicação, vazio |
| `/backup` | Backup | implementado | exportar, validar, confirmar restauração |
| `/notifications` | Captura Android | condicional | indisponível web, permissão, allowlist, fila |
| `/sync-privacy` | Sync e privacidade | condicional | desligado, offline, fila, conflito, sucesso |
| `/data` | Dados locais/reset | implementado | contagens, backup, `ZERAR`, conclusão |

## 9. Sistema visual e regras de usabilidade

- mobile-first; protótipo centralizado em no máximo 440 px;
- validar 360×800 e 390×844;
- margem lateral usual de 16 px e grade de 4 px;
- superfícies claras, borda/sombra discretas e raios consistentes;
- tipografia Inter ou equivalente de alta legibilidade;
- título compacto, subtítulo que explica contexto e uma ação principal;
- listas financeiras densas; não transformar cada linha em cartão alto;
- chips horizontais para filtros rápidos e bottom sheet para filtros avançados;
- botão primário único por etapa; ações destrutivas separadas;
- alvo mínimo de toque 48×48 dp;
- contraste mínimo 4,5:1 para texto pequeno;
- ícones sempre acompanhados por texto, tooltip ou semântica;
- valores positivos/negativos usam sinal, texto e cor;
- texto ampliado a 1,3 sem truncar informação essencial;
- teclado não pode encobrir CTA nem confirmação;
- snackbar temporário não acompanha troca de rota;
- loading, vazio, erro, offline e sucesso refletem estado real;
- campos técnicos ficam em detalhe explicativo, nunca no fluxo principal;
- usar português brasileiro com acentuação e termos financeiros explicados.

## 10. Cenário demonstrativo anônimo

Usar somente estes dados fictícios no protótipo:

- pessoas: Paulo, Marina, Sofia e Liz;
- instrumentos:
  - Nubank Conta · Conta corrente · Paulo · •1234;
  - Nubank Crédito · Mastercard · Paulo · •5678;
  - Mercado Pago Marina · Conta de pagamento · Marina · •9012;
- categorias: Mercado, Casa, Saúde, Transporte, Educação, Lazer, Renda,
  Transferência e Ajuste;
- centros: Casa, Filhos, Pessoal, Carro e Trabalho;
- movimentos: salário, aluguel, energia, Netflix, transporte, farmácia,
  estorno, escola e pagamento de fatura;
- fatura com compras, estorno, parcela projetada e pagamento parcial;
- um item pendente, uma provável duplicidade e um conflito de sync fictício;
- nenhum CPF, email real, banco real do usuário, OFX pessoal ou notificação
  capturada do aparelho.

## 11. Critérios de aceite do protótipo

1. Todas as rotas da seção 8 existem e compartilham o mesmo sistema visual.
2. A navegação principal contém apenas os cinco destinos canônicos.
3. Onboarding é compreensível sem conhecimento financeiro e cabe nos dois
   viewports.
4. Conta e cartão Nubank são reconhecíveis sem depender do ícone.
5. Instituição e bandeira usam asset local ou fallback consistente.
6. Nenhum texto técnico `provider`, `brand`, `payload`, `outbox` ou ID interno
   aparece para a pessoa.
7. Não existem CTA fictício de sync, importação, pagamento ou restauração.
8. Estados vazio, erro, loading, offline, sucesso e confirmação estão
   desenhados onde aplicáveis.
9. Não há overflow, ação encoberta, contraste insuficiente ou alvo pequeno.
10. `npm run build` e `npm run lint` passam no repositório visual.
11. O commit Lovable aprovado é registrado como novo baseline, sem reescrever
    histórico do Git.

## 12. Prompt mestre para o Lovable

Copie o conteúdo abaixo juntamente com este arquivo:

```text
Redesenhe integralmente a interface mobile do ZimbaControl dentro deste projeto
existente. Leia primeiro todo o arquivo FUNCTIONAL_CATALOG_AND_UX_BRIEF.md e
trate-o como fonte funcional e de UX. As seis tentativas anteriores são apenas
histórico: preserve rotas e integração Git, mas não mantenha uma composição
visual ruim por compatibilidade.

O produto final é um app Android Flutter offline-first; este projeto React é
somente o laboratório visual. Use mocks anônimos e interativos. Não implemente
backend, não conecte banco, não simule importação/sync/captura como se fossem
reais e não copie dados pessoais.

Trabalhe no mesmo sistema de design e entregue em quatro blocos coerentes:

1. Design system, AppShell, navegação de cinco destinos e onboarding completo
   em nove etapas, com catálogo visual pesquisável de instituições e bandeiras.
2. Resumo, Revisão, Novo, Detalhe e Movimentações.
3. Cadastros, Família, Faturas e Compromissos.
4. Importação, Duplicidades, Backup, Captura Android, Regras, Sync/Privacidade
   e Dados locais/Reset.

Crie as rotas ausentes /onboarding, /registries, /invoices, /commitments,
/notifications e /data. Mantenha /review redirecionando para /. Use somente os
dados demonstrativos anônimos do briefing.

O onboarding deve ser a principal referência de qualidade: progressivo,
acolhedor, claro sobre privacidade, com seleção visual de banco, conta versus
cartão, titular, final, bandeira, fechamento e vencimento. Opções padrão não
criam instrumentos automaticamente. Nunca exiba os termos provider ou brand.

Implemente FinancialInstitutionOption e CardNetworkOption conforme o contrato
do briefing. Assets de marca precisam ser locais e só podem usar logo oficial
quando houver fonte/uso permitido; caso contrário use monograma original com
fallback textual. Não use hotlinks.

Visual: fintech familiar clean, fundo claro, texto #0F172A, acento ciano/azul,
Inter, bordas discretas, grade de 4 px, margem de 16 px, listas densas, cards
somente quando agregarem hierarquia. Evite cards gigantes, excesso de espaço,
ícones sem texto, filtros abertos ocupando a tela e totais repetidos.

Valide todas as telas em 360x800 e 390x844, texto 1.3, nomes/valores longos,
teclado, sheets e diálogos. Todo controle deve ter alvo de 48 px e semântica.
Inclua loading, vazio, erro, offline e sucesso reais. Corrija todo overflow e
garanta que npm run build e npm run lint passem.

Não finalize apenas a primeira tela. Entregue todas as rotas do inventário e,
ao terminar, apresente uma lista de rotas criadas, componentes compartilhados,
assets/fallbacks e diferenças deliberadas.
```

## 13. Referências

- `docs/product/PRODUCT_REQUIREMENTS.md` — requisitos canônicos vigentes;
- `docs/product/VISUAL_PARITY_AUDIT.md` — auditoria do protótipo anterior;
- `docs/context/ARCHITECTURE.md` — domínio e restrições técnicas;
- `docs/context/CURRENT_STATE.md` — estado operacional do repositório;
- [Banco Central — ranking e quantidade de clientes](https://dadosabertos.bcb.gov.br/dataset/ranking-de-instituicoes-por-indice-de-reclamacoes);
- [Abecs — mercado e bandeiras de pagamento](https://api.abecs.org.br/wp-content/uploads/2019/11/Cartilha-da-Abecs-sobre-o-Mercado-de-Meios-de-Pagamento.pdf);
- [Android — qualidade de apps](https://developer.android.com/docs/quality-guidelines/core-app-quality);
- [WCAG — contraste e acessibilidade](https://www.w3.org/WAI/WCAG22/quickref/).
