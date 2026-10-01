# PRD

## Problema

Páginas e componentes ficam soltos na raiz do frontend, ao lado de domínio, casos de uso e adapters. Quem abre o cliente não vê uma camada de interface separada.

## Para quem

Quem for implementar a próxima tela precisa achar páginas e componentes dentro de uma pasta `ui`.

## Resultado deste change

Publicar, consultar, dar lance e acompanhar a sala continuam iguais para quem usa o navegador. Páginas e componentes passam a viver em `ui`. Os nomes das telas que o servidor pede permanecem os mesmos.

## Fora deste change

- Nova tela, novo componente ou mudança visual.
- Mover domínio, casos de uso, adapters, ponto de entrada ou o composition root para dentro de `ui`.
- Renomear pastas no pack Rails.
- Saga, Outbox ou Unit of Work.

## Jornadas

1. O vendedor publica e vê o leilão aberto com o preço inicial.
2. O licitante envia um lance maior e a sala mostra o preço confirmado.
3. Um lance recusado continua mostrando o último preço confirmado.

## Premissas

- As specs `auction-catalog`, `live-bidding` e `realtime-feed` já descrevem o comportamento e não mudam.
- Hoje a interface Vue é `pages` e `components`. Não há pasta de layout no frontend para mover.
- A pasta se chama `ui`, no mesmo padrão de `domain`, `data` e `infra`.
- O composition root continua fora de `ui` e entrega os casos de uso para as telas.

## Capabilities

### New Capabilities

- Nenhuma. Este change não altera comportamento observável.

### Modified Capabilities

- Nenhuma.

## Critérios de sucesso

- As três jornadas acima continuam verdadeiras no navegador.
- `pages` e `components` ficam dentro de `ui` e somem da raiz do frontend.
- O servidor continua pedindo as mesmas telas de início, publicação e sala.

## Riscos de produto

- Um caminho de página quebrado mostra tela em branco. A verificação no navegador, com publicação e lance, continua obrigatória.
