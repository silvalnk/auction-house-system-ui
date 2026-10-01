export type BidCommand = {
  submit(amountCents: number): void
}

export function placeBid(amountCents: number, command: BidCommand): void {
  command.submit(amountCents)
}

export type PublishInput = {
  title: string
  startingPriceCents: number
  endsAt: string
}

export type PublishCommand = {
  submit(input: PublishInput): void
}

export function publishAuction(input: PublishInput, command: PublishCommand): void {
  command.submit(input)
}

export type SessionCommand = {
  choose(participantId: string): void
}

export function switchParticipant(participantId: string, command: SessionCommand): void {
  command.choose(participantId)
}
