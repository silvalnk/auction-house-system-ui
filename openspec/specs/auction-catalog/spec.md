# auction-catalog Specification

## Purpose

Permite ao vendedor publicar um leilão inglês de um lote, já aberto para lances.

## Requirements

### Requirement: Publicação de leilão aberto
O sistema SHALL criar um leilão aberto quando o vendedor informa título, preço inicial positivo em centavos de BRL e término posterior ao relógio do servidor. O preço atual SHALL ser o preço inicial e o leilão SHALL ficar visível para os participantes.

#### Scenario: Publicação válida
- **WHEN** o vendedor publica título, preço inicial de 1000 centavos e término futuro
- **THEN** o leilão fica aberto, com preço atual de 1000 centavos e nenhum lance aceito

#### Scenario: Preço inicial inválido
- **WHEN** o vendedor publica preço inicial zero ou negativo
- **THEN** o sistema recusa a publicação e nenhum leilão novo fica visível

#### Scenario: Término no passado
- **WHEN** o vendedor publica um término anterior ou igual ao relógio do servidor
- **THEN** o sistema recusa a publicação e nenhum leilão novo fica visível

### Requirement: Consulta do leilão publicado
O sistema SHALL mostrar título, preço atual, término e a condição de aberto para um participante que consulta o leilão.

#### Scenario: Consulta após publicação
- **WHEN** um participante consulta um leilão recém-publicado
- **THEN** a resposta contém o título, o preço inicial como preço atual, o término e a condição aberto
