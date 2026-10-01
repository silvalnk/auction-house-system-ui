# RFC

## Contexto

O PRD deste change pede publicação de um leilão inglês e aceite de um único lance vencedor, com a sala mostrando só o que foi confirmado. As specs em `specs/` definem esse comportamento. O desenho abaixo vale para esse recorte. Saga, Outbox e Unit of Work ficam registrados como decisões adiadas porque nenhum efeito externo ou escrita em mais de um agregado aparece aqui.

## Decisões

### D1. Um agregado Auction no pack auctions

- Status: aceita
- Decisão: o leilão aberto e os lances aceitos formam um único agregado. O pack `auctions` é o único bounded context deste change. A interface Inertia fica fora do pack e chama a API pública dele.
- Alternativas: separar `catalog` e `bidding` agora. Isso partiria o agregado e criaria consistência entre packs antes de existir um segundo contexto real.
- Consequências: o primeiro pack fica coeso. O pack `settlement` só nasce no change que introduzir cobrança.

### D2. Event sourcing do leilão

- Status: aceita
- Decisão: o estado que decide um lance é reconstituído pelo stream `Auction$<id>` no Rails Event Store. A publicação emite `AuctionOpened`. Cada lance aceito emite `BidAccepted`. Lance recusado não entra no stream.
- Alternativas: linha mutável com `lock` no PostgreSQL. Protege a corrida, mas não deixa o histórico do preço como fonte da decisão.
- Consequências: a concorrência usa a versão esperada do stream. Uma projeção separada serve à tela e não decide o próximo lance.

### D3. Concorrência otimista

- Status: aceita
- Decisão: `PlaceBid` grava `BidAccepted` somente se a versão lida do stream ainda for a versão esperada. Se outro lance confirmou antes, o comando recarrega o stream uma vez. Se o preço já não for superado, devolve recusa. Não há fila de lances nem lock pessimista.
- Alternativas: `SELECT FOR UPDATE` na projeção. Acopla a regra ao modelo de leitura e enfraquece o event sourcing.
- Consequências: o cenário de duas ofertas sobre o mesmo preço termina com um aceite e uma recusa, como a spec `live-bidding` exige.

### D4. Tempo real depois do commit

- Status: aceita
- Decisão: o canal Action Cable publica o lance somente depois que `BidAccepted` está no stream. A página Vue entra no canal do leilão. Lance recusado não gera mensagem de aceite.
- Alternativas: Outbox com relay assíncrono. Faz sentido para e-mail ou webhook, não para a sala no mesmo processo.
- Consequências: um observador pode perder a mensagem se conectar no meio do lance; a consulta do leilão continua sendo a fonte para o preço exibido ao carregar a página.

### D5. Domínio independente de Rails

- Status: aceita
- Decisão: agregado, value object de dinheiro em centavos e contratos `dry-validation` não referenciam ActiveRecord, controller nem Action Cable. O container `dry-system` do pack entrega o repositório do stream e o relógio. Casos de uso devolvem `Result`.
- Alternativas: lógica de lance no controller Inertia. É o caminho mais curto e o que este estudo quer evitar.
- Consequências: o teste da regra de lance roda sem subir o servidor web.

### D6. Preço de leitura separado da decisão

- Status: aceita
- Decisão: uma projeção `auction_listings` guarda título, término, preço atual e versão publicada para a tela. Ela é atualizada na mesma transação em que o evento é acrescentado ao stream. Quem decide o lance relê o stream, não essa tabela.
- Alternativas: projetar em processo assíncrono neste change. A sala poderia mostrar preço atrasado logo após o aceite.
- Consequências: a escrita do evento e da projeção anda junta. Isso ainda não é um Unit of Work genérico; é uma transação do caso de uso `PlaceBid` e `CreateAuction`.

## Decisões adiadas

- Saga de pagamento e compensação: depende de `AuctionClosed` e de um prestador externo, ambos fora do PRD deste change.
- Outbox: entra quando existir consumidor que não pode perder evento fora do processo Rails.
- Unit of Work genérico: entra se um caso de uso passar a coordenar mais de um agregado.
- Anti-snipe, fechamento e vencedor: próximo change de produto, com spec própria.
- Identidade: participantes de desenvolvimento permanecem semeados até o change de contas.
