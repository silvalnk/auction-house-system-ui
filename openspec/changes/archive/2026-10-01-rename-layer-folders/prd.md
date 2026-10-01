# PRD

## Problema

As camadas de casos de uso e de adapters usam os nomes `application` e `infrastructure`. Quem lê o frontend e o pack de leilões precisa dos nomes `data` e `infra`.

## Para quem

Quem for abrir o código do leilão no navegador e no servidor precisa achar as mesmas duas camadas pelos mesmos nomes.

## Resultado deste change

Publicar, consultar, dar lance e acompanhar a sala continuam iguais para quem usa o navegador. As pastas `application` passam a se chamar `data`, e as pastas `infrastructure` passam a se chamar `infra`, no frontend e no backend do leilão.

## Fora deste change

- Nova regra de lance, fechamento, pagamento ou cadastro.
- Renomear domínio, páginas, API pública ou constantes já usadas pelo leilão.
- Reescrever o histórico arquivado do planejamento.
- Saga, Outbox ou Unit of Work.

## Jornadas

1. O vendedor publica e vê o leilão aberto com o preço inicial.
2. O licitante envia um lance maior e a sala mostra o preço confirmado.
3. Um lance recusado continua mostrando o último preço confirmado.

## Premissas

- As specs `auction-catalog`, `live-bidding` e `realtime-feed` já descrevem o comportamento e não mudam.
- O recorte cobre o frontend Vue e o pack de leilões. Outros diretórios da aplicação Rails ficam como estão.
- `domain` e a API pública do pack permanecem com os nomes atuais.
- O servidor continua sendo o único lugar que aceita ou recusa um lance.

## Capabilities

### New Capabilities

- Nenhuma. Este change não altera comportamento observável.

### Modified Capabilities

- Nenhuma.

## Critérios de sucesso

- As três jornadas acima continuam verdadeiras no navegador.
- Não restam pastas `application` nem `infrastructure` nas duas áreas deste recorte.
- As pastas `data` e `infra` existem no frontend e no pack de leilões.

## Riscos de produto

- Um import ou um caminho de carga quebrado pode impedir a publicação ou a sala. A verificação no navegador, com lance aceito e lance recusado, continua obrigatória.
