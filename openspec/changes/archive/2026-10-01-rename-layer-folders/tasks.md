# Tasks

## 1. Frontend

- [x] 1.1 Mover `app/frontend/application` para `app/frontend/data` e `app/frontend/infrastructure` para `app/frontend/infra`, atualizar os imports de `composition.ts` e do adapter de comandos, e verificar com `npm test` e `npm run check`
- [x] 1.2 Confirmar que `app/frontend/domain` continua sem importar Vue, Inertia ou Action Cable, e que `config/application.rb` e `app/frontend/entrypoints/application.ts` permanecem

## 2. Pack auctions

- [x] 2.1 Mover `packs/auctions/app/application` para `packs/auctions/app/data` e `packs/auctions/app/infrastructure` para `packs/auctions/app/infra`, mantendo as constantes `Auctions::*`, e verificar com `bin/rails zeitwerk:check` e `bundle exec packwerk check`
- [x] 2.2 Rodar os testes de domínio do pack e `bin/rails test test/integration`, e verificar que publicação, lance e a corrida de lances iguais continuam verdes

## 3. Sala no navegador

- [x] 3.1 Publicar um leilão, enviar um lance maior, enviar um lance que não aumenta o preço e confirmar que uma segunda sessão só muda no preço confirmado
