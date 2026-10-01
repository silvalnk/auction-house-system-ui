# frozen_string_literal: true

module Auctions
  class ListingRecord < ActiveRecord::Base
    self.table_name = "auction_listings"
  end
end
