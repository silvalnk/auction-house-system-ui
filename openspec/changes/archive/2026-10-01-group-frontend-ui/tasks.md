# Tasks

## 1. Pasta ui

- [x] 1.1 Mover `app/frontend/pages` para `app/frontend/ui/pages` e `app/frontend/components` para `app/frontend/ui/components`, apontar o Inertia para `../ui/pages` e atualizar os imports que saem de `ui`, verificando com `npm run check` e `npm test`
- [x] 1.2 Confirmar que `domain`, `data`, `infra` e `composition.ts` permanecem fora de `ui`, e que `domain` continua sem importar Vue, Inertia ou Action Cable

## 2. Telas no navegador

- [x] 2.1 Rodar `bin/rails test test/integration` e verificar que início, publicação e sala ainda resolvem pelos mesmos nomes
- [x] 2.2 Publicar um leilão, enviar um lance maior, enviar um lance que não aumenta o preço e confirmar que uma segunda sessão só muda no preço confirmado
