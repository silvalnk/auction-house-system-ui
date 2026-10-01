# TRD

## Objetivo técnico

Agrupar a interface Vue em `app/frontend/ui` e manter os nomes de tela que o Rails já pede. Comandos, eventos, projeção, concorrência e canal não mudam.

## Packs e módulos

- Mover `app/frontend/pages` para `app/frontend/ui/pages`.
- Mover `app/frontend/components` para `app/frontend/ui/components`.
- Em `app/frontend/entrypoints/inertia.ts`, apontar a resolução de páginas para `../ui/pages`. Os renders continuam `home/index`, `auctions/new` e `auctions/show`.
- Ajustar imports de `composition.ts` e de `domain` nas páginas e no componente, porque eles passam a estar um nível acima de `ui`. Imports entre `pages` e `components` continuam relativos dentro de `ui`.
- `domain`, `data`, `infra`, `composition.ts`, `entrypoints` e `types` ficam na raiz do frontend. O pack `auctions` não é movido.

## Comandos, eventos e leituras

- Comandos do pack: criar leilão e dar lance, ainda pela API pública.
- Eventos: abertura e lance aceito no stream `Auction$<id>`.
- Leituras: projeção `auction_listings` e, no cliente, dinheiro e sala.
- Nenhuma mensagem nova entra no event store.

## Consistência e concorrência

- A projeção continua na mesma transação do evento.
- A versão esperada do stream e a releitura em conflito permanecem.
- O move não muda a regra de lances iguais concorrentes.

## Tempo real

- O broadcast continua depois do commit de um lance aceito.
- Lance recusado continua fora do stream e fora do canal.
- A assinatura continua em `infra`, fora de `ui`.

## Persistência

- Sem migration. Tabelas do event store e de `auction_listings` permanecem.

## Testes

- `npm run check` confirma os imports depois do move.
- `npm test` continua cobrindo dinheiro, sala e casos de uso, que não mudam de pasta.
- `bin/rails test test/integration` confirma que os nomes de tela ainda resolvem.
- No navegador: publicar, lance maior, lance recusado e segunda sessão só no preço confirmado.

## Fora de escopo técnico deste change

- Saga, Outbox, Unit of Work, layouts e design system, adiados no RFC.
- Fechamento, pagamento, anti-snipe e autenticação real.
- Reescrever specs principais ou o histórico do planejamento.
