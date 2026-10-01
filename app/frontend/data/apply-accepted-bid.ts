export type PriceSink = {
  apply(cents: number): void
}

export function applyAcceptedBid(
  message: { current_price_cents?: number } | null | undefined,
  sink: PriceSink,
): void {
  const cents = message?.current_price_cents
  if (typeof cents !== "number") return
  sink.apply(cents)
}
