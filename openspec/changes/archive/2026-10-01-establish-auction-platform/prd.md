# PRD

## Problema

Um leilão ao vivo deixa de ser confiável quando dois lances chegam juntos e a interface mostra um preço que o servidor não confirmou. Este projeto existe para praticar esse fluxo com event sourcing, concorrência otimista e atualização em tempo real.

## Para quem

- Vendedor: publica um lote e acompanha o preço.
- Licitante: observa o leilão e envia lances maiores que o preço atual.
- Estudante da base de código: usa o fluxo para exercitar DDD e eventos antes de acrescentar pagamento e fechamento.

## Resultado deste change

O vendedor publica um leilão inglês com um lote, preço inicial em centavos de BRL e horário de término. O leilão abre na publicação. Um licitante envia um lance maior que o preço atual. Lances menores, iguais, atrasados, do próprio vendedor ou posteriores ao término são recusados sem alterar o preço. Quem está na sala vê somente lances aceitos.

## Fora deste change

- Cadastro, recuperação de senha e gestão de papéis.
- Fechamento automático, escolha de vencedor e anti-snipe.
- Cobrança, reembolso, Saga, Outbox e Unit of Work.
- Vários lotes no mesmo leilão, outras moedas e leilão holandês ou selado.

Esses itens permanecem no roadmap e não entram nas specs deste change.

## Jornadas

1. O vendedor informa título, preço inicial e término futuro. O leilão aparece aberto, com o preço atual igual ao inicial e sem lances.
2. O licitante envia um valor maior. O preço atual passa a ser esse valor.
3. Outro lance, menor ou simultâneo e perdedor, recebe recusa. A sala continua exibindo o lance aceito.

## Premissas

- Existem dois participantes de desenvolvimento já autenticados: um vendedor e um licitante.
- O relógio do servidor decide se o término já passou.
- O preço é um inteiro de centavos de BRL. R$ 10,50 é 1050.
- Há um lote por leilão.
- A entrega externa de e-mail ou webhook não faz parte deste recorte. Tempo real significa a sala aberta no navegador.

## Capabilities

### New Capabilities

- `auction-catalog`: publicação de um leilão inglês aberto, com um lote e preço inicial.
- `live-bidding`: aceite e recusa de lances, inclusive quando dois lances concorrem.
- `realtime-feed`: difusão dos lances aceitos para quem observa o leilão.

### Modified Capabilities

- Nenhuma.

## Critérios de sucesso

- Um lance perdedor nunca reduz nem mantém um preço já superado por um lance confirmado.
- A sala não apresenta como aceito um lance que o servidor recusou.
- O comportamento acima é verificável por cenário, sem depender da tela para a regra de domínio.

## Riscos de produto

- Adiar o fechamento pode parecer um leilão incompleto. O término já recusa lance tardio; declarar vencedor fica para o próximo change.
- Participantes fixos de desenvolvimento escondem regras de autorização que precisarão de capability própria.
