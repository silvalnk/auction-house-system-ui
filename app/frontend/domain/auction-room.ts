export class AuctionRoom {
  private priceCents: number

  constructor(currentPriceCents: number) {
    this.priceCents = currentPriceCents
  }

  currentPrice(): number {
    return this.priceCents
  }

  applyConfirmedPrice(cents: number | null | undefined): void {
    if (typeof cents !== "number") return
    this.priceCents = cents
  }
}
