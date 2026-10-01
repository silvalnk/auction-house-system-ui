import type { BidCommand, PublishCommand, PublishInput, SessionCommand } from "../data/commands"

type BidForm = {
  amount_cents: number
  post(url: string): void
}

type PublishForm = {
  title: string
  starting_price_cents: number
  ends_at: string
  post(url: string): void
}

type SessionPoster = {
  post(url: string, data: { participant_id: string }): void
}

export function inertiaBidCommand(auctionId: string, form: BidForm): BidCommand {
  return {
    submit(amountCents: number) {
      form.amount_cents = amountCents
      form.post(`/auctions/${auctionId}/bids`)
    },
  }
}

export function inertiaPublishCommand(form: PublishForm): PublishCommand {
  return {
    submit(input: PublishInput) {
      form.title = input.title
      form.starting_price_cents = input.startingPriceCents
      form.ends_at = input.endsAt
      form.post("/auctions")
    },
  }
}

export function inertiaSessionCommand(poster: SessionPoster): SessionCommand {
  return {
    choose(participantId: string) {
      poster.post("/session", { participant_id: participantId })
    },
  }
}
