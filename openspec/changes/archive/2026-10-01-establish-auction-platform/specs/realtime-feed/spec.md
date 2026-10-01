# Spec Delta

## Purpose

Mantém a sala do leilão alinhada aos lances que o servidor confirmou.

## ADDED Requirements

### Requirement: Difusão de lance aceito
O sistema SHALL enviar a quem observa o leilão o valor aceito e o preço atual resultante, depois que o lance for confirmado.

#### Scenario: Observador recebe lance aceito
- **WHEN** um lance é aceito e um participante observa esse leilão
- **THEN** o participante recebe o valor aceito e o novo preço atual

### Requirement: Recusa não entra como lance aceito
O sistema MUST NOT apresentar a quem observa o leilão um lance recusado como se tivesse sido aceito.

#### Scenario: Lance recusado não altera a sala
- **WHEN** um lance é recusado para um leilão observado
- **THEN** os observadores não recebem esse lance como aceito e o preço exibido permanece o último confirmado
