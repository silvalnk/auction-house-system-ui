# frozen_string_literal: true

require "test_helper"

class AuctionFlowTest < ActiveSupport::TestCase
  include ActionCable::TestHelper

  setup do
    @seller = Participant.create!(name: "Vendedor", role: "seller")
    @ana = Participant.create!(name: "Ana", role: "bidder")
    @bruno = Participant.create!(name: "Bruno", role: "bidder")
  end

  test "event store appends and reads a probe event" do
    event = Auctions::AuctionOpenedEvent.new(data: { probe: true })
    store = Rails.configuration.event_store
    store.publish(event, stream_name: "probe-#{event.event_id}", expected_version: :none)
    read = store.read.stream("probe-#{event.event_id}").to_a

    assert_equal [event.event_id], read.map(&:event_id)
  end

  test "publishing an auction shows the starting price" do
    created = Auctions.create_auction(
      seller_id: @seller.id,
      title: "Relógio",
      starting_price_cents: 1000,
      ends_at: 2.days.from_now
    )

    assert created.success?
    listing = Auctions.find_listing(created.value![:id])
    assert_equal 1000, listing[:current_price_cents]
    assert listing[:open]
    assert_equal "Relógio", listing[:title]
  end

  test "rejected bid does not broadcast an acceptance" do
    auction_id = publish_auction

    assert_no_broadcasts("auction_#{auction_id}") do
      result = Auctions.place_bid(auction_id:, bidder_id: @ana.id, amount_cents: 1000)
      assert result.failure?
    end
    assert_equal 1000, Auctions.find_listing(auction_id)[:current_price_cents]
  end

  test "accepted bid is broadcast after it is stored" do
    auction_id = publish_auction

    assert_broadcasts("auction_#{auction_id}", 1) do
      result = Auctions.place_bid(auction_id:, bidder_id: @ana.id, amount_cents: 1500)
      assert result.success?
      assert_equal 1500, result.value![:current_price_cents]
    end
    assert_equal 1500, Auctions.find_listing(auction_id)[:current_price_cents]
  end

  test "publication, accepted bid, rejected bid and a race keep one confirmed price" do
    auction_id = publish_auction
    accepted = Auctions.place_bid(auction_id:, bidder_id: @ana.id, amount_cents: 1500)
    rejected = Auctions.place_bid(auction_id:, bidder_id: @bruno.id, amount_cents: 1200)

    assert accepted.success?
    assert rejected.failure?
    assert_equal :bid_too_low, rejected.failure
    events = Rails.configuration.event_store.read.stream("Auction$#{auction_id}").to_a
    assert_equal 1, events.count { |event| event.is_a?(Auctions::BidAcceptedEvent) }
    assert_equal 1500, Auctions.find_listing(auction_id)[:current_price_cents]
  end

  private

  def publish_auction
    Auctions.create_auction(
      seller_id: @seller.id,
      title: "Relógio",
      starting_price_cents: 1000,
      ends_at: 2.days.from_now
    ).value![:id]
  end
end
