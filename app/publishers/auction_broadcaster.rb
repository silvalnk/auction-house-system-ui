# frozen_string_literal: true

class AuctionBroadcaster
  def publish(payload)
    ActionCable.server.broadcast(
      "auction_#{payload.fetch(:auction_id)}",
      {
        amount_cents: payload.fetch(:amount_cents),
        current_price_cents: payload.fetch(:current_price_cents)
      }
    )
  end
end
