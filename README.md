# Casa de Leilões

Projeto de estudo: leilão inglês em tempo real, com Rails, Inertia.js, Vue, packs, dry-rb e Rails Event Store.

O planejamento segue OpenSpec, no schema `planning`. O comportamento atual está em `openspec/specs/`: `auction-catalog`, `live-bidding` e `realtime-feed`.

Os changes concluídos estão em `openspec/changes/archive/`. O primeiro, `establish-auction-platform`, entregou o leilão. Os seguintes só reorganizaram pastas, sem mudar o comportamento. Fechamento, pagamento, Saga e Outbox ficam para changes seguintes.

No frontend, `app/frontend/domain` é a leitura, `data` os casos de uso, `infra` os adapters e `ui` as páginas e os componentes. `composition.ts` fica na raiz do frontend. No pack `auctions`, as pastas são `domain`, `data`, `infra` e `public`.

Em desenvolvimento, `bin/dev` sobe o Rails e o Vite. Os participantes de exemplo estão em `db/seeds.rb`.
