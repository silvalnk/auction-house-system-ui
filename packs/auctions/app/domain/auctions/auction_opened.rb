# frozen_string_literal: true

module Auctions
  AuctionOpened = Data.define(:auction_id, :seller_id, :title, :starting_price_cents, :ends_at)
end
