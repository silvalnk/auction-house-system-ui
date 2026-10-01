# frozen_string_literal: true

module Auctions
  class EventStoreRepository
    def initialize(event_store:)
      @event_store = event_store
    end

    def load(id)
      records = event_store.read.stream(stream_name(id)).to_a
      return [nil, -1] if records.empty?

      [Auction.replay(records.map { |record| from_record(record) }), records.size - 1]
    end

    def commit(auction, expected_version:)
      ActiveRecord::Base.transaction do
        auction.changes.each_with_index do |event, index|
          event_store.publish(
            to_record(event),
            stream_name: stream_name(auction.id),
            expected_version: expected_version + index
          )
        end
        project(auction)
        auction.changes.clear
      end
    end

    private

    attr_reader :event_store

    def stream_name(id)
      "Auction$#{id}"
    end

    def to_record(event)
      case event
      when AuctionOpened
        AuctionOpenedEvent.new(
          data: {
            auction_id: event.auction_id,
            seller_id: event.seller_id,
            title: event.title,
            starting_price_cents: event.starting_price_cents,
            ends_at: event.ends_at.iso8601(6)
          }
        )
      when BidAccepted
        BidAcceptedEvent.new(
          data: {
            auction_id: event.auction_id,
            bidder_id: event.bidder_id,
            amount_cents: event.amount_cents
          }
        )
      else
        raise ArgumentError, "evento desconhecido"
      end
    end

    def from_record(record)
      data = record.data
      case record
      when AuctionOpenedEvent
        AuctionOpened.new(
          auction_id: data.fetch(:auction_id),
          seller_id: data.fetch(:seller_id),
          title: data.fetch(:title),
          starting_price_cents: data.fetch(:starting_price_cents),
          ends_at: Time.iso8601(data.fetch(:ends_at))
        )
      when BidAcceptedEvent
        BidAccepted.new(
          auction_id: data.fetch(:auction_id),
          bidder_id: data.fetch(:bidder_id),
          amount_cents: data.fetch(:amount_cents)
        )
      else
        raise ArgumentError, "evento desconhecido"
      end
    end

    def project(auction)
      listing = ListingRecord.find_or_initialize_by(id: auction.id)
      listing.seller_id = auction.seller_id
      listing.title = auction.title
      listing.ends_at = auction.ends_at
      listing.current_price_cents = auction.current_price_cents
      listing.open = true
      listing.save!
    end
  end
end
