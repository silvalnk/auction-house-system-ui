# RFC

## Contexto

O PRD pede a mesma sala, com o código Vue separado em camadas. Hoje `app/frontend/pages/auctions/show.vue` formata o preço, soma 100 centavos, assina o Action Cable e envia o POST. `app/frontend/lib/money.ts` é uma função solta. O pack `auctions` no Rails continua dono da decisão do lance.

## Decisões

### D1. Quatro pastas no frontend

- Status: aceita
- Decisão: `app/frontend/domain` não importa Vue, Inertia nem Action Cable. `application` depende só de portas. `infrastructure` implementa essas portas. `pages` e `components` só chamam casos de uso recebidos pelo composition root.
- Alternativas: deixar a regra no componente e cobrir com teste de página. O teste existiria, mas a dependência de framework continuaria no meio da regra.
- Consequências: publicar e dar lance passam por objetos pequenos. A página fica responsável pelo template.

### D2. O cliente não reconstitui o agregado

- Status: aceita
- Decisão: o domínio do navegador tem o value object de dinheiro e a sala como leitura. A sala aplica um preço confirmado. Ela não decide se o lance é válido.
- Alternativas: copiar `Auction` e `PlaceBid` para TypeScript. Isso criaria duas regras para o mesmo comportamento.
- Consequências: TDD no cliente cobre formatação, incremento sugerido e aplicação de mensagem aceita. A recusa continua sendo a resposta do servidor, já especificada em `live-bidding`.

### D3. Portas e um composition root

- Status: aceita
- Decisão: `AuctionRoomPort` recebe a mensagem confirmada. `BidCommandPort` envia o lance. `SessionPort` troca o participante. Um módulo `composition.ts` entrega as implementações Inertia e Action Cable. Os casos de uso recebem as portas pelo construtor.
- Alternativas: um container npm genérico. O grafo cabe em um arquivo e não justifica outro framework.
- Consequências: o teste troca a porta por um dublê. Vue não aparece no teste de aplicação.

### D4. Vitest para domínio e aplicação

- Status: aceita
- Decisão: os testes nascem antes da extração de cada módulo. O primeiro teste que falha descreve dinheiro ou sala. A implementação mínima faz o teste passar. Não há teste de componente neste change.
- Alternativas: só o teste Rails já existente. Ele não impede a página de voltar a conhecer o canal.
- Consequências: `npm test` roda sem o Rails. O navegador ainda verifica a sala com duas sessões.

### D5. Padrões que não entram agora

- Status: aceita
- Decisão: não criar Strategy, Saga, Outbox, Unit of Work nem um barramento de eventos no cliente. O canal já é um observer. O envio do lance é um comando. O preço é um value object.
- Alternativas: introduzir um padrão por item da lista de estudo. O PRD não tem um comportamento novo que precise deles.
- Consequências: o próximo change de produto reutiliza as portas e só acrescenta padrão quando a regra pedir.

## Decisões adiadas

- Teste de componente ou de navegador no Vitest.
- Regras de fechamento e de vencedor no cliente. Elas ainda não existem no servidor.
