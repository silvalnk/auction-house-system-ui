---
name: auction-platform
description: Orienta a casa de leilões em Rails, Inertia, Vue, packs, dry-rb e Rails Event Store. Use ao implementar ou revisar código em auction_house, leilão, lance, event sourcing, pack auctions ou Action Cable.
---

# Casa de Leilões

Antes de alterar código, leia `openspec/specs/`, o change ativo em `openspec/changes/` e o `openspec/config.yaml`. O schema do projeto é `planning`.

## Comportamento atual

O sistema publica leilão inglês e aceita um lance vencedor em tempo real. Os changes concluídos estão em `openspec/changes/archive/`.

Saga, Outbox, Unit of Work genérico, fechamento, pagamento e cadastro de usuários só entram quando um change novo os especificar.

## Fronteiras

- A regra de lance mora no pack `auctions` e não referencia Rails, Inertia, Action Cable nem ActiveRecord.
- A web chama `Auctions.create_auction`, `Auctions.place_bid` e a consulta da projeção.
- No pack, as pastas são `domain`, `data`, `infra` e `public`. As constantes continuam `Auctions::*`.
- No frontend, `domain` não importa Vue, Inertia nem Action Cable. `data` são os casos de uso, `infra` os adapters e `ui` as páginas e os componentes. `composition.ts` fica fora de `ui`.
- O stream `Auction$<id>` decide o lance. A tabela de leitura não decide.
- `BidAccepted` é gravado com a versão esperada do stream. Lance recusado não vira evento.
- O canal publica só depois do commit e só para lance aceito.
- Preço é inteiro em centavos de BRL.

## Verificação

Rode o teste do grupo que você alterou. A disputa de dois lances sobre o mesmo preço termina com um único evento aceito.
