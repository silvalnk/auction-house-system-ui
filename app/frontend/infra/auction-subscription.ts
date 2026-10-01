import { createConsumer } from "@rails/actioncable"

export function subscribeToAuction(
  auctionId: string,
  onMessage: (message: { current_price_cents?: number }) => void,
): { stop(): void } {
  const subscription = createConsumer().subscriptions.create(
    { channel: "AuctionChannel", auction_id: auctionId },
    { received: onMessage },
  )

  return {
    stop() {
      subscription.unsubscribe()
    },
  }
}
