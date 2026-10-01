# RFC

## Contexto

O PRD pede uma pasta `ui` para páginas e componentes, sem mudar o leilão. Não há delta de spec: o comportamento continua em `openspec/specs/`.

Hoje `app/frontend` tem `domain`, `data`, `infra`, `pages`, `components`, `composition.ts`, `entrypoints` e `types`. O Inertia resolve as telas por `pages: "../pages"` em `entrypoints/inertia.ts`. Os controllers pedem `home/index`, `auctions/new` e `auctions/show`. O pack `auctions` não entra neste recorte.

## Decisões

### D1. Uma pasta ui para a interface

- Status: aceita
- Decisão: mover `app/frontend/pages` para `app/frontend/ui/pages` e `app/frontend/components` para `app/frontend/ui/components`. Não criar pasta de layout: não existe uma hoje.
- Alternativas: deixar páginas na raiz e só criar `ui` vazia. A separação que o PRD pede não apareceria.
- Consequências: a interface fica ao lado de `domain`, `data` e `infra`. Novas telas nascem dentro de `ui`.

### D2. Nomes de tela do Inertia permanecem

- Status: aceita
- Decisão: o entrypoint passa a resolver `../ui/pages`. Os controllers continuam pedindo `home/index`, `auctions/new` e `auctions/show`.
- Alternativas: mudar o nome da tela para `ui/pages/auctions/show`. Isso alteraria o contrato entre Rails e Vue sem mudança de comportamento.
- Consequências: o glob do Inertia acompanha a pasta. A publicação e a sala continuam as mesmas rotas.

### D3. O composition root fica fora de ui

- Status: aceita
- Decisão: `composition.ts`, `domain`, `data`, `infra`, `entrypoints` e `types` permanecem onde estão. `ui` importa casos de uso já compostos e o domínio de leitura. Não importa o cliente do canal.
- Alternativas: mover `composition.ts` para dentro de `ui`. O composition root liga `data` e `infra`; colocá-lo na interface misturaria a montagem com a tela.
- Consequências: os imports das páginas ganham um nível até `composition.ts` e `domain`. O import entre `pages` e `components` continua relativo dentro de `ui`.

### D4. Padrões que não entram agora

- Status: aceita
- Decisão: não introduzir Saga, Outbox nem Unit of Work. Event sourcing, concorrência do lance e o broadcast depois do commit permanecem no pack `auctions`. A web continua chamando a API pública.
- Alternativas: aproveitar o move para extrair um design system. O PRD não pede componente novo.
- Consequências: dry-system, stream e canal não mudam. Este change só reorganiza a interface Vue.

## Decisões adiadas

- Pasta de layouts, design system e novas telas.
- Fechamento, pagamento, anti-snipe e autenticação real.
