# RFC

## Contexto

O PRD pede os nomes `data` e `infra` no lugar de `application` e `infrastructure`, sem mudar o leilão. Não há delta de spec: o comportamento continua em `openspec/specs/`.

Hoje o pack `auctions` separa `app/domain`, `app/application`, `app/infrastructure` e `app/public`. O Rails trata cada uma dessas pastas como raiz de autoload, então as constantes continuam `Auctions::*`. O frontend separa `app/frontend/domain`, `application`, `infrastructure`, `pages` e `components`. Os imports vivos estão em `composition.ts` e em `infrastructure/inertia-commands.ts`.

## Decisões

### D1. Dois renomes, nos dois lados

- Status: aceita
- Decisão: `application` vira `data` e `infrastructure` vira `infra` em `app/frontend` e em `packs/auctions/app`. O bounded context continua sendo o pack `auctions`.
- Alternativas: renomear só o frontend. O PRD pede o mesmo vocabulário nos dois lados.
- Consequências: casos de uso ficam em `data` e adapters ficam em `infra`. Domínio, páginas e a API pública não mudam de pasta.

### D2. Constantes Ruby permanecem

- Status: aceita
- Decisão: `Auctions::PlaceBid`, `Auctions::EventStoreRepository` e as demais constantes do pack continuam com o mesmo nome. A pasta nova continua sendo raiz de autoload, como `application` e `infrastructure` já são.
- Alternativas: criar módulos `Data::` e `Infra::`. O nome da pasta não faz parte da constante hoje, e o PRD não pede trocar a API do pack.
- Consequências: o container dry-system, o event store, a concorrência otimista e o publicador do canal não mudam de contrato. Só o caminho do arquivo muda.

### D3. O que não se chama application

- Status: aceita
- Decisão: não renomear `config/application.rb`, `app/frontend/entrypoints/application.ts`, `Rails.application` nem o histórico em `openspec/changes/archive`.
- Alternativas: busca global por `application` e `infrastructure`. Isso alteraria o boot do Rails e o ponto de entrada do Vite.
- Consequências: a troca fica restrita às duas camadas do recorte.

### D4. Imports do cliente acompanham a pasta

- Status: aceita
- Decisão: `composition.ts` e o adapter de comandos passam a importar `./data` e `./infra`. O composition root continua entregando Inertia e Action Cable. O domínio do cliente continua sem Vue, Inertia e Action Cable.
- Alternativas: deixar alias no Vite com os nomes antigos. O alias esconderia o nome que o PRD quer visível.
- Consequências: a sala, a publicação e a troca de participante seguem o mesmo fluxo. O teste Vitest acompanha o arquivo movido.

### D5. Padrões que não entram agora

- Status: aceita
- Decisão: não introduzir Saga, Outbox nem Unit of Work. Event sourcing, versão esperada do stream e o broadcast depois do commit permanecem como já estão.
- Alternativas: aproveitar o rename para extrair uma unidade de trabalho genérica. O comportamento deste change não precisa disso.
- Consequências: a comunicação entre o pack e a web continua pela API pública `Auctions` e pelo canal já existente.

## Decisões adiadas

- Fechamento do leilão, pagamento, anti-snipe e autenticação real.
- Um segundo pack e a comunicação entre bounded contexts além da API pública atual.
