# Tasks

## 1. Testes do domínio de leitura

- [x] 1.1 Adicionar Vitest e verificar que `npm test` executa uma suíte vazia
- [x] 1.2 Escrever o teste de dinheiro em BRL e da sugestão de cem centavos, vê-lo falhar, extrair `domain/money.ts` e verificar que o teste passa sem importar Vue
- [x] 1.3 Escrever o teste da sala, vê-lo falhar, extrair `domain/auction-room.ts` e verificar que só um preço confirmado troca o valor

## 2. Casos de uso e portas

- [x] 2.1 Escrever o teste de `applyAcceptedBid` com uma porta falsa, vê-lo falhar, implementar o caso de uso e verificar que uma mensagem vazia não chama a atualização
- [x] 2.2 Escrever os testes de `placeBid`, `publishAuction` e `switchParticipant` com portas falsas, vê-los falhar, implementar os casos de uso e verificar que cada um chama a porta uma vez com os centavos informados

## 3. Adapters e páginas

- [x] 3.1 Implementar os adapters de Inertia e Action Cable atrás das portas e o `composition.ts`, e verificar que `domain` não importa Vue, Inertia nem Action Cable
- [x] 3.2 Trocar `show.vue`, `new.vue` e `ParticipantBar.vue` para usarem a composição, e verificar no navegador a publicação, o lance válido, o lance recusado e a segunda sessão atualizando o preço
