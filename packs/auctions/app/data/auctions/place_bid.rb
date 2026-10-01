# frozen_string_literal: true

require "dry/monads"

module Auctions
  class PlaceBid
    include Dry::Monads[:result]

    def initialize(repository:, clock:, publisher:)
      @repository = repository
      @clock = clock
      @publisher = publisher
    end

    def call(auction_id:, bidder_id:, amount_cents:)
      result = persist(auction_id:, bidder_id:, amount_cents:)
      result = persist(auction_id:, bidder_id:, amount_cents:) if result == :conflict
      return Failure(:conflict) if result == :conflict

      result
    end

    private

    attr_reader :repository, :clock, :publisher

    def persist(auction_id:, bidder_id:, amount_cents:)
      auction, version = repository.load(auction_id)
      return Failure(:not_found) if auction.nil?

      decision = auction.place_bid(bidder_id: bidder_id.to_s, amount_cents: amount_cents, now: clock.now)
      return decision if decision.failure?

      repository.commit(auction, expected_version: version)
      payload = {
        auction_id: auction.id,
        amount_cents: amount_cents,
        current_price_cents: auction.current_price_cents
      }
      publisher.publish(payload)
      Success(payload)
    rescue RubyEventStore::WrongExpectedEventVersion
      :conflict
    end
  end
end
