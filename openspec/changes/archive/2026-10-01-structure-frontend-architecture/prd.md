# PRD

## Problema

As páginas Vue decidem preço, formulário e canal no mesmo arquivo. Dá para estudar o leilão no Rails, mas o frontend não exercita as mesmas fronteiras.

## Para quem

Quem for implementar a próxima tela precisa achar domínio, caso de uso e adapter sem abrir o componente.

## Resultado deste change

Publicar, consultar, dar lance e acompanhar a sala continuam iguais para quem usa o navegador. Por dentro, a página só renderiza. Dinheiro, atualização da sala e o envio do lance passam por módulos testados sem montar o Vue.

## Fora deste change

- Nova regra de lance, fechamento, pagamento ou cadastro.
- Um segundo agregado de leilão no navegador.
- Saga, Outbox ou Unit of Work no cliente.
- Troca de Vue, Inertia ou Action Cable.

## Jornadas

1. O vendedor publica e vê o leilão aberto com o preço inicial.
2. O licitante envia um lance maior e a sala mostra o preço confirmado.
3. Um lance recusado continua mostrando o último preço confirmado.

## Premissas

- As specs `auction-catalog`, `live-bidding` e `realtime-feed` já descrevem o comportamento e não mudam.
- O servidor continua sendo o único lugar que aceita ou recusa um lance.
- O cliente formata centavos e reage a uma mensagem já confirmada.
- Vitest entra só para o código que não depende do navegador.

## Capabilities

### New Capabilities

- Nenhuma. Este change não altera comportamento observável.

### Modified Capabilities

- Nenhuma.

## Critérios de sucesso

- As três jornadas acima continuam verdadeiras no navegador.
- Um teste de dinheiro e um teste da sala rodam sem Vue, Inertia e Action Cable.
- A página não importa o cliente do canal nem calcula a próxima oferta fora de um caso de uso.

## Riscos de produto

- A refatoração pode quebrar a sala se o adapter do canal deixar de atualizar o preço. A verificação no navegador, com duas sessões, continua obrigatória.
