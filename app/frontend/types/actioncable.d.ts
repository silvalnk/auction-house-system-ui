declare module "@rails/actioncable" {
  type Subscription = {
    unsubscribe(): void
  }

  export function createConsumer(): {
    subscriptions: {
      create(
        params: { channel: string; auction_id: string },
        handlers: { received(message: { current_price_cents?: number }): void },
      ): Subscription
    }
  }
}
