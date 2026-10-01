export class Money {
  private constructor(readonly cents: number) {}

  static fromCents(cents: number): Money {
    return new Money(cents)
  }

  format(): string {
    return (this.cents / 100).toLocaleString("pt-BR", {
      style: "currency",
      currency: "BRL",
    })
  }

  suggestedNext(): Money {
    return Money.fromCents(this.cents + 100)
  }
}
