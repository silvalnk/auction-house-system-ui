# frozen_string_literal: true

module Auctions
  class Listings
    def initialize(clock:)
      @clock = clock
    end

    def find(id)
      record = ListingRecord.find_by(id: id)
      return nil unless record

      serialize(record)
    end

    def list
      ListingRecord.order(created_at: :desc).map { |record| serialize(record) }
    end

    private

    attr_reader :clock

    def serialize(record)
      {
        id: record.id,
        title: record.title,
        seller_id: record.seller_id,
        current_price_cents: record.current_price_cents,
        ends_at: record.ends_at,
        open: record.ends_at > clock.now
      }
    end
  end
end
