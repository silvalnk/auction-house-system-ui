# TRD

## Objetivo técnico

Mover as duas camadas pedidas pelo RFC e apontar os imports para os caminhos novos. Comandos, eventos, projeção, concorrência e canal permanecem os mesmos.

## Packs e módulos

- Pack `auctions`: mover `app/application` para `app/data` e `app/infrastructure` para `app/infra`. `app/domain` e `app/public` ficam.
- Cada subpasta direta de `packs/auctions/app` já é raiz de autoload. Depois do move, `data` e `infra` ocupam esse papel. As constantes `Auctions::*` não ganham prefixo.
- Frontend: mover `app/frontend/application` para `app/frontend/data` e `app/frontend/infrastructure` para `app/frontend/infra`.
- Atualizar os imports de `composition.ts` e do adapter de comandos. `domain`, `pages` e `components` permanecem.
- Não alterar `config/application.rb` nem `app/frontend/entrypoints/application.ts`.

## Comandos, eventos e leituras

- Comandos do pack: criar leilão e dar lance, ainda expostos pela API pública.
- Eventos de domínio: abertura e lance aceito, ainda no stream `Auction$<id>`.
- Leituras: projeção `auction_listings` e, no cliente, dinheiro e sala.
- Nenhuma mensagem nova entra no event store.

## Consistência e concorrência

- A publicação da projeção continua na mesma transação do evento.
- A versão esperada do stream e a única releitura em conflito permanecem.
- O rename não muda a regra de que lances iguais concorrentes produzem um único evento aceito.

## Tempo real

- O broadcast continua depois do commit de um lance aceito.
- Lance recusado continua fora do stream e fora do canal.
- O adapter do canal muda de pasta para `infra` e continua assinando o mesmo canal.

## Persistência

- Sem migration. Tabelas do event store e de `auction_listings` permanecem.
- O repositório e o registro da projeção mudam só de diretório, para `infra`.

## Testes

- `npm test` e `npm run check` depois dos imports.
- Testes de domínio do pack continuam sem Rails. A suíte de integração Rails cobre publicação, lance e corrida.
- `zeitwerk:check` confirma que `data` e `infra` carregam as constantes atuais.
- `packwerk check` confirma a fronteira do pack.
- No navegador: publicar, lance maior, lance recusado e segunda sessão só no preço confirmado.

## Fora de escopo técnico deste change

- Saga, Outbox e Unit of Work, adiados no RFC.
- Fechamento, pagamento, anti-snipe e autenticação real.
- Reescrever specs principais ou o arquivo histórico do planejamento.
- Renomear módulos Ruby ou introduzir alias de caminho no Vite.
