# TRD

## Objetivo técnico

Extrair o que hoje está em `show.vue`, `new.vue`, `ParticipantBar.vue` e `lib/money.ts` para as quatro pastas do RFC, com testes Vitest escritos antes de cada extração. O comportamento das specs principais permanece.

## Packs e módulos

Não há pack Ruby novo.

- `app/frontend/domain/money.ts`: centavos inteiros, texto em BRL e sugestão do próximo lance, cem centavos acima do preço atual.
- `app/frontend/domain/auction-room.ts`: guarda o preço confirmado e só o substitui quando recebe um preço confirmado.
- `app/frontend/application`: `publishAuction`, `placeBid`, `switchParticipant`, `applyAcceptedBid`. Cada função recebe as portas por argumento.
- `app/frontend/infrastructure`: POST via Inertia e assinatura do Action Cable.
- `app/frontend/composition.ts`: único lugar que importa os adapters e devolve os casos de uso.
- As páginas atuais passam a usar essa composição.

## Comandos, eventos e leituras

- Publicar envia título, preço inicial em centavos e término. Não valida a regra de negócio no cliente.
- Dar lance envia o valor em centavos. Não decide aceite.
- Aplicar lance confirmado atualiza a sala com `current_price_cents` da mensagem.
- Mensagem sem preço confirmado não altera a sala.
- Trocar participante continua no POST `/session`.

## Consistência e concorrência

- O cliente não tem versão de stream nem retry. Quem confirma o lance é o `PlaceBid` do Rails.
- Duas abas continuam cada uma com sua assinatura. As duas aplicam a mesma mensagem confirmada.

Risco: a página aplicar a mensagem direto no `ref` e ignorar a sala. Mitigação: o teste da sala falha se o preço não mudar por ali, e a página não importa o adapter.

## Tempo real

- O adapter assina `AuctionChannel` com o id do leilão e traduz a mensagem para o caso de uso.
- Ao sair da página, cancela a assinatura.
- Lance recusado não produz mensagem. A sala permanece no último preço. O alerta continua vindo do flash do Inertia.

## Persistência

- Nenhuma tabela nova. O estado da sala vive na memória da página.

## Testes

- Vitest, antes da implementação de cada módulo: dinheiro positivo formatado em BRL; sugestão de lance; sala que aceita preço confirmado e ignora mensagem vazia; caso de uso que chama a porta uma vez e não altera a sala quando a porta não devolve confirmação.
- `npm test` não sobe o Rails.
- No navegador, repetir publicação, lance válido, lance recusado e a segunda sessão acompanhando o preço.

## Fora de escopo técnico deste change

- Teste de montagem Vue.
- Mover o pack `auctions`.
- Regra de fechamento, vencedor, Saga ou Outbox.
