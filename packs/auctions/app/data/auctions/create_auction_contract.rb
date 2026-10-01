# frozen_string_literal: true

require "dry/validation"

module Auctions
  class CreateAuctionContract < Dry::Validation::Contract
    params do
      required(:seller_id).filled(:string)
      required(:title).filled(:string)
      required(:starting_price_cents).filled(:integer)
      required(:ends_at).filled
    end

    rule(:starting_price_cents) do
      key.failure("invalid") unless value.positive?
    end
  end
end
