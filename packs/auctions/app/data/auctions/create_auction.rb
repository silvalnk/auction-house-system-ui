# frozen_string_literal: true

require "securerandom"
require "dry/monads"

module Auctions
  class CreateAuction
    include Dry::Monads[:result]

    def initialize(repository:, clock:)
      @repository = repository
      @clock = clock
    end

    def call(seller_id:, title:, starting_price_cents:, ends_at:)
      contract = CreateAuctionContract.new.call(
        seller_id: seller_id.to_s,
        title: title.to_s,
        starting_price_cents: starting_price_cents,
        ends_at: ends_at
      )
      errors = contract.errors.to_h
      return Failure(:invalid_price) if errors[:starting_price_cents]
      return Failure(:ends_at_in_the_past) if errors[:ends_at]
      return Failure(:invalid_price) if contract.failure?

      now = clock.now
      id = SecureRandom.uuid
      opened = Auction.open(
        id: id,
        seller_id: seller_id.to_s,
        title: title.to_s,
        starting_price_cents: starting_price_cents,
        ends_at: ends_at,
        now: now
      )
      return opened if opened.failure?

      repository.commit(opened.value!, expected_version: -1)
      Success(
        id: id,
        title: title.to_s,
        current_price_cents: starting_price_cents,
        ends_at: ends_at,
        open: true
      )
    end

    private

    attr_reader :repository, :clock
  end
end
