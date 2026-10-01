# Spec Delta

## Purpose

Aceita um único lance vencedor por vez e recusa lances que não superam o preço confirmado.

## ADDED Requirements

### Requirement: Lance maior que o preço atual
O sistema SHALL aceitar um lance de licitante estritamente maior que o preço atual de um leilão aberto e SHALL tornar esse valor o novo preço atual.

#### Scenario: Primeiro lance válido
- **WHEN** um licitante oferece mais do que o preço inicial de um leilão aberto
- **THEN** o lance é aceito e o preço atual passa a ser o valor oferecido

#### Scenario: Lance seguinte ainda maior
- **WHEN** um licitante oferece mais do que o preço já confirmado por um lance anterior
- **THEN** o lance é aceito e o preço atual passa a ser o novo valor

### Requirement: Recusa sem alterar o preço
O sistema MUST recusar lance menor ou igual ao preço atual, lance do vendedor do leilão e lance recebido depois do término. O preço atual SHALL permanecer o último valor aceito.

#### Scenario: Lance igual ou menor
- **WHEN** um licitante oferece um valor igual ou menor que o preço atual
- **THEN** o lance é recusado e o preço atual não muda

#### Scenario: Vendedor tenta lance
- **WHEN** o vendedor envia um lance no próprio leilão
- **THEN** o lance é recusado e o preço atual não muda

#### Scenario: Lance após o término
- **WHEN** um licitante envia um lance depois do término
- **THEN** o lance é recusado e o preço atual não muda

### Requirement: Um vencedor entre lances concorrentes
O sistema SHALL confirmar no máximo um lance quando duas ofertas concorrentes chegam sobre o mesmo preço. A oferta perdedora SHALL ser recusada e o preço atual SHALL ser o da oferta confirmada.

#### Scenario: Duas ofertas sobre o mesmo preço
- **WHEN** dois licitantes oferecem valores maiores que o mesmo preço atual antes de qualquer um ser confirmado
- **THEN** exatamente um lance é aceito, o outro é recusado e o preço atual é o valor aceito
