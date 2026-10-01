import { describe, expect, it, vi } from "vitest"
import { placeBid, publishAuction, switchParticipant } from "./commands"

describe("commands", () => {
  it("places a bid once with the given cents", () => {
    const command = { submit: vi.fn() }

    placeBid(1500, command)

    expect(command.submit).toHaveBeenCalledTimes(1)
    expect(command.submit).toHaveBeenCalledWith(1500)
  })

  it("publishes an auction once with the given cents", () => {
    const command = { submit: vi.fn() }
    const input = { title: "Relógio", startingPriceCents: 1000, endsAt: "2026-10-02T10:00" }

    publishAuction(input, command)

    expect(command.submit).toHaveBeenCalledTimes(1)
    expect(command.submit).toHaveBeenCalledWith(input)
  })

  it("switches the participant once", () => {
    const command = { choose: vi.fn() }

    switchParticipant("seller-1", command)

    expect(command.choose).toHaveBeenCalledTimes(1)
    expect(command.choose).toHaveBeenCalledWith("seller-1")
  })
})
