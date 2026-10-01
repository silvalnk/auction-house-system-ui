# frozen_string_literal: true

require "dry/monads"

module Auctions
  class Auction
    include Dry::Monads[:result]

    attr_reader :id, :seller_id, :title, :ends_at, :current_price_cents, :changes

    def initialize
      @changes = []
    end

    def self.open(id:, seller_id:, title:, starting_price_cents:, ends_at:, now:)
      auction = new
      return auction.Failure(:invalid_price) unless Money.new(starting_price_cents).positive?
      return auction.Failure(:ends_at_in_the_past) if ends_at <= now

      auction.record(
        AuctionOpened.new(
          auction_id: id,
          seller_id: seller_id,
          title: title,
          starting_price_cents: starting_price_cents,
          ends_at: ends_at
        )
      )
      auction.Success(auction)
    end

    def self.replay(events)
      auction = new
      events.each { |event| auction.apply_event(event) }
      auction
    end

    def place_bid(bidder_id:, amount_cents:, now:)
      return Failure(:seller_cannot_bid) if bidder_id == seller_id
      return Failure(:auction_ended) if now >= ends_at
      return Failure(:bid_too_low) unless amount_cents.is_a?(Integer) && amount_cents > current_price_cents

      record(BidAccepted.new(auction_id: id, bidder_id: bidder_id, amount_cents: amount_cents))
      Success(self)
    end

    def record(event)
      apply_event(event)
      changes << event
    end

    def apply_event(event)
      case event
      when AuctionOpened
        @id = event.auction_id
        @seller_id = event.seller_id
        @title = event.title
        @ends_at = event.ends_at
        @current_price_cents = event.starting_price_cents
      when BidAccepted
        @current_price_cents = event.amount_cents
      else
        raise ArgumentError, "evento desconhecido"
      end
    end
  end
end
