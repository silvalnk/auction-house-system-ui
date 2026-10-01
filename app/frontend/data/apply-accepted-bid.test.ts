import { describe, expect, it, vi } from "vitest"
import { applyAcceptedBid } from "./apply-accepted-bid"

describe("applyAcceptedBid", () => {
  it("forwards a confirmed price once", () => {
    const sink = { apply: vi.fn() }

    applyAcceptedBid({ current_price_cents: 1500 }, sink)

    expect(sink.apply).toHaveBeenCalledTimes(1)
    expect(sink.apply).toHaveBeenCalledWith(1500)
  })

  it("does not update the room when the message has no price", () => {
    const sink = { apply: vi.fn() }

    applyAcceptedBid({}, sink)
    applyAcceptedBid(null, sink)

    expect(sink.apply).not.toHaveBeenCalled()
  })
})
