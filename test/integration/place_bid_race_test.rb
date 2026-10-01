# frozen_string_literal: true

require "test_helper"

class PlaceBidRaceTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  setup do
    @seller = Participant.create!(name: "Vendedor da corrida", role: "seller")
    @ana = Participant.create!(name: "Ana da corrida", role: "bidder")
    @bruno = Participant.create!(name: "Bruno da corrida", role: "bidder")
  end

  teardown do
    Auctions::ListingRecord.delete_all
    connection = ActiveRecord::Base.connection
    connection.execute("DELETE FROM event_store_events_in_streams")
    connection.execute("DELETE FROM event_store_events")
    Participant.delete_all
  end

  test "two bids on the same price leave a single accepted event" do
    auction_id = Auctions.create_auction(
      seller_id: @seller.id,
      title: "Corrida",
      starting_price_cents: 1000,
      ends_at: 2.days.from_now
    ).value![:id]

    barrier = Queue.new
    results = Queue.new
    threads = [@ana, @bruno].map do |bidder|
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          barrier.pop
          results << Auctions.place_bid(auction_id:, bidder_id: bidder.id, amount_cents: 1600)
        end
      end
    end
    2.times { barrier << true }
    threads.each(&:join)

    outcomes = 2.times.map { results.pop }
    assert_equal 1, outcomes.count(&:success?)
    events = Rails.configuration.event_store.read.stream("Auction$#{auction_id}").to_a
    assert_equal 1, events.count { |event| event.is_a?(Auctions::BidAcceptedEvent) }
    assert_equal 1600, Auctions.find_listing(auction_id)[:current_price_cents]
  end
end
