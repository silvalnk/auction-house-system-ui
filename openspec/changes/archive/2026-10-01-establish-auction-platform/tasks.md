# Tasks

## 1. Aplicação e fronteiras

- [x] 1.1 Criar a aplicação Rails com PostgreSQL, Inertia.js e Vue, e verificar que a página inicial responde no navegador
- [x] 1.2 Adicionar `packs`, `packs-rails` e `packwerk`, criar o pack `auctions` com API pública vazia e verificar que `packwerk check` passa
- [x] 1.3 Registrar o container `dry-system` do pack com `dry-auto_inject` e verificar que um caso de uso de exemplo é resolvido no console
- [x] 1.4 Instalar `rails_event_store` e verificar que um evento de teste é acrescentado e relido de um stream

## 2. Publicação do leilão

- [x] 2.1 Implementar dinheiro em centavos, `AuctionOpened` e a abertura do agregado, e verificar os cenários de publicação válida, preço inválido e término no passado sem carregar Rails
- [x] 2.2 Implementar o contrato e `CreateAuction`, gravando stream e projeção na mesma transação, e verificar a consulta do leilão aberto com preço igual ao inicial
- [x] 2.3 Publicar a página Inertia de criação e detalhe, e verificar no navegador que um leilão válido aparece aberto

## 3. Lance

- [x] 3.1 Completar a regra do agregado para lance maior, lance seguinte, lance menor ou igual, lance do vendedor e lance após o término, e verificar esses cenários em teste unitário
- [x] 3.2 Implementar `PlaceBid` com versão esperada e uma releitura em conflito, e verificar no banco que duas ofertas sobre o mesmo preço deixam um único `BidAccepted` e a projeção com o valor aceito
- [x] 3.3 Acrescentar o formulário de lance na sala e verificar no navegador que um lance válido muda o preço e um lance inválido mostra recusa sem mudar o preço

## 4. Tempo real

- [x] 4.1 Publicar no canal do leilão somente depois do commit de `BidAccepted`, e verificar que um observador recebe valor aceito e preço atual
- [x] 4.2 Verificar que lance recusado não gera mensagem de aceite
- [x] 4.3 Atualizar o preço na página Vue ao receber a mensagem, e verificar com duas sessões que a sala segue o lance confirmado

## 5. Integração do recorte

- [x] 5.1 Percorrer publicação, lance aceito, lance recusado e disputa concorrente num teste de ponta a ponta e verificar que o preço final é o único lance confirmado
