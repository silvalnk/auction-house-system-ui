import { describe, expect, it } from "vitest"
import { AuctionRoom } from "./auction-room"

describe("AuctionRoom", () => {
  it("replaces the price only when a confirmed price arrives", () => {
    const room = new AuctionRoom(1000)

    room.applyConfirmedPrice(1500)
    expect(room.currentPrice()).toBe(1500)

    room.applyConfirmedPrice(undefined)
    room.applyConfirmedPrice(null)
    expect(room.currentPrice()).toBe(1500)
  })
})
