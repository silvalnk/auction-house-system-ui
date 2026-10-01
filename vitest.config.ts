import { defineConfig } from "vitest/config"

export default defineConfig({
  test: {
    root: ".",
    include: ["app/frontend/**/*.test.ts"],
  },
})
