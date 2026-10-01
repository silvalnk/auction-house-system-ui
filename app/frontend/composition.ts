import { applyAcceptedBid } from "./data/apply-accepted-bid"
import {
  placeBid,
  publishAuction,
  switchParticipant,
  type PublishInput,
} from "./data/commands"
import { AuctionRoom } from "./domain/auction-room"
import { Money } from "./domain/money"
import { subscribeToAuction } from "./infra/auction-subscription"
import {
  inertiaBidCommand,
  inertiaPublishCommand,
  inertiaSessionCommand,
} from "./infra/inertia-commands"

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

export function composeAuctionShow(
  auctionId: string,
  initialPriceCents: number,
  form: BidForm,
  onPrice: (cents: number) => void,
) {
  const room = new AuctionRoom(initialPriceCents)

  function publishPrice() {
    onPrice(room.currentPrice())
    form.amount_cents = Money.fromCents(room.currentPrice()).suggestedNext().cents
  }

  const subscription = subscribeToAuction(auctionId, (message) => {
    applyAcceptedBid(message, {
      apply(cents) {
        room.applyConfirmedPrice(cents)
        publishPrice()
      },
    })
  })

  return {
    place(amountCents: number) {
      placeBid(amountCents, inertiaBidCommand(auctionId, form))
    },
    applyServerPrice(cents: number) {
      room.applyConfirmedPrice(cents)
      publishPrice()
    },
    stop() {
      subscription.stop()
    },
  }
}

export function composePublish(form: PublishForm) {
  return {
    submit(input: PublishInput) {
      publishAuction(input, inertiaPublishCommand(form))
    },
  }
}

export function composeSession(poster: SessionPoster) {
  return {
    choose(participantId: string) {
      switchParticipant(participantId, inertiaSessionCommand(poster))
    },
  }
}
