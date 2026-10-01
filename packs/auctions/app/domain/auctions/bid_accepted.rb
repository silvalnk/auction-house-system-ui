# frozen_string_literal: true

module Auctions
  BidAccepted = Data.define(:auction_id, :bidder_id, :amount_cents)
end
