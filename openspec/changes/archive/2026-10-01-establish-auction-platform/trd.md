# TRD

## Objetivo técnico

Implementar o recorte do PRD em Rails com Inertia e Vue, com a regra de lance fora do framework. O RFC já fixou um pack `auctions`, event sourcing e concorrência pela versão do stream. Este documento desce até comandos, eventos e testes, sem código.

## Packs e módulos

Pack `auctions`:

- Domínio: agregado `Auction`, dinheiro em centavos, eventos `AuctionOpened` e `BidAccepted`.
- Aplicação: `CreateAuction` e `PlaceBid`, contratos de entrada e `Result` de sucesso ou recusa.
- Infraestrutura: repositório do stream, projeção `auction_listings` e relógio do servidor.
- API pública: os dois casos de uso e a consulta da projeção. É o único caminho da camada web.

Camada web, fora do pack:

- Páginas Inertia para publicar, consultar e enviar lance.
- Canal Action Cable do leilão, chamado só depois do commit de `BidAccepted`.

`packwerk` declara essa dependência de fora para dentro. O domínio não depende de `app/controllers` nem de `app/channels`.

## Comandos, eventos e leituras

`CreateAuction` recebe participante vendedor, título, preço inicial e término.

- Recusa preço que não seja inteiro positivo ou término que não esteja no futuro.
- Em sucesso, abre o agregado, acrescenta `AuctionOpened` ao stream `Auction$<id>` e grava a projeção com preço atual igual ao inicial, sem lances e condição aberto.

`PlaceBid` recebe licitante, leilão e valor em centavos.

- Reconstrói o agregado pelo stream.
- Aceita só valor estritamente maior, licitante diferente do vendedor e relógio anterior ao término.
- Em aceite, acrescenta `BidAccepted` com a versão esperada e atualiza a projeção na mesma transação.
- Em conflito de versão, relê o stream uma vez. Se o novo preço já não for superado, devolve recusa.
- Recusa não gera evento.

Consulta devolve título, preço atual, término e condição aberto a partir da projeção.

## Consistência e concorrência

- A decisão usa o stream. A projeção serve à página e ao preço exibido ao entrar na sala.
- A versão esperada é a do stream lido no início do caso de uso.
- Duas ofertas sobre o mesmo preço produzem um `BidAccepted` e uma recusa, sem lance parcial gravado.
- A transação cobre o append e a projeção daquele caso de uso. Não há Unit of Work reutilizável neste change.

Risco: a releitura única pode ainda colidir sob carga alta. Mitigação: devolver recusa de conflito para o licitante tentar de novo; não enfileirar lances.

Risco: projeção e stream divergirem se a atualização da projeção ficar fora da transação. Mitigação: os dois writes do caso de uso compartilham a transação do repositório.

## Tempo real

- O canal é por leilão.
- A mensagem de aceite leva valor aceito e preço atual.
- Ela sai depois do commit. Falha de broadcast não desfaz o lance.
- Quem entra na sala carrega o preço pela consulta, não pelo histórico do canal.
- Lance recusado não produz mensagem de aceite.

## Persistência

- PostgreSQL guarda as tabelas do Rails Event Store e `auction_listings`.
- `auction_listings` contém identificador, vendedor, título, término, preço atual em centavos, condição e versão publicada.
- O stream permanece a fonte para reconstituir o agregado. A tabela não é atualizada por fora dos casos de uso.

## Testes

- Agregado e contratos, sem Rails: publicação inválida, primeiro lance, lance seguinte, lance menor, vendedor e término vencido.
- Repositório com banco: versão conflitante não grava o segundo `BidAccepted`; a projeção fica com o valor vencedor.
- Canal: mensagem só após aceite; recusa não publica aceite.
- Página: publicação válida aparece aberta; o envio de lance atualiza o preço confirmado.

## Fora de escopo técnico deste change

- Pack de pagamento, Saga, Outbox, fechamento agendado e anti-snipe.
- Cadastro de usuários. Os dois participantes de desenvolvimento são semeados.
- Projeção assíncrona e replay administrativo do stream.
