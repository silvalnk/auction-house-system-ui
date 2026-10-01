import { describe, expect, it } from "vitest"
import { Money } from "./money"

describe("Money", () => {
  it("formats cents as BRL", () => {
    expect(Money.fromCents(1050).format()).toMatch(/10,50/)
  })

  it("suggests one hundred cents above the current price", () => {
    expect(Money.fromCents(1000).suggestedNext().cents).toBe(1100)
  })
})
